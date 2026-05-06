import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/Intervention_bottom_navigation.dart';
import 'package:new_version_plus/model/version_status.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/app_info_state/app_info_state.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_bottom_navigation_state/intervention_bottom_navigation_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/access_to_data_entry/access_to_data_entry_warning.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/intervention_app_bar.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/route_page_not_found.dart';
import 'package:kb_mobile_app/core/constants/auto_synchronization.dart';
import 'package:kb_mobile_app/core/constants/interventions_records_page_tabs.dart';
import 'package:kb_mobile_app/core/services/device_connectivity_provider.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/core/utils/app_bar_util.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/core/utils/app_version_update.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/ovc_enrollment_page.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/pages/ovc_enrollment_consent_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_page.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_records/ovc_records_page.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_page.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_page.dart';

class OvcIntervention extends StatefulWidget {
  const OvcIntervention({Key? key}) : super(key: key);

  @override
  State<OvcIntervention> createState() => _OvcInterventionState();
}

class _OvcInterventionState extends State<OvcIntervention>
    with TickerProviderStateMixin {
  final bool disableSelectionOfActiveIntervention = true;
  bool isViewReady = false;
  late Timer periodicTimer;
  late StreamSubscription connectionSubscription;
  TabController? tabController;
  late List<Widget> tabsItems = [];
  late List<Widget> tabsViews = [];
  int syncInterval = AutoSynchronization.syncInterval;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      isViewReady = true;
      setTabsController();
      setState(() {});
    });
    connectionSubscription = DeviceConnectivityProvider()
        .checkChangeOfDeviceConnectionStatus(context);
    checkAppVersion();
    periodicTimer =
        Timer.periodic(Duration(minutes: syncInterval), (Timer timer) {
      Provider.of<CurrentUserState>(context, listen: false)
          .getAndSetCurrentUserDataEntryAuthorityStatus();
    });
  }

  @override
  void dispose() {
    periodicTimer.cancel();
    connectionSubscription.cancel();
    tabController!.dispose();
    super.dispose();
  }

  void setTabsController() async {
    CurrentUser? user = await UserService().getCurrentUser();
    String currentUserImplementingPartner = user!.implementingPartner ?? '';

    Map<String, InterventionRecordsPageTabs> tabsMap =
        InterventionRecordsPageTabs.ovcModule;

    // Filter tabs based on the current implementing partner
    tabsMap.removeWhere((key, value) {
      List implementingPartners = value.implementingPartners ?? [];
      return implementingPartners.isNotEmpty &&
          !implementingPartners.contains(currentUserImplementingPartner);
    });

    tabsItems = tabsMap.keys.map((String key) {
      return Text(
        key,
      );
    }).toList();

    tabsViews = tabsMap.values.map((tabView) => tabView.page).toList();
    tabController = TabController(
      length: tabsItems.length,
      vsync: this,
    );
    setState(() {});
  }

  void onOpenMoreMenu(
    BuildContext context,
    InterventionCard activeInterventionProgram,
  ) async {
    AppBarUtil.onOpenMoreMenu(
      context,
      activeInterventionProgram,
      disableSelectionOfActiveIntervention,
    );
  }

  void checkAppVersion() async {
    bool shouldShowUpdateWarning =
        Provider.of<AppInfoState>(context, listen: false)
            .showWarningToAppUpdate;
    VersionStatus? versionStatus =
        Provider.of<AppInfoState>(context, listen: false).versionStatus;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (shouldShowUpdateWarning) {
        AppVersionUpdate.showAppUpdateWarning(context, versionStatus);
      }
    });
  }

  void onClickHome() {}

  void onAddHousehold(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId =
        "${OvcRoutesConstant.ovcConcentFormPage}_$beneficiaryId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave);
    Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const OvcEnrollmentConsentForm();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CurrentUserState>(
          builder: (context, currentUserState, child) {
            return Consumer<InterventionCardState>(
              builder: (context, interventionCardState, child) {
                InterventionCard activeInterventionProgram =
                    interventionCardState.currentInterventionProgram;
                return Consumer<InterventionBottomNavigationState>(builder:
                    (context, interventionBottomNavigationState, child) {
                  InterventionBottomNavigation
                      currentInterventionBottomNavigation =
                      interventionBottomNavigationState
                          .getCurrentInterventionBottomNavigation(
                    activeInterventionProgram,
                    currentUserState.implementingPartner,
                  );
                  return Scaffold(
                    appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(110),
                        child: InterventionAppBar(
                          tabController: tabController,
                          tabs: tabsItems,
                          hasTabs: currentInterventionBottomNavigation.id ==
                              'records',
                          activeInterventionProgram: activeInterventionProgram,
                          onClickHome: onClickHome,
                          onAddHousehold: () => onAddHousehold(context),
                          onOpenMoreMenu: () => onOpenMoreMenu(
                              context, activeInterventionProgram),
                        )),
                    body: Consumer<CurrentUserState>(
                        builder: (context, currentUserState, child) {
                      bool hasAccessToDataEntry =
                          currentUserState.canCurrentUserDoDataEntry;
                      return Container(
                        child: !isViewReady
                            ? Container(
                                margin: const EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: const CircularProcessLoader(
                                  color: Colors.blueGrey,
                                ),
                              )
                            : !hasAccessToDataEntry
                                ? const AccessToDataEntryWarning()
                                : Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: activeInterventionProgram
                                              .background,
                                        ),
                                      ),
                                      Container(
                                        child: currentInterventionBottomNavigation
                                                    .id ==
                                                'services'
                                            ? const OvcServicesPage()
                                            : currentInterventionBottomNavigation
                                                        .id ==
                                                    'referral'
                                                ? const OvcReferralPage()
                                                : currentInterventionBottomNavigation
                                                            .id ==
                                                        'enrollment'
                                                    ? const OvcEnrollmentPage()
                                                    : currentInterventionBottomNavigation
                                                                .id ==
                                                            'exit'
                                                        ? const OvcExitPage()
                                                        : currentInterventionBottomNavigation
                                                                    .id ==
                                                                'records'
                                                            ? OvcRecordsPage(
                                                                tabsController:
                                                                    tabController!,
                                                                tabsVieItems:
                                                                    tabsViews,
                                                              )
                                                            : RoutePageNotFound(
                                                                pageTitle:
                                                                    currentInterventionBottomNavigation
                                                                        .id,
                                                              ),
                                      ),
                                    ],
                                  ),
                      );
                    }),
                    bottomNavigationBar:
                        const InterventionBottomNavigationBarContainer(),
                  );
                });
              },
            );
          },
        ),
      ),
    );
  }
}
