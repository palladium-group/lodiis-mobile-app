import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/models/form_section.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';

class CasePlanFormContainer extends StatefulWidget {
  const CasePlanFormContainer({
    Key? key,
    required this.mandatoryFieldObject,
    required this.canAddDomainGaps,
    required this.formSectionColor,
    required this.formSection,
    required this.isEditableMode,
    required this.dataObject,
    required this.onInputValueChange,
    required this.isHouseholdCasePlan,
    required this.hasEditAccessToCasePlan,
    required this.enrollmentOuAccessible,
    required this.isOnCasePlanPage,
    required this.isOnCasePlanServiceProvision,
    required this.isOnCasePlanServiceMonitoring,
  }) : super(key: key);

  final Map mandatoryFieldObject;
  final bool canAddDomainGaps;
  final Color formSectionColor;
  final FormSection formSection;
  final bool isEditableMode;
  final Map dataObject;
  final Function(dynamic value) onInputValueChange;

  final bool isHouseholdCasePlan;
  final bool hasEditAccessToCasePlan;
  final bool enrollmentOuAccessible;
  final bool isOnCasePlanPage;
  final bool isOnCasePlanServiceProvision;
  final bool isOnCasePlanServiceMonitoring;

  @override
  State<CasePlanFormContainer> createState() => _CasePlanFormContainerState();
}

class _CasePlanFormContainerState extends State<CasePlanFormContainer> {
  List<FormSection> _gapSectionsForDomain(String domainId) {
    final all = widget.isHouseholdCasePlan
        ? OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: '')
        : OvcServicesChildCasePlanGap.getFormSections(firstDate: '');
    return all.where((s) => (s.id ?? '') == domainId).toList();
  }

  Future<void> _openGeneratePlan() async {
    final domainId = widget.formSection.id ?? '';
    final gapSections = _gapSectionsForDomain(domainId);
    if (gapSections.isEmpty) {
      AppUtil.showToastMessage(message: 'No gap form configured for $domainId');
      return;
    }

    // fresh object for the gap-sheet (tracking fields set but null)
    final obj = <String, dynamic>{
      UserAccountReference.appAndDeviceTrackingDataElement: null,
      UserAccountReference.implementingPartnerDataElement: null,
      UserAccountReference.subImplementingPartnerDataElement: null,
      UserAccountReference.serviceProviderDataElement: null,
    };

    final result = await AppUtil.showActionSheetModal(
      context: context,
      initialHeightRatio: 0.9,
      maxHeightRatio: 0.95,
      containerBody: CasePlanGapFormContainer(
        formSections: gapSections,
        isEditableMode: widget.isEditableMode && widget.hasEditAccessToCasePlan,
        formSectionColor: widget.formSectionColor,
        dataObject: obj,
      ),
    );

    if (result is Map) {
      // merge selected gap into current domain data (dedupe of false/empty handled here)
      final domainMap =
      Map<String, dynamic>.from(widget.dataObject.map((k, v) => MapEntry('$k', v)));
      final currentGaps =
          (domainMap['gaps'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
              <Map<String, dynamic>>[];

      final cleaned = <String, dynamic>{};
      result.forEach((k, v) {
        if (k == 'eventId') {
          cleaned[k] = v; // keep eventId if present (update vs create)
          return;
        }
        if (v == null) return;
        if (v is bool && v == false) return; // skip false
        if (v is String && v.trim().isEmpty) return; // skip empty
        cleaned[k] = v;
      });

      if (cleaned.isNotEmpty) {
        currentGaps.add(cleaned);
        domainMap['gaps'] = currentGaps;
        widget.onInputValueChange(domainMap);
      } else {
        AppUtil.showToastMessage(message: 'No new gaps selected.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<ServiceFormState>();
    final domainId = widget.formSection.id ?? '';

    // ensure we operate on a String-keyed map
    final domainValue =
    Map<String, dynamic>.from(widget.dataObject.map((k, v) => MapEntry('$k', v)));

    final List<Map<String, dynamic>> gaps =
        (domainValue['gaps'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
            const <Map<String, dynamic>>[];

    // Used by grouped viewer (to get labels & subSections)
    final gapSections = _gapSectionsForDomain(domainId);
    final FormSection gapDomain = gapSections.isNotEmpty
        ? gapSections.first
        : FormSection(
      id: domainId,
      name: domainId,
      translatedName: domainId,
      color: widget.formSectionColor,
      borderColor: widget.formSectionColor,
      inputFields: const [],
      subSections: const [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Domain inputs (goals removed in parent)
        EntryFormContainer(
          elevation: 0.0,
          formSections: [widget.formSection],
          hiddenFields: formState.hiddenFields,
          hiddenSections: formState.hiddenSections,
          hiddenInputFieldOptions: formState.hiddenInputFieldOptions,
          mandatoryFieldObject: widget.mandatoryFieldObject,
          dataObject: domainValue,
          isEditableMode: widget.isEditableMode,
          onInputValueChange: widget.onInputValueChange,
          unFilledMandatoryFields: const [],
        ),

        // The ONLY Identified gaps view (grouped by sub-section, no DATE fields)
        if (gaps.isNotEmpty) ...[
          const SizedBox(height: 8),
          IdentifiedGapsGrouped(
            domainId: domainId,
            domainColor: widget.formSectionColor,
            domainDataObject: domainValue, // contains 'gaps'
            isHouseholdCasePlan: widget.isHouseholdCasePlan,
            title: 'Identified gaps',
            compact: false,
          ),
        ],

        // Generate Plan button (below grouped view)
        if (widget.canAddDomainGaps &&
            widget.isEditableMode &&
            widget.hasEditAccessToCasePlan) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: widget.formSectionColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              onPressed: _openGeneratePlan,
              child: const Text(
                'GENERATE PLAN',
                style: TextStyle(
                  color: Color(0xFFFAFAFA),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
