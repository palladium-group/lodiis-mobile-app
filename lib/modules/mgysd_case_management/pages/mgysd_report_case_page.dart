import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:provider/provider.dart';

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
  date,
  integer,
  phone,
  textShort,
  textLong,
}

class MgysdOption {
  final String code;
  final String label;

  const MgysdOption({
    required this.code,
    required this.label,
  });
}

class MgysdFormFieldDef {
  final String id;
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

class MgysdClientEntry {
  final String localId;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController ageController;
  final TextEditingController estimatedDobController;
  final TextEditingController phoneController;
  final TextEditingController districtController;
  final TextEditingController contactOtherController;

  String sex;
  String contactMethod;

  MgysdClientEntry({
    required this.localId,
    String firstName = '',
    String lastName = '',
    String age = '',
    String estimatedDob = '',
    String phone = '',
    String district = '',
    String contactOther = '',
    this.sex = '',
    this.contactMethod = '',
  })  : firstNameController = TextEditingController(text: firstName),
        lastNameController = TextEditingController(text: lastName),
        ageController = TextEditingController(text: age),
        estimatedDobController = TextEditingController(text: estimatedDob),
        phoneController = TextEditingController(text: phone),
        districtController = TextEditingController(text: district),
        contactOtherController = TextEditingController(text: contactOther);

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    estimatedDobController.dispose();
    phoneController.dispose();
    districtController.dispose();
    contactOtherController.dispose();
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'age': ageController.text.trim(),
      'estimatedDateOfBirth': estimatedDobController.text.trim(),
      'sex': sex,
      'phone': phoneController.text.trim(),
      'district': districtController.text.trim(),
      'howToContactClient': contactMethod,
      'contactOtherSpecify': contactOtherController.text.trim(),
    };
  }
}

class MgysdPersonInvolvedEntry {
  final String localId;
  final TextEditingController nameController;
  final TextEditingController roleController;

  MgysdPersonInvolvedEntry({
    required this.localId,
    String name = '',
    String role = '',
  })  : nameController = TextEditingController(text: name),
        roleController = TextEditingController(text: role);

  void dispose() {
    nameController.dispose();
    roleController.dispose();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': nameController.text.trim(),
      'roleOrRelationship': roleController.text.trim(),
    };
  }
}

