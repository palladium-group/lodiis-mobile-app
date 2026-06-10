import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/app_state/app_logs_state/app_logs_state.dart';
import 'package:lncmis_mobile_app/app_state/intervention_bottom_navigation_state/intervention_bottom_navigation_state.dart';
import 'package:lncmis_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:lncmis_mobile_app/app_state/mgysd_case_management_list_state/mgysd_case_management_list_state.dart';
import 'package:lncmis_mobile_app/app_state/synchronization_state/synchronization_state.dart';
import 'package:lncmis_mobile_app/core/components/intervention_pop_up_menu.dart';
import 'package:lncmis_mobile_app/core/services/preference_provider.dart';
import 'package:lncmis_mobile_app/core/services/user_service.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:lncmis_mobile_app/models/intervention_card.dart';
import 'package:lncmis_mobile_app/modules/about_app/about_app.dart';
import 'package:lncmis_mobile_app/modules/app_logs/app_logs_page.dart';
import 'package:lncmis_mobile_app/modules/language_selection/language_selection.dart';
import 'package:lncmis_mobile_app/modules/login/login.dart';
import 'package:lncmis_mobile_app/modules/mgysd_case_management/mgysd_case_management.dart';
import 'package:lncmis_mobile_app/modules/synchronization/constants/synchronization_actions_constants.dart';
import 'package:lncmis_mobile_app/modules/synchronization/synchronization.dart';
import 'package:provider/provider.dart';

class AppBarUtil {
  static void onOpenMoreMenu(
    BuildContext context,
    InterventionCard activeInterventionProgram,
    final bool disableSelectionOfActiveIntervention,
  ) async {
    final modal = InterventionPopUpMenu(
      activeInterventionProgram: activeInterventionProgram,
      disableSelectionOfActiveIntervention: disableSelectionOfActiveIntervention,
    );
    final response = await AppUtil.showPopUpModal(context, modal, false);
    if (response == null) return;

    if (response.id == 'mgysd') {
      await _onSwitchToIntervention(context, 'mgysd');
    } else if (response.id == 'logout') {
      onLogOut(context);
    } else if (response.id == 'sync') {
      _onOpenSyncModule(context);
    } else if (response.id == 'language_setting') {
      _onOpenLanguageSettingModule(context);
    } else if (response.id == 'about') {
      _onOpenAboutAppModule(context);
    } else if (response.id == 'application_logs') {
      _onOpenApplicationLogsModule(context);
    }
  }

  static void _onOpenAboutAppModule(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutApp()));
  }

  static void _onOpenLanguageSettingModule(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LanguageSelection(showLanguageSettingAppBar: true),
      ),
    );
  }

  static void _onOpenSyncModule(BuildContext context) async {
    final syncState = Provider.of<SynchronizationState>(context, listen: false);
    final isBusy = syncState.isDataDownloadingActive || syncState.isDataUploadingActive;
    final int localCount = syncState.beneficiaryCount + syncState.beneficiaryServiceCount;
    const String lastDataDownloadDatePreferenceKey = 'lastSyncDatePreferenceKey';
    final String? lastSyncDate = await PreferenceProvider.getPreferenceValue(lastDataDownloadDatePreferenceKey);

    final String syncAction = isBusy
        ? ''
        : localCount > 0
            ? SynchronizationActionsConstants.downloadAndUpload
            : lastSyncDate == null || syncState.isDataAvailableForDownload
                ? SynchronizationActionsConstants.downloadAndUpload
                : '';

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Synchronization(synchronizationAction: syncAction)),
    );
  }

  static void onLogOut(BuildContext context) async {
    Provider.of<InterventionCardState>(context, listen: false).resetCurrentInterventionProgram();
    Provider.of<InterventionBottomNavigationState>(context, listen: false)
        .resetCurrentInterventionBottomNavigationIndex();
    await UserService().logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Login()));
  }

  static Future<void> _onOpenApplicationLogsModule(BuildContext context) async {
    await Provider.of<AppLogsState>(context, listen: false).refreshAppLogsNumber();
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AppLogsPage()));
  }

  static Future<void> _onSwitchToIntervention(BuildContext context, String? id) async {
    await Provider.of<MgysdCaseManagementListState>(context, listen: false).refreshMgysdCasesNumber();
    Provider.of<InterventionCardState>(context, listen: false).setCurrentInterventionProgramId('mgysd');
    Provider.of<InterventionBottomNavigationState>(context, listen: false)
        .setCurrentInterventionBottomNavigationStatus(0, null);
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MgysdCaseManagement()));
  }
}
