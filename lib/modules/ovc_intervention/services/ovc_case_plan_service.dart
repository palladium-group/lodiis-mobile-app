

import 'package:kb_mobile_app/core/offline_db/event_offline/event_offline_provider.dart';
import 'package:kb_mobile_app/models/case_plan_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_monitoring_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_provision_event.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

extension _SafeStr on Object? {
  String get s => (this ?? '').toString();

  DateTime? parseUtc(String t) {}
}

extension _AsDate on String {
  DateTime? get asDate {
    final t = trim();
    if (t.isEmpty) return null;
    const fmts = [
      'yyyy-MM-dd',
      "yyyy-MM-dd'T'HH:mm:ss",
      "yyyy-MM-dd HH:mm:ss",
    ];
    for (final f in fmts) {
      try {
        return DateTime.tryParse(f)!.parseUtc(t);
      } catch (_) {}
    }
    return DateTime.tryParse(t);
  }
}

class OvcCasePlanService {
  Future<List<CasePlanEvent>> getCasePlanEvents({
    required String date,
    required String programStageId,
    required String teiId,
  }) async {
    final events =
    await EventOfflineProvider().getEventByTeiByEventDateByProgramStage(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    return events
        .map((eventData) => CasePlanEvent().toDataModel(eventData: eventData))
        .toList();
  }

  Future<List<CasePlanGapEvent>> getCasePlanGapEvents({
    required String date,
    required String programStageId,
    required String teiId,
    required List casePlanToGaps,
  }) async {
    final events =
    await EventOfflineProvider().getEventByTeiByEventDateByProgramStage(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    return events
        .map(
          (eventData) => CasePlanGapEvent().toDataModel(eventData: eventData),
    )
        .toList();
  }

  Future<List<CasePlanGapServiceProvisionEvent>>
  getCasePlanServiceProvisonEvents({
    required String date,
    required String programStageId,
    required String teiId,
    required String casePlanGapToServiceProvisionLinkage,
  }) async {
    final events =
    await EventOfflineProvider().getEventByTeiByEventDateByProgramStage(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    return events
        .map((eventData) => CasePlanGapServiceProvisionEvent()
        .toDataModel(eventData: eventData))
        .where((m) =>
    (m.casePlanGapToServiceProvisionLinkage ?? '') ==
        casePlanGapToServiceProvisionLinkage)
        .toList();
  }

  Future<List<CasePlanGapServiceMonitoringEvent>>
  getCasePlanServiceMonitoringEvents({
    required String date,
    required String programStageId,
    required String teiId,
    required String casePlanGapToServiceMonitoringLinkage,
  }) async {
    final events =
    await EventOfflineProvider().getEventByTeiByEventDateByProgramStage(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    return events
        .map((eventData) => CasePlanGapServiceMonitoringEvent()
        .toDataModel(eventData: eventData))
        .where((m) =>
    (m.casePlanGapToServiceMonitoringLinkage ?? '') ==
        casePlanGapToServiceMonitoringLinkage)
        .toList();
  }

  // ----------------------------------------------------------------------------
  // NEW: list ALL monitoring events for the same CP (and domain) from CP date,
  // using getTrackedEntityInstanceEvents() since provider has no "by stage" API
  // ----------------------------------------------------------------------------
  Future<List<CasePlanGapServiceMonitoringEvent>>
  getCasePlanServiceMonitoringEventsForCpSinceDate({
    required String teiId,
    required String programStageId, // HH or Child MON stage
    required String cpLinkage,      // OvcCasePlanConstant.casePlanToGapLinkage
    required String domainId,       // 'Health' | 'Safe' | 'Stable' | 'Schooled'
    required String fromDate,       // casePlanDate or CP eventDate
  }) async {
    // 1) read ALL events for this TEI
    final allForTei =
    await EventOfflineProvider().getTrackedEntityInstanceEvents([teiId]);

    // 2) filter by stage first
    final stageEvents =
    allForTei.where((e) => (e.programStage ?? '') == programStageId).toList();

    // Debug: raw load
    // ignore: avoid_print
    print('[MON Service] RAW events read: tei="$teiId" stage="$programStageId" total=${stageEvents.length}');

    final from = fromDate.s.asDate ?? DateTime.fromMillisecondsSinceEpoch(0);
    final monStable = '$cpLinkage|$domainId';

    int matched = 0, skipped = 0, badDate = 0, emptyCp = 0;

    final list = <CasePlanGapServiceMonitoringEvent>[];
    for (final ev in stageEvents) {
      final model = CasePlanGapServiceMonitoringEvent().toDataModel(eventData: ev);

      // date gate (>= CP date)
      final d = model.eventData!.eventDate.s.asDate;
      if (d == null) {
        badDate++;
        continue;
      }
      if (d.isBefore(from)) {
        skipped++;
        continue;
      }

      // linkage checks
      final cp = model.casePlanGapToServiceMonitoringLinkage.s;
      final mon = model.casePlanGapToServiceMonitoringLinkage.s;

      if (cp.isEmpty && mon.isEmpty) {
        emptyCp++;
        continue;
      }

      final ok = (cp == cpLinkage) || (mon == monStable);
      if (!ok) {
        skipped++;
        continue;
      }

      matched++;
      list.add(model);
    }

    list.sort((a, b) => b.eventData!.eventDate.s.compareTo(a.eventData!.eventDate.s));

    // Debug: filter result
    // ignore: avoid_print
    print('[MON Service] FILTER result for cp="$cpLinkage": matched=$matched, emptyCp=$emptyCp, skipped=$skipped');
    // ignore: avoid_print
    print('[MON Service] FINAL list for cp="$cpLinkage": count=${list.length}');

    return list;
  }
}
