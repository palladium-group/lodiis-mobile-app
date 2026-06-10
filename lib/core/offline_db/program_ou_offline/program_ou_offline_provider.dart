import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:sqflite/sqflite.dart';

class ProgramOuOfflineProvider extends OfflineDbProvider {
  final String table = 'program_ou';
  // columns
  final String id = 'id';
  final String program = 'program';
  final String organisationUnit = 'organisationUnit';

  Future addProgramOrganisationUnit(
    String? program,
    List<String> organisationUnits,
  ) async {
    var dbClient = await db;
    for (String organisationUnit in organisationUnits) {
      var data = <String, dynamic>{};
      data['id'] = '$program-$organisationUnit';
      data['program'] = program;
      data['organisationUnit'] = organisationUnit;

      await dbClient!
          .insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  deleteProgramOrganisationUnit(String id) async {
    var dbClient = await db;
    return await dbClient!.delete(table, where: '$id = ?', whereArgs: [id]);
  }

  clearProgramOrganisationUnits() async {
    var dbClient = await db;
    return await dbClient!.delete(table);
  }

  Future<List<String?>> getProgramOrganisationUnits(String programId) async {
    List<String?> organisationUnits = [];
    try {
      var dbClient = await db;
      List<Map> maps =
          await dbClient!.query(table, columns: [program, organisationUnit]);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          if (map['program'] == programId) {
            organisationUnits.add(map['organisationUnit']);
          }
        }
      }
    } catch (e) {
      //
    }
    return organisationUnits;
  }
}
