
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/events.dart';

// Shared heading & constants
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/household_service_provision.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_service_provision.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import '../../ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import '../cp_section_heading.dart';

class CasePlanGapServiceProvisionView extends StatefulWidget {
  const CasePlanGapServiceProvisionView({
    Key? key,
    required this.isHouseholdCasePlan,
    required this.hasEditAccess,
    required this.formSectionColor,
    required this.domainId,
    required this.casePlanGap,
    required this.onEditCasePlanService,
    required this.onViewCasePlanService,
    this.name, // optional custom title (e.g., 'Health SERVICES')
  }) : super(key: key);

  final bool isHouseholdCasePlan;
  final bool hasEditAccess;
  final Color formSectionColor;
  final String domainId;

  /// Must include CP->Gap & Gap->SP linkages
  final Map<String, dynamic> casePlanGap;

  final void Function(Map dataObject) onEditCasePlanService;
  final void Function(Map dataObject) onViewCasePlanService;

  final String? name;

  @override
  State<CasePlanGapServiceProvisionView> createState() =>
      _CasePlanGapServiceProvisionViewState();
}

class _CasePlanGapServiceProvisionViewState
    extends State<CasePlanGapServiceProvisionView> {
  static const String _cpKey = OvcCasePlanConstant.casePlanToGapLinkage;
  static const String _spKey =
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;

  String get _stage => widget.isHouseholdCasePlan
      ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
      : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;

  final Map<String, bool> _expandedByGroup = {};
  bool _sectionExpanded = true; // controls collapse/expand of the whole view

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

  Map<String, _ServiceMeta> _serviceMetaByDe({
    required List<FormSection> sections,
    required bool isSesotho,
  }) {
    final map = <String, _ServiceMeta>{};

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
            : (domain.name))
            : (domain.name),
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
        if (f.valueType == 'TRUE_ONLY' &&
            OvcCasePlanConstant.casePlanServiceProvisionResults.contains(f.id)) {
          final label = isSesotho
              ? ((f.translatedName?.isNotEmpty == true
              ? f.translatedName
              : f.name) ??
              '')
              : (f.name ?? '');
          map[f.id ?? ''] = _ServiceMeta(
            id: f.id ?? '',
            label: label,
            groupLabel: ownerLabel,
          );
        }
      }
    }
    return map;
  }

  String? _firstNonEmptyReason(Map<String, dynamic> values) {
    for (final de in OvcCasePlanConstant.casePlanServiceProvisionReasons) {
      final v = values[de];
      if (v != null && (v.toString().trim()).isNotEmpty) return v.toString();
    }
    return null;
  }

  // --- Collapsible header (without changing CpSectionHeading) ---
  Widget _buildCollapsibleHeader(String title) {
    // We overlay a chevron and make the whole header tappable.
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _sectionExpanded = !_sectionExpanded),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          // Keep space on right so chevron doesn't cover the title
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: CpSectionHeading(
              title: title,
              color: widget.formSectionColor,
              icon: Icons.assignment_turned_in_rounded,
            ),
          ),
          Positioned(
            right: 12,
            child: Icon(
              _sectionExpanded ? Icons.expand_less : Icons.expand_more,
              color: widget.formSectionColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSesotho =
    context.select<LanguageTranslationState, bool>((s) => s.isSesothoLanguage);

    // Title, overridable by container
    final servicesTitle = widget.name ?? 'Services Provided';

    // sections & service metadata
    final List<FormSection> sections = widget.isHouseholdCasePlan
        ? HouseholdServiceProvision.getFormSections(firstDate: '')
        : OvcServicesChildServiceProvision.getFormSections(firstDate: '');
    final serviceMeta = _serviceMetaByDe(sections: sections, isSesotho: isSesotho);

    // stage events
    final events = context
        .select<ServiceEventDataState, List<Events>>((s) => s.eventsForStage(_stage));

    // Filter by CP/SP (current gap)
    final cp = (widget.casePlanGap[_cpKey] ?? '').toString();
    final sp = (widget.casePlanGap[_spKey] ?? '').toString();
    final filtered = <Map<String, dynamic>>[];
    for (final ev in events) {
      final obj = _toPlainObject(ev);
      if ((obj[_cpKey] ?? '') == cp && (obj[_spKey] ?? '') == sp) {
        filtered.add(obj);
      }
    }

    // Events per service toggle
    final byService = <String, List<Map<String, dynamic>>>{};
    for (final obj in filtered) {
      for (final entry in serviceMeta.entries) {
        final de = entry.key;
        if (_isTrueLike(obj[de])) {
          byService.putIfAbsent(de, () => <Map<String, dynamic>>[]).add(obj);
        }
      }
    }

    // Group services by subsection label, keep only with entries
    final groups = <String, List<_ServiceMeta>>{};
    for (final m in serviceMeta.values) {
      final hasEntries = (byService[m.id]?.isNotEmpty ?? false);
      if (!hasEntries) continue;
      groups.putIfAbsent(m.groupLabel, () => <_ServiceMeta>[]).add(m);
    }

    // Body content
    final Widget body = groups.isEmpty
        ? Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        isSesotho
            ? 'Ha hona litšebeletso tse ngolisitsoeng bakeng sa lekhalo lena.'
            : 'No recorded services for this gap yet.',
        style: TextStyle(
          color: widget.formSectionColor.withOpacity(0.75),
          fontStyle: FontStyle.italic,
        ),
      ),
    )
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groups.entries.map((entry) {
          final groupLabel = entry.key.isNotEmpty ? entry.key : widget.domainId;
          final items = entry.value
            ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

          final servicesCount = items.length;
          final totalEntries =
          items.fold<int>(0, (acc, m) => acc + (byService[m.id]?.length ?? 0));

          final initiallyExpanded = _expandedByGroup[groupLabel] ?? false;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: widget.formSectionColor.withOpacity(0.045),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.formSectionColor.withOpacity(0.22),
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: initiallyExpanded,
                onExpansionChanged: (v) =>
                    setState(() => _expandedByGroup[groupLabel] = v),
                tilePadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                childrenPadding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 10),
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
                    _Chip(
                      label:
                      '$servicesCount service${servicesCount == 1 ? '' : 's' } Provided',
                      color: widget.formSectionColor,
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
                children: items.map((meta) {
                  final list = byService[meta.id] ?? const <Map<String, dynamic>>[];
                  final count = list.length;
                  if (count == 0) return const SizedBox.shrink();
                  return ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -2),
                    title: Text(
                      meta.label,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '$count time${count == 1 ? '' : 's'}',
                      style: TextStyle(
                        color: widget.formSectionColor.withOpacity(0.8),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showEventsSheet(
                      context: context,
                      color: widget.formSectionColor,
                      serviceLabel: meta.label,
                      events: list,
                      onTapEvent: widget.onViewCasePlanService,
                      firstNonEmptyReason: _firstNonEmptyReason,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }).toList(),
      ),
    );

    // Header + collapsible body (no extra spacing when collapsed)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCollapsibleHeader(servicesTitle),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 160),
          crossFadeState: _sectionExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(), // no space when collapsed
          secondChild: body,
        ),
      ],
    );
  }

  Future<void> _showEventsSheet({
    required BuildContext context,
    required Color color,
    required String serviceLabel,
    required List<Map<String, dynamic>> events,
    required void Function(Map dataObject) onTapEvent,
    required String? Function(Map<String, dynamic>) firstNonEmptyReason,
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
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)
                ],
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
                            serviceLabel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                        if (events.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                                '${events.length} entr${events.length == 1 ? 'y' : 'ies'}'),
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
                        'No services recorded yet.',
                        style: TextStyle(color: color.withOpacity(0.7)),
                      ),
                    )
                        : ListView.separated(
                      controller: controller,
                      itemCount: events.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final obj = events[index];
                        final date = obj['eventDate'] ?? '';
                        final comment = firstNonEmptyReason(obj) ?? '';
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          title: const Text('Event Details'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text('Date of Service: $date'),
                              if (comment.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text('Comments: $comment'),
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

class _ServiceMeta {
  final String id;
  final String label;
  final String groupLabel;
  _ServiceMeta({
    required this.id,
    required this.label,
    required this.groupLabel,
  });
}

class _Chip extends StatelessWidget {
  const _Chip({Key? key, required this.label, required this.color})
      : super(key: key);

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
