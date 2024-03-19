import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/household_services_ongoing_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_ongoing_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/skip_logics/ovc_service_monitoring_skip_logic.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_service_monitoring_household_to_ovc_util.dart';
import 'package:provider/provider.dart';

class CasePlanGapServiceMonitoringFormContainer extends StatefulWidget {
  const CasePlanGapServiceMonitoringFormContainer({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.gapServiceMonitoringObject,
    required this.isHouseholdCasePlan,
    required this.enrollmentOuAccessible,
    required this.isEditableMode,
    required this.casePlanGapDate,
  }) : super(key: key);

  final String domainId;
  final String casePlanGapDate;
  final Color formSectionColor;
  final Map gapServiceMonitoringObject;
  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;
  final bool isEditableMode;

  @override
  State<CasePlanGapServiceMonitoringFormContainer> createState() =>
      _CasePlanGapServiceMonitoringFormContainerState();
}

class _CasePlanGapServiceMonitoringFormContainerState
    extends State<CasePlanGapServiceMonitoringFormContainer>
    with OvcServiceMonitoringSkipLogic {
  bool _isFormReady = false;
  bool _isSaving = false;
  List<FormSection> formSections = [];
  List<String> mandatoryFields = [];
  List unFilledMandatoryFields = [];
  Map mandatoryFieldObject = {};

  @override
  void initState() {
    super.initState();
    setFormMetdata();
  }

  void setFormMetdata() {
    mandatoryFieldObject.clear();
    formSections = widget.isHouseholdCasePlan
        ? HouseholdServicesOngoingMonitoring.getFormSections()
        : OvcServicesOngoingMonitoring.getFormSections();
    formSections = formSections
        .where((formSection) =>
            formSection.id == widget.domainId ||
            formSection.id == '' ||
            formSection.id == null)
        .toList();

    formSections = [
      AppUtil.getServiceProvisionEventDateSection(
        inputColor: widget.formSectionColor,
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: widget.formSectionColor,
        formSectionLabel: 'Service Monitoring Date',
        inputFieldLabel: 'Service Monitoring On',
        firstDate: widget.casePlanGapDate,
      ),
      ...formSections
    ];
    mandatoryFields = ['eventDate'];
    if (!widget.enrollmentOuAccessible) {
      formSections = [
        AppUtil.getServiceProvisionLocationSection(
          id: OvcCasePlanConstant.casePlanLocatinSectionId,
          inputColor: widget.formSectionColor,
          labelColor: const Color(0xFF1A3518),
          sectionLabelColor: widget.formSectionColor,
          formlabel: 'Location',
          allowedSelectedLevels: [
            AppHierarchyReference.communityLevel,
          ],
          program: widget.isHouseholdCasePlan
              ? OvcHouseholdCasePlanConstant.program
              : OvcChildCasePlanConstant.program,
        ),
        ...formSections
      ];
      String orgUnit = widget.gapServiceMonitoringObject['location'] ?? '';
      onInputValueChange('location', orgUnit);
      mandatoryFields.add('location');
    }
    formSections = formSections.map((formSection) {
      formSection.borderColor = Colors.transparent;
      return formSection;
    }).toList();
    for (String field in mandatoryFields) {
      mandatoryFieldObject[field] = true;
    }
    Timer(const Duration(milliseconds: 200), () {
      _isFormReady = true;
      evaluateSkipLogics(
          context, formSections, widget.gapServiceMonitoringObject);
      setState(() {});
    });
  }

  void onInputValueChange(String id, dynamic value) {
    widget.gapServiceMonitoringObject[id] = value;
    setState(() {});
    evaluateSkipLogics(
        context, formSections, widget.gapServiceMonitoringObject);
  }

  void onSaveCasePlanMonitoring() async {
    bool hasAtLeasrOnFieldFilled = FormUtil.hasAtLeastOnFieldFilled(
      hiddenFields: hiddenFields,
      formSections: formSections,
      dataObject: widget.gapServiceMonitoringObject,
    );
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      widget.gapServiceMonitoringObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections,
      ),
    );
    unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
      mandatoryFields,
      widget.gapServiceMonitoringObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections,
      ),
    );
    setState(() {});
    if (hadAllMandatoryFilled) {
      if (hasAtLeasrOnFieldFilled) {
        _isSaving = true;
        setState(() {});
        try {
          List<String> hiddenFields = [
            OvcCasePlanConstant.casePlanGapToMonitoringLinkage
          ];
          List<OvcHouseholdChild> childrens =
              Provider.of<OvcHouseholdCurrentSelectionState>(context,
                          listen: false)
                      .currentOvcHousehold!
                      .children ??
                  [];
          TrackedEntityInstance beneficiary = widget.isHouseholdCasePlan
              ? Provider.of<OvcHouseholdCurrentSelectionState>(context,
                      listen: false)
                  .currentOvcHousehold!
                  .teiData!
              : Provider.of<OvcHouseholdCurrentSelectionState>(context,
                      listen: false)
                  .currentOvcHouseholdChild!
                  .teiData!;
          String orgUnit = widget.gapServiceMonitoringObject['location'] ??
              beneficiary.orgUnit ??
              '';
          orgUnit = orgUnit.isEmpty ? beneficiary.orgUnit ?? '' : orgUnit;
          String eventDate = widget.gapServiceMonitoringObject['eventDate'];
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            widget.isHouseholdCasePlan
                ? OvcHouseholdCasePlanConstant.program
                : OvcChildCasePlanConstant.program,
            widget.isHouseholdCasePlan
                ? OvcHouseholdCasePlanConstant
                    .casePlanGapServiceMonitoringProgramStage
                : OvcChildCasePlanConstant
                    .casePlanGapServiceMonitoringProgramStage,
            orgUnit,
            formSections,
            widget.gapServiceMonitoringObject,
            eventDate,
            beneficiary.trackedEntityInstance,
            widget.gapServiceMonitoringObject['eventId'],
            hiddenFields,
          );
          if (widget.isHouseholdCasePlan) {
            await OvcCasePlanServiceMonitoringHouseholdToOvcUtil
                .autoSyncOvcsCasePlanServiceMonitoring(
                    childrens: childrens,
                    dataObject: widget.gapServiceMonitoringObject,
                    domainId: widget.domainId,
                    orgUnit: orgUnit,
                    eventDate: eventDate);
          }
          Provider.of<ServiceEventDataState>(context, listen: false)
              .resetServiceEventDataState(beneficiary.trackedEntityInstance);
          String? currentLanguage =
              Provider.of<LanguageTranslationState>(context, listen: false)
                  .currentLanguage;
          AppUtil.showToastMessage(
            message: currentLanguage == 'lesotho'
                ? 'Fomo e bolokeile'
                : 'Form has been saved successfully',
          );
          Navigator.pop(context);
        } catch (e) {
          _isSaving = true;
          setState(() {});
          AppUtil.showToastMessage(
            message: e.toString(),
          );
        }
      } else {
        AppUtil.showToastMessage(
          message: 'Please fill at least one field',
        );
      }
    } else {
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;

        return Container(
          margin: const EdgeInsets.symmetric(
            vertical: 15.0,
          ),
          child: !_isFormReady
              ? const CircularProcessLoader(
                  color: Colors.blueGrey,
                )
              : Column(
                  children: [
                    EntryFormContainer(
                      hiddenFields: hiddenFields,
                      hiddenSections: hiddenSections,
                      elevation: 0.0,
                      formSections: formSections,
                      mandatoryFieldObject: mandatoryFieldObject,
                      unFilledMandatoryFields: unFilledMandatoryFields,
                      dataObject: widget.gapServiceMonitoringObject,
                      isEditableMode: widget.isEditableMode,
                      onInputValueChange: onInputValueChange,
                    ),
                    Visibility(
                      visible: widget.isEditableMode,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: widget.formSectionColor,
                          ),
                          onPressed: onSaveCasePlanMonitoring,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              vertical: 22.0,
                            ),
                            child: Text(
                              _isSaving
                                  ? currentLanguage == 'lesotho'
                                      ? 'E ntse e boloka tlhahlobo e hlophisitsoeng ea lelapa'
                                      : 'SAVING MONITORING ...'
                                  : currentLanguage == 'lesotho'
                                      ? 'Boloka tlhahlobo e hlophisitsoeng ea lelapa'
                                      : 'SAVE MONITORING',
                              style: const TextStyle().copyWith(
                                color: const Color(0xFFFAFAFA),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
