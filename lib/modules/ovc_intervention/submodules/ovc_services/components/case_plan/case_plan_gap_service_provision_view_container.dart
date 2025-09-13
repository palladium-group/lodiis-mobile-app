
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart'; // kept (not used to hide)
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
    String location = (gapServiceObject['location'] ?? '').toString();

    final String programStage = widget.isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
        : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;

    const skippedKeys = [
      'eventId',
      'eventDate',
      UserAccountReference.appAndDeviceTrackingDataElement,
      UserAccountReference.implementingPartnerDataElement,
      UserAccountReference.subImplementingPartnerDataElement,
      UserAccountReference.serviceProviderDataElement,
    ];

    // seed object with gap values (preserve linkages), then keep any edit values
    final Map<String, dynamic> obj = <String, dynamic>{};
    widget.casePlanGap.forEach((k, v) {
      final key = k.toString();
      if (!skippedKeys.contains(key)) obj[key] = v;
    });
    gapServiceObject.forEach((k, v) => obj[k.toString()] = v);
    obj['casePlanDate'] = widget.casePlanGap['eventDate'];
    obj['location'] = location;

    final prev = OvcServiceProvisionUtil.getPreviousSessionMapping(
      context,
      [programStage],
    );
    obj['previousSessionMapping'] = prev;

    AppUtil.showActionSheetModal(
      context: context,
      initialHeightRatio: ratio,
      maxHeightRatio: ratio,
      containerBody: CasePlanGapServiceProvisionFormContainer(
        gapServiceObject: obj,
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
        // hide ONLY when exited
        final bool hasBeneficiaryExited = widget.isHouseholdCasePlan
            ? (state.currentOvcHousehold?.hasExitedProgram == true)
            : (state.currentOvcHousehold?.hasExitedProgram == true ||
            state.currentOvcHouseholdChild?.hasExitedProgram == true);

        return Container(
          margin: const EdgeInsets.symmetric(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CasePlanGapServiceProvisionView(
                  isHouseholdCasePlan: widget.isHouseholdCasePlan,
                  hasEditAccess: !hasBeneficiaryExited,
                  formSectionColor: widget.formSectionColor,
                  domainId: widget.domainId,
                  casePlanGap: widget.casePlanGap,
                  onEditCasePlanService: (Map dataObject) =>
                      onManageCasePlanGapServiceProvision(
                        gapServiceObject: dataObject,
                        isOnEditMode: true,
                      ),
                  onViewCasePlanService: (Map dataObject) =>
                      onManageCasePlanGapServiceProvision(
                        gapServiceObject: dataObject,
                        isOnEditMode: false,
                      ),
                ),
              ),
              Visibility(
                visible: !hasBeneficiaryExited,
                child: Consumer<LanguageTranslationState>(
                  builder: (context, languageTranslationState, _) {
                    final isSesotho =
                        languageTranslationState.isSesothoLanguage;
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: widget.formSectionColor),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.all(15.0),
                        ),
                        onPressed: onManageCasePlanGapServiceProvision,
                        child: Text(
                          isSesotho ? 'TLATSA TŠEBELETSO' : 'ADD SERVICE',
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
              ),
            ],
          ),
        );
      },
    );
  }
}
