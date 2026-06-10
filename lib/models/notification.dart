import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lncmis_mobile_app/core/constants/app_info_reference.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
  AppUtil.getUid(),
  AppInfoReference.currentAppName,
  channelDescription: AppInfoReference.currentAppName,
  importance: Importance.defaultImportance,
  priority: Priority.low,
  icon: "app_icon",
  ticker: 'ticker',
);

NotificationDetails platformChannelSpecifics = NotificationDetails(
  android: androidPlatformChannelSpecifics,
);
