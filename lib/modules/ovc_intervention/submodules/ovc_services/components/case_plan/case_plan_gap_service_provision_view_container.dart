
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';

import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_view.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

import '../../../../../../models/form_section.dart' show FormSection;
import '../../models/ovc_services_child_case_plan_gap.dart';
import '../../models/ovc_services_household_case_plan_gaps.dart';
import 'case_plan_gap_view_container.dart';

// 🔹 use the same header component style as the gaps container
import '../cp_section_heading.dart';

class CasePlanGapServiceProvisionViewContainer extends StatefulWidget {
  const CasePlanGapServiceProvisionViewContainer({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap,
    required this.isHouseholdCasePlan,
    required this.enrollmentOuAccessible,
    required this.tittle,
    this.domainGaps = const <Map<String, dynamic>>[],
    this.showIdentifiedGapsHeader = true,
  }) : super(key: key);

  /// Domain (e.g. "Health", "Safe", etc.)
  final String domainId;

  /// Domain title displayed at the top of this container
  final String tittle;

  final Color formSectionColor;

  /// Merged gap map for this domain (plus linkage, casePlanDate, location)
  final Map<String, dynamic> casePlanGap;

  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;

  /// Optional: the raw list of domain gaps (so we can render grouped “Identified gaps”)
  final List<Map<String, dynamic>> domainGaps;

  /// Toggle to show/hide the grouped “Identified gaps” header in this container
  final bool showIdentifiedGapsHeader;

  @override
  State<CasePlanGapServiceProvisionViewContainer> createState() =>
      _CasePlanGapServiceProvisionViewContainerState();
}

