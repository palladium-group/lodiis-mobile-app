
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';

import 'package:kb_mobile_app/models/form_section.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_view_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_view_container.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

import 'case_plan_gap_view_container.dart';

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
  final Map dataObject; // domain scoped value
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

  Map<String, dynamic> _mergedGapForDomain(List<Map<String, dynamic>> gaps) {
    const skip = {
      'eventId',
      'eventDate',
      UserAccountReference.appAndDeviceTrackingDataElement,
      UserAccountReference.implementingPartnerDataElement,
      UserAccountReference.subImplementingPartnerDataElement,
      UserAccountReference.serviceProviderDataElement,
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
    };
    final out = <String, dynamic>{};
    for (final g in gaps) {
      g.forEach((k, v) {
        if (!skip.contains(k)) out[k] = out[k] ?? v;
      });
    }
    return out;
  }

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
        debugPrint('[CasePlanForm] Set "$cpKey" => ${domainValue[cpKey]} ($domainId)');
      }
    }
    if ((domainValue[spKey] ?? '').toString().isEmpty) {
      domainValue[spKey] = AppUtil.getUid();
      changed = true;
    }
    if ((domainValue[monKey] ?? '').toString().isEmpty) {
      domainValue[monKey] = AppUtil.getUid();
      changed = true;
    }
    if (changed) {
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
        isEditableMode:
        widget.isEditableMode && widget.hasEditAccessToCasePlan,
        formSectionColor: widget.formSectionColor,
        dataObject: seed,
        isHouseholdCasePlan: widget.isHouseholdCasePlan,
      ),
    );

    if (result is Map) {
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
    final Map<String, dynamic> domainValue =
    Map<String, dynamic>.from(widget.dataObject.map((k, v) => MapEntry('$k', v)));
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

    _ensureStableLinkOnDomainValue(domainValue, domainId);

    final gapSections = _gapSectionsForDomain(domainId);
    final mergedGap = _mergedGapForDomain(gaps);
    final bool showGroupedHere = widget.isOnCasePlanPage;

    const cpKey = OvcCasePlanConstant.casePlanToGapLinkage;
    const spKey = OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;
    const monKey = OvcCasePlanConstant.casePlanGapToMonitoringLinkage;

    final String cpLink = (domainValue[cpKey] ?? '').toString();
    final String spLink = (domainValue[spKey] ?? '').toString();
    final String monLink = (domainValue[monKey] ?? '').toString();

    final canShowAddButton = widget.isOnCasePlanPage &&
        widget.hasEditAccessToCasePlan &&
        widget.canAddDomainGaps;

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
        if (showGroupedHere && widget.canAddDomainGaps) ...[
          const SizedBox(height: 6),

          // Reserve right space so chevron in the inner header stays visible.
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Give the container a right padding so the chevron isn’t covered by the button
              Padding(
                padding: const EdgeInsets.only(right: 88.0), // space for button
                child: CasePlanGapViewContainer(
                  margin: const EdgeInsets.only(bottom: 6), // tighter between domains
                  title: widget.formSection.name,
                  isHouseholdCasePlan: widget.isHouseholdCasePlan,
                  formSectionColor: widget.formSectionColor,
                  domainId: domainId,
                  casePlanEvent: domainValue,
                  gapSections: gapSections,
                  onViewGapEvent: (_) {},
                ),
              ),

              if (canShowAddButton)
                Positioned(
                  // align with header baseline, not on top of chevron
                  right: 12,
                  top: 10,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: widget.formSectionColor),
                      foregroundColor: widget.formSectionColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _openGeneratePlan,
                    child: const Text(
                      '+ Gaps',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],

        const SizedBox(height: 6),

        // 3) On SP/MON pages, render their containers.
        if (gaps.isNotEmpty) ...[
          if (widget.isOnCasePlanServiceProvision)
            CasePlanGapServiceProvisionViewContainer(
              tittle: widget.formSection.name,
              domainId: domainId,
              formSectionColor: widget.formSectionColor,
              casePlanGap: <String, dynamic>{
                ...mergedGap,
                cpKey: cpLink,
                spKey: spLink,
                'eventDate': (domainValue['eventDate'] ?? '').toString(),
                'location': (domainValue['location'] ?? '').toString(),
              },
              domainGaps: gaps,
              isHouseholdCasePlan: widget.isHouseholdCasePlan,
              enrollmentOuAccessible: widget.enrollmentOuAccessible,
              showIdentifiedGapsHeader: true,
            ),

          if (widget.isOnCasePlanServiceMonitoring)
            CasePlanGapServiceMonitoringViewContainer(
              tittle: widget.formSection.name,
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
