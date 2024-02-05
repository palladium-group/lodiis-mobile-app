import 'dart:async';

import 'package:kb_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDbProvider {
  final String databaseName = "lodiis_testing";
  Database? _db;
  // Script for migrations as well as initialization of tables
  final List<String> initialQuery = [
    "CREATE TABLE IF NOT EXISTS current_user (id TEXT PRIMARY KEY, name TEXT, username TEXT, password TEXT , implementingPartner TEXT ,isLogin INTEGER, subImplementingPartner TEXT, phoneNumber TEXT, email TEXT, userRoles TEXT, userGroups TEXT, hasPreviousSuccessLogin TEXT)",
    "CREATE TABLE IF NOT EXISTS current_user_ou (id TEXT PRIMARY KEY, userId TEXT)",
    "CREATE TABLE IF NOT EXISTS current_user_program (id TEXT PRIMARY KEY, userId TEXT)",
    "CREATE TABLE IF NOT EXISTS organisation_unit (id TEXT PRIMARY KEY, name TEXT, code TEXT, parent TEXT, level NUMBER)",
    "CREATE TABLE IF NOT EXISTS organisation_unit_children (id TEXT PRIMARY KEY, organisationId TEXT)",
    "CREATE TABLE IF NOT EXISTS organisation_unit_path (id TEXT PRIMARY KEY, path TEXT)",
    "CREATE TABLE IF NOT EXISTS organisation_unit_program (id TEXT PRIMARY KEY ,programId TEXT, organisationId TEXT)",
    "CREATE TABLE IF NOT EXISTS tracked_entity_instance (id TEXT PRIMARY KEY, trackedEntityInstance TEXT, trackedEntityType TEXT,orgUnit TEXT,syncStatus TEXT )",
    "CREATE TABLE IF NOT EXISTS tracked_entity_instance_attribute (id TEXT PRIMARY KEY,  trackedEntityInstance TEXT,attribute TEXT, value TEXT)",
    "CREATE TABLE IF NOT EXISTS enrollment (id TEXT PRIMARY KEY, enrollment TEXT ,enrollmentDate TEXT, incidentDate TEXT, program TEXT, orgUnit TEXT,trackedEntityInstance TEXT, status TEXT,searchableValue TEXT ,syncStatus TEXT)",
    "CREATE TABLE IF NOT EXISTS events (id TEXT PRIMARY KEY, event TEXT, eventDate TEXT, program TEXT,programStage TEXT, trackedEntityInstance TEXT, status TEXT, orgUnit TEXT,syncStatus TEXT)",
    "CREATE TABLE IF NOT EXISTS event_data_value (id TEXT PRIMARY KEY, event TEXT,dataElement TEXT, value TEXT)",
    "CREATE TABLE IF NOT EXISTS tei_relationships (id TEXT PRIMARY KEY, relationshipType TEXT, fromTei TEXT, toTei TEXT, syncStatus TEXT )",
    "CREATE TABLE IF NOT EXISTS app_logs (id TEXT PRIMARY KEY, type TEXT, message TEXT, date TEXT)",
    "CREATE TABLE IF NOT EXISTS reserve_value (id TEXT PRIMARY KEY,attribute TEXT,value TEXT,expireDate TEXT)",
    "CREATE TABLE IF NOT EXISTS current_user_access (id TEXT PRIMARY KEY, userAccess TEXT)",
    "CREATE TABLE IF NOT EXISTS program_ou (id TEXT PRIMARY KEY, program TEXT, organisationUnit TEXT)",
    "CREATE TABLE IF NOT EXISTS implementing_partner_referral_Services (id TEXT PRIMARY KEY, services TEXT)",
    "CREATE TABLE IF NOT EXISTS referral_notification (id TEXT PRIMARY KEY, implementingPartner TEXT,nameSpaceKey TEXT, tei TEXT)",
    "CREATE TABLE IF NOT EXISTS referral_event_notification (id TEXT PRIMARY KEY, tei TEXT, nameSpaceKey TEXT, fromImplementingPartner TEXT ,isCompleted TEXT, isViewed TEXT)",
    "CREATE TABLE IF NOT EXISTS form_auto_save (id TEXT PRIMARY KEY, beneficiaryId TEXT, pageModule TEXT, nextPageModule TEXT, data TEXT)"
  ];

  final List<String> migrationQuery = [
    // Migration to add an extra field to checking Reassessment for the enrollments
    "ALTER TABLE enrollment ADD shouldReAssess TEXT DEFAULT ''",

    // Migrations to resolve the miss-added household categorization attribute for Caregiver/Household program
    "UPDATE tracked_entity_instance_attribute SET value = '' WHERE attribute = '${BeneficiaryIdentification.householdCategorization}' AND value = '{}'",
    "DELETE FROM tracked_entity_instance_attribute WHERE attribute = 'enrollmentDate'",
  ];
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await init();
    return _db;
  }

  init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$databaseName.db');
    return await openDatabase(
      path,
      version: migrationQuery.length + 1,
      onUpgrade: onUpgrade,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onDowngrade: onDowngrade,
      onOpen: onOpen,
    );
  }

  onOpen(Database db) {}

  onDowngrade(Database db, int oldVersion, int newVersion) {}

  onConfigure(Database db) {}

  onCreate(Database db, int version) async {
    List queries = [...initialQuery, ...migrationQuery];
    for (String query in queries) {
      try {
        await db.execute(query);
      } catch (error) {
        //
      }
    }
  }

  onUpgrade(Database db, int oldVersion, int version) async {
    for (String query in migrationQuery) {
      try {
        await db.execute(query);
      } catch (e) {
        //
      }
    }
  }

  close() async {
    try {
      var dbClient = await db;
      dbClient!.close();
    } catch (e) {
      //
    }
  }
}
