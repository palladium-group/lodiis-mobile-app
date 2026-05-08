
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/models/mgysd_case.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/pages/mgysd_care_plan_page.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/pages/mgysd_initial_risk_assessment_page.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/pages/mgysd_social_investigation_page.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/pages/mgysd_service_provision_page.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/pages/mgysd_referral_page.dart';
import 'package:sqflite/sqflite.dart';

class MgysdCaseDetailPage extends StatefulWidget {
  const MgysdCaseDetailPage({
    Key? key,
    required this.color,
    required this.mgysdCase,
  }) : super(key: key);

  final Color color;
  final MgysdCase mgysdCase;

  @override
  State<MgysdCaseDetailPage> createState() => _MgysdCaseDetailPageState();
}

class _HouseholdMember {
  final String tei;
  final String role;
  final bool isPrimaryClient;
  final String firstName;
  final String lastName;
  final String phone;
  final String dob;

  const _HouseholdMember({
    required this.tei,
    required this.role,
    required this.isPrimaryClient,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.dob,
  });

  String get fullName {
    final fn = firstName.trim();
    final ln = lastName.trim();
    final full = ('$fn $ln').trim();
    return full.isEmpty ? '(No name)' : full;
  }
}

class _HouseholdInfo {
  final String tei;
  final String code;
  final String name;
  final String district;
  final String village;
  final String address;

  const _HouseholdInfo({
    required this.tei,
    required this.code,
    required this.name,
    required this.district,
    required this.village,
    required this.address,
  });

  bool get hasAnyData =>
      code.trim().isNotEmpty ||
          name.trim().isNotEmpty ||
          district.trim().isNotEmpty ||
          village.trim().isNotEmpty ||
          address.trim().isNotEmpty;
}

class _CaseDetailData {
  final _HouseholdInfo? household;
  final List<_HouseholdMember> householdMembers;
  final _HouseholdMember? primaryClient;
  final String initialRiskStatus;
  final String socialInvestigationStatus;
  final String carePlanStatus;
  final String monitoringStatus;
  final String referralStatus;
  final String serviceProvisionStatus;

  const _CaseDetailData({
    required this.household,
    required this.householdMembers,
    required this.primaryClient,
    required this.initialRiskStatus,
    required this.socialInvestigationStatus,
    required this.carePlanStatus,
    required this.monitoringStatus,
    required this.referralStatus,
    required this.serviceProvisionStatus,
  });
}

class _MgysdCaseDetailPageState extends State<MgysdCaseDetailPage> {
  late Future<_CaseDetailData> _detailFuture;
  int _selectedSection = 0;

  static const String attFirstName = 'ATTR_FIRSTNAME';
  static const String attLastName = 'ATTR_LASTNAME';
  static const String attDob = 'ATTR_DOB';
  static const String attPhone = 'ATTR_PHONE';

  static const String legacyAttPersonFirstName = 'ATTR_P_FIRSTNAME';
  static const String legacyAttPersonLastName = 'ATTR_P_LASTNAME';
  static const String legacyAttPersonDob = 'ATTR_P_DOB';
  static const String legacyAttPersonPhone = 'ATTR_P_PHONE';

  static const String attHouseholdCode = 'ATTR_HOUSEHOLD_CODE';
  static const String attHouseholdName = 'ATTR_HOUSEHOLD_NAME';
  static const String attHouseholdDistrict = 'ATTR_HOUSEHOLD_DISTRICT';
  static const String attHouseholdVillage = 'ATTR_HOUSEHOLD_VILLAGE';
  static const String attHouseholdAddress = 'ATTR_HOUSEHOLD_ADDRESS';

  @override
  void initState() {
    super.initState();
    _detailFuture = _loadCaseDetailData();
  }

  Future<Database> _db() async {
    final dbClient = await OfflineDbProvider().db;
    if (dbClient == null) {
      throw Exception('Offline DB not initialized');
    }
    return dbClient;
  }

  String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  String _prettyRole(String role) {
    switch (role.toUpperCase()) {
      case 'CLIENT':
        return 'Client';
      case 'MOTHER':
        return 'Mother';
      case 'FATHER':
        return 'Father';
      case 'CAREGIVER':
        return 'Caregiver';
      case 'GUARDIAN':
        return 'Guardian';
      case 'SIBLING':
        return 'Sibling';
      case 'SPOUSE':
        return 'Spouse';
      case 'CHILD':
        return 'Child';
      case 'OTHER_RELATIVE':
        return 'Other relative';
      case 'HOUSEHOLD_MEMBER':
        return 'Household member';
      default:
        return role.replaceAll('_', ' ').trim();
    }
  }

