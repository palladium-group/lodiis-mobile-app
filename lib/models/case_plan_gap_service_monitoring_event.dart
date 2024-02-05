import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

class CasePlanGapServiceMonitoringEvent {
  String? id;
  String? date;
  String? casePlanGapToServiceMonitoringLinkage;
  Events? eventData;

  CasePlanGapServiceMonitoringEvent({
    this.id,
    this.date,
    this.eventData,
    this.casePlanGapToServiceMonitoringLinkage,
  });

  bool get canCurrentUserEdit => eventData?.enrollmentOuAccessible == true;

  Map<String, dynamic> toDataObject() {
    Map<String, dynamic> dataObject = {
      "eventId": id,
      "eventDate": date,
    };
    for (Map dataValueObj in eventData?.dataValues ?? []) {
      String? dataElement = dataValueObj['dataElement'];
      if (dataElement != null) {
        dataObject[dataElement] = '${dataValueObj['value']}'.trim();
      }
    }
    return dataObject;
  }

  CasePlanGapServiceMonitoringEvent toDataModel({required Events eventData}) {
    List keys = [OvcCasePlanConstant.casePlanGapToMonitoringLinkage];
    Map data = {};
    for (Map dataValueObj in eventData.dataValues) {
      String? dataElement = dataValueObj['dataElement'];
      if (dataElement != null && keys.contains(dataElement)) {
        data[dataElement] = '${dataValueObj['value']}'.trim();
      }
    }

    return CasePlanGapServiceMonitoringEvent(
      id: eventData.event,
      casePlanGapToServiceMonitoringLinkage:
          data[OvcCasePlanConstant.casePlanGapToMonitoringLinkage] ?? '',
      date: eventData.eventDate,
      eventData: eventData,
    );
  }

  @override
  String toString() {
    return '$id $date';
  }
}
