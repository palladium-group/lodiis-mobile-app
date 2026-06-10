import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:sqflite/sqflite.dart';

class UserAccessOfflineProvider extends OfflineDbProvider {
  String tableName = "current_user_access";
  // columns
  String id = 'id';
  String userAccess = "userAccess";

  Future addOrUpdateUserAccess(
    String userAccessId,
    String userAccessData,
  ) async {
    var dbClient = await db;
    var data = <String, dynamic>{};
    data[id] = userAccessId;
    data[userAccess] = userAccessData;
    await dbClient!.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<dynamic> getAllUserAccessConfigurationById(userAccessId) async {
    dynamic userAccessConfig;
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        tableName,
        columns: [
          id,
          userAccess,
        ],
        where: '$id = ?',
        whereArgs: [userAccessId],
      );
      if (maps.isNotEmpty) {
        userAccessConfig = maps[0][userAccess];
      }
    } catch (e) {
      //
    }
    return userAccessConfig;
  }
}
