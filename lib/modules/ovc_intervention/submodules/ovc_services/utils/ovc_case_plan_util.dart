import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/case_plan_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_monitoring_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_provision_event.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

import '../../../services/ovc_case_plan_service.dart';

class OvcCasePlanUtil {
  static Map<String, List<Events>> getCasePlanByDates({
    required Map<String?, List<Events>> eventListByProgramStage,
    required List<String> programStageIds,
  }) {
    List<Events> events = TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(
            eventListByProgramStage, programStageIds);
    return TrackedEntityInstanceUtil.getGroupedEventByDates(events);
  }

  static bool hasAccessToEdit(List<Events> events) {
    return events.length ==
        events
            .where((Events event) => event.enrollmentOuAccessible!)
            .toList()
            .length;
  }


  /// Return ALL gap events for a given case-plan linkage, ignoring date windows.
  /// Used to deduplicate when saving (so previously-saved gaps from any day aren’t re-added).
  static Future<List<CasePlanGapEvent>> getCasePlanGapsForLinkage({
    required String teiId,
    required String programStageId,
    required String linkage,
  }) async {
    try {
      // Most builds of OvcCasePlanService filter by linkage if you pass it,
      // and ignore the date when you pass an empty ''.
      final gaps = await OvcCasePlanService().getCasePlanGapEvents(
        date: '', // <- intentionally blank to fetch across dates
        programStageId: programStageId,
        teiId: teiId,
        casePlanToGaps: [linkage],
      );
      return gaps;
    } catch (_) {
      return <CasePlanGapEvent>[];
    }
  }


  static Map getMappedCasePlanWithGapsByDomain({
    required List<Events> casePlanEvents,
    required List<Events> casePlanGapsEvents,
  }) {
    Map casePlanDataObject = {};
    for (Events casePlanEventData in casePlanEvents) {
      CasePlanEvent casePlanEvent =
          CasePlanEvent().toDataModel(eventData: casePlanEventData);
      String domainType = casePlanEvent.domainType!;
      Map casePlanObject = getMappedEventObject(casePlanEvent.eventData!);
      casePlanObject['gaps'] = casePlanGapsEvents
          .map(
            (Events casePlanGapEventData) =>
                CasePlanGapEvent().toDataModel(eventData: casePlanGapEventData),
          )
          .toList()
          .where((casePlanGapEvent) =>
              casePlanGapEvent.casePlanToGap == casePlanEvent.casePlanToGap)
          .toList()
          .map((casePlanGapEvent) =>
              getMappedEventObject(casePlanGapEvent.eventData!))
          .toList();
      casePlanDataObject[domainType] = casePlanObject;
    }
    return casePlanDataObject;
  }

  static Map getMappedEventObject(Events eventData) {
    Map map = {};
    map['eventDate'] = eventData.eventDate;
    map['eventId'] = eventData.event;
    map['location'] = eventData.orgUnit ?? '';
    for (Map dataValue in eventData.dataValues) {
      if ('${dataValue['value']}'.trim() != '') {
        map[dataValue['dataElement']] = dataValue['value'];
      }
    }
    return map;
  }

  static String getLocationFromCasePlanForm(Map dataObject, String sectionsId) {
    Map locationSection = dataObject[sectionsId] ?? {};
    return locationSection['location'] ?? '';
  }

  static bool isLocationOnCasePlanFormFilled(
    Map dataObject, {
    required String sectionsId,
    required bool shouldCheck,
  }) {
    bool hasBeenFilled = true;
    if (shouldCheck) {
      hasBeenFilled =
          getLocationFromCasePlanForm(dataObject, sectionsId).isNotEmpty;
    }
    return hasBeenFilled;
  }

  static String getCasePlanDateFromCasePlanForm(
    Map dataObject,
    String sectionsId,
  ) {
    Map casePlanDateSection = dataObject[sectionsId] ?? {};
    return casePlanDateSection['eventDate'] ?? '';
  }

  static bool isCasePlanDateOnCasePlanFormFilled(
    Map dataObject, {
    required String sectionsId,
  }) {
    return getCasePlanDateFromCasePlanForm(dataObject, sectionsId).isNotEmpty;
  }

  static bool isAllDomainGoalAndGapFilled(
    Map dataObject, {
    required bool isHouseholdCasePlan,
  }) {
    bool isAllDomainFilled = true;
    for (String? domainType in dataObject.keys.toList()) {
      Map domainDataObject = dataObject[domainType] ?? {};
      String casePlanFirstGoal =
          domainDataObject[OvcCasePlanConstant.casePlanFirstGoal] ?? '';
      String casePlansSecondGoal =
          domainDataObject[OvcCasePlanConstant.casePlansSecondGoal] ?? '';

      if (domainDataObject.keys.contains('gaps') &&
          domainDataObject['gaps'].length > 0) {
        if (casePlanFirstGoal.isEmpty) {
          if (casePlansSecondGoal.isEmpty) {
            isAllDomainFilled = false;
          }
        }
      } else if (isHouseholdCasePlan &&
          domainType == OvcCasePlanConstant.casePlanDomainType) {
        String houseHoldCategorization = domainDataObject[
                OvcCasePlanConstant.houseHoldCategorizationDataElement] ??
            '';
        if (houseHoldCategorization.isEmpty) {
          isAllDomainFilled = false;
        }
      }
    }
    return isAllDomainFilled;
  }

  static List<CasePlanGapServiceProvisionEvent>
      getCasePlanGapServiceProvisionEvents({
    required Map<String?, List<Events>> eventListByProgramStage,
    required List<String> programStageIds,
    required String casePlanGapToServiceProvisionLinkage,
  }) {
    List<Events> events = TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(
            eventListByProgramStage, programStageIds);
    return events
        .map((eventData) => CasePlanGapServiceProvisionEvent()
            .toDataModel(eventData: eventData))
        .toList()
        .where((casePlanService) =>
            casePlanService.casePlanGapToServiceProvisionLinkage ==
            casePlanGapToServiceProvisionLinkage)
        .toList();
  }

  static List<CasePlanGapServiceMonitoringEvent>
      getCasePlanGapServiceMonitoringEvents({
    required Map<String?, List<Events>> eventListByProgramStage,
    required List<String> programStageIds,
    required String casePlanGapToServiceMonitoringLinkage,
  }) {
    List<Events> events = TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(
            eventListByProgramStage, programStageIds);
    return events
        .map((eventData) => CasePlanGapServiceMonitoringEvent()
            .toDataModel(eventData: eventData))
        .toList()
        .where((casePlanService) =>
            casePlanService.casePlanGapToServiceMonitoringLinkage ==
            casePlanGapToServiceMonitoringLinkage)
        .toList();
  }
}
