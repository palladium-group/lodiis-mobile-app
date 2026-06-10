
import 'dart:convert';

import 'package:lncmis_mobile_app/core/constants/default_user_access.dart';
import 'package:lncmis_mobile_app/core/offline_db/user_access_offline/user_access_offline.dart';
import 'package:lncmis_mobile_app/core/services/http_service.dart';

class UserAccess {
  final String url = "api/dataStore/kb-mobile-app/user-access";
  final String userAccessId = "user-access";

  final String mgysdMobileConfigUrl =
      "api/dataStore/lodiis-mgysd-config/mobile-config";
  final String mgysdMobileConfigId = "mgysd-mobile-config";

  Map<String, dynamic> getDefaultMgysdMobileConfig() {
    return {
      "enabled": false,
      "accessControl": {
        "requiredUserGroups": [],
        "requiredRoles": [],
        "mode": "ANY"
      },
      "programs": {},
      "programStages": {}
    };
  }

  Future<dynamic> getUserAccessConfigurationsFromTheServer(
      String? username,
      String? password,
      ) async {
    String defaultUserAccessConfigs = DefaultUserAccess.getDefaultUserAccess();
    dynamic currentUserAccessConfigs = "";

    try {
      HttpService http = HttpService(
        username: username,
        password: password,
      );

      var response = await http.httpGet(url);

      currentUserAccessConfigs =
      response.statusCode == 200 ? response.body : defaultUserAccessConfigs;

      final mgysdConfig =
      await getMgysdMobileConfigFromTheServer(username, password);
      await savingMgysdMobileConfig(mgysdConfig);
    } catch (e) {
      currentUserAccessConfigs = defaultUserAccessConfigs;
    }

    return json.decode(currentUserAccessConfigs);
  }

  Future<void> savingUserAccessConfigurations(userAccessConfigs) async {
    try {
      String userAccessData = json.encode(userAccessConfigs);
      await UserAccessOfflineProvider()
          .addOrUpdateUserAccess(userAccessId, userAccessData);
    } catch (e) {
      //
    }
  }

  Future getSavedUserAccessConfigurations() async {
    String defaultUserAccessConfigs = DefaultUserAccess.getDefaultUserAccess();
    dynamic currentUserAccessConfigs;

    try {
      currentUserAccessConfigs = await UserAccessOfflineProvider()
          .getAllUserAccessConfigurationById(userAccessId);

      currentUserAccessConfigs =
          currentUserAccessConfigs ?? defaultUserAccessConfigs;
    } catch (error) {
      currentUserAccessConfigs = defaultUserAccessConfigs;
    }

    return json.decode(currentUserAccessConfigs);
  }

  Future<dynamic> getMgysdMobileConfigFromTheServer(
      String? username,
      String? password,
      ) async {
    final defaultConfig = getDefaultMgysdMobileConfig();

    try {
      HttpService http = HttpService(
        username: username,
        password: password,
      );

      final response = await http.httpGet(mgysdMobileConfigUrl);

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body.toString().trim().isNotEmpty) {
        return json.decode(response.body);
      }
    } catch (e) {
      //
    }

    return defaultConfig;
  }

  Future<void> savingMgysdMobileConfig(dynamic mgysdMobileConfig) async {
    try {
      final configData = json.encode(mgysdMobileConfig);
      await UserAccessOfflineProvider()
          .addOrUpdateUserAccess(mgysdMobileConfigId, configData);
    } catch (e) {
      //
    }
  }

  Future<dynamic> getSavedMgysdMobileConfig() async {
    final defaultConfig = getDefaultMgysdMobileConfig();

    try {
      final savedConfig = await UserAccessOfflineProvider()
          .getAllUserAccessConfigurationById(mgysdMobileConfigId);

      if (savedConfig == null || savedConfig.toString().trim().isEmpty) {
        return defaultConfig;
      }

      return json.decode(savedConfig);
    } catch (e) {
      return defaultConfig;
    }
  }
}
