import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lncmis_mobile_app/models/notification.dart';

class LocalNotificationService {
  static selectNotification(payload) async {}

  static init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static show(
      {required String message, required String title, String? id}) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformChannelSpecifics,
      payload: id,
    );
  }
}
