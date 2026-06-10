import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/models/organisation_unit.dart';
import 'package:sqflite/sqflite.dart';

class OrganisationUnitProgramOfflineProvider extends OfflineDbProvider {
  // columns
  String? id = 'id';
  String organisationId = 'organisationId';
  String programId = 'programId';

  addOrUpdateProgramOrganisationUnits(OrganisationUnit organisationUnit) async {
    var dbClient = await db;
    for (id in organisationUnit.program ?? []) {
      var map = <String, dynamic>{};
      map['id'] = '$id-${organisationUnit.id}';
      map['programId'] = id;
      map['organisationId'] = organisationUnit.id;
      await dbClient!.insert(OrganisationUnit.organisationProgramTable, map,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  deleteOrganisation(String organisationUnitId) async {
    var dbClient = await db;
    return await dbClient!.delete(OrganisationUnit.organisationProgramTable,
        where: '$organisationId = ?', whereArgs: [organisationUnitId]);
  }

  Future<List> getProgramOrganisationUnits(String? organisationUnitId) async {
    List programOrganisationUnits = [];
    var dbClient = await db;
    List<Map> maps = await dbClient!
        .query(OrganisationUnit.organisationProgramTable, columns: [
      id!,
      programId,
      organisationId,
    ]);
    if (maps.isNotEmpty) {
      for (Map map in maps) {
        if (map['organisationId'] == organisationUnitId) {
          programOrganisationUnits.add(map[programId]);
        }
      }
    }
    return programOrganisationUnits;
  }
}
