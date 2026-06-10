import 'package:lncmis_mobile_app/core/constants/pagination.dart';
import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/tracked_entity_instance_offline/tracked_entity_instance_offline_attribute_provider.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:lncmis_mobile_app/models/tracked_entity_instance.dart';
import 'package:sqflite/sqflite.dart';

class TrackedEntityInstanceOfflineProvider extends OfflineDbProvider {
  final String table = 'tracked_entity_instance';

  //columns
  final String id = 'id';
  final String trackedEntityInstance = 'trackedEntityInstance';
  final String trackedEntityType = 'trackedEntityType';
  final String orgUnit = 'orgUnit';
  final String syncStatus = 'syncStatus';

  addOrUpdateMultipleTrackedEntityInstance(
      List<dynamic> trackedEntityInstances) async {
    try {
      var dbClient = await db;

      List<List<dynamic>> chunkedTrackedEntityInstances =
          AppUtil.chunkItems(items: trackedEntityInstances, size: 100);

      for (List<dynamic> trackedEntityInstancesGroup
          in chunkedTrackedEntityInstances) {
        var trackedEntityBatch = dbClient!.batch();
        List attributesList = [];

        for (dynamic trackedEntityInstance in trackedEntityInstancesGroup) {
          Map data = TrackedEntityInstance().toOffline(trackedEntityInstance);
          data.remove('attributes');
          data['id'] = data['trackedEntityInstance'];
          trackedEntityBatch.insert(table, data as Map<String, Object?>,
              conflictAlgorithm: ConflictAlgorithm.replace);
          attributesList.addAll(TrackedEntityInstanceOfflineAttributeProvider()
              .getTrackedEntityAttributes(trackedEntityInstance));
        }
        await trackedEntityBatch.commit(
            continueOnError: true, noResult: true, exclusive: true);
        await TrackedEntityInstanceOfflineAttributeProvider()
            .addOrUpdateMultipleTrackedEntityInstanceAttributes(attributesList);
      }
    } catch (e) {
      rethrow;
    }
  }

  addOrUpdateTrackedEntityInstance(
    TrackedEntityInstance trackedEntityInstance,
  ) async {
    var dbClient = await db;
    Map data = TrackedEntityInstance().toOffline(trackedEntityInstance);
    data.remove('attributes');
    data['id'] = data['trackedEntityInstance'];
    await dbClient!.insert(table, data as Map<String, Object?>,
        conflictAlgorithm: ConflictAlgorithm.replace);
    await TrackedEntityInstanceOfflineAttributeProvider()
        .addOrUpdateTrackedEntityAttributesValues(trackedEntityInstance);
  }

  Future<List<String?>> getAllOfflineTrackedEntitiyInstanceIds() async {
    List<String?> offlineTrackedEntityInstanceIds = [];
    try {
      var dbClient = await db;
      List<Map> maps =
          await dbClient!.query(table, columns: [trackedEntityInstance]);
      if (maps.isNotEmpty) {
        offlineTrackedEntityInstanceIds.addAll(
            maps.map((map) => map[trackedEntityInstance] as String?).toList());
      }
    } catch (error) {
      //
    }
    return offlineTrackedEntityInstanceIds.toSet().toList();
  }

  Future<List<TrackedEntityInstance>> getTrackedEntityInstanceByIds(
    List<String?> trackedEntityInstanceIds,
  ) async {
    List<TrackedEntityInstance> trackedEntityInstances = [];
    try {
      var dbClient = await db;
      List<List<String?>> chunkedTrackedEntityInstanceIds =
          AppUtil.chunkItems(items: trackedEntityInstanceIds, size: 50)
              .cast<List<String?>>();
      for (List<String?> trackedEntityInstanceIdsGroup
          in chunkedTrackedEntityInstanceIds) {
        String questionMarks =
            trackedEntityInstanceIdsGroup.map((e) => '?').toList().join(',');
        List<Map> maps = await dbClient!.query(
          table,
          columns: [
            trackedEntityInstance,
            trackedEntityType,
            orgUnit,
            syncStatus,
          ],
          where: '$trackedEntityInstance IN ($questionMarks)',
          whereArgs: trackedEntityInstanceIdsGroup,
        );
        if (maps.isNotEmpty) {
          for (Map map in maps) {
            String? trackedEntityInstanceId = map['trackedEntityInstance'];
            List attributes =
                await TrackedEntityInstanceOfflineAttributeProvider()
                    .getTrackedEntityAttributesValues(trackedEntityInstanceId);
            TrackedEntityInstance tei =
                TrackedEntityInstance.fromOffline(map as Map<String, dynamic>);
            tei.attributes = attributes;
            trackedEntityInstances.add(tei);
          }
        }
      }
    } catch (e) {
      //
    }
    return trackedEntityInstances;
  }

  Future<int> getTeiCountBySyncStatus(String status) async {
    int? teiCount;
    try {
      var dbClient = await db;
      teiCount = Sqflite.firstIntValue(await dbClient!.rawQuery(
          'SELECT COUNT(*) FROM $table WHERE $syncStatus = ?', [status]));
    } catch (e) {
      //
    }
    return teiCount ?? 0;
  }

  Future<List<String>> getTrackedEntitiyInstanceReferencesBySyncStatus(
      {String teiSyncStatus = 'not-synced'}) async {
    List<String> references = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [
          trackedEntityInstance,
          trackedEntityType,
          orgUnit,
          syncStatus,
        ],
        where: '$syncStatus = ?',
        whereArgs: [teiSyncStatus],
      );

      for (Map map in maps) {
        references.add(map[trackedEntityInstance] as String);
      }
    } catch (e) {
      rethrow;
    }

    return references;
  }

  Future<List<TrackedEntityInstance>> getTrackedEntityInstanceByStatus(
    String teiSyncStatus, {
    int? page,
  }) async {
    List<TrackedEntityInstance> trackedEntityInstances = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(table,
          columns: [
            trackedEntityInstance,
            trackedEntityType,
            orgUnit,
            syncStatus,
          ],
          where: '$syncStatus = ?',
          whereArgs: [teiSyncStatus],
          limit: page != null
              ? PaginationConstants.dataUploadPaginationLimit
              : null,
          offset: page != null
              ? page * PaginationConstants.dataUploadPaginationLimit
              : null);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          String? trackedEntityInstanceId = map['trackedEntityInstance'];
          List attributes =
              await TrackedEntityInstanceOfflineAttributeProvider()
                  .getTrackedEntityAttributesValues(trackedEntityInstanceId);
          TrackedEntityInstance tei =
              TrackedEntityInstance.fromOffline(map as Map<String, dynamic>);
          tei.attributes = attributes;
          trackedEntityInstances.add(tei);
        }
      }
    } catch (e) {
      //
    }
    return trackedEntityInstances;
  }
}
