
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_view.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';

class CasePlanGapViewContainer extends StatelessWidget {
  const CasePlanGapViewContainer({
    Key? key,
    required this.dataObject,
    required this.formSectionColor,
    required this.isHouseholdCasePlan,
    required this.hasEditAccessToCasePlan,
    required this.enrollmentOuAccessible,
    required this.isEditableMode,
    required this.canAddDomainGaps,
    required this.domainId,
    required this.onInputValueChange,
    required this.isOnCasePlanServiceProvision,
    required this.isOnCasePlanServiceMonitoring,
  }) : super(key: key);

  final Map dataObject;
  final Color formSectionColor;
  final bool isHouseholdCasePlan;
  final bool hasEditAccessToCasePlan;
  final bool enrollmentOuAccessible;
  final bool isEditableMode;
  final bool canAddDomainGaps;
  final String domainId;
  final bool isOnCasePlanServiceProvision;
  final bool isOnCasePlanServiceMonitoring;
  final Function(dynamic value) onInputValueChange;

  // If someone still taps edit on a gap row, we open the gap form.
  Future<void> _onEditGap(
      BuildContext context, {
        required Map<String, dynamic> gapDataObject,
      }) async {
    // Resolve the gap sections for this domain
    List<FormSection> sections = isHouseholdCasePlan
        ? OvcHouseholdServicesCasePlanGaps.getFormSections(
      firstDate: gapDataObject['eventDate'] ??
          AppUtil.formattedDateTimeIntoString(DateTime.now()),
    ).where((s) => (s.id ?? '') == domainId).toList()
        : OvcServicesChildCasePlanGap.getFormSections(
      firstDate: gapDataObject['eventDate'] ??
          AppUtil.formattedDateTimeIntoString(DateTime.now()),
    ).where((s) => (s.id ?? '') == domainId).toList();

    sections = sections.map((s) {
      s.borderColor = Colors.transparent;
      return s;
    }).toList();

    final response = await AppUtil.showActionSheetModal(
      context: context,
      initialHeightRatio: 0.9,
      maxHeightRatio: 0.95,
      containerBody: CasePlanGapFormContainer(
        formSections: sections,
        isEditableMode: isEditableMode && hasEditAccessToCasePlan,
        formSectionColor: formSectionColor,
        dataObject: gapDataObject,
        isChildCasePlan: !isHouseholdCasePlan,
      ),
    );

    if (response is Map) {
      // Update dataObject['gaps'] list by replacing edited eventId
      final eventId = (response['eventId'] ?? '').toString();
      final List<Map<String, dynamic>> gaps = ((dataObject['gaps'] as List?) ??
          const <Map<String, dynamic>>[])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final updated = <Map<String, dynamic>>[];
      for (final g in gaps) {
        if ((g['eventId'] ?? '') == eventId && eventId.isNotEmpty) {
          updated.add(Map<String, dynamic>.from(response));
        } else {
          updated.add(g);
        }
      }
      if (eventId.isEmpty) {
        // in case edit created a new one somehow, append
        updated.add(Map<String, dynamic>.from(response));
      }
      dataObject['gaps'] = updated;
      onInputValueChange(dataObject);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> rawGaps = (dataObject['gaps'] as List?) ?? const [];
    final List<Map<String, dynamic>> gaps =
    rawGaps.map((e) => Map<String, dynamic>.from(e as Map)).toList();

    return Container(
      margin: const EdgeInsets.symmetric(),
      child: CasePlanGapView(
        hasEditAccessToCasePlan: hasEditAccessToCasePlan,
        isEditableMode: isEditableMode,
        isOnCasePlanServiceProvision: isOnCasePlanServiceProvision,
        isOnCasePlanServiceMonitoring: isOnCasePlanServiceMonitoring,
        domainId: domainId,
        formSectionColor: formSectionColor,
        isHouseholdCasePlan: isHouseholdCasePlan,
        casePlanGapObjects: gaps, // already typed
        onEdiCasePlanGap: (dynamic gap) => _onEditGap(
          context,
          gapDataObject: Map<String, dynamic>.from(gap as Map),
        ),
      ),
    );
  }
}

