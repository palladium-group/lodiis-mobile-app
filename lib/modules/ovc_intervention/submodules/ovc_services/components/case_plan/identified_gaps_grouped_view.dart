
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/events.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';

import '../../ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';

class IdentifiedGapsGroupedView extends StatefulWidget {
  const IdentifiedGapsGroupedView({
    Key? key,
    required this.isHouseholdCasePlan,
    required this.formSectionColor,
    required this.domainId,
    required this.casePlan, // Map of the selected Case Plan event
    required this.gapSections, // GAP form sections (HH or Child)
    this.gapToggleDataElements,
    this.onViewGapEvent,
  }) : super(key: key);

  final bool isHouseholdCasePlan;
  final Color formSectionColor;
  final String domainId;
  final Map<String, dynamic> casePlan;
  final List<FormSection> gapSections;
  final Set<String>? gapToggleDataElements;
  final void Function(Map dataObject)? onViewGapEvent;

  @override
  State<IdentifiedGapsGroupedView> createState() => _IdentifiedGapsGroupedViewState();
}

class _IdentifiedGapsGroupedViewState extends State<IdentifiedGapsGroupedView> {
  static const String _cpKey = OvcCasePlanConstant.casePlanToGapLinkage;

  String get _gapStage => widget.isHouseholdCasePlan
      ? OvcHouseholdCasePlanConstant.casePlanGapProgramStage
      : OvcChildCasePlanConstant.casePlanGapProgramStage;

  final Map<String, bool> _expandedByGroup = {};

  bool _isTrueLike(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    return v == true || s == 'true' || s == '1' || s == 'yes';
  }

  Map<String, dynamic> _toPlainObject(dynamic ev) {
    try {
      if (ev is Events) {
        final out = <String, dynamic>{};
        final dv = ev.dataValues;
        if (dv is Map) {
          dv.forEach((k, v) => out['$k'] = v);
        } else if (dv is List) {
          for (final row in dv) {
            if (row is Map && row['dataElement'] != null) {
              out['${row['dataElement']}'] = row['value'];
            }
          }
        }
        out['eventDate'] = ev.eventDate;
        out['event'] = ev.event;
        return out;
      }
    } catch (_) {}
    if (ev is Map) {
      final raw = ev['dataValues'] ?? ev['data'] ?? {};
      final out = <String, dynamic>{};
      if (raw is Map) {
        raw.forEach((k, v) => out['$k'] = v);
      } else if (raw is List) {
        for (final row in raw) {
          if (row is Map && row['dataElement'] != null) {
            out['${row['dataElement']}'] = row['value'];
          }
        }
      }
      out['eventDate'] = ev['eventDate'];
      out['event'] = ev['event'];
      return out;
    }
    return const {};
  }

  Map<String, _GapMeta> _gapMetaByDe({
    required List<FormSection> sections,
    required bool isSesotho,
  }) {
    final map = <String, _GapMeta>{};

    final FormSection domain = sections.firstWhere(
          (s) => (s.id ?? '') == widget.domainId,
      orElse: () => FormSection(
        color: Colors.transparent,
        id: widget.domainId,
        name: widget.domainId,
        subSections: const [],
        inputFields: const [],
      ),
    );

    final List<FormSection> owners = (domain.subSections?.isNotEmpty == true)
        ? domain.subSections!
        : [
      FormSection(
        color: Colors.transparent,
        id: widget.domainId,
        name: isSesotho
            ? (domain.translatedName?.isNotEmpty == true
            ? domain.translatedName!
            : (domain.name ?? widget.domainId))
            : (domain.name ?? widget.domainId),
        inputFields: domain.inputFields,
      )
    ];

    for (final owner in owners) {
      final ownerLabel = isSesotho
          ? ((owner.translatedName?.isNotEmpty == true
          ? owner.translatedName
          : owner.name) ??
          '')
          : (owner.name ?? '');

      for (final f in owner.inputFields ?? const <InputField>[]) {
        final isToggle =
            f.valueType == 'TRUE_ONLY' &&
                (widget.gapToggleDataElements == null ||
                    widget.gapToggleDataElements!.contains(f.id));
        if (isToggle) {
          final label = isSesotho
              ? ((f.translatedName?.isNotEmpty == true ? f.translatedName : f.name) ?? '')
              : (f.name ?? '');
          final id = f.id ?? '';
          map[id] = _GapMeta(id: id, label: label, groupLabel: ownerLabel);
        }
      }
    }
    return map;
  }

