import 'package:lncmis_mobile_app/core/constants/pagination.dart';
import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:lncmis_mobile_app/models/tei_relationship.dart';
import 'package:sqflite/sqflite.dart';

class TeiRelationshipOfflineProvider extends OfflineDbProvider {
  final String table = 'tei_relationships';

  // columns
  final String id = 'id';
  final String relationshipType = 'relationshipType';
  final String fromTei = 'fromTei';
  final String toTei = 'toTei';
  final String syncStatus = 'syncStatus';

  addOrUpdateMultipleTeiRelationships(List<dynamic> relationships) async {
    try {
      var dbClient = await db;
      List<List<dynamic>> chunkedRelationship =
          AppUtil.chunkItems(items: relationships, size: 100);
      for (List<dynamic> relationshipsGroup in chunkedRelationship) {
        var relationshipBatch = dbClient!.batch();
        for (dynamic relationship in relationshipsGroup) {
          var data = TeiRelationship().toOffline(relationship);
          relationshipBatch.insert(table, data as Map<String, Object?>,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }

        await relationshipBatch.commit(
            noResult: true, continueOnError: true, exclusive: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  addOrUpdateTeiRelationship(TeiRelationship teiRelationship) async {
    var dbClient = await db;
    var data = TeiRelationship().toOffline(teiRelationship);
    await dbClient!.insert(table, data as Map<String, Object?>,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TeiRelationship>> getTeiRelationships(
    String? fromTeiId,
  ) async {
    List<TeiRelationship> teiRelationships = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [id, relationshipType, fromTei, toTei, syncStatus],
        where: '$fromTei = ?',
        whereArgs: [fromTeiId],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          teiRelationships
              .add(TeiRelationship.fromOffline(map as Map<String, dynamic>));
        }
      }
    } catch (e) {
      rethrow;
    }
    return teiRelationships;
  }

  Future<List<TeiRelationship>> getAllTeiRelationShips(
    String teiRelationshipSyncStatus, {
    int? page,
  }) async {
    List<TeiRelationship> teiRelationships = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(table,
          columns: [id, relationshipType, fromTei, toTei, syncStatus],
          where: '$syncStatus = ?',
          whereArgs: [teiRelationshipSyncStatus],
          limit: page != null
              ? PaginationConstants.dataUploadPaginationLimit
              : null,
          offset: page != null
              ? page * PaginationConstants.dataUploadPaginationLimit
              : null);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          teiRelationships
              .add(TeiRelationship.fromOffline(map as Map<String, dynamic>));
        }
      }
    } catch (e) {
      rethrow;
    }
    return teiRelationships;
  }

  Future<int> getRelationshipCountBySyncStatus(
    String status,
  ) async {
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
}
