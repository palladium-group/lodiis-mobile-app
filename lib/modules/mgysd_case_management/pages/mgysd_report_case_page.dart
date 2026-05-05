import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:provider/provider.dart';

/// MGYSD Stage 1: Reporting (Event Program) — SAVES OFFLINE
///
/// ✅ Saves to offline_db (events + event_data_values) using FormUtil.savingEvent()
/// ✅ Uses dropdown option CODES (DHIS2 OptionSet-safe)
/// ✅ Compact phone layout (2 columns where possible)
///
/// You said you will replace IDs manually:
/// - program UID
/// - programStage UID
/// - dataElement UIDs
/// - option codes/labels
///
/// Put this file e.g.
/// lib/modules/mgysd_case_management/pages/mgysd_record_case_page.dart
class MgysdRecordCasePage extends StatefulWidget {
  const MgysdRecordCasePage({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  State<MgysdRecordCasePage> createState() => _MgysdRecordCasePageState();
}

enum MgysdFieldType {
  option,
  boolean,
  trueOnly,
  date,
  integer,
  number,
  phone,
  textShort,
}

class MgysdOption {
  final String code;
  final String label;

  const MgysdOption({required this.code, required this.label});
}

class MgysdFormFieldDef {
  final String id; // dataElement UID placeholder
  final String label;
  final MgysdFieldType type;
  final bool requiredField;
  final List<MgysdOption> options;
  final int? maxLen;

  const MgysdFormFieldDef({
    required this.id,
    required this.label,
    required this.type,
    this.requiredField = false,
    this.options = const [],
    this.maxLen,
  });
}

class _MgysdRecordCasePageState extends State<MgysdRecordCasePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _values = {};
  bool _submitting = false;

  // ✅ Replace these with real DHIS2 IDs when ready
  static const String mgysdReportProgram = 'MGYSD_REPORT_EVENT_PROGRAM_UID';
  static const String mgysdReportProgramStage = 'MGYSD_REPORT_STAGE_UID';

  // --- placeholders you already use ---
  static const String deReporterRelationship = 'vXKcqU7V0xQ';
  static const String deReporterRelationshipOther = 'wIAHzLOccWk';
  static const String deReporterAnonymous = 'DE_REP_ANONYMOUS';
  static const String deWhenHappened = 'DE_WHEN_HAPPENED';

  // -----------------------
  // FIELD DEFINITIONS
  // -----------------------
  List<MgysdFormFieldDef> get aboutYouFields => const [
    MgysdFormFieldDef(
      id: 'RWEFHH4pm27',
      label: 'Reporter First name',
      type: MgysdFieldType.textShort,
      maxLen: 20,
    ),
    MgysdFormFieldDef(
      id: 'dwSkq33g4Uu',
      label: 'Reporter Last name',
      type: MgysdFieldType.textShort,
      maxLen: 20,
    ),
    MgysdFormFieldDef(
      id: 'NCb5dNKnqOG',
      label: 'Reporter Village',
      type: MgysdFieldType.textShort,
      maxLen: 20,
    ),
    MgysdFormFieldDef(
      id: 'Zjah90FdrwV',
      label: 'Chief First name',
      type: MgysdFieldType.textShort,
      maxLen: 20,
    ),
    MgysdFormFieldDef(
      id: 'vmVxUbkVmXN',
      label: 'Chief Last name',
      type: MgysdFieldType.textShort,
      maxLen: 20,
    ),
    MgysdFormFieldDef(
      id: 'hKEJvGcXWND',
      label: 'Reporter phone',
      type: MgysdFieldType.phone,
      requiredField: true,
    ),
    MgysdFormFieldDef(
      id: 'pgklc5q0r9A',
      label: 'Alternate phone',
      type: MgysdFieldType.phone,
    ),
    MgysdFormFieldDef(
      id: deReporterRelationship,
      label: 'Relationship to client',
      type: MgysdFieldType.option,
      requiredField: true,
      options: [
        MgysdOption(code: 'PARENT', label: 'Parent'),
        MgysdOption(code: 'RELATIVE', label: 'Relative'),
        MgysdOption(code: 'NEIGHBOUR', label: 'Neighbour'),
        MgysdOption(code: 'TEACHER', label: 'Teacher'),
        MgysdOption(code: 'PRIEST', label: 'Priest'),
        MgysdOption(code: 'OTHER', label: 'Other'),
      ],
    ),
    MgysdFormFieldDef(
      id: deReporterRelationshipOther,
      label: 'Relationship (other)',
      type: MgysdFieldType.textShort,
      maxLen: 20,
    ),
    MgysdFormFieldDef(
      id: deReporterAnonymous,
      label: 'Reporter wants to remain anonymous',
      type: MgysdFieldType.boolean,
      requiredField: true,
    ),
  ];

  List<MgysdFormFieldDef> get aboutClientFields => const [
    MgysdFormFieldDef(
      id: 'wOIx1Tism5p',
      label: 'Client First name',
      type: MgysdFieldType.textShort,
      maxLen: 20,
      requiredField: true,
    ),
    MgysdFormFieldDef(
      id: 'mclj3oLRpiv',
      label: 'Client Last name',
      type: MgysdFieldType.textShort,
      maxLen: 20,
      requiredField: true,
    ),
    MgysdFormFieldDef(
      id: 'kwL1QEdrChg',
      label: 'Client Sex',
      type: MgysdFieldType.option,
      requiredField: true,
      options: [
        MgysdOption(code: 'MALE', label: 'Male'),
        MgysdOption(code: 'FEMALE', label: 'Female'),
      ],
    ),
    MgysdFormFieldDef(
      id: 'DE_CLIENT_LOCATION',
      label: 'Client District',
      type: MgysdFieldType.option,
      requiredField: true,
      options: [
        MgysdOption(code: 'MASERU', label: 'Maseru'),
        MgysdOption(code: 'LERIBE', label: 'Leribe'),
        MgysdOption(code: 'BEREA', label: 'Berea'),
        MgysdOption(code: 'MAFETENG', label: 'Mafeteng'),
        MgysdOption(code: 'MOHALES_HOEK', label: 'Mohale’s Hoek'),
        MgysdOption(code: 'QUTHING', label: 'Quthing'),
        MgysdOption(code: 'QACHAS_NEK', label: 'Qacha’s Nek'),
        MgysdOption(code: 'THABA_TSEKA', label: 'Thaba-Tseka'),
        MgysdOption(code: 'BUTHABUTHE', label: 'Butha-Buthe'),
        MgysdOption(code: 'MOKHOTLONG', label: 'Mokhotlong'),
      ],
    ),
    MgysdFormFieldDef(
      id: 'hxxH8RmZrV2',
      label: 'Client phone',
      type: MgysdFieldType.phone,
    ),
  ];

  List<MgysdFormFieldDef> get concernFields => const [
    MgysdFormFieldDef(
      id: 'UJIrqEgPMn1',
      label: 'Concern reason',
      type: MgysdFieldType.option,
      requiredField: true,
      options: [
        MgysdOption(code: 'PHYSICAL', label: 'Physical violence'),
        MgysdOption(code: 'SEXUAL', label: 'Sexual violence'),
        MgysdOption(code: 'SOCIO_ECON', label: 'Low socio-economic status'),
        MgysdOption(
          code: 'ISSN_NISSA',
          label: 'Exclusion/inclusion error (ISSN/NISSA)',
        ),
        MgysdOption(code: 'WORK_EXP', label: 'Work exploitation'),
        MgysdOption(code: 'EMOTIONAL', label: 'Emotional violence'),
        MgysdOption(code: 'CHILD_MARRIAGE', label: 'Child marriage'),
        MgysdOption(code: 'FINANCIAL', label: 'Financial exploitation'),
        MgysdOption(code: 'SPECIAL_NEEDS', label: 'Special needs'),
        MgysdOption(code: 'GRIEVANCE', label: 'Grievance'),
      ],
    ),
    MgysdFormFieldDef(
      id: 'DE_CASE_TYPE',
      label: 'Type of concern',
      type: MgysdFieldType.option,
      requiredField: true,
      options: [
        MgysdOption(code: 'CHILD_PROTECTION', label: 'Child protection'),
        MgysdOption(code: 'GBV', label: 'Gender-based violence'),
        MgysdOption(code: 'NEGLECT', label: 'Neglect'),
        MgysdOption(code: 'ABUSE_PHYSICAL', label: 'Physical abuse'),
        MgysdOption(code: 'ABUSE_SEXUAL', label: 'Sexual abuse'),
        MgysdOption(code: 'TRAFFICKING', label: 'Trafficking'),
        MgysdOption(code: 'OTHER', label: 'Other'),
      ],
    ),
    MgysdFormFieldDef(
      id: 'DE_URGENT_RISK',
      label: 'Immediate danger / urgent risk',
      type: MgysdFieldType.boolean,
      requiredField: true,
    ),
    MgysdFormFieldDef(
      id: deWhenHappened,
      label: 'Date incident happened',
      type: MgysdFieldType.date,
      requiredField: false,
    ),
  ];

  // -----------------------
  // DEFAULTS + VISIBILITY
  // -----------------------
  @override
  void initState() {
    super.initState();
    for (final f in [...aboutYouFields, ...aboutClientFields, ...concernFields]) {
      _values.putIfAbsent(f.id, () {
        if (f.type == MgysdFieldType.boolean) return 'false';
        return '';
      });
    }
  }

  bool get _isAnonymous => (_values[deReporterAnonymous] ?? 'false') == 'true';
  bool get _relationshipIsOther =>
      (_values[deReporterRelationship] ?? '') == 'OTHER';

  List<MgysdFormFieldDef> get _visibleAboutYouFields {
    if (!_isAnonymous) return aboutYouFields;
    return aboutYouFields.where((f) {
      return f.id == deReporterRelationship ||
          f.id == deReporterRelationshipOther ||
          f.id == deReporterAnonymous;
    }).toList();
  }

  bool _shouldShowRelationshipOther(MgysdFormFieldDef f) {
    if (f.id != deReporterRelationshipOther) return true;
    return _relationshipIsOther;
  }

  // -----------------------
  // LOOK & FEEL (LOD IIS STYLE)
  // -----------------------
  Color get _softBg => const Color(0xFFF6F7FB);

  InputDecoration _decoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      isDense: true,
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: widget.color, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  double _contentMaxWidth(double screenWidth) {
    if (screenWidth >= 1100) return 880;
    if (screenWidth >= 800) return 720;
    return screenWidth;
  }

  bool _phoneTwoCols(double width) => width >= 380;

  // -----------------------
  // VALIDATORS
  // -----------------------
  String? _requiredValidator(String? v, {required bool requiredField}) {
    if (!requiredField) return null;
    if ((v ?? '').trim().isEmpty) return 'Required';
    return null;
  }

  String? _phoneValidator(String? v, {required bool requiredField}) {
    final value = (v ?? '').trim();
    if (!requiredField && value.isEmpty) return null;
    if (value.isEmpty) return 'Required';
    final digits = value.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.length < 8) return 'Enter a valid phone number';
    return null;
  }

