import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/referral_notification/referral_event_notification_offline_provider.dart';
import 'package:lncmis_mobile_app/models/referral_event_notification.dart';
import 'package:lncmis_mobile_app/models/referral_notification.dart';
import 'package:sqflite/sqflite.dart';

class ReferralNotificationOfflineProvider extends OfflineDbProvider {
  // table name
  final String table = "referral_notification";
  // columns
  final String id = "id";
  final String implementingPartner = "implementingPartner";
  final String nameSpaceKey = "nameSpaceKey";
  final String tei = "tei";

  addOrUpdateReferralNotification(
    List<ReferralNotification> referralNotifications,
  ) async {
    List<ReferralEventNotification> referralEvents = [];
    try {
      var dbClient = await db;
      var dbClientBatch = dbClient!.batch();
      for (ReferralNotification referralNotification in referralNotifications) {
        referralEvents.addAll(referralNotification.referrals!);
        Map data = referralNotification.toOffline();
        data.remove('referrals');
        dbClientBatch.insert(
          table,
          data as Map<String, Object?>,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await dbClientBatch.commit(
        continueOnError: true,
        noResult: true,
        exclusive: true,
      );
      await ReferralEventNotificationOfflineProvider()
          .addOrUpdateReferralEventNotification(referralEvents);
    } catch (error) {
      //
    }
  }

  Future<List<ReferralNotification>> getReferralNotifications() async {
    List<ReferralNotification> referralNotifications = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [id, implementingPartner, nameSpaceKey, tei],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          ReferralNotification referralNotification =
              ReferralNotification.fromJson(map);
          List<ReferralEventNotification> referrals =
              await ReferralEventNotificationOfflineProvider()
                  .getReferralEventNotification([referralNotification.tei]);
          referralNotification.referrals = referrals
              .where((ReferralEventNotification referral) =>
                  referral.nameSpaceKey == referralNotification.nameSpaceKey)
              .toList();
          referralNotifications.add(referralNotification);
        }
      }
    } catch (error) {
      //
    }
    return referralNotifications
        .where((ReferralNotification referralNotification) =>
            referralNotification.referrals!.isNotEmpty)
        .toList();
  }
}