class _MgysdRecordCasePageState extends State<MgysdRecordCasePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _values = {};
  bool _submitting = false;

  static const String mgysdReportProgram = 'MGYSD_REPORT_EVENT_PROGRAM_UID';
  static const String mgysdReportProgramStage = 'MGYSD_REPORT_STAGE_UID';

  static const String deReporterFirstName = 'RWEFHH4pm27';
  static const String deReporterLastName = 'dwSkq33g4Uu';
  static const String deReporterVillage = 'NCb5dNKnqOG';
  static const String deChiefFirstName = 'Zjah90FdrwV';
  static const String deChiefLastName = 'vmVxUbkVmXN';
  static const String deReporterPhone = 'hKEJvGcXWND';
  static const String deReporterAltPhone = 'pgklc5q0r9A';
  static const String deReporterRelationship = 'vXKcqU7V0xQ';
  static const String deReporterRelationshipOther = 'wIAHzLOccWk';
  static const String deReporterAnonymous = 'DE_REP_ANONYMOUS';

  static const String deReporterPhysicalAddress =
      'DE_REPORTER_PHYSICAL_ADDRESS';
  static const String deReporterDob = 'DE_REPORTER_DOB';
  static const String deReporterAge = 'DE_REPORTER_AGE';
  static const String deReporterSex = 'DE_REPORTER_SEX';
  static const String deReporterOccupation = 'DE_REPORTER_OCCUPATION';

  static const String deClientsJson = 'DE_CLIENTS_JSON';
  static const String dePeopleInvolvedJson = 'DE_PEOPLE_INVOLVED_JSON';

  // Concern-related data elements
  static const String deConcernReason = 'UJIrqEgPMn1';
  static const String deConcernReasonOther = 'UJIrqEgPMn1_OTHER';
  static const String deIncidentDescription = 'DE_INCIDENT_DESCRIPTION';
  static const String deWhenHappened = 'DE_WHEN_HAPPENED';
  static const String deIncidentLocation = 'DE_INCIDENT_LOCATION';

  final List<MgysdClientEntry> _clients = [];
  final List<MgysdPersonInvolvedEntry> _peopleInvolved = [];

  final Set<String> _selectedConcernReasons = {};
  final TextEditingController _concernOtherController = TextEditingController();

  List<MgysdFormFieldDef> get aboutReporterFields => const [
    MgysdFormFieldDef(
      id: deReporterAnonymous,
      label: 'Reporter wants to remain anonymous',
      type: MgysdFieldType.boolean,
      requiredField: true,
    ),
    MgysdFormFieldDef(
      id: deReporterFirstName,
      label: 'Reporter First name',
      type: MgysdFieldType.textShort,
      maxLen: 40,
    ),
    MgysdFormFieldDef(
      id: deReporterLastName,
      label: 'Reporter Last name',
      type: MgysdFieldType.textShort,
      maxLen: 40,
    ),
    MgysdFormFieldDef(
      id: deReporterDob,
      label: 'Date of Birth',
      type: MgysdFieldType.date,
    ),
    MgysdFormFieldDef(
      id: deReporterAge,
      label: 'Age',
      type: MgysdFieldType.integer,
    ),
    MgysdFormFieldDef(
      id: deReporterSex,
      label: 'Sex',
      type: MgysdFieldType.option,
      options: [
        MgysdOption(code: 'MALE', label: 'Male'),
        MgysdOption(code: 'FEMALE', label: 'Female'),
      ],
    ),
    MgysdFormFieldDef(
      id: deReporterOccupation,
      label: 'Occupation',
      type: MgysdFieldType.textShort,
      maxLen: 80,
    ),
    MgysdFormFieldDef(
      id: deReporterVillage,
      label: 'Reporter Village',
      type: MgysdFieldType.textShort,
      maxLen: 80,
    ),
    MgysdFormFieldDef(
      id: deReporterPhysicalAddress,
      label: 'Physical Address',
      type: MgysdFieldType.textLong,
    ),
    MgysdFormFieldDef(
      id: deChiefFirstName,
      label: 'Chief First name',
      type: MgysdFieldType.textShort,
      maxLen: 40,
    ),
    MgysdFormFieldDef(
      id: deChiefLastName,
      label: 'Chief Last name',
      type: MgysdFieldType.textShort,
      maxLen: 40,
    ),
    MgysdFormFieldDef(
      id: deReporterPhone,
      label: 'Reporter phone',
      type: MgysdFieldType.phone,
      requiredField: true,
    ),
    MgysdFormFieldDef(
      id: deReporterAltPhone,
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
      maxLen: 80,
    ),
  ];


  List<MgysdFormFieldDef> get concernFields => const [
    MgysdFormFieldDef(
      id: deWhenHappened,
      label: 'Date incident happened',
      type: MgysdFieldType.date,
    ),
    MgysdFormFieldDef(
      id: deIncidentLocation,
      label: 'Location of incident',
      type: MgysdFieldType.textShort,
      maxLen: 120,
    ),
    MgysdFormFieldDef(
      id: deConcernReason,
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
        MgysdOption(code: 'MENTAL_HEALTH', label: 'Mental Health'),
        MgysdOption(code: 'HEALTH', label: 'Health'),
        MgysdOption(code: 'SUBSTANCE', label: 'Substance abuse'),
        MgysdOption(code: 'SAFETY_SECURITY', label: 'Safety and Security'),
        MgysdOption(code: 'OTHER', label: 'Other'),
      ],
    ),
    MgysdFormFieldDef(
      id: deIncidentDescription,
      label: 'Describe the incident that has made you concerned',
      type: MgysdFieldType.textLong,
      requiredField: true,
    ),
  ];

  static const List<MgysdOption> _sexOptions = [
    MgysdOption(code: 'MALE', label: 'Male'),
    MgysdOption(code: 'FEMALE', label: 'Female'),
  ];

  static const List<MgysdOption> _contactMethodOptions = [
    MgysdOption(code: 'SCHOOL', label: 'School'),
    MgysdOption(code: 'HOME', label: 'Home'),
    MgysdOption(code: 'OTHER', label: 'Other'),
  ];

  @override
  void initState() {
    super.initState();

    for (final f in [...aboutReporterFields, ...concernFields]) {
      _values.putIfAbsent(f.id, () {
        if (f.type == MgysdFieldType.boolean) return 'false';
        return '';
      });
    }

    // initialize selected concerns from saved value if present
    final saved = (_values[deConcernReason] ?? '').trim();
    if (saved.isNotEmpty) {
      _selectedConcernReasons.addAll(
        saved.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty),
      );
    }

    // initialize other description if present
    final otherSaved = (_values[deConcernReasonOther] ?? '').trim();
    if (otherSaved.isNotEmpty) {
      _concernOtherController.text = otherSaved;
    }

    _addClient();
    _addPersonInvolved();
  }

  @override
  void dispose() {
    for (final client in _clients) {
      client.dispose();
    }
    for (final person in _peopleInvolved) {
      person.dispose();
    }
    _concernOtherController.dispose();
    super.dispose();
  }

  bool get _relationshipIsOther =>
      (_values[deReporterRelationship] ?? '') == 'OTHER';

  Color get _softBg => const Color(0xFFF6F7FB);

  InputDecoration _decoration(String label, {IconData? icon, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
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
    if (screenWidth >= 1100) return 900;
    if (screenWidth >= 800) return 740;
    return screenWidth;
  }

  bool _twoCols(double width) => width >= 420;

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

  int? _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    final hadBirthdayThisYear =
        today.month > dob.month || (today.month == dob.month && today.day >= dob.day);
    if (!hadBirthdayThisYear) age--;
    return age < 0 ? null : age;
  }

  String _estimateDobFromAge(String ageText) {
    final age = int.tryParse(ageText.trim());
    if (age == null || age < 0 || age > 130) return '';
    final now = DateTime.now();
    final estimated = DateTime(now.year - age, 7, 1);
    return _formatDate(estimated);
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  DateTime? _parseDate(String value) {
    final parts = value.trim().split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  Future<void> _pickDate(String fieldId) async {
    FocusScope.of(context).unfocus();

    DateTime initial = DateTime.now();
    final existing = (_values[fieldId] ?? '').trim();
    final parsed = _parseDate(existing);
    if (parsed != null) initial = parsed;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select date',
    );

    if (picked == null) return;

    setState(() {
      _values[fieldId] = _formatDate(picked);

      if (fieldId == deReporterDob) {
        final age = _calculateAge(picked);
        _values[deReporterAge] = age?.toString() ?? '';
      }
    });
  }

  void _addClient() {
    setState(() {
      _clients.add(
        MgysdClientEntry(
          localId: DateTime.now().microsecondsSinceEpoch.toString(),
        ),
      );
    });
  }

  void _removeClient(int index) {
    if (_clients.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one client is required.')),
      );
      return;
    }

    setState(() {
      final removed = _clients.removeAt(index);
      removed.dispose();
    });
  }

  void _addPersonInvolved() {
    setState(() {
      _peopleInvolved.add(
        MgysdPersonInvolvedEntry(
          localId: DateTime.now().microsecondsSinceEpoch.toString(),
        ),
      );
    });
  }

  void _removePersonInvolved(int index) {
    setState(() {
      final removed = _peopleInvolved.removeAt(index);
      removed.dispose();
    });
  }

  bool _shouldShowRelationshipOther(MgysdFormFieldDef f) {
    if (f.id != deReporterRelationshipOther) return true;
    return _relationshipIsOther;
  }

  Widget _buildField(MgysdFormFieldDef f) {
    switch (f.type) {
      case MgysdFieldType.option:
      // Special-case multi-select for Concern reason
        if (f.id == deConcernReason) {
          final selected = _selectedConcernReasons;

          // split options into two roughly equal lists, keeping OTHER last
          final options = f.options;
          final otherOption =
          options.isNotEmpty && options.last.code == 'OTHER' ? options.last : null;
          final coreOptions = otherOption != null ? options.sublist(0, options.length - 1) : options;
          final mid = (coreOptions.length / 2).ceil();
          final left = coreOptions.sublist(0, mid);
          final right = coreOptions.sublist(mid);
          if (otherOption != null) right.add(otherOption); // ensure OTHER is last in right column

          return FormField<Set<String>>(
            initialValue: selected,
            validator: (set) {
              // avoid calling contains on null
              if (f.requiredField && (set == null || set.isEmpty)) {
                return 'Required';
              }
              if (set != null && set.contains('OTHER') && _concernOtherController.text.trim().isEmpty) {
                return 'Required';
              }
              return null;
            },
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // label
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      f.label,
                      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // two-column layout
                  LayoutBuilder(builder: (context, constraints) {
                    final twoCols = constraints.maxWidth >= 420;
                    if (twoCols) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: left.map((o) {
                                final isSelected = selected.contains(o.code);
                                return CheckboxListTile(
                                  value: isSelected,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        selected.add(o.code);
                                      } else {
                                        selected.remove(o.code);
                                      }
                                      _values[f.id] = selected.join(',');
                                      state.didChange(selected);
                                    });
                                  },
                                  title: Text(o.label),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  dense: true,
                                  activeColor: widget.color,
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: right.map((o) {
                                final isSelected = selected.contains(o.code);
                                final isOther = o.code == 'OTHER';
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CheckboxListTile(
                                      value: isSelected,
                                      onChanged: (val) {
                                        setState(() {
                                          if (val == true) {
                                            selected.add(o.code);
                                          } else {
                                            selected.remove(o.code);
                                            if (isOther) {
                                              _concernOtherController.text = '';
                                              _values[deConcernReasonOther] = '';
                                            }
                                          }
                                          _values[f.id] = selected.join(',');
                                          state.didChange(selected);
                                        });
                                      },
                                      title: Text(o.label),
                                      controlAffinity: ListTileControlAffinity.leading,
                                      dense: true,
                                      activeColor: widget.color,
                                    ),
                                    if (isOther && isSelected)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                                        child: TextFormField(
                                          controller: _concernOtherController,
                                          decoration: InputDecoration(
                                            labelText: 'Please describe',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFF9FBFD),
                                          ),
                                          onChanged: (v) {
                                            _values[deConcernReasonOther] = v.trim();
                                          },
                                          validator: (v) {
                                            if (f.requiredField && selected.contains('OTHER')) {
                                              if ((v ?? '').trim().isEmpty) return 'Required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // single column for narrow screens: left then right stacked
                      final all = [...left, ...right];
                      return Column(
                        children: all.map((o) {
                          final isSelected = selected.contains(o.code);
                          final isOther = o.code == 'OTHER';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                value: isSelected,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      selected.add(o.code);
                                    } else {
                                      selected.remove(o.code);
                                      if (isOther) {
                                        _concernOtherController.text = '';
                                        _values[deConcernReasonOther] = '';
                                      }
                                    }
                                    _values[f.id] = selected.join(',');
                                    state.didChange(selected);
                                  });
                                },
                                title: Text(o.label),
                                controlAffinity: ListTileControlAffinity.leading,
                                dense: true,
                                activeColor: widget.color,
                              ),
                              if (isOther && isSelected)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                                  child: TextFormField(
                                    controller: _concernOtherController,
                                    decoration: InputDecoration(
                                      labelText: 'Please describe',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF9FBFD),
                                    ),
                                    onChanged: (v) {
                                      _values[deConcernReasonOther] = v.trim();
                                    },
                                    validator: (v) {
                                      if (f.requiredField && selected.contains('OTHER')) {
                                        if ((v ?? '').trim().isEmpty) return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  }),
                  // validation message
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        state.errorText ?? '',
                        style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                      ),
                    ),
                ],
              );
            },
          );
        }

        // Default single-select behavior for other option fields
        final rawValue = (_values[f.id] ?? '').trim();
        final safeValue = f.options.any((o) => o.code == rawValue) ? rawValue : null;

        return DropdownButtonFormField<String>(
          value: safeValue,
          isExpanded: true,
          items: f.options
              .map(
                (o) => DropdownMenuItem<String>(
              value: o.code,
              child: Text(o.label, overflow: TextOverflow.ellipsis),
            ),
          )
              .toList(),
          onChanged: (v) => setState(() {
            _values[f.id] = v ?? '';
            if (f.id == deReporterRelationship && (v ?? '') != 'OTHER') {
              _values[deReporterRelationshipOther] = '';
            }
          }),
          validator: (v) => _requiredValidator(v, requiredField: f.requiredField),
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
              key: ValueKey('${f.id}_$value'),
              initialValue: value,
              decoration: _decoration(
                f.label,
                icon: Icons.calendar_month,
                hint: 'yyyy-mm-dd',
              ),
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

      case MgysdFieldType.integer:
        return TextFormField(
          key: ValueKey('${f.id}_${_values[f.id] ?? ''}'),
          initialValue: (_values[f.id] ?? '').trim(),
          decoration: _decoration(f.label),
          keyboardType: TextInputType.number,
          readOnly: f.id == deReporterAge,
          onChanged: (v) => _values[f.id] = v.trim(),
          validator: (v) =>
              _requiredValidator(v, requiredField: f.requiredField),
        );

      case MgysdFieldType.textLong:
        return TextFormField(
          initialValue: (_values[f.id] ?? '').trim(),
          decoration: _decoration(f.label),
          maxLines: 4,
          onChanged: (v) => _values[f.id] = v.trim(),
          validator: (v) =>
              _requiredValidator(v, requiredField: f.requiredField),
        );

      case MgysdFieldType.textShort:
        return TextFormField(
          initialValue: (_values[f.id] ?? '').trim(),
          decoration: _decoration(f.label),
          maxLength: f.maxLen,
          buildCounter: (
              context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) {
            return null;
          },
          onChanged: (v) => _values[f.id] = v.trim(),
          validator: (v) =>
              _requiredValidator(v, requiredField: f.requiredField),
        );
    }
  }

  Widget _row2(Widget a, Widget b) {
    return Row(
      children: [
        Expanded(child: a),
        const SizedBox(width: 10),
        Expanded(child: b),
      ],
    );
  }

  List<Widget> _buildCompactFields({
    required List<MgysdFormFieldDef> fields,
    required double availableWidth,
  }) {
    final twoCols = _twoCols(availableWidth);
    final visible = fields.where(_shouldShowRelationshipOther).toList();

    MgysdFormFieldDef? byId(String id) {
      for (final f in visible) {
        if (f.id == id) return f;
      }
      return null;
    }

    final widgets = <Widget>[];
    final used = <String>{};

    void addField(MgysdFormFieldDef f) {
      used.add(f.id);
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildField(f),
        ),
      );
    }

    void addRow(MgysdFormFieldDef f1, MgysdFormFieldDef f2) {
      used.add(f1.id);
      used.add(f2.id);
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _row2(_buildField(f1), _buildField(f2)),
        ),
      );
    }

    if (twoCols) {
      final rfn = byId(deReporterFirstName);
      final rln = byId(deReporterLastName);
      if (rfn != null && rln != null) addRow(rfn, rln);

      final dob = byId(deReporterDob);
      final age = byId(deReporterAge);
      if (dob != null && age != null) addRow(dob, age);

      final sex = byId(deReporterSex);
      final occupation = byId(deReporterOccupation);
      if (sex != null && occupation != null) addRow(sex, occupation);

      final p1 = byId(deReporterPhone);
      final p2 = byId(deReporterAltPhone);
      if (p1 != null && p2 != null) addRow(p1, p2);

      final cfn = byId(deChiefFirstName);
      final cln = byId(deChiefLastName);
      if (cfn != null && cln != null) addRow(cfn, cln);
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
    required List<Widget> children,
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
          ),
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
          ...children,
        ],
      ),
    );
  }

  Widget _dropdownFromOptions({
    required String label,
    required String value,
    required List<MgysdOption> options,
    required void Function(String?) onChanged,
    bool requiredField = false,
  }) {
    final safeValue = options.any((o) => o.code == value) ? value : null;

    return DropdownButtonFormField<String>(
      value: safeValue,
      isExpanded: true,
      decoration: _decoration(label),
      items: options
          .map(
            (o) => DropdownMenuItem<String>(
          value: o.code,
          child: Text(o.label, overflow: TextOverflow.ellipsis),
        ),
      )
          .toList(),
      onChanged: onChanged,
      validator: (v) => _requiredValidator(v, requiredField: requiredField),
    );
  }

  Widget _clientCard(int index, MgysdClientEntry client, double availableWidth) {
    final twoCols = _twoCols(availableWidth);

    Widget firstName = TextFormField(
      controller: client.firstNameController,
      decoration: _decoration('Client First name'),
      validator: (v) => _requiredValidator(v, requiredField: true),
    );

    Widget lastName = TextFormField(
      controller: client.lastNameController,
      decoration: _decoration('Client Last name'),
      validator: (v) => _requiredValidator(v, requiredField: true),
    );

    Widget age = TextFormField(
      controller: client.ageController,
      decoration: _decoration('Age'),
      keyboardType: TextInputType.number,
      validator: (v) => _requiredValidator(v, requiredField: true),
      onChanged: (v) {
        final estimatedDob = _estimateDobFromAge(v);
        setState(() {
          client.estimatedDobController.text = estimatedDob;
        });
      },
    );

    Widget estimatedDob = TextFormField(
      controller: client.estimatedDobController,
      readOnly: true,
      decoration: _decoration(
        'Estimated date of birth',
        icon: Icons.calendar_month,
        hint: 'Calculated from age',
      ),
    );

    Widget sex = _dropdownFromOptions(
      label: 'Client Sex',
      value: client.sex,
      options: _sexOptions,
      requiredField: true,
      onChanged: (v) => setState(() {
        client.sex = v ?? '';
      }),
    );

    Widget district = TextFormField(
      controller: client.districtController,
      decoration: _decoration('Client District'),
      validator: (v) => _requiredValidator(v, requiredField: true),
    );

    Widget phone = TextFormField(
      controller: client.phoneController,
      decoration: _decoration('Client phone', icon: Icons.phone),
      keyboardType: TextInputType.phone,
      validator: (v) => _phoneValidator(v, requiredField: false),
    );

    Widget contactMethod = _dropdownFromOptions(
      label: 'How to contact client',
      value: client.contactMethod,
      options: _contactMethodOptions,
      requiredField: true,
      onChanged: (v) => setState(() {
        client.contactMethod = v ?? '';
        if (client.contactMethod != 'OTHER') {
          client.contactOtherController.text = '';
        }
      }),
    );

    Widget contactOther = TextFormField(
      controller: client.contactOtherController,
      decoration: _decoration('Specify other contact method'),
      validator: (v) {
        if (client.contactMethod == 'OTHER' && (v ?? '').trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
    );

    final fields = <Widget>[
      if (twoCols)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _row2(firstName, lastName),
        )
      else ...[
        Padding(padding: const EdgeInsets.only(bottom: 10), child: firstName),
        Padding(padding: const EdgeInsets.only(bottom: 10), child: lastName),
      ],
      if (twoCols)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _row2(age, estimatedDob),
        )
      else ...[
        Padding(padding: const EdgeInsets.only(bottom: 10), child: age),
        Padding(padding: const EdgeInsets.only(bottom: 10), child: estimatedDob),
      ],
      if (twoCols)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _row2(sex, district),
        )
      else ...[
        Padding(padding: const EdgeInsets.only(bottom: 10), child: sex),
        Padding(padding: const EdgeInsets.only(bottom: 10), child: district),
      ],
      if (twoCols)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _row2(phone, contactMethod),
        )
      else ...[
        Padding(padding: const EdgeInsets.only(bottom: 10), child: phone),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: contactMethod,
        ),
      ],
      if (client.contactMethod == 'OTHER')
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: contactOther,
        ),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          ...fields,
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Container()),
              if (_clients.length > 1)
                TextButton.icon(
                  onPressed: () => _removeClient(index),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Remove', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _personInvolvedCard(int index, MgysdPersonInvolvedEntry person, double availableWidth) {
    final twoCols = _twoCols(availableWidth);

    Widget firstNameField = TextFormField(
      controller: person.nameController,
      decoration: _decoration('First name'),
      validator: (v) => _requiredValidator(v, requiredField: true),
    );

    Widget lastNameField = TextFormField(
      controller: person.roleController,
      decoration: _decoration('Role / Relationship'),
      validator: (v) => _requiredValidator(v, requiredField: true),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Person ${index + 1}',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
          ),
          if (twoCols)
            Row(
              children: [
                Expanded(child: firstNameField),
                const SizedBox(width: 10),
                Expanded(child: lastNameField),
              ],
            )
          else ...[
            firstNameField,
            const SizedBox(height: 8),
            lastNameField,
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const Spacer(),
              if (_peopleInvolved.isNotEmpty)
                TextButton.icon(
                  onPressed: () => _removePersonInvolved(index),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Remove', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form')),
      );
      return;
    }

    setState(() => _submitting = true);

    // ensure concern reasons are stored
    _values[deConcernReason] = _selectedConcernReasons.join(',');
    _values[deConcernReasonOther] = _concernOtherController.text.trim();

    // collect clients and people involved
    final clientsJson = _clients.map((c) => c.toJson()).toList();
    final peopleJson = _peopleInvolved.map((p) => p.toJson()).toList();

    // reporter map
    final reporterMap = <String, String>{};
    for (final f in aboutReporterFields) {
      reporterMap[f.id] = _values[f.id] ?? '';
    }

    final concernsMap = <String, String>{
      deWhenHappened: _values[deWhenHappened] ?? '',
      deIncidentLocation: _values[deIncidentLocation] ?? '',
      deConcernReason: _values[deConcernReason] ?? '',
      deConcernReasonOther: _values[deConcernReasonOther] ?? '',
      deIncidentDescription: _values[deIncidentDescription] ?? '',
    };

    final payload = {
      'reporter': reporterMap,
      'concerns': concernsMap,
      'peopleInvolved': peopleJson, // moved people involved before clients in UI
      'clients': clientsJson,
    };

    debugPrint('MGYSD payload: ${jsonEncode(payload)}');

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _submitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report saved (simulated)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentMax = _contentMaxWidth(screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a Case'),
        backgroundColor: widget.color,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMax),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionCard(
                      title: 'About Reporter',
                      subtitle: 'Who is reporting this concern',
                      icon: Icons.person,
                      children: _buildCompactFields(
                        fields: aboutReporterFields,
                        availableWidth: contentMax,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _sectionCard(
                      title: 'Why are you concerned?',
                      subtitle: 'Date, location and reasons for concern',
                      icon: Icons.report_problem,
                      children: [

                        ...concernFields.map((f) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _buildField(f),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _sectionCard(
                      title: 'People involved',
                      subtitle: 'Other people involved in the incident',
                      icon: Icons.people,
                      children: [
                        ..._peopleInvolved.asMap().entries.map((e) {
                          final idx = e.key;
                          final person = e.value;
                          return _personInvolvedCard(idx, person, contentMax);
                        }).toList(),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _addPersonInvolved,
                            icon: const Icon(Icons.add),
                            label: const Text('Add another person involved'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _sectionCard(
                      title: 'Clients',
                      subtitle: 'People affected',
                      icon: Icons.group,
                      children: [
                        ..._clients.asMap().entries.map((e) {
                          final idx = e.key;
                          final client = e.value;
                          return _clientCard(idx, client, contentMax);
                        }).toList(),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _addClient,
                            icon: const Icon(Icons.add),
                            label: const Text('Add another client'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitting ? null : _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.color,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _submitting
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                          : const Text('Save report offline'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
