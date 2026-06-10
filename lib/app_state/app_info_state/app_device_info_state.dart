import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:lncmis_mobile_app/core/utils/device_info_util.dart';

class AppDeviceInfoState with ChangeNotifier {
  String? _androidDeviceId;
  String? _securityPatch;
  String? _osVersion;
  String? _brand;
  String? _device;
  String? _manufacturer;
  String? _model;
  String? _product;

  String get androidDeviceId => _androidDeviceId ?? '';
  String get securityPatch => _securityPatch ?? '';
  String get osVersion => _osVersion ?? '';
  String get brand => _brand ?? '';
  String get device => _device ?? '';
  String get manufacturer => _manufacturer ?? '';
  String get model => _model ?? '';
  String get product => _product ?? '';

  void setCurrentDeviceInfo() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        deviceData = DeviceInfoUtil.readAndroidBuildData(
            await deviceInfoPlugin.androidInfo);
        _securityPatch = deviceData['version.securityPatch'] ?? '';
        _osVersion = deviceData['version.release'] ?? '';
        _brand = deviceData['brand'] ?? '';
        _device = deviceData['device'] ?? '';
        _manufacturer = deviceData['manufacturer'] ?? '';
        _model = deviceData['model'] ?? '';
        _product = deviceData['product'] ?? '';
        _androidDeviceId = deviceData['androidId'] ?? '';
      }
    } catch (error) {
      //
    }
    notifyListeners();
  }
}
