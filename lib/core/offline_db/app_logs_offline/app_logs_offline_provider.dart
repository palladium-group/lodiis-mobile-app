import 'package:lncmis_mobile_app/core/constants/app_logs_constants.dart';
import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/models/app_logs.dart';
import 'package:sqflite/sqflite.dart';

class AppLogsOfflineProvider extends OfflineDbProvider {
  final String table = 'app_logs';
  // columns
  final String id = 'id';
  final String type = 'type';
  final String message = 'message';
  final String date = 'date';

  List<String> getTableColumns() {
    return [id, date, type, message];
  }

  Future<void> addLogs(AppLogs logData) async {
    var dbClient = await db;
    Map data = logData.toOffline();
    try {
      await dbClient!.insert(table, data as Map<String, Object?>,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      //
    }
  }

  Future<void> clearLogs() async {
    var dbClient = await db;
    var batch = dbClient!.batch();
    batch.delete(table);
    await batch.commit(noResult: true);
  }

  Future<List<AppLogs>> getLogs({int? page}) async {
    List<AppLogs> logs = [];

    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [
          id,
          type,
          date,
          message,
        ],
        limit: page != null ? AppLogsConstants.logsPagnationLimit : null,
        offset:
            page != null ? page * AppLogsConstants.logsPagnationLimit : null,
        orderBy: '$date DESC',
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          AppLogs log = AppLogs.fromOffline(map as Map<String, dynamic>);
          logs.add(log);
        }
      }
    } catch (e) {
      //
    }

    return logs..sort((b, a) => a.date!.compareTo(b.date!));
  }

  Future<List<AppLogs>> getAppLogsByDates({
    required String startDate,
    required String endDate,
  }) async {
    List<AppLogs> logs = [];
    try {
      var dbClient = await db;
      startDate =
          startDate.contains('T') ? startDate.split('T').join(' ') : startDate;
      endDate = endDate.contains('T') ? endDate.split('T').join(' ') : endDate;
      String query =
          "SELECT * from $table WHERE date >= '$startDate' and date <= '$endDate'";
      List<Map> maps = await dbClient!.rawQuery(query);
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          AppLogs log = AppLogs.fromOffline(map as Map<String, dynamic>);
          logs.add(log);
        }
      }
    } catch (e) {
      //
    }
    return logs;
  }

  Future<int> getAppLogsCount() async {
    int? logsCount;
    try {
      var dbClient = await db;
      logsCount = Sqflite.firstIntValue(
          await dbClient!.rawQuery('SELECT COUNT(*) FROM $table'));
    } catch (e) {
      //
    }
    return logsCount ?? 0;
  }
}
