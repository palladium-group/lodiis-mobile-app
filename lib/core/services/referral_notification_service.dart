import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:lncmis_mobile_app/app_state/synchronization_state/synchronization_state.dart';
import 'package:lncmis_mobile_app/core/constants/app_logs_constants.dart';
import 'package:lncmis_mobile_app/core/offline_db/app_logs_offline/app_logs_offline_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/referral_notification/referral_event_notification_offline_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/referral_notification/referral_notification_offline_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/tracked_entity_instance_offline/tracked_entity_instance_offline_provider.dart';
import 'package:lncmis_mobile_app/core/services/http_service.dart';
import 'package:lncmis_mobile_app/core/services/organisation_unit_service.dart';
import 'package:lncmis_mobile_app/core/services/tracked_entity_instance_service.dart';
import 'package:lncmis_mobile_app/core/services/user_service.dart';
import 'package:lncmis_mobile_app/models/app_logs.dart';
import 'package:lncmis_mobile_app/models/current_user.dart';
import 'package:lncmis_mobile_app/models/referral_event_notification.dart';
import 'package:lncmis_mobile_app/models/referral_notification.dart';
import 'package:provider/provider.dart';

class ReferralNotificationService {
  final String apiUrlToDataStore = "api/dataStore/kb-referral-notification";

  Future syncReferralNotifications({
    BuildContext? context,
    bool shouldRefreshBeneficairyList = false,
  }) async {
    try {
      List<ReferralNotification> onlineReferralNotifications =
          await discoveringReferralNotificationFromServer();
      List<ReferralNotification> offlineReferralNotifications =
          await getReferralNotificationFromOffline();
      List<ReferralNotification> referralNotifications =
          getMergedReferralNotifications(
              onlineReferralNotifications, offlineReferralNotifications);
      List<String> beneficiaryIdsToBeSynced = referralNotifications
          .map((ReferralNotification referralNotification) =>
              referralNotification.tei)
          .toList();
      if (shouldRefreshBeneficairyList && context != null) {
        List<String> offlineIds = await TrackedEntityInstanceOfflineProvider()
            .getTrackedEntitiyInstanceReferencesBySyncStatus();
        List<String> offlineSynced =
            await TrackedEntityInstanceOfflineProvider()
                .getTrackedEntitiyInstanceReferencesBySyncStatus(
                    teiSyncStatus: "synced");
        offlineIds.addAll(offlineSynced);
        List<String> beneficiaryIds = beneficiaryIdsToBeSynced
            .where((String id) => !offlineIds.contains(id))
            .toList();
        if (beneficiaryIds.isNotEmpty) {
          await synchronizeUnsyncedBeneficiariesWithNotifications(
            context,
            beneficiaryIds,
          );
        }
      }
      await savingReferralNotificationToOfflineDb(referralNotifications);
      await updateReferralNotificationToServer(referralNotifications);
    } catch (error) {
      //
    }
  }

  Future synchronizeUnsyncedBeneficiariesWithNotifications(
      BuildContext context, List<String> beneficiaryIds) async {
    try {
      for (String teiId in beneficiaryIds) {
        await TrackedEntityInstanceService()
            .discoverTrackedEntityInstanceById(teiId);
      }
      await Provider.of<SynchronizationState>(context, listen: false)
          .refreshBeneficiaryCounts();
    } catch (error) {
      //
    }
  }

  savingReferralNotificationToOfflineDb(
    List<ReferralNotification> referralNotifications,
  ) async {
    try {
      await ReferralNotificationOfflineProvider()
          .addOrUpdateReferralNotification(referralNotifications);
    } catch (error) {
      AppLogs log = AppLogs(
          type: AppLogsConstants.errorLogType,
          message:
              'savingReferralNotificationToOfflineDb: ${error.toString()}');
      await AppLogsOfflineProvider().addLogs(log);
      rethrow;
    }
  }