  Future<String?> _getHouseholdTeiFromEnrollment(Database db) async {
    final rows = await db.query(
      'enrollment',
      columns: ['trackedEntityInstance'],
      where: 'enrollment = ?',
      whereArgs: [widget.mgysdCase.id],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    final tei = (rows.first['trackedEntityInstance'] ?? '').toString().trim();
    return tei.isEmpty ? null : tei;
  }

  Future<Map<String, String>> _getAttributes(Database db, String tei) async {
    final rows = await db.query(
      'tracked_entity_instance_attribute',
      columns: ['attribute', 'value'],
      where: 'trackedEntityInstance = ?',
      whereArgs: [tei],
    );

    final Map<String, String> map = {};
    for (final r in rows) {
      final k = (r['attribute'] ?? '').toString();
      final v = (r['value'] ?? '').toString();
      if (k.isNotEmpty && v.isNotEmpty) {
        map[k] = v;
      }
    }
    return map;
  }

  String _readFirstName(Map<String, String> attrs) {
    return attrs[attFirstName] ?? attrs[legacyAttPersonFirstName] ?? '';
  }

  String _readLastName(Map<String, String> attrs) {
    return attrs[attLastName] ?? attrs[legacyAttPersonLastName] ?? '';
  }

  String _readPhone(Map<String, String> attrs) {
    return attrs[attPhone] ?? attrs[legacyAttPersonPhone] ?? '';
  }

  String _readDob(Map<String, String> attrs) {
    return attrs[attDob] ?? attrs[legacyAttPersonDob] ?? '';
  }

  Future<_HouseholdInfo?> _loadHousehold(Database db, String householdTei) async {
    final attrs = await _getAttributes(db, householdTei);

    return _HouseholdInfo(
      tei: householdTei,
      code: attrs[attHouseholdCode] ?? '',
      name: attrs[attHouseholdName] ?? '',
      district: attrs[attHouseholdDistrict] ?? '',
      village: attrs[attHouseholdVillage] ?? '',
      address: attrs[attHouseholdAddress] ?? '',
    );
  }

  Future<List<_HouseholdMember>> _loadHouseholdMembers(
      Database db,
      String householdTei,
      ) async {
    final List<_HouseholdMember> members = [];

    final helperRows = await db.query(
      'mgysd_household_member',
      columns: ['memberTei', 'memberRole', 'isPrimaryClient'],
      where: 'householdTei = ?',
      whereArgs: [householdTei],
    );

    for (final row in helperRows) {
      final memberTei = (row['memberTei'] ?? '').toString().trim();
      if (memberTei.isEmpty) continue;

      final attrs = await _getAttributes(db, memberTei);
      final role = (row['memberRole'] ?? '').toString().trim();
      final isPrimaryClient =
          (row['isPrimaryClient'] ?? '').toString().toLowerCase() == 'true' ||
              role.toUpperCase() == 'CLIENT';

      members.add(
        _HouseholdMember(
          tei: memberTei,
          role: role,
          isPrimaryClient: isPrimaryClient,
          firstName: _readFirstName(attrs),
          lastName: _readLastName(attrs),
          phone: _readPhone(attrs),
          dob: _readDob(attrs),
        ),
      );
    }

    members.sort((a, b) {
      if (a.isPrimaryClient && !b.isPrimaryClient) return -1;
      if (!a.isPrimaryClient && b.isPrimaryClient) return 1;
      return a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
    });

    return members;
  }

  Future<String> _readFormStatus(
      Database db,
      String tableName,
      String caseId,
      ) async {
    try {
      final rows = await db.query(
        tableName,
        columns: ['status'],
        where: 'id = ?',
        whereArgs: [caseId],
        limit: 1,
      );
      if (rows.isEmpty) return 'NOT_STARTED';
      return (rows.first['status'] ?? 'NOT_STARTED').toString();
    } catch (_) {
      return 'NOT_STARTED';
    }
  }

  Future<_CaseDetailData> _loadCaseDetailData() async {
    final db = await _db();
    final householdTei = await _getHouseholdTeiFromEnrollment(db);

    final initialRiskStatus = await _readFormStatus(
      db,
      'mgysd_initial_risk_assessment',
      widget.mgysdCase.id,
    );

    final socialInvestigationStatus = await _readFormStatus(
      db,
      'mgysd_social_investigation',
      widget.mgysdCase.id,
    );

    final carePlanStatus = await _readFormStatus(
      db,
      'mgysd_care_plan',
      widget.mgysdCase.id,
    );

    final monitoringStatus = await _readFormStatus(
      db,
      'mgysd_monitoring',
      widget.mgysdCase.id,
    );

    final referralStatus = await _readFormStatus(
      db,
      'mgysd_referral',
      widget.mgysdCase.id,
    );

    final serviceProvisionStatus = await _readFormStatus(
      db,
      'mgysd_service_provision',
      widget.mgysdCase.id,
    );

    if (householdTei == null) {
      return _CaseDetailData(
        household: null,
        householdMembers: const [],
        primaryClient: null,
        initialRiskStatus: initialRiskStatus,
        socialInvestigationStatus: socialInvestigationStatus,
        carePlanStatus: carePlanStatus,
        monitoringStatus: monitoringStatus,
        referralStatus: referralStatus,
        serviceProvisionStatus: serviceProvisionStatus,
      );
    }

    final household = await _loadHousehold(db, householdTei);
    final householdMembers = await _loadHouseholdMembers(db, householdTei);

    _HouseholdMember? primaryClient;
    try {
      primaryClient = householdMembers.firstWhere(
            (m) => m.isPrimaryClient || m.role.toUpperCase() == 'CLIENT',
      );
    } catch (_) {
      primaryClient =
      householdMembers.isNotEmpty ? householdMembers.first : null;
    }

    return _CaseDetailData(
      household: household,
      householdMembers: householdMembers,
      primaryClient: primaryClient,
      initialRiskStatus: initialRiskStatus,
      socialInvestigationStatus: socialInvestigationStatus,
      carePlanStatus: carePlanStatus,
      monitoringStatus: monitoringStatus,
      referralStatus: referralStatus,
      serviceProvisionStatus: serviceProvisionStatus,
    );
  }

  Future<void> _refreshAll() async {
    setState(() {
      _detailFuture = _loadCaseDetailData();
    });
    await _detailFuture;
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return Colors.green;
      case 'DRAFT':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return 'Completed';
      case 'DRAFT':
        return 'Draft';
      default:
        return 'Not started';
    }
  }

