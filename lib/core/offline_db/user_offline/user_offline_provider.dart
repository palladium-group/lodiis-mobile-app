import 'dart:async';
import 'package:lncmis_mobile_app/core/offline_db/user_offline/user_ou_offline_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/user_offline/user_program_offline_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/models/current_user.dart';

class UserOfflineProvider extends OfflineDbProvider {
  // columns
  String id = 'id';
  String name = 'name';
  String username = 'username';
  String password = 'password';
  String isLogin = 'isLogin';
  String email = 'email';
  String phoneNumber = 'phoneNumber';
  String userGroups = 'userGroups';
  String userRoles = 'userRoles';
  String implementingPartner = 'implementingPartner';
  String subImplementingPartner = 'subImplementingPartner';
  String hasPreviousSuccessLogin = 'hasPreviousSuccessLogin';

  addOrUpdateUser(CurrentUser user) async {
    var dbClient = await db;
    await dbClient!.insert(
        CurrentUser.userTable, user.toOffline(user) as Map<String, Object?>,
        conflictAlgorithm: ConflictAlgorithm.replace);
    await UserOuOfflineProvider().addOrUpdateUserOrganisationUnits(user);
    await UserProgramOfflineProvider().addOrUpdateUserPrograms(user);
  }

  deleteUser(String userId) async {
    var dbClient = await db;
    return await dbClient!
        .delete(CurrentUser.userTable, where: '$id = ?', whereArgs: [userId]);
  }

  Future<List<CurrentUser>> getUsers() async {
    List<CurrentUser> users = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        CurrentUser.userTable,
        columns: [
          id,
          name,
          phoneNumber,
          email,
          userGroups,
          userRoles,
          username,
          password,
          isLogin,
          implementingPartner,
          subImplementingPartner,
          hasPreviousSuccessLogin,
        ],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          String? userId = map['id'];
          List userOrgUnitIds =
              await UserOuOfflineProvider().getUserOrganisationUnits(userId);
          List programs =
              await UserProgramOfflineProvider().getUserPrograms(userId);
          CurrentUser user =
              CurrentUser.fromOffline(map as Map<String, dynamic>);
          user.programs = programs;
          user.userOrgUnitIds = userOrgUnitIds;
          users.add(user);
        }
      }
    } catch (e) {
      //
    }
    return users;
  }
}
