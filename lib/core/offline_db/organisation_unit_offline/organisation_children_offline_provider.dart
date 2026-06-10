import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/models/organisation_unit.dart';
import 'package:sqflite/sqflite.dart';

class OrganisationUnitChildrenOfflineProvider extends OfflineDbProvider {
  // columns
  String? id = 'id';
  String organisationId = 'organisationId';

  addOrUpdateChildrenOrganisationUnits(
      OrganisationUnit organisationUnit) async {
    var dbClient = await db;
    for (id in organisationUnit.children ?? []) {
      var map = <String, dynamic>{};
      map['id'] = id;
      map['organisationId'] = organisationUnit.id;
      await dbClient!.insert(
        OrganisationUnit.organisationChildrenTable,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  deleteOrganisationChildren(String organisationUnitId) async {
    var dbClient = await db;
    return await dbClient!.delete(
      OrganisationUnit.organisationChildrenTable,
      where: '$organisationId = ?',
      whereArgs: [organisationUnitId],
    );
  }

  Future<List> getChildrenOrganisationUnits(String? organisationUnitId) async {
    List childrenOrganisationUnits = [];
    var dbClient = await db;
    List<Map> maps = await dbClient!.query(
      OrganisationUnit.organisationChildrenTable,
      columns: [
        id!,
        organisationId,
      ],
      where: '$organisationId = ?',
      whereArgs: [organisationUnitId],
    );
    if (maps.isNotEmpty) {
      childrenOrganisationUnits = maps.map((map) => map['id']).toList();
    }
    return childrenOrganisationUnits;
  }
}
