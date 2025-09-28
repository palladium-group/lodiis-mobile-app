
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';

// Grouped gaps view you already use
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped_view.dart';

import '../cp_section_heading.dart';

/// Container that renders Identified Gaps grouped by Benchmark/Subsection.
/// - Collapsible title row (chevron on the right)
/// - When expanded: shows grouped gaps + (NEW) an optional footer widget *after* the gaps
/// - Use [footerAfterGaps] for "+ Gaps" so it collapses with the gaps.
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
    this.trailingAction,   // kept for backward compat (stays in header)
    this.footerAfterGaps,  // NEW: rendered inside expanded body after gaps
    this.initiallyExpanded = false,
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

  /// Optional widget shown on the right side of the header row (stays visible when collapsed).
  final Widget? trailingAction;

  /// NEW: Optional widget placed *below* the gaps, inside expanded area (collapses with the gaps).
  final Widget? footerAfterGaps;

  /// Start open?
  final bool initiallyExpanded;

  @override
  State<CasePlanGapViewContainer> createState() => _CasePlanGapViewContainerState();
}

class _CasePlanGapViewContainerState extends State<CasePlanGapViewContainer> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Title + (optional) trailingAction + chevron
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                // Add right padding so text doesn't sit under action/chevron
                Padding(
                  padding: EdgeInsets.only(right: widget.trailingAction == null ? 38.0 : 120.0),
                  child: CpSectionHeading(
                    title: widget.title,
                    color: widget.formSectionColor,
                  ),
                ),
                Positioned(
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.trailingAction != null) ...[
                        // Absorb taps so they don't toggle expand/collapse
                        GestureDetector(
                          onTap: () {}, // keep header collapsed/expanded state unchanged
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

          // Body: Gaps + (NEW) footerAfterGaps; both collapse together
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                if (widget.footerAfterGaps != null) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: widget.footerAfterGaps!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
