import 'package:lncmis_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:lncmis_mobile_app/core/constants/user_account_reference.dart';
import 'package:lncmis_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:lncmis_mobile_app/models/tracked_entity_instance.dart';
import 'package:sqflite/sqflite.dart';

class TrackedEntityInstanceOfflineAttributeProvider extends OfflineDbProvider {
  final String table = 'tracked_entity_instance_attribute';

  //columns
  final String id = 'id';
  final String trackedEntityInstance = 'trackedEntityInstance';
  final String attribute = 'attribute';
  final String value = 'value';

  addOrUpdateTrackedEntityAttributesValues(
    TrackedEntityInstance trackedEntityInstanceData,
  ) async {
    var dbClient = await db;
    try {
      List attributes = trackedEntityInstanceData.attributes ?? [];
      String? trackedEntityInstance =
          trackedEntityInstanceData.trackedEntityInstance;
      for (Map attributeObj in attributes) {
        if ('${attributeObj[value]}' != 'null') {
          String? attribute = attributeObj['attribute'];
          Map data = <String, dynamic>{};
          data['id'] = '$trackedEntityInstance-$attribute';
          data['trackedEntityInstance'] = trackedEntityInstance;
          data['attribute'] = attribute;
          data['value'] = attributeObj['value'] ?? '';
          await dbClient!.insert(table, data as Map<String, Object?>,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    } catch (e) {
      //
    }
  }

  addOrUpdateMultipleTrackedEntityInstanceAttributes(List attributes) async {
    var dbClient = await db;
    var attributesBatch = dbClient!.batch();
    try {
      for (var attribute in attributes) {
        attributesBatch.insert(table, attribute,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await attributesBatch.commit(
          exclusive: true, noResult: true, continueOnError: true);
    } catch (e) {
      //
    }
  }

  List getTrackedEntityAttributes(TrackedEntityInstance trackedEntityInstance) {
    List attributes = trackedEntityInstance.attributes ?? [];
    List attributesObjects = [];
    try {
      String? trackedEntityInstanceId =
          trackedEntityInstance.trackedEntityInstance;
      for (Map attributeObj in attributes) {
        String? attribute = attributeObj['attribute'];
        Map data = <String, dynamic>{};
        data['id'] = '$trackedEntityInstanceId-$attribute';
        data['trackedEntityInstance'] = trackedEntityInstanceId;
        data['attribute'] = attribute;
        data['value'] = attributeObj['value'] ?? '';
        attributesObjects.add(data);
      }
    } catch (e) {
      //
    }

    return attributesObjects;
  }

  Future<List> getTrackedEntityAttributesValues(
    String? trackedEntityInstanceId,
  ) async {
    List attributes = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [attribute, value],
        where: '$trackedEntityInstance = ?',
        whereArgs: [trackedEntityInstanceId],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          if ('${map[value]}'.isNotEmpty && '${map[value]}' != 'null') {
            attributes.add(map);
          }
        }
      }
    } catch (e) {
      //
    }
    return attributes;
  }

  Future<String> getSearchableFieldFromTrackedEntityAttributes(
      String tei) async {
    List<String> searchableFields = [
      'WTZ7GLTrE8Q',
      's1HaiT6OllL',
      'rSP9c21JsfC',
      'VJiWumvINR6',
      UserAccountReference.implementingPartnerAttribute,
      BeneficiaryIdentification.beneficiaryId,
      BeneficiaryIdentification.primaryUIC,
      BeneficiaryIdentification.secondaryUIC,
    ];
    String searchableValue = '';
    String questionMarks = searchableFields.map((e) => '?').toList().join(',');
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        table,
        columns: [id, trackedEntityInstance, attribute, value],
        where: '$trackedEntityInstance = ? AND $attribute IN ($questionMarks)',
        whereArgs: [tei, ...searchableFields],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          searchableValue = '$searchableValue${map[value]} ';
        }
      }
    } catch (e) {
      //
    }
    return searchableValue.toLowerCase().trim();
  }

  Future<List> getTrackedEntityAttributesValuesById(
    List<String> attributeIds,
  ) async {
    List attributes = [];
    try {
      var dbClient = await db;
      String questionMarks = attributeIds.map((e) => '?').toList().join(',');
      List<Map> maps = await dbClient!.query(
        table,
        columns: [id, trackedEntityInstance, attribute, value],
        where: '$attribute IN ($questionMarks)',
        whereArgs: attributeIds,
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          attributes.add(map);
        }
      }
    } catch (e) {
      //
    }
    return attributes;
  }

  Future<void> deleteTrackedEntityAttributesByIds(List<String> ids) async {
    try {
      var dbClient = await db;
      var batch = dbClient!.batch();
      for (String id in ids) {
        batch.delete(table, where: '$attribute = ?', whereArgs: [id]);
      }
      await batch.commit(
          exclusive: true, noResult: true, continueOnError: true);
    } catch (e) {
      //
    }
  }

  Future<void> reduceDeviceInformationAttributes() async {
    var deviceInfoId = UserAccountReference.appAndDeviceTrackingAttribute;
    try {
      var dbClient = await db;
      await dbClient!.rawUpdate(
        'UPDATE $table SET $value = SUBSTR($value, 0, 1190)  WHERE $attribute = ? AND LENGTH($value) > 1199',
        [deviceInfoId],
      );
    } catch (e) {
      rethrow;
    }
  }
}
