import 'package:kb_mobile_app/core/constants/auto_synchronization.dart';
import 'package:kb_mobile_app/core/constants/workmanager_constants.dart';
import 'package:kb_mobile_app/core/services/app_info_service.dart';
import 'package:kb_mobile_app/core/services/dreams_background_re_assessment_service.dart';
import 'package:kb_mobile_app/core/services/preference_provider.dart';
import 'package:kb_mobile_app/core/services/synchronization_service.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_re_assessment_constant.dart';
import 'package:workmanager/workmanager.dart';

@pragma("vm:entry-point")
@pragma("vm:entry-point", true)
@pragma("vm:entry-point", !const bool.fromEnvironment("dart.vm.product"))
@pragma("vm:entry-point", "call")
callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    var autoSyncTaskName = WorkmanagerConstants.autoSync;
    var reAssessmentEvaluation = WorkmanagerConstants.reAssessmentEvaluation;
    try {
      if (task == reAssessmentEvaluation) {
        await DreamsBackgroundReAssessmentService.startProcess();
      }
      if (task == autoSyncTaskName) {
        await AppInfoService.updateAppStoreVersion();
        CurrentUser? currentUser = await UserService().getCurrentUser();
        if (currentUser != null) {
          SynchronizationService synchronizationService =
              SynchronizationService(currentUser.username, currentUser.password,
                  currentUser.programs, currentUser.userOrgUnitIds);
          await synchronizationService.initiateBackgroundDataSync(currentUser);
        }
      }
      return Future.value(true);
    } catch (err) {
      return Future.value(false);
    }
  });
}
@pragma("vm:entry-point")
@pragma("vm:entry-point", true)
@pragma("vm:entry-point", !const bool.fromEnvironment("dart.vm.product"))
class WorkmanagerService {
  static void init() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  static startTasks() async {
    var autoSync = await PreferenceProvider.getPreferenceValue(
      WorkmanagerConstants.autoSync,
    );
    var reAssessment = await PreferenceProvider.getPreferenceValue(
      WorkmanagerConstants.reAssessmentEvaluation,
    );

    if (reAssessment != "true") {
      var reAssessmentEvaluation = WorkmanagerConstants.reAssessmentEvaluation;
      var reAssessmentTimeout = const Duration(
        minutes: AgywDreamReAssessmentConstants.reAssessmentTimeout,
      );
      await Workmanager()
          .registerPeriodicTask(reAssessmentEvaluation, reAssessmentEvaluation,
              initialDelay: const Duration(minutes: 5),
              existingWorkPolicy: ExistingWorkPolicy.replace,
              frequency: reAssessmentTimeout,
              constraints: Constraints(
                networkType: NetworkType.notRequired,
              ));
      await PreferenceProvider.setPreferenceValue(
        WorkmanagerConstants.reAssessmentEvaluation,
        "true",
      );
    }

    if (autoSync != "true") {
      var autoSyncTaskName = WorkmanagerConstants.autoSync;
      var syncTimeOut = const Duration(
        minutes: AutoSynchronization.syncInterval,
      );
      await Workmanager().registerPeriodicTask(
        autoSyncTaskName,
        autoSyncTaskName,
        frequency: syncTimeOut,
        initialDelay: const Duration(minutes: 15),
        existingWorkPolicy: ExistingWorkPolicy.replace,
        constraints: Constraints(networkType: NetworkType.connected),
      );
      await PreferenceProvider.setPreferenceValue(
        WorkmanagerConstants.autoSync,
        "true",
      );
    }
  }

  static stop() async {
    Workmanager().cancelAll();
  }
}
