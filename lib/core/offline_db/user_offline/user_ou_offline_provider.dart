import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/models/current_user.dart';
import 'package:sqflite/sqflite.dart';

class UserOuOfflineProvider extends OfflineDbProvider {
  // columns
  String? id = 'id';
  String userId = 'userId';

  addOrUpdateUserOrganisationUnits(CurrentUser user) async {
    var dbClient = await db;
    for (id in user.userOrgUnitIds ?? []) {
      var data = <String, dynamic>{};
      data['id'] = id;
      data['userId'] = user.id;
      await dbClient!.insert(CurrentUser.userOrganisationUnitTable, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  deleteUserOrganisationUnits(String? user) async {
    var dbClient = await db;
    return await dbClient!.delete(CurrentUser.userOrganisationUnitTable,
        where: '$userId = ?', whereArgs: [user]);
  }

  Future<List> getUserOrganisationUnits(String? currentUserId) async {
    List userOrganisationUnits = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!
          .query(CurrentUser.userOrganisationUnitTable, columns: [
        id!,
        userId,
      ]);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          if (map['userId'] == currentUserId) {
            userOrganisationUnits.add(map['id']);
          }
        }
      }
    } catch (e) {
      //
    }
    return userOrganisationUnits;
  }
}
