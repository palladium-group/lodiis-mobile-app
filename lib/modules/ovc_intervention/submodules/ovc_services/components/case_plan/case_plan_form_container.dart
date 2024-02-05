import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_view_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

class CasePlanFormContainer extends StatelessWidget {
  const CasePlanFormContainer({
    Key? key,
    required this.formSectionColor,
    required this.formSection,
    required this.isEditableMode,
    required this.mandatoryFieldObject,
    required this.canAddDomainGaps,
    required this.dataObject,
    required this.onInputValueChange,
    required this.isHouseholdCasePlan,
    required this.hasEditAccessToCasePlan,
    required this.enrollmentOuAccessible,
    required this.isOnCasePlanPage,
    required this.isOnCasePlanServiceProvision,
    required this.isOnCasePlanServiceMonitoring,
    this.unFilledMandatoryFields,
    this.currentHouseholdChild,
  }) : super(key: key);

  final Color formSectionColor;
  final FormSection formSection;
  final bool isEditableMode;
  final bool canAddDomainGaps;
  final Map dataObject;
  final Function onInputValueChange;
  final Map? mandatoryFieldObject;
  final bool isHouseholdCasePlan;
  final bool hasEditAccessToCasePlan;
  final bool enrollmentOuAccessible;
  final bool isOnCasePlanPage;
  final bool isOnCasePlanServiceProvision;
  final bool isOnCasePlanServiceMonitoring;
  final OvcHouseholdChild? currentHouseholdChild;
  final List? unFilledMandatoryFields;

  void onValueChange(String id, dynamic value) {
    dynamic previousValue = dataObject[id] ?? '';
    dataObject[id] = value;
    bool canUpdate = _hasAtLeasOneGoalAndGap();
    if (canUpdate) {
      onInputValueChange(dataObject);
    } else {
      dataObject[id] = previousValue;
      AppUtil.showToastMessage(
        message: 'You can not clear all goals with identifier needs/gaps',
      );
    }
  }

  bool _hasAtLeasOneGoalAndGap() {
    bool status = true;
    dynamic gaps = dataObject['gaps'] ?? [];
    String firstGoal = dataObject[OvcCasePlanConstant.casePlanFirstGoal] ?? '';
    String secondGoal =
        dataObject[OvcCasePlanConstant.casePlansSecondGoal] ?? '';
    if (gaps.isNotEmpty && firstGoal.isEmpty && secondGoal.isEmpty) {
      status = false;
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ),
        child: MaterialCard(
          body: Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
                border: Border(
              left: BorderSide(
                color: formSectionColor,
                width: 8.0,
              ),
            )),
            child: Column(
              children: [
                EntryFormContainer(
                  unFilledMandatoryFields: unFilledMandatoryFields,
                  elevation: 0.0,
                  formSections: [formSection],
                  mandatoryFieldObject: mandatoryFieldObject,
                  dataObject: dataObject,
                  isEditableMode: isEditableMode && isOnCasePlanPage,
                  onInputValueChange: onValueChange,
                ),
                CasePlanGapViewContainer(
                  isHouseholdCasePlan: isHouseholdCasePlan,
                  isOnCasePlanServiceProvision: isOnCasePlanServiceProvision,
                  isOnCasePlanServiceMonitoring: isOnCasePlanServiceMonitoring,
                  domainId: formSection.id!,
                  hasEditAccessToCasePlan: hasEditAccessToCasePlan,
                  enrollmentOuAccessible: enrollmentOuAccessible,
                  canAddDomainGaps: canAddDomainGaps,
                  isEditableMode: isEditableMode && isOnCasePlanPage,
                  dataObject: dataObject,
                  formSectionColor: formSectionColor,
                  onInputValueChange: (dynamic value) =>
                      onValueChange(formSection.id!, value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