  bool _isCompleted(String status) => status.toUpperCase() == 'COMPLETED';

  void _showBlockedMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openInitialRiskAssessment(_CaseDetailData data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MgysdInitialRiskAssessmentPage(
          color: widget.color,
          mgysdCase: widget.mgysdCase,
          householdTei: data.household?.tei,
          householdName: data.household?.name,
          clientName: data.primaryClient?.fullName,
        ),
      ),
    );
    await _refreshAll();
  }

  Future<void> _openSocialInvestigation(_CaseDetailData data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MgysdSocialInvestigationPage(
          color: widget.color,
          mgysdCase: widget.mgysdCase,
          householdTei: data.household?.tei,
          householdName: data.household?.name,
          clientName: data.primaryClient?.fullName,
        ),
      ),
    );
    await _refreshAll();
  }

  Future<void> _openCarePlan(_CaseDetailData data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MgysdCarePlanPage(
          color: widget.color,
          mgysdCase: widget.mgysdCase,
          householdTei: data.household?.tei,
          householdName: data.household?.name,
          clientName: data.primaryClient?.fullName,
        ),
      ),
    );
    await _refreshAll();
  }

  Future<void> _openServiceProvision(_CaseDetailData data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MgysdServiceProvisionPage(
          color: widget.color,
          mgysdCase: widget.mgysdCase,
          householdTei: data.household?.tei,
          householdName: data.household?.name,
          clientName: data.primaryClient?.fullName,
        ),
      ),
    );
    await _refreshAll();
  }

  void _showPlaceholder(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title (placeholder)')),
    );
  }

  Widget _badge(String text, {bool highlighted = false}) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    final bg = highlighted
        ? widget.color.withOpacity(0.14)
        : Colors.blueGrey.withOpacity(0.07);
    final border = highlighted
        ? widget.color.withOpacity(0.22)
        : Colors.blueGrey.withOpacity(0.10);
    final fg = highlighted ? widget.color : Colors.blueGrey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    if (v.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              k,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              v,
              style: const TextStyle(height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _surfaceCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(14),
        child: child,
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12.5,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _sectionChip(String label, int index) {
    final bool selected = _selectedSection == index;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: widget.color.withOpacity(0.15),
      labelStyle: TextStyle(
        color: selected ? widget.color : Colors.black87,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      onSelected: (_) {
        setState(() {
          _selectedSection = index;
        });
      },
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberCard(_HouseholdMember m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: widget.color.withOpacity(0.12),
            child: Icon(
              m.isPrimaryClient
                  ? Icons.person_pin_circle
                  : Icons.person_outline,
              color: widget.color,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.fullName,
                  style: const TextStyle(
                    fontSize: 14.8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _badge(_prettyRole(m.role), highlighted: m.isPrimaryClient),
                    if (m.isPrimaryClient)
                      _badge('Primary Client', highlighted: true),
                    if (m.dob.trim().isNotEmpty) _badge('DOB: ${m.dob}'),
                  ],
                ),
                if (m.phone.trim().isNotEmpty) ...[
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          m.phone,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blueGrey,
          height: 1.35,
        ),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required VoidCallback onTap,
  }) {
    final color = _statusColor(status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: widget.color.withOpacity(0.12),
                child: Icon(icon, color: widget.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            _statusLabel(status),
                            style: TextStyle(
                              color: color,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: widget.color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaseDetailsSection(_CaseDetailData data) {
    final opened = widget.mgysdCase.parsedEnrollmentDate != null
        ? _formatDate(widget.mgysdCase.parsedEnrollmentDate!)
        : '';

    final caseDisplayName =
    (data.primaryClient?.fullName ?? widget.mgysdCase.fullName).trim();

    return Column(
      children: [
        _surfaceCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: widget.color.withOpacity(0.14),
                child: Icon(
                  Icons.folder_shared_outlined,
                  color: widget.color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caseDisplayName.isEmpty
                          ? widget.mgysdCase.caseNo
                          : caseDisplayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _badge(widget.mgysdCase.displayStatus, highlighted: true),
                        if ((data.household?.district ?? widget.mgysdCase.district)
                            .trim()
                            .isNotEmpty)
                          _badge(
                            data.household?.district ??
                                widget.mgysdCase.district,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _kv('Case No', widget.mgysdCase.caseNo),
                    _kv('Opened Date', opened),
                    if ((data.primaryClient?.phone ?? '').trim().isNotEmpty)
                      _kv('Phone', data.primaryClient!.phone.trim()),
                  ],
                ),
              ),
            ],
          ),
        ),
        _surfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                'Progress Summary',
                'Quick view of the current case progress',
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _summaryCard(
                    title: 'Initial Risk',
                    value: _statusLabel(data.initialRiskStatus),
                    icon: Icons.shield_outlined,
                    color: _statusColor(data.initialRiskStatus),
                  ),
                  const SizedBox(width: 10),
                  _summaryCard(
                    title: 'Investigation',
                    value: _statusLabel(data.socialInvestigationStatus),
                    icon: Icons.fact_check_outlined,
                    color: _statusColor(data.socialInvestigationStatus),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _summaryCard(
                    title: 'Care Plan',
                    value: _statusLabel(data.carePlanStatus),
                    icon: Icons.assignment_outlined,
                    color: _statusColor(data.carePlanStatus),
                  ),
                  const SizedBox(width: 10),
                  _summaryCard(
                    title: 'Monitoring',
                    value: _statusLabel(data.monitoringStatus),
                    icon: Icons.monitor_heart_outlined,
                    color: _statusColor(data.monitoringStatus),
                  ),
                ],
              ),
            ],
          ),
        ),
        _surfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                'Quick Actions',
                'Open the main case steps from here',
              ),
              const SizedBox(height: 10),
              _actionTile(
                icon: Icons.shield_outlined,
                title: 'Initial Risk Assessment',
                subtitle:
                'Assess immediate safety concerns and urgent actions.',
                status: data.initialRiskStatus,
                onTap: () => _openInitialRiskAssessment(data),
              ),
              Divider(height: 1, color: Colors.blueGrey.withOpacity(0.12)),
              _actionTile(
                icon: Icons.fact_check_outlined,
                title: 'Social Investigation',
                subtitle: 'Document the detailed social work investigation.',
                status: data.socialInvestigationStatus,
                onTap: () => _openSocialInvestigation(data),
              ),
              Divider(height: 1, color: Colors.blueGrey.withOpacity(0.12)),
              _actionTile(
                icon: Icons.assignment_outlined,
                title: 'Care Plan',
                subtitle: 'Create and manage the intervention plan.',
                status: data.carePlanStatus,
                onTap: () {
                  if (_isCompleted(data.socialInvestigationStatus)) {
                    _openCarePlan(data);
                  } else {
                    _showBlockedMessage(
                      'Complete Social Investigation first before opening Care Plan.',
                    );
                  }
                },
              ),

              Divider(height: 1, color: Colors.blueGrey.withOpacity(0.12)),
              _actionTile(
                icon: Icons.volunteer_activism_outlined,
                title: 'Service Provision',
                subtitle: 'Capture services provided to the client.',
                status: data.serviceProvisionStatus,
                onTap: () => _openServiceProvision(data),
              ),

              Divider(height: 1, color: Colors.blueGrey.withOpacity(0.12)),
              _actionTile(
                icon: Icons.handshake_outlined,
                title: 'Referral',
                subtitle: 'Link the client or household to needed services.',
                status: data.referralStatus,
                onTap: () async {
                  if (_isCompleted(data.socialInvestigationStatus)) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MgysdReferralPage(
                          color: widget.color,
                          mgysdCase: widget.mgysdCase,
                          householdTei: data.household?.tei,
                          householdName: data.household?.name,
                          clientName: data.primaryClient?.fullName,
                        ),
                      ),
                    );
                    await _refreshAll();
                  } else {
                    _showBlockedMessage(
                      'Complete Social Investigation first before opening Referral.',
                    );
                  }
                },

              ),
              Divider(height: 1, color: Colors.blueGrey.withOpacity(0.12)),
              _actionTile(
                icon: Icons.monitor_heart_outlined,
                title: 'Monitoring',
                subtitle: 'Follow up on progress and review support over time.',
                status: data.monitoringStatus,
                onTap: () {
                  if (_isCompleted(data.socialInvestigationStatus)) {
                    _showPlaceholder('Monitoring');
                  } else {
                    _showBlockedMessage(
                      'Complete Social Investigation first before opening Monitoring.',
                    );
                  }
                },
              ),



            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHouseholdDetailsSection(_CaseDetailData data) {
    return Column(
      children: [
        _surfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                'Household',
                'Registered household information',
              ),
              const SizedBox(height: 12),
              if (data.household == null || !data.household!.hasAnyData)
                _emptyBox('No household information linked yet.')
              else ...[
                _kv('Code', data.household!.code),
                _kv('Name', data.household!.name),
                _kv('District', data.household!.district),
                _kv('Village', data.household!.village),
                _kv('Address', data.household!.address),
              ],
            ],
          ),
        ),
        _surfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                'Household Members',
                '${data.householdMembers.length} member${data.householdMembers.length == 1 ? '' : 's'}',
              ),
              const SizedBox(height: 12),
              if (data.householdMembers.isEmpty)
                _emptyBox('No household members found.')
              else
                Column(
                  children: data.householdMembers.map(_memberCard).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedSection(_CaseDetailData data) {
    switch (_selectedSection) {
      case 1:
        return _buildHouseholdDetailsSection(data);
      default:
        return _buildCaseDetailsSection(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.color,
        title: Text(widget.mgysdCase.caseNo),
        actions: [
          IconButton(
            onPressed: _refreshAll,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAll,
        child: FutureBuilder<_CaseDetailData>(
          future: _detailFuture,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 140),
                  Center(child: CircularProgressIndicator()),
                  SizedBox(height: 14),
                  Center(
                    child: Text(
                      'Loading case details...',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                ],
              );
            }

            if (snap.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  _surfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Failed to load case detail',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snap.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            final data = snap.data ??
                const _CaseDetailData(
                  household: null,
                  householdMembers: [],
                  primaryClient: null,
                  initialRiskStatus: 'NOT_STARTED',
                  socialInvestigationStatus: 'NOT_STARTED',
                  carePlanStatus: 'NOT_STARTED',
                  serviceProvisionStatus: 'NOT_STARTED',
                  monitoringStatus: 'NOT_STARTED',
                  referralStatus: 'NOT_STARTED',
                );

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _sectionChip('Case Details', 0),
                    _sectionChip('Household Details', 1),
                  ],
                ),
                const SizedBox(height: 14),
                _buildSelectedSection(data),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}
