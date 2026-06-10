import 'dart:convert';
import 'package:lncmis_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:lncmis_mobile_app/core/offline_db/reserve_attribute_value_offline/reserve_attribute_value_offline_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/tracked_entity_instance_offline/tracked_entity_instance_offline_attribute_provider.dart';
import 'package:lncmis_mobile_app/core/services/http_service.dart';
import 'package:lncmis_mobile_app/core/services/user_service.dart';
import 'package:lncmis_mobile_app/models/current_user.dart';
import 'package:lncmis_mobile_app/models/reserved_attribute_value.dart';

class ReservedAttributeValueService {
  int maxNumberToReserve = BeneficiaryIdentification.maxNumberToReserve;
  final String attribute = BeneficiaryIdentification.beneficiaryIndex;
  List<ReservedAttributeValue> reservedValues = [];

  Future generateReservedAttributeValues() async {
    List<ReservedAttributeValue> allReservedValues =
        await ReserveAttributeValueOfflineProvider()
            .getReserveAttributeValues();
    List<String?> expireReserveValueObjectIds =
        await getExpiredReserveAttributeValues();
    int numberToReserve = maxNumberToReserve +
        expireReserveValueObjectIds.length -
        allReservedValues.length;
    if (numberToReserve > 0) {
      expireReserveValueObjectIds.isNotEmpty
          ? await deleteExpireReservedAttributeValues(
              expireReserveValueObjectIds)
          : await null;
      List<ReservedAttributeValue> data =
          await (getReservedAttributeValuesFromTheServer(numberToReserve));
      saveReservedAttributeValues(data);
    }
  }

  Future getReservedAttributeValuesFromTheServer(int numberToReserve) async {
    const String attribute = BeneficiaryIdentification.beneficiaryIndex;
    String url = 'api/trackedEntityAttributes/$attribute/generateAndReserve';
    var queryParameters = {
      "numberToReserve": "$numberToReserve",
    };
    CurrentUser? user = await (UserService().getCurrentUser());
    HttpService http = HttpService(
      username: user!.username,
      password: user.password,
    );
    try {
      var response = await http.httpGet(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        for (var reserveValue in responseData) {
          reservedValues.add(ReservedAttributeValue.fromJson(reserveValue));
        }
      }
    } catch (e) {
      //
    }
    return reservedValues;
  }

  Future saveReservedAttributeValues(
      List<ReservedAttributeValue> reservedAttributeValues) async {
    await ReserveAttributeValueOfflineProvider()
        .addOrUpdateReservedAttributeValues(reservedAttributeValues);
  }

  Future<String?> getReservedAttributeValue() async {
    List<ReservedAttributeValue> reservedAttributeValues =
        await ReserveAttributeValueOfflineProvider()
            .getReserveAttributeValues();
    return reservedAttributeValues.isNotEmpty
        ? reservedAttributeValues[0].value
        : null;
  }

  Future deleteExpireReservedAttributeValues(
      List<String?> expireReservedAttributeValueIds) async {
    return await ReserveAttributeValueOfflineProvider()
        .deleteReserveAttributeValues(expireReservedAttributeValueIds);
  }

  Future<List<String?>> getExpiredReserveAttributeValues() async {
    DateTime date = DateTime.now();
    List<String?> expireReserveValueObjectIds = [];
    List<ReservedAttributeValue> reservedAttributeValues =
        await ReserveAttributeValueOfflineProvider()
            .getReserveAttributeValues();
    for (ReservedAttributeValue reservedAttributeValue
        in reservedAttributeValues) {
      DateTime todayDate = DateTime.parse(reservedAttributeValue.expireDate!);
      if (todayDate.difference(date).inDays < 0) {
        expireReserveValueObjectIds.add(reservedAttributeValue.id);
      }
    }
    return expireReserveValueObjectIds;
  }

  Future cleanUsedReservedAttributeValues() async {
    List<String?> trackedEntityValues = [];
    List<String?> usedReservedValueIds = [];
    List<ReservedAttributeValue> reservedAttributeValues =
        await ReserveAttributeValueOfflineProvider()
            .getReserveAttributeValues();
    List attributeValues = await TrackedEntityInstanceOfflineAttributeProvider()
        .getTrackedEntityAttributesValuesById([attribute]);
    for (var attributeValue in attributeValues) {
      trackedEntityValues.add(attributeValue["value"]);
    }
    for (ReservedAttributeValue reserveValue in reservedAttributeValues) {
      if (trackedEntityValues.contains(reserveValue.value)) {
        usedReservedValueIds.add(reserveValue.id);
      }
    }
    await deleteExpireReservedAttributeValues(usedReservedValueIds);
    generateReservedAttributeValues();
  }
}
