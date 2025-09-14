
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_view.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/monitoring/viral_load_monitoring_form_container.dart';
import '../../constants/ovc_case_plan_constant.dart';
import 'identified_gaps_grouped.dart';

class CasePlanGapServiceMonitoringViewContainer extends StatefulWidget {
  const CasePlanGapServiceMonitoringViewContainer({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap,
    required this.isHouseholdCasePlan,
    required this.enrollmentOuAccessible,
    this.domainDataObject, // NEW (optional)
  }) : super(key: key);

  final String domainId;
  final Color formSectionColor;
  final Map casePlanGap;
  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;

  /// Full domain object (the section map that contains the `gaps` list).
  /// Optional to keep backward compatibility with older call sites.
  final Map<String, dynamic>? domainDataObject;

  @override
  State<CasePlanGapServiceMonitoringViewContainer> createState() =>
      _CasePlanGapServiceMonitoringViewContainerState();
}

class _CasePlanGapServiceMonitoringViewContainerState
    extends State<CasePlanGapServiceMonitoringViewContainer> {
  Future<String?> _pickMonitoringType(BuildContext context,
      {required bool canShowVl}) async {
    final options = <String>[
      'Assessment monitoring',
      if (canShowVl) 'Viral load monitoring'
    ];
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text('Choose monitoring type',
                style: Theme.of(ctx).textTheme.titleMedium),
            const Divider(),
            for (final opt in options)
              ListTile(
                title: Text(opt),
                onTap: () => Navigator.pop(ctx, opt),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<bool> _canShowVl() async {
    // Keep light; VL form enforces its own gating
    return true;
  }

  void onManageCasePlanGapServiceMonitoring({
    Map? gapServiceMonitoringObject,
    bool isOnEditMode = true,
  }) async {
    double ratio = 0.8;
    gapServiceMonitoringObject = gapServiceMonitoringObject ?? {};

    // Merge with casePlanGap
    final obj = <String, dynamic>{};
    gapServiceMonitoringObject.forEach((k, v) => obj[k.toString()] = v);
    widget.casePlanGap.forEach((key, value) {
      final k = key.toString();
      if (!obj.containsKey(k)) obj[k] = value;
    });

    // Keep CP linkage
    final cp = (obj[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
    if (cp.isEmpty &&
        (widget.casePlanGap[OvcCasePlanConstant.casePlanToGapLinkage] ?? '')
            .toString()
            .isNotEmpty) {
      obj[OvcCasePlanConstant.casePlanToGapLinkage] =
      widget.casePlanGap[OvcCasePlanConstant.casePlanToGapLinkage];
    }

    obj['location'] = (obj['location'] ?? '').toString();
    obj['casePlanDate'] = (widget.casePlanGap['eventDate'] ?? '').toString();

    final canShowVl = await _canShowVl();
    final picked = await _pickMonitoringType(context, canShowVl: canShowVl);
    if (picked == null) return;

    if (picked == 'Viral load monitoring') {
      AppUtil.showActionSheetModal(
        context: context,
        initialHeightRatio: ratio,
        maxHeightRatio: ratio,
        containerBody: ViralLoadMonitoringFormContainer(
          domainId: widget.domainId,
          formSectionColor: widget.formSectionColor,
          gapServiceMonitoringObject: obj,
          isHouseholdCasePlan: widget.isHouseholdCasePlan,
          enrollmentOuAccessible: widget.enrollmentOuAccessible,
          isEditableMode: isOnEditMode,
          casePlanGapDate: obj['casePlanDate'] ?? '',
        ),
      );
    } else {
      AppUtil.showActionSheetModal(
        context: context,
        initialHeightRatio: ratio,
        maxHeightRatio: ratio,
        containerBody: CasePlanGapServiceMonitoringFormContainer(
          domainId: widget.domainId,
          formSectionColor: widget.formSectionColor,
          gapServiceMonitoringObject: obj,
          isHouseholdCasePlan: widget.isHouseholdCasePlan,
          enrollmentOuAccessible: widget.enrollmentOuAccessible,
          isEditableMode: isOnEditMode,
          casePlanGapDate: obj['casePlanDate'] ?? '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OvcHouseholdCurrentSelectionState>(
      builder: (context, state, child) {
        var hasBeneficiaryExited = widget.isHouseholdCasePlan
            ? state.currentOvcHousehold?.hasExitedProgram
            : state.currentOvcHousehold?.hasExitedProgram == true ||
            state.currentOvcHouseholdChild?.hasExitedProgram == true;

        final Map<String, dynamic> domainObj =
        Map<String, dynamic>.from(widget.domainDataObject ?? const {});
        final List gapsList = (domainObj['gaps'] as List?) ?? const [];

        return Container(
          margin: const EdgeInsets.symmetric(),
          child: Column(
            children: [
              if (gapsList.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 8),
                  child: IdentifiedGapsGrouped(
                    domainId: widget.domainId,
                    domainColor: widget.formSectionColor,
                    domainDataObject: domainObj,
                    isHouseholdCasePlan: widget.isHouseholdCasePlan,
                    title: 'Identified gaps',
                  ),
                ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CasePlanGapServiceMonitoringView(
                  domainId: widget.domainId,
                  formSectionColor: widget.formSectionColor,
                  casePlanGap: widget.casePlanGap,
                  isHouseholdCasePlan: widget.isHouseholdCasePlan,
                  hasEditAccess: hasBeneficiaryExited != true,
                  onViewCasePlanServiceMonitoring: (Map dataObject) =>
                      onManageCasePlanGapServiceMonitoring(
                        gapServiceMonitoringObject: dataObject,
                        isOnEditMode: false,
                      ),
                  onEditCasePlanServiceMonitoring: (Map dataObject) =>
                      onManageCasePlanGapServiceMonitoring(
                        gapServiceMonitoringObject: dataObject,
                        isOnEditMode: true,
                      ),
                ),
              ),

              Consumer<CurrentUserState>(
                builder: (context, currentUserState, child) {
                  bool isKbFacilitySocialWorker =
                      currentUserState.isKbFacilitySocialWorker;
                  return Visibility(
                    visible:
                    !isKbFacilitySocialWorker && hasBeneficiaryExited != true,
                    child: Container(
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
                        onPressed: onManageCasePlanGapServiceMonitoring,
                        child: Consumer<LanguageTranslationState>(
                          builder: (context, languageTranslationState, child) =>
                              Text(
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