  updateReferralNotificationEvent(
    String? referralEventId,
    String? tei,
    bool isCompleted,
    bool isViewed,
  ) async {
    try {
      List<ReferralEventNotification> referralEvents =
          await ReferralEventNotificationOfflineProvider()
              .getReferralEventNotification([tei]);
      for (ReferralEventNotification referralEventNotification
          in referralEvents) {
        if (referralEventNotification.id == referralEventId) {
          referralEventNotification.isCompleted = isCompleted;
          referralEventNotification.isViewed = isViewed;
          ReferralEventNotificationOfflineProvider()
              .addOrUpdateReferralEventNotification(
                  [referralEventNotification]);
        }
      }
    } catch (error) {
      //
    }
  }

  updateReferralNotificationToServer(
    List<ReferralNotification> referralNotifications,
  ) async {
    try {
      CurrentUser? currentUser = await (UserService().getCurrentUser());
      HttpService httpService = HttpService(
        username: currentUser!.username,
        password: currentUser.password,
      );
      List<String> nameSpaceKeys = (referralNotifications
              .map((ReferralNotification referralNotification) =>
                  referralNotification.nameSpaceKey)
              .toList())
          .toSet()
          .toList();
      for (String nameSpaceKey in nameSpaceKeys) {
        String url = "$apiUrlToDataStore/$nameSpaceKey";
        var jsondata = (referralNotifications
                .where((ReferralNotification referralNotification) =>
                    referralNotification.nameSpaceKey == nameSpaceKey)
                .toList())
            .map((ReferralNotification referralNotification) =>
                referralNotification.toOffline(
                  shouldTransformBooleanValues: true,
                ))
            .toList();
        await httpService.httpDelete(url, queryParameters: {});
        await httpService.httpPost(
          "$apiUrlToDataStore/$nameSpaceKey",
          json.encode(jsondata),
          queryParameters: {},
        );
      }
    } catch (error) {
      //
    }
  }

  Future<List<ReferralNotification>>
      getReferralNotificationFromOffline() async {
    List<ReferralNotification> referralNotifications = [];
    try {
      referralNotifications = await ReferralNotificationOfflineProvider()
          .getReferralNotifications();
    } catch (error) {
      //
    }
    return referralNotifications;
  }

  Future<List<ReferralNotification>>
      discoveringReferralNotificationFromServer() async {
    List<ReferralNotification> referralNotifications = [];
    List<String?> locations = [];
    try {
      CurrentUser? currentUser = await (UserService().getCurrentUser());
      HttpService httpService = HttpService(
        username: currentUser!.username,
        password: currentUser.password,
      );
      for (String? organisationUnitId in currentUser.userOrgUnitIds ?? []) {
        locations.addAll(await OrganisationUnitService()
            .getOrganisationUnitsInPathByOrganisationUnit(organisationUnitId));
      }
      locations = locations.toSet().toList();
      String implementingPartner =
          currentUser.implementingPartner!.split("/").join("-").trim();
      Response response = await httpService.httpGet(
        apiUrlToDataStore,
        queryParameters: {},
      );
      List<String> keysForReferralNotification = getKeysForReferralNotification(
        response,
        implementingPartner,
        locations.toSet().toList(),
      );
      referralNotifications = await getReferralNotificationFromServer(
        keysForReferralNotification,
        httpService,
      );
    } catch (error) {
      //
    }
    return referralNotifications;
  }

  Future<List<ReferralNotification>> getReferralNotificationFromServer(
    List<String> keysForReferralNotification,
    HttpService httpService,
  ) async {
    List<ReferralNotification> referralNotifications = [];
    try {
      for (String nameSpaceKey in keysForReferralNotification) {
        Response response = await httpService.httpGet(
          "$apiUrlToDataStore/$nameSpaceKey",
          queryParameters: {},
        );
        if (response.statusCode == 200) {
          for (Map data in json.decode(response.body)) {
            referralNotifications.add(ReferralNotification.fromJson(data));
          }
        }
      }
    } catch (error) {
      //
    }
    return referralNotifications;
  }

  List<String> getKeysForReferralNotification(
    Response response,
    String implementingPartner,
    List<String?> locations,
  ) {
    List<String> selectedKeys = [];
    try {
      if (locations.isEmpty) {
        for (String key in json.decode(response.body)) {
          if (key.contains(implementingPartner)) {
            selectedKeys.add(key);
          }
        }
      } else {
        for (String key in json.decode(response.body)) {
          for (String? location in locations) {
            if (key.contains(location!)) {
              selectedKeys.add(key);
            }
          }
        }
      }
    } catch (error) {
      //
    }
    return selectedKeys;
  }

