
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:lncmis_mobile_app/core/constants/beneficiary_without_enrollment_criteria.dart';
import 'package:lncmis_mobile_app/core/constants/pagination.dart';
import 'package:lncmis_mobile_app/core/offline_db/event_offline/event_offline_data_value_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/core/services/organisation_unit_service.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:lncmis_mobile_app/models/events.dart';
import 'package:lncmis_mobile_app/models/none_participation_beneficiary.dart';
import 'package:sqflite/sqflite.dart';

class EventOfflineProvider extends OfflineDbProvider {
  final String table = 'events';

  //columns
  final String id = 'id';
  final String event = 'event';
  final String eventDate = 'eventDate';
  final String program = 'program';
  final String programStage = 'programStage';
  final String trackedEntityInstance = 'trackedEntityInstance';
  final String status = 'status';
  final String orgUnit = 'orgUnit';
  final String syncStatus = 'syncStatus';

  addOrUpdateEvent(Events event) async {
    try {
      var dbClient = await db;
      Map data = Events().toOffline(event);
      data['id'] = data['event'];
      data.remove('dataValues');
      await dbClient!.insert(table, data as Map<String, Object?>,
          conflictAlgorithm: ConflictAlgorithm.replace);
      await EventOfflineDataValueProvider().addOrUpdateEventDataValues(event);
    } catch (e) {
      ///
    }
  }

