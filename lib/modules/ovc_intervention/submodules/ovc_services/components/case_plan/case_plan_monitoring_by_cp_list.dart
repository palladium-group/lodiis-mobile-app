
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';

import '../../constants/ovc_case_plan_constant.dart';
import '../../ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import '../../ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';

class CasePlanMonitoringByCpLinkList extends StatelessWidget {
  const CasePlanMonitoringByCpLinkList({
    Key? key,
    required this.isHouseholdCasePlan,
    required this.domainId,
    required this.cpLink,
    required this.color,
    required this.hasEditAccess,
    required this.onView,
    required this.onEdit,
  }) : super(key: key);

  final bool isHouseholdCasePlan;
  final String domainId;
  final String cpLink;
  final Color color;
  final bool hasEditAccess;
  final void Function(Map<String, dynamic>) onView;
  final void Function(Map<String, dynamic>) onEdit;

  String _stageId() => isHouseholdCasePlan
      ? OvcHouseholdCasePlanConstant.casePlanGapServiceMonitoringProgramStage
      : OvcChildCasePlanConstant.casePlanGapServiceMonitoringProgramStage;

  @override
  Widget build(BuildContext context) {
    return Consumer<OvcHouseholdCurrentSelectionState>(
      builder: (context, sel, _) {
        final tei = isHouseholdCasePlan
            ? sel.currentOvcHousehold?.teiData?.trackedEntityInstance ?? ''
            : sel.currentOvcHouseholdChild?.teiData?.trackedEntityInstance ?? '';

        if (tei.isEmpty || cpLink.isEmpty) {
          return _Empty(color: color);
        }

        return FutureBuilder<List<dynamic>>(
          future: TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(tei),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
              );
            }

            final events = snap.data!;
            final stage = _stageId();

            // Filter by monitoring stage, same cpLink and same domain
            final filtered = <Map<String, dynamic>>[];
            for (final e in events) {
              try {
                if ('${e.programStage}' != stage) continue;

                // normalize dataValues to a Map
                final dv = <String, dynamic>{};
                final raw = e.dataValues;
                if (raw is Map) {
                  raw.forEach((k, v) => dv['$k'] = v);
                } else if (raw is List) {
                  for (final row in raw) {
                    if (row is Map && row['dataElement'] != null) {
                      dv['${row['dataElement']}'] = row['value'];
                    }
                  }
                }

                final link = (dv[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
                final dom  = (dv[OvcCasePlanConstant.casePlanDomainType] ?? '').toString();
                if (link != cpLink || dom != domainId) continue;

                // build display map
                final m = <String, dynamic>{
                  'eventId': '${e.event ?? ''}',
                  'eventDate': '${e.eventDate ?? ''}',
                };
                m.addAll(dv);
                filtered.add(m);
              } catch (_) {}
            }

            // sort by eventDate desc
            filtered.sort((a, b) {
              final da = DateTime.tryParse('${a['eventDate'] ?? ''}');
              final db = DateTime.tryParse('${b['eventDate'] ?? ''}');
              if (da != null && db != null) return db.compareTo(da);
              return ('${b['eventDate'] ?? ''}').compareTo('${a['eventDate'] ?? ''}');
            });

            if (kDebugMode) {
              debugPrint('[MON List] domain="$domainId" cp="$cpLink" count=${filtered.length}');
            }

            if (filtered.isEmpty) return _Empty(color: color);

            return Column(
              children: filtered.map((m) {
                final date = (m['eventDate'] ?? '').toString();
                return Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: color.withOpacity(.3)),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      date.isEmpty ? 'Monitoring' : 'Monitoring • $date',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Domain: $domainId',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Wrap(
                      spacing: 6,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          color: color,
                          tooltip: 'View',
                          onPressed: () => onView(m),
                        ),
                        if (hasEditAccess)
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: color,
                            tooltip: 'Edit',
                            onPressed: () => onEdit(m),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color.withOpacity(.7), size: 18),
          const SizedBox(width: 6),
          Text(
            'No monitoring saved for this Case Plan yet',
            style: TextStyle(color: color.withOpacity(.9)),
          ),
        ],
      ),
    );
  }
}
