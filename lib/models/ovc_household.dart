import 'package:kb_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';

class OvcHousehold {
  String? id;
  String? firstName;
  String? middleName;
  String? surname;
  String? location;
  String? phoneNumber;
  String? age;
  String? village;
  String? orgUnit;
  String? createdDate;
  String? primaryUIC;
  String? hivStatus;
  String? secondaryUIC;
  String? ovcMaleCount;
  String? ovcFemaleCount;
  String? houseHoldStatus;
  String? houseHoldCategorization;
  String? implementingPartner;
  String? searchableValue;
  bool? enrollmentOuAccessible;
  bool? primaryChildExist;
  bool? primaryChildHasExited;
  bool? hasExitedProgram;
  List<OvcHouseholdChild>? children;
  Map? dataObject;
  TrackedEntityInstance? teiData;

  OvcHousehold({
    this.id,
    this.firstName,
    this.middleName,
    this.surname,
    this.ovcMaleCount,
    this.children,
    this.primaryUIC,
    this.secondaryUIC,
    this.hivStatus,
    this.location,
    this.phoneNumber,
    this.age,
    this.village,
    this.orgUnit,
    this.createdDate,
    this.ovcFemaleCount,
    this.houseHoldStatus,
    this.houseHoldCategorization,
    this.searchableValue,
    this.enrollmentOuAccessible,
    this.implementingPartner,
    this.teiData,
    this.primaryChildExist,
    this.primaryChildHasExited,
    this.hasExitedProgram,
    this.dataObject,
  });

  OvcHousehold fromTeiModel(
    TrackedEntityInstance tei,
    String? location,
    String? orgUnit,
    String? createdDate,
    bool? enrollmentOuAccessible,
    List<OvcHouseholdChild> children,
  ) {
    List<String> phoneNumberIds = ['tNdoR0jYr7R', 'cvrdI9t4rtN'];
    List<String> keys = [
      'tNdoR0jYr7R',
      'cvrdI9t4rtN',
      'tNdoR0jYr7R',
      'WTZ7GLTrE8Q',
      's1HaiT6OllL',
      'rSP9c21JsfC',
      'kQehaqmaygZ',
      'BXUNH6LXeGA',
      'PN92g65TkVI',
      'RB8Wx75hGa4',
      'qZP982qpSPS',
      'oSKX8fFQdWc',
      OvcInterventionConstant.programStatus,
      BeneficiaryIdentification.householdCategorization,
      UserAccountReference.implementingPartnerAttribute,
      BeneficiaryIdentification.primaryUIC,
      BeneficiaryIdentification.secondaryUIC
    ];
    Map<String, dynamic> data = {};
    for (Map attributeObject in tei.attributes) {
      String? attribute = attributeObject['attribute'];

      if (attribute != null && keys.contains(attribute)) {
        data[attribute] = '${attributeObject['value']}'.trim();
      }
    }
    String village = data['RB8Wx75hGa4'] ?? '';
    String hivStatus = data['oSKX8fFQdWc'] ?? '';
    String phoneNumber = getPhoneNumbers(data, phoneNumberIds);
    int maleCount = getChildCountBySex(children, 'male');
    int femaleCount = getChildCountBySex(children, 'female');
    int age = AppUtil.getAgeInYear(data['qZP982qpSPS']);
    return OvcHousehold(
      id: tei.trackedEntityInstance,
      firstName: data['WTZ7GLTrE8Q'] ?? '',
      middleName: data['s1HaiT6OllL'] ?? '',
      surname: data['rSP9c21JsfC'] ?? '',
      location: location,
      age: '$age',
      phoneNumber: phoneNumber != "" ? phoneNumber : 'N/A',
      village: village != "" ? village : 'N/A',
      orgUnit: orgUnit,
      createdDate: createdDate,
      ovcMaleCount: '$maleCount',
      ovcFemaleCount: '$femaleCount',
      hivStatus: hivStatus,
      primaryUIC: data[BeneficiaryIdentification.primaryUIC] ?? '',
      secondaryUIC: data[BeneficiaryIdentification.secondaryUIC] ?? '',
      houseHoldStatus: data['PN92g65TkVI'] ?? '',
      houseHoldCategorization: data['uetInX0KTfc'] ?? '',
      implementingPartner:
          data[UserAccountReference.implementingPartnerAttribute] ?? '',
      enrollmentOuAccessible: enrollmentOuAccessible,
      searchableValue:
          "${data['WTZ7GLTrE8Q'] ?? ''} ${data['s1HaiT6OllL'] ?? ''} ${data['rSP9c21JsfC'] ?? ''} ${data[BeneficiaryIdentification.beneficiaryId] ?? ''} $location $createdDate"
              .toLowerCase(),
      primaryChildExist: _doesPrimaryChildExist(children),
      primaryChildHasExited: _hasPrimaryChildExited(children),
      children: children,
      teiData: tei,
      dataObject: data,
      hasExitedProgram: data[OvcInterventionConstant.programStatus] == 'Exit',
    );
  }

  bool _doesPrimaryChildExist(List<OvcHouseholdChild> children) {
    return children
        .any((OvcHouseholdChild child) => child.isChildPrimary == true);
  }

  bool _hasPrimaryChildExited(List<OvcHouseholdChild> children) {
    List<OvcHouseholdChild> primaryChildren = children
        .where((OvcHouseholdChild child) => child.isChildPrimary == true)
        .toList();
    return primaryChildren.isNotEmpty &&
        primaryChildren
            .every((OvcHouseholdChild child) => child.ovcStatus == 'Exit');
  }

  String getPhoneNumbers(
    Map<String, dynamic> data,
    List<String> phoneNumberIds,
  ) {
    return phoneNumberIds
        .map((String phoneNumberId) => data[phoneNumberId] ?? "")
        .toList()
        .where((phoneNumber) => phoneNumber.isNotEmpty)
        .toList()
        .join("/");
  }

  int getChildCountBySex(List<OvcHouseholdChild> children, String sex) {
    return children
        .where((child) => child.sex!.toLowerCase() == sex)
        .toList()
        .length;
  }

  @override
  String toString() {
    return '$firstName $surname';
  }
}
