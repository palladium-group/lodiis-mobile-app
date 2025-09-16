
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:provider/provider.dart';

// Language state to switch Sesotho/English title
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

// Shared heading

// Grouped/collapsible gaps view
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped_view.dart';

// GAP section builders (Household & Child)
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';

import '../cp_section_heading.dart';

class CasePlanGapViewContainer extends StatelessWidget {
  const CasePlanGapViewContainer({
    Key? key,
    required this.isHouseholdCasePlan,
    required this.formSectionColor,
    required this.domainId,
    required this.casePlanEvent,
    this.gapToggleDataElements,
    this.onViewGapEvent,
  }) : super(key: key);

  final bool isHouseholdCasePlan;
  final Color formSectionColor;
  final String domainId;
  final Map<String, dynamic> casePlanEvent;

  final Set<String>? gapToggleDataElements;
  final void Function(Map dataObject)? onViewGapEvent;

  List<FormSection> _buildGapSections() {
    if (isHouseholdCasePlan) {
      return OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: '');
    } else {
      return OvcServicesChildCasePlanGap.getFormSections(firstDate: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSesotho = context.select<LanguageTranslationState, bool>(
          (s) => s.isSesothoLanguage,
    );
    final gapTitle = isSesotho ? 'Likheo (Case Plan)' : 'Case Plan Gaps';

    final gapSections = _buildGapSections();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CpSectionHeading(
          title: gapTitle,
          color: formSectionColor,
          icon: Icons.warning_amber_rounded,
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
    );
  }
}
