import 'dart:async';

import 'package:kb_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDbProvider {
  final String databaseName = "lodiis";
  Database? _db;

  final List<String> initialQuery = [
    "CREATE TABLE IF NOT EXISTS mgysd_report_intake_link (id TEXT PRIMARY KEY, reportEvent TEXT, tei TEXT, enrollment TEXT, createdAt TEXT)",

    "CREATE TABLE IF NOT EXISTS mgysd_household_member (id TEXT PRIMARY KEY, householdTei TEXT, memberTei TEXT, memberRole TEXT, isPrimaryClient TEXT, syncStatus TEXT)",

    "CREATE TABLE IF NOT EXISTS mgysd_initial_risk_assessment (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, assessmentDate TEXT, riskLevel TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT, syncStatus TEXT DEFAULT 'not-synced')",

    "CREATE TABLE IF NOT EXISTS mgysd_social_investigation (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, investigationDate TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT, parentCaseId TEXT DEFAULT '', rootCaseId TEXT DEFAULT '', stageKey TEXT DEFAULT 'social_investigation', syncStatus TEXT DEFAULT 'not-synced')",

    "CREATE TABLE IF NOT EXISTS mgysd_care_plan (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, socialInvestigationId TEXT DEFAULT '', planDate TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT, parentCaseId TEXT DEFAULT '', rootCaseId TEXT DEFAULT '', stageKey TEXT DEFAULT 'care_plan', syncStatus TEXT DEFAULT 'not-synced')",

    "CREATE TABLE IF NOT EXISTS mgysd_care_plan_goal (id TEXT PRIMARY KEY, carePlanId TEXT, socialInvestigationId TEXT DEFAULT '', caseId TEXT, householdTei TEXT, goalCategory TEXT, targetType TEXT, targetTei TEXT, targetName TEXT, goalDescription TEXT, term TEXT DEFAULT '', subjectId TEXT DEFAULT '', subjectTei TEXT DEFAULT '', subjectName TEXT DEFAULT '', subjectRole TEXT DEFAULT '', goal TEXT DEFAULT '', goalStatus TEXT DEFAULT 'open', createdAt TEXT, updatedAt TEXT, syncStatus TEXT DEFAULT 'not-synced')",

    "CREATE TABLE IF NOT EXISTS mgysd_referral (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, referralDate TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT, syncStatus TEXT DEFAULT 'not-synced')",

    "CREATE TABLE IF NOT EXISTS mgysd_monitoring (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, socialInvestigationId TEXT DEFAULT '', carePlanId TEXT DEFAULT '', monitoringReason TEXT DEFAULT '', monitoringDate TEXT, status TEXT, payloadJson TEXT, reassessmentPayloadJson TEXT DEFAULT '', updatedAt TEXT, parentCaseId TEXT DEFAULT '', rootCaseId TEXT DEFAULT '', stageKey TEXT DEFAULT 'monitoring', syncStatus TEXT DEFAULT 'not-synced')",

    "CREATE TABLE IF NOT EXISTS mgysd_monitoring_goal (id TEXT PRIMARY KEY, monitoringId TEXT, caseId TEXT, householdTei TEXT, socialInvestigationId TEXT DEFAULT '', carePlanId TEXT DEFAULT '', memberTei TEXT, goalId TEXT, serviceProvisionId TEXT DEFAULT '', progressStatus TEXT, progressNotes TEXT, challenges TEXT, recommendation TEXT, nextFollowupDate TEXT, createdAt TEXT, updatedAt TEXT, syncStatus TEXT DEFAULT 'not-synced')",

    "CREATE TABLE IF NOT EXISTS mgysd_case_closure (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, closureDate TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT, syncStatus TEXT DEFAULT 'not-synced')",

    "CREATE TABLE IF NOT EXISTS mgysd_service_provision (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, socialInvestigationId TEXT DEFAULT '', carePlanId TEXT DEFAULT '', memberTei TEXT, goalId TEXT, serviceDate TEXT, serviceProvided TEXT, outcome TEXT, goalStatus TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT, parentCaseId TEXT DEFAULT '', rootCaseId TEXT DEFAULT '', stageKey TEXT DEFAULT 'service_provision', syncStatus TEXT DEFAULT 'not-synced')",

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
    "ALTER TABLE enrollment ADD shouldReAssess TEXT DEFAULT ''",

    "UPDATE tracked_entity_instance_attribute SET value = '' WHERE attribute = '${BeneficiaryIdentification.householdCategorization}' AND value = '{}'",
    "DELETE FROM tracked_entity_instance_attribute WHERE attribute = 'enrollmentDate'",

    "CREATE TABLE IF NOT EXISTS mgysd_report_intake_link (id TEXT PRIMARY KEY, reportEvent TEXT, tei TEXT, enrollment TEXT, createdAt TEXT)",
    "CREATE TABLE IF NOT EXISTS mgysd_household_member (id TEXT PRIMARY KEY, householdTei TEXT, memberTei TEXT, memberRole TEXT, isPrimaryClient TEXT, syncStatus TEXT)",

    "CREATE TABLE IF NOT EXISTS mgysd_initial_risk_assessment (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, assessmentDate TEXT, riskLevel TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT)",
    "CREATE TABLE IF NOT EXISTS mgysd_social_investigation (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, investigationDate TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT, parentCaseId TEXT DEFAULT '', rootCaseId TEXT DEFAULT '', stageKey TEXT DEFAULT 'social_investigation', syncStatus TEXT DEFAULT 'not-synced')",
    "CREATE TABLE IF NOT EXISTS mgysd_care_plan (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, socialInvestigationId TEXT DEFAULT '', planDate TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT, parentCaseId TEXT DEFAULT '', rootCaseId TEXT DEFAULT '', stageKey TEXT DEFAULT 'care_plan', syncStatus TEXT DEFAULT 'not-synced')",
    "CREATE TABLE IF NOT EXISTS mgysd_referral (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, referralDate TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT)",
    "CREATE TABLE IF NOT EXISTS mgysd_monitoring (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, socialInvestigationId TEXT DEFAULT '', carePlanId TEXT DEFAULT '', monitoringReason TEXT DEFAULT '', monitoringDate TEXT, status TEXT, payloadJson TEXT, reassessmentPayloadJson TEXT DEFAULT '', updatedAt TEXT, parentCaseId TEXT DEFAULT '', rootCaseId TEXT DEFAULT '', stageKey TEXT DEFAULT 'monitoring', syncStatus TEXT DEFAULT 'not-synced')",
    "CREATE TABLE IF NOT EXISTS mgysd_case_closure (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, closureDate TEXT, status TEXT, payloadJson TEXT, updatedAt TEXT)",
    "CREATE TABLE IF NOT EXISTS mgysd_service_provision (id TEXT PRIMARY KEY, caseId TEXT, householdTei TEXT, socialInvestigationId TEXT DEFAULT '', carePlanId TEXT DEFAULT '', memberTei TEXT DEFAULT '', goalId TEXT DEFAULT '', serviceDate TEXT, serviceProvided TEXT DEFAULT '', outcome TEXT DEFAULT '', goalStatus TEXT DEFAULT '', status TEXT, payloadJson TEXT, updatedAt TEXT, parentCaseId TEXT DEFAULT '', rootCaseId TEXT DEFAULT '', stageKey TEXT DEFAULT 'service_provision', syncStatus TEXT DEFAULT 'not-synced')",

    "CREATE TABLE IF NOT EXISTS mgysd_care_plan_goal (id TEXT PRIMARY KEY, carePlanId TEXT, socialInvestigationId TEXT DEFAULT '', caseId TEXT, householdTei TEXT, goalCategory TEXT, targetType TEXT, targetTei TEXT, targetName TEXT, goalDescription TEXT, term TEXT DEFAULT '', subjectId TEXT DEFAULT '', subjectTei TEXT DEFAULT '', subjectName TEXT DEFAULT '', subjectRole TEXT DEFAULT '', goal TEXT DEFAULT '', goalStatus TEXT DEFAULT 'open', createdAt TEXT, updatedAt TEXT, syncStatus TEXT DEFAULT 'not-synced')",

    "CREATE TABLE IF NOT EXISTS mgysd_monitoring_goal (id TEXT PRIMARY KEY, monitoringId TEXT, caseId TEXT, householdTei TEXT, socialInvestigationId TEXT DEFAULT '', carePlanId TEXT DEFAULT '', memberTei TEXT, goalId TEXT, serviceProvisionId TEXT DEFAULT '', progressStatus TEXT, progressNotes TEXT, challenges TEXT, recommendation TEXT, nextFollowupDate TEXT, createdAt TEXT, updatedAt TEXT, syncStatus TEXT DEFAULT 'not-synced')",

    "ALTER TABLE mgysd_initial_risk_assessment ADD COLUMN syncStatus TEXT DEFAULT 'not-synced'",
    "ALTER TABLE mgysd_social_investigation ADD COLUMN syncStatus TEXT DEFAULT 'not-synced'",
    "ALTER TABLE mgysd_care_plan ADD COLUMN syncStatus TEXT DEFAULT 'not-synced'",
    "ALTER TABLE mgysd_referral ADD COLUMN syncStatus TEXT DEFAULT 'not-synced'",
    "ALTER TABLE mgysd_monitoring ADD COLUMN syncStatus TEXT DEFAULT 'not-synced'",
    "ALTER TABLE mgysd_case_closure ADD COLUMN syncStatus TEXT DEFAULT 'not-synced'",
    "ALTER TABLE mgysd_service_provision ADD COLUMN syncStatus TEXT DEFAULT 'not-synced'",
    "ALTER TABLE mgysd_service_provision ADD COLUMN memberTei TEXT DEFAULT ''",
    "ALTER TABLE mgysd_service_provision ADD COLUMN goalId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_service_provision ADD COLUMN serviceProvided TEXT DEFAULT ''",
    "ALTER TABLE mgysd_service_provision ADD COLUMN outcome TEXT DEFAULT ''",
    "ALTER TABLE mgysd_service_provision ADD COLUMN goalStatus TEXT DEFAULT ''",

    "ALTER TABLE mgysd_care_plan ADD COLUMN socialInvestigationId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN socialInvestigationId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN term TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN subjectId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN subjectTei TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN subjectName TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN subjectRole TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN goal TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN targetType TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN targetTei TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN targetName TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN goalDescription TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN goalCategory TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN goalStatus TEXT DEFAULT 'open'",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN updatedAt TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan_goal ADD COLUMN syncStatus TEXT DEFAULT 'not-synced'",

    "ALTER TABLE mgysd_service_provision ADD COLUMN socialInvestigationId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_service_provision ADD COLUMN carePlanId TEXT DEFAULT ''",

    "ALTER TABLE mgysd_monitoring ADD COLUMN socialInvestigationId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_monitoring ADD COLUMN carePlanId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_monitoring ADD COLUMN monitoringReason TEXT DEFAULT ''",
    "ALTER TABLE mgysd_monitoring ADD COLUMN reassessmentPayloadJson TEXT DEFAULT ''",

    "ALTER TABLE mgysd_monitoring_goal ADD COLUMN socialInvestigationId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_monitoring_goal ADD COLUMN carePlanId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_monitoring_goal ADD COLUMN serviceProvisionId TEXT DEFAULT ''",


    "ALTER TABLE mgysd_social_investigation ADD COLUMN parentCaseId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_social_investigation ADD COLUMN rootCaseId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_social_investigation ADD COLUMN stageKey TEXT DEFAULT ''",

    "ALTER TABLE mgysd_care_plan ADD COLUMN parentCaseId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan ADD COLUMN rootCaseId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_care_plan ADD COLUMN stageKey TEXT DEFAULT ''",

    "ALTER TABLE mgysd_referral ADD COLUMN parentCaseId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_referral ADD COLUMN rootCaseId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_referral ADD COLUMN stageKey TEXT DEFAULT ''",

    "ALTER TABLE mgysd_monitoring ADD COLUMN parentCaseId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_monitoring ADD COLUMN rootCaseId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_monitoring ADD COLUMN stageKey TEXT DEFAULT ''",

    "ALTER TABLE mgysd_service_provision ADD COLUMN parentCaseId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_service_provision ADD COLUMN rootCaseId TEXT DEFAULT ''",
    "ALTER TABLE mgysd_service_provision ADD COLUMN stageKey TEXT DEFAULT ''"
  ];

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await init();
    return _db;
  }

  Future<Database> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$databaseName.db');

    return await openDatabase(
      path,
      version: 105,
      onUpgrade: onUpgrade,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onDowngrade: onDowngrade,
      onOpen: onOpen,
    );
  }

  Future<void> onOpen(Database db) async {}

  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> onConfigure(Database db) async {}

  Future<void> onCreate(Database db, int version) async {
    List<String> queries = [...initialQuery, ...migrationQuery];

    for (String query in queries) {
      try {
        await db.execute(query);
      } catch (_) {
        // ignored intentionally because some ALTER statements may fail on fresh DB
      }
    }
  }

  Future<void> onUpgrade(Database db, int oldVersion, int version) async {
    for (String query in migrationQuery) {
      try {
        await db.execute(query);
      } catch (_) {
        // ignored intentionally because columns may already exist
      }
    }
  }

  Future<void> close() async {
    try {
      var dbClient = await db;
      await dbClient?.close();
      _db = null;
    } catch (_) {
      //
    }
  }
}