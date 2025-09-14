
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_view_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_provision_view_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_view.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';

class CasePlanGapViewContainer extends StatelessWidget {
  const CasePlanGapViewContainer({
    Key? key,
    // keep existing required params
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
    // NEW: optional (to avoid “required but missing” at call sites)
    this.domainDataObject,
  }) : super(key: key);

  // existing
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
  final Function onInputValueChange;

  // optional, safe default
  final Map<String, dynamic>? domainDataObject;

  final String caseToGapLinkage = OvcCasePlanConstant.casePlanToGapLinkage;
  final String casePlanGapToServiceProvisionLinkage =
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;
  final String casePlanGapToServiceMonitoringLinkage =
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage;

  void onAddOrEditCasePlanGap(
      BuildContext context, {
        Map? gapDataObject,
        bool isOnEdit = false,
      }) async {
    String caseToGapLinkageValue =
    (dataObject[caseToGapLinkage] ?? AppUtil.getUid()).toString();
    String casePlanFirstGoal =
    (dataObject[OvcCasePlanConstant.casePlanFirstGoal] ?? '').toString();
    String casePlansSecondGoal =
    (dataObject[OvcCasePlanConstant.casePlansSecondGoal] ?? '').toString();

    double ratio = 0.8;
    final Map<String, dynamic> gap = Map<String, dynamic>.from(gapDataObject ?? {});
    gap[casePlanGapToServiceProvisionLinkage] =
        (gap[casePlanGapToServiceProvisionLinkage] ?? AppUtil.getUid()).toString();
    gap[casePlanGapToServiceMonitoringLinkage] =
        (gap[casePlanGapToServiceMonitoringLinkage] ?? AppUtil.getUid()).toString();
    gap[OvcCasePlanConstant.casePlanFirstGoal] = casePlanFirstGoal;
    gap[OvcCasePlanConstant.casePlansSecondGoal] = casePlansSecondGoal;
    gap[caseToGapLinkage] = caseToGapLinkageValue;

    final String firstDate = (gap['eventDate'] ??
        AppUtil.formattedDateTimeIntoString(DateTime.now()))
        .toString();

    List<FormSection> formSections = isHouseholdCasePlan
        ? OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: firstDate)
        .where((s) => (s.id ?? '') == domainId)
        .toList()
        : OvcServicesChildCasePlanGap.getFormSections(firstDate: firstDate)
        .where((s) => (s.id ?? '') == domainId)
        .toList();

    formSections = formSections
        .map((f) {
      f.borderColor = Colors.transparent;
      return f;
    })
        .toList();

    final response = await AppUtil.showActionSheetModal(
      context: context,
      containerBody: CasePlanGapFormContainer(
        formSections: formSections,
        isEditableMode: isEditableMode,
        formSectionColor: formSectionColor,
        dataObject: gap,
        isChildCasePlan: !isHouseholdCasePlan,
      ),
      initialHeightRatio: ratio,
      maxHeightRatio: ratio,
    );

    if (response != null) {
      final String eventId = (response['eventId'] ?? '').toString();
      final List<dynamic> gapsList =
      List<dynamic>.from((dataObject['gaps'] ?? []) as List);

      if (isOnEdit) {
        dataObject['gaps'] =
            gapsList.where((g) => (g as Map)['eventId'] != eventId).toList();
      }

      gapsList.add(response);
      onValueChange('gaps', gapsList);
    }
  }

  void onValueChange(String id, dynamic value) {
    dataObject[id] = value;
    onInputValueChange(dataObject);
  }

  Map<String, dynamic> _getCasePlanGapObjects(List casePlanGapObjects) {
    final out = <String, dynamic>{};
    for (final obj in casePlanGapObjects) {
      final m = Map<String, dynamic>.from(obj as Map);
      out.addAll(m);
    }
    return out;
  }

  bool _hasCasPlanGaps(List casePlanGapObjects) => casePlanGapObjects.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> rawGaps = List<dynamic>.from((dataObject['gaps'] ?? []) as List);

    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Column(
        children: [
          // Classic gaps list (edit/view single gap cards)
          CasePlanGapView(
            hasEditAccessToCasePlan: hasEditAccessToCasePlan,
            isEditableMode: isEditableMode,
            isOnCasePlanServiceProvision: isOnCasePlanServiceProvision,
            isOnCasePlanServiceMonitoring: isOnCasePlanServiceMonitoring,
            domainId: domainId,
            formSectionColor: formSectionColor,
            isHouseholdCasePlan: isHouseholdCasePlan,
            casePlanGapObjects: rawGaps,
            onEdiCasePlanGap: (dynamic gapDataObject) => onAddOrEditCasePlanGap(
              context,
              gapDataObject: gapDataObject as Map?,
              isOnEdit: true,
            ),
          ),

          // Service Provision / Monitoring containers (use merged gap object)
          Visibility(
            visible: _hasCasPlanGaps(rawGaps),
            child: Container(
              margin: const EdgeInsets.symmetric(),
              child: Column(
                children: [
                  if (isOnCasePlanServiceProvision)
                    CasePlanGapServiceProvisionViewContainer(
                      domainId: domainId,
                      formSectionColor: formSectionColor,
                      casePlanGap: _getCasePlanGapObjects(rawGaps),
                      isHouseholdCasePlan: isHouseholdCasePlan,
                      enrollmentOuAccessible: enrollmentOuAccessible,
                      // optional grouped gaps can use the whole section map if you want
                      domainDataObject: Map<String, dynamic>.from(
                        (domainDataObject ?? dataObject).map(
                              (k, v) => MapEntry(k.toString(), v),
                        ),
                      ),
                    ),
                  if (isOnCasePlanServiceMonitoring)
                    CasePlanGapServiceMonitoringViewContainer(
                      domainId: domainId,
                      formSectionColor: formSectionColor,
                      casePlanGap: _getCasePlanGapObjects(rawGaps),
                      isHouseholdCasePlan: isHouseholdCasePlan,
                      enrollmentOuAccessible: enrollmentOuAccessible,
                      domainDataObject: Map<String, dynamic>.from(
                        (domainDataObject ?? dataObject).map(
                              (k, v) => MapEntry(k.toString(), v),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),

          // (Optional) Generate Plan button if you still show gaps here
          Visibility(
            visible: (isEditableMode && canAddDomainGaps) &&
                !(isOnCasePlanServiceMonitoring || isOnCasePlanServiceProvision),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  disabledForegroundColor:
                  formSectionColor.withOpacity(0.38),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: formSectionColor),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () => onAddOrEditCasePlanGap(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 40.0,
                  ),
                  child: Consumer<LanguageTranslationState>(
                    builder: (context, lang, child) => Text(
                      lang.isSesothoLanguage ? "Eketsa sekheo" : 'Generate Plan',
                      style: const TextStyle().copyWith(
                        color: formSectionColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
