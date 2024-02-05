import 'package:kb_mobile_app/core/offline_db/event_offline/event_offline_provider.dart';
import 'package:kb_mobile_app/models/case_plan_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_monitoring_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_provision_event.dart';
import 'package:kb_mobile_app/models/events.dart';

class OvcCasePlanService {
  Future<List<CasePlanEvent>> getCasePlanEvents({
    required String date,
    required String programStageId,
    required String teiId,
  }) async {
    List<Events> events =
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
    List<Events> events =
        await EventOfflineProvider().getEventByTeiByEventDateByProgramStage(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    return events
        .map(
            (eventData) => CasePlanGapEvent().toDataModel(eventData: eventData))
        .toList();
  }

  Future<List<CasePlanGapServiceProvisionEvent>>
      getCasePlanServiceProvisonEvents(
          {required String date,
          required String programStageId,
          required String teiId,
          required String casePlanGapToServiceProvisionLinkage}) async {
    List<Events> events =
        await EventOfflineProvider().getEventByTeiByEventDateByProgramStage(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    return events
        .map((eventData) => CasePlanGapServiceProvisionEvent()
            .toDataModel(eventData: eventData))
        .toList()
        .where((gapService) =>
            gapService.casePlanGapToServiceProvisionLinkage ==
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
    List<Events> events =
        await EventOfflineProvider().getEventByTeiByEventDateByProgramStage(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
    );
    return events
        .map((eventData) => CasePlanGapServiceMonitoringEvent()
            .toDataModel(eventData: eventData))
        .toList()
        .where((gapServiceMonitoring) =>
            gapServiceMonitoring.casePlanGapToServiceMonitoringLinkage ==
            casePlanGapToServiceMonitoringLinkage)
        .toList();
  }
}
