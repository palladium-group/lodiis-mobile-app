
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class MgysdNewCasePage extends StatefulWidget {
  const MgysdNewCasePage({
    Key? key,
    required this.color,
    this.reportedEventId,
    this.prefillClientFirstName,
    this.prefillClientLastName,
    this.prefillClientPhone,
    this.prefillCaseType,
    this.prefillIncidentDate,
  }) : super(key: key);

  final Color color;
  final String? reportedEventId;
  final String? prefillClientFirstName;
  final String? prefillClientLastName;
  final String? prefillClientPhone;
  final String? prefillCaseType;
  final String? prefillIncidentDate;

  @override
  State<MgysdNewCasePage> createState() => _MgysdNewCasePageState();
}

class _Opt {
  final String code;
  final String label;

  const _Opt(this.code, this.label);
}

class _MgysdNewCasePageState extends State<MgysdNewCasePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fileNumberController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _communityCouncilController =
  TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _physicalAddressController =
  TextEditingController();

  final TextEditingController _identityNumberController =
  TextEditingController();
  final TextEditingController _clientFirstNameController =
  TextEditingController();
  final TextEditingController _clientSurnameController =
  TextEditingController();
  final TextEditingController _clientDobController = TextEditingController();
  final TextEditingController _clientAgeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _alternativePhoneController =
  TextEditingController();
  final TextEditingController _homeLanguageOtherController =
  TextEditingController();

  DateTime? _selectedDob;
  bool _saving = false;

  String _clientCategory = '';
  String _isDisabled = '';
  String _sex = '';
  String _nationality = '';
  String _homeLanguage = '';

  static const String mgysdTrackerProgramId = 'MGYSD_TRACKER_PROGRAM';
  static const String mgysdHouseholdTeiTypeId = 'MGYSD_HOUSEHOLD_TEI_TYPE';
  static const String mgysdPersonTeiTypeId = 'MGYSD_PERSON_TEI_TYPE';

  static const String attHouseholdFileNumber = 'ATTR_HOUSEHOLD_FILE_NUMBER';
  static const String attHouseholdDistrict = 'ATTR_HOUSEHOLD_DISTRICT';
  static const String attHouseholdCommunityCouncil =
      'ATTR_HOUSEHOLD_COMMUNITY_COUNCIL';
  static const String attHouseholdVillage = 'ATTR_HOUSEHOLD_VILLAGE';
  static const String attHouseholdAddress = 'ATTR_HOUSEHOLD_ADDRESS';

  static const String attFirstName = 'ATTR_FIRSTNAME';
  static const String attLastName = 'ATTR_LASTNAME';
  static const String attDob = 'ATTR_DOB';
  static const String attAge = 'ATTR_AGE';
  static const String attPhone = 'ATTR_PHONE';
  static const String attAlternativePhone = 'ATTR_ALTERNATIVE_PHONE';
  static const String attSex = 'ATTR_SEX';
  static const String attClientCategory = 'ATTR_CLIENT_CATEGORY';
  static const String attIsDisabled = 'ATTR_IS_DISABLED';
  static const String attIdentityNumber = 'ATTR_IDENTITY_NUMBER';
  static const String attNationality = 'ATTR_NATIONALITY';
  static const String attHomeLanguage = 'ATTR_HOME_LANGUAGE';
  static const String attHomeLanguageOther = 'ATTR_HOME_LANGUAGE_OTHER';

  static const String relHouseholdHasMember = 'HOUSEHOLD_HAS_MEMBER';

  static const List<_Opt> clientCategoryOptions = [
    _Opt('CHILD', 'Child'),
    _Opt('ADULT_ELDERLY_PERSON', 'Adult / Elderly Person'),
  ];

  static const List<_Opt> yesNoOptions = [
    _Opt('YES', 'Yes'),
    _Opt('NO', 'No'),
  ];

  static const List<_Opt> sexOptions = [
    _Opt('MALE', 'Male'),
    _Opt('FEMALE', 'Female'),
  ];

  static const List<_Opt> nationalityOptions = [
    _Opt('MOSOTHO', 'Mosotho'),
    _Opt('SOUTH_AFRICAN', 'South African'),
    _Opt('ZIMBABWEAN', 'Zimbabwean'),
    _Opt('OTHER', 'Other'),
  ];

  static const List<_Opt> homeLanguageOptions = [
    _Opt('SESOTHO', 'Sesotho'),
    _Opt('ENGLISH', 'English'),
    _Opt('XHOSA', 'Xhoza'),
    _Opt('OTHER', 'Other'),
  ];

  @override
  void initState() {
    super.initState();

    _clientFirstNameController.text =
        (widget.prefillClientFirstName ?? '').trim();
    _clientSurnameController.text = (widget.prefillClientLastName ?? '').trim();
    _phoneController.text = (widget.prefillClientPhone ?? '').trim();

    _fileNumberController.text = 'MGYSD-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  void dispose() {
    _fileNumberController.dispose();
    _districtController.dispose();
    _communityCouncilController.dispose();
    _villageController.dispose();
    _physicalAddressController.dispose();

    _identityNumberController.dispose();
    _clientFirstNameController.dispose();
    _clientSurnameController.dispose();
    _clientDobController.dispose();
    _clientAgeController.dispose();
    _phoneController.dispose();
    _alternativePhoneController.dispose();
    _homeLanguageOtherController.dispose();

    super.dispose();
  }

  Future<Database> _db() async {
    final dbClient = await OfflineDbProvider().db;
    if (dbClient == null) throw Exception('Offline DB not initialized');
    return dbClient;
  }

  String _newId() {
    final r = Random();
    return '${DateTime.now().millisecondsSinceEpoch}-${r.nextInt(999999)}';
  }

  String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    final hadBirthday = today.month > dob.month ||
        (today.month == dob.month && today.day >= dob.day);
    if (!hadBirthday) age--;
    return age < 0 ? 0 : age;
  }

  Future<void> _pickDobForClient() async {
    final now = DateTime.now();
    final initial = _selectedDob ?? DateTime(now.year - 15, 1, 1);

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      initialDate: initial,
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _clientDobController.text = _formatDate(picked);
        _clientAgeController.text = _calculateAge(picked).toString();
      });
    }
  }

  Future<void> _saveTeiOffline({
    required Database db,
    required String teiId,
    required String teiTypeId,
    required String orgUnit,
  }) async {
    await db.insert(
      'tracked_entity_instance',
      {
        'id': _newId(),
        'trackedEntityInstance': teiId,
        'trackedEntityType': teiTypeId,
        'orgUnit': orgUnit,
        'syncStatus': 'not-synced',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _saveAttrOffline({
    required Database db,
    required String teiId,
    required String attribute,
    required String value,
  }) async {
    final v = value.trim();
    if (v.isEmpty) return;

    await db.insert(
      'tracked_entity_instance_attribute',
      {
        'id': _newId(),
        'trackedEntityInstance': teiId,
        'attribute': attribute,
        'value': v,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _saveRelationshipOffline({
    required Database db,
    required String relationshipTypeCode,
    required String fromTei,
    required String toTei,
  }) async {
    await db.insert(
      'tei_relationships',
      {
        'id': _newId(),
        'relationshipType': relationshipTypeCode,
        'fromTei': fromTei,
        'toTei': toTei,
        'syncStatus': 'not-synced',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _saveHouseholdMemberOffline({
    required Database db,
    required String householdTei,
    required String memberTei,
    required String memberRole,
    required bool isPrimaryClient,
  }) async {
    await db.insert(
      'mgysd_household_member',
      {
        'id': _newId(),
        'householdTei': householdTei,
        'memberTei': memberTei,
        'memberRole': memberRole,
        'isPrimaryClient': isPrimaryClient ? 'true' : 'false',
        'syncStatus': 'not-synced',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _saveEnrollmentOffline({
    required Database db,
    required String enrollmentId,
    required String teiId,
    required String orgUnit,
    required String searchableValue,
  }) async {
    final nowIso = DateTime.now().toIso8601String();

    await db.insert(
      'enrollment',
      {
        'id': _newId(),
        'enrollment': enrollmentId,
        'enrollmentDate': nowIso.substring(0, 10),
        'incidentDate': nowIso.substring(0, 10),
        'program': mgysdTrackerProgramId,
        'orgUnit': orgUnit,
        'trackedEntityInstance': teiId,
        'status': 'ACTIVE',
        'searchableValue': searchableValue,
        'syncStatus': 'not-synced',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _saveLinkToReportEvent({
    required Database db,
    required String reportEventId,
    required String teiId,
    required String enrollmentId,
  }) async {
    final nowIso = DateTime.now().toIso8601String();

    await db.insert(
      'mgysd_report_intake_link',
      {
        'id': _newId(),
        'reportEvent': reportEventId,
        'tei': teiId,
        'enrollment': enrollmentId,
        'createdAt': nowIso,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _saveCase() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _saving = true);

    try {
      final db = await _db();

      final householdTeiId = 'TEI_${_newId()}';
      final householdEnrollmentId = 'ENR_${_newId()}';
      final clientTeiId = 'TEI_${_newId()}';
      final orgUnit = '';

      await _saveTeiOffline(
        db: db,
        teiId: householdTeiId,
        teiTypeId: mgysdHouseholdTeiTypeId,
        orgUnit: orgUnit,
      );

      await _saveAttrOffline(
        db: db,
        teiId: householdTeiId,
        attribute: attHouseholdFileNumber,
        value: _fileNumberController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: householdTeiId,
        attribute: attHouseholdDistrict,
        value: _districtController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: householdTeiId,
        attribute: attHouseholdCommunityCouncil,
        value: _communityCouncilController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: householdTeiId,
        attribute: attHouseholdVillage,
        value: _villageController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: householdTeiId,
        attribute: attHouseholdAddress,
        value: _physicalAddressController.text,
      );

      final searchableValue = [
        _fileNumberController.text.trim(),
        _clientFirstNameController.text.trim(),
        _clientSurnameController.text.trim(),
        _identityNumberController.text.trim(),
        widget.reportedEventId == null ? '' : 'reportEvent:${widget.reportedEventId}',
      ].where((e) => e.isNotEmpty).join(' | ');

      await _saveEnrollmentOffline(
        db: db,
        enrollmentId: householdEnrollmentId,
        teiId: householdTeiId,
        orgUnit: orgUnit,
        searchableValue: searchableValue,
      );

      final reportEventId = (widget.reportedEventId ?? '').trim();
      if (reportEventId.isNotEmpty) {
        await _saveLinkToReportEvent(
          db: db,
          reportEventId: reportEventId,
          teiId: householdTeiId,
          enrollmentId: householdEnrollmentId,
        );
      }

      await _saveTeiOffline(
        db: db,
        teiId: clientTeiId,
        teiTypeId: mgysdPersonTeiTypeId,
        orgUnit: orgUnit,
      );

      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attClientCategory,
        value: _clientCategory,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attIsDisabled,
        value: _isDisabled,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attIdentityNumber,
        value: _identityNumberController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attFirstName,
        value: _clientFirstNameController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attLastName,
        value: _clientSurnameController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attDob,
        value: _clientDobController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attAge,
        value: _clientAgeController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attSex,
        value: _sex,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attNationality,
        value: _nationality,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attHomeLanguage,
        value: _homeLanguage,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attHomeLanguageOther,
        value: _homeLanguageOtherController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attPhone,
        value: _phoneController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attAlternativePhone,
        value: _alternativePhoneController.text,
      );

      await _saveHouseholdMemberOffline(
        db: db,
        householdTei: householdTeiId,
        memberTei: clientTeiId,
        memberRole: 'CLIENT',
        isPrimaryClient: true,
      );

      await _saveRelationshipOffline(
        db: db,
        relationshipTypeCode: relHouseholdHasMember,
        fromTei: householdTeiId,
        toTei: clientTeiId,
      );

      AppUtil.showToastMessage(
        message: widget.reportedEventId == null
            ? 'Household case saved offline.'
            : 'Household case saved and linked to report.',
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      AppUtil.showToastMessage(message: 'Failed to save case: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _titleRow({
    required Color color,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 12.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<_Opt> options,
    required void Function(String?) onChanged,
    bool requiredField = false,
  }) {
    final safeValue = options.any((o) => o.code == value) ? value : null;

    return DropdownButtonFormField<String>(
      value: safeValue,
      isExpanded: true,
      items: options
          .map(
            (o) => DropdownMenuItem<String>(
          value: o.code,
          child: Text(o.label, overflow: TextOverflow.ellipsis),
        ),
      )
          .toList(),
      onChanged: onChanged,
      validator: (v) {
        if (!requiredField) return null;
        if ((v ?? '').trim().isEmpty) return 'Required';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final activeInterventionProgram =
        Provider.of<InterventionCardState>(context, listen: false)
            .currentInterventionProgram;

    final Color primary = activeInterventionProgram.primaryColor ?? widget.color;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: SubPageAppBar(
          label: widget.reportedEventId == null
              ? 'Register / Intake Case'
              : 'Enroll Household Case',
          activeInterventionProgram: activeInterventionProgram,
          disableSelectionOfActiveIntervention: false,
        ),
      ),
      body: SubPageBody(
        body: SingleChildScrollView(
          child: Container(
            margin:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if ((widget.reportedEventId ?? '').trim().isNotEmpty)
                    MaterialCard(
                      body: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.link, color: widget.color),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Linked to report event: ${widget.reportedEventId}',
                                style: const TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  MaterialCard(
                    body: Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleRow(
                            color: primary,
                            title: 'Household Location',
                            subtitle: 'Capture the household location and file reference.',
                            icon: Icons.home_work_outlined,
                          ),
                          const SizedBox(height: 12),
                          _Input(
                            controller: _fileNumberController,
                            label: 'File Number',
                            hint: 'e.g. MGYSD-0001',
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'File number is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _districtController,
                            label: 'District',
                            hint: 'e.g. Maseru',
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'District is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _communityCouncilController,
                            label: 'Community Council',
                            hint: 'e.g. Lithabaneng',
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _villageController,
                            label: 'Village',
                            hint: 'e.g. Ha Thetsane',
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Village is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _physicalAddressController,
                            label: 'Physical Address',
                            hint: 'Describe the household physical address',
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  MaterialCard(
                    body: Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleRow(
                            color: primary,
                            title: 'Demographics and Reporting Information',
                            subtitle: 'Capture the main client information for this case.',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 12),
                          _dropdown(
                            label: 'Client category',
                            value: _clientCategory,
                            options: clientCategoryOptions,
                            requiredField: true,
                            onChanged: (v) {
                              setState(() => _clientCategory = v ?? '');
                            },
                          ),
                          const SizedBox(height: 10),
                          _dropdown(
                            label: 'Is the client disabled?',
                            value: _isDisabled,
                            options: yesNoOptions,
                            requiredField: true,
                            onChanged: (v) {
                              setState(() => _isDisabled = v ?? '');
                            },
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _identityNumberController,
                            label: 'Identity Number',
                            hint: 'National ID / document number',
                          ),
                          const SizedBox(height: 10),
                          _row2(
                            _Input(
                              controller: _clientFirstNameController,
                              label: 'First name',
                              hint: 'Client first name',
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'First name is required';
                                }
                                return null;
                              },
                            ),
                            _Input(
                              controller: _clientSurnameController,
                              label: 'Surname',
                              hint: 'Client surname',
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Surname is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          _row2(
                            GestureDetector(
                              onTap: _pickDobForClient,
                              child: AbsorbPointer(
                                child: _Input(
                                  controller: _clientDobController,
                                  label: 'Date of Birth',
                                  hint: 'Pick date',
                                  suffixIcon: const Icon(Icons.date_range),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Date of birth is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            _Input(
                              controller: _clientAgeController,
                              label: 'Age',
                              hint: 'Auto-calculated',
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _dropdown(
                            label: 'Sex',
                            value: _sex,
                            options: sexOptions,
                            requiredField: true,
                            onChanged: (v) {
                              setState(() => _sex = v ?? '');
                            },
                          ),
                          const SizedBox(height: 10),
                          _dropdown(
                            label: 'Nationality',
                            value: _nationality,
                            options: nationalityOptions,
                            requiredField: true,
                            onChanged: (v) {
                              setState(() => _nationality = v ?? '');
                            },
                          ),
                          const SizedBox(height: 10),
                          _dropdown(
                            label: 'Home Language',
                            value: _homeLanguage,
                            options: homeLanguageOptions,
                            requiredField: true,
                            onChanged: (v) {
                              setState(() {
                                _homeLanguage = v ?? '';
                                if (_homeLanguage != 'OTHER') {
                                  _homeLanguageOtherController.text = '';
                                }
                              });
                            },
                          ),
                          if (_homeLanguage == 'OTHER') ...[
                            const SizedBox(height: 10),
                            _Input(
                              controller: _homeLanguageOtherController,
                              label: 'Specify other language',
                              hint: 'Enter language',
                              validator: (v) {
                                if (_homeLanguage == 'OTHER' &&
                                    (v == null || v.trim().isEmpty)) {
                                  return 'Please specify language';
                                }
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 10),
                          _row2(
                            _Input(
                              controller: _phoneController,
                              label: 'Phone Number',
                              hint: 'e.g. 5xxxxxxx',
                              keyboardType: TextInputType.phone,
                            ),
                            _Input(
                              controller: _alternativePhoneController,
                              label: 'Alternative Phone Number',
                              hint: 'e.g. 5xxxxxxx',
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  EntryFormSaveButton(
                    marginLeft: 20.0,
                    marginRight: 20.0,
                    label: _saving ? 'Saving...' : 'Save Intake',
                    svgIconPath: 'assets/icons/save-icon.svg',
                    svgIconHeight: 16.0,
                    svgIconWidth: 16.0,
                    labelColor: Colors.white,
                    buttonColor: primary,
                    fontSize: 15.0,
                    onPressButton: _saving ? () {} : _saveCase,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.keyboardType,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int maxLines;
  final bool readOnly;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: readOnly ? const Color(0xFFF3F5F7) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}
