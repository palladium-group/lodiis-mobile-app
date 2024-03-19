import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_service_well_being_assessment_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_wellbeing_assessment.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/skip_logics/ovc_child_well_being_assessment_skip_logic.dart';
import 'package:provider/provider.dart';

class OvcServiceWellBeingAssessmentForm extends StatefulWidget {
  const OvcServiceWellBeingAssessmentForm({Key? key}) : super(key: key);

  @override
  State<OvcServiceWellBeingAssessmentForm> createState() =>
      _OvcServiceWellBeingAssessmentFormState();
}

class _OvcServiceWellBeingAssessmentFormState
    extends State<OvcServiceWellBeingAssessmentForm> {
  final String label = 'Child Well-being Assessment';
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;
  Map mandatoryFieldObject = {};
  List<String> mandatoryFields = [];
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setFormSections();
  }

  void setFormSections() {
    mandatoryFields = [
      'eventDate',
      ...OvcServicesWellbeingAssessment.getMandatoryFields()
    ];
    OvcHouseholdChild? child =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild;
    formSections = OvcServicesWellbeingAssessment.getFormSections(
      firstDate: child!.createdDate!,
    );
    if (child.enrollmentOuAccessible! != true) {
      formSections = [
        AppUtil.getServiceProvisionLocationSection(
          inputColor: const Color(0xFF4B9F46),
          labelColor: const Color(0xFF1A3518),
          sectionLabelColor: const Color(0xFF1A3518),
          formlabel: 'Location',
          allowedSelectedLevels: [
            AppHierarchyReference.communityLevel,
          ],
          program: OvcInterventionConstant.ovcProgramprogram,
        ),
        ...formSections ?? []
      ];
      mandatoryFields.add('location');
    }
    for (String fieldId in mandatoryFields) {
      mandatoryFieldObject[fieldId] = true;
    }
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isFormReady = true;
        evaluateSkipLogics();
      });
    });
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        OvcHouseholdChild? child =
            Provider.of<OvcHouseholdCurrentSelectionState>(context,
                    listen: false)
                .currentOvcHouseholdChild;

        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await OvcChildWellBeingAssessmentSkipLogic.evaluateSkipLogics(
            context, formSections!, dataObject, child?.hivStatus);
      },
    );
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    OvcHouseholdChild? currentOvcHouseholdChild,
  ) async {
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields:
          Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections ?? [],
      ),
    );
    unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
      mandatoryFields,
      dataObject,
      hiddenFields:
          Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections ?? [],
      ),
    );
    setState(() {});
    if (hadAllMandatoryFilled) {
      if (dataObject['ADc3clrQRl4'] == null &&
          dataObject['efNgDIqhlNs'] == null) {
        AppUtil.showToastMessage(message: "Fill atleast one goal");
      } else {
        isSaving = true;
        setState(() {});
        String? eventDate = dataObject['eventDate'];
        String? eventId = dataObject['eventId'];
        String orgUnit =
            dataObject['location'] ?? currentOvcHouseholdChild?.orgUnit ?? '';
        List<String> skippedFields = [
          'Wstcittf',
        ];
        try {
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            OvcServiceWellBeingAssessmentConstant.program,
            OvcServiceWellBeingAssessmentConstant.programStage,
            orgUnit,
            formSections!,
            dataObject,
            eventDate,
            currentOvcHouseholdChild?.id ?? '',
            eventId,
            null,
            skippedFields: skippedFields,
          );
          Provider.of<ServiceEventDataState>(context, listen: false)
              .resetServiceEventDataState(currentOvcHouseholdChild?.id ?? '');
          Timer(const Duration(seconds: 1), () {
            String? currentLanguage =
                Provider.of<LanguageTranslationState>(context, listen: false)
                    .currentLanguage;
            AppUtil.showToastMessage(
              message: currentLanguage == 'lesotho'
                  ? 'Fomo e bolokeile'
                  : 'Form has been saved successfully',
              position: ToastGravity.TOP,
            );
            Navigator.pop(context);
          });
        } catch (e) {
          Timer(const Duration(seconds: 1), () {
            setState(() {
              isSaving = false;
              AppUtil.showToastMessage(
                  message: e.toString(), position: ToastGravity.BOTTOM);
              Navigator.pop(context);
            });
          });
        }
      }
    } else {
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
        position: ToastGravity.TOP,
      );
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
              label: label,
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
                OvcHouseholdChild? currentOvcHouseholdChild =
                    ovcHouseholdCurrentSelectionState.currentOvcHouseholdChild;
                return Consumer<ServiceFormState>(
                  builder: (context, serviceFormState, child) {
                    return Column(
                      children: [
                        const OvcChildInfoTopHeader(),
                        Container(
                          child: !isFormReady
                              ? const CircularProcessLoader(
                                  color: Colors.blueGrey,
                                )
                              : Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        top: 10.0,
                                        left: 13.0,
                                        right: 13.0,
                                      ),
                                      child: EntryFormContainer(
                                        hiddenSections:
                                            serviceFormState.hiddenSections,
                                        hiddenFields:
                                            serviceFormState.hiddenFields,
                                        hiddenInputFieldOptions:
                                            serviceFormState
                                                .hiddenInputFieldOptions,
                                        formSections: formSections,
                                        mandatoryFieldObject:
                                            mandatoryFieldObject,
                                        unFilledMandatoryFields:
                                            unFilledMandatoryFields,
                                        dataObject: serviceFormState.formState,
                                        isEditableMode:
                                            serviceFormState.isEditableMode,
                                        onInputValueChange: onInputValueChange,
                                      ),
                                    ),
                                    Visibility(
                                      visible: serviceFormState.isEditableMode,
                                      child: EntryFormSaveButton(
                                        label: isSaving
                                            ? currentLanguage == 'lesotho'
                                                ? 'E ntse e boloka...'
                                                : 'Saving ...'
                                            : currentLanguage == 'lesotho'
                                                ? 'Boloka'
                                                : 'Save',
                                        labelColor: Colors.white,
                                        buttonColor: const Color(0xFF4B9F46),
                                        fontSize: 15.0,
                                        onPressButton: () => onSaveForm(
                                            context,
                                            serviceFormState.formState,
                                            currentOvcHouseholdChild),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
