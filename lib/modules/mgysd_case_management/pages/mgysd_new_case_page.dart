
import 'dart:convert';
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

class _ReasonGroup {
  final String code;
  final String title;
  final List<_Opt> options;
  final bool childOnly;

  const _ReasonGroup({
    required this.code,
    required this.title,
    required this.options,
    this.childOnly = false,
  });
}

class _DynamicTextItem {
  final String id;
  final TextEditingController controller;

  _DynamicTextItem({
    required this.id,
    String value = '',
  }) : controller = TextEditingController(text: value);

  void dispose() {
    controller.dispose();
  }
}

class _MgysdNewCasePageState extends State<MgysdNewCasePage> {
  final _formKey = GlobalKey<FormState>();

  final _fileNumberController = TextEditingController();
  final _districtController = TextEditingController();
  final _communityCouncilController = TextEditingController();
  final _villageController = TextEditingController();
  final _physicalAddressController = TextEditingController();

  final _identityNumberController = TextEditingController();
  final _clientFirstNameController = TextEditingController();
  final _clientSurnameController = TextEditingController();
  final _clientDobController = TextEditingController();
  final _clientAgeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alternativePhoneController = TextEditingController();
  final _homeLanguageOtherController = TextEditingController();

  final _schoolNameController = TextEditingController();
  final _employerNameController = TextEditingController();

  final _nextOfKinFirstNameController = TextEditingController();
  final _nextOfKinSurnameController = TextEditingController();
  final _nextOfKinPhoneController = TextEditingController();
  final _nextOfKinPhysicalAddressController = TextEditingController();
  final _nextOfKinRelationshipOtherController = TextEditingController();

  final _reasonOtherController = TextEditingController();

  final _emergencyActionTakenController = TextEditingController();
  final _emergencyNoActionRefusedSpecifyController = TextEditingController();
  final _emergencyNoActionOtherSpecifyController = TextEditingController();

  DateTime? _selectedDob;
  bool _saving = false;

  String _clientCategory = '';
  String _isDisabled = '';
  String _sex = '';
  String _nationality = '';
  String _homeLanguage = '';
  String _isClientInSchool = '';
  String _grade = '';
  String _schoolAttendanceStatus = '';
  String _isAdultEmployed = '';
  String _nextOfKinRelationship = '';

  String _hasEmergencyActionTaken = '';
  String _emergencyNoActionReason = '';

  final Set<String> _selectedReasonOptions = {};
  final List<_DynamicTextItem> _contactedPhoneNumbers = [];
  final List<_DynamicTextItem> _servicesAlreadyProvided = [];

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

  static const String attIsClientInSchool = 'ATTR_IS_CLIENT_IN_SCHOOL';
  static const String attSchoolName = 'ATTR_SCHOOL_NAME';
  static const String attGrade = 'ATTR_GRADE';
  static const String attSchoolAttendanceStatus =
      'ATTR_SCHOOL_ATTENDANCE_STATUS';

  static const String attIsAdultEmployed = 'ATTR_IS_ADULT_EMPLOYED';
  static const String attEmployerName = 'ATTR_EMPLOYER_NAME';

  static const String attNextOfKinFirstName = 'ATTR_NOK_FIRST_NAME';
  static const String attNextOfKinSurname = 'ATTR_NOK_SURNAME';
  static const String attNextOfKinPhone = 'ATTR_NOK_PHONE';
  static const String attNextOfKinPhysicalAddress =
      'ATTR_NOK_PHYSICAL_ADDRESS';
  static const String attNextOfKinRelationship = 'ATTR_NOK_RELATIONSHIP';
  static const String attNextOfKinRelationshipOther =
      'ATTR_NOK_RELATIONSHIP_OTHER';

  static const String attReasonForEnrolment = 'ATTR_REASON_FOR_ENROLMENT';
  static const String attReasonForEnrolmentOther =
      'ATTR_REASON_FOR_ENROLMENT_OTHER';

