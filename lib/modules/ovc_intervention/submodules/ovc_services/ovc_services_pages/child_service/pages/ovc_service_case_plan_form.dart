import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/Intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/service_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_case_plan.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:provider/provider.dart';

class OcvServiceCasePlanForm extends StatefulWidget {
  const OcvServiceCasePlanForm({
    Key? key,
    this.shouldEditCaseGapServiceProvision = false,
    this.shoulViewCaseGapServiceProvision = false,
  }) : super(key: key);

  final bool shouldEditCaseGapServiceProvision;
  final bool shoulViewCaseGapServiceProvision;

  @override
  _OcvServiceCasePlanFormState createState() => _OcvServiceCasePlanFormState();
}

class _OcvServiceCasePlanFormState extends State<OcvServiceCasePlanForm> {
  final String label = 'Service Provision';
  late List<FormSection> formSections;
  Map borderColors = Map();

  bool isSaving = false;
  bool isFormReady = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      formSections = [];
      for (FormSection formSection in OvcServicesCasePlan.getFormSections()) {
        borderColors[formSection.id] = formSection.borderColor;
        formSection.borderColor = Colors.transparent;
        formSections.add(formSection);
      }
      isFormReady = true;
    });
  }

  onInputValueChange(String? formSectionId, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(formSectionId, value);
  }

  bool isAllDomainGoalAndGapFilled(Map dataObject) {
    bool isAllDomainFilled = true;
    String casePlanFirstGoal = OvcCasePlanConstant.casePlanFirstGoal;
    for (String domainType in dataObject.keys.toList()) {
      Map domainDataObject = dataObject[domainType];
      if (domainDataObject['gaps'].length > 0 &&
          (domainDataObject[casePlanFirstGoal] == null ||
              '${domainDataObject[casePlanFirstGoal]}'.trim() == '')) {
        isAllDomainFilled = false;
      }
    }
    return isAllDomainFilled;
  }

  Future savingDomainsAndGaps(
    Map dataObject,
    OvcHouseholdChild currentOvcHouseholdChild,
  ) async {
    String casePlanFirstGoal = OvcCasePlanConstant.casePlanFirstGoal;
    for (String domainType in dataObject.keys.toList()) {
      Map domainDataObject = dataObject[domainType];
      if (domainDataObject['gaps'].length > 0 &&
          (domainDataObject[casePlanFirstGoal] != null ||
              '${domainDataObject[casePlanFirstGoal]}'.trim() != '')) {
        try {
          List<String> hiddenFields = [
            OvcCasePlanConstant.casePlanToGapLinkage,
            OvcCasePlanConstant.casePlanDomainType
          ];
          List<FormSection> domainFormSections = formSections
              .where((FormSection formSection) => formSection.id == domainType)
              .toList();
          List<FormSection> domainGapFormSections =
              OvcServicesChildCasePlanGap.getFormSections()
                  .where(
                      (FormSection formSection) => formSection.id == domainType)
                  .toList();
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            OvcChildCasePlanConstant.program,
            OvcChildCasePlanConstant.casePlanProgramStage,
            currentOvcHouseholdChild.orgUnit,
            domainFormSections,
            domainDataObject,
            domainDataObject['eventDate'],
            currentOvcHouseholdChild.id,
            domainDataObject['eventId'],
            hiddenFields,
          );
          hiddenFields = [
            OvcCasePlanConstant.casePlanToGapLinkage,
            OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage
          ];
          for (Map domainGapDataObject in domainDataObject['gaps']) {
            await TrackedEntityInstanceUtil
                .savingTrackedEntityInstanceEventData(
              OvcChildCasePlanConstant.program,
              OvcChildCasePlanConstant.casePlanGapProgramStage,
              currentOvcHouseholdChild.orgUnit,
              domainGapFormSections,
              domainGapDataObject,
              domainGapDataObject['eventDate'],
              currentOvcHouseholdChild.id,
              domainGapDataObject['eventId'],
              hiddenFields,
            );
          }
        } catch (e) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return SubPageAppBar(
              label: label,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Container(
          child: Consumer<ServiceFormState>(
            builder: (context, serviceFormState, child) {
              Map dataObject = serviceFormState.formState;
              return Container(
                child: !isFormReady
                    ? Container(
                        child: CircularProcessLoader(
                          color: Colors.blueGrey,
                        ),
                      )
                    : Container(
                        child: Consumer<OvcHouseholdCurrentSelectionState>(
                            builder: (context,
                                ovcHouseholdCurrentSelectionState, child) {
                          OvcHouseholdChild currentOvcHouseholdChild =
                              ovcHouseholdCurrentSelectionState
                                  .currentOvcHouseholdChild!;
                          int age = 5;
                          try {
                            age = int.parse(currentOvcHouseholdChild.age!);
                          } catch (e) {
                            print(e);
                          }

                          return Column(
                            children: [
                              OvcChildInfoTopHeader(),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 10.0,
                                  left: 13.0,
                                  right: 13.0,
                                ),
                                child: Column(
                                  children: formSections
                                      .map(
                                        (FormSection formSection) => (age < 5 &&
                                                formSection.id == 'Schooled')
                                            ? Container()
                                            : ServiceFormContainer(
                                                shouldEditCaseGapServiceProvision:
                                                    widget
                                                        .shouldEditCaseGapServiceProvision,
                                                shoulViewCaseGapServiceProvision:
                                                    widget
                                                        .shoulViewCaseGapServiceProvision,
                                                formSectionColor: borderColors[
                                                    formSection.id],
                                                formSection: formSection,
                                                dataObject:
                                                    dataObject[formSection.id],
                                                isEditableMode: serviceFormState
                                                    .isEditableMode,
                                                onInputValueChange:
                                                    (dynamic value) =>
                                                        onInputValueChange(
                                                            formSection.id,
                                                            value),
                                              ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: InterventionBottomNavigationBarContainer(),
    );
  }
}
