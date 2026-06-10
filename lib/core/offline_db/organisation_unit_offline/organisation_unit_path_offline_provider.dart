import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/models/organisation_unit.dart';
import 'package:sqflite/sqflite.dart';

class OrganisationUnitPathOfflineProvider extends OfflineDbProvider {
  // table name
  final String table = "organisation_unit_path";
  // column
  final String id = "id";
  final String path = "path";

  addOrUpdateOrganisationUnitPath(
    OrganisationUnit organisationUnit,
  ) async {
    try {
      var dbClient = await db;
      var map = <String, dynamic>{};
      map['id'] = organisationUnit.id;
      map['path'] = organisationUnit.path;
      await dbClient!
          .insert(table, map, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (error) {
      //
    }
  }

  Future<List<String>> getAccessableOrganisationUnits(
      String organisationUnitId) async {
    List<String> organisationUnitIds = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [id, path],
      );
      if (maps.isNotEmpty) {
        organisationUnitIds.addAll(maps
            .where((map) => "${map[path]}".contains(organisationUnitId))
            .toList()
            .map((map) => "${map[id]}"));
      }
    } catch (e) {
      //
    }
    return organisationUnitIds.toList().toSet().toList();
  }

  Future<List<String?>> getOrganisationUnitsInPathByOrganisationUnit(
    String? organisationUnitId,
  ) async {
    List<String> organisationUnitIds = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [id, path],
      );
      if (maps.isNotEmpty) {
        List<String> paths = maps
            .map((map) => "${map[path]}")
            .toList()
            .where((path) => path.contains(organisationUnitId!))
            .toList();
        for (String path in paths) {
          List<String> splittedPath = path.split("/");
          organisationUnitIds.addAll(
            splittedPath.where(
              (String path) =>
                  splittedPath.indexOf(path) >=
                  splittedPath.indexOf(organisationUnitId!),
            ),
          );
        }
      }
    } catch (e) {
      //
    }
    return organisationUnitIds.toList().toSet().toList();
  }

  Future<String?> getOrganiationUnitPath(String? organisationUnitId) async {
    String? organisationUnitPath = "";
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [id, path],
        where: '$id = ?',
        whereArgs: [organisationUnitId],
      );
      if (maps.isNotEmpty) {
        organisationUnitPath = maps.first["path"];
      }
    } catch (e) {
      //
    }
    return organisationUnitPath;
  }
}
