import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_view.dart';
import 'package:provider/provider.dart';

class CasePlanGapServiceMonitoringViewContainer extends StatefulWidget {
  const CasePlanGapServiceMonitoringViewContainer({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap,
    required this.isHouseholdCasePlan,
    required this.enrollmentOuAccessible,
  }) : super(key: key);

  final String domainId;
  final Color formSectionColor;
  final Map casePlanGap;
  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;

  @override
  State<CasePlanGapServiceMonitoringViewContainer> createState() =>
      _CasePlanGapServiceMonitoringViewContainerState();
}

class _CasePlanGapServiceMonitoringViewContainerState
    extends State<CasePlanGapServiceMonitoringViewContainer> {
  void onManageCasePlanGapServiceMonitoring({
    Map? gapServiceMonitoringObject,
    bool isOnEditMode = true,
  }) async {
    double ratio = 0.8;
    gapServiceMonitoringObject = gapServiceMonitoringObject ?? {};
    String location = gapServiceMonitoringObject['location'] ?? '';
    String casePlanGapDate = widget.casePlanGap['eventDate'] ?? '';
    List skippedKeys = [
      'eventId',
      'eventDate',
      UserAccountReference.appAndDeviceTrackingDataElement,
      UserAccountReference.implementingPartnerDataElement,
      UserAccountReference.subImplementingPartnerDataElement,
      UserAccountReference.serviceProviderDataElement
    ];
    for (String key in widget.casePlanGap.keys
        .where((element) => !skippedKeys.contains(element))) {
      gapServiceMonitoringObject[key] =
          gapServiceMonitoringObject[key] ?? widget.casePlanGap[key];
    }
    gapServiceMonitoringObject['location'] = location;
    gapServiceMonitoringObject['casePlanDate'] =
        widget.casePlanGap['eventDate'];
    AppUtil.showActionSheetModal(
      context: context,
      initialHeightRatio: ratio,
      maxHeightRatio: ratio,
      containerBody: CasePlanGapServiceMonitoringFormContainer(
        domainId: widget.domainId,
        formSectionColor: widget.formSectionColor,
        gapServiceMonitoringObject: gapServiceMonitoringObject,
        isHouseholdCasePlan: widget.isHouseholdCasePlan,
        enrollmentOuAccessible: widget.enrollmentOuAccessible,
        isEditableMode: isOnEditMode,
        casePlanGapDate: casePlanGapDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OvcHouseholdCurrentSelectionState>(
        builder: ((context, state, child) {
      var hasBeneficiaryExited = widget.isHouseholdCasePlan
          ? state.currentOvcHousehold?.hasExitedProgram
          : state.currentOvcHousehold?.hasExitedProgram == true ||
              state.currentOvcHouseholdChild?.hasExitedProgram == true;
      return Container(
        margin: const EdgeInsets.symmetric(),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: CasePlanGapServiceMonitoringView(
                domainId: widget.domainId,
                formSectionColor: widget.formSectionColor,
                casePlanGap: widget.casePlanGap,
                isHouseholdCasePlan: widget.isHouseholdCasePlan,
                hasEditAccess: hasBeneficiaryExited != true,
                onViewCasePlanServiceMonitoring: (Map dataObject) =>
                    onManageCasePlanGapServiceMonitoring(
                        gapServiceMonitoringObject: dataObject,
                        isOnEditMode: false),
                onEditCasePlanServiceMonitoring: (Map dataObject) =>
                    onManageCasePlanGapServiceMonitoring(
                        gapServiceMonitoringObject: dataObject,
                        isOnEditMode: true),
              ),
            ),
            Visibility(
              visible: hasBeneficiaryExited != true,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: widget.formSectionColor,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.all(15.0),
                  ),
                  onPressed: onManageCasePlanGapServiceMonitoring,
                  child: Consumer<LanguageTranslationState>(
                    builder: (context, languageTranslationState, child) => Text(
                      languageTranslationState.isSesothoLanguage
                          ? 'KENYA TLHOKOMELO'
                          : 'ADD MONITORING',
                      style: const TextStyle().copyWith(
                        color: widget.formSectionColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }));
  }
}