  static const String attHasEmergencyActionTaken =
      'ATTR_HAS_EMERGENCY_ACTION_TAKEN';
  static const String attEmergencyNoActionReason =
      'ATTR_EMERGENCY_NO_ACTION_REASON';
  static const String attEmergencyNoActionRefusedSpecify =
      'ATTR_EMERGENCY_NO_ACTION_REFUSED_SPECIFY';
  static const String attEmergencyNoActionOtherSpecify =
      'ATTR_EMERGENCY_NO_ACTION_OTHER_SPECIFY';
  static const String attEmergencyActionTakenDescription =
      'ATTR_EMERGENCY_ACTION_TAKEN_DESCRIPTION';
  static const String attEmergencyContactedPhoneNumbers =
      'ATTR_EMERGENCY_CONTACTED_PHONE_NUMBERS';
  static const String attEmergencyServicesAlreadyProvided =
      'ATTR_EMERGENCY_SERVICES_ALREADY_PROVIDED';

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
    _Opt('XHOSA', 'Xhosa'),
    _Opt('OTHER', 'Other'),
  ];

  static const List<_Opt> gradeOptions = [
    _Opt('1', 'Grade 1'),
    _Opt('2', 'Grade 2'),
    _Opt('3', 'Grade 3'),
    _Opt('4', 'Grade 4'),
    _Opt('5', 'Grade 5'),
    _Opt('6', 'Grade 6'),
    _Opt('7', 'Grade 7'),
    _Opt('8', 'Grade 8'),
    _Opt('9', 'Grade 9'),
    _Opt('10', 'Grade 10'),
    _Opt('11', 'Grade 11'),
  ];

  static const List<_Opt> inSchoolAttendanceOptions = [
    _Opt('POOR_ATTENDANCE', 'Poor attendance'),
    _Opt('GOOD_ATTENDANCE', 'Good attendance'),
  ];

  static const List<_Opt> notInSchoolAttendanceOptions = [
    _Opt('NO_LONGER_IN_SCHOOL', 'No longer in School'),
    _Opt('NEVER_ATTENDED_SCHOOL', 'Never attended School'),
  ];

  static const List<_Opt> nextOfKinRelationshipOptions = [
    _Opt('PARENT', 'Parent'),
    _Opt('CAREGIVER', 'Caregiver'),
    _Opt('GUARDIAN', 'Guardian'),
    _Opt('OTHER', 'Other'),
  ];

  static const List<_Opt> emergencyNoActionOptions = [
    _Opt('NOT_REQUIRED', 'Not required'),
    _Opt('REFUSED', 'Refused'),
    _Opt('OTHER', 'Other'),
  ];

  static const List<_ReasonGroup> groupedReasons = [
    _ReasonGroup(
      code: 'ABUSE',
      title: 'Abuse',
      options: [
        _Opt('ABUSE_PHYSICAL', 'Physical abuse'),
        _Opt('ABUSE_EMOTIONAL', 'Emotional abuse'),
        _Opt('ABUSE_SEXUAL', 'Sexual abuse'),
        _Opt('ABUSE_RAPE', 'Rape'),
        _Opt('ABUSE_INCEST', 'Incest'),
      ],
    ),
    _ReasonGroup(
      code: 'CARE_OR_PROTECTION',
      title: 'In need of care or protection',
      options: [
        _Opt('CARE_NEGLECT', 'Neglect'),
        _Opt('CARE_ABANDONMENT', 'Abandonment'),
        _Opt('CARE_ORPHANS', 'Orphans'),
        _Opt('CARE_BABY_ABANDONMENT', 'Baby abandonment'),
      ],
    ),
    _ReasonGroup(
      code: 'BEHAVIOURAL_PROBLEMS',
      title: 'Behavioural problems',
      options: [
        _Opt('BEHAVIOUR_ALCOHOL_ABUSE', 'Alcohol abuse'),
        _Opt('BEHAVIOUR_DRUG_ABUSE', 'Drug abuse'),
        _Opt('BEHAVIOUR_OTHER', 'Other behavioural problem'),
      ],
    ),
    _ReasonGroup(
      code: 'SPECIAL_NEEDS',
      title: 'Special needs',
      options: [
        _Opt('SPECIAL_PHYSICAL', 'Physical'),
        _Opt('SPECIAL_MENTAL', 'Mental'),
        _Opt('SPECIAL_PSYCHOLOGICAL', 'Psychological'),
      ],
    ),
    _ReasonGroup(
      code: 'CHILD_EXPLOITATION',
      title: 'Child exploitation',
      childOnly: true,
      options: [
        _Opt('EXPLOITATION_CHILD_LABOUR', 'Child labour'),
        _Opt('EXPLOITATION_CHILD_MARRIAGE', 'Child marriage'),
        _Opt('EXPLOITATION_SEXUAL', 'Sexual exploitation'),
      ],
    ),
  ];

  static const List<_Opt> singleReasons = [
    _Opt('STREET_CHILD', 'Child living and working on the street'),
    _Opt('CONFLICT_WITH_LAW', 'Child in conflict with the law'),
    _Opt('ABDUCTION_KIDNAPPING', 'Child abduction / kidnapping'),
    _Opt('CHILD_MAINTENANCE', 'Child maintenance'),
    _Opt('CHILD_WITNESS_SUPPORT', 'Child witness support services'),
    _Opt('DOMESTIC_VIOLENCE', 'Domestic violence'),
    _Opt('HUMAN_TRAFFICKING', 'Human trafficking / Trafficking in Persons'),
    _Opt('INTERNATIONAL_SOCIAL_SERVICES', 'International social services'),
    _Opt('TEENAGE_PREGNANCY_YOUNG_MOTHERS',
        'Teenage pregnancy / young mothers'),
    _Opt('PSYCHOSOCIAL_DISTRESS',
        'Psychosocial distress / bereavement / trauma'),
    _Opt('PRE_SENTENCE_REQUEST_REPORT', 'Pre-sentence request / report'),
    _Opt('SOCIAL_ASSISTANCE_EDUCATIONAL_AID',
        'Social Assistance and Educational Aid'),
    _Opt('GRIEVANCE', 'Grievance'),
    _Opt('COMMUNITY_DEVELOPMENT_INITIATIVES',
        'Community Development Initiatives'),
    _Opt('HEALTH_NUTRITION_ISSUES', 'Health and nutrition issues'),
    _Opt('OTHER', 'Other'),
  ];

  static const Set<String> childOnlySingleReasonCodes = {
    'STREET_CHILD',
    'CONFLICT_WITH_LAW',
    'ABDUCTION_KIDNAPPING',
    'CHILD_MAINTENANCE',
    'CHILD_WITNESS_SUPPORT',
    'TEENAGE_PREGNANCY_YOUNG_MOTHERS',
    'SOCIAL_ASSISTANCE_EDUCATIONAL_AID',
  };

  bool get _isAdultOrElderly => _clientCategory == 'ADULT_ELDERLY_PERSON';
  bool get _isChild => _clientCategory == 'CHILD';
  bool get _isDisabledYes => _isDisabled == 'YES';
  bool get _showGuardianOption => _isDisabledYes;
  bool get _nextOfKinRelationshipIsOther => _nextOfKinRelationship == 'OTHER';
  bool get _reasonOtherSelected => _selectedReasonOptions.contains('OTHER');

  int? get _clientAge => int.tryParse(_clientAgeController.text.trim());

  @override
  void initState() {
    super.initState();

    _clientFirstNameController.text =
        (widget.prefillClientFirstName ?? '').trim();
    _clientSurnameController.text = (widget.prefillClientLastName ?? '').trim();
    _phoneController.text = (widget.prefillClientPhone ?? '').trim();

    _fileNumberController.text =
    'MGYSD-${DateTime.now().millisecondsSinceEpoch}';

    _addContactedPhoneNumber();
    _addServiceProvided();
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

    _schoolNameController.dispose();
    _employerNameController.dispose();

    _nextOfKinFirstNameController.dispose();
    _nextOfKinSurnameController.dispose();
    _nextOfKinPhoneController.dispose();
    _nextOfKinPhysicalAddressController.dispose();
    _nextOfKinRelationshipOtherController.dispose();

    _reasonOtherController.dispose();

    _emergencyActionTakenController.dispose();
    _emergencyNoActionRefusedSpecifyController.dispose();
    _emergencyNoActionOtherSpecifyController.dispose();

    for (final item in _contactedPhoneNumbers) {
      item.dispose();
    }

    for (final item in _servicesAlreadyProvided) {
      item.dispose();
    }

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
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
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
        _removeHiddenReasonOptions();
      });
    }
  }

  List<_Opt> _nextOfKinRelationshipOptions() {
    if (_showGuardianOption) return nextOfKinRelationshipOptions;
    return nextOfKinRelationshipOptions
        .where((option) => option.code != 'GUARDIAN')
        .toList();
  }

  bool _isVisibleReasonGroup(_ReasonGroup group) {
    if (group.childOnly) return _isChild;
    return true;
  }

  bool _isVisibleSingleReason(_Opt reason) {
    if (childOnlySingleReasonCodes.contains(reason.code) && !_isChild) {
      return false;
    }

    if (reason.code == 'TEENAGE_PREGNANCY_YOUNG_MOTHERS') {
      return _isChild && _sex == 'FEMALE';
    }

    if (reason.code == 'SOCIAL_ASSISTANCE_EDUCATIONAL_AID') {
      final age = _clientAge;
      return _isChild && age != null && age < 18;
    }

    return true;
  }

  List<_ReasonGroup> _visibleGroupedReasons() {
    return groupedReasons.where(_isVisibleReasonGroup).toList();
  }

  Set<String> _allVisibleReasonCodes() {
    final codes = <String>{};

    for (final group in _visibleGroupedReasons()) {
      for (final option in group.options) {
        codes.add(option.code);
      }
    }

    for (final reason in singleReasons.where(_isVisibleSingleReason)) {
      codes.add(reason.code);
    }

    return codes;
  }

  void _removeHiddenReasonOptions() {
    final visibleCodes = _allVisibleReasonCodes();
    _selectedReasonOptions.removeWhere((code) => !visibleCodes.contains(code));

    if (!_reasonOtherSelected) {
      _reasonOtherController.clear();
    }
  }

  List<Map<String, String>> _selectedReasonPayload() {
    final payload = <Map<String, String>>[];

    for (final group in groupedReasons) {
      for (final option in group.options) {
        if (_selectedReasonOptions.contains(option.code)) {
          payload.add({
            'type': 'grouped',
            'groupCode': group.code,
            'groupTitle': group.title,
            'optionCode': option.code,
            'optionLabel': option.label,
          });
        }
      }
    }

    for (final reason in singleReasons) {
      if (_selectedReasonOptions.contains(reason.code)) {
        payload.add({
          'type': 'single',
          'groupCode': '',
          'groupTitle': '',
          'optionCode': reason.code,
          'optionLabel': reason.label,
        });
      }
    }

    return payload;
  }

  List<String> _dynamicValues(List<_DynamicTextItem> items) {
    return items
        .map((item) => item.controller.text.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }

  void _addContactedPhoneNumber() {
    setState(() {
      _contactedPhoneNumbers.add(_DynamicTextItem(id: _newId()));
    });
  }

  void _removeContactedPhoneNumber(int index) {
    setState(() {
      final item = _contactedPhoneNumbers.removeAt(index);
      item.dispose();

      if (_contactedPhoneNumbers.isEmpty) {
        _contactedPhoneNumbers.add(_DynamicTextItem(id: _newId()));
      }
    });
  }

  void _addServiceProvided() {
    setState(() {
      _servicesAlreadyProvided.add(_DynamicTextItem(id: _newId()));
    });
  }

  void _removeServiceProvided(int index) {
    setState(() {
      final item = _servicesAlreadyProvided.removeAt(index);
      item.dispose();

      if (_servicesAlreadyProvided.isEmpty) {
        _servicesAlreadyProvided.add(_DynamicTextItem(id: _newId()));
      }
    });
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
    await db.insert(
      'mgysd_report_intake_link',
      {
        'id': _newId(),
        'reportEvent': reportEventId,
        'tei': teiId,
        'enrollment': enrollmentId,
        'createdAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _saveCase() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_selectedReasonOptions.isEmpty) {
      AppUtil.showToastMessage(
        message: 'Please select at least one reason for enrolment.',
      );
      return;
    }

    if (_reasonOtherSelected && _reasonOtherController.text.trim().isEmpty) {
      AppUtil.showToastMessage(
        message: 'Please specify the other reason for enrolment.',
      );
      return;
    }

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

      final householdAttrs = <String, String>{
        attHouseholdFileNumber: _fileNumberController.text,
        attHouseholdDistrict: _districtController.text,
        attHouseholdCommunityCouncil: _communityCouncilController.text,
        attHouseholdVillage: _villageController.text,
        attHouseholdAddress: _physicalAddressController.text,
      };

      for (final entry in householdAttrs.entries) {
        await _saveAttrOffline(
          db: db,
          teiId: householdTeiId,
          attribute: entry.key,
          value: entry.value,
        );
      }

      final searchableValue = [
        _fileNumberController.text.trim(),
        _clientFirstNameController.text.trim(),
        _clientSurnameController.text.trim(),
        _identityNumberController.text.trim(),
        widget.reportedEventId == null
            ? ''
            : 'reportEvent:${widget.reportedEventId}',
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

      final attrs = <String, String>{
        attClientCategory: _clientCategory,
        attIsDisabled: _isDisabled,
        attIdentityNumber: _identityNumberController.text,
        attFirstName: _clientFirstNameController.text,
        attLastName: _clientSurnameController.text,
        attDob: _clientDobController.text,
        attAge: _clientAgeController.text,
        attSex: _sex,
        attNationality: _nationality,
        attHomeLanguage: _homeLanguage,
        attHomeLanguageOther: _homeLanguageOtherController.text,
        attPhone: _phoneController.text,
        attAlternativePhone: _alternativePhoneController.text,
        attIsClientInSchool: _isClientInSchool,
        attSchoolName: _schoolNameController.text,
        attGrade: _grade,
        attSchoolAttendanceStatus: _schoolAttendanceStatus,
        attIsAdultEmployed: _isAdultEmployed,
        attEmployerName: _employerNameController.text,
        attNextOfKinFirstName: _nextOfKinFirstNameController.text,
        attNextOfKinSurname: _nextOfKinSurnameController.text,
        attNextOfKinPhone: _nextOfKinPhoneController.text,
        attNextOfKinPhysicalAddress: _nextOfKinPhysicalAddressController.text,
        attNextOfKinRelationship: _nextOfKinRelationship,
        attNextOfKinRelationshipOther:
        _nextOfKinRelationshipOtherController.text,
        attReasonForEnrolment: jsonEncode(_selectedReasonPayload()),
        attReasonForEnrolmentOther: _reasonOtherController.text,
        attHasEmergencyActionTaken: _hasEmergencyActionTaken,
        attEmergencyNoActionReason: _emergencyNoActionReason,
        attEmergencyNoActionRefusedSpecify:
        _emergencyNoActionRefusedSpecifyController.text,
        attEmergencyNoActionOtherSpecify:
        _emergencyNoActionOtherSpecifyController.text,
        attEmergencyActionTakenDescription:
        _emergencyActionTakenController.text,
        attEmergencyContactedPhoneNumbers:
        jsonEncode(_dynamicValues(_contactedPhoneNumbers)),
        attEmergencyServicesAlreadyProvided:
        jsonEncode(_dynamicValues(_servicesAlreadyProvided)),
      };

      for (final entry in attrs.entries) {
        await _saveAttrOffline(
          db: db,
          teiId: clientTeiId,
          attribute: entry.key,
          value: entry.value,
        );
      }

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
              Text(title,
                  style: const TextStyle(
                      fontSize: 15.5, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style:
                  const TextStyle(color: Colors.blueGrey, fontSize: 12.5)),
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

  Widget _reasonGroupCard(_ReasonGroup group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.title,
              style:
              const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.options.map(_reasonChoiceChip).toList(),
          ),
        ],
      ),
    );
  }

  Widget _reasonChoiceChip(_Opt option) {
    final selected = _selectedReasonOptions.contains(option.code);

    return FilterChip(
      selected: selected,
      label: Text(option.label),
      selectedColor: widget.color.withOpacity(0.16),
      checkmarkColor: widget.color,
      onSelected: (checked) {
        setState(() {
          if (checked) {
            _selectedReasonOptions.add(option.code);
          } else {
            _selectedReasonOptions.remove(option.code);
            if (option.code == 'OTHER') _reasonOtherController.clear();
          }
        });
      },
    );
  }

  Widget _buildReasonSection(Color primary) {
    final visibleSingleReasons =
    singleReasons.where(_isVisibleSingleReason).toList();

    return MaterialCard(
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleRow(
              color: primary,
              title: 'Reason for Enrolment',
              subtitle: 'Select all applicable reasons for this case.',
              icon: Icons.fact_check_outlined,
            ),
            const SizedBox(height: 12),
            ..._visibleGroupedReasons().map(_reasonGroupCard).toList(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blueGrey.withOpacity(0.18)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Other enrolment reasons',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                    visibleSingleReasons.map(_reasonChoiceChip).toList(),
                  ),
                  if (_reasonOtherSelected) ...[
                    const SizedBox(height: 12),
                    _Input(
                      controller: _reasonOtherController,
                      label: 'Specify other reason',
                      hint: 'Describe other reason for enrolment',
                      maxLines: 3,
                      validator: (v) {
                        if (_reasonOtherSelected &&
                            (v == null || v.trim().isEmpty)) {
                          return 'Please specify other reason';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dynamicTextList({
    required String title,
    required List<_DynamicTextItem> items,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    required VoidCallback onAdd,
    required void Function(int index) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
          const TextStyle(fontWeight: FontWeight.w800, color: Colors.blueGrey),
        ),
        const SizedBox(height: 8),
        ...List.generate(items.length, (index) {
          final item = items[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Input(
                    controller: item.controller,
                    label: '$label ${index + 1}',
                    hint: hint,
                    keyboardType: keyboardType,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => onRemove(index),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.redAccent,
                ),
              ],
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: Text('Add $label'),
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.color,
            side: BorderSide(color: widget.color),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyActionSection(Color primary) {
    return MaterialCard(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleRow(
              color: primary,
              title: 'Any Emergency Actions Already Taken',
              subtitle:
              'Capture immediate actions, people contacted, and services already provided.',
              icon: Icons.emergency_outlined,
            ),
            const SizedBox(height: 12),
            _dropdown(
              label: 'Has any action already been taken?',
              value: _hasEmergencyActionTaken,
              options: yesNoOptions,
              requiredField: true,
              onChanged: (v) {
                setState(() {
                  _hasEmergencyActionTaken = v ?? '';

                  if (_hasEmergencyActionTaken != 'YES') {
                    _emergencyActionTakenController.clear();
                  }

                  if (_hasEmergencyActionTaken != 'NO') {
                    _emergencyNoActionReason = '';
                    _emergencyNoActionRefusedSpecifyController.clear();
                    _emergencyNoActionOtherSpecifyController.clear();
                  }
                });
              },
            ),
            if (_hasEmergencyActionTaken == 'NO') ...[
              const SizedBox(height: 10),
              _dropdown(
                label: 'If no, specify',
                value: _emergencyNoActionReason,
                options: emergencyNoActionOptions,
                requiredField: true,
                onChanged: (v) {
                  setState(() {
                    _emergencyNoActionReason = v ?? '';

                    if (_emergencyNoActionReason != 'REFUSED') {
                      _emergencyNoActionRefusedSpecifyController.clear();
                    }

                    if (_emergencyNoActionReason != 'OTHER') {
                      _emergencyNoActionOtherSpecifyController.clear();
                    }
                  });
                },
              ),
              if (_emergencyNoActionReason == 'REFUSED') ...[
                const SizedBox(height: 10),
                _Input(
                  controller: _emergencyNoActionRefusedSpecifyController,
                  label: 'Specify refusal reason',
                  hint: 'Explain why action was refused',
                  maxLines: 3,
                  validator: (v) {
                    if (_emergencyNoActionReason == 'REFUSED' &&
                        (v == null || v.trim().isEmpty)) {
                      return 'Please specify refusal reason';
                    }
                    return null;
                  },
                ),
              ],
              if (_emergencyNoActionReason == 'OTHER') ...[
                const SizedBox(height: 10),
                _Input(
                  controller: _emergencyNoActionOtherSpecifyController,
                  label: 'Specify other reason',
                  hint: 'Explain other reason',
                  maxLines: 3,
                  validator: (v) {
                    if (_emergencyNoActionReason == 'OTHER' &&
                        (v == null || v.trim().isEmpty)) {
                      return 'Please specify other reason';
                    }
                    return null;
                  },
                ),
              ],
            ],
            if (_hasEmergencyActionTaken == 'YES') ...[
              const SizedBox(height: 10),
              _Input(
                controller: _emergencyActionTakenController,
                label: 'Explain what action was taken',
                hint: 'Describe emergency action already taken',
                maxLines: 4,
                validator: (v) {
                  if (_hasEmergencyActionTaken == 'YES' &&
                      (v == null || v.trim().isEmpty)) {
                    return 'Please explain what action was taken';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 14),
            _dynamicTextList(
              title: 'Phone numbers of people contacted, if any',
              items: _contactedPhoneNumbers,
              label: 'Phone number',
              hint: 'e.g. 5xxxxxxx',
              keyboardType: TextInputType.phone,
              onAdd: _addContactedPhoneNumber,
              onRemove: _removeContactedPhoneNumber,
            ),
            const SizedBox(height: 14),
            _dynamicTextList(
              title: 'Services already provided, if any',
              items: _servicesAlreadyProvided,
              label: 'Service',
              hint: 'e.g. Police notified, counselling, temporary shelter',
              keyboardType: TextInputType.text,
              onAdd: _addServiceProvided,
              onRemove: _removeServiceProvided,
            ),
          ],
        ),
      ),
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
                      body: Padding(
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
                    body: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleRow(
                            color: primary,
                            title: 'Household Location',
                            subtitle:
                            'Capture the household location and file reference.',
                            icon: Icons.home_work_outlined,
                          ),
                          const SizedBox(height: 12),
                          _Input(
                            controller: _fileNumberController,
                            label: 'File Number',
                            hint: 'e.g. MGYSD-0001',
                            validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'File number is required'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _districtController,
                            label: 'District',
                            hint: 'e.g. Maseru',
                            validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'District is required'
                                : null,
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
                            validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Village is required'
                                : null,
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
                    body: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleRow(
                            color: primary,
                            title: 'Demographics and Reporting Information',
                            subtitle:
                            'Capture the main client information for this case.',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 12),
                          _dropdown(
                            label: 'Client category',
                            value: _clientCategory,
                            options: clientCategoryOptions,
                            requiredField: true,
                            onChanged: (v) {
                              setState(() {
                                _clientCategory = v ?? '';
                                if (!_isAdultOrElderly) {
                                  _isAdultEmployed = '';
                                  _employerNameController.clear();
                                }
                                if (_isAdultOrElderly) {
                                  _grade = '';
                                }
                                _removeHiddenReasonOptions();
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          _dropdown(
                            label: 'Is the client disabled?',
                            value: _isDisabled,
                            options: yesNoOptions,
                            requiredField: true,
                            onChanged: (v) {
                              setState(() {
                                _isDisabled = v ?? '';
                                if (!_showGuardianOption &&
                                    _nextOfKinRelationship == 'GUARDIAN') {
                                  _nextOfKinRelationship = '';
                                }
                              });
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
                              validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'First name is required'
                                  : null,
                            ),
                            _Input(
                              controller: _clientSurnameController,
                              label: 'Surname',
                              hint: 'Client surname',
                              validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Surname is required'
                                  : null,
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
                                  validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Date of birth is required'
                                      : null,
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
                              setState(() {
                                _sex = v ?? '';
                                _removeHiddenReasonOptions();
                              });
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
                              validator: (v) =>
                              (_homeLanguage == 'OTHER' &&
                                  (v == null || v.trim().isEmpty))
                                  ? 'Please specify language'
                                  : null,
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
                  const SizedBox(height: 12),
                  MaterialCard(
                    body: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleRow(
                            color: primary,
                            title: 'Education',
                            subtitle:
                            'Capture school enrolment and attendance information.',
                            icon: Icons.school_outlined,
                          ),
                          const SizedBox(height: 12),
                          _dropdown(
                            label: 'Is the client in School?',
                            value: _isClientInSchool,
                            options: yesNoOptions,
                            requiredField: true,
                            onChanged: (v) {
                              setState(() {
                                _isClientInSchool = v ?? '';
                                _schoolAttendanceStatus = '';
                                if (_isClientInSchool != 'YES') {
                                  _schoolNameController.clear();
                                  _grade = '';
                                }
                              });
                            },
                          ),
                          if (_isClientInSchool == 'YES') ...[
                            const SizedBox(height: 10),
                            _Input(
                              controller: _schoolNameController,
                              label: 'Name of School',
                              hint: 'Enter school name',
                              validator: (v) =>
                              (_isClientInSchool == 'YES' &&
                                  (v == null || v.trim().isEmpty))
                                  ? 'School name is required'
                                  : null,
                            ),
                            if (!_isAdultOrElderly) ...[
                              const SizedBox(height: 10),
                              _dropdown(
                                label: 'Grade',
                                value: _grade,
                                options: gradeOptions,
                                requiredField: true,
                                onChanged: (v) {
                                  setState(() => _grade = v ?? '');
                                },
                              ),
                            ],
                            const SizedBox(height: 10),
                            _dropdown(
                              label: 'School attendance Status',
                              value: _schoolAttendanceStatus,
                              options: inSchoolAttendanceOptions,
                              requiredField: true,
                              onChanged: (v) {
                                setState(
                                        () => _schoolAttendanceStatus = v ?? '');
                              },
                            ),
                          ],
                          if (_isClientInSchool == 'NO') ...[
                            const SizedBox(height: 10),
                            _dropdown(
                              label: 'School attendance Status',
                              value: _schoolAttendanceStatus,
                              options: notInSchoolAttendanceOptions,
                              requiredField: true,
                              onChanged: (v) {
                                setState(
                                        () => _schoolAttendanceStatus = v ?? '');
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (_isAdultOrElderly) ...[
                    const SizedBox(height: 12),
                    MaterialCard(
                      body: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _titleRow(
                              color: primary,
                              title: 'Employment Information',
                              subtitle:
                              'Capture employment details for adult or elderly clients.',
                              icon: Icons.work_outline,
                            ),
                            const SizedBox(height: 12),
                            _dropdown(
                              label: 'Is the adult employed?',
                              value: _isAdultEmployed,
                              options: yesNoOptions,
                              requiredField: true,
                              onChanged: (v) {
                                setState(() {
                                  _isAdultEmployed = v ?? '';
                                  if (_isAdultEmployed != 'YES') {
                                    _employerNameController.clear();
                                  }
                                });
                              },
                            ),
                            if (_isAdultEmployed == 'YES') ...[
                              const SizedBox(height: 10),
                              _Input(
                                controller: _employerNameController,
                                label: 'Name of Employer',
                                hint: 'Enter employer name',
                                validator: (v) =>
                                (_isAdultEmployed == 'YES' &&
                                    (v == null || v.trim().isEmpty))
                                    ? 'Employer name is required'
                                    : null,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  MaterialCard(
                    body: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleRow(
                            color: primary,
                            title: 'Details of Next of Kin or Significant Other',
                            subtitle:
                            'Capture the main contact person linked to the client.',
                            icon: Icons.contact_phone_outlined,
                          ),
                          const SizedBox(height: 12),
                          _row2(
                            _Input(
                              controller: _nextOfKinFirstNameController,
                              label: 'First name',
                              hint: 'Next of kin first name',
                              validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'First name is required'
                                  : null,
                            ),
                            _Input(
                              controller: _nextOfKinSurnameController,
                              label: 'Surname',
                              hint: 'Next of kin surname',
                              validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Surname is required'
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _nextOfKinPhoneController,
                            label: 'Phone Number',
                            hint: 'e.g. 5xxxxxxx',
                            keyboardType: TextInputType.phone,
                            validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Phone number is required'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _nextOfKinPhysicalAddressController,
                            label: 'Physical Address',
                            hint: 'Describe physical address',
                            maxLines: 3,
                          ),
                          const SizedBox(height: 10),
                          _dropdown(
                            label: 'Relationship to Client',
                            value: _nextOfKinRelationship,
                            options: _nextOfKinRelationshipOptions(),
                            requiredField: true,
                            onChanged: (v) {
                              setState(() {
                                _nextOfKinRelationship = v ?? '';
                                if (_nextOfKinRelationship != 'OTHER') {
                                  _nextOfKinRelationshipOtherController.clear();
                                }
                              });
                            },
                          ),
                          if (_nextOfKinRelationshipIsOther) ...[
                            const SizedBox(height: 10),
                            _Input(
                              controller:
                              _nextOfKinRelationshipOtherController,
                              label: 'Specify other relationship',
                              hint: 'Enter relationship',
                              validator: (v) =>
                              (_nextOfKinRelationshipIsOther &&
                                  (v == null || v.trim().isEmpty))
                                  ? 'Please specify relationship'
                                  : null,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildReasonSection(primary),
                  const SizedBox(height: 12),
                  _buildEmergencyActionSection(primary),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

