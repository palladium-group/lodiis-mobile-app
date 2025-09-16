
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/monitoring/viral_load_monitoring_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_view.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped.dart';

import 'case_plan_gap_view_container.dart';

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
  final Map<String, dynamic> casePlanGap;
  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;

  @override
  State<CasePlanGapServiceMonitoringViewContainer> createState() =>
      _CasePlanGapServiceMonitoringViewContainerState();
}

class _CasePlanGapServiceMonitoringViewContainerState
    extends State<CasePlanGapServiceMonitoringViewContainer> {
  Future<String?> _pickMonitoringType(BuildContext context) async {
    final options = <String>['Assessment monitoring', 'Viral load monitoring'];
    return showModalBottomSheet<String>(
      context: context,
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

  Future<void> _openMonitoring({
    Map<String, dynamic>? seed,
    bool edit = true,
  }) async {
    final obj = Map<String, dynamic>.from(seed ?? {});

    obj.putIfAbsent(UserAccountReference.appAndDeviceTrackingDataElement, () => null);
    obj.putIfAbsent(UserAccountReference.implementingPartnerDataElement, () => null);
    obj.putIfAbsent(UserAccountReference.subImplementingPartnerDataElement, () => null);
    obj.putIfAbsent(UserAccountReference.serviceProviderDataElement, () => null);

    obj['casePlanDate'] =
        obj['casePlanDate'] ?? widget.casePlanGap['casePlanDate'] ?? widget.casePlanGap['eventDate'];
    obj['location'] = obj['location'] ?? widget.casePlanGap['location'] ?? '';

    final picked = await _pickMonitoringType(context);
    if (picked == null) return;

    final ratio = 0.85;
    if (picked == 'Viral load monitoring') {
      await AppUtil.showActionSheetModal(
        context: context,
        initialHeightRatio: ratio,
        maxHeightRatio: ratio,
        containerBody: ViralLoadMonitoringFormContainer(
          domainId: widget.domainId,
          formSectionColor: widget.formSectionColor,
          gapServiceMonitoringObject: obj,
          isHouseholdCasePlan: widget.isHouseholdCasePlan,
          enrollmentOuAccessible: widget.enrollmentOuAccessible,
          isEditableMode: edit,
          casePlanGapDate: (obj['casePlanDate'] ?? '').toString(),
        ),
      );
    } else {
      await AppUtil.showActionSheetModal(
        context: context,
        initialHeightRatio: ratio,
        maxHeightRatio: ratio,
        containerBody: CasePlanGapServiceMonitoringFormContainer(
          domainId: widget.domainId,
          formSectionColor: widget.formSectionColor,
          gapServiceMonitoringObject: obj,
          isHouseholdCasePlan: widget.isHouseholdCasePlan,
          enrollmentOuAccessible: widget.enrollmentOuAccessible,
          isEditableMode: edit,
          casePlanGapDate: (obj['casePlanDate'] ?? '').toString(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OvcHouseholdCurrentSelectionState>(
      builder: (context, sel, _) {
        final hasExited = widget.isHouseholdCasePlan
            ? (sel.currentOvcHousehold?.hasExitedProgram == true)
            : (sel.currentOvcHousehold?.hasExitedProgram == true ||
            sel.currentOvcHouseholdChild?.hasExitedProgram == true);

        return Column(
          children: [
            // grouped gaps
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
              child: CasePlanGapViewContainer(
                isHouseholdCasePlan: widget.isHouseholdCasePlan, // or false for child CP
                formSectionColor: const Color(0xFF4A9F46), // use your domain color
                domainId: widget.domainId,                 // e.g. 'Health'
                casePlanEvent: widget.casePlanGap,
                title: 'Identified gaps',// must include CP linkage or event id
                onViewGapEvent: (gapEvent) {
                  // optional: navigate to details / view gap
                  // Navigator.push(...);
                },
              ),
            ),

            // saved monitoring list
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CasePlanGapServiceMonitoringView(
                domainId: widget.domainId,
                formSectionColor: widget.formSectionColor,
                // 🔧 FIX: Map<String,dynamic>
                casePlanGap: Map<String, dynamic>.from(widget.casePlanGap),
                isHouseholdCasePlan: widget.isHouseholdCasePlan,
                hasEditAccess: !hasExited,
                onViewCasePlanServiceMonitoring: (Map dataObject) =>
                    _openMonitoring(seed: Map<String, dynamic>.from(dataObject), edit: false),
                onEditCasePlanServiceMonitoring: (Map dataObject) =>
                    _openMonitoring(seed: Map<String, dynamic>.from(dataObject), edit: true),
              ),
            ),

            // add monitoring
            Consumer<CurrentUserState>(
              builder: (context, currentUserState, __) {
                final bool isKbFacilitySocialWorker =
                    currentUserState.isKbFacilitySocialWorker;
                return Visibility(
                  visible: !isKbFacilitySocialWorker && !hasExited,
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
                      onPressed: () =>
                          _openMonitoring(seed: Map<String, dynamic>.from(widget.casePlanGap), edit: true),
                      child: Consumer<LanguageTranslationState>(
                        builder: (context, languageTranslationState, child) => Text(
                          languageTranslationState.isSesothoLanguage
                              ? 'KENYA TLHOKOMELO'
                              : 'ADD MONITORING',
                          style: TextStyle(
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
            ),
          ],
        );
      },
    );
  }
}

