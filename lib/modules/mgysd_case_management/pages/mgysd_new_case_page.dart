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

class _FamilyMemberDraft {
  final String localId;

  String relationshipCode;

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController phone = TextEditingController();

  String sexCode;
  bool livesInHousehold;

  DateTime? selectedDob;

  _FamilyMemberDraft({
    required this.localId,
    this.relationshipCode = '',
    this.sexCode = '',
    this.livesInHousehold = true,
  });

  void dispose() {
    firstName.dispose();
    lastName.dispose();
    dob.dispose();
    phone.dispose();
  }

  bool get hasAnyData =>
      firstName.text.trim().isNotEmpty ||
          lastName.text.trim().isNotEmpty ||
          dob.text.trim().isNotEmpty ||
          phone.text.trim().isNotEmpty ||
          relationshipCode.trim().isNotEmpty ||
          sexCode.trim().isNotEmpty;

  String get displayName {
    final fn = firstName.text.trim();
    final ln = lastName.text.trim();
    final full = ('$fn $ln').trim();
    return full.isEmpty ? '(No name)' : full;
  }

  String get memberRole {
    switch (relationshipCode) {
      case 'CLIENT_HAS_MOTHER':
        return 'MOTHER';
      case 'CLIENT_HAS_FATHER':
        return 'FATHER';
      case 'CLIENT_HAS_CAREGIVER':
        return 'CAREGIVER';
      case 'CLIENT_HAS_GUARDIAN':
        return 'GUARDIAN';
      case 'CLIENT_HAS_SIBLING':
        return 'SIBLING';
      case 'CLIENT_HAS_SPOUSE':
        return 'SPOUSE';
      case 'CLIENT_HAS_CHILD':
        return 'CHILD';
      case 'CLIENT_HAS_OTHER_RELATIVE':
        return 'OTHER_RELATIVE';
      default:
        return 'HOUSEHOLD_MEMBER';
    }
  }
}

class _MgysdNewCasePageState extends State<MgysdNewCasePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _caseIdController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientSurnameController = TextEditingController();
  final TextEditingController _clientDobController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _caseTypeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final TextEditingController _householdCodeController =
  TextEditingController();
  final TextEditingController _householdNameController =
  TextEditingController();
  final TextEditingController _householdDistrictController =
  TextEditingController();
  final TextEditingController _householdVillageController =
  TextEditingController();
  final TextEditingController _householdAddressController =
  TextEditingController();

  DateTime? _selectedDob;
  bool _saving = false;

  // ----------------------------
  // DHIS2 placeholders
  // ----------------------------
  static const String mgysdTrackerProgramId = 'MGYSD_TRACKER_PROGRAM';

  static const String mgysdHouseholdTeiTypeId = 'MGYSD_HOUSEHOLD_TEI_TYPE';
  static const String mgysdPersonTeiTypeId = 'MGYSD_PERSON_TEI_TYPE';

  // Person attributes (shared by client + household members)
  static const String attFirstName = 'ATTR_FIRSTNAME';
  static const String attLastName = 'ATTR_LASTNAME';
  static const String attDob = 'ATTR_DOB';
  static const String attPhone = 'ATTR_PHONE';
  static const String attSex = 'ATTR_SEX';

