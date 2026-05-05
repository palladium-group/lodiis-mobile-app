
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/pages/mgysd_new_case_page.dart';
import 'package:sqflite/sqflite.dart';

class MgysdRecordsPage extends StatefulWidget {
  const MgysdRecordsPage({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  State<MgysdRecordsPage> createState() => _MgysdRecordsPageState();
}

enum _RecordsFilter { all, reportedOnly, enrolledOnly }

class _OfflineReportedCase {
  final String dbRowId; // events.id
  final String eventId; // events.event
  final String? eventDate;
  final String? program;
  final String? programStage;

  // extracted from event_data_value (by dataElement)
  final String clientFirstName;
  final String clientLastName;
  final String clientPhone;
  final String clientSex;
  final String clientDistrict;
  final String caseType;
  final String concernReason;
  final String incidentDate;

  // link info
  final bool isEnrolled;
  final String? linkedTei;
  final String? linkedEnrollment;

  const _OfflineReportedCase({
    required this.dbRowId,
    required this.eventId,
    required this.eventDate,
    required this.program,
    required this.programStage,
    required this.clientFirstName,
    required this.clientLastName,
    required this.clientPhone,
    required this.clientSex,
    required this.clientDistrict,
    required this.caseType,
    required this.concernReason,
    required this.incidentDate,
    required this.isEnrolled,
    required this.linkedTei,
    required this.linkedEnrollment,
  });

  String get displayName {
    final fn = clientFirstName.trim();
    final ln = clientLastName.trim();
    final full = ('$fn $ln').trim();
    return full.isEmpty ? '(No client name)' : full;
  }
}

class _MgysdRecordsPageState extends State<MgysdRecordsPage> {
  late Future<List<_OfflineReportedCase>> _future;
  _RecordsFilter _filter = _RecordsFilter.all;

  // ✅ READ FROM BOTH STAGE + PROGRAM
  // Replace these with real DHIS2 IDs you are using for MGYSD report event program/stage
  static const String mgysdReportProgramUid = 'MGYSD_REPORT_EVENT_PROGRAM_UID';
  static const String mgysdReportStageUid = 'MGYSD_REPORT_STAGE_UID';

  // ---------------------------
  // Map your report form DEs here (replace anytime)
  // ---------------------------
  static const String deClientFirstName = 'wOIx1Tism5p';
  static const String deClientLastName = 'mclj3oLRpiv';
  static const String deClientPhone = 'hxxH8RmZrV2';
  static const String deClientSex = 'kwL1QEdrChg';
  static const String deClientDistrict = 'DE_CLIENT_LOCATION';
  static const String deCaseType = 'DE_CASE_TYPE';
  static const String deConcernReason = 'UJIrqEgPMn1';
  static const String deWhenHappened = 'DE_WHEN_HAPPENED';

  @override
  void initState() {
    super.initState();
    _future = _loadReportedCases();
  }

  Future<Database> _db() async {
    final dbClient = await OfflineDbProvider().db;
    if (dbClient == null) {
      throw Exception('Offline DB not initialized');
    }
    return dbClient;
  }

  Future<Map<String, String>> _loadEventDataValuesAsMap(Database db, String eventId) async {
    final rows = await db.query(
      'event_data_value',
      columns: ['dataElement', 'value'],
      where: 'event = ?',
      whereArgs: [eventId],
    );

    final Map<String, String> map = {};
    for (final r in rows) {
      final de = (r['dataElement'] ?? '').toString();
      final val = (r['value'] ?? '').toString();
      if (de.isNotEmpty && val.isNotEmpty) {
        map[de] = val;
      }
    }
    return map;
  }

  Future<Map<String, Map<String, String>>> _loadLinksByReportEvent(Database db) async {
    // returns map[reportEvent] = {tei:..., enrollment:...}
    final rows = await db.query(
      'mgysd_report_intake_link',
      columns: ['reportEvent', 'tei', 'enrollment'],
    );

    final Map<String, Map<String, String>> links = {};
    for (final r in rows) {
      final reportEvent = (r['reportEvent'] ?? '').toString();
      if (reportEvent.isEmpty) continue;
      links[reportEvent] = {
        'tei': (r['tei'] ?? '').toString(),
        'enrollment': (r['enrollment'] ?? '').toString(),
      };
    }
    return links;
  }

  Future<List<_OfflineReportedCase>> _loadReportedCases() async {
    final db = await _db();

    // load links once
    final links = await _loadLinksByReportEvent(db);

    // ✅ FROM BOTH: stage OR program
    final eventRows = await db.query(
      'events',
      where: '(programStage = ?) OR (program = ?)',
      whereArgs: [mgysdReportStageUid, mgysdReportProgramUid],
      orderBy: 'eventDate DESC',
    );

    final List<_OfflineReportedCase> list = [];

    for (final row in eventRows) {
      final dbRowId = (row['id'] ?? '').toString();
      final eventId = (row['event'] ?? '').toString();
      final eventDate = row['eventDate']?.toString();
      final program = row['program']?.toString();
      final programStage = row['programStage']?.toString();

      if (eventId.isEmpty) continue;

      final dv = await _loadEventDataValuesAsMap(db, eventId);

      final link = links[eventId];
      final isEnrolled = link != null;

      list.add(
        _OfflineReportedCase(
          dbRowId: dbRowId,
          eventId: eventId,
          eventDate: eventDate,
          program: program,
          programStage: programStage,
          clientFirstName: (dv[deClientFirstName] ?? ''),
          clientLastName: (dv[deClientLastName] ?? ''),
          clientPhone: (dv[deClientPhone] ?? ''),
          clientSex: (dv[deClientSex] ?? ''),
          clientDistrict: (dv[deClientDistrict] ?? ''),
          caseType: (dv[deCaseType] ?? ''),
          concernReason: (dv[deConcernReason] ?? ''),
          incidentDate: (dv[deWhenHappened] ?? ''),
          isEnrolled: isEnrolled,
          linkedTei: link?['tei'],
          linkedEnrollment: link?['enrollment'],
        ),
      );
    }

    return list;
  }

  Future<void> _refresh() async {
    setState(() => _future = _loadReportedCases());
  }

  List<_OfflineReportedCase> _applyFilter(List<_OfflineReportedCase> items) {
    switch (_filter) {
      case _RecordsFilter.reportedOnly:
        return items.where((e) => e.isEnrolled == false).toList();
      case _RecordsFilter.enrolledOnly:
        return items.where((e) => e.isEnrolled == true).toList();
      case _RecordsFilter.all:
      default:
        return items;
    }
  }

  void _openEnrollForm(_OfflineReportedCase c) async {
    if (c.isEnrolled) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MgysdNewCasePage(
          color: widget.color,
          reportedEventId: c.eventId,
          prefillClientFirstName: c.clientFirstName,
          prefillClientLastName: c.clientLastName,
          prefillClientPhone: c.clientPhone,
          prefillCaseType: c.caseType,
          prefillIncidentDate: c.incidentDate,
        ),
      ),
    );

    _refresh();
  }

