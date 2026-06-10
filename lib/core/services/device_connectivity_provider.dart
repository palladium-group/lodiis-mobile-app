import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:lncmis_mobile_app/core/constants/app_logs_constants.dart';
import 'package:lncmis_mobile_app/core/offline_db/app_logs_offline/app_logs_offline_provider.dart';
import 'package:lncmis_mobile_app/models/app_logs.dart';
import 'package:provider/provider.dart';

class DeviceConnectivityProvider {
  StreamSubscription checkChangeOfDeviceConnectionStatus(BuildContext context) {
    return Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) async {
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        Provider.of<DeviceConnectivityState>(context, listen: false)
            .changeConnectivityStatus(isConnected: true);
      } else if (connectivityResult == ConnectivityResult.none) {
        Provider.of<DeviceConnectivityState>(context, listen: false)
            .changeConnectivityStatus(isConnected: false);
      } else {
        Provider.of<DeviceConnectivityState>(context, listen: false)
            .changeConnectivityStatus(isConnected: false);
        AppLogs log = AppLogs(
            type: AppLogsConstants.errorLogType,
            message: 'Failed to get connectivity.');
        await AppLogsOfflineProvider().addLogs(log);
      }
    });
  }
}
