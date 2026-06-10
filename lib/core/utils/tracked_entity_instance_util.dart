import 'package:lncmis_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:lncmis_mobile_app/core/constants/user_account_reference.dart';
import 'package:lncmis_mobile_app/core/offline_db/event_offline/event_offline_provider.dart';
import 'package:lncmis_mobile_app/core/services/user_service.dart';
import 'package:lncmis_mobile_app/core/utils/app_info_util.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:lncmis_mobile_app/core/utils/form_util.dart';
import 'package:lncmis_mobile_app/models/current_user.dart';
import 'package:lncmis_mobile_app/models/events.dart';
import 'package:lncmis_mobile_app/models/form_section.dart';

class TrackedEntityInstanceUtil {
  static Future savingTrackedEntityInstanceEventData(
    String? program,
    String? programStage,
    String? orgUnit,
    List<FormSection> formSections,
    Map? dataObject,
    String? eventDate,
    String? trackedEntityInstance,
    String? eventId,
    List<String>? hiddenFields, {
    List<String>? skippedFields,
  }) async {
    dataObject = dataObject ?? const {};
    hiddenFields = hiddenFields;
    skippedFields = skippedFields ?? [];
    List<String> inputFieldIds = FormUtil.getFormFieldIds(
      formSections,
    );
    String appAndDeviceTrackingDataElement =
        await AppInfoUtil.getAppAndDeviceTrackingInfo();
    inputFieldIds.addAll(hiddenFields ?? []);
    inputFieldIds.removeWhere((field) => skippedFields!.contains(field));
    inputFieldIds.add(UserAccountReference.implementingPartnerDataElement);
    inputFieldIds.add(UserAccountReference.subImplementingPartnerDataElement);
    inputFieldIds.add(UserAccountReference.serviceProviderDataElement);
    CurrentUser? user = await (UserService().getCurrentUser());
    dataObject[UserAccountReference.implementingPartnerDataElement] =
        dataObject[UserAccountReference.implementingPartnerDataElement] ??
            user!.implementingPartner;
    dataObject[UserAccountReference.serviceProviderDataElement] =
        dataObject[UserAccountReference.serviceProviderDataElement] ??
            user!.username;
    if (user!.subImplementingPartner != '') {
      dataObject[UserAccountReference.subImplementingPartnerDataElement] =
          dataObject[UserAccountReference.subImplementingPartnerDataElement] ??
              user.subImplementingPartner;
    }
    dataObject[UserAccountReference.appAndDeviceTrackingDataElement] =
        dataObject[UserAccountReference.appAndDeviceTrackingDataElement] ??
            appAndDeviceTrackingDataElement;
    inputFieldIds.add(UserAccountReference.appAndDeviceTrackingDataElement);
    eventId = eventId ?? dataObject['eventId'] ?? AppUtil.getUid();
    Events eventData = FormUtil.getEventPayload(eventId, program, programStage,
        orgUnit, inputFieldIds, dataObject, eventDate, trackedEntityInstance);
    await FormUtil.savingEvent(eventData);
  }

  static Future<List<Events>> getSavedTrackedEntityInstanceEventData(
    String? trackedEntityInstance, {
    List<String>? accessibleOrgUnits,
  }) async {
    accessibleOrgUnits = accessibleOrgUnits ?? [];
    List<Events> events = [];
    List<String?> trackedEntityInstanceIds = [];
    try {
      trackedEntityInstanceIds.add(trackedEntityInstance);
      events = await EventOfflineProvider().getTrackedEntityInstanceEvents(
        trackedEntityInstanceIds,
        accessibleOrgUnits: accessibleOrgUnits,
      );
    } catch (e) {
      //
    }
    return events.reversed.toList();
  }

  static List<Events> getAllEventListFromServiceDataStateByProgramStages(
    Map<String?, List<Events>> eventListByProgramStage,
    List<String?> programStageIds, {
    bool shouldSortByDate = false,
  }) {
    programStageIds = programStageIds.toSet().toList();
    List<Events> events = [];
    for (String? programStageId in programStageIds) {
      try {
        var data = eventListByProgramStage[programStageId] ?? [];
        events.addAll(data);
      } catch (e) {
        //
      }
    }
    return events.toList();
  }

  static List<Events> getAllEventListFromServiceDataState(
    Map<String?, List<Events>> eventListByProgramStage,
  ) {
    List<String?> programStageIds = eventListByProgramStage.keys.toList();
    List<Events> events = [];
    for (String? programStageId in programStageIds) {
      try {
        var data = eventListByProgramStage[programStageId] ?? [];
        events.addAll(data);
      } catch (e) {
        //
      }
    }
    return events.reversed.toList();
  }

  static Map<String, List<Events>> getGroupedEventByDates(List<Events> events) {
    Map<String, List<Events>> groupedEvents = {};
    List<String> eventDates = events
        .map((event) => event.eventDate!)
        .toSet()
        .toList()
      ..sort((b, a) => a.compareTo(b));
    for (String? eventDate in eventDates) {
      groupedEvents[eventDate!] =
          events.where((event) => event.eventDate == eventDate).toList();
    }
    return groupedEvents;
  }

  static String getEnrollmentSearchableValue(dynamic tei) {
    String searchableValue = "";
    try {
      var searchableAttributes = (tei['attributes'] ?? [])
          .map((attribute) {
            return [
              'WTZ7GLTrE8Q',
              's1HaiT6OllL',
              'rSP9c21JsfC',
              'VJiWumvINR6',
              UserAccountReference.implementingPartnerAttribute,
              BeneficiaryIdentification.beneficiaryId,
              BeneficiaryIdentification.primaryUIC,
              BeneficiaryIdentification.secondaryUIC,
            ].contains(attribute['attribute'])
                ? attribute['value']
                : '';
          })
          .where((value) => value.trim() != '')
          .toList();
      searchableValue = searchableAttributes.join(' ');
    } catch (e) {
      //
    }

    return searchableValue.toLowerCase();
  }
}
