
import 'package:kb_mobile_app/core/offline_db/event_offline/event_offline_provider.dart';

import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/case_plan_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_provision_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_monitoring_event.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

class OvcCasePlanService {
  OvcCasePlanService();

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<List<Events>> _fetchByTeiStageAndMaybeDate({
    required String date,
    required String programStageId,
    required String teiId,
  }) async {
    // When date == '' return ALL events for the TEI + stage (no date filter)
    if (date.trim().isEmpty) {
      return EventOfflineProvider().getEventByTeiByEventDateByProgramStage(date: date, programStageId: programStageId, teiId: teiId);
         //.getEventByTeiAndProgramStage(teiId: teiId, programStageId: programStageId);
    }
    return EventOfflineProvider().getEventByTeiByEventDateByProgramStage(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
  }

  // ---------------------------------------------------------------------------
  // Case Plan (container) events
  // ---------------------------------------------------------------------------

  Future<List<CasePlanEvent>> getCasePlanEvents({
    required String date,
    required String programStageId,
    required String teiId,
  }) async {
    final events = await _fetchByTeiStageAndMaybeDate(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    return events
        .map((e) => CasePlanEvent().toDataModel(eventData: e))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // GAP events
  // ---------------------------------------------------------------------------

  /// NOTE: `casePlanToGaps` is historically unused in this app build, we keep the
  /// signature for backwards compatibility.
  Future<List<CasePlanGapEvent>> getCasePlanGapEvents({
    required String date,
    required String programStageId,
    required String teiId,
    required List casePlanToGaps,
  }) async {
    final events = await _fetchByTeiStageAndMaybeDate(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    return events
        .map((e) => CasePlanGapEvent().toDataModel(eventData: e))
        .toList();
  }

  /// All GAP events for a specific Case Plan linkage (cpLink).
  Future<List<CasePlanGapEvent>> getCasePlanGapEventsForCp({
    required String date, // '' => all
    required String programStageId,
    required String teiId,
    required String casePlanToGapLinkage,
  }) async {
    final list = await getCasePlanGapEvents(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
      casePlanToGaps: const [],
    );
    final cp = casePlanToGapLinkage.trim();
    return list
        .where((m) => (m.casePlanGapToServiceMonitoring ?? '').toString().trim() == cp)
        .toList();
  }

  // ---------------------------------------------------------------------------
  // SERVICE PROVISION events
  // ---------------------------------------------------------------------------

  /// Legacy method: filters by SP linkage (casePlanGapToServiceProvisionLinkage).
  Future<List<CasePlanGapServiceProvisionEvent>> getCasePlanServiceProvisonEvents({
    required String date,
    required String programStageId,
    required String teiId,
    required String casePlanGapToServiceProvisionLinkage,
  }) async {
    final events = await _fetchByTeiStageAndMaybeDate(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    final models = events
        .map((e) => CasePlanGapServiceProvisionEvent().toDataModel(eventData: e))
        .toList();
    final link = casePlanGapToServiceProvisionLinkage.trim();
    return models
        .where((m) => (m.casePlanGapToServiceProvisionLinkage ?? '')
        .toString()
        .trim() ==
        link)
        .toList();
  }

  /// New convenience: list all services for a given Case Plan (via cpLink)
  /// We filter by the **CP** (OvcCasePlanConstant.casePlanToGapLinkage),
  /// not the SP linkage.
  Future<List<CasePlanGapServiceProvisionEvent>> getCasePlanServiceProvisionEventsForCp({
    required String date, // '' => all
    required String programStageId,
    required String teiId,
    required String casePlanToGapLinkage,
  }) async {
    final events = await _fetchByTeiStageAndMaybeDate(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    final models = events
        .map((e) => CasePlanGapServiceProvisionEvent().toDataModel(eventData: e))
        .toList();

    final cp = casePlanToGapLinkage.trim();
    final cpDe = OvcCasePlanConstant.casePlanToGapLinkage;

    // Some model classes may not expose cp directly; fallback to raw dataValues if needed.
    return models.where((m) {
      // First try the explicit field
      final fromModel = (m.casePlanGapToServiceProvisionLinkage ?? '').toString().trim();
      if (fromModel.isNotEmpty) return fromModel == cp;

      // Fallback: check raw map if present
      final raw = m.toDataObject();
      final rawCp = (raw[cpDe] ?? '').toString().trim();
      return rawCp == cp;
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // MONITORING events
  // ---------------------------------------------------------------------------

  /// Legacy method: filters by MON linkage (casePlanGapToServiceMonitoringLinkage).
  Future<List<CasePlanGapServiceMonitoringEvent>> getCasePlanServiceMonitoringEvents({
    required String date,
    required String programStageId,
    required String teiId,
    required String casePlanGapToServiceMonitoringLinkage,
  }) async {
    final events = await _fetchByTeiStageAndMaybeDate(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    final models = events
        .map((e) => CasePlanGapServiceMonitoringEvent().toDataModel(eventData: e))
        .toList();
    final link = casePlanGapToServiceMonitoringLinkage.trim();
    return models
        .where((m) => (m.casePlanGapToServiceMonitoringLinkage ?? '')
        .toString()
        .trim() ==
        link)
        .toList();
  }

  /// New convenience: list **all monitoring events for the same Case Plan** (cpLink).
  /// This is what your UI wants when it says: “show all monitoring for this CP”.
  Future<List<CasePlanGapServiceMonitoringEvent>> getCasePlanServiceMonitoringEventsForCp({
    required String date, // '' => all
    required String programStageId,
    required String teiId,
    required String casePlanToGapLinkage,
  }) async {
    final events = await _fetchByTeiStageAndMaybeDate(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    final models = events
        .map((e) => CasePlanGapServiceMonitoringEvent().toDataModel(eventData: e))
        .toList();

    final cp = casePlanToGapLinkage.trim();
    final cpDe = OvcCasePlanConstant.casePlanToGapLinkage;

    // Filter by CP linkage (not by MON linkage)
    return models.where((m) {
      // Prefer explicit field on the model if it exists
      final fromModel = (m.casePlanGapToServiceMonitoringLinkage ?? '').toString().trim();
      if (fromModel.isNotEmpty) return fromModel == cp;

      // Fallback to raw map if needed
      final raw = m.toDataObject();
      final rawCp = (raw[cpDe] ?? '').toString().trim();
      return rawCp == cp;
    }).toList();
  }
}

