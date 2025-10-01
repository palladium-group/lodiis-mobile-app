
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';

class CasePlanGapServiceMonitoringView extends StatelessWidget {
  const CasePlanGapServiceMonitoringView({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap, // must contain cpLink + casePlanDate/eventDate + location (optional)
    required this.isHouseholdCasePlan,
    required this.hasEditAccess,
    required this.onViewCasePlanServiceMonitoring,
    required this.onEditCasePlanServiceMonitoring,
  }) : super(key: key);

  final String domainId;
  final Color formSectionColor;
  final Map<String, dynamic> casePlanGap;
  final bool isHouseholdCasePlan;
  final bool hasEditAccess;

  final void Function(Map dataObject) onViewCasePlanServiceMonitoring;
  final void Function(Map dataObject) onEditCasePlanServiceMonitoring;

  String _s(Object? v) => (v ?? '').toString();

  DateTime? _asDate(String s) {
    final t = s.trim();
    if (t.isEmpty) return null;
    final parsers = <DateTime? Function()>[
          () => DateTime.tryParse(t), // covers most ISO formats
    ];
    for (final p in parsers) {
      final d = p();
      if (d != null) return d;
    }
    return null;
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

  @override
  Widget build(BuildContext context) {
    final stageId = isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.casePlanGapServiceMonitoringProgramStage
        : OvcChildCasePlanConstant.casePlanGapServiceMonitoringProgramStage;

    // From CP container
    final cpLink =
    _s(casePlanGap[OvcCasePlanConstant.casePlanToGapLinkage]); // required
    final fromDateStr =
    _s(casePlanGap['casePlanDate'].toString().isNotEmpty ? casePlanGap['casePlanDate'] : casePlanGap['eventDate']);
    final fromDate = _asDate(fromDateStr) ?? DateTime.fromMillisecondsSinceEpoch(0);

    final monStable = '$cpLink|$domainId';

    return Consumer<ServiceEventDataState>(
      builder: (context, serviceEventDataState, _) {
        final isLoading = serviceEventDataState.isLoading;
        final byStage = serviceEventDataState.eventListByProgramStage;

        // Pull exactly like Viral Load:
        final List<Events> allStageEvents =
        TrackedEntityInstanceUtil.getAllEventListFromServiceDataStateByProgramStages(
          byStage,
          <String>[stageId],
        );

        // Verbose logs
        if (kDebugMode) {
          debugPrint(
              '[MON List] RAW stage="$stageId" total=${allStageEvents.length}');
          debugPrint(
              '[MON List] domain="$domainId" cp="$cpLink" from="$fromDateStr"');
        }

        // Filter by CP link (or stable mon link) and by date >= casePlanDate
        int skipped = 0, badDate = 0;
        final filtered = <Events>[];
        for (final ev in allStageEvents) {
          final d = _asDate(_s(ev.eventDate));
          if (d == null) {
            badDate++;
            continue;
          }
          if (d.isBefore(fromDate)) {
            skipped++;
            continue;
          }

          final dvs = _dvMap(ev);
          final cp = _s(dvs[OvcCasePlanConstant.casePlanToGapLinkage]);
          final mon =
          _s(dvs[OvcCasePlanConstant.casePlanGapToMonitoringLinkage]);

          final pass = (cp == cpLink) || (mon == monStable);
          if (pass) {
            filtered.add(ev);
          } else {
            skipped++;
          }
        }

        // Sort newest first
        filtered.sort((a, b) => _s(b.eventDate).compareTo(_s(a.eventDate)));

        if (kDebugMode) {
          debugPrint(
              '[MON List] FILTERED domain="$domainId" cp="$cpLink" count=${filtered.length} (skipped=$skipped badDate=$badDate)');
        }

        if (isLoading) {
          return const Padding(
            padding: EdgeInsets.all(12.0),
            child: LinearProgressIndicator(),
          );
        }

        if (filtered.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No monitoring recorded yet for this case plan.',
              style: TextStyle(color: formSectionColor),
            ),
          );
        }

        int n = filtered.length;
        return Column(
          children: filtered.map((ev) {
            final idx = n--;
            final data = <String, dynamic>{
              'eventId': ev.event,
              'eventDate': ev.eventDate,
              'location': ev.orgUnit,
              // include all DEs for edit/view
              ..._dvMap(ev),
            };

            // Card UI similar to Viral Load list
            return Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: Card(
                elevation: 0.5,
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  leading: CircleAvatar(
                    backgroundColor: formSectionColor.withOpacity(0.1),
                    foregroundColor: formSectionColor,
                    child: Text('$idx'),
                  ),
                  title: Text(
                    _s(ev.eventDate),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('CP: $cpLink'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () =>
                            onViewCasePlanServiceMonitoring(data),
                      ),
                      if (hasEditAccess)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              onEditCasePlanServiceMonitoring(data),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
