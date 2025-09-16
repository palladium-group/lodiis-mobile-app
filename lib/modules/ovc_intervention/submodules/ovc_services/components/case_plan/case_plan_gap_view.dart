
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';
import 'package:provider/provider.dart';

class CasePlanGapView extends StatefulWidget {
  const CasePlanGapView({
    Key? key,
    required this.casePlanGapObjects,            // List<Map> of GAP events (for this CP/domain)
    required this.hasEditAccessToCasePlan,       // preserved (not used in grouped summary)
    required this.isEditableMode,                // preserved (not used in grouped summary)
    required this.isHouseholdCasePlan,
    required this.domainId,
    required this.formSectionColor,
    required this.onEdiCasePlanGap,              // preserved (not used in grouped summary)
    required this.isOnCasePlanServiceProvision,  // preserved (not used)
    required this.isOnCasePlanServiceMonitoring, // preserved (not used)
  }) : super(key: key);

  final List casePlanGapObjects;
  final bool hasEditAccessToCasePlan;
  final bool isEditableMode;
  final bool isHouseholdCasePlan;
  final String domainId;
  final Color formSectionColor;
  final Function onEdiCasePlanGap;
  final bool isOnCasePlanServiceProvision;
  final bool isOnCasePlanServiceMonitoring;

  @override
  State<CasePlanGapView> createState() => _CasePlanGapViewState();
}

class _CasePlanGapViewState extends State<CasePlanGapView> {
  final Map<String, bool> _expandedByGroup = <String, bool>{};

  bool _isTrueLike(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    return v == true || s == 'true' || s == '1' || s == 'yes';
  }

  // Build sections for the current domain (HH or Child)
  List<FormSection> _domainSections() {
    final List<FormSection> all = widget.isHouseholdCasePlan
        ? OvcHouseholdServicesCasePlanGaps.getFormSections(
        firstDate: AppUtil.formattedDateTimeIntoString(DateTime.now()))
        : OvcServicesChildCasePlanGap.getFormSections(
        firstDate: AppUtil.formattedDateTimeIntoString(DateTime.now()));
    return all.where((f) => (f.id ?? '') == widget.domainId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isSesotho = context.select<LanguageTranslationState, bool>(
          (s) => s.isSesothoLanguage,
    );

    final formSectionColor = widget.formSectionColor;

    // Header (unchanged style)
    final title = isSesotho ? 'Likheo' : 'Identified Gaps';

    // 1) Prepare meta: benchmark/subsections and gap toggles
    final List<FormSection> domain = _domainSections();
    final List<FormSection> owners = (domain.isNotEmpty && (domain.first.subSections?.isNotEmpty ?? false))
        ? domain.first.subSections!
        : [
      FormSection(
        color: Colors.transparent,
        id: domain.isNotEmpty ? domain.first.id : widget.domainId,
        name: domain.isNotEmpty ? (domain.first.name ?? widget.domainId) : widget.domainId,
        translatedName: domain.isNotEmpty ? domain.first.translatedName : null,
        inputFields: domain.isNotEmpty ? domain.first.inputFields : const <InputField>[],
      )
    ];

    // Only DEs considered “gap toggles”
    final Set<String> gapToggleDes = Set<String>.from(OvcCasePlanConstant.casPlanServiceGaps);

    // Map: groupLabel -> list of _GapMeta
    final Map<String, List<_GapMeta>> groups = <String, List<_GapMeta>>{};

    for (final owner in owners) {
      final groupLabel = isSesotho
          ? ((owner.translatedName?.isNotEmpty == true ? owner.translatedName : owner.name) ?? '')
          : (owner.name ?? '');
      final metas = <_GapMeta>[];
      for (final f in owner.inputFields ?? const <InputField>[]) {
        if (f.valueType == 'TRUE_ONLY' && gapToggleDes.contains(f.id)) {
          final label = isSesotho
              ? ((f.translatedName?.isNotEmpty == true ? f.translatedName : f.name) ?? '')
              : (f.name ?? '');
          metas.add(_GapMeta(id: f.id ?? '', label: label));
        }
      }
      if (metas.isNotEmpty) {
        groups[groupLabel] = metas;
      }
    }

    // 2) Count entries per gap across provided events (casePlanGapObjects)
    final Map<String, int> counts = <String, int>{};
    for (final raw in widget.casePlanGapObjects) {
      final Map obj = Map<String, dynamic>.from(raw as Map);
      for (final entry in groups.entries) {
        for (final meta in entry.value) {
          final v = obj[meta.id];
          if (_isTrueLike(v)) {
            counts[meta.id] = (counts[meta.id] ?? 0) + 1;
          }
        }
      }
    }

    // 3) Filter out gaps with zero entries; also drop empty groups
    final List<_Group> displayGroups = [];
    groups.forEach((groupLabel, metas) {
      final kept = metas.where((m) => (counts[m.id] ?? 0) > 0).toList()
        ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
      if (kept.isNotEmpty) {
        final totalEntries = kept.fold<int>(0, (acc, m) => acc + (counts[m.id] ?? 0));
        displayGroups.add(_Group(
          label: groupLabel.isNotEmpty ? groupLabel : widget.domainId,
          items: kept,
          totalEntries: totalEntries,
        ));
      }
    });

    // 4) Render
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Column(
        children: [
          // Section header (preserves your style)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: formSectionColor.withOpacity(0.3), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle().copyWith(
                      color: formSectionColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grouped, collapsible benchmarks
          if (displayGroups.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                isSesotho
                    ? 'Ha ho likheo tse ngolisitsoeng bakeng sa moralo ona.'
                    : 'No identified gaps for this case plan yet.',
                style: TextStyle(
                  color: formSectionColor.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            Column(
              children: displayGroups
                  .map(
                    (g) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: formSectionColor.withOpacity(0.045),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: formSectionColor.withOpacity(0.22)),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: _expandedByGroup[g.label] ?? false,
                      onExpansionChanged: (v) =>
                          setState(() => _expandedByGroup[g.label] = v),
                      tilePadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      childrenPadding:
                      const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              g.label,
                              style: TextStyle(
                                color: formSectionColor.withOpacity(0.95),
                                fontWeight: FontWeight.w700,
                                letterSpacing: .2,
                              ),
                            ),
                          ),
                          _MiniChip(
                            label:
                            '${g.items.length} gap${g.items.length == 1 ? '' : 's'}',
                            color: formSectionColor,
                          ),
                          const SizedBox(width: 6),
                          _MiniChip(
                            label:
                            '${g.totalEntries} entr${g.totalEntries == 1 ? 'y' : 'ies'}',
                            color: formSectionColor,
                          ),
                        ],
                      ),
                      children: [
                        // separator
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: LineSeparator(
                            color: formSectionColor.withOpacity(0.25),
                          ),
                        ),
                        ...g.items.map((m) {
                          final count = counts[m.id] ?? 0;
                          return ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -2),
                            title: Text(
                              m.label,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              '$count entr${count == 1 ? 'y' : 'ies'}',
                              style: TextStyle(
                                  color: formSectionColor.withOpacity(0.8)),
                            ),
                            // For now we just show counts; if you want a bottom sheet of raw events per gap,
                            // we can wire it the same way as Service Provision view.
                            onTap: null,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _Group {
  _Group({required this.label, required this.items, required this.totalEntries});
  final String label;
  final List<_GapMeta> items;
  final int totalEntries;
}

class _GapMeta {
  _GapMeta({required this.id, required this.label});
  final String id;
  final String label;
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({Key? key, required this.label, required this.color})
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
