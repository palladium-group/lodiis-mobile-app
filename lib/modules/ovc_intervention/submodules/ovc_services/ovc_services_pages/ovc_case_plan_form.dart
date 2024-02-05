import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_enrollment_household_service.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_case_plan.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_gap_household_to_ovc_util.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_util.dart';
import 'package:provider/provider.dart';

class OvcCasePlanForm extends StatefulWidget {
  const OvcCasePlanForm({
    Key? key,
    required this.casePlanLabel,
    required this.enrollmentDate,
    required this.currentCasePlanDate,
    required this.hasEditAccessToCasePlan,
    required this.enrollmentOuAccessible,
    required this.isHouseholdCasePlan,
    required this.casePlanProgram,
    required this.casePlanProgramStage,
    required this.casePlanGapProgramStage,
    required this.casePlanServiceProgramStage,
    required this.casePlanMonitoringProgramStage,
    required this.isOnCasePlanPage,
    required this.isOnCasePlanServiceProvision,
    required this.isOnCasePlanServiceMonitoring,
  }) : super(key: key);

  final String casePlanLabel;
  final String currentCasePlanDate;
  final String enrollmentDate;
  final bool hasEditAccessToCasePlan;
  final String casePlanProgram;
  final String casePlanProgramStage;
  final String casePlanGapProgramStage;
  final String casePlanServiceProgramStage;
  final String casePlanMonitoringProgramStage;
  final bool enrollmentOuAccessible;
  final bool isHouseholdCasePlan;
  final bool isOnCasePlanPage;
  final bool isOnCasePlanServiceProvision;
  final bool isOnCasePlanServiceMonitoring;

  @override
  State<OvcCasePlanForm> createState() => _OvcCasePlanFormState();
}

class _OvcCasePlanFormState extends State<OvcCasePlanForm> {
  List<FormSection> formSections = [];
  Map borderColors = {};
  final List<Map> childrenMapObjects = [];
  bool _isSaving = false;
  bool _isFormNotReady = true;
  final List<String> mandatoryFields = OvcServicesCasePlan.getMandatoryField();
  final Map mandatoryFieldObject = {};

  @override
  void initState() {
    super.initState();
    _setFormMetadata();
  }

