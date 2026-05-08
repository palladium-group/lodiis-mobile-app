
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/mgysd_case_management_list_state/mgysd_case_management_list_state.dart';
import 'package:kb_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/models/mgysd_case.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/pages/mgysd_case_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class MgysdCaseListPage extends StatefulWidget {
  const MgysdCaseListPage({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  State<MgysdCaseListPage> createState() => _MgysdCaseListPageState();
}

class _MgysdCaseListPageState extends State<MgysdCaseListPage> {
  final TextEditingController _searchController = TextEditingController();

  List<MgysdCase> _cases = [];
  List<MgysdCase> _filtered = [];
  bool _loading = true;

  static const String mgysdCaseManagementProgramId =
      'MGYSD_CASE_MANAGEMENT_PROGRAM';

  static const String attFirstName = 'ATTR_FIRSTNAME';
  static const String attLastName = 'ATTR_LASTNAME';
  static const String attPhone = 'ATTR_PHONE';
  static const String attClientCategory = 'ATTR_CLIENT_CATEGORY';
  static const String attSex = 'ATTR_SEX';
  static const String attAge = 'ATTR_AGE';

  static const String attHouseholdFileNumber = 'ATTR_HOUSEHOLD_FILE_NUMBER';
  static const String attHouseholdDistrict = 'ATTR_HOUSEHOLD_DISTRICT';
  static const String attHouseholdVillage = 'ATTR_HOUSEHOLD_VILLAGE';

  static const String legacyAttPersonFirstName = 'ATTR_P_FIRSTNAME';
  static const String legacyAttPersonLastName = 'ATTR_P_LASTNAME';
  static const String legacyAttPersonPhone = 'ATTR_P_PHONE';

  @override
  void initState() {
    super.initState();
    _loadEnrolledCases();

    Future.microtask(() {
      Provider.of<MgysdCaseManagementListState>(context, listen: false)
          .refreshMgysdCasesNumber();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<Database> _db() async {
    final dbClient = await OfflineDbProvider().db;
    if (dbClient == null) throw Exception('Offline DB not initialized');
    return dbClient;
  }

  Future<Map<String, String>> _loadTeiAttributes(
      Database db,
      String teiId,
      ) async {
    final rows = await db.query(
      'tracked_entity_instance_attribute',
      columns: ['attribute', 'value'],
      where: 'trackedEntityInstance = ?',
      whereArgs: [teiId],
    );

    final Map<String, String> map = {};
    for (final row in rows) {
      final att = (row['attribute'] ?? '').toString();
      final val = (row['value'] ?? '').toString();
      if (att.isNotEmpty) map[att] = val;
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

  Future<String?> _getHouseholdForClient(Database db, String clientTei) async {
    final rows = await db.query(
      'mgysd_household_member',
      columns: ['householdTei', 'memberTei', 'memberRole', 'isPrimaryClient'],
      where: 'memberTei = ?',
      whereArgs: [clientTei],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final householdTei = (rows.first['householdTei'] ?? '').toString().trim();
    return householdTei.isEmpty ? null : householdTei;
  }

  String _prettyClientCategory(String value) {
    switch (value.toUpperCase()) {
      case 'CHILD':
        return 'Child';
      case 'ADULT_ELDERLY_PERSON':
        return 'Adult / Elderly';
      default:
        return value;
    }
  }

  Future<void> _loadEnrolledCases() async {
    setState(() => _loading = true);

    final db = await _db();

    final enrollmentRows = await db.query(
      'enrollment',
      where: 'program = ?',
      whereArgs: [mgysdCaseManagementProgramId],
      orderBy: 'enrollmentDate DESC',
    );

    final List<MgysdCase> list = [];

    for (final row in enrollmentRows) {
      final enrollmentId = (row['enrollment'] ?? '').toString().trim();
      final clientTei = (row['trackedEntityInstance'] ?? '').toString().trim();
      final status = (row['status'] ?? 'ACTIVE').toString().trim();
      final enrollmentDate = (row['enrollmentDate'] ?? '').toString().trim();

      if (enrollmentId.isEmpty || clientTei.isEmpty) continue;

      final clientAttrs = await _loadTeiAttributes(db, clientTei);

      final firstName = _readFirstName(clientAttrs).trim();
      final lastName = _readLastName(clientAttrs).trim();
      final phone = _readPhone(clientAttrs).trim();
      final category =
      _prettyClientCategory((clientAttrs[attClientCategory] ?? '').trim());
      final sex = (clientAttrs[attSex] ?? '').trim();
      final age = (clientAttrs[attAge] ?? '').trim();

      String fullName = ('$firstName $lastName').trim();
      if (fullName.isEmpty) fullName = '(No client name)';

      final householdTei = await _getHouseholdForClient(db, clientTei);
      String district = '';
      String village = '';
      String fileNumber = '';

      if (householdTei != null && householdTei.isNotEmpty) {
        final householdAttrs = await _loadTeiAttributes(db, householdTei);
        district = (householdAttrs[attHouseholdDistrict] ?? '').trim();
        village = (householdAttrs[attHouseholdVillage] ?? '').trim();
        fileNumber = (householdAttrs[attHouseholdFileNumber] ?? '').trim();
      }

      final displayCaseNo = fileNumber.isNotEmpty ? fileNumber : enrollmentId;

      list.add(
        MgysdCase(
          id: enrollmentId,
          caseNo: displayCaseNo,
          fullName: fullName,
          district: district,
          status: status,
          phone: phone,
          enrollmentDate: enrollmentDate,
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      _cases = list;
      _filtered = list;
      _loading = false;
    });
  }

  Future<void> _refresh() async {
    await _loadEnrolledCases();
    if (!mounted) return;
    Provider.of<MgysdCaseManagementListState>(context, listen: false)
        .refreshMgysdCasesNumber();
  }

  void _filter(String q) {
    final query = q.trim().toLowerCase();

    setState(() {
      _filtered = query.isEmpty
          ? _cases
          : _cases.where((c) {
        return c.caseNo.toLowerCase().contains(query) ||
            c.fullName.toLowerCase().contains(query) ||
            c.district.toLowerCase().contains(query) ||
            c.status.toLowerCase().contains(query) ||
            (c.phone ?? '').toLowerCase().contains(query);
      }).toList();
    });
  }

  void _openCase(MgysdCase mgysdCase) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MgysdCaseDetailPage(
          color: widget.color,
          mgysdCase: mgysdCase,
        ),
      ),
    );
  }

  void _onAddCase() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Use "Report Case" or "Enroll Client Case" workflow'),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'Open';
      case 'COMPLETED':
        return 'Closed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Widget _statusChip(String status) {
    final label = _statusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: widget.color.withOpacity(0.20)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: widget.color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blueGrey),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: TextField(
        controller: _searchController,
        onChanged: _filter,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.search, color: widget.color),
          suffixIcon: _searchController.text.trim().isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
              _filter('');
            },
            icon: const Icon(Icons.close),
          )
              : null,
          hintText: 'Search client cases',
          hintStyle: const TextStyle(color: Colors.blueGrey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.18)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.18)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: widget.color, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSummary() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: widget.color.withOpacity(0.08),
        border: Border.all(color: widget.color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: widget.color.withOpacity(0.14),
            child: Icon(Icons.folder_shared_outlined, color: widget.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Client Case Management',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_filtered.length} case${_filtered.length == 1 ? '' : 's'} shown',
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _refresh,
            icon: Icon(Icons.refresh, color: widget.color),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 120),
        Center(child: CircularProgressIndicator()),
        SizedBox(height: 16),
        Center(
          child: Text(
            'Loading client cases...',
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 80),
        CircleAvatar(
          radius: 34,
          backgroundColor: widget.color.withOpacity(0.10),
          child: Icon(
            Icons.folder_open,
            size: 32,
            color: widget.color,
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'No client cases found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Pull down to refresh or create a new client case intake.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaseCard(MgysdCase item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Material(
        color: Colors.white,
        elevation: 1.2,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _openCase(item),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: widget.color.withOpacity(0.12),
                  child: Icon(
                    Icons.person_outline,
                    color: widget.color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.fullName,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'File / Case: ${item.caseNo}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _statusChip(item.status),
                          if (item.district.trim().isNotEmpty)
                            _infoChip(Icons.place_outlined, item.district),
                          if ((item.phone ?? '').trim().isNotEmpty)
                            _infoChip(Icons.phone_outlined, item.phone!.trim()),
                          if (item.enrollmentDate!.trim().isNotEmpty)
                            _infoChip(
                              Icons.event_outlined,
                              item.enrollmentDate!.trim(),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.blueGrey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.color,
        onPressed: _onAddCase,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            _buildSearchBox(),
            _buildHeaderSummary(),
            Expanded(
              child: _loading
                  ? _buildLoadingState()
                  : _filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 90, top: 4),
                itemCount: _filtered.length,
                itemBuilder: (_, index) {
                  return _buildCaseCard(_filtered[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
