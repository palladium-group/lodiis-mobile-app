import 'package:lncmis_mobile_app/core/constants/device_tracking_constant.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';

class DeviceTrackingData {
  Map deviceInfo;

  DeviceTrackingData({
    required this.deviceInfo,
  });

  Map toProfileData() {
    return {
      "trackedEntityInstance": deviceInfo['trackedEntityInstance'] ?? '',
      "trackedEntityType": DeviceTrackingConstant.trackedEntityType,
      "orgUnit": deviceInfo['orgUnit'] ?? '',
      "attributes": DeviceTrackingConstant.attributes.map((attributeId) {
        return {
          "attribute": attributeId,
          "value": deviceInfo[attributeId] ?? ''
        };
      }).toList(),
      "enrollments": [
        {
          "enrollment": AppUtil.getUid(),
          "trackedEntityInstance": deviceInfo['trackedEntityInstance'] ?? '',
          "orgUnit": deviceInfo['orgUnit'] ?? '',
          "program": DeviceTrackingConstant.program,
          "enrollmentDate": AppUtil.formattedDateTimeIntoString(DateTime.now()),
          "incidentDate": AppUtil.formattedDateTimeIntoString(DateTime.now()),
        }
      ]
    };
  }

  Map toEventData() {
    return {
      "eventDate": AppUtil.formattedDateTimeIntoString(DateTime.now()),
      "program": DeviceTrackingConstant.program,
      "programStage": DeviceTrackingConstant.programStage,
      "trackedEntityInstance": deviceInfo['trackedEntityInstance'] ?? '',
      "status": "COMPLETED",
      "orgUnit": deviceInfo['orgUnit'] ?? '',
      "dataValues": DeviceTrackingConstant.dataElements.map((dataElementId) {
        return {
          "dataElement": dataElementId,
          "value": deviceInfo[dataElementId] ?? ''
        };
      }).toList(),
    };
  }
}
