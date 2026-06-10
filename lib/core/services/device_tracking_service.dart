import 'dart:convert';

import 'package:lncmis_mobile_app/core/constants/app_info_reference.dart';
import 'package:lncmis_mobile_app/core/constants/device_tracking_constant.dart';
import 'package:lncmis_mobile_app/core/offline_db/app_logs_offline/app_logs_offline_provider.dart';
import 'package:lncmis_mobile_app/core/services/http_service.dart';
import 'package:lncmis_mobile_app/core/services/preference_provider.dart';
import 'package:lncmis_mobile_app/core/services/tracked_entity_instance_service.dart';
import 'package:lncmis_mobile_app/core/services/user_service.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:lncmis_mobile_app/core/utils/device_info_util.dart';
import 'package:lncmis_mobile_app/models/app_logs.dart';
import 'package:lncmis_mobile_app/models/current_user.dart';
import 'package:lncmis_mobile_app/models/device_tracking_data.dart';

class DeviceTrackingService {
  final String deviceTrackingReference = 'deviceTrackingReference';

  Future checkAndRegistertDeviceTrackingInfo({
    required CurrentUser user,
  }) async {
    String trackedEntityInstance = AppUtil.getUid();
    Map deviceInfo = await DeviceInfoUtil.getDeviceInfo();
    String uniqueId =
        deviceInfo['identifierForVendor'] ?? deviceInfo['androidId'] ?? '';
    String filters = "${DeviceTrackingConstant.deviceId}:eq:$uniqueId";
    List<dynamic> teis = await TrackedEntityInstanceService()
        .discoveringBeneficiaryByFilters(
            [DeviceTrackingConstant.program], filters);
    if (teis.isEmpty) {
      await _registerDeviceForTracking(
        user,
        trackedEntityInstance,
        uniqueId,
        deviceInfo,
      );
    } else {
      Map teiObj = teis.first ?? {};
      trackedEntityInstance =
          teiObj['trackedEntityInstance'] ?? trackedEntityInstance;
    }
    setDeviceTrackingReference(teiId: trackedEntityInstance);
  }

  Future syncDeviceTrackingInfoOnSynchronization({
    required Map dataObject,
  }) async {
    String trackedEntityInstance = await getDeviceTrackingReference();
    if (trackedEntityInstance.isNotEmpty) {
      CurrentUser? user = await UserService().getCurrentUser();
      await _syncDeviceInfoStatusOnsyncProcess(
        user,
        dataObject,
        trackedEntityInstance,
      );
    }
  }

  Future _syncDeviceInfoStatusOnsyncProcess(
    CurrentUser? user,
    Map<dynamic, dynamic> dataObject,
    String trackedEntityInstance,
  ) async {
    Map errorMessages = await _getSynchronizationErrors(
      startDate: dataObject[DeviceTrackingConstant.syncStartTime],
      endDate: dataObject[DeviceTrackingConstant.syncEndTime],
    );
    List userOrgUnitIds = user!.userOrgUnitIds ?? [];
    dataObject[DeviceTrackingConstant.appVersionDataElemnt] =
        AppInfoReference.currentAppVersion;
    dataObject[DeviceTrackingConstant.usernameDataElemnt] = user.username;
    dataObject = {
      ...{
        "trackedEntityInstance": trackedEntityInstance,
        "orgUnit": userOrgUnitIds.first ?? '',
      },
      ...dataObject,
      ...errorMessages,
    };
    var httpClient = HttpService(
      username: user.username,
      password: user.password,
    );
    var queryParameters = {
      "strategy": "CREATE_AND_UPDATE",
    };
    DeviceTrackingData deviceTrackingData =
        DeviceTrackingData(deviceInfo: dataObject);
    await httpClient.httpPost(
      'api/events',
      json.encode({
        "events": [deviceTrackingData.toEventData()]
      }),
      queryParameters: queryParameters,
    );
  }

  Future<String> getDeviceTrackingReference() async {
    String teiId = '';
    try {
      var response =
          await PreferenceProvider.getPreferenceValue(deviceTrackingReference);
      teiId = response ?? teiId;
    } catch (e) {
      //
    }
    return teiId;
  }