// ✅ aliases for household members
  static const String attPersonFirstName = attFirstName;
  static const String attPersonLastName = attLastName;
  static const String attPersonDob = attDob;
  static const String attPersonPhone = attPhone;

  // Household attributes
  static const String attHouseholdCode = 'ATTR_HOUSEHOLD_CODE';
  static const String attHouseholdName = 'ATTR_HOUSEHOLD_NAME';
  static const String attHouseholdDistrict = 'ATTR_HOUSEHOLD_DISTRICT';
  static const String attHouseholdVillage = 'ATTR_HOUSEHOLD_VILLAGE';
  static const String attHouseholdAddress = 'ATTR_HOUSEHOLD_ADDRESS';

  // Relationship types
  static const String relHouseholdHasMember = 'HOUSEHOLD_HAS_MEMBER';

  static const List<_Opt> relationshipOptions = [
    _Opt('CLIENT_HAS_MOTHER', 'Mother'),
    _Opt('CLIENT_HAS_FATHER', 'Father'),
    _Opt('CLIENT_HAS_CAREGIVER', 'Caregiver'),
    _Opt('CLIENT_HAS_GUARDIAN', 'Guardian'),
    _Opt('CLIENT_HAS_SIBLING', 'Sibling'),
    _Opt('CLIENT_HAS_SPOUSE', 'Spouse'),
    _Opt('CLIENT_HAS_CHILD', 'Child'),
    _Opt('CLIENT_HAS_OTHER_RELATIVE', 'Other relative'),
  ];

  static const List<_Opt> sexOptions = [
    _Opt('MALE', 'Male'),
    _Opt('FEMALE', 'Female'),
  ];

  final List<_FamilyMemberDraft> _family = [];

  @override
  void initState() {
    super.initState();

    _clientNameController.text = (widget.prefillClientFirstName ?? '').trim();
    _clientSurnameController.text = (widget.prefillClientLastName ?? '').trim();
    _contactController.text = (widget.prefillClientPhone ?? '').trim();
    _caseTypeController.text = (widget.prefillCaseType ?? '').trim();

    final incident = (widget.prefillIncidentDate ?? '').trim();
    if (incident.isNotEmpty) {
      _notesController.text = 'Incident date: $incident\n';
    }

    _caseIdController.text = 'MGYSD-${DateTime.now().millisecondsSinceEpoch}';
    _householdCodeController.text =
    'HH-${DateTime.now().millisecondsSinceEpoch}';
    _householdNameController.text =
    '${_clientNameController.text} ${_clientSurnameController.text}'
        .trim()
        .isEmpty
        ? ''
        : '${_clientNameController.text} ${_clientSurnameController.text} Household';
  }

  @override
  void dispose() {
    _caseIdController.dispose();
    _clientNameController.dispose();
    _clientSurnameController.dispose();
    _clientDobController.dispose();
    _contactController.dispose();
    _caseTypeController.dispose();
    _notesController.dispose();

    _householdCodeController.dispose();
    _householdNameController.dispose();
    _householdDistrictController.dispose();
    _householdVillageController.dispose();
    _householdAddressController.dispose();

    for (final f in _family) {
      f.dispose();
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
        _clientDobController.text = AppUtil.formattedDateTimeIntoString(picked);
      });
    }
  }

  Future<void> _pickDobForFamily(_FamilyMemberDraft m) async {
    final now = DateTime.now();
    final initial = m.selectedDob ?? DateTime(now.year - 20, 1, 1);
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      initialDate: initial,
    );
    if (picked != null) {
      setState(() {
        m.selectedDob = picked;
        m.dob.text = AppUtil.formattedDateTimeIntoString(picked);
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

  bool _validateFamilyMembers() {
    for (final m in _family) {
      if (!m.hasAnyData) continue;

      if (m.relationshipCode.trim().isEmpty) {
        AppUtil.showToastMessage(
          message: 'Please select relationship for a family member.',
        );
        return false;
      }

      if (m.firstName.text.trim().isEmpty || m.lastName.text.trim().isEmpty) {
        AppUtil.showToastMessage(
          message: 'Please enter first & last name for a family member.',
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _saveCase() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (!_validateFamilyMembers()) return;

    setState(() => _saving = true);

    try {
      final db = await _db();
      final orgUnit = '';

      final householdTeiId = 'TEI_${_newId()}';
      final householdEnrollmentId = 'ENR_${_newId()}';
      final clientTeiId = 'TEI_${_newId()}';

      // 1. Save household TEI
      await _saveTeiOffline(
        db: db,
        teiId: householdTeiId,
        teiTypeId: mgysdHouseholdTeiTypeId,
        orgUnit: orgUnit,
      );

      await _saveAttrOffline(
        db: db,
        teiId: householdTeiId,
        attribute: attHouseholdCode,
        value: _householdCodeController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: householdTeiId,
        attribute: attHouseholdName,
        value: _householdNameController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: householdTeiId,
        attribute: attHouseholdDistrict,
        value: _householdDistrictController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: householdTeiId,
        attribute: attHouseholdVillage,
        value: _householdVillageController.text,
      );
      await _saveAttrOffline(
        db: db,
        teiId: householdTeiId,
        attribute: attHouseholdAddress,
        value: _householdAddressController.text,
      );

      // 2. Enroll household in MGYSD case management
      final searchableValue = (widget.reportedEventId ?? '').trim().isNotEmpty
          ? 'reportEvent:${widget.reportedEventId}'
          : '';

      await _saveEnrollmentOffline(
        db: db,
        enrollmentId: householdEnrollmentId,
        teiId: householdTeiId,
        orgUnit: orgUnit,
        searchableValue: searchableValue,
      );

      // 3. Link report -> household case
      final reportEventId = (widget.reportedEventId ?? '').trim();
      if (reportEventId.isNotEmpty) {
        await _saveLinkToReportEvent(
          db: db,
          reportEventId: reportEventId,
          teiId: householdTeiId,
          enrollmentId: householdEnrollmentId,
        );
      }

      // 4. Save client as person TEI
      await _saveTeiOffline(
        db: db,
        teiId: clientTeiId,
        teiTypeId: mgysdPersonTeiTypeId,
        orgUnit: orgUnit,
      );

      await _saveAttrOffline(
        db: db,
        teiId: clientTeiId,
        attribute: attFirstName,
        value: _clientNameController.text,
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
        attribute: attPhone,
        value: _contactController.text,
      );

      // 5. Save client as household member
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

      // 6. Save family members
      for (final m in _family) {
        if (!m.hasAnyData) continue;

        final personTeiId = 'TEI_${_newId()}';

        await _saveTeiOffline(
          db: db,
          teiId: personTeiId,
          teiTypeId: mgysdPersonTeiTypeId,
          orgUnit: orgUnit,
        );

        await _saveAttrOffline(
          db: db,
          teiId: personTeiId,
          attribute: attPersonFirstName,
          value: m.firstName.text,
        );
        await _saveAttrOffline(
          db: db,
          teiId: personTeiId,
          attribute: attPersonLastName,
          value: m.lastName.text,
        );
        await _saveAttrOffline(
          db: db,
          teiId: personTeiId,
          attribute: attPersonDob,
          value: m.dob.text,
        );
        await _saveAttrOffline(
          db: db,
          teiId: personTeiId,
          attribute: attPersonPhone,
          value: m.phone.text,
        );
        await _saveAttrOffline(
          db: db,
          teiId: personTeiId,
          attribute: attSex,
          value: m.sexCode,
        );

        await _saveHouseholdMemberOffline(
          db: db,
          householdTei: householdTeiId,
          memberTei: personTeiId,
          memberRole: m.memberRole,
          isPrimaryClient: false,
        );

        if (m.livesInHousehold) {
          await _saveRelationshipOffline(
            db: db,
            relationshipTypeCode: relHouseholdHasMember,
            fromTei: householdTeiId,
            toTei: personTeiId,
          );
        }
      }

      AppUtil.showToastMessage(
        message: widget.reportedEventId == null
            ? 'Household case and members saved offline.'
            : 'Household case and members saved + linked to report.',
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      AppUtil.showToastMessage(message: 'Failed to save case: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _addFamilyMember() {
    setState(() {
      _family.add(_FamilyMemberDraft(localId: _newId()));
    });
  }

  void _removeFamilyMember(String localId) {
    setState(() {
      final idx = _family.indexWhere((x) => x.localId == localId);
      if (idx >= 0) {
        _family[idx].dispose();
        _family.removeAt(idx);
      }
    });
  }

  Widget _titleRow({
    required Color color,
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
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
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 12.5),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _familyMemberCard({
    required _FamilyMemberDraft m,
    required Color primary,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.12)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  m.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () => _removeFamilyMember(m.localId),
                icon: const Icon(Icons.delete_outline),
                color: Colors.redAccent,
                tooltip: 'Remove',
              )
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: m.relationshipCode.isEmpty ? null : m.relationshipCode,
            items: relationshipOptions
                .map(
                  (o) => DropdownMenuItem<String>(
                value: o.code,
                child: Text(o.label, overflow: TextOverflow.ellipsis),
              ),
            )
                .toList(),
            onChanged: (v) => setState(() => m.relationshipCode = (v ?? '')),
            decoration: InputDecoration(
              labelText: 'Relationship to client',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _Input(
                  controller: m.firstName,
                  label: 'First name',
                  hint: 'e.g. Mary',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Input(
                  controller: m.lastName,
                  label: 'Last name',
                  hint: 'e.g. Maieane',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDobForFamily(m),
                  child: AbsorbPointer(
                    child: _Input(
                      controller: m.dob,
                      label: 'Date of Birth',
                      hint: 'Pick date',
                      suffixIcon: const Icon(Icons.date_range),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: m.sexCode.isEmpty ? null : m.sexCode,
                  items: sexOptions
                      .map(
                        (o) => DropdownMenuItem<String>(
                      value: o.code,
                      child: Text(o.label),
                    ),
                  )
                      .toList(),
                  onChanged: (v) => setState(() => m.sexCode = (v ?? '')),
                  decoration: InputDecoration(
                    labelText: 'Sex',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Input(
            controller: m.phone,
            label: 'Phone (optional)',
            hint: 'e.g. 5xxxxxxx',
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            value: m.livesInHousehold,
            onChanged: (v) => setState(() => m.livesInHousehold = v),
            activeColor: primary,
            contentPadding: EdgeInsets.zero,
            title: const Text('Lives in this household'),
          ),
        ],
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
          label: widget.reportedEventId == null ? 'New Household Case' : 'Enroll Household Case',
          activeInterventionProgram: activeInterventionProgram,
          disableSelectionOfActiveIntervention: false,
        ),
      ),
      body: SubPageBody(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
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
                            title: 'Case Details',
                            subtitle: 'Household case information',
                            icon: Icons.folder_open,
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _caseIdController,
                            label: 'Case ID (placeholder)',
                            hint: 'e.g. MGYSD-0001',
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Case ID is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _caseTypeController,
                            label: 'Case Type (placeholder)',
                            hint: 'e.g. Child Protection / GBV / Social Assistance',
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Case type is required';
                              }
                              return null;
                            },
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
                            title: 'Primary Client',
                            subtitle: 'Main beneficiary in this household case',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _clientNameController,
                            label: 'Client Name',
                            hint: 'First name',
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Client name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _clientSurnameController,
                            label: 'Client Surname',
                            hint: 'Surname',
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Client surname is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: _pickDobForClient,
                            child: AbsorbPointer(
                              child: _Input(
                                controller: _clientDobController,
                                label: 'Date of Birth',
                                hint: 'Pick date',
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Date of birth is required';
                                  }
                                  return null;
                                },
                                suffixIcon: const Icon(Icons.date_range),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _contactController,
                            label: 'Contact Number',
                            hint: 'e.g. 5xxxxxxx',
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
                            title: 'Household Details',
                            subtitle: 'Household registry information',
                            icon: Icons.home_outlined,
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _householdCodeController,
                            label: 'Household Code',
                            hint: 'e.g. HH-0001',
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Household code is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _householdNameController,
                            label: 'Household Name',
                            hint: 'e.g. Mokoena Household',
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Household name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _householdDistrictController,
                            label: 'District',
                            hint: 'e.g. Maseru',
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _householdVillageController,
                            label: 'Village',
                            hint: 'e.g. Ha Ts\'osane',
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _householdAddressController,
                            label: 'Address / Description',
                            hint: 'Short household address...',
                            maxLines: 2,
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
                            title: 'Household Members',
                            subtitle: 'Add mother, father, siblings, caregiver, etc.',
                            icon: Icons.group_outlined,
                            trailing: TextButton.icon(
                              onPressed: _addFamilyMember,
                              icon: Icon(Icons.add, color: primary),
                              label: Text(
                                'Add',
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (_family.isEmpty)
                            const Text(
                              'No household members added yet.',
                              style: TextStyle(color: Colors.blueGrey),
                            )
                          else
                            Column(
                              children: _family
                                  .map(
                                    (m) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _familyMemberCard(
                                    m: m,
                                    primary: primary,
                                  ),
                                ),
                              )
                                  .toList(),
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
                            title: 'Notes',
                            subtitle: 'Optional household case notes',
                            icon: Icons.notes_outlined,
                          ),
                          const SizedBox(height: 10),
                          _Input(
                            controller: _notesController,
                            label: 'Notes (placeholder)',
                            hint: 'Short notes...',
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  EntryFormSaveButton(
                    marginLeft: 20.0,
                    marginRight: 20.0,
                    label: _saving ? 'Saving...' : 'Save Household Case',
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
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
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