import 'package:flutter/material.dart';

import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';

/// Pretty, overflow-safe grouped gaps view
///
/// Expects the current domain "dataObject" (with `gaps` list) and will render
/// only the true/ticked service flags, grouped under their sub-section names.
/// DATE inputs are intentionally ignored here.
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
  final Map<String, dynamic> domainDataObject;
  final bool isHouseholdCasePlan;
  final String title;
  final bool compact;

  bool _isTrueLike(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    return v == true || s == 'true' || s == '1' || s == 'yes';
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gaps =
        (domainDataObject['gaps'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
            const <Map<String, dynamic>>[];

    if (gaps.isEmpty) {
      return const SizedBox.shrink();
    }

    // Load the domain (with subSections + inputFields) so we can group by sub-section
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

    // Map each input id to its owning subSection (or null for top-level)
    final Map<String, FormSection?> ownerByInputId = {};
    final Map<String, InputField> inputById = {};

    // Top-level inputs
    for (final f in (domain.inputFields ?? const <InputField>[])) {
      inputById[f.id] = f;
      ownerByInputId[f.id] = null;
    }
    // Sub-sections
    for (final sub in (domain.subSections ?? const <FormSection>[])) {
      for (final f in (sub.inputFields ?? const <InputField>[])) {
        inputById[f.id] = f;
        ownerByInputId[f.id] = sub;
      }
    }

    // We collect "true/ticked" fields across all gaps and group them by sub-section
    final Map<FormSection?, Set<String>> groupedIds = {};
    for (final gap in gaps) {
      gap.forEach((key, value) {
        final id = key.toString();
        final field = inputById[id];
        if (field == null) return;

        // Skip DATE fields in this display
        if ((field.valueType ?? '').toUpperCase() == 'DATE') return;

        if (_isTrueLike(value)) {
          final owner = ownerByInputId[id]; // can be null for top-level
          groupedIds.putIfAbsent(owner, () => <String>{}).add(id);
        }
      });
    }

    if (groupedIds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: domainColor.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(12),
        color: domainColor.withOpacity(0.04),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title – ellipsize to avoid row overflow
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: domainColor,
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 13 : 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // One card per sub-section (or "Other" for top-level)
          ...groupedIds.entries.map((entry) {
            final FormSection? sub = entry.key;
            final ids = entry.value.toList()..sort();

            final header = (sub?.name ?? 'Other').toString();
            final subColor = sub?.borderColor ?? domainColor;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: subColor.withOpacity(0.35)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sub-section title – safe overflow
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            header,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: subColor,
                              fontWeight: FontWeight.w700,
                              fontSize: compact ? 12 : 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Chips wrap to new lines – no horizontal overflow
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ids.map((id) {
                        final label = (inputById[id]?.name ?? id).toString();
                        return Container(
                          constraints: const BoxConstraints(minHeight: 32),
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 10),
                          decoration: BoxDecoration(
                            color: subColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: subColor.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Little dot
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: subColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              // Label – ellipsize inside chip
                              ConstrainedBox(
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
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

