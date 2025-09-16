
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';

// ✅ Use your existing heading widget (the one that worked before)

// Grouped/collapsible gaps view we built earlier
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped_view.dart';

import '../cp_section_heading.dart';

/// Container that renders Identified Gaps grouped by Benchmark/Subsection.
/// - Collapsed by default
/// - Only shows gaps with ≥ 1 recorded entry
/// - Uses your existing CpSectionHeading
///
/// Pass everything explicitly (no Provider calls inside build).
class CasePlanGapViewContainer extends StatelessWidget {
  const CasePlanGapViewContainer({
    Key? key,
    required this.title,               // e.g., 'Case Plan Gaps' or 'Likheo (Case Plan)'
    required this.isHouseholdCasePlan, // true for HH CP, false for Child CP
    required this.formSectionColor,    // domain color
    required this.domainId,            // current domain FormSection.id (e.g. 'Health')
    required this.casePlanEvent,       // CP event map (has cp linkage or at least event id)
    required this.gapSections,         // full GAP sections list (HH/Child)
    this.gapToggleDataElements,        // optionally restrict TRUE_ONLY DEs counted as gaps
    this.onViewGapEvent,               // optional tap handler for a gap event
    this.margin,                       // optional outer margin
  }) : super(key: key);

  final String title;
  final bool isHouseholdCasePlan;
  final Color formSectionColor;
  final String domainId;
  final Map<String, dynamic> casePlanEvent;
  final List<FormSection> gapSections;

  final Set<String>? gapToggleDataElements;
  final void Function(Map dataObject)? onViewGapEvent;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔹 Your original header component
          CpSectionHeading(
            title: title,
            color: formSectionColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: IdentifiedGapsGroupedView(
              isHouseholdCasePlan: isHouseholdCasePlan,
              formSectionColor: formSectionColor,
              domainId: domainId,
              casePlan: casePlanEvent,
              gapSections: gapSections,
              gapToggleDataElements: gapToggleDataElements,
              onViewGapEvent: onViewGapEvent,
            ),
          ),
        ],
      ),
    );
  }
}
