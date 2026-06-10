import 'package:lncmis_mobile_app/core/constants/auto_synchronization.dart';
import 'package:lncmis_mobile_app/core/constants/workmanager_constants.dart';
import 'package:lncmis_mobile_app/core/services/app_info_service.dart';
import 'package:lncmis_mobile_app/core/services/preference_provider.dart';
import 'package:lncmis_mobile_app/core/services/synchronization_service.dart';
import 'package:lncmis_mobile_app/core/services/user_service.dart';
import 'package:lncmis_mobile_app/models/current_user.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
@pragma('vm:entry-point', true)
@pragma('vm:entry-point', !const bool.fromEnvironment('dart.vm.product'))
@pragma('vm:entry-point', 'call')
callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final autoSyncTaskName = WorkmanagerConstants.autoSync;
    try {
      if (task == autoSyncTaskName) {
        await AppInfoService.updateAppStoreVersion();
        final CurrentUser? currentUser = await UserService().getCurrentUser();
        if (currentUser != null) {
          final SynchronizationService synchronizationService = SynchronizationService(
            currentUser.username,
            currentUser.password,
            currentUser.programs,
            currentUser.userOrgUnitIds,
          );
          await synchronizationService.initiateBackgroundDataSync(currentUser);
        }
      }
      return Future.value(true);
    } catch (_) {
      return Future.value(false);
    }
  });
}

@pragma('vm:entry-point')
@pragma('vm:entry-point', true)
@pragma('vm:entry-point', !const bool.fromEnvironment('dart.vm.product'))
class WorkmanagerService {
  static void init() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  static startTasks() async {
    final autoSync = await PreferenceProvider.getPreferenceValue(WorkmanagerConstants.autoSync);
    if (autoSync != 'true') {
      final autoSyncTaskName = WorkmanagerConstants.autoSync;
      final syncTimeOut = const Duration(minutes: AutoSynchronization.syncInterval);
      await Workmanager().registerPeriodicTask(
        autoSyncTaskName,
        autoSyncTaskName,
        frequency: syncTimeOut,
        initialDelay: const Duration(minutes: 15),
        existingWorkPolicy: ExistingWorkPolicy.replace,
        constraints: Constraints(networkType: NetworkType.connected),
      );
      await PreferenceProvider.setPreferenceValue(WorkmanagerConstants.autoSync, 'true');
    }
  }

  static stop() async {
    Workmanager().cancelAll();
  }
}
