import 'package:kb_mobile_app/models/events.dart';

class ServiceEvent {
  String? event;
  String? programStage;
  String? interventionType;
  String? interventionGroup;
  String? sessionNumber;
  Events? eventData;

  ServiceEvent(
      {this.event,
      this.programStage,
      this.eventData,
      this.interventionType,
      this.interventionGroup,
      this.sessionNumber});

  ServiceEvent getServiceSessions(Events events) {
    List keys = [
      'Eug4BXDFLym',
      'vL6NpUA0rIU',
    ];

    Map data = {};
    for (Map dataValues in events.dataValues) {
      String? attribute = dataValues['dataElement'];
      if (attribute != null && keys.contains(attribute)) {
        data[attribute] = '${dataValues['value']}'.trim();
      }
    }

    var sessionNumber = data['vL6NpUA0rIU'] != '' && data['vL6NpUA0rIU'] != null
        ? data['vL6NpUA0rIU']
        : '0';
    return ServiceEvent(
        event: events.event,
        programStage: events.programStage,
        interventionType: data['Eug4BXDFLym'] ?? '',
        interventionGroup: assignInterventionGroup(data['Eug4BXDFLym'] ?? ''),
        sessionNumber: '$sessionNumber'.toLowerCase(),
        eventData: events);
  }

  String assignInterventionGroup(String interventionType) {
    if (interventionType == 'AFLATEEN/TOUN' ||
        interventionType == 'PTS 4 NON-GRADS' ||
        interventionType == 'PTS 4-GRADS' ||
        interventionType == 'Go Girls') {
      return '(SAB) Social Assets Building';
    } else if (interventionType == 'SILC' ||
        interventionType == 'SAVING GROUP' ||
        interventionType == 'FinancialLiteracyEducation') {
      return '(ES) Economic Strengthening';
    } else if (interventionType == 'STEPPING STONES' ||
        interventionType == 'IPC' ||
        interventionType == 'LBSE') {
      return 'HIV & VIOLENCE PREVENTION';
    } else if (interventionType == 'PARENTING') {
      return 'PARENTING';
    } else if (interventionType == 'GBV Messaging') {
      return 'GBV Messaging';
    } else if (interventionType == 'VAC Messaging') {
      return 'VAC Messaging';
    } else if (interventionType == 'VAC Legal Messaging') {
      return 'VAC LEGAL MESSAGING';
    } else if (interventionType == 'GBV Legal Messaging') {
      return 'GBV LEGAL MESSAGING';
    } else {
      return '';
    }
  }
}
