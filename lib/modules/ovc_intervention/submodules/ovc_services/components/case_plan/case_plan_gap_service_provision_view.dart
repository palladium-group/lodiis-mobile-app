
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';

import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';

/// Renders the saved Service Provision events bound to the current domain’s gap
/// (filtered by both case-plan linkage and SP linkage).
class CasePlanGapServiceProvisionView extends StatelessWidget {
  const CasePlanGapServiceProvisionView({
    Key? key,
    required this.isHouseholdCasePlan,
    required this.hasEditAccess,
    required this.formSectionColor,
    required this.domainId,
    required this.casePlanGap,
    required this.onEditCasePlanService,
    required this.onViewCasePlanService,
  }) : super(key: key);

  final bool isHouseholdCasePlan;
  final bool hasEditAccess;
  final Color formSectionColor;
  final String domainId;

  /// Must contain anchors:
  ///  - OvcCasePlanConstant.casePlanToGapLinkage
  ///  - OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage
  final Map<String, dynamic> casePlanGap;

  final void Function(Map dataObject) onEditCasePlanService;
  final void Function(Map dataObject) onViewCasePlanService;

  static const String _cpKey = OvcCasePlanConstant.casePlanToGapLinkage;
  static const String _spKey =
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;

  String get _stage => isHouseholdCasePlan
      ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
      : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;

  /// Extracts a flat map of dataValues from a variety of shapes (Events model / Map / List of pairs).
  Map<String, dynamic> _extractDataValues(dynamic ev) {
    // 1) Model with "dataValues" property
    try {
      final dv = (ev as dynamic).dataValues;
      if (dv is Map) return Map<String, dynamic>.from(dv);
      if (dv is List) {
        final out = <String, dynamic>{};
        for (final row in dv) {
          if (row is Map && row['dataElement'] != null) {
            out['${row['dataElement']}'] = row['value'];
          }
        }
        return out;
      }
    } catch (_) {}

    // 2) Map with "dataValues" or "data"
    if (ev is Map) {
      final raw = ev['dataValues'] ?? ev['data'];
      if (raw is Map) return Map<String, dynamic>.from(raw);
      if (raw is List) {
        final out = <String, dynamic>{};
        for (final row in raw) {
          if (row is Map && row['dataElement'] != null) {
            out['${row['dataElement']}'] = row['value'];
          }
        }
        return out;
      }
    }
    return const {};
  }

  String _eventIdOf(dynamic ev) {
    try {
      final id = (ev as dynamic).event;
      if (id is String) return id;
    } catch (_) {}
    if (ev is Map && ev['event'] is String) return ev['event'] as String;
    return '';
  }

  String _eventDateOf(dynamic ev) {
    try {
      final ed = (ev as dynamic).eventDate;
      if (ed is String) return ed;
    } catch (_) {}
    if (ev is Map && ev['eventDate'] is String) return ev['eventDate'] as String;
    return '';
  }

  Map<String, dynamic> _toPlainObject(dynamic ev) {
    // Build a plain map the edit/view sheet can accept
    final obj = <String, dynamic>{};
    obj['eventId'] = _eventIdOf(ev);
    obj['eventDate'] = _eventDateOf(ev);
    obj.addAll(_extractDataValues(ev));
    return obj;
  }

  @override
  Widget build(BuildContext context) {
    final cpAnchor = (casePlanGap[_cpKey] ?? '').toString();
    final spAnchor = (casePlanGap[_spKey] ?? '').toString();

    return Consumer2<ServiceEventDataState, OvcHouseholdCurrentSelectionState>(
      builder: (context, serviceEvents, selection, _) {
        // Read the grouped map defensively
        Map grouped;
        try {
          final raw = serviceEvents.eventListByProgramStage;
          grouped = raw is Map ? raw : <String, List>{};
        } catch (e) {
          if (kDebugMode) {
            debugPrint('[SP View] eventListByProgramStage cast error: $e');
          }
          grouped = <String, List>{};
        }

        // Pull stage list safely
        List<dynamic> stageEvents;
        try {
          final maybe = grouped[_stage];
          stageEvents = maybe is List ? List<dynamic>.from(maybe) : <dynamic>[];
        } catch (e) {
          if (kDebugMode) {
            debugPrint('[SP View] getEventListByProgramStages error: $e');
          }
          stageEvents = <dynamic>[];
        }

        // Filter by both anchors
        final filtered = <dynamic>[];
        for (final ev in stageEvents) {
          final dv = _extractDataValues(ev);
          final cp = (dv[_cpKey] ?? '').toString();
          final sp = (dv[_spKey] ?? '').toString();

          if (cp != cpAnchor || sp != spAnchor) {
            if (kDebugMode) {
              debugPrint(
                '[SP View] exclude event=${_eventIdOf(ev)} '
                    'reason=${cp != cpAnchor ? 'cp_mismatch' : 'sp_mismatch'} '
                    'cp="$cp" (need "$cpAnchor") sp="$sp" (need "$spAnchor")',
              );
            }
            continue;
          }
          filtered.add(ev);
        }

        if (kDebugMode) {
          debugPrint(
            '[SP View] build domain="$domainId" HH=$isHouseholdCasePlan '
                'cp="$cpAnchor" sp="$spAnchor" stage=$_stage '
                'totalStage=${stageEvents.length} show=${filtered.length}',
          );
        }

        if (filtered.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              'No services recorded for this gap yet.',
              style: TextStyle(
                color: formSectionColor.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }

        return Column(
          children: filtered.map((ev) {
            final obj = _toPlainObject(ev);
            final date = AppUtil.getDateIntoDateTimeFormat(obj['eventDate']) ??
                (obj['eventDate'] ?? '');

            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: formSectionColor.withOpacity(0.35)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                title: Text(
                  'Service on $date',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Linked CP: $cpAnchor  •  SP: $spAnchor',
                  style: TextStyle(color: Colors.black54),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'view') onViewCasePlanService(obj);
                    if (v == 'edit' && hasEditAccess) onEditCasePlanService(obj);
                  },
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem(
                      value: 'view',
                      child: Text('View'),
                    ),
                    if (hasEditAccess)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                  ],
                ),
                onTap: () => onViewCasePlanService(obj),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
