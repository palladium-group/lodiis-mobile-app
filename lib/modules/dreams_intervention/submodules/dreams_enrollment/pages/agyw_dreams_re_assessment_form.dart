import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_re_assessment_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_enrollment_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_re_assessment_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/services/agyw_dreams_enrollment_service.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/models/agyw_re_assessment.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/skip_logics/agyw_dreams_re_assessment_skip_logic.dart';
import 'package:provider/provider.dart';

class AgywDreamsReAssessmentForm extends StatefulWidget {
  const AgywDreamsReAssessmentForm({Key? key}) : super(key: key);

  @override
  State<AgywDreamsReAssessmentForm> createState() =>
      _AgywDreamsReAssessmentFormState();
}

class _AgywDreamsReAssessmentFormState
    extends State<AgywDreamsReAssessmentForm> {
  List<FormSection>? formSections;
  final String label = 'Re-assessment and Re-enrollment form';
  final List<String> mandatoryFields = AgywReAssessment.getMandatoryFields();
  final Map mandatoryFieldObject = {};
  bool isFormReady = false;
  bool isSaving = false;
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      for (String id in mandatoryFields) {
        mandatoryFieldObject[id] = true;
      }
      formSections = AgywReAssessment.getFormSections();
      isFormReady = true;
      evaluateSkipLogics();
    });
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await AgywDreamsReAssessmentSkipLogic.evaluateSkipLogic(
          context,
          formSections!,
          dataObject,
        );
      },
    );
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
  }

  String getReAssessmentAgeBand(AgywDream agywDream) {
    var age = int.parse(agywDream.age ?? '0');

    return age >= 10 && age <= 14
        ? '10-14'
        : age >= 15 && age <= 19
            ? '15-19'
            : age >= 20 && age <= 24
                ? '20-24'
                : '';
  }

  void onSaveForm(
    BuildContext context,
    AgywDream agywDream,
    Map dataObject, {
    Map hiddenFields = const {},
  }) async {
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections ?? [],
      ),
    );
    if (hadAllMandatoryFilled) {
      if (FormUtil.geFormFilledStatus(dataObject, formSections)) {
        isSaving = true;
        setState(() {});
        String? eventDate = dataObject['eventDate'];
        String? eventId = dataObject['eventId'];
        List<String> hiddenFields = [];
        String orgUnit = dataObject['location'] ?? agywDream.orgUnit;
        orgUnit = orgUnit.isEmpty ? agywDream.orgUnit ?? '' : orgUnit;
        try {
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            AgywDreamsEnrollmentConstant.program,
            AgywDreamReAssessmentConstants.programStage,
            orgUnit,
            formSections!,
            dataObject,
            eventDate,
            agywDream.id,
            eventId,
            hiddenFields,
          );
          await AgywDreamsEnrollmentService().updateReAssessedAgywBeneficiary(
            {
              AgywDreamsEnrollmentConstant.reAssessmentCriteriaId:
                  getReAssessmentAgeBand(agywDream)
            },
            agywDream.id,
            agywDream.orgUnit,
            [AgywDreamsEnrollmentConstant.reAssessmentCriteriaId],
          );
          Provider.of<ServiceEventDataState>(context, listen: false)
              .resetServiceEventDataState(agywDream.id);
          Provider.of<DreamsRaAssessmentListState>(context, listen: false)
              .refreshBeneficiariesNumber();
          Timer(const Duration(seconds: 1), () {
            setState(() {
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
          });
        } catch (e) {
          Timer(const Duration(seconds: 1), () {
            setState(() {
              AppUtil.showToastMessage(
                  message: e.toString(), position: ToastGravity.BOTTOM);
            });
          });
        }
      } else {
        AppUtil.showToastMessage(
          message: 'Please fill at least one form field',
          position: ToastGravity.TOP,
        );
      }
    } else {
      setState(() {
        unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
          mandatoryFields,
          dataObject,
          hiddenFields: hiddenFields,
          checkBoxInputFields: FormUtil.getInputFieldByValueType(
            valueType: 'CHECK_BOX',
            formSections: formSections ?? [],
          ),
        );
      });
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
        position: ToastGravity.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          body: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 13.0,
            ),
            child: !isFormReady
                ? const Column(
                    children: [
                      Center(
                        child: CircularProcessLoader(
                          color: Colors.blueGrey,
                        ),
                      )
                    ],
                  )
                : Consumer<LanguageTranslationState>(
                    builder: (context, languageTranslationState, child) {
                      String? currentLanguage =
                          languageTranslationState.currentLanguage;
                      return Consumer<DreamsBeneficiarySelectionState>(
                        builder:
                            (context, dreamsBeneficiarySelectionState, child) {
                          AgywDream? agywDream =
                              dreamsBeneficiarySelectionState.currentAgywDream;
                          return Consumer<ServiceFormState>(
                              builder: (context, serviceFormState, child) =>
                                  Column(
                                    children: [
                                      EntryFormContainer(
                                        hiddenFields:
                                            serviceFormState.hiddenFields,
                                        hiddenSections:
                                            serviceFormState.hiddenSections,
                                        formSections: formSections,
                                        mandatoryFieldObject:
                                            mandatoryFieldObject,
                                        dataObject: serviceFormState.formState,
                                        onInputValueChange: onInputValueChange,
                                        unFilledMandatoryFields:
                                            unFilledMandatoryFields,
                                      ),
                                      EntryFormSaveButton(
                                        label: isSaving
                                            ? currentLanguage == 'lesotho'
                                                ? 'E ntse e boloka...'
                                                : 'Saving ...'
                                            : currentLanguage == 'lesotho'
                                                ? 'Boloka'
                                                : 'Save',
                                        labelColor: Colors.white,
                                        buttonColor: const Color(0xFF258DCC),
                                        fontSize: 15.0,
                                        onPressButton: () => onSaveForm(
                                          context,
                                          agywDream!,
                                          serviceFormState.formState,
                                          hiddenFields:
                                              serviceFormState.hiddenFields,
                                        ),
                                      )
                                    ],
                                  ));
                        },
                      );
                    },
                  ),
          ),
        ),
        bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
      ),
    );
  }
}
