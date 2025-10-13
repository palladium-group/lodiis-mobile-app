
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';

import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_view.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

import '../../../../../../models/form_section.dart' show FormSection;
import '../../../../../../models/events.dart';
import '../../models/ovc_services_child_case_plan_gap.dart';
import '../../models/ovc_services_household_case_plan_gaps.dart';
import 'case_plan_gap_view_container.dart';
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

  final String domainId;
  final String tittle;
  final Color formSectionColor;

  /// merged gap object for this domain, includes cp linkage, casePlanDate, location, etc.
  final Map<String, dynamic> casePlanGap;

  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;
  final List<Map<String, dynamic>> domainGaps;
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

  String _stableSp(String cp, String domain) => '$cp|$domain';

  /// Find service DEs already set “today” for this SP linkage
  Future<Set<String>> _getServiceDeIdsProvidedToday({
    required String spLinkage,
    required String teiId,
  }) async {
    final stageId = widget.isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
        : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;

    final List<Events> all =
    await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(teiId);

    bool _sameDay(String? iso) {
      final d = AppUtil.getDateIntoDateTimeFormat(iso ?? '');
      if (d == null) return false;
      final now = DateTime.now();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }

    final provided = <String>{};

    for (final e in all) {
      if (e.programStage != stageId) continue;
      if (!_sameDay(e.eventDate)) continue;

      final dvs = (e.dataValues as List?) ?? const [];
      final matchesSp = dvs.any((dv) =>
      dv is Map && dv['dataElement'] == _spKey && (dv['value']?.toString() ?? '') == spLinkage);
      if (!matchesSp) continue;

      for (final row in dvs) {
        if (row is! Map) continue;
        final de = (row['dataElement'] ?? '').toString();
        if (de.isEmpty || de == _spKey || de == _cpKey) continue;
        final val = (row['value'] ?? '').toString().toLowerCase().trim();
        final truthy = val == 'true' || val == 'yes' || val == '1';
        if (truthy) provided.add(de);
      }
    }
    return provided;
  }

  Future<void> _openServiceProvisionSheet({
    Map<String, dynamic>? gapServiceObject,
    bool isOnEditMode = true,
  }) async {
    final ratio = 0.85;

    // Start from incoming (edit) or fresh
    final obj = Map<String, dynamic>.from(gapServiceObject ?? <String, dynamic>{});

    // Ensure base context (merge without clobbering)
    const skipped = <String>[
      'eventId',
      'eventDate',
      UserAccountReference.appAndDeviceTrackingDataElement,
      UserAccountReference.implementingPartnerDataElement,
      UserAccountReference.subImplementingPartnerDataElement,
      UserAccountReference.serviceProviderDataElement,
    ];
    widget.casePlanGap.forEach((k, v) {
      if (!skipped.contains(k) && !obj.containsKey(k)) {
        obj[k] = v;
      }
    });

    // Ensure date + location
    obj['casePlanDate'] =
        obj['casePlanDate'] ?? widget.casePlanGap['casePlanDate'] ?? widget.casePlanGap['eventDate'];
    obj['location'] = obj['location'] ?? (widget.casePlanGap['location'] ?? '');

    // Ensure stable CP/SP linkage
    final cp = (obj[_cpKey] ?? widget.casePlanGap[_cpKey] ?? '').toString();
    if (cp.isEmpty) {
      if (kDebugMode) {
        debugPrint('[SP View] ABORT: missing CP for domain=${widget.domainId}');
      }
      return;
    }
    final spStable = _stableSp(cp, widget.domainId);
    if ((obj[_spKey] ?? '').toString() != spStable) {
      obj[_spKey] = spStable;
    }

    // Compute fields to hide (already provided today)
    final sel = Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);
    final teiId = widget.isHouseholdCasePlan
        ? (sel.currentOvcHousehold?.teiData?.trackedEntityInstance ?? '')
        : (sel.currentOvcHouseholdChild?.teiData?.trackedEntityInstance ?? '');

    Set<String> hideToday = {};
    if (teiId.isNotEmpty) {
      hideToday = await _getServiceDeIdsProvidedToday(
        spLinkage: spStable,
        teiId: teiId,
      );
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
        preHiddenFieldIds: hideToday.toList(), // <<< NEW: hide duplicates
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gapSections = _gapSectionsForDomain(widget.domainId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
            builder: (context, state, child) {
              final hasExited =
                  state.currentOvcHousehold?.hasExitedProgram == true ||
                      (state.currentOvcHouseholdChild?.hasExitedProgram == true && !widget.isHouseholdCasePlan);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.showIdentifiedGapsHeader && widget.domainGaps.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
                      child: CasePlanGapViewContainer(
                        gapSections: gapSections,
                        title: 'Identified Gaps',
                        isHouseholdCasePlan: widget.isHouseholdCasePlan,
                        formSectionColor: Colors.red,
                        domainId: widget.domainId,
                        casePlanEvent: widget.casePlanGap,
                        onViewGapEvent: (_) {},
                      ),
                    ),
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
                            gapServiceObject: Map<String, dynamic>.from(dataObject),
                            isOnEditMode: true,
                          ),
                      onViewCasePlanService: (Map dataObject) =>
                          _openServiceProvisionSheet(
                            gapServiceObject: Map<String, dynamic>.from(dataObject),
                            isOnEditMode: false,
                          ),
                    ),
                  ),
                  Consumer<CurrentUserState>(
                    builder: (context, currentUserState, child) {
                      final showButton = !hasExited;

                      if (!showButton) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: widget.formSectionColor),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.all(15.0),
                            ),
                            onPressed: () => _openServiceProvisionSheet(),
                            child: Consumer<LanguageTranslationState>(
                              builder: (context, lang, _) => Text(
                                lang.isSesothoLanguage ? 'TLATSA TŠEBELETSO' : 'ADD SERVICE',
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
