import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_view.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_service_provision_util.dart';
import 'package:provider/provider.dart';

class CasePlanGapServiceProvisionViewContainer extends StatefulWidget {
  const CasePlanGapServiceProvisionViewContainer({
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
  State<CasePlanGapServiceProvisionViewContainer> createState() =>
      _CasePlanGapServiceProvisionViewContainerState();
}

class _CasePlanGapServiceProvisionViewContainerState
    extends State<CasePlanGapServiceProvisionViewContainer> {
  void onManageCasePlanGapServiceProvision({
    Map? gapServiceObject,
    bool isOnEditMode = true,
  }) async {
    double ratio = 0.8;
    gapServiceObject = gapServiceObject ?? {};
    String location = gapServiceObject['location'] ?? '';
    String programStage = widget.isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
        : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;
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
      gapServiceObject[key] = gapServiceObject[key] ?? widget.casePlanGap[key];
    }
    gapServiceObject['casePlanDate'] = widget.casePlanGap['eventDate'];
    gapServiceObject['location'] = location;
    Map<String, List<String>> previousSessionMapping =
        OvcServiceProvisionUtil.getPreviousSessionMapping(
      context,
      [programStage],
    );
    gapServiceObject["previousSessionMapping"] = previousSessionMapping;
    AppUtil.showActionSheetModal(
      context: context,
      initialHeightRatio: ratio,
      maxHeightRatio: ratio,
      containerBody: CasePlanGapServiceProvisionFormContainer(
        gapServiceObject: gapServiceObject,
        isHouseholdCasePlan: widget.isHouseholdCasePlan,
        enrollmentOuAccessible: widget.enrollmentOuAccessible,
        domainId: widget.domainId,
        formSectionColor: widget.formSectionColor,
        isEditableMode: isOnEditMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OvcHouseholdCurrentSelectionState>(
        builder: (context, state, child) {
      var hasBeneficiaryExited =
          state.currentOvcHousehold?.hasExitedProgram == true ||
              (!widget.isHouseholdCasePlan &&
                  state.currentOvcHouseholdChild?.hasExitedProgram == true);
      return Container(
        margin: const EdgeInsets.symmetric(),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: CasePlanGapServiceProvisionView(
                isHouseholdCasePlan: widget.isHouseholdCasePlan,
                hasEditAccess: hasBeneficiaryExited != true,
                formSectionColor: widget.formSectionColor,
                domainId: widget.domainId,
                casePlanGap: widget.casePlanGap,
                onEditCasePlanService: (Map dataObject) =>
                    onManageCasePlanGapServiceProvision(
                        gapServiceObject: dataObject),
                onViewCasePlanService: (Map dataObject) =>
                    onManageCasePlanGapServiceProvision(
                        gapServiceObject: dataObject, isOnEditMode: false),
              ),
            ),
            Visibility(
              visible: hasBeneficiaryExited != true,
              child: Consumer<LanguageTranslationState>(
                builder: (context, languageTranslationState, child) {
                  String? currentLanguage =
                      languageTranslationState.currentLanguage;
                  return Container(
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
                      onPressed: () => onManageCasePlanGapServiceProvision(),
                      child: Text(
                        currentLanguage != 'lesotho'
                            ? 'ADD SERVICE'
                            : 'TLATSA TŠEBELETSO',
                        style: const TextStyle().copyWith(
                          color: widget.formSectionColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
