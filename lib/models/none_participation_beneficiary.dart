import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:lncmis_mobile_app/models/events.dart';

class NoneParticipationBeneficiary {
  String? event;
  String? eventDate;
  String? program;
  String? programStage;
  String? firstname;
  String? surname;
  String? age;
  String? sex;
  String? phoneNumber;
  String? searchableValue;
  String? reason;
  bool? isMaleBeneficiary;
  bool? enrollmentOuAccessible;
  Events? eventData;

  NoneParticipationBeneficiary({
    this.event,
    this.eventDate,
    this.program,
    this.programStage,
    this.firstname,
    this.surname,
    this.age,
    this.phoneNumber,
    this.sex,
    this.searchableValue,
    this.enrollmentOuAccessible,
    this.isMaleBeneficiary,
    this.reason,
    this.eventData,
  });

  NoneParticipationBeneficiary fromEventsModel(Events eventData) {
    List<String> keys = [
      'JhOvli80Qbx',
      'jjZWuJfVStp',
      'ox6mydZjgC3',
      'jVSwC6Ln95H',
      'an7w8LYPZ7y',
      'FHn0nJPumhO'
    ];

    Map data = {};

    for (Map detailObj in eventData.dataValues) {
      String? dataElements = detailObj['dataElement'];
      if (dataElements != null && keys.contains(dataElements)) {
        data[dataElements] = '${detailObj['value']}'.trim();
      }
    }

    int age = AppUtil.getAgeInYear(data['jVSwC6Ln95H']);
    String phoneNumber = data["ox6mydZjgC3"] ?? '';
    String sex = data['an7w8LYPZ7y'] ?? '';
    bool isMaleBeneficiary = sex.trim().toLowerCase() == "male";
    NoneParticipationBeneficiary beneficiary = NoneParticipationBeneficiary(
      event: eventData.event,
      eventDate: eventData.eventDate,
      program: eventData.program,
      programStage: eventData.programStage,
      age: age.toString(),
      phoneNumber: phoneNumber != "" ? phoneNumber : 'N/A',
      firstname: data['JhOvli80Qbx'] ?? '',
      surname: data['jjZWuJfVStp'] ?? '',
      sex: sex,
      isMaleBeneficiary: isMaleBeneficiary,
      searchableValue:
          "${data['an7w8LYPZ7y']} ${data['JhOvli80Qbx']}, ${data['jjZWuJfVStp']}",
      reason: data['FHn0nJPumhO'] ?? '',
      enrollmentOuAccessible: eventData.enrollmentOuAccessible,
      eventData: eventData,
    );
    return beneficiary;
  }

  @override
  String toString() {
    return '$firstname $surname';
  }
}
