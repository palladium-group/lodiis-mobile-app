import 'package:kb_mobile_app/core/utils/app_util.dart';

class AppLogs {
  String? id;
  String? type;
  String? message;
  String? date;
  String? searchableValue;

  AppLogs({
    this.id,
    this.type,
    this.message,
    this.date,
  });

  @override
  String toString() {
    return 'logs <$message>';
  }

  Map toOffline(AppLogs logs) {
    DateTime currentDateTime = DateTime.now();
    Map mapData = <String, dynamic>{};
    mapData['id'] = logs.id ?? AppUtil.getUid();
    mapData['type'] = logs.type ?? '';
    mapData['message'] = logs.message ?? '';
    mapData['date'] = logs.date ?? currentDateTime.toString().split('.')[0];
    return mapData;
  }

  AppLogs.fromOffline(Map<String, dynamic> mapData) {
    id = mapData['id'];
    type = mapData['type'];
    message = mapData['message'];
    date = mapData['date'];
    searchableValue = '${type!.toLowerCase()} ${message!.toLowerCase()} $date';
  }
}
