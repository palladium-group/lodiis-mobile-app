import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/app_info_state/app_info_state.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/access_to_data_entry/access_to_data_entry_warning.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/intervention_app_bar.dart';
import 'package:kb_mobile_app/core/constants/auto_synchronization.dart';
import 'package:kb_mobile_app/core/services/auto_synchronization_service.dart';
import 'package:kb_mobile_app/core/services/data_quality_service.dart';
import 'package:kb_mobile_app/core/services/device_connectivity_provider.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_bar_util.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/core/utils/app_version_update.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/ogac_intervention/pages/ogac_enrollment_form.dart';
import 'package:kb_mobile_app/modules/ogac_intervention/pages/ogac_intervention_home.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

import 'constants/ogac_routes_constant.dart';

class OgacIntervention extends StatefulWidget {
  OgacIntervention({Key? key}) : super(key: key);

  @override
  _OgacInterventionState createState() => _OgacInterventionState();
}

class _OgacInterventionState extends State<OgacIntervention> {
  final bool disableSelectionOfActiveIntervention = true;
  bool isViewReady = false;
  late Timer periodicTimer;
  late StreamSubscription connectionSubscription;
  int syncTimeout = AutoSynchronization.syncTimeout;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        isViewReady = true;
      });
    });
    DataQualityService.runDataQualityCheckResolution();
    connectionSubscription = DeviceConnectivityProvider()
        .checkChangeOfDeviceConnectionStatus(context);
    checkAppVersion();
    periodicTimer =
        Timer.periodic(Duration(minutes: syncTimeout), (Timer timer) {
      Provider.of<CurrentUserState>(context, listen: false)
          .getAndSetCurrentUserDataEntryAuthorityStatus();
      AutoSynchronizationService().startAutoUpload(context);
    });
  }

  @override
  void dispose() {
    periodicTimer.cancel();
    connectionSubscription.cancel();
    super.dispose();
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
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (shouldShowUpdateWarning && versionStatus != null) {
        AppVersionUpdate.showAppUpdateWarning(context, versionStatus);
      }
    });
  }

  void onClickHome() {}

  void onAddOgacBeneficiary(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId = "${OgacRoutesConstant.pageModule}_$beneficiaryId";
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
            return OgacEnrollmentForm();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(105),
                child: InterventionAppBar(
                  activeInterventionProgram: activeInterventionProgram,
                  onClickHome: onClickHome,
                  onAddOgacBeneficiary: () => onAddOgacBeneficiary(context),
                  onOpenMoreMenu: () => onOpenMoreMenu(
                    context,
                    activeInterventionProgram,
                  ),
                ),
              ),
              body: Consumer<CurrentUserState>(
                  builder: (context, currentUserState, child) {
                bool hasAccessToDataEntry =
                    currentUserState.canCurrentUserDoDataEntry;
                return Container(
                  child: !isViewReady
                      ? Container(
                          margin: EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: CircularProcessLoader(
                            color: Colors.blueGrey,
                          ),
                        )
                      : !hasAccessToDataEntry
                          ? AccessToDataEntryWarning()
                          : Container(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          activeInterventionProgram.background,
                                    ),
                                  ),
                                  Container(
                                    child: OgacInterventionHome(),
                                  ),
                                ],
                              ),
                            ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