  // -----------------------
  // DATE PICKER
  // -----------------------
  Future<void> _pickDate(String fieldId) async {
    FocusScope.of(context).unfocus();

    DateTime initial = DateTime.now();
    final existing = (_values[fieldId] ?? '').trim();
    final parts = existing.split('-');
    if (parts.length == 3) {
      final y = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final d = int.tryParse(parts[2]);
      if (y != null && m != null && d != null) initial = DateTime(y, m, d);
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select date',
    );

    if (picked == null) return;

    final y = picked.year.toString().padLeft(4, '0');
    final m = picked.month.toString().padLeft(2, '0');
    final d = picked.day.toString().padLeft(2, '0');

    setState(() => _values[fieldId] = '$y-$m-$d');
  }

  // -----------------------
  // FIELD BUILDER
  // -----------------------
  Widget _buildField(MgysdFormFieldDef f) {
    switch (f.type) {
      case MgysdFieldType.option:
        return DropdownButtonFormField<String>(
          value: (_values[f.id] ?? '').isEmpty ? null : _values[f.id],
          isExpanded: true,
          items: f.options
              .map((o) => DropdownMenuItem<String>(
            value: o.code, // ✅ store option CODE
            child: Text(o.label, overflow: TextOverflow.ellipsis),
          ))
              .toList(),
          onChanged: (v) => setState(() {
            _values[f.id] = v ?? '';

            // clear relationship-other when not OTHER
            if (f.id == deReporterRelationship && (v ?? '') != 'OTHER') {
              _values[deReporterRelationshipOther] = '';
            }
          }),
          validator: (v) =>
              _requiredValidator(v, requiredField: f.requiredField),
          decoration: _decoration(f.label),
        );

      case MgysdFieldType.boolean:
        final current = (_values[f.id] ?? 'false') == 'true';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.blueGrey.withOpacity(0.25)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(f.label, style: const TextStyle(fontSize: 13.5)),
              ),
              Text(
                current ? 'Yes' : 'No',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: widget.color,
                ),
              ),
              const SizedBox(width: 6),
              Switch(
                value: current,
                activeColor: widget.color,
                onChanged: (val) => setState(() {
                  _values[f.id] = val ? 'true' : 'false';

                  // anonymous => clear personal fields
                  if (f.id == deReporterAnonymous && val == true) {
                    for (final ff in aboutYouFields) {
                      final keep = ff.id == deReporterAnonymous ||
                          ff.id == deReporterRelationship ||
                          ff.id == deReporterRelationshipOther;
                      if (!keep) _values[ff.id] = '';
                    }
                  }
                }),
              ),
            ],
          ),
        );

      case MgysdFieldType.date:
        final value = (_values[f.id] ?? '').trim();
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _pickDate(f.id),
          child: IgnorePointer(
            child: TextFormField(
              initialValue: value,
              decoration: _decoration(f.label, icon: Icons.calendar_month)
                  .copyWith(hintText: 'yyyy-mm-dd'),
              validator: (v) =>
                  _requiredValidator(v, requiredField: f.requiredField),
            ),
          ),
        );

      case MgysdFieldType.phone:
        return TextFormField(
          initialValue: (_values[f.id] ?? '').trim(),
          decoration: _decoration(f.label, icon: Icons.phone),
          keyboardType: TextInputType.phone,
          onChanged: (v) => _values[f.id] = v.trim(),
          validator: (v) => _phoneValidator(v, requiredField: f.requiredField),
        );

      case MgysdFieldType.textShort:
        return TextFormField(
          initialValue: (_values[f.id] ?? '').trim(),
          decoration: _decoration(f.label),
          maxLength: f.maxLen,
          buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) {
            return null; // remove counter line
          },
          onChanged: (v) => _values[f.id] = v.trim(),
          validator: (v) =>
              _requiredValidator(v, requiredField: f.requiredField),
        );

      default:
        return TextFormField(
          initialValue: (_values[f.id] ?? '').trim(),
          decoration: _decoration(f.label),
          onChanged: (v) => _values[f.id] = v.trim(),
          validator: (v) =>
              _requiredValidator(v, requiredField: f.requiredField),
        );
    }
  }

  // -----------------------
  // COMPACT ROW BUILDERS
  // -----------------------
  Widget _row2(MgysdFormFieldDef a, MgysdFormFieldDef b) {
    return Row(
      children: [
        Expanded(child: _buildField(a)),
        const SizedBox(width: 10),
        Expanded(child: _buildField(b)),
      ],
    );
  }

  List<Widget> _buildCompactSection({
    required List<MgysdFormFieldDef> fields,
    required double availableWidth,
  }) {
    final bool twoCols = _phoneTwoCols(availableWidth);
    final visible = fields.where(_shouldShowRelationshipOther).toList();

    MgysdFormFieldDef? byId(String id) {
      for (final f in visible) {
        if (f.id == id) return f;
      }
      return null;
    }

    final List<Widget> widgets = [];
    final Set<String> used = {};

    void addField(MgysdFormFieldDef f) {
      used.add(f.id);
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _buildField(f),
      ));
    }

    void addRow(MgysdFormFieldDef f1, MgysdFormFieldDef f2) {
      used.add(f1.id);
      used.add(f2.id);
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _row2(f1, f2),
      ));
    }

    if (twoCols) {
      final rfn = byId('RWEFHH4pm27');
      final rln = byId('dwSkq33g4Uu');
      if (rfn != null && rln != null) addRow(rfn, rln);

      final cfn = byId('Zjah90FdrwV');
      final cln = byId('vmVxUbkVmXN');
      if (cfn != null && cln != null) addRow(cfn, cln);

      final p1 = byId('hKEJvGcXWND');
      final p2 = byId('pgklc5q0r9A');
      if (p1 != null && p2 != null) addRow(p1, p2);

      final c1 = byId('wOIx1Tism5p');
      final c2 = byId('mclj3oLRpiv');
      if (c1 != null && c2 != null) addRow(c1, c2);

      final sex = byId('kwL1QEdrChg');
      final dist = byId('DE_CLIENT_LOCATION');
      if (sex != null && dist != null) addRow(sex, dist);
    }

    for (final f in visible) {
      if (!used.contains(f.id)) addField(f);
    }

    return widgets;
  }

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<MgysdFormFieldDef> fields,
    required double availableWidth,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        border: Border.all(color: Colors.blueGrey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: widget.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._buildCompactSection(fields: fields, availableWidth: availableWidth),
        ],
      ),
    );
  }

  // -----------------------
  // OFFLINE SAVE
  // -----------------------

  Future<void> _onSubmit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      final currentUserState = Provider.of<CurrentUserState>(context, listen: false);

      final String orgUnit =
      (currentUserState.currentUser?.userOrgUnitIds ?? []).isNotEmpty
          ? (currentUserState.currentUser!.userOrgUnitIds!.first ?? '')
          : '';

      if (orgUnit.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No orgUnit found for current user.')),
        );
        return;
      }

      final inputFieldIds = <String>[
        ...aboutYouFields.map((e) => e.id),
        ...aboutClientFields.map((e) => e.id),
        ...concernFields.map((e) => e.id),
      ].where((id) => id.trim().isNotEmpty).toList();

      final eventDate = (_values[deWhenHappened] ?? '').trim().isNotEmpty
          ? _values[deWhenHappened]!.trim()
          : AppUtil.formattedDateTimeIntoString(DateTime.now());

      // Build event payload (should include dataValues in most LODIIS patterns)
      final Events event = FormUtil.getEventPayload(
        null, // generate uid
        mgysdReportProgram,
        mgysdReportProgramStage,
        orgUnit,
        inputFieldIds,
        _values,
        eventDate,
        null, // TEI null for event-program
      );

      // ✅ Safety: if your getEventPayload doesn't attach dataValues, attach them here
      event.dataValues ??= inputFieldIds
          .map((de) {
        final v = (_values[de] ?? '').trim();
        if (v.isEmpty) return null;
        return {'dataElement': de, 'value': v};
      })
          .whereType<Map<String, dynamic>>()
          .toList();

      // ✅ Save offline (your actual signature)
      await FormUtil.savingEvent(event);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report saved offline. Ref: ${event.event}')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save offline: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }


  // -----------------------
  // BUILD
  // -----------------------
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final maxWidth = _contentMaxWidth(screenWidth);
        final availableWidth = maxWidth == screenWidth ? screenWidth : maxWidth;

        return Scaffold(
          backgroundColor: _softBg,
          appBar: AppBar(
            backgroundColor: widget.color,
            elevation: 0,
            title: const Text('Report a Case'),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.color.withOpacity(0.14),
                              Colors.white,
                            ],
                          ),
                          border: Border.all(
                            color: widget.color.withOpacity(0.18),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: widget.color),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Stage 1: Reporting (Event).\nSaved offline first, then sync to DHIS2 later.\n(Uses option codes for optionSets)',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _sectionCard(
                        title: 'About the Reporter',
                        subtitle: 'Who is reporting this case?',
                        icon: Icons.person_outline,
                        fields: _visibleAboutYouFields,
                        availableWidth: availableWidth,
                      ),
                      const SizedBox(height: 12),
                      _sectionCard(
                        title: 'About the Client',
                        subtitle: 'Who is the case about?',
                        icon: Icons.badge_outlined,
                        fields: aboutClientFields,
                        availableWidth: availableWidth,
                      ),
                      const SizedBox(height: 12),
                      _sectionCard(
                        title: 'Why are you concerned?',
                        subtitle: 'Select the concern details',
                        icon: Icons.report_outlined,
                        fields: concernFields,
                        availableWidth: availableWidth,
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.color,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _submitting ? null : _onSubmit,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_submitting)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              const Icon(Icons.save_outlined),
                            const SizedBox(width: 10),
                            Text(_submitting ? 'Saving...' : 'Save report offline'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
