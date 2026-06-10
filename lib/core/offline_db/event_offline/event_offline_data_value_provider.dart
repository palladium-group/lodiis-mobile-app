import 'package:lncmis_mobile_app/core/constants/user_account_reference.dart';
import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/models/events.dart';
import 'package:sqflite/sqflite.dart';

class EventOfflineDataValueProvider extends OfflineDbProvider {
  final String table = 'event_data_value';
  //columns
  final String id = 'id';
  final String event = 'event';
  final String dataElement = 'dataElement';
  final String value = 'value';

  addOrUpdateEventDataValues(Events eventData) async {
    var dbClient = await db;
    try {
      List dataValues = eventData.dataValues ?? [];
      String? event = eventData.event;
      for (Map dataValue in dataValues) {
        if ('${dataValue[value]}' != 'null') {
          String? dataElement = dataValue['dataElement'];
          Map data = <String, dynamic>{};
          data['id'] = '$event-$dataElement';
          data['event'] = event;
          data['dataElement'] = dataElement;
          data['value'] = dataValue['value'] ?? '';
          await dbClient!.insert(table, data as Map<String, Object?>,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    } catch (e) {
      //
    }
  }

  Future<List> getEventDataValuesByEventId(
    String? eventId,
  ) async {
    List dataValues = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [dataElement, value],
        where: '$event = ?',
        whereArgs: [eventId],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          if ('${map[value]}'.isNotEmpty && '${map[value]}' != 'null') {
            dataValues.add(map);
          }
        }
      }
    } catch (e) {
      //
    }
    return dataValues;
  }

  Future<void> reduceDeviceInformationDataValues() async {
    var deviceInfoId = UserAccountReference.appAndDeviceTrackingDataElement;
    try {
      var dbClient = await db;
      await dbClient!.rawUpdate(
        'UPDATE $table SET $value = SUBSTR($value, 0, 1190)  WHERE $dataElement = ? AND LENGTH($value) > 1199',
        [deviceInfoId],
      );
    } catch (e) {
      rethrow;
    }
  }
}
