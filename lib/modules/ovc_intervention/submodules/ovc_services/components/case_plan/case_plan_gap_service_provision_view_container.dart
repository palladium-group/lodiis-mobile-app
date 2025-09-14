
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_view.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_service_provision_util.dart';
import '../../constants/ovc_case_plan_constant.dart';

class CasePlanGapServiceProvisionViewContainer extends StatefulWidget {
  const CasePlanGapServiceProvisionViewContainer({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap,
    required this.isHouseholdCasePlan,
    required this.enrollmentOuAccessible,
    required this.domainDataObject, // NEW
  }) : super(key: key);

  final String domainId;
  final Color formSectionColor;
  final Map casePlanGap;
  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;
  final Map<String, dynamic> domainDataObject; // full domain (with 'gaps')

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

    // Copy linkages/safe fields from gap + keep existing
    final obj = <String, dynamic>{};
    gapServiceObject.forEach((k, v) => obj[k.toString()] = v);
    widget.casePlanGap.forEach((key, value) {
      final k = key.toString();
      if (!obj.containsKey(k)) obj[k] = value;
    });

    // Harden linkages
    final cp = (obj[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
    if (cp.isEmpty && (widget.casePlanGap[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString().isNotEmpty) {
      obj[OvcCasePlanConstant.casePlanToGapLinkage] =
      widget.casePlanGap[OvcCasePlanConstant.casePlanToGapLinkage];
    }
    final sp =
    (obj[OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage] ?? '').toString();
    if (sp.isEmpty) {
      obj[OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage] =
          AppUtil.getUid();
    }

    obj['location'] = (obj['location'] ?? '').toString();
    obj['casePlanDate'] = (widget.casePlanGap['eventDate'] ?? '').toString();

    // Previous sessions map (unchanged)
    String programStage = widget.isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
        : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;
    Map<String, List<String>> previousSessionMapping =
    OvcServiceProvisionUtil.getPreviousSessionMapping(
      context,
      [programStage],
    );
    obj["previousSessionMapping"] = previousSessionMapping;

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
        var hasBeneficiaryExited =
            state.currentOvcHousehold?.hasExitedProgram == true ||
                (!widget.isHouseholdCasePlan &&
                    state.currentOvcHouseholdChild?.hasExitedProgram == true);

        final gapsList = (widget.domainDataObject['gaps'] as List?) ?? const [];

        return Container(
          margin: const EdgeInsets.symmetric(),
          child: Column(
            children: [
              // New: show grouped identified gaps here (single place)
              if (gapsList.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 8),
                  child: IdentifiedGapsGrouped(
                    domainId: widget.domainId,
                    domainColor: widget.formSectionColor,
                    domainDataObject:
                    Map<String, dynamic>.from(widget.domainDataObject),
                    isHouseholdCasePlan: widget.isHouseholdCasePlan,
                    title: 'Identified gaps',
                  ),
                ),

              // Existing: list of services for this gap
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
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

              // Add Service button
              Consumer<CurrentUserState>(
                builder: (context, currentUserState, child) {
                  bool isKbFacilitySocialWorker =
                      currentUserState.isKbFacilitySocialWorker;
                  return Visibility(
                    visible:
                    !isKbFacilitySocialWorker && hasBeneficiaryExited != true,
                    child: Consumer<LanguageTranslationState>(
                      builder: (context, languageTranslationState, child) {
                        String? currentLanguage =
                            languageTranslationState.currentLanguage;
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
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
