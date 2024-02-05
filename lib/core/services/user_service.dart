import 'dart:convert';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/offline_db/program_ou_offline/program_ou_offline_provider.dart';
import 'package:kb_mobile_app/core/offline_db/user_offline/user_offline_provider.dart';
import 'package:kb_mobile_app/core/offline_db/user_offline/user_ou_offline_provider.dart';
import 'package:kb_mobile_app/core/offline_db/user_offline/user_program_offline_provider.dart';
import 'package:kb_mobile_app/core/services/http_service.dart';
import 'package:kb_mobile_app/core/services/preference_provider.dart';
import 'package:kb_mobile_app/models/current_user.dart';

class UserService {
  final String userSuccessMetadataSyncKey = 'userSuccessMetadataSync';
  final String preferenceKey = 'current_user';
  final String currentUserDataEntryAuthorityPreferenceKey =
      'current_user_data_entry_authority';

  Future<CurrentUser?> login({
    required String username,
    required String password,
    isOnlineAuthentication = true,
  }) async {
    CurrentUser? user;
    try {
      if (isOnlineAuthentication) {
        var url = 'api/me.json';
        var queryParameters = {
          "fields":
              "id,name,email,phoneNumber,programs,organisationUnits[id],attributeValues[value,attribute[id]],userGroups[name,id],userCredentials[userRoles[id,name]]"
        };
        HttpService http = HttpService(
          username: username,
          password: password,
        );
        var response =
            await http.httpGet(url, queryParameters: queryParameters);
        if (response.statusCode == 200) {
          user = CurrentUser.fromJson(
            json.decode(response.body),
            username,
            password,
          );
        }
      } else {
        List<CurrentUser> users = await UserOfflineProvider().getUsers();
        try {
          user = users.firstWhere((CurrentUser user) =>
              user.username == username && user.password == password);
        } catch (error) {
          String message =
              "You can not login offline with provided username and password, kindly connect to network and try again";
          throw message;
        }
      }
      return user;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> hasUserPreviousSuccessLogin({
    required String username,
    required String password,
  }) async {
    bool hasPreviousSuccessLogin = false;
    try {
      List<CurrentUser> users = await UserOfflineProvider().getUsers();
      var user = users.firstWhere((CurrentUser user) =>
          user.username == username && user.password == password);
      hasPreviousSuccessLogin = user.hasPreviousSuccessLogin!;
    } catch (e) {
      //
    }
    return hasPreviousSuccessLogin;
  }

  Future logout() async {
    CurrentUser? user = await getCurrentUser();
    if (user != null) {
      user.isLogin = false;
      await setCurrentUser(user);
      await setCurrentUserMetadataSyncStatus("false");
    }
  }

  Future<bool> getCurrentUserDataEntryAuthorityStatus() async {
    bool currentUserDataEntryAuthorityStatus =
        await getSavedDataEntryAuthorityStatus();
    CurrentUser? user = await getCurrentUser();
    var url = 'api/me.json';
    var queryParameters = {"fields": "authorities,userGroups[id]"};
    HttpService http = HttpService(
      username: user?.username,
      password: user?.password,
    );
    try {
      var response = await http.httpGet(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        Map<String, dynamic> dataResponse = json.decode(response.body);
        List<String> authorities = (dataResponse["authorities"] as List)
            .map((authority) => "$authority")
            .toList();
        List userGroups =
            (dataResponse["userGroups"] as List).where((userGroup) {
          List<String> allowedGroupsForDataEntry =
              UserAccountReference.allowedGroupsForDataEntry;
          String userGroupId =
              userGroup.keys.toList().indexOf("id") > -1 ? userGroup["id"] : "";
          return allowedGroupsForDataEntry.contains(userGroupId);
        }).toList();
        currentUserDataEntryAuthorityStatus =
            userGroups.isNotEmpty || authorities.contains("ALL");
      }
    } catch (e) {
      //
      currentUserDataEntryAuthorityStatus = true;
    }
    return currentUserDataEntryAuthorityStatus;
  }

  Future<bool> getSavedDataEntryAuthorityStatus() async {
    String? status = await PreferenceProvider.getPreferenceValue(
        currentUserDataEntryAuthorityPreferenceKey);
    return status == null ? true : status == "true";
  }

  Future setDataEntryAuthorityStatus(status) async {
    await PreferenceProvider.setPreferenceValue(
        currentUserDataEntryAuthorityPreferenceKey, "$status");
  }

  Future<CurrentUser?> getCurrentUser() async {
    String? userId = await PreferenceProvider.getPreferenceValue(preferenceKey);
    List<CurrentUser> users = await UserOfflineProvider().getUsers();
    List<CurrentUser> filteredUsers =
        users.where((CurrentUser user) => user.id == userId).toList();
    return filteredUsers.isNotEmpty ? filteredUsers[0] : null;
  }

  resetUserAssociatedMetadata(String? userId) async {
    await UserOuOfflineProvider().deleteUserOrganisationUnits(userId);
    await UserProgramOfflineProvider().deleteUserPrograms(userId);
    await ProgramOuOfflineProvider().clearProgramOrganisationUnits();
  }

  setCurrentUser(
    CurrentUser user,
  ) async {
    await UserOfflineProvider().addOrUpdateUser(user);
    await PreferenceProvider.setPreferenceValue(
      preferenceKey,
      user.id!,
    );
  }

  Future setCurrentUserMetadataSyncStatus(dynamic status) async {
    await PreferenceProvider.setPreferenceValue(
        userSuccessMetadataSyncKey, "$status");
  }

  Future<bool> getCurrentUserMetadataSyncStatus() async {
    var status =
        await PreferenceProvider.getPreferenceValue(userSuccessMetadataSyncKey);
    return "$status" == "true";
  }
}
