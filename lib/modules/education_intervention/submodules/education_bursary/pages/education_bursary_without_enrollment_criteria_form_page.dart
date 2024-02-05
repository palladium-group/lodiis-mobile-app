import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_bursary_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/constants/bursary_routes_constant.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/education_bursary_without_vulnerability_criteria_form.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/services/education_bursary_enrollment_service.dart';
import 'package:provider/provider.dart';

class EducationBursaryWithoutVulnerabilityCriteriaFormPage
    extends StatefulWidget {
  const EducationBursaryWithoutVulnerabilityCriteriaFormPage({Key? key})
      : super(key: key);

  @override
  State<EducationBursaryWithoutVulnerabilityCriteriaFormPage> createState() =>
      _EducationBursaryWithoutVulnerabilityCriteriaFormPageState();
}

class _EducationBursaryWithoutVulnerabilityCriteriaFormPageState
    extends State<EducationBursaryWithoutVulnerabilityCriteriaFormPage> {
  List<FormSection>? formSections;
  final String label = 'Bursary without vulnerability criteria';
  final List<String> mandatoryFields =
      EducationBursaryWithoutVulnerabilityCriteriaForm.getMandatoryField();
  final Map mandatoryFieldObject = {};

  bool isSaving = false;
  bool isFormReady = false;
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      for (String id in mandatoryFields) {
        mandatoryFieldObject[id] = true;
      }
      formSections =
          EducationBursaryWithoutVulnerabilityCriteriaForm.getFormSections();
      isFormReady = true;
    });
  }

  void clearFormAutoSaveState(BuildContext context) async {
    String beneficiaryId = '';
    String formAutoSaveId =
        '${BursaryRoutesConstant.assessmentPageModule}_$beneficiaryId';
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState(id, value);
    autoFillInputFields(id, value);
    onUpdateFormAutoSaveState(context);
  }

  void autoFillInputFields(String id, dynamic value) {
    if (id == 'jVSwC6Ln95H') {
      int age = AppUtil.getAgeInYear(value);
      Provider.of<EnrollmentFormState>(context, listen: false)
          .setFormFieldState('mZs1YsN56cR', age.toString());
    }
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
  }) async {
    String beneficiaryId = '';
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String id = '${BursaryRoutesConstant.assessmentPageModule}_$beneficiaryId';
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule:
          BursaryRoutesConstant.bursaryWithoutVulnerabilityCriteriaPageModule,
      nextPageModule: isSaveForm
          ? BursaryRoutesConstant
              .bursaryWithoutVulnerabilityCriteriaNextPageModule
          : BursaryRoutesConstant.bursaryWithoutVulnerabilityCriteriaPageModule,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void onSave(BuildContext context, Map dataObject) async {
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields:
          Provider.of<EnrollmentFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections ?? [],
      ),
    );
    if (hadAllMandatoryFilled) {
      isSaving = true;
      setState(() {});
      String eventId = dataObject['eventId'] ?? AppUtil.getUid();
      await EducationBursaryEnrollmentService()
          .saveBursaryWithoutVulnerabilityCriteria(
              formSections!, dataObject, eventId);
      Provider.of<EducationBursaryInterventionState>(context, listen: false)
          .refreshAllEducationBursaryLists();
      clearFormAutoSaveState(context);
      Timer(const Duration(seconds: 1), () {
        if (Navigator.canPop(context)) {
          setState(() {
            isSaving = false;
          });
          String? currentLanguage =
              Provider.of<LanguageTranslationState>(context, listen: false)
                  .currentLanguage;
          AppUtil.showToastMessage(
            message: currentLanguage == 'lesotho'
                ? 'Fomo e bolokeile'
                : 'Form has been saved successfully',
            position: ToastGravity.TOP,
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      });
    } else {
      setState(() {
        unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
          mandatoryFields,
          dataObject,
          hiddenFields: Provider.of<EnrollmentFormState>(context, listen: false)
              .hiddenFields,
          checkBoxInputFields: FormUtil.getInputFieldByValueType(
            valueType: 'CHECK_BOX',
            formSections: formSections ?? [],
          ),
        );
      });
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory field',
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
                    return Consumer<EnrollmentFormState>(
                      builder: (context, enrollmentFormState, child) => Column(
                        children: [
                          EntryFormContainer(
                            isEditableMode: enrollmentFormState.isEditableMode,
                            formSections: formSections,
                            mandatoryFieldObject: mandatoryFieldObject,
                            dataObject: enrollmentFormState.formState,
                            onInputValueChange: onInputValueChange,
                            unFilledMandatoryFields: unFilledMandatoryFields,
                          ),
                          Visibility(
                            visible: enrollmentFormState.isEditableMode,
                            child: EntryFormSaveButton(
                              label: isSaving
                                  ? currentLanguage == 'lesotho'
                                      ? 'E ntse e boloka...'
                                      : 'Saving ...'
                                  : currentLanguage == 'lesotho'
                                      ? 'Boloka'
                                      : 'Save',
                              labelColor: Colors.white,
                              buttonColor: const Color(0xFF009688),
                              fontSize: 15.0,
                              onPressButton: () => isSaving
                                  ? null
                                  : onSave(
                                      context,
                                      enrollmentFormState.formState,
                                    ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    ));
  }
}
