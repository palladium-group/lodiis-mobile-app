import 'package:lncmis_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';

class ReservedAttributeValue {
  String? id;
  String? attribute;
  String? value;
  String? expireDate;

  ReservedAttributeValue({
    this.id,
    this.attribute,
    this.value,
    this.expireDate,
  });

  factory ReservedAttributeValue.fromJson(Map<String, dynamic> json) {
    return ReservedAttributeValue(
        id: json['id'] ?? AppUtil.getUid(),
        attribute: BeneficiaryIdentification.beneficiaryIndex,
        value: json['value'],
        expireDate: json['expiryDate']);
  }

  Map toOffline(ReservedAttributeValue reservedAttributeValue) {
    var map = <String, dynamic>{};
    map['id'] = reservedAttributeValue.id;
    map['attribute'] = reservedAttributeValue.attribute;
    map['value'] = reservedAttributeValue.value;
    map['expireDate'] = reservedAttributeValue.expireDate;
    return map;
  }

  ReservedAttributeValue.fromOffline(Map<String, dynamic> map) {
    id = map['id'];
    attribute = map['attribute'];
    value = map['value'];
    expireDate = map['expireDate'];
  }

  @override
  String toString() {
    return "reserve value is $value";
  }
}
