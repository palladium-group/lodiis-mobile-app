import 'package:lncmis_mobile_app/core/utils/app_util.dart';

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

  Map toOffline() {
    DateTime currentDateTime = DateTime.now();
    Map mapData = <String, dynamic>{};
    mapData['id'] = id ?? AppUtil.getUid();
    mapData['type'] = type ?? '';
    mapData['message'] = message ?? '';
    mapData['date'] = date ?? currentDateTime.toString().split('.')[0];
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
