import 'dart:convert';

class Events {
  String? event;
  String? eventDate;
  String? program;
  String? programStage;
  String? trackedEntityInstance;
  String? status;
  String? orgUnit;
  String? syncStatus;
  bool? enrollmentOuAccessible;
  dynamic dataValues;

  Events({
    this.event,
    this.eventDate,
    this.program,
    this.programStage,
    this.trackedEntityInstance,
    this.status,
    this.orgUnit,
    this.syncStatus,
    this.dataValues,
  });

  @override
  String toString() {
    return 'event <$event> eventDate <$eventDate> enrollmentOuAccessible <$enrollmentOuAccessible>';
  }

  bool get isSynced => syncStatus == "synced";

  Events fromJson(dynamic json) {
    return Events(
      event: json['event'],
      eventDate: "${json['eventDate']}".split('T')[0],
      program: json['program'],
      programStage: json['programStage'],
      trackedEntityInstance: json['trackedEntityInstance'] ?? '',
      orgUnit: json['orgUnit'],
      status: json['status'],
      dataValues: json['dataValues'],
      syncStatus: json['syncStatus'] ?? 'synced',
    );
  }

  String toJson(Events event) {
    return json.encode(toOffline(event));
  }

  Map toOffline(Events eventData) {
    Map mapData = <String, dynamic>{};
    mapData['event'] = eventData.event;
    mapData['eventDate'] = eventData.eventDate;
    mapData['program'] = eventData.program;
    mapData['programStage'] = eventData.programStage;
    mapData['trackedEntityInstance'] = eventData.trackedEntityInstance;
    mapData['status'] = eventData.status;
    mapData['orgUnit'] = eventData.orgUnit;
    mapData['syncStatus'] = eventData.syncStatus;
    mapData['dataValues'] = eventData.dataValues;
    //dataValues.removeWhere((item)=>item['dataElement'] == 'eventDate');
    return mapData;
  }

  Events.fromOffline(Map<String, dynamic> mapData) {
    event = mapData['event'];
    eventDate = mapData['eventDate'];
    program = mapData['program'];
    programStage = mapData['programStage'];
    trackedEntityInstance = mapData['trackedEntityInstance'];
    status = mapData['status'];
    orgUnit = mapData['orgUnit'];
    syncStatus = mapData['syncStatus'];
    dataValues = mapData['dataValues'];
  }

  String getServiceFormEventLabel() {
    String serviceFormIntervention = 'Eug4BXDFLym';
    String serviceFormSessionNumber = 'vL6NpUA0rIU';

    List<Map> sanitizedDataValues = _getSanitizedDataValues();
    Map intervention = (sanitizedDataValues).firstWhere(
        (Map dataValue) => dataValue['dataElement'] == serviceFormIntervention,
        orElse: () => {});
    Map sessionNumber = (sanitizedDataValues).firstWhere(
        (Map dataValue) => dataValue['dataElement'] == serviceFormSessionNumber,
        orElse: () => {});

    return intervention.isNotEmpty
        ? "${intervention['value']}${sessionNumber.isNotEmpty ? ' - Session Number ${sessionNumber["value"]}' : ''}"
        : "Service";
  }

  List<Map> _getSanitizedDataValues() {
    List<Map> sanitizedDataValues = [];
    for (Map dataValue in dataValues) {
      sanitizedDataValues.add({
        "dataElement": "${dataValue['dataElement']}",
        "value": dataValue['value']
      });
    }
    return sanitizedDataValues;
  }
}
