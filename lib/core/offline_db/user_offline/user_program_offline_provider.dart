import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/models/current_user.dart';
import 'package:sqflite/sqflite.dart';

class UserProgramOfflineProvider extends OfflineDbProvider {
  // columns
  String? id = 'id';
  String userId = 'userId';

  addOrUpdateUserPrograms(CurrentUser user) async {
    var dbClient = await db;
    for (id in user.programs ?? []) {
      var data = <String, dynamic>{};
      data['id'] = id;
      data['userId'] = user.id;
      await dbClient!.insert(CurrentUser.userProgramTable, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  deleteUserPrograms(String? userId) async {
    var dbClient = await db;
    return await dbClient!.delete(CurrentUser.userProgramTable,
        where: '$id = ?', whereArgs: [userId]);
  }

  Future<List> getUserPrograms(String? currentUserId) async {
    List userProgramIds = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!
          .query(CurrentUser.userProgramTable, columns: [id!, userId]);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          if (map['userId'] == currentUserId) {
            userProgramIds.add(map['id']);
          }
        }
      }
    } catch (e) {
      //
    }
    return userProgramIds;
  }
}
