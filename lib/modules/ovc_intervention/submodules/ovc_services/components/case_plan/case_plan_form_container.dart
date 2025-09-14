
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/models/form_section.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/identified_gaps_grouped.dart';

// SP & MON view containers (they render their own add buttons and lists)
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_view_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_view_container.dart';

// Gap schemas
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';

// Constants
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

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
  final Map dataObject; // domain scoped value (String->dynamic expected)
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
  // ---------------- helpers ----------------

  List<FormSection> _gapSectionsForDomain(String domainId) {
    final all = widget.isHouseholdCasePlan
        ? OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: '')
        : OvcServicesChildCasePlanGap.getFormSections(firstDate: '');
    return all.where((s) => (s.id ?? '') == domainId).toList();
  }

  Map<String, dynamic> _mergedGapForDomain(
      List<Map<String, dynamic>> gaps,
      ) {
    // Merge ticked/true-ish flags (skip metadata keys)
    const skip = {
      'eventId',
      'eventDate',
      UserAccountReference.appAndDeviceTrackingDataElement,
      UserAccountReference.implementingPartnerDataElement,
      UserAccountReference.subImplementingPartnerDataElement,
      UserAccountReference.serviceProviderDataElement,
      // stable linkages live on the domain object; we don't merge them from gap blobs
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
    };
    final out = <String, dynamic>{};
    for (final g in gaps) {
      g.forEach((k, v) {
        if (!skip.contains(k)) {
          out[k] = out[k] ?? v;
        }
      });
    }
    return out;
  }

  /// Ensure this domain has stable linkage keys (cp/sp/mon) only once, post-frame.
  void _ensureStableLinkOnDomainValue(
      Map<String, dynamic> domainValue,
      String domainId,
      ) {
    const cpKey = OvcCasePlanConstant.casePlanToGapLinkage;
    const spKey = OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;
    const monKey = OvcCasePlanConstant.casePlanGapToMonitoringLinkage;

    bool changed = false;

    if ((domainValue[cpKey] ?? '').toString().isEmpty) {
      domainValue[cpKey] = AppUtil.getUid();
      changed = true;
      if (kDebugMode) {
        debugPrint('[CasePlanForm] Set stable "$cpKey" => ${domainValue[cpKey]} for domain=$domainId');
      }
    }
    if ((domainValue[spKey] ?? '').toString().isEmpty) {
      domainValue[spKey] = AppUtil.getUid();
      changed = true;
      if (kDebugMode) {
        debugPrint('[CasePlanForm] Set stable "$spKey" => ${domainValue[spKey]} for domain=$domainId');
      }
    }
    if ((domainValue[monKey] ?? '').toString().isEmpty) {
      domainValue[monKey] = AppUtil.getUid();
      changed = true;
      if (kDebugMode) {
        debugPrint('[CasePlanForm] Set stable "$monKey" => ${domainValue[monKey]} for domain=$domainId');
      }
    }

    if (changed) {
      // Persist back to parent form state safely after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onInputValueChange(Map<String, dynamic>.from(domainValue));
      });
    }
  }

  Future<void> _openGeneratePlan() async {
    final domainId = widget.formSection.id ?? '';
    final gapSections = _gapSectionsForDomain(domainId);
    if (gapSections.isEmpty) {
      AppUtil.showToastMessage(message: 'No gap form configured for $domainId');
      return;
    }

    final seed = <String, dynamic>{
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
        dataObject: seed,
      ),
    );

    if (result is Map) {
      final domainMap = Map<String, dynamic>.from(
        widget.dataObject.map((k, v) => MapEntry('$k', v)),
      );
      final currentGaps =
          (domainMap['gaps'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
              <Map<String, dynamic>>[];

      final cleaned = <String, dynamic>{};
      result.forEach((k, v) {
        if (k == 'eventId') {
          cleaned[k] = v;
          return;
        }
        if (v == null) return;
        if (v is bool && v == false) return;
        if (v is String && v.trim().isEmpty) return;
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

  // ------------- build ---------------------

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<ServiceFormState>();

    final String domainId = widget.formSection.id ?? '';
    final Map<String, dynamic> domainValue = Map<String, dynamic>.from(
      widget.dataObject.map((k, v) => MapEntry('$k', v)),
    );
    final List<Map<String, dynamic>> gaps =
        (domainValue['gaps'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
            const <Map<String, dynamic>>[];

    if (kDebugMode) {
      debugPrint('[CasePlanFormContainer] domain=$domainId '
          'isOnCasePlanPage=${widget.isOnCasePlanPage} '
          'isOnServiceProvision=${widget.isOnCasePlanServiceProvision} '
          'isOnMonitoring=${widget.isOnCasePlanServiceMonitoring} '
          'hasEditAccess=${widget.hasEditAccessToCasePlan} '
          'isEditableMode=${widget.isEditableMode} '
          'canAddDomainGaps=${widget.canAddDomainGaps} '
          'gapsCount=${gaps.length}');
    }

    // Ensure stable link keys exist (done safely post-frame)
    _ensureStableLinkOnDomainValue(domainValue, domainId);

    // For grouped view schema lookup (labels/sub-sections)
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

    final mergedGap = _mergedGapForDomain(gaps);

    // Only show grouped gaps here when on the Case Plan page
    final bool showGroupedHere = widget.isOnCasePlanPage;

    // Stable linkages pulled from domain value (must be non-empty)
    const cpKey = OvcCasePlanConstant.casePlanToGapLinkage;
    const spKey = OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;
    const monKey = OvcCasePlanConstant.casePlanGapToMonitoringLinkage;

    final String cpLink = (domainValue[cpKey] ?? '').toString();
    final String spLink = (domainValue[spKey] ?? '').toString();
    final String monLink = (domainValue[monKey] ?? '').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1) Domain entry form
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

        // 2) Grouped Identified Gaps (only on Case Plan page)
        if (showGroupedHere && gaps.isNotEmpty) ...[
          const SizedBox(height: 8),
          IdentifiedGapsGrouped(
            domainId: domainId,
            domainColor: widget.formSectionColor,
            domainDataObject: domainValue,
            isHouseholdCasePlan: widget.isHouseholdCasePlan,
            title: 'Identified gaps',
            compact: false,
          ),
        ],

        const SizedBox(height: 8),

        // 3) Case Plan page action button (Generate plan)
        if (widget.isOnCasePlanPage &&
            widget.hasEditAccessToCasePlan &&
            widget.canAddDomainGaps)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: widget.formSectionColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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

        // 4) On SP/MON pages, render their containers.
        //    We pass both the merged gap flags map AND the raw domain gaps list,
        //    PLUS stable linkages so their list queries and add flows work.
        if (gaps.isNotEmpty) ...[
          const SizedBox(height: 10),

          if (widget.isOnCasePlanServiceProvision)
            CasePlanGapServiceProvisionViewContainer(
              domainId: domainId,
              formSectionColor: widget.formSectionColor,
              casePlanGap: <String, dynamic>{
                ...mergedGap,
                cpKey: cpLink,
                spKey: spLink,
                'eventDate': (domainValue['eventDate'] ?? '').toString(),
                'location': (domainValue['location'] ?? '').toString(),
              },
              domainGaps: gaps, // <-- powers grouped header in SP view
              isHouseholdCasePlan: widget.isHouseholdCasePlan,
              enrollmentOuAccessible: widget.enrollmentOuAccessible,
              showIdentifiedGapsHeader: true,
            ),

          if (widget.isOnCasePlanServiceMonitoring)
            CasePlanGapServiceMonitoringViewContainer(
              domainId: domainId,
              formSectionColor: widget.formSectionColor,
              casePlanGap: <String, dynamic>{
                ...mergedGap,
                cpKey: cpLink,
                monKey: monLink,
                'eventDate': (domainValue['eventDate'] ?? '').toString(),
                'location': (domainValue['location'] ?? '').toString(),
              },
              isHouseholdCasePlan: widget.isHouseholdCasePlan,
              enrollmentOuAccessible: widget.enrollmentOuAccessible,
            ),
        ],
      ],
    );
  }
}