class _CasePlanGapServiceProvisionViewContainerState
    extends State<CasePlanGapServiceProvisionViewContainer> {
  bool _expanded = false;

  List<FormSection> _gapSectionsForDomain(String domainId) {
    final all = widget.isHouseholdCasePlan
        ? OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: '')
        : OvcServicesChildCasePlanGap.getFormSections(firstDate: '');
    return all.where((s) => (s.id ?? '') == domainId).toList();
  }

  static const String _cpKey = OvcCasePlanConstant.casePlanToGapLinkage;
  static const String _spKey =
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;

  /// Make SP stable per (CP, domain)
  String _stableSp(String cp, String domain) => '$cp|$domain';

  Future<void> _openServiceProvisionSheet({
    Map<String, dynamic>? gapServiceObject,
    bool isOnEditMode = true,
  }) async {
    final ratio = 0.85;

    // Start from incoming (edit) or fresh
    final obj =
    Map<String, dynamic>.from(gapServiceObject ?? <String, dynamic>{});

    // Keep device/user tracking fields present
    obj.putIfAbsent(
        UserAccountReference.appAndDeviceTrackingDataElement, () => null);
    obj.putIfAbsent(
        UserAccountReference.implementingPartnerDataElement, () => null);
    obj.putIfAbsent(
        UserAccountReference.subImplementingPartnerDataElement, () => null);
    obj.putIfAbsent(
        UserAccountReference.serviceProviderDataElement, () => null);

    // Ensure base context comes from the identified gap (merge without clobbering edits)
    const skippedKeys = <String>[
      'eventId',
      'eventDate',
      UserAccountReference.appAndDeviceTrackingDataElement,
      UserAccountReference.implementingPartnerDataElement,
      UserAccountReference.subImplementingPartnerDataElement,
      UserAccountReference.serviceProviderDataElement,
    ];

    widget.casePlanGap.forEach((k, v) {
      if (!skippedKeys.contains(k) && !obj.containsKey(k)) {
        obj[k] = v;
      }
    });

    // Ensure date + location on object
    obj['casePlanDate'] = obj['casePlanDate'] ??
        widget.casePlanGap['casePlanDate'] ??
        widget.casePlanGap['eventDate'];
    obj['location'] = obj['location'] ?? (widget.casePlanGap['location'] ?? '');

    // Ensure stable CP/SP linkage
    final cp = (obj[_cpKey] ?? widget.casePlanGap[_cpKey] ?? '').toString();
    if (cp.isEmpty) {
      if (kDebugMode) {
        debugPrint(
            '[SP ViewContainer] ABORT: missing CP for domain=${widget.domainId}');
      }
      return;
    }
    final spStable = _stableSp(cp, widget.domainId);
    if ((obj[_spKey] ?? '').toString() != spStable) {
      obj[_spKey] = spStable;
    }

    if (kDebugMode) {
      final ou = (obj['location'] ?? '').toString();
      final date = (obj['eventDate'] ?? obj['casePlanDate'] ?? '').toString();
      debugPrint(
          '[SP ViewContainer] open sheet domain=${widget.domainId} cp=$cp sp=$spStable date=$date ou=$ou edit=$isOnEditMode');
    }

    await AppUtil.showActionSheetModal(
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
    final gapSections = _gapSectionsForDomain(widget.domainId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 🔹 Collapsible domain title bar (tap toggles content)
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

        // 🔹 When expanded: show sections preview + identified gaps + service list + add button
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState:
          _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild:
          const SizedBox.shrink(), // collapsed => nothing below the title
          secondChild: Consumer<OvcHouseholdCurrentSelectionState>(
            builder: (context, state, child) {
              final hasExited =
                  state.currentOvcHousehold?.hasExitedProgram == true ||
                      (!widget.isHouseholdCasePlan &&
                          state.currentOvcHouseholdChild?.hasExitedProgram ==
                              true);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Optional “Identified Gaps” header (grouped) — only if you supplied domainGaps
                  if (widget.showIdentifiedGapsHeader &&
                      widget.domainGaps.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
                      child: CasePlanGapViewContainer(
                        gapSections: gapSections,
                        title: 'Identified Gaps',
                        isHouseholdCasePlan:
                        widget.isHouseholdCasePlan, // or false for child CP
                        formSectionColor: Colors.red,
                        domainId: widget.domainId, // e.g. 'Health'
                        casePlanEvent: widget.casePlanGap,
                        onViewGapEvent: (gapEvent) {
                          // optional: navigate to details / view gap
                        },
                      ),
                    ),

                  // Existing saved Service Provision list & actions (CP-only filtering inside)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: CasePlanGapServiceProvisionView(
                      name: 'Services Provided',
                      isHouseholdCasePlan: widget.isHouseholdCasePlan,
                      hasEditAccess: !hasExited,
                      formSectionColor: widget.formSectionColor,
                      domainId: widget.domainId,
                      casePlanGap: <String, dynamic>{
                        ...widget.casePlanGap,
                        _spKey: _stableSp(
                          (widget.casePlanGap[_cpKey] ?? '').toString(),
                          widget.domainId,
                        ),
                      },
                      onEditCasePlanService: (Map dataObject) =>
                          _openServiceProvisionSheet(
                            gapServiceObject:
                            Map<String, dynamic>.from(dataObject),
                            isOnEditMode: true,
                          ),
                      onViewCasePlanService: (Map dataObject) =>
                          _openServiceProvisionSheet(
                            gapServiceObject:
                            Map<String, dynamic>.from(dataObject),
                            isOnEditMode: false,
                          ),
                    ),
                  ),

                  // Add Service button (respect role + exit status)
                  Consumer<CurrentUserState>(
                    builder: (context, currentUserState, child) {
                      final isKbFacilitySocialWorker =
                          currentUserState.isKbFacilitySocialWorker;
                      final showButton = !isKbFacilitySocialWorker && !hasExited;

                      if (!showButton) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: widget.formSectionColor),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.all(15.0),
                            ),
                            onPressed: () {
                              if (kDebugMode) {
                                debugPrint(
                                    '[SP ViewContainer] ADD SERVICE pressed (domain=${widget.domainId})');
                              }
                              _openServiceProvisionSheet();
                            },
                            child: Consumer<LanguageTranslationState>(
                              builder: (context, lang, _) => Text(
                                lang.isSesothoLanguage
                                    ? 'TLATSA TŠEBELETSO'
                                    : 'ADD SERVICE',
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
          ),
        ),
      ],
    );
  }
}