  Widget _badge(String text, {Color? color}) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    final c = color ?? widget.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: c,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _filterBar() {
    Widget chip(String label, _RecordsFilter v) {
      final selected = _filter == v;
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _filter = v),
        selectedColor: widget.color.withOpacity(0.18),
        labelStyle: TextStyle(
          color: selected ? widget.color : Colors.blueGrey,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: widget.color.withOpacity(0.25)),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          chip('All', _RecordsFilter.all),
          chip('Reported', _RecordsFilter.reportedOnly),
          chip('Enrolled', _RecordsFilter.enrolledOnly),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<_OfflineReportedCase>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                MaterialCard(
                  body: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      'Failed to load MGYSD records:\n${snap.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            );
          }

          final all = snap.data ?? [];
          final items = _applyFilter(all);

          if (all.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Text(
                  'No MGYSD records found offline yet.\n\nSubmit a report first, then come back here.',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ],
            );
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _filterBar(),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${items.length} of ${all.length} records',
                  style: const TextStyle(color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 10),

              ...items.map((c) {
                final enrolledColor = c.isEnrolled ? Colors.green : widget.color;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                  child: MaterialCard(
                    body: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // header
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: enrolledColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  c.isEnrolled ? Icons.verified_outlined : Icons.report_outlined,
                                  color: enrolledColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.displayName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Event: ${c.eventId}',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.blueGrey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              _badge(
                                c.isEnrolled ? 'ENROLLED' : 'REPORTED',
                                color: enrolledColor,
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _badge(c.caseType),
                              _badge(c.concernReason),
                              _badge(c.clientDistrict),
                              _badge(c.eventDate ?? ''),
                            ],
                          ),

                          if (c.clientPhone.trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16, color: Colors.blueGrey),
                                const SizedBox(width: 6),
                                Text(
                                  c.clientPhone,
                                  style: const TextStyle(color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ],

                          if (c.isEnrolled && (c.linkedTei ?? '').trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Linked TEI: ${c.linkedTei}',
                              style: const TextStyle(color: Colors.blueGrey, fontSize: 12.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: c.isEnrolled ? null : () => _openEnrollForm(c),
                                  icon: Icon(Icons.how_to_reg, color: widget.color),
                                  label: Text(
                                    c.isEnrolled ? 'Already Enrolled' : 'Enroll Case',
                                    style: TextStyle(
                                      color: c.isEnrolled ? Colors.blueGrey : widget.color,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: widget.color.withOpacity(0.5)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
