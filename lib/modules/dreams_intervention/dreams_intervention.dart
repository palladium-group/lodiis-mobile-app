import 'dart:async';

import 'package:flutter/material.dart';
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
import 'package:kb_mobile_app/models/Intervention_bottom_navigation.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/dreams_enrollment_page.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/pages/agyw_dreams_consent.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_records/dreams_records_page.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_referral/dreams_referral_page.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_referral/dreams_incoming_referral_page.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/dreams_services_page.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/none_agyw.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/pages/non_agyw_dreams_hts_consent_form.dart';
import 'package:new_version_plus/model/version_status.dart';
import 'package:provider/provider.dart';

class DreamsIntervention extends StatefulWidget {
  const DreamsIntervention({Key? key}) : super(key: key);

  @override
  State<DreamsIntervention> createState() => _DreamsInterventionState();
}

class _DreamsInterventionState extends State<DreamsIntervention>
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
      setState(() {
        isViewReady = true;
        setTabsController();
      });
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
        InterventionRecordsPageTabs.dreamsModule;

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

  void onClickHome() {}

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

  void onAddNoneAgywBeneficiary(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId =
        "${DreamsRoutesConstant.noneAgywHtsConsentPage}_$beneficiaryId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave);
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const NonAgywDreamsHTSConsentForm();
          },
        ),
      );
    }
  }

  void onAddAgywBeneficiary(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywConsentPage}_$beneficiaryId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave);
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const AgywDreamsConsentForm();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<CurrentUserState>(
        builder: (context, currentUserState, child) {
          return Consumer<InterventionCardState>(
            builder: (context, interventionCardState, child) {
              InterventionCard activeInterventionProgram =
                  interventionCardState.currentInterventionProgram;
              return Consumer<InterventionBottomNavigationState>(
                  builder: (context, interventionBottomNavigationState, child) {
                InterventionBottomNavigation
                    currentInterventionBottomNavigation =
                    interventionBottomNavigationState
                        .getCurrentInterventionBottomNavigation(
                            activeInterventionProgram,
                            currentUserState.implementingPartner);
                return Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(110),
                    child: InterventionAppBar(
                      activeInterventionProgram: activeInterventionProgram,
                      tabController: tabController,
                      tabs: tabsItems,
                      hasTabs:
                          currentInterventionBottomNavigation.id == 'records',
                      onClickHome: onClickHome,
                      onAddAgywBeneficiary: () => onAddAgywBeneficiary(context),
                      onAddNoneAgywBeneficiary: () =>
                          onAddNoneAgywBeneficiary(context),
                      onOpenMoreMenu: () =>
                          onOpenMoreMenu(context, activeInterventionProgram),
                    ),
                  ),
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
                                    Consumer<InterventionBottomNavigationState>(
                                      builder: (context,
                                          interventionBottomNavigationState,
                                          child) {
                                        InterventionBottomNavigation
                                            currentInterventionBottomNavigation =
                                            interventionBottomNavigationState
                                                .getCurrentInterventionBottomNavigation(
                                                    activeInterventionProgram,
                                                    currentUserState
                                                        .implementingPartner);
                                        return Container(
                                          child: currentInterventionBottomNavigation
                                                      .id ==
                                                  'services'
                                              ? const DreamsServicesPage()
                                              : currentInterventionBottomNavigation
                                                          .id ==
                                                      'outGoingReferral'
                                                  ? const DreamsReferralPage()
                                                  : currentInterventionBottomNavigation
                                                              .id ==
                                                          'enrollment'
                                                      ? const DreamsEnrollmentPage()
                                                      : currentInterventionBottomNavigation
                                                                  .id ==
                                                              'noneAgyw'
                                                          ? const NoneAgyw()
                                                          : currentInterventionBottomNavigation
                                                                      .id ==
                                                                  'incomingReferral'
                                                              ? const DreamsIncomingReferralPage()
                                                              : currentInterventionBottomNavigation
                                                                          .id ==
                                                                      'records'
                                                                  ? DreamsRecordsPage(
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
                                        );
                                      },
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
    );
  }
}
