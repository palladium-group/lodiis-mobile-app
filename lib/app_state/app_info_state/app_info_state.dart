import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/services/app_info_service.dart';
import 'package:new_version_plus/new_version_plus.dart';

import 'package:kb_mobile_app/core/constants/app_info_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/app_semantic_version.dart';

class AppInfoState with ChangeNotifier {
  String? _serverUrl;
  String? _currentAppName;
  String? _currentAppVersion;
  String? _currentAppId;
  VersionStatus? _versionStatus;
  NewVersionPlus _newVersion = NewVersionPlus();
  bool? _showWarningToAppUpdate;
  bool? _shouldUpdateTheApp;

  String get serverUrl => _serverUrl ?? '';
  String get currentAppName => _currentAppName ?? '';
  bool get showWarningToAppUpdate => _showWarningToAppUpdate ?? false;
  bool get shouldUpdateTheApp => _shouldUpdateTheApp ?? false;
  String get currentAppVersion => _currentAppVersion ?? '';
  String get currentAppId => _currentAppId ?? '';
  NewVersionPlus get newVersion => _newVersion;
  VersionStatus? get versionStatus => _versionStatus;

  Future<void> setCurrentAppInfo() async {
    _currentAppId = AppInfoReference.androidId;
    _currentAppName = AppInfoReference.currentAppName;
    _currentAppVersion = AppInfoReference.currentAppVersion;
    _serverUrl = Uri.https(
      AppInfoReference.baseUrl,
      [AppInfoReference.subBaseUrl]
          .where((String url) => url.isNotEmpty)
          .join("/"),
    ).toString();
    try {
      _newVersion = NewVersionPlus(
        androidId: AppInfoReference.androidId,
      );
      final status = await _newVersion.getVersionStatus();
      _versionStatus = status;
      _showWarningToAppUpdate = status!.canUpdate;
      _currentAppVersion = status.localVersion;

      updateAppUpdateState(
        storeVersion: status.storeVersion,
        localVersion: status.localVersion,
      );
    } catch (error) {
      var localVersion = AppInfoReference.currentAppVersion;
      var storeVersion = await AppInfoService.getSavedApStoreVersion();
      updateAppUpdateState(
        storeVersion: storeVersion,
        localVersion: localVersion,
      );
    }
    notifyListeners();
  }

  void updateAppUpdateState({storeVersion, localVersion}) {
    storeVersion = "$storeVersion".split("-").first;
    localVersion = "$localVersion".split("-").first;
    AppSemanticVersion storeSemanticVersion =
        AppUtil.getSemanticVersionValue(version: storeVersion);
    AppSemanticVersion localSemanticVersion =
        AppUtil.getSemanticVersionValue(version: localVersion);
    if (localSemanticVersion.major +
            AppInfoReference.minimumAllowedMajorVersion <
        storeSemanticVersion.major) {
      _shouldUpdateTheApp = true;
    } else if (!(localSemanticVersion.major +
                AppInfoReference.minimumAllowedMajorVersion <
            storeSemanticVersion.major) &&
        (localSemanticVersion.minor +
                AppInfoReference.minimumAllowedMinorVersion <
            storeSemanticVersion.minor)) {
      _shouldUpdateTheApp = true;
    } else if (!(storeSemanticVersion.patch <= localSemanticVersion.patch) &&
        storeSemanticVersion.patch - localSemanticVersion.patch <=
            AppInfoReference.minimumAllowedPatchVersion) {
      _showWarningToAppUpdate = true;
    } else if (localSemanticVersion.patch +
            AppInfoReference.minimumAllowedPatchVersion <=
        storeSemanticVersion.patch) {
      _shouldUpdateTheApp = true;
    } else {
      _shouldUpdateTheApp = false;
      _showWarningToAppUpdate = false;
    }
    notifyListeners();
  }
}
