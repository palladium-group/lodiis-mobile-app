
// CasePlanGapServiceMonitoringViewContainer.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';

import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';

import '../../constants/ovc_case_plan_constant.dart';
import '../../ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import '../../ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'case_plan_gap_service_monitoring_form_container.dart';

class CasePlanGapServiceMonitoringViewContainer extends StatefulWidget {
  const CasePlanGapServiceMonitoringViewContainer({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap, // must include cp link and casePlanDate/eventDate/location
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
  bool _expanded = true;

  static const _cpKey  = OvcCasePlanConstant.casePlanToGapLinkage;
  static const _monKey = OvcCasePlanConstant.casePlanGapToMonitoringLinkage;

  String _s(Object? v) => (v ?? '').toString();

  DateTime? _asDate(String s) {
    final t = s.trim();
    if (t.isEmpty) return null;
    return DateTime.tryParse(t);
  }

  Map<String, String> _dvMap(Events e) {
    final m = <String, String>{};
    for (final dv in e.dataValues) {
      final de = _s(dv['dataElement']);
      if (de.isEmpty) continue;
      m[de] = _s(dv['value']);
    }
    return m;
  }

  String _stableMon(String cp, String domain) => '$cp|$domain';

  Future<void> _openMonitoringSheet({
    Map<String, dynamic>? seed,
    bool editable = true,
  }) async {
    // Compose seed with CP context
    final obj = <String, dynamic>{
      ...?seed,
      'casePlanDate': seed?['casePlanDate']
          ?? widget.casePlanGap['casePlanDate']
          ?? widget.casePlanGap['eventDate'],
      'location': seed?['location'] ?? widget.casePlanGap['location'] ?? '',
    };

    // ✅ FIX: resolve CP safely (no `.isNotEmpty` on null)
    final resolvedCp = obj[_cpKey] ?? widget.casePlanGap[_cpKey];
    final cp = _s(resolvedCp);
    if (cp.isEmpty) {
      if (kDebugMode) {
        debugPrint('[MON ViewContainer] ABORT open: missing CP (domain=${widget.domainId})');
      }
      AppUtil.showToastMessage(message: 'Missing Case Plan link for ${widget.domainId}');
      return;
    }

    // Stable MON link
    obj[_cpKey]  = cp;
    obj[_monKey] = _stableMon(cp, widget.domainId);

    final dateInfo = _s(obj['eventDate'] ?? obj['casePlanDate']);
    final ou = _s(obj['location']);
    if (kDebugMode) {
      debugPrint('[MON ViewContainer] open sheet '
          'domain=${widget.domainId} cp=$cp date=$dateInfo ou=$ou edit=$editable');
    }

    await AppUtil.showActionSheetModal(
      context: context,
      initialHeightRatio: 0.85,
      maxHeightRatio: 0.85,
      containerBody: CasePlanGapServiceMonitoringFormContainer(
        domainId: widget.domainId,
        formSectionColor: widget.formSectionColor,
        gapServiceMonitoringObject: obj,
        isHouseholdCasePlan: widget.isHouseholdCasePlan,
        enrollmentOuAccessible: widget.enrollmentOuAccessible,
        isEditableMode: editable,
        casePlanGapDate: _s(widget.casePlanGap['casePlanDate'] ?? widget.casePlanGap['eventDate']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stageId = widget.isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.casePlanGapServiceMonitoringProgramStage
        : OvcChildCasePlanConstant.casePlanGapServiceMonitoringProgramStage;

    final cpLink = _s(widget.casePlanGap[_cpKey]);
    final cpDateStr = _s(
      widget.casePlanGap['casePlanDate']?.toString().isNotEmpty == true
          ? widget.casePlanGap['casePlanDate']
          : widget.casePlanGap['eventDate'],
    );
    final cpDate = _asDate(cpDateStr) ?? DateTime.fromMillisecondsSinceEpoch(0);
    final monStable = _stableMon(cpLink, widget.domainId);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: widget.formSectionColor.withOpacity(.25)),
      ),
      child: Column(
        children: [
          // HEADER
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: widget.formSectionColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.tittle,
                      style: TextStyle(
                        color: widget.formSectionColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Consumer<CurrentUserState>(
                    builder: (context, currentUserState, _) {
                      final isKbFacilitySW = currentUserState.isKbFacilitySocialWorker;
                      return Consumer<OvcHouseholdCurrentSelectionState>(
                        builder: (context, sel, __) {
                          final hasExited = widget.isHouseholdCasePlan
                              ? (sel.currentOvcHousehold?.hasExitedProgram == true)
                              : (sel.currentOvcHousehold?.hasExitedProgram == true ||
                              sel.currentOvcHouseholdChild?.hasExitedProgram == true);

                          final canAdd = !isKbFacilitySW && !hasExited;

                          return Row(
                            children: [
                              if (canAdd)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: widget.formSectionColor),
                                      foregroundColor: widget.formSectionColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () => _openMonitoringSheet(editable: true),
                                    child: const Text(
                                      '+ Monitoring',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              Icon(
                                _expanded ? Icons.expand_less : Icons.expand_more,
                                color: widget.formSectionColor,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // BODY
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 160),
            crossFadeState:
            _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Consumer<ServiceEventDataState>(
              builder: (context, serviceEventDataState, _) {
                final isLoading = serviceEventDataState.isLoading;
                final byStage = serviceEventDataState.eventListByProgramStage;

                final List<Events> allStageEvents =
                TrackedEntityInstanceUtil.getAllEventListFromServiceDataStateByProgramStages(
                  byStage,
                  <String>[stageId],
                );

                // Filter to same CP (or stable mon) and >= CP date
                final filtered = <Events>[];
                for (final ev in allStageEvents) {
                  final d = _asDate(_s(ev.eventDate));
                  if (d == null || d.isBefore(cpDate)) continue;
                  final dvs = _dvMap(ev);
                  final evCp  = _s(dvs[_cpKey]);
                  final evMon = _s(dvs[_monKey]);
                  if (evCp == cpLink || evMon == monStable) {
                    filtered.add(ev);
                  }
                }
                filtered.sort((a, b) => _s(b.eventDate).compareTo(_s(a.eventDate)));

                if (kDebugMode) {
                  debugPrint('[MON List] domain="${widget.domainId}" '
                      'stage="$stageId" cp="$cpLink" from="$cpDateStr" '
                      'total=${allStageEvents.length} filtered=${filtered.length}');
                }

                if (isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: LinearProgressIndicator(),
                  );
                }

                if (filtered.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: widget.formSectionColor.withOpacity(.8)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'No monitoring recorded yet for this Case Plan.',
                            style: TextStyle(color: widget.formSectionColor.withOpacity(.9)),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                int n = filtered.length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 6),
                    ...filtered.map((ev) {
                      final idx = n--;
                      final data = <String, dynamic>{
                        'eventId': ev.event,
                        'eventDate': ev.eventDate,
                        'location': ev.orgUnit,
                        ..._dvMap(ev),
                      };
                      // Row shows DATE ONLY (no CP subtitle)
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: widget.formSectionColor.withOpacity(.22),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: widget.formSectionColor.withOpacity(.08),
                              foregroundColor: widget.formSectionColor,
                              child: Text('$idx'),
                            ),
                            title: Text(
                              _s(ev.eventDate), // ✅ date only
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () => _openMonitoringSheet(
                              seed: Map<String, dynamic>.from(data),
                              editable: false,
                            ),
                            onLongPress: () => _openMonitoringSheet(
                              seed: Map<String, dynamic>.from(data),
                              editable: true,
                            ),
                            trailing: Icon(Icons.chevron_right, color: widget.formSectionColor),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