  addOrUpdateMultipleEvents(List<dynamic> events) async {
    try {
      var dbClient = await db;
      List<List<dynamic>> chunkedEvents =
      AppUtil.chunkItems(items: events, size: 100);
      for (List<dynamic> eventsGroup in chunkedEvents) {
        var eventBatch = dbClient!.batch();
        for (dynamic event in eventsGroup) {
          Map data = Events().toOffline(event);
          data['id'] = data['event'];
          data.remove('dataValues');
          eventBatch.insert(table, data as Map<String, Object?>,
              conflictAlgorithm: ConflictAlgorithm.replace);
          await EventOfflineDataValueProvider()
              .addOrUpdateEventDataValues(event);
        }

        await eventBatch.commit(
            exclusive: true, noResult: true, continueOnError: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String?>> getAllOfflineEventIds() async {
    List<String?> offlineEventIds = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(table, columns: [id]);
      if (maps.isNotEmpty) {
        offlineEventIds.addAll(maps.map((map) => map[id] as String?).toList());
      }
    } catch (error) {
      //
    }
    return offlineEventIds.toSet().toList();
  }

  Future<List<Events>> getTrackedEntityInstanceEvents(
      List<String?> trackedEntityInstanceIds, {
        List<String>? accessibleOrgUnits,
      }) async {
    List<Events> events = [];
    try {
      var dbClient = await db;
      for (String? trackedEntityInstanceId in trackedEntityInstanceIds) {
        List<Map> maps = await dbClient!.query(
          table,
          columns: [
            id,
            event,
            eventDate,
            program,
            programStage,
            trackedEntityInstance,
            status,
            orgUnit,
            syncStatus,
          ],
          where: '$trackedEntityInstance = ?',
          whereArgs: [trackedEntityInstanceId],
          orderBy: eventDate,
        );
        if (maps.isNotEmpty) {
          for (Map map in maps) {
            List dataValues = await EventOfflineDataValueProvider()
                .getEventDataValuesByEventId(map['id']);
            Events eventData = Events.fromOffline(map as Map<String, dynamic>);
            eventData.enrollmentOuAccessible =
                accessibleOrgUnits?.contains(eventData.orgUnit);
            eventData.dataValues = dataValues;
            events.add(eventData);
          }
        }
      }
    } catch (e) {
      //
    }
    return events;
  }

  Future<List<String>> getTrackedEntityInstanceReferenceByEventSyncStatus({
    String eventSyncStatus = "not-synced",
  }) async {
    List<String> references = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [
          id,
          event,
          eventDate,
          program,
          programStage,
          trackedEntityInstance,
          status,
          orgUnit,
          syncStatus,
        ],
        where: '$syncStatus = ?',
        whereArgs: [eventSyncStatus],
      );
      if (maps.isNotEmpty) {
        references.addAll(maps.map((Map map) =>
        map[trackedEntityInstance] != null &&
            map[trackedEntityInstance] != ''
            ? map[trackedEntityInstance]
            : map[event]));
      }
    } catch (e) {
      //
    }
    return references.toSet().toList();
  }


  Future<List<Map>> getEventsByProgramId(String programId) async {
    final dbClient = await db;
    final List<Map> maps = await dbClient!.query(
      table,
      where: '$program = ?',
      whereArgs: [programId],
      orderBy: '$eventDate DESC',
    );
    return maps;
  }


  List<Map> _sanitizeSearchedEvents(Map<String, dynamic> eventsMetadata) {
    var maps = eventsMetadata['data'] ?? [] as List<Map>;
    var searchedAttributes = eventsMetadata['searchedDataValues'] ?? {};
    var groupedEnrollments = groupBy(maps, (Map data) => data[event]);
    return groupedEnrollments.values
        .where((List<Map> dataGroup) =>
    dataGroup.length == searchedAttributes.values.length)
        .map((List<Map> dataGroup) => dataGroup.first)
        .toList();
  }

  Map _getSanitizedSearchDataValues(Map searchDataValues) {
    Map sanitizedSearchDataValues = {};
    final List<BeneficiaryWithoutEnrollmentCriteriaConstant> constants =
    BeneficiaryWithoutEnrollmentCriteriaConstant
        .getWithoutEnrollmentCriteriaConstants();
    for (BeneficiaryWithoutEnrollmentCriteriaConstant constant in constants) {
      if (searchDataValues.containsKey(constant.attribute)) {
        sanitizedSearchDataValues[constant.dataElement] =
        searchDataValues[constant.attribute];
      }
    }
    return sanitizedSearchDataValues;
  }

  Future<List<NoneParticipationBeneficiary>>
  _getEventsProgramBySearchedDataElements(
      {String programId = '',
        String programStageId = '',
        Map searchedDataValues = const {},
        int? page}) async {
    searchedDataValues = _getSanitizedSearchDataValues(searchedDataValues);
    List<NoneParticipationBeneficiary> eventsProgramBeneficiaries = [];
    String dataValuesTable = 'event_data_value';
    String dataElement = 'dataElement';
    String dataValueValue = 'value';

    List searchParams = [];
    List<String> searchParamsStringList = [];
    searchedDataValues.forEach((key, value) {
      var dataValueQuery =
          '$dataValuesTable.$dataElement = ? AND $dataValuesTable.$dataValueValue LIKE ?';
      searchParams = [...searchParams, key, '%$value%'];
      searchParamsStringList = [...searchParamsStringList, dataValueQuery];
    });
    String searchParamsString = '(${searchParamsStringList.join(' OR ')})';
    String rawQuery =
        'SELECT $table.$id, $table.$event, $eventDate, $program, $programStage, $trackedEntityInstance, $status, $orgUnit, $syncStatus FROM $table, $dataValuesTable WHERE $program = ? AND $programStage = ? AND $table.$event = $dataValuesTable.$event AND $searchParamsString ORDER BY $eventDate DESC';
    try {
      List<String> accessibleOrgUnits = await OrganisationUnitService()
          .getOrganisationUnitAccessedByCurrentUser();
      var dbClient = await db;
      List params = [
        programId,
        programStageId,
        ...searchParams,
      ];
      List<Map> maps = await dbClient!.rawQuery(
        rawQuery,
        params,
      );
      if (maps.isNotEmpty) {
        Map<String, dynamic> eventsMetadata = {
          'searchedDataValues': searchedDataValues,
          'data': maps
        };
        List<Map> sanitizedMaps =
        await compute(_sanitizeSearchedEvents, eventsMetadata);
        for (Map map in sanitizedMaps) {
          List dataValues = await EventOfflineDataValueProvider()
              .getEventDataValuesByEventId(map['id']);
          Events eventData = Events.fromOffline(map as Map<String, dynamic>);
          eventData.dataValues = dataValues;
          eventData.enrollmentOuAccessible =
              accessibleOrgUnits.contains(eventData.orgUnit);
          eventsProgramBeneficiaries
              .add(NoneParticipationBeneficiary().fromEventsModel(eventData));
        }
      }
    } catch (e) {
      //
    }
    return eventsProgramBeneficiaries;
  }

  Future<List<NoneParticipationBeneficiary>> getEventsByProgram({
    String programId = '',
    String programStageId = '',
    int? page,
    Map searchedDataValues = const {},
  }) async {
    List<NoneParticipationBeneficiary> eventsProgramBeneficiaries = [];
    if (searchedDataValues.isNotEmpty) {
      return _getEventsProgramBySearchedDataElements(
        programId: programId,
        programStageId: programStageId,
        page: page,
        searchedDataValues: searchedDataValues,
      );
    }
    try {
      List<String> accessibleOrgUnits = await OrganisationUnitService()
          .getOrganisationUnitAccessedByCurrentUser();
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(table,
          columns: [
            id,
            event,
            eventDate,
            program,
            programStage,
            trackedEntityInstance,
            status,
            orgUnit,
            syncStatus,
          ],
          where: '$program = ? AND $programStage = ?',
          whereArgs: [programId, programStageId],
          orderBy: '$eventDate DESC',
          limit: page != null ? PaginationConstants.paginationLimit : null,
          offset:
          page != null ? page * PaginationConstants.paginationLimit : null);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          List dataValues = await EventOfflineDataValueProvider()
              .getEventDataValuesByEventId(map['id']);
          Events eventData = Events.fromOffline(map as Map<String, dynamic>);
          eventData.dataValues = dataValues;
          eventData.enrollmentOuAccessible =
              accessibleOrgUnits.contains(eventData.orgUnit);
          eventsProgramBeneficiaries
              .add(NoneParticipationBeneficiary().fromEventsModel(eventData));
        }
      }
    } catch (e) {
      //
    }
    return eventsProgramBeneficiaries
      ..sort((b, a) => a.eventDate!.compareTo(b.eventDate!));
  }

  Future<List<Events>> getEventByTeiByEventDateByProgramStage({
    required String date,
    required String programStageId,
    required String teiId,
  }) async {
    List<Events> events = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [
          id,
          event,
          eventDate,
          program,
          programStage,
          trackedEntityInstance,
          status,
          orgUnit,
          syncStatus,
        ],
        where:
        '$eventDate = ? AND $programStage = ? AND $trackedEntityInstance = ?',
        whereArgs: [
          date,
          programStageId,
          teiId,
        ],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          List dataValues = await EventOfflineDataValueProvider()
              .getEventDataValuesByEventId(map['id']);
          Events eventData = Events.fromOffline(map as Map<String, dynamic>);
          eventData.dataValues = dataValues;
          events.add(eventData);
        }
      }
    } catch (e) {
      //
    }

    return events;
  }

  Future<int> getEventsByProgramCount(
      {String programId = '', String programStageId = ''}) async {
    int? offlineEventsCount;
    try {
      var dbClient = await db;
      offlineEventsCount = Sqflite.firstIntValue(await dbClient!.rawQuery(
          'SELECT COUNT(*) FROM $table WHERE $program = ? AND $programStage = ?',
          ['$programId', '$programStageId']));
    } catch (e) {
      //
    }
    return offlineEventsCount ?? 0;
  }

  Future<List<Events>> getTrackedEntityInstanceEventsByStatus(
      String eventSyncStatus, {
        List<String> eventList = const [],
        int? page,
      }) async {
    List<Events> events = [];
    try {
      var dbClient = await db;
      List<List<String?>> chunkedEventList =
      AppUtil.chunkItems(items: eventList, size: 50).cast<List<String?>>();
      if (chunkedEventList.isEmpty) {
        List<Map> maps = await dbClient!.query(table,
            columns: [
              id,
              event,
              eventDate,
              program,
              programStage,
              trackedEntityInstance,
              status,
              orgUnit,
              syncStatus,
            ],
            where: '$syncStatus = ?',
            whereArgs: [eventSyncStatus],
            limit: page != null
                ? PaginationConstants.dataUploadPaginationLimit
                : null,
            offset: page != null
                ? page * PaginationConstants.dataUploadPaginationLimit
                : null);
        if (maps.isNotEmpty) {
          for (Map map in maps) {
            List dataValues = await EventOfflineDataValueProvider()
                .getEventDataValuesByEventId(map['id']);
            Events eventData = Events.fromOffline(map as Map<String, dynamic>);
            eventData.dataValues = dataValues;
            events.add(eventData);
          }
        }
      } else {
        for (List<String?> eventListGroup in chunkedEventList) {
          String questionMarks =
          eventListGroup.map((e) => '?').toList().join(',');
          List<Map> maps = await dbClient!.query(
            table,
            columns: [
              id,
              event,
              eventDate,
              program,
              programStage,
              trackedEntityInstance,
              status,
              orgUnit,
              syncStatus,
            ],
            where: eventList.isEmpty
                ? '$syncStatus = ?'
                : '$event IN ($questionMarks)',
            whereArgs: eventListGroup.isEmpty
                ? [eventSyncStatus]
                : [...eventListGroup],
          );
          if (maps.isNotEmpty) {
            for (Map map in maps) {
              List dataValues = await EventOfflineDataValueProvider()
                  .getEventDataValuesByEventId(map['id']);
              Events eventData =
              Events.fromOffline(map as Map<String, dynamic>);
              eventData.dataValues = dataValues;
              events.add(eventData);
            }
          }
        }
      }
    } catch (e) {
      //
    }
    return events..sort((b, a) => a.eventDate!.compareTo(b.eventDate!));
  }

  Future<List<String>> getTrackedEntityInstanceIdsByIds(
      List<String?> eventIds,
      ) async {
    List<String> teiIds = [];
    try {
      var dbClient = await db;
      List<List<String?>> chunkedEventIds =
      AppUtil.chunkItems(items: eventIds, size: 50).cast<List<String?>>();
      for (List<String?> eventIdsGroup in chunkedEventIds) {
        String questionMarks = eventIdsGroup.map((e) => '?').toList().join(',');
        List<Map> maps = await dbClient!.query(
          table,
          columns: [
            trackedEntityInstance,
          ],
          where: '$event IN ($questionMarks)',
          whereArgs: [...eventIdsGroup],
        );
        if (maps.isNotEmpty) {
          teiIds
              .addAll(maps.map((Map map) => map[trackedEntityInstance] ?? ""));
        }
      }
    } catch (e) {
      //
    }
    return teiIds;
  }

  Future<int> getEventsCountBySyncStatus(String status) async {
    int? eventsCounts;
    try {
      var dbClient = await db;
      eventsCounts = Sqflite.firstIntValue(await dbClient!
          .rawQuery('SELECT COUNT(*) FROM $table WHERE $syncStatus = ?', [
        status,
      ]));
    } catch (e) {
      //
    }
    return eventsCounts ?? 0;
  }

  Future<int> getOfflineEventCount(String? programId, String? orgUnitId) async {
    int? offlineEventsCount;
    try {
      var dbClient = await db;
      offlineEventsCount = Sqflite.firstIntValue(await dbClient!.rawQuery(
          'SELECT COUNT(*) FROM $table WHERE $program = ? AND $orgUnit = ?',
          ['$programId', '$orgUnitId']));
    } catch (e) {
      //
    }
    return offlineEventsCount ?? 0;
  }
}
