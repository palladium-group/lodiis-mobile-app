import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

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

  final bool isHouseholdCasePlan;
  final bool hasEditAccessToCasePlan;
  final bool enrollmentOuAccessible;
  final bool isEditableMode;
  final bool canAddDomainGaps;

  final bool isOnCasePlanServiceProvision;
  final bool isOnCasePlanServiceMonitoring;
  final Map dataObject;
  final Color formSectionColor;
  final String domainId;
  final Function onInputValueChange;

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
        dataObject[caseToGapLinkage] ?? AppUtil.getUid();
    String casePlanFirstGoal =
        dataObject[OvcCasePlanConstant.casePlanFirstGoal] ?? '';
    String casePlansSecondGoal =
        dataObject[OvcCasePlanConstant.casePlansSecondGoal] ?? '';
    if (casePlanFirstGoal.isEmpty && casePlansSecondGoal.isEmpty) {
      AppUtil.showToastMessage(
        message: 'Please fill at least one goal in $domainId domain',
      );
    } else {
      double ratio = 0.8;
      gapDataObject = gapDataObject ?? {};
      gapDataObject[casePlanGapToServiceProvisionLinkage] =
          gapDataObject[casePlanGapToServiceProvisionLinkage] ??
              AppUtil.getUid();
      gapDataObject[casePlanGapToServiceMonitoringLinkage] =
          gapDataObject[casePlanGapToServiceMonitoringLinkage] ??
              AppUtil.getUid();
      gapDataObject[OvcCasePlanConstant.casePlanFirstGoal] = casePlanFirstGoal;
      gapDataObject[OvcCasePlanConstant.casePlansSecondGoal] =
          casePlansSecondGoal;
      gapDataObject[caseToGapLinkage] = caseToGapLinkageValue;
      List<FormSection> formSections = isHouseholdCasePlan
          ? OvcHouseholdServicesCasePlanGaps.getFormSections(
              firstDate: gapDataObject['eventDate'] ??
                  AppUtil.formattedDateTimeIntoString(
                    DateTime.now(),
                  ),
            ).where((FormSection form) => form.id == domainId).toList()
          : OvcServicesChildCasePlanGap.getFormSections(
              firstDate: gapDataObject['eventDate'] ??
                  AppUtil.formattedDateTimeIntoString(
                    DateTime.now(),
                  ),
            ).where((FormSection form) => form.id == domainId).toList();
      formSections = formSections.map((FormSection form) {
        form.borderColor = Colors.transparent;
        return form;
      }).toList();
      var response = await AppUtil.showActionSheetModal(
        context: context,
        containerBody: CasePlanGapFormContainer(
          formSections: formSections,
          isEditableMode: isEditableMode,
          formSectionColor: formSectionColor,
          dataObject: gapDataObject,
        ),
        initialHeightRatio: ratio,
        maxHeightRatio: ratio,
      );
      if (response != null) {
        var eventId = response['eventId'] ?? '';
        if (isOnEdit) {
          dataObject['gaps'] = (dataObject['gaps'] ?? [])
              .where((dynamic gap) => gap['eventId'] != eventId)
              .toList();
        }
        dataObject['gaps'].add(response);
        onValueChange('gaps', dataObject['gaps']);
      }
    }
  }

  void onValueChange(String id, dynamic value) {
    dataObject[id] = value;
    onInputValueChange(dataObject);
  }

  Map _getCasePlanGapObjects(List casePlanGapObjects) {
    Map sanitizedDataObject = {};
    for (dynamic casePlanGapObject in casePlanGapObjects) {
      Map casePlanGap = Map<String, dynamic>.from(casePlanGapObject);
      sanitizedDataObject = {...sanitizedDataObject, ...casePlanGap};
    }
    return sanitizedDataObject;
  }

  bool _hasCasPlanGaps(List casePlanGapObjects) {
    return casePlanGapObjects.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Column(
        children: [
          CasePlanGapView(
            hasEditAccessToCasePlan: hasEditAccessToCasePlan,
            isEditableMode: isEditableMode,
            isOnCasePlanServiceProvision: isOnCasePlanServiceProvision,
            isOnCasePlanServiceMonitoring: isOnCasePlanServiceMonitoring,
            domainId: domainId,
            formSectionColor: formSectionColor,
            isHouseholdCasePlan: isHouseholdCasePlan,
            casePlanGapObjects: dataObject['gaps'] ?? [],
            onEdiCasePlanGap: (dynamic gapDataObject) => onAddOrEditCasePlanGap(
              context,
              gapDataObject: gapDataObject,
              isOnEdit: true,
            ),
          ),
          Visibility(
            visible: _hasCasPlanGaps(dataObject['gaps'] ?? []),
            child: Container(
              margin: const EdgeInsets.symmetric(),
              child: Column(
                children: [
                  Visibility(
                    visible: isOnCasePlanServiceProvision,
                    child: CasePlanGapServiceProvisionViewContainer(
                      domainId: domainId,
                      formSectionColor: formSectionColor,
                      casePlanGap:
                          _getCasePlanGapObjects(dataObject['gaps'] ?? []),
                      isHouseholdCasePlan: isHouseholdCasePlan,
                      enrollmentOuAccessible: enrollmentOuAccessible,
                    ),
                  ),
                  Visibility(
                    visible: isOnCasePlanServiceMonitoring,
                    child: CasePlanGapServiceMonitoringViewContainer(
                      domainId: domainId,
                      formSectionColor: formSectionColor,
                      casePlanGap:
                          _getCasePlanGapObjects(dataObject['gaps'] ?? []),
                      isHouseholdCasePlan: isHouseholdCasePlan,
                      enrollmentOuAccessible: enrollmentOuAccessible,
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: (isEditableMode && canAddDomainGaps) &&
                !(isOnCasePlanServiceMonitoring ||
                    isOnCasePlanServiceProvision),
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 10.0,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  disabledForegroundColor:
                      formSectionColor.withOpacity(0.5).withOpacity(0.38),
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
                    builder: (context, languageTranslationState, child) => Text(
                      languageTranslationState.isSesothoLanguage
                          ? "Eketsa sekheo"
                          : 'Add Gap',
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
          )
        ],
      ),
    );
  }
}
