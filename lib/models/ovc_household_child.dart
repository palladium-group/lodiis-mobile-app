import 'package:kb_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';

class OvcHouseholdChild {
  String? id;
  String? primaryUIC;
  String? secondaryUIC;
  String? firstName;
  String? middleName;
  String? surname;
  String? sex;
  String? age;
  String? phoneNumber;
  String? orgUnit;
  String? createdDate;
  String? hivStatus;
  bool? enrollmentOuAccessible;
  String? ovcStatus;
  bool? isChildPrimary;
  bool? hasExitedProgram;
  String? artInitiationDate;
  TrackedEntityInstance? teiData;

  OvcHouseholdChild({
    this.id,
    this.primaryUIC,
    this.secondaryUIC,
    this.firstName,
    this.middleName,
    this.surname,
    this.sex,
    this.age,
    this.phoneNumber,
    this.orgUnit,
    this.createdDate,
    this.hivStatus,
    this.enrollmentOuAccessible,
    this.isChildPrimary,
    this.ovcStatus,
    this.teiData,
    this.artInitiationDate,
    this.hasExitedProgram,
  });

  bool get isClHiv => '$hivStatus' == 'Positive';

  Map toMap({
    required String parentId,
  }) {
    Map dataObject = {
      "parentTrackedEntityInstance": parentId,
      "orgUnit": orgUnit,
      "enrollmentDate": createdDate,
      "incidentDate": createdDate,
      "trackedEntityInstance": id,
    };
    for (Map attributeObj in teiData!.attributes ?? []) {
      dataObject[attributeObj['attribute']] = attributeObj['value'];
    }
    return dataObject;
  }

  OvcHouseholdChild fromTeiModel(
    TrackedEntityInstance tei,
    String? orgUnit,
    String? createdDate,
    bool? enrollmentOuAccessible,
  ) {
    List keys = [
      'WTZ7GLTrE8Q',
      's1HaiT6OllL',
      'rSP9c21JsfC',
      'ls9hlz2tyol',
      'vIX4GTSCX4P',
      'wmKqYZML8GA',
      'PN92g65TkVI',
      'KO5NC4pfBmv',
      'qZP982qpSPS',
      'EIMgHQW61kx',
      BeneficiaryIdentification.phoneNumber,
      BeneficiaryIdentification.primaryUIC,
      BeneficiaryIdentification.secondaryUIC,
      OvcInterventionConstant.programStatus,
    ];
    Map data = {};
    for (Map attributeObject in tei.attributes) {
      String? attribute = attributeObject['attribute'];
      if (attribute != null && keys.contains(attribute)) {
        data[attribute] = '${attributeObject['value']}'.trim();
      }
    }
    int age = AppUtil.getAgeInYear(data['qZP982qpSPS']);
    return OvcHouseholdChild(
        id: tei.trackedEntityInstance,
        firstName: data['WTZ7GLTrE8Q'] ?? '',
        middleName: data['s1HaiT6OllL'] ?? '',
        surname: data['rSP9c21JsfC'] ?? '',
        sex: data['vIX4GTSCX4P'] ?? '',
        age: '$age',
        phoneNumber: data[BeneficiaryIdentification.phoneNumber] ?? '',
        primaryUIC: data[BeneficiaryIdentification.primaryUIC] ?? '',
        secondaryUIC: data[BeneficiaryIdentification.secondaryUIC] ?? '',
        createdDate: createdDate,
        artInitiationDate: data['EIMgHQW61kx'],
        hivStatus: data['wmKqYZML8GA'] != null
            ? data['wmKqYZML8GA'] == 'true'
                ? 'Positive'
                : 'Negative'
            : '',
        enrollmentOuAccessible: enrollmentOuAccessible,
        isChildPrimary: "${data['KO5NC4pfBmv']}" == 'true',
        ovcStatus: data['PN92g65TkVI'] ?? '',
        orgUnit: orgUnit,
        teiData: tei,
        hasExitedProgram:
            data[OvcInterventionConstant.programStatus] == 'Exit');
  }

  @override
  String toString() {
    return '$firstName $surname';
  }
}
