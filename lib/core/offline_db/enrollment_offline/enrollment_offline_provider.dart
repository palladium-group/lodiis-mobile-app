import 'package:collection/collection.dart';
import 'package:kb_mobile_app/core/constants/pagination.dart';
import 'package:kb_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/enrollment.dart';
import 'package:sqflite/sqflite.dart';

class EnrollmentOfflineProvider extends OfflineDbProvider {
  final String table = 'enrollment';

  //columns
  final String id = 'id';
  final String enrollment = 'enrollment';
  final String enrollmentDate = 'enrollmentDate';
  final String incidentDate = 'incidentDate';
  final String program = 'program';
  final String orgUnit = 'orgUnit';
  final String trackedEntityInstance = 'trackedEntityInstance';
  final String status = 'status';
  final String syncStatus = 'syncStatus';
  final String searchableValue = 'searchableValue';
  final String shouldReAssess = 'shouldReAssess';

  addOrUpdateEnrollment(Enrollment enrollment) async {
    var dbClient = await db;
    Map data = Enrollment().toOffline(enrollment);
    data['id'] = data['enrollment'];
    await dbClient!.insert(table, data as Map<String, Object?>,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  addOrUpdateMultipleEnrollments(List<dynamic> enrollments) async {
    try {
      var dbClient = await db;
      List<List<dynamic>> chunkedEnrollments =
          AppUtil.chunkItems(items: enrollments, size: 100);
      for (List<dynamic> enrollmentsGroup in chunkedEnrollments) {
        var enrollmentBatch = dbClient!.batch();
        for (dynamic enrollment in enrollmentsGroup) {
          Map data = Enrollment().toOffline(enrollment);
          data['id'] = data['enrollment'];
          enrollmentBatch.insert(table, data as Map<String, Object?>,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
        return await enrollmentBatch.commit(
            noResult: true, continueOnError: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Enrollment>> getEnrollmentsByProgram(String programId,
      {int? page, Map searchedAttributes = const {}}) async {
    if (searchedAttributes.isNotEmpty) {
      // For searching
      return _getEnrollmentsBySearchedAttributes(
        programId,
        page: page,
        searchedAttributes: searchedAttributes,
      );
    }
    List<Enrollment> enrollments = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(table,
          columns: [
            enrollment,
            enrollmentDate,
            incidentDate,
            program,
            orgUnit,
            status,
            syncStatus,
            searchableValue,
            trackedEntityInstance,
            shouldReAssess
          ],
          where: '$program = ?',
          orderBy: '$enrollmentDate DESC',
          whereArgs: [programId],
          limit: page != null ? PaginationConstants.paginationLimit : null,
          offset:
              page != null ? page * PaginationConstants.paginationLimit : null);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          enrollments.add(Enrollment.fromOffline(map as Map<String, dynamic>));
        }
      }
    } catch (e) {
      //
    }
    return enrollments
      ..sort((b, a) => a.enrollmentDate!.compareTo(b.enrollmentDate!));
  }

  Future<List<Enrollment>> getAllEnrollments(int page) async {
    List<Enrollment> enrollments = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [
          enrollment,
          enrollmentDate,
          incidentDate,
          program,
          orgUnit,
          status,
          syncStatus,
          trackedEntityInstance,
          shouldReAssess
        ],
        orderBy: '$enrollmentDate DESC',
        limit: PaginationConstants.searchingPaginationLimit,
        offset: page * PaginationConstants.searchingPaginationLimit,
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          enrollments.add(Enrollment.fromOffline(map as Map<String, dynamic>));
        }
      }
    } catch (e) {
      //
    }
    return enrollments
      ..sort((b, a) => a.enrollmentDate!.compareTo(b.enrollmentDate!));
  }

  Future<int> getEnrollmentsCount(String programId) async {
    int? enrollmentsCount;
    try {
      var dbClient = await db;
      enrollmentsCount = Sqflite.firstIntValue(await dbClient!.rawQuery(
          'SELECT COUNT(*) FROM $table WHERE $program = ?', [programId]));
    } catch (e) {
      //
    }
    return enrollmentsCount ?? 0;
  }

  Future<int> getEnrollmentsToReAssessCount(String programId) async {
    var reAssessStatus = 'true';
    int? enrollmentsCount;
    try {
      var dbClient = await db;
      enrollmentsCount = Sqflite.firstIntValue(await dbClient!.rawQuery(
          'SELECT COUNT(*) FROM $table WHERE $program = ? AND $shouldReAssess != ?',
          [programId, reAssessStatus]));
    } catch (e) {
      //
    }
    return enrollmentsCount ?? 0;
  }

  Future<Map<String, int>> getEnrollmentsCountBySex(String programId) async {
    Map<String, int> enrollmentsCountBySex = {};
    String attributesTable = 'tracked_entity_instance_attribute';
    String attribute = 'attribute';
    String sexAttribute = 'vIX4GTSCX4P';
    String value = 'value';
    List<String> sex = ['Male', 'Female'];
    try {
      var dbClient = await db;
      for (String sexValue in sex) {
        int? enrollmentsCount = Sqflite.firstIntValue(await dbClient!.rawQuery(
            'SELECT COUNT($table.$trackedEntityInstance) FROM $table, $attributesTable WHERE $program = ? AND $table.$trackedEntityInstance = $attributesTable.$trackedEntityInstance AND $attributesTable.$attribute = ? AND $attributesTable.$value = ?',
            [programId, sexAttribute, sexValue]));

        enrollmentsCountBySex[sexValue.toLowerCase()] = enrollmentsCount ?? 0;
      }
    } catch (e) {
      //
    }
    return enrollmentsCountBySex;
  }

  Future<List<Enrollment>> getEnrollmentsFromTeiList(
      List<String> teiIds) async {
    List<Enrollment> enrollments = [];
    try {
      List<List<String>> chunkedTeiIds =
          AppUtil.chunkItems(items: teiIds, size: 50).cast<List<String>>();

      for (List<String> teiIdsChunk in chunkedTeiIds) {
        String questionMarks = (teiIdsChunk.isEmpty ? [''] : teiIdsChunk)
            .map((e) => '?')
            .toList()
            .join(',');
        var dbClient = await db;
        List<Map> maps = await dbClient!.query(table,
            columns: [
              enrollment,
              enrollmentDate,
              incidentDate,
              program,
              orgUnit,
              trackedEntityInstance,
              shouldReAssess
            ],
            where: "$trackedEntityInstance IN ($questionMarks)",
            whereArgs: [...teiIdsChunk]);

        if (maps.isNotEmpty) {
          for (Map map in maps) {
            enrollments
                .add(Enrollment.fromOffline(map as Map<String, dynamic>));
          }
        }
      }
    } catch (e) {
      //
    }
    return enrollments;
  }

  Future<int> getFilteredEnrollmentsCount(
      String programId, List<String> filteredTei) async {
    List<Map> enrollmentList = [];
    List<List<String>> chunkedFilteredTei =
        (AppUtil.chunkItems(items: filteredTei, size: 50)).cast<List<String>>();

    for (List<String> teiList in chunkedFilteredTei) {
      String questionMarks =
          (teiList.isEmpty ? [''] : teiList).map((e) => '?').toList().join(',');

      var dbClient = await db;
      List<Map> map = await dbClient!.query(
        table,
        columns: [enrollment],
        where: '$trackedEntityInstance IN ($questionMarks) AND $program = ?',
        whereArgs: [...teiList, programId],
      );

      enrollmentList.addAll(map);
    }
    return enrollmentList.length;
  }

  Future<List<Enrollment>> getFilteredEnrollments(
    String programId, {
    int? page,
    searchedAttributes = const {},
    required List<String> requiredTeiList,
  }) async {
    List<Enrollment> enrollments = [];
    try {
      if (searchedAttributes.isNotEmpty) {
        return _getFilteredEnrollmentsBySearchedAttributes(
          programId,
          searchedAttributes: searchedAttributes,
          requiredTeiList: requiredTeiList,
        );
      }
      List<List<String>> chunkedTeiList =
          (AppUtil.chunkItems(items: requiredTeiList, size: 50))
              .cast<List<String>>();

      for (List<String> teiList in chunkedTeiList) {
        String questionMarks = (teiList.isEmpty ? [''] : teiList)
            .map((e) => '?')
            .toList()
            .join(',');
        var dbClient = await db;
        List<Map> maps = await dbClient!.query(table,
            columns: [
              enrollment,
              enrollmentDate,
              incidentDate,
              program,
              orgUnit,
              status,
              syncStatus,
              trackedEntityInstance,
              shouldReAssess
            ],
            where:
                "$trackedEntityInstance IN ($questionMarks) AND $program = ?",
            orderBy: '$enrollmentDate DESC',
            whereArgs: [...teiList, programId],
            limit: page != null ? PaginationConstants.paginationLimit : null,
            offset: page != null
                ? page * PaginationConstants.paginationLimit
                : null);
        if (maps.isNotEmpty) {
          for (Map map in maps) {
            enrollments
                .add(Enrollment.fromOffline(map as Map<String, dynamic>));
          }
        }
      }
    } catch (e) {
      //
    }
    return enrollments
      ..sort((b, a) => a.enrollmentDate!.compareTo(b.enrollmentDate!));
  }

  Future<int> getOfflineEnrollmentsCount(
      String? programId, String? orgUnitId) async {
    int? offlineEnrollmentsCount;
    String params = programId == null && orgUnitId == null
        ? ''
        : programId == null
            ? orgUnitId == null
                ? 'WHERE $program = ?'
                : '$orgUnit = ?'
            : 'WHERE $program = ? AND $orgUnit = ?';

    List<String> paramsArgs = programId == null && orgUnitId == null
        ? []
        : programId == null
            ? ['$orgUnitId']
            : orgUnitId == null
                ? [programId]
                : [programId, orgUnitId];
    try {
      var dbClient = await db;
      offlineEnrollmentsCount = Sqflite.firstIntValue(await dbClient!
          .rawQuery('SELECT COUNT(*) FROM $table $params', paramsArgs));
    } catch (e) {
      //
    }
    return offlineEnrollmentsCount ?? 0;
  }

  Future<int> getOfflineEnrollmentsWithoutSearchableValueCount() async {
    int? offlineEnrollmentsCount;
    try {
      var dbClient = await db;
      offlineEnrollmentsCount = Sqflite.firstIntValue(await dbClient!.rawQuery(
          'SELECT COUNT(*) FROM $table WHERE $searchableValue = ?', ['']));
    } catch (e) {
      //
    }
    return offlineEnrollmentsCount ?? 0;
  }

  Future<int> getEnrollmentToReassessCount(String programId) async {
    int? offlineEnrollmentsCount;
    var reAssessStatus = 'true';
    try {
      var dbClient = await db;
      offlineEnrollmentsCount = Sqflite.firstIntValue(await dbClient!.rawQuery(
          'SELECT COUNT(*) FROM $table WHERE $program = ? AND $shouldReAssess = ?',
          [
            programId,
            reAssessStatus,
          ]));
    } catch (e) {
      //
    }
    return offlineEnrollmentsCount ?? 0;
  }

  Future<List<Enrollment>> getEnrollmentToReassess({
    int? page,
  }) async {
    var reAssessStatus = 'true';
    List<Enrollment> enrollments = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(table,
          columns: [
            enrollment,
            enrollmentDate,
            incidentDate,
            program,
            orgUnit,
            status,
            syncStatus,
            trackedEntityInstance,
            shouldReAssess
          ],
          where: '$shouldReAssess = ?',
          whereArgs: [reAssessStatus],
          limit: page != null
              ? PaginationConstants.dataUploadPaginationLimit
              : null,
          offset: page != null
              ? page * PaginationConstants.dataUploadPaginationLimit
              : null);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          enrollments.add(Enrollment.fromOffline(map as Map<String, dynamic>));
        }
      }
    } catch (e) {
      //
    }
    return enrollments;
  }

  Future<List<Enrollment>> getEnrollmentByStatus(
    String enrollmentSyncStatus, {
    int? page,
  }) async {
    List<Enrollment> enrollments = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(table,
          columns: [
            enrollment,
            enrollmentDate,
            incidentDate,
            program,
            orgUnit,
            status,
            syncStatus,
            trackedEntityInstance,
            shouldReAssess
          ],
          where: '$syncStatus = ?',
          whereArgs: [enrollmentSyncStatus],
          limit: page != null
              ? PaginationConstants.dataUploadPaginationLimit
              : null,
          offset: page != null
              ? page * PaginationConstants.dataUploadPaginationLimit
              : null);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          enrollments.add(Enrollment.fromOffline(map as Map<String, dynamic>));
        }
      }
    } catch (e) {
      //
    }
    return enrollments;
  }

  List<Map> _sanitizeSearchedEnrollments(
      Map<String, dynamic> enrollmentsMetadata) {
    var maps = enrollmentsMetadata['data'] ?? [] as List<Map>;
    var groupedEnrollments =
        groupBy(maps, (Map data) => data[trackedEntityInstance]);
    return groupedEnrollments.values
        .map((List<Map> dataGroup) => dataGroup.first)
        .toList();
  }

  Future<List<Enrollment>> _getEnrollmentsBySearchedAttributes(
    String programId, {
    int? page,
    Map searchedAttributes = const {},
  }) async {
    searchedAttributes.removeWhere((key, value) => value.isEmpty);
    List<Enrollment> enrollments = [];
    String attributesTable = 'tracked_entity_instance_attribute';
    String attribute = 'attribute';
    String attributeValue = 'value';

    List searchParams = [];
    List<String> searchParamsStringList = [];
    searchedAttributes.forEach((key, value) {
      var attributeQuery =
          '$attributesTable.$attribute = ? AND $attributesTable.$attributeValue LIKE ?';
      searchParams = [...searchParams, key, '%$value%'];
      searchParamsStringList = [...searchParamsStringList, attributeQuery];
    });

    String searchParamsString = '(${searchParamsStringList.join(' OR ')})';
    String rawQuery =
        'SELECT $enrollment, $enrollmentDate, $incidentDate, $program, $orgUnit, $status, $syncStatus, $searchableValue, $table.$trackedEntityInstance, $attributesTable.$attribute, $attributesTable.$attributeValue FROM $table, $attributesTable  WHERE $program = ? AND $table.$trackedEntityInstance = $attributesTable.$trackedEntityInstance AND $searchParamsString  ORDER BY $enrollmentDate DESC';
    try {
      var dbClient = await db;
      List params = [
        programId,
        ...searchParams,
      ];
      List<Map> maps = await dbClient!.rawQuery(
        rawQuery,
        params,
      );
      if (maps.isNotEmpty) {
        Map<String, dynamic> enrollmentsMetadata = {'data': maps};
        List<Map> sanitizedMaps =
            _sanitizeSearchedEnrollments(enrollmentsMetadata);
        for (Map map in sanitizedMaps) {
          enrollments.add(Enrollment.fromOffline(map as Map<String, dynamic>));
        }
      }
    } catch (e) {
      //
    }
    return enrollments.toSet().toList()
      ..sort((b, a) => a.enrollmentDate!.compareTo(b.enrollmentDate!));
  }

  Future<List<Enrollment>> _getFilteredEnrollmentsBySearchedAttributes(
    String programId, {
    Map searchedAttributes = const {},
    List<String> requiredTeiList = const [],
  }) async {
    searchedAttributes.removeWhere((key, value) => value.isEmpty);
    List<Enrollment> enrollments = [];
    String attributesTable = 'tracked_entity_instance_attribute';
    String attribute = 'attribute';
    String attributeValue = 'value';

    List searchParams = [];
    List<String> searchParamsStringList = [];
    searchedAttributes.forEach((key, value) {
      var attributeQuery =
          '$attributesTable.$attribute = ? AND $attributesTable.$attributeValue LIKE ?';
      searchParams = [...searchParams, key, '%$value%'];
      searchParamsStringList = [...searchParamsStringList, attributeQuery];
    });

    String searchParamsString = '(${searchParamsStringList.join(' OR ')})';
    try {
      var dbClient = await db;
      String rawQuery =
          'SELECT $enrollment, $enrollmentDate, $incidentDate, $program, $orgUnit, $status, $syncStatus, $searchableValue, $table.$trackedEntityInstance, $attributesTable.$attribute, $attributesTable.$attributeValue FROM $table, $attributesTable  WHERE $program = ? AND $table.$trackedEntityInstance = $attributesTable.$trackedEntityInstance AND $searchParamsString';

      List params = [
        programId,
        ...searchParams,
      ];

      List<List<String>> chunkedTeiList =
          (AppUtil.chunkItems(items: requiredTeiList, size: 50))
              .cast<List<String>>();

      for (List<String> teiList in chunkedTeiList) {
        String questionMarks = (teiList.isEmpty ? [''] : teiList)
            .map((e) => '?')
            .toList()
            .join(',');
        if (questionMarks.isNotEmpty) {
          params = [...params, ...teiList];
          rawQuery =
              '$rawQuery AND $trackedEntityInstance in ($questionMarks) ORDER BY $enrollmentDate DESC';
        } else {
          rawQuery = '$rawQuery ORDER BY $enrollmentDate DESC';
        }
        List<Map> maps = await dbClient!.rawQuery(
          rawQuery,
          params,
        );
        if (maps.isNotEmpty) {
          Map<String, dynamic> enrollmentsMetadata = {
            'searchedAttributes': searchedAttributes,
            'data': maps
          };
          List<Map> sanitizedMaps =
              _sanitizeSearchedEnrollments(enrollmentsMetadata);
          for (Map map in sanitizedMaps) {
            enrollments
                .add(Enrollment.fromOffline(map as Map<String, dynamic>));
          }
        }
      }
    } catch (e) {
      //
    }
    return enrollments
      ..sort((b, a) => a.enrollmentDate!.compareTo(b.enrollmentDate!));
  }
}
