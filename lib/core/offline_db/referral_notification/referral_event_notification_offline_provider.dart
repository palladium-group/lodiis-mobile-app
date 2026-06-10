import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:lncmis_mobile_app/models/referral_event_notification.dart';
import 'package:sqflite/sqflite.dart';

class ReferralEventNotificationOfflineProvider extends OfflineDbProvider {
  // table name
  final String table = "referral_event_notification";
  // column\
  final String id = "id";
  final String tei = "tei";
  final String nameSpaceKey = "nameSpaceKey";
  final String fromImplementingPartner = "fromImplementingPartner";
  final String isCompleted = "isCompleted";
  final String isViewed = "isViewed";

  addOrUpdateReferralEventNotification(
    List<ReferralEventNotification> referralEvents,
  ) async {
    try {
      var dbClient = await db;
      var dbClientBatch = dbClient!.batch();
      for (ReferralEventNotification referralEventNotification
          in referralEvents) {
        Map data = referralEventNotification.toOffline();
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
    } catch (error) {
      //
    }
  }

  Future<List<ReferralEventNotification>> getReferralEventNotification(
    List<String?> teiIds,
  ) async {
    List<ReferralEventNotification> referralEvents = [];
    try {
      var dbClient = await db;
      List<List<String?>> chunkedTeiIds =
          AppUtil.chunkItems(items: teiIds, size: 50).cast<List<String?>>();
      for (List<String?> teiIdsChunk in chunkedTeiIds) {
        String questionMarks = teiIdsChunk.map((e) => '?').toList().join(',');
        List<Map> maps = await dbClient!.query(
          table,
          columns: [
            id,
            tei,
            nameSpaceKey,
            fromImplementingPartner,
            isCompleted,
            isViewed,
          ],
          where: '$tei IN ($questionMarks)',
          whereArgs: teiIdsChunk,
        );
        if (maps.isNotEmpty) {
          for (Map map in maps) {
            referralEvents.add(ReferralEventNotification.fromJson(map));
          }
        }
      }
    } catch (error) {
      //
    }
    return referralEvents;
  }
}