  List<ReferralNotification> getMergedReferralNotifications(
    List<ReferralNotification> onlineReferralNotifications,
    List<ReferralNotification> offlineReferralNotifications,
  ) {
    List<ReferralNotification> referralNotifications = [];
    try {
      List<String> offlineReferralNotificationIds = offlineReferralNotifications
          .map((ReferralNotification referralNotification) =>
              referralNotification.id)
          .toList();
      List<String> conflictReferralNotificationIds =
          (onlineReferralNotifications
                  .map((ReferralNotification referralNotification) =>
                      referralNotification.id)
                  .toList())
              .where((String id) => offlineReferralNotificationIds.contains(id))
              .toList()
              .toSet()
              .toList();
      referralNotifications.addAll(onlineReferralNotifications
          .where((ReferralNotification referralNotification) =>
              !conflictReferralNotificationIds
                  .contains(referralNotification.id))
          .toList());
      referralNotifications.addAll(offlineReferralNotifications
          .where((ReferralNotification referralNotification) =>
              !conflictReferralNotificationIds
                  .contains(referralNotification.id))
          .toList());
      for (String id in conflictReferralNotificationIds) {
        ReferralNotification onlineReferralNotification =
            onlineReferralNotifications.firstWhere(
                (ReferralNotification referralNotification) =>
                    referralNotification.id == id);
        ReferralNotification offlineReferralNotification =
            offlineReferralNotifications.firstWhere(
                (ReferralNotification referralNotification) =>
                    referralNotification.id == id);
        List<ReferralEventNotification> referrals =
            getMergedReferralEventNotifications(
                onlineReferralNotification.referrals!,
                offlineReferralNotification.referrals!);
        referralNotifications.add(ReferralNotification(
          id: id,
          implementingPartner: onlineReferralNotification.implementingPartner,
          nameSpaceKey: onlineReferralNotification.nameSpaceKey,
          tei: onlineReferralNotification.tei,
          referrals: referrals,
        ));
      }
    } catch (error) {
      //
    }
    return referralNotifications;
  }

  List<ReferralEventNotification> getMergedReferralEventNotifications(
    List<ReferralEventNotification> onlineReferrals,
    List<ReferralEventNotification> offlineReferrals,
  ) {
    List<ReferralEventNotification> referrals = [];
    try {
      List<String> offlineReferralIds = offlineReferrals
          .map((ReferralEventNotification referralEventNotification) =>
              referralEventNotification.id)
          .toList();
      List<String> conflictReferralIds = (onlineReferrals
              .map((ReferralEventNotification referralEventNotification) =>
                  referralEventNotification.id)
              .toList())
          .where((String id) => offlineReferralIds.contains(id))
          .toList()
          .toSet()
          .toList();
      referrals.addAll(onlineReferrals
          .where((ReferralEventNotification referralEventNotification) =>
              !conflictReferralIds.contains(referralEventNotification.id))
          .toList());
      referrals.addAll(offlineReferrals
          .where((ReferralEventNotification referralEventNotification) =>
              !conflictReferralIds.contains(referralEventNotification.id))
          .toList());
      for (String id in conflictReferralIds) {
        ReferralEventNotification onlineReferral = onlineReferrals.firstWhere(
            (ReferralEventNotification referralEventNotification) =>
                referralEventNotification.id == id);
        ReferralEventNotification offlineReferral = offlineReferrals.firstWhere(
            (ReferralEventNotification referralEventNotification) =>
                referralEventNotification.id == id);
        if (offlineReferral.isViewed!) {
          referrals.add(offlineReferral);
        } else if (onlineReferral.isViewed!) {
          referrals.add(onlineReferral);
        } else if (onlineReferral.isCompleted!) {
          referrals.add(onlineReferral);
        } else {
          referrals.add(offlineReferral);
        }
      }
    } catch (error) {
      //
    }
    return referrals;
  }
}
