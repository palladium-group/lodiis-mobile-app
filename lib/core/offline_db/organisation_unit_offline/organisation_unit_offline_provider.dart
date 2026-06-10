import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/organisation_unit_offline/organisation_children_offline_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/organisation_unit_offline/organisation_program_offline_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/organisation_unit_offline/organisation_unit_path_offline_provider.dart';
import 'package:lncmis_mobile_app/models/organisation_unit.dart';
import 'package:sqflite/sqflite.dart';

class OrganisationUnitOfflineProvider extends OfflineDbProvider {
  //columns
  String id = 'id';
  String name = 'name';
  String parent = 'parent';
  String level = 'level';
  String code = 'code';

  addOrUpdateOrganisationUnits(List<OrganisationUnit> organisationUnits) async {
    var dbClient = await db;
    for (OrganisationUnit organisationUnit in organisationUnits) {
      await dbClient!.insert(OrganisationUnit.organisationUnitTable,
          organisationUnit.toOffline(organisationUnit) as Map<String, Object?>,
          conflictAlgorithm: ConflictAlgorithm.replace);
      await OrganisationUnitChildrenOfflineProvider()
          .addOrUpdateChildrenOrganisationUnits(organisationUnit);
      await OrganisationUnitProgramOfflineProvider()
          .addOrUpdateProgramOrganisationUnits(organisationUnit);
      await OrganisationUnitPathOfflineProvider()
          .addOrUpdateOrganisationUnitPath(organisationUnit);
    }
  }

  deleteOrganisation(String organisationId) async {
    var dbClient = await db;
    return await dbClient!.delete(
      OrganisationUnit.organisationUnitTable,
      where: '$id = ?',
      whereArgs: [organisationId],
    );
  }

  Future<List<OrganisationUnit>> getOrganisationUnits() async {
    List<OrganisationUnit> organisationUnitList = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        OrganisationUnit.organisationUnitTable,
        columns: [id, name, parent, level, code],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          String? organisationUnitId = map['id'];
          String? path = await OrganisationUnitPathOfflineProvider()
              .getOrganiationUnitPath(organisationUnitId);
          List children = await OrganisationUnitChildrenOfflineProvider()
              .getChildrenOrganisationUnits(organisationUnitId);
          List programs = await OrganisationUnitProgramOfflineProvider()
              .getProgramOrganisationUnits(organisationUnitId);
          OrganisationUnit organisationUnits =
              OrganisationUnit.fromOffline(map as Map<String, dynamic>);
          organisationUnits.path = path;
          organisationUnits.program = programs;
          organisationUnits.children = children;
          organisationUnitList.add(organisationUnits);
        }
      }
    } catch (e) {
      //
    }
    organisationUnitList.sort((a, b) => a.name!.compareTo(b.name!));
    return organisationUnitList;
  }

  Future<List<OrganisationUnit>> getOrganisationUnitsByLevel(
    int ouLevel,
  ) async {
    List<OrganisationUnit> organisationUnitList = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        OrganisationUnit.organisationUnitTable,
        columns: [id, name, parent, level, code],
        where: '$level = ?',
        whereArgs: [ouLevel],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          String? organisationUnitId = map['id'];
          String? path = await OrganisationUnitPathOfflineProvider()
              .getOrganiationUnitPath(organisationUnitId);
          List children = await OrganisationUnitChildrenOfflineProvider()
              .getChildrenOrganisationUnits(organisationUnitId);
          List programs = await OrganisationUnitProgramOfflineProvider()
              .getProgramOrganisationUnits(organisationUnitId);
          OrganisationUnit organisationUnits =
              OrganisationUnit.fromOffline(map as Map<String, dynamic>);
          organisationUnits.path = path;
          organisationUnits.program = programs;
          organisationUnits.children = children;
          organisationUnitList.add(organisationUnits);
        }
      }
    } catch (e) {
      //
    }
    return organisationUnitList;
  }

  Future<List<OrganisationUnit>> getOrganisationUnitById(
    List? organisationIds,
  ) async {
    List<OrganisationUnit> organisationUnitList = [];
    try {
      var dbClient = await db;
      String questionMark =
          (organisationIds ?? []).map((e) => '?').toList().join(',');
      List<Map> maps = await dbClient!.query(
          OrganisationUnit.organisationUnitTable,
          columns: [id, name, parent, level, code],
          orderBy: name,
          where: '$id IN ($questionMark)',
          whereArgs: organisationIds ?? ['']);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          String? organisationUnitId = map['id'];
          String? path = await OrganisationUnitPathOfflineProvider()
              .getOrganiationUnitPath(organisationUnitId);
          List children = await OrganisationUnitChildrenOfflineProvider()
              .getChildrenOrganisationUnits(organisationUnitId);
          List programs = await OrganisationUnitProgramOfflineProvider()
              .getProgramOrganisationUnits(organisationUnitId);
          OrganisationUnit organisationUnits =
              OrganisationUnit.fromOffline(map as Map<String, dynamic>);
          organisationUnits.path = path;
          organisationUnits.program = programs;
          organisationUnits.children = children;
          organisationUnitList.add(organisationUnits);
        }
      }
    } catch (e) {
      //
    }
    organisationUnitList.sort((a, b) => a.name!.compareTo(b.name!));
    return organisationUnitList;
  }
}
