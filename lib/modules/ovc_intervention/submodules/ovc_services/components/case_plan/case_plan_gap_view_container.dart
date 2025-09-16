import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';

// Grouped/collapsible gaps view
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped_view.dart';

// GAP section builders (Household & Child)
// NOTE: If your class names/files differ slightly, adjust these two imports.
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';

/// Container that renders Identified Gaps grouped by Benchmark/Subsection,
/// collapsed by default, and only shows gaps with ≥ 1 recorded entry.
///
/// Required:
/// - [isHouseholdCasePlan] : true for HH CP, false for Child CP
/// - [formSectionColor]    : domain color used for accents
/// - [domainId]            : FormSection.id of the current domain (e.g., 'Health')
/// - [casePlanEvent]       : Map of the selected Case Plan event (should carry
///                           OvcCasePlanConstant.casePlanToGapLinkage or at least event id)
///
/// Optional:
/// - [gapToggleDataElements] : restrict which TRUE_ONLY DEs count as “gap toggles”
/// - [onViewGapEvent]        : tap handler for a gap item (opens details, etc.)
class CasePlanGapViewContainer extends StatelessWidget {
  const CasePlanGapViewContainer({
    Key? key,
    required this.isHouseholdCasePlan,
    required this.formSectionColor,
    required this.domainId,
    required this.casePlanEvent,
    this.gapToggleDataElements,
    this.title = 'Identified gaps',
    this.onViewGapEvent,
  }) : super(key: key);

  final bool isHouseholdCasePlan;
  final Color formSectionColor;
  final String domainId;
  final Map<String, dynamic> casePlanEvent;
  final String title;

  /// If provided, only these DE ids count as “gap toggles”.
  final Set<String>? gapToggleDataElements;

  /// Optional: open a details screen / bottom sheet for a specific gap event.
  final void Function(Map dataObject)? onViewGapEvent;

  List<FormSection> _buildGapSections() {
    // Build full GAP sections set; the grouped view filters to [domainId].
    if (isHouseholdCasePlan) {
      return OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: '');
    } else {
      return OvcServicesChildCasePlanGap.getFormSections(firstDate: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final gapSections = _buildGapSections();

    return IdentifiedGapsGroupedView(
      isHouseholdCasePlan: isHouseholdCasePlan,
      formSectionColor: formSectionColor,
      domainId: domainId,
      casePlan: casePlanEvent,
      gapSections: gapSections,
      gapToggleDataElements: gapToggleDataElements,
      onViewGapEvent: onViewGapEvent,
    );
  }
}