  void _setFormMetadata() {
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
    }
    _isFormNotReady = true;
    setState(() {});
    formSections = [];
    for (FormSection formSection in OvcServicesCasePlan.getFormSections(
      firstDate: widget.enrollmentDate,
    )) {
      // Removing the Schooled section for caregiver
      if (!(widget.isHouseholdCasePlan && ['Schooled'].contains(formSection.id))) {
        borderColors[formSection.id] = formSection.borderColor;
        formSection.borderColor = Colors.transparent;
        formSections.add(formSection);
      }
      // Removing the house categorization for child
      if (!widget.isHouseholdCasePlan &&
          formSection.id == OvcCasePlanConstant.householdCategorizationSection) {
        formSections.remove(formSection);
      }
    }
    if (!widget.enrollmentOuAccessible) {
      formSections = [
        AppUtil.getServiceProvisionLocationSection(
          id: OvcCasePlanConstant.casePlanLocatinSectionId,
          inputColor: const Color(0xFF4B9F46),
          labelColor: const Color(0xFF1A3518),
          sectionLabelColor: const Color(0xFF1A3518),
          formlabel: 'Location',
          allowedSelectedLevels: [
            AppHierarchyReference.communityLevel,
          ],
          program: widget.casePlanProgram,
        ),
        ...formSections
      ];
      mandatoryFieldObject['location'] = true;
    }
    Timer(const Duration(milliseconds: 500), () {
      _isFormNotReady = false;
      setState(() {});
    });
  }

  onInputValueChange(String? formSectionId, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(formSectionId, value);
  }

  void onSaveCasePlan({
    required Map dataObject,
  }) async {
    bool isAllDomainFilled = OvcCasePlanUtil.isAllDomainGoalAndGapFilled(
      dataObject,
      isHouseholdCasePlan: widget.isHouseholdCasePlan,
    );
    bool hasLocationFilled = OvcCasePlanUtil.isLocationOnCasePlanFormFilled(dataObject,
        sectionsId: OvcCasePlanConstant.casePlanLocatinSectionId,
        shouldCheck: !widget.enrollmentOuAccessible);
    bool hasCasePlanDateFilled = OvcCasePlanUtil.isCasePlanDateOnCasePlanFormFilled(dataObject,
        sectionsId: OvcCasePlanConstant.casePlanEventDateSectionId);
    if (isAllDomainFilled && hasLocationFilled && hasCasePlanDateFilled) {
      _isSaving = true;
      setState(() {});
      List<OvcHouseholdChild> children =
          Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
                  .currentOvcHousehold
                  ?.children ??
              [];
      TrackedEntityInstance beneficiary = widget.isHouseholdCasePlan
          ? Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
              .currentOvcHousehold!
              .teiData!
          : Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
              .currentOvcHouseholdChild!
              .teiData!;
      String orgUnit = widget.enrollmentOuAccessible
          ? beneficiary.orgUnit ?? ''
          : OvcCasePlanUtil.getLocationFromCasePlanForm(
              dataObject, OvcCasePlanConstant.casePlanLocatinSectionId);
      orgUnit = orgUnit.isEmpty ? beneficiary.orgUnit ?? '' : orgUnit;
      String casePlanEventDate = OvcCasePlanUtil.getCasePlanDateFromCasePlanForm(
          dataObject, OvcCasePlanConstant.casePlanEventDateSectionId);
      await savingDomainsAndGaps(
        dataObject: dataObject,
        beneficiary: beneficiary,
        orgUnit: orgUnit,
        eventDate: casePlanEventDate,
      );
      if (widget.isHouseholdCasePlan) {
        await updateHouseholdCategorization(beneficiary, dataObject);
        await OvcCasePlanGapHouseholdToOvcUtil.autoSyncOvcsCasPlanGaps(
          currentCasePlanDate: widget.currentCasePlanDate,
          childrens: children,
          dataObject: dataObject,
          orgUnit: orgUnit,
          eventDate: casePlanEventDate,
        );
      }
      Provider.of<ServiceEventDataState>(context, listen: false)
          .resetServiceEventDataState(beneficiary.trackedEntityInstance);
      Timer(const Duration(milliseconds: 200), () {
        if (Navigator.canPop(context)) {
          String currentLanguage =
              Provider.of<LanguageTranslationState>(context, listen: false).currentLanguage;
          AppUtil.showToastMessage(
            message: currentLanguage == 'lesotho'
                ? 'Fomo e bolokeile'
                : 'Form has been saved successfully',
          );
          _isSaving = false;
          setState(() {});
          Navigator.pop(context);
        }
      });
    } else {
      setState(() {});
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory field and at least one goal for all domain with gaps',
      );
    }
  }

  Future<void> updateHouseholdCategorization(
    TrackedEntityInstance beneficiary,
    Map<dynamic, dynamic> dataObject,
  ) async {
    OvcEnrollmentHouseholdService().updateHouseholdStatus(
        trackedEntityInstance: beneficiary.trackedEntityInstance,
        orgUnit: beneficiary.orgUnit,
        dataObject: {
          BeneficiaryIdentification.householdCategorization:
              dataObject[OvcCasePlanConstant.householdCategorizationSection]
                      [OvcCasePlanConstant.houseHoldCategorizationDataElement] ??
                  ''
        },
        inputFieldIds: [
          BeneficiaryIdentification.householdCategorization
        ]).then((value) {
      Provider.of<OvcInterventionListState>(context, listen: false).refreshOvcList();
      Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
          .refetchCurrentHousehold();
      Provider.of<ServiceEventDataState>(context, listen: false)
          .resetServiceEventDataState(beneficiary.trackedEntityInstance);
    }).catchError((error) {});
  }

  Future<void> savingDomainsAndGaps({
    required Map dataObject,
    required TrackedEntityInstance beneficiary,
    required String orgUnit,
    required String eventDate,
  }) async {
    String casePlanFirstGoal = OvcCasePlanConstant.casePlanFirstGoal;
    for (String domainType in dataObject.keys.toList()) {
      Map domainDataObject = dataObject[domainType];
      if (domainType != OvcCasePlanConstant.casePlanLocatinSectionId &&
              (domainDataObject['gaps'].length > 0 &&
                  (domainDataObject[casePlanFirstGoal] != null ||
                      '${domainDataObject[casePlanFirstGoal]}'.trim() != '')) ||
          domainType == OvcCasePlanConstant.householdCategorizationSection) {
        try {
          List<String> hiddenFields = [
            OvcCasePlanConstant.casePlanToGapLinkage,
            OvcCasePlanConstant.casePlanDomainType
          ];
          List<FormSection> domainFormSections = formSections
              .where((FormSection formSection) => formSection.id == domainType)
              .toList();
          List<FormSection> domainGapFormSections = widget.isHouseholdCasePlan
              ? OvcHouseholdServicesCasePlanGaps.getFormSections(
                  firstDate: '',
                ).where((FormSection formSection) => formSection.id == domainType).toList()
              : OvcServicesChildCasePlanGap.getFormSections(firstDate: '')
                  .where((FormSection formSection) => formSection.id == domainType)
                  .toList();
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            widget.isHouseholdCasePlan
                ? OvcHouseholdCasePlanConstant.program
                : OvcChildCasePlanConstant.program,
            widget.isHouseholdCasePlan
                ? OvcHouseholdCasePlanConstant.casePlanProgramStage
                : OvcChildCasePlanConstant.casePlanProgramStage,
            orgUnit,
            domainFormSections,
            domainDataObject,
            eventDate,
            beneficiary.trackedEntityInstance,
            domainDataObject['eventId'],
            hiddenFields,
          );
          hiddenFields = [
            OvcCasePlanConstant.casePlanToGapLinkage,
            OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
            OvcCasePlanConstant.casePlanGapToMonitoringLinkage
          ];
          for (Map domainGapDataObject in domainDataObject['gaps']) {
            await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
              widget.isHouseholdCasePlan
                  ? OvcHouseholdCasePlanConstant.program
                  : OvcChildCasePlanConstant.program,
              widget.isHouseholdCasePlan
                  ? OvcHouseholdCasePlanConstant.casePlanGapProgramStage
                  : OvcChildCasePlanConstant.casePlanGapProgramStage,
              orgUnit,
              domainGapFormSections,
              domainGapDataObject,
              eventDate,
              beneficiary.trackedEntityInstance,
              domainGapDataObject['eventId'],
              hiddenFields,
            );
          }
        } catch (e) {
          //
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return SubPageAppBar(
              label: widget.casePlanLabel,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Consumer<LanguageTranslationState>(
          builder: (context, languageTranslationState, child) {
            String? currentLanguage = languageTranslationState.currentLanguage;
            return Consumer<OvcHouseholdCurrentSelectionState>(
                builder: (context, ovcHouseholdCurrentSelectionState, child) {
              OvcHousehold? currentOvcHousehold =
                  ovcHouseholdCurrentSelectionState.currentOvcHousehold;
              OvcHouseholdChild? currentOvcHouseholdChild =
                  ovcHouseholdCurrentSelectionState.currentOvcHouseholdChild;
              int beneficairyAge = int.tryParse(widget.isHouseholdCasePlan
                      ? currentOvcHousehold!.age!
                      : currentOvcHouseholdChild!.age!) ??
                  0;
              return Consumer<ServiceFormState>(builder: (context, serviceFormState, child) {
                Map dataObject = serviceFormState.formState;
                return Container(
                  margin: const EdgeInsets.symmetric(),
                  child: _isFormNotReady
                      ? const CircularProcessLoader(
                          color: Colors.blueGrey,
                        )
                      : Column(
                          children: [
                            widget.isHouseholdCasePlan
                                ? OvcHouseholdInfoTopHeader(
                                    currentOvcHousehold: currentOvcHousehold,
                                  )
                                : const OvcChildInfoTopHeader(),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 13.0,
                              ),
                              child: Column(
                                children: formSections
                                    .where((formSection) => formSection.id == 'Schooled'
                                        ? beneficairyAge > 5
                                            ? true
                                            : false
                                        : true)
                                    .toList()
                                    .map(
                                      (formSection) => Container(
                                        margin: const EdgeInsets.symmetric(),
                                        child: CasePlanFormContainer(
                                          mandatoryFieldObject: mandatoryFieldObject,
                                          canAddDomainGaps: ![
                                            OvcCasePlanConstant.householdCategorizationSection,
                                            OvcCasePlanConstant.casePlanLocatinSectionId,
                                            OvcCasePlanConstant.casePlanEventDateSectionId
                                          ].contains(formSection.id),
                                          formSectionColor:
                                              borderColors[formSection.id] ?? Colors.transparent,
                                          formSection: formSection,
                                          isEditableMode: serviceFormState.isEditableMode,
                                          dataObject: dataObject[formSection.id] ?? {},
                                          onInputValueChange: (
                                            dynamic value,
                                          ) =>
                                              onInputValueChange(formSection.id, value),
                                          isHouseholdCasePlan: widget.isHouseholdCasePlan,
                                          hasEditAccessToCasePlan: widget.hasEditAccessToCasePlan,
                                          enrollmentOuAccessible: widget.enrollmentOuAccessible,
                                          isOnCasePlanPage: widget.isOnCasePlanPage,
                                          isOnCasePlanServiceProvision:
                                              widget.isOnCasePlanServiceProvision,
                                          isOnCasePlanServiceMonitoring:
                                              widget.isOnCasePlanServiceMonitoring,
                                        ),
                                      ),
                                    )
                                    .toList()
                                  ..add(
                                    Container(
                                      margin: const EdgeInsets.symmetric(),
                                      child: Visibility(
                                        visible: serviceFormState.isEditableMode,
                                        child: EntryFormSaveButton(
                                          label: _isSaving
                                              ? currentLanguage == 'lesotho'
                                                  ? 'E ntse e boloka...'
                                                  : 'Saving ...'
                                              : currentLanguage == 'lesotho'
                                                  ? 'Boloka'
                                                  : 'Save',
                                          labelColor: Colors.white,
                                          buttonColor: const Color(0xFF4B9F46),
                                          fontSize: 15.0,
                                          onPressButton: () => onSaveCasePlan(
                                            dataObject: serviceFormState.formState,
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
              });
            });
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