  Future setDeviceTrackingReference({required String teiId}) async {
    await PreferenceProvider.setPreferenceValue(deviceTrackingReference, teiId);
  }

  Future _registerDeviceForTracking(
    CurrentUser user,
    String trackedEntityInstance,
    String uniqueId,
    Map<dynamic, dynamic> deviceInfo,
  ) async {
    var httpClient = HttpService(
      username: user.username,
      password: user.password,
    );
    var queryParameters = {
      "strategy": "CREATE_AND_UPDATE",
    };
    List userOrgUnitIds = user.userOrgUnitIds ?? [];
    Map dataObject = {
      "trackedEntityInstance": trackedEntityInstance,
      "orgUnit": userOrgUnitIds.first ?? '',
    };
    dataObject[DeviceTrackingConstant.deviceId] = uniqueId;
    dataObject[DeviceTrackingConstant.deviceManufacturer] =
        deviceInfo['manufacturer'] ?? '';
    dataObject[DeviceTrackingConstant.deviceModel] = deviceInfo['model'] ?? '';
    dataObject[DeviceTrackingConstant.usernameAttribute] = user.username;
    dataObject[DeviceTrackingConstant.appVersionIdAttribute] =
        AppInfoReference.currentAppVersion;
    DeviceTrackingData deviceTrackingData =
        DeviceTrackingData(deviceInfo: dataObject);
    await httpClient.httpPost(
      'api/trackedEntityInstances',
      json.encode({
        "trackedEntityInstances": [deviceTrackingData.toProfileData()]
      }),
      queryParameters: queryParameters,
    );
  }

  _getSynchronizationErrors({
    required String startDate,
    required String endDate,
  }) async {
    Map errorMessages = {};
    RegExp connectionRegex = RegExp(r"(timed out)");
    RegExp accessRegex = RegExp(r"(access)");
    RegExp enrollmentRegex = RegExp(r"(not enrolled)");
    RegExp socketRegex = RegExp(r"(SocketException)");
    RegExp eventForTeiNotExistRegex = RegExp(
        r"Event.trackedEntityInstance does not point to a valid tracked entity instance");
    RegExp eventForStageNotExistRegex =
        RegExp(r"Event.programStage does not point to a valid programStage");
    RegExp attributeRegEx = RegExp(r"Attribute.value");
    RegExp notValidRegEx = RegExp(r"is not a valid");
    String startDate = '2022-08-16T10:57';
    String endDate = '2022-08-16T10:58';
    List<AppLogs> logs = await AppLogsOfflineProvider().getAppLogsByDates(
      startDate: startDate,
      endDate: endDate,
    );
    for (AppLogs log in logs) {
      String message = log.message ?? '';
      if ((connectionRegex.hasMatch(message) ||
          socketRegex.hasMatch(message))) {
        errorMessages[DeviceTrackingConstant.connectivityError] = true;
      } else if ((accessRegex.hasMatch(message) ||
          enrollmentRegex.hasMatch(message) ||
          eventForStageNotExistRegex.hasMatch(message) ||
          eventForTeiNotExistRegex.hasMatch(message))) {
        errorMessages[DeviceTrackingConstant.userAccessError] = true;
      } else if (attributeRegEx.hasMatch(message) ||
          notValidRegEx.hasMatch(message)) {
        errorMessages[DeviceTrackingConstant.valueTypeError] = true;
      } else if (!(attributeRegEx.hasMatch(message) ||
          notValidRegEx.hasMatch(message) ||
          accessRegex.hasMatch(message) ||
          enrollmentRegex.hasMatch(message) ||
          connectionRegex.hasMatch(message) ||
          socketRegex.hasMatch(message) ||
          eventForStageNotExistRegex.hasMatch(message) ||
          eventForTeiNotExistRegex.hasMatch(message))) {
        errorMessages[DeviceTrackingConstant.othersError] = true;
      }
    }
    return errorMessages;
  }
}