  String? _firstNonEmptyComment(Map<String, dynamic> values) {
    for (final de in OvcCasePlanConstant.casePlanServiceProvisionReasons) {
      final v = values[de];
      if (v != null && (v.toString().trim()).isNotEmpty) return v.toString();
    }
    for (final de in OvcCasePlanConstant.casePlanServiceProvisionReasons) {
      final v = values[de];
      if (v != null && (v.toString().trim()).isNotEmpty) return v.toString();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isSesotho =
    context.select<LanguageTranslationState, bool>((s) => s.isSesothoLanguage);

    final meta = _gapMetaByDe(sections: widget.gapSections, isSesotho: isSesotho);

    final events = context
        .select<ServiceEventDataState, List<Events>>((s) => s.eventsForStage(_gapStage));

    final cpLinkValue = (widget.casePlan[_cpKey] ??
        widget.casePlan['event'] ??
        widget.casePlan['eventId'] ??
        '')
        .toString();

    final gapEvents = <Map<String, dynamic>>[];
    for (final ev in events) {
      final obj = _toPlainObject(ev);
      if ((obj[_cpKey] ?? '') == cpLinkValue) {
        gapEvents.add(obj);
      }
    }

    final byGap = <String, List<Map<String, dynamic>>>{};
    for (final obj in gapEvents) {
      for (final entry in meta.entries) {
        final de = entry.key;
        if (_isTrueLike(obj[de])) {
          byGap.putIfAbsent(de, () => <Map<String, dynamic>>[]).add(obj);
        }
      }
    }

    final groups = <String, List<_GapMeta>>{};
    for (final m in meta.values) {
      final has = (byGap[m.id]?.isNotEmpty ?? false);
      if (!has) continue;
      groups.putIfAbsent(m.groupLabel, () => <_GapMeta>[]).add(m);
    }

    if (groups.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          isSesotho
              ? 'Ha ho likheo tse ngolisitsoeng bakeng sa moralo ona.'
              : 'No identified gaps for this case plan yet.',
          style: TextStyle(
            color: widget.formSectionColor.withOpacity(0.75),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    final groupEntries = groups.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupEntries.map((entry) {
        final groupLabel = entry.key.isNotEmpty ? entry.key : widget.domainId;
        final items = entry.value
          ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

        final gapsCount = items.length;
        final totalEntries = items.fold<int>(0, (acc, g) => acc + (byGap[g.id]?.length ?? 0));
        final initiallyExpanded = _expandedByGroup[groupLabel] ?? false;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: widget.formSectionColor.withOpacity(0.045),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.formSectionColor.withOpacity(0.22)),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              initiallyExpanded: initiallyExpanded,
              onExpansionChanged: (v) => setState(() => _expandedByGroup[groupLabel] = v),
              tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              childrenPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      groupLabel,
                      style: TextStyle(
                        color: widget.formSectionColor.withOpacity(0.95),
                        fontWeight: FontWeight.w700,
                        letterSpacing: .2,
                      ),
                    ),
                  ),
                  _MiniChip(
                    label: '$gapsCount gap${gapsCount == 1 ? '' : 's'}',
                    color: widget.formSectionColor,
                  ),
                  const SizedBox(width: 6),
                  _MiniChip(
                    label: '$totalEntries entr${totalEntries == 1 ? 'y' : 'ies'}',
                    color: widget.formSectionColor,
                  ),
                ],
              ),
              children: items.map((gapMeta) {
                final list = byGap[gapMeta.id] ?? const <Map<String, dynamic>>[];
                final count = list.length;
                if (count == 0) return const SizedBox.shrink();
                return ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -2),
                  title: Text(
                    gapMeta.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '$count entr${count == 1 ? 'y' : 'ies'}',
                    style: TextStyle(color: widget.formSectionColor.withOpacity(0.8)),
                  ),
                  trailing: widget.onViewGapEvent != null ? const Icon(Icons.chevron_right) : null,
                  onTap: widget.onViewGapEvent == null
                      ? null
                      : () => _showGapEventsSheet(
                    context: context,
                    color: widget.formSectionColor,
                    gapLabel: gapMeta.label,
                    events: list,
                    onTapEvent: widget.onViewGapEvent!,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showGapEventsSheet({
    required BuildContext context,
    required Color color,
    required String gapLabel,
    required List<Map<String, dynamic>> events,
    required void Function(Map dataObject) onTapEvent,
  }) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
              ),
              child: Column(
                children: [
                  Container(
                    width: 46,
                    height: 5,
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            gapLabel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                        if (events.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text('${events.length} entr${events.length == 1 ? 'y' : 'ies'}'),
                          ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: events.isEmpty
                        ? Center(
                      child: Text(
                        'No gap events recorded.',
                        style: TextStyle(color: color.withOpacity(0.7)),
                      ),
                    )
                        : ListView.separated(
                      controller: controller,
                      itemCount: events.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final obj = events[index];
                        final date = AppUtil.getDateIntoDateTimeFormat(obj['eventDate']) ??
                            (obj['eventDate'] ?? '');
                        final comment = _firstNonEmptyComment(obj) ?? '';
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          title: Text('$date'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (comment.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text('Comment: $comment'),
                              ],
                            ],
                          ),
                          trailing: const Icon(Icons.open_in_new),
                          onTap: () => onTapEvent(obj),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _GapMeta {
  final String id;
  final String label;
  final String groupLabel;
  _GapMeta({required this.id, required this.label, required this.groupLabel});
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({Key? key, required this.label, required this.color}) : super(key: key);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color.withOpacity(0.95),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
