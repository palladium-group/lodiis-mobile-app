
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';

/// Pretty, overflow-safe grouped gaps view
/// Shows only true/ticked gap flags (ignores DATE fields).
class IdentifiedGapsGrouped extends StatelessWidget {
  const IdentifiedGapsGrouped({
    Key? key,
    required this.domainId,
    required this.domainColor,
    required this.domainDataObject,
    required this.isHouseholdCasePlan,
    this.title = 'Identified gaps',
    this.compact = false,
  }) : super(key: key);

  final String domainId;
  final Color domainColor;
  final Map<String, dynamic> domainDataObject; // expects {'gaps': [ ... ] }
  final bool isHouseholdCasePlan;
  final String title;
  final bool compact;

  bool _isTrueLike(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    return v == true || s == 'true' || s == '1' || s == 'yes';
  }

  @override
  Widget build(BuildContext context) {
    final isSesotho =
    context.select<LanguageTranslationState, bool>((s) => s.isSesothoLanguage);

    final List<Map<String, dynamic>> gaps =
        (domainDataObject['gaps'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
            const <Map<String, dynamic>>[];

    if (gaps.isEmpty) {
      return const SizedBox.shrink();
    }

    final sections = isHouseholdCasePlan
        ? OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: '')
        : OvcServicesChildCasePlanGap.getFormSections(firstDate: '');
    final FormSection domain = sections.firstWhere(
          (s) => (s.id ?? '') == domainId,
      orElse: () => FormSection(
        id: domainId,
        name: domainId,
        translatedName: domainId,
        color: domainColor,
        borderColor: domainColor,
        inputFields: const [],
        subSections: const [],
      ),
    );

    // Build lookups for labels and sub-sections
    final Map<String, FormSection?> ownerByInputId = {};
    final Map<String, InputField> inputById = {};

    void _indexSection(FormSection sec) {
      for (final f in (sec.inputFields ?? const <InputField>[])) {
        inputById[f.id!] = f;
        ownerByInputId[f.id!] = null;
      }
      for (final sub in (sec.subSections ?? const <FormSection>[])) {
        for (final f in (sub.inputFields ?? const <InputField>[])) {
          inputById[f.id!] = f;
          ownerByInputId[f.id!] = sub;
        }
      }
    }

    _indexSection(domain);

    // Merge gaps for display
    final merged = <String, dynamic>{};
    for (final g in gaps) {
      g.forEach((k, v) {
        if (!merged.containsKey(k)) merged[k] = v;
      });
    }

    // Group truthy flags by sub-section title
    final Map<String, List<String>> bySub = {};
    merged.forEach((id, val) {
      final field = inputById[id];
      if (field == null) return;
      if (field.valueType == 'DATE') return;
      if (!_isTrueLike(val)) return;

      final owner = ownerByInputId[id];
      final subNameRaw = owner == null
          ? (isSesotho
          ? (domain.translatedName?.isNotEmpty == true
          ? domain.translatedName!
          : domain.name ?? '')
          : (domain.name ?? ''))
          : (isSesotho
          ? (owner.translatedName?.isNotEmpty == true
          ? owner.translatedName!
          : owner.name ?? '')
          : (owner.name ?? ''));

      final label = isSesotho
          ? (field.translatedName?.isNotEmpty == true
          ? field.translatedName!
          : field.name ?? id)
          : (field.name ?? id);

      bySub.putIfAbsent(subNameRaw, () => <String>[]);
      bySub[subNameRaw]!.add(label);
    });

    if (bySub.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: domainColor.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSesotho ? 'Likheo tse khethiloeng' : title,
            style: TextStyle(
              fontSize: compact ? 13 : 14.5,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          ...bySub.entries.map((entry) {
            final subTitle = entry.key;
            final chips = entry.value;
            final subColor = domainColor.withOpacity(0.85);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // sub-section title
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: subColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          subTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: compact ? 12.5 : 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // chips grid
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: chips.map((label) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: domainColor.withOpacity(0.25)),
                          color: domainColor.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        constraints: const BoxConstraints(maxWidth: 260),
                        child: Text(
                          label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: compact ? 11.5 : 12.5,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
