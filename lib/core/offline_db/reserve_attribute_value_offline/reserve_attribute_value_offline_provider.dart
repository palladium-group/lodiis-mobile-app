import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/models/reserved_attribute_value.dart';
import 'package:sqflite/sqlite_api.dart';

class ReserveAttributeValueOfflineProvider extends OfflineDbProvider {
  String reservedValueTable = 'reserve_value';
  String id = 'id';
  String attribute = 'attribute';
  String value = 'value';
  String expireDate = 'expireDate';

  addOrUpdateReservedAttributeValues(
      List<ReservedAttributeValue> reservedAttributeValues) async {
    var dbClient = await db;
    for (ReservedAttributeValue reservedValue in reservedAttributeValues) {
      try {
        await dbClient!.insert(reservedValueTable,
            reservedValue.toOffline(reservedValue) as Map<String, Object?>,
            conflictAlgorithm: ConflictAlgorithm.replace);
      } catch (e) {
        //
      }
    }
  }

  Future<List<ReservedAttributeValue>> getReserveAttributeValues() async {
    List<ReservedAttributeValue> reservedAttributeValues = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        reservedValueTable,
        columns: [
          id,
          attribute,
          value,
          expireDate,
        ],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          reservedAttributeValues.add(
              ReservedAttributeValue.fromOffline(map as Map<String, dynamic>));
        }
      }
    } catch (e) {
      //
    }
    return reservedAttributeValues;
  }

  Future deleteReserveAttributeValues(
    List<String?> reservedAttributeValueIds,
  ) async {
    var dbClient = await db;
    String questionMark =
        reservedAttributeValueIds.map((e) => '?').toList().join(',');
    await dbClient!.delete(reservedValueTable,
        where: '$id IN ($questionMark)', whereArgs: reservedAttributeValueIds);
  }
}
