import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/app.dart';
import 'package:lncmis_mobile_app/core/services/local_notification_service.dart';
import 'package:lncmis_mobile_app/core/services/workmanager_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WorkmanagerService.init();
  LocalNotificationService.init();
  runApp(
    const MyApp(),
  );
}
