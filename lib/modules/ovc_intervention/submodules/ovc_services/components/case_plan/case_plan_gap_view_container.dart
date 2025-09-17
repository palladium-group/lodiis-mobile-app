
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';

// Grouped gaps view you already use
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped_view.dart';

import '../cp_section_heading.dart';

/// Container that renders Identified Gaps grouped by Benchmark/Subsection.
/// - Title (current domain) is COLLAPSIBLE
/// - When collapsed: ONLY the title is visible
/// - When expanded: shows gapSections preview + IdentifiedGapsGroupedView
/// - NEW: optional trailingAction shown on the same row as the title (right side)
class CasePlanGapViewContainer extends StatefulWidget {
  const CasePlanGapViewContainer({
    Key? key,
    required this.title,
    required this.isHouseholdCasePlan,
    required this.formSectionColor,
    required this.domainId,
    required this.casePlanEvent,
    required this.gapSections,
    this.gapToggleDataElements,
    this.onViewGapEvent,
    this.margin,
    this.trailingAction, // 👈 NEW
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

  /// Optional widget shown on the right side of the header row
  final Widget? trailingAction;

  @override
  State<CasePlanGapViewContainer> createState() => _CasePlanGapViewContainerState();
}

class _CasePlanGapViewContainerState extends State<CasePlanGapViewContainer> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔹 Collapsible current domain title (tap to expand/collapse)
          // We overlay a right-side "action bar" that contains [trailingAction] and the chevron.
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                // Add right padding so header text never sits under the action bar
                Padding(
                  padding: EdgeInsets.only(right: widget.trailingAction == null ? 38.0 : 120.0),
                  child: CpSectionHeading(
                    title: widget.title,
                    color: widget.formSectionColor,
                  ),
                ),

                // Right-side action bar: [trailingAction] then chevron, horizontally
                Positioned(
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.trailingAction != null) ...[
                        // Make sure taps on the trailing action don't toggle the header
                        GestureDetector(
                          onTap: () {}, // absorb
                          behavior: HitTestBehavior.opaque,
                          child: widget.trailingAction!,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        color: widget.formSectionColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 EXPANDED CONTENT:
          //     - gapSections preview (benchmarks/subsections)
          //     - IdentifiedGapsGroupedView (the actual domain gaps list)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            crossFadeState:
            _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // The grouped gaps (visible only when expanded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: IdentifiedGapsGroupedView(
                    isHouseholdCasePlan: widget.isHouseholdCasePlan,
                    formSectionColor: widget.formSectionColor,
                    domainId: widget.domainId,
                    casePlan: widget.casePlanEvent,
                    gapSections: widget.gapSections,
                    gapToggleDataElements: widget.gapToggleDataElements,
                    onViewGapEvent: widget.onViewGapEvent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

