
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';

import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_view.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_view_container.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

import '../../../../../../models/form_section.dart' show FormSection;
import '../../models/ovc_services_child_case_plan_gap.dart';
import '../../models/ovc_services_household_case_plan_gaps.dart';
import '../cp_section_heading.dart';

class CasePlanGapServiceMonitoringViewContainer extends StatefulWidget {
  const CasePlanGapServiceMonitoringViewContainer({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap,
    required this.isHouseholdCasePlan,
    required this.enrollmentOuAccessible,
    required this.tittle,
  }) : super(key: key);

  final String domainId;
  final Color formSectionColor;
  final Map<String, dynamic> casePlanGap;
  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;
  final String tittle;

  @override
  State<CasePlanGapServiceMonitoringViewContainer> createState() =>
      _CasePlanGapServiceMonitoringViewContainerState();
}

class _CasePlanGapServiceMonitoringViewContainerState
    extends State<CasePlanGapServiceMonitoringViewContainer> {
  bool _expanded = false;

  List<FormSection> _gapSectionsForDomain(String domainId) {
    final all = widget.isHouseholdCasePlan
        ? OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: '')
        : OvcServicesChildCasePlanGap.getFormSections(firstDate: '');
    return all.where((s) => (s.id ?? '') == domainId).toList();
  }

  Future<void> _openMonitoring({
    Map<String, dynamic>? seed,
    bool edit = true,
  }) async {
    final obj = Map<String, dynamic>.from(seed ?? <String, dynamic>{});

    // Keep device/user tracking fields present
    obj.putIfAbsent(UserAccountReference.appAndDeviceTrackingDataElement, () => null);
    obj.putIfAbsent(UserAccountReference.implementingPartnerDataElement, () => null);
    obj.putIfAbsent(UserAccountReference.subImplementingPartnerDataElement, () => null);
    obj.putIfAbsent(UserAccountReference.serviceProviderDataElement, () => null);

    // === CRITICAL: CP + Domain + stable MON linkage ===
    const cpKey  = OvcCasePlanConstant.casePlanToGapLinkage;
    const domKey = OvcCasePlanConstant.casePlanDomainType;
    const monKey = OvcCasePlanConstant.casePlanGapToMonitoringLinkage;

    // Resolve CP link from incoming obj or the domain container we render under
    final cpLink = (obj[cpKey] ?? widget.casePlanGap[cpKey] ?? '').toString();
    if (cpLink.isEmpty) {
      if (kDebugMode) {
        debugPrint('[MON ViewContainer] ABORT: missing CP link for ${widget.domainId}');
      }
      return;
    }

    // Stamp CP + domain so they are present in the form object
    obj[cpKey]  = cpLink;
    obj[domKey] = widget.domainId;

    // Stable MON linkage helpful for grouping (cp|domain)
    if ((obj[monKey] ?? '').toString().isEmpty) {
      obj[monKey] = '$cpLink|${widget.domainId}';
    }

    // Ensure date + location on object
    obj['casePlanDate'] =
        obj['casePlanDate'] ?? widget.casePlanGap['casePlanDate'] ?? widget.casePlanGap['eventDate'];
    obj['location'] = obj['location'] ?? (widget.casePlanGap['location'] ?? '');

    if (kDebugMode) {
      final ou   = (obj['location'] ?? '').toString();
      final date = (obj['eventDate'] ?? obj['casePlanDate'] ?? '').toString();
      debugPrint('[MON ViewContainer] open sheet domain=${widget.domainId} cp=$cpLink date=$date ou=$ou edit=$edit');
    }

    const ratio = 0.85;
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

  @override
  Widget build(BuildContext context) {
    final gapSections = _gapSectionsForDomain(widget.domainId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Collapsible domain title
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              CpSectionHeading(
                title: widget.tittle,
                color: widget.formSectionColor,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: widget.formSectionColor,
                ),
              ),
            ],
          ),
        ),

        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Consumer<OvcHouseholdCurrentSelectionState>(
            builder: (context, state, _) {
              final hasExited = widget.isHouseholdCasePlan
                  ? (state.currentOvcHousehold?.hasExitedProgram == true)
                  : (state.currentOvcHousehold?.hasExitedProgram == true ||
                  state.currentOvcHouseholdChild?.hasExitedProgram == true);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Collapsible “Identified Gaps” (grouped) header + list
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                    child: CasePlanGapViewContainer(
                      gapSections: gapSections,
                      title: widget.tittle,
                      isHouseholdCasePlan: widget.isHouseholdCasePlan,
                      formSectionColor: widget.formSectionColor,
                      domainId: widget.domainId,
                      casePlanEvent: widget.casePlanGap,
                      onViewGapEvent: (gapEvent) {},
                    ),
                  ),

                  // Saved monitoring list filtered by CP link (inside the view component)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: CasePlanGapServiceMonitoringView(
                      domainId: widget.domainId,
                      formSectionColor: widget.formSectionColor,
                      casePlanGap: Map<String, dynamic>.from(widget.casePlanGap),
                      isHouseholdCasePlan: widget.isHouseholdCasePlan,
                      hasEditAccess: !hasExited,
                      onViewCasePlanServiceMonitoring: (Map dataObject) =>
                          _openMonitoring(seed: Map<String, dynamic>.from(dataObject), edit: false),
                      onEditCasePlanServiceMonitoring: (Map dataObject) =>
                          _openMonitoring(seed: Map<String, dynamic>.from(dataObject), edit: true),
                    ),
                  ),

                  // Add monitoring button
                  Consumer<CurrentUserState>(
                    builder: (context, currentUserState, __) {
                      final bool isKbFacilitySocialWorker =
                          currentUserState.isKbFacilitySocialWorker;
                      final showButton = !isKbFacilitySocialWorker && !hasExited;
                      if (!showButton) return const SizedBox.shrink();

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
                          onPressed: () => _openMonitoring(),
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
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
