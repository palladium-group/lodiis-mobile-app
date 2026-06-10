import 'package:lncmis_mobile_app/core/constants/app_info_reference.dart';
import 'package:lncmis_mobile_app/core/utils/device_info_util.dart';
import 'package:new_version_plus/new_version_plus.dart';

class AppInfoUtil {
  static Future<String> getAppVersionInfo() async {
    String currentAppVersion = AppInfoReference.currentAppVersion;
    try {
      NewVersionPlus newVersion = NewVersionPlus(
        androidId: AppInfoReference.androidId,
      );
      final status = await newVersion.getVersionStatus();
      currentAppVersion = status!.localVersion;
    } catch (error) {
      //
    }
    return currentAppVersion;
  }

  static Future<String> getAppAndDeviceTrackingInfo() async {
    String appAndDeviceInfo = '';
    try {
      appAndDeviceInfo = 'App version : ${AppInfoReference.currentAppVersion}';
      Map<String, dynamic> deviceInfo = await DeviceInfoUtil.getDeviceInfo();
      for (String key in deviceInfo.keys) {
        dynamic value = deviceInfo[key];
        appAndDeviceInfo += " , $key : $value";
      }
    } catch (error) {
      //
    }
    return appAndDeviceInfo;
  }
}
