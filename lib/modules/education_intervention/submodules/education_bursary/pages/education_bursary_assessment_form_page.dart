import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/beneficiary_without_enrollment_criteria.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/constants/bursary_routes_constant.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/education_bursary_assessment_form.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/pages/education_bursary_enrollment_form_page.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/pages/education_bursary_without_enrollment_criteria_form_page.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/skip_logics/education_bursary_enrollment_skip_logic.dart';
import 'package:provider/provider.dart';

class EducationBursaryAssessmentFormPage extends StatefulWidget {
  const EducationBursaryAssessmentFormPage({Key? key}) : super(key: key);

  @override
  State<EducationBursaryAssessmentFormPage> createState() =>
      _EducationBursaryAssessmentFormPageState();
}

class _EducationBursaryAssessmentFormPageState
    extends State<EducationBursaryAssessmentFormPage> {
  final String label = 'Bursary Assessment Form';
  final String translatedName = 'Foromo ea Tlhahlobo ea Lihlapiso';

  final List<String> mandatoryFields =
      EducationBursaryAssessment.getMandatoryField();
  final Map mandatoryFieldObject = {};
  List<FormSection>? formSections;
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
      formSections = EducationBursaryAssessment.getFormSections();
      isFormReady = true;
      evaluateSkipLogics();
    });
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<EnrollmentFormState>(context, listen: false).formState;
        await EducationBursaryEnrollmentSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
        );
      },
    );
  }

  void onUpdateFormAutoSaveState(BuildContext context,
      {bool isSaveForm = false}) async {
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String beneficiaryId = dataObject['trackedEntityInstance'] ?? '';
    String id = '${BursaryRoutesConstant.assessmentPageModule}_$beneficiaryId';
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: BursaryRoutesConstant.assessmentPageModule,
      nextPageModule: isSaveForm
          ? BursaryRoutesConstant.assessmentNextPageModule
          : BursaryRoutesConstant.assessmentPageModule,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
  }

  void onSaveAndContinue(BuildContext context, Map dataObject) async {
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
      setState(() {
        isSaving = true;
      });
      onUpdateFormAutoSaveState(context, isSaveForm: true);
      setState(() {
        isSaving = false;
      });
      List<FormSection> vulnerabilityCriteriaSections = formSections!
          .where((section) => section.id == 'vulnerability_criteria')
          .toList();
      List<String> vulnerabilityCriteria =
          FormUtil.getFormFieldIds(vulnerabilityCriteriaSections);
      bool beneficiaryMetVulnerabilityCriteria = false;
      for (String criteria in vulnerabilityCriteria) {
        if ('${dataObject[criteria]}' == 'true') {
          beneficiaryMetVulnerabilityCriteria = true;
        }
      }
      if (!beneficiaryMetVulnerabilityCriteria) {
        final List<BeneficiaryWithoutEnrollmentCriteriaConstant>
            beneficiaryWithoutEnrollmentConstants =
            BeneficiaryWithoutEnrollmentCriteriaConstant
                .getDreamsWithoutEnrollmentCriteriaConstants();
        for (BeneficiaryWithoutEnrollmentCriteriaConstant beneficiaryConstant
            in beneficiaryWithoutEnrollmentConstants) {
          String dataElement = beneficiaryConstant.dataElement;
          String attribute = beneficiaryConstant.attribute;
          if (dataObject.keys.toList().contains(attribute)) {
            Provider.of<EnrollmentFormState>(context, listen: false)
                .setFormFieldState(dataElement, dataObject[attribute]);
          }
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return beneficiaryMetVulnerabilityCriteria
                ? const EducationBursaryEnrollmentFormPage()
                : const EducationBursaryWithoutVulnerabilityCriteriaFormPage();
          },
        ),
      );
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
          message: 'Please fill all mandatory fields',
          position: ToastGravity.TOP);
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
                translatedName: translatedName,
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
                        builder: (context, enrollmentFormState, child) =>
                            Column(
                          children: [
                            EntryFormContainer(
                              isEditableMode:
                                  enrollmentFormState.isEditableMode,
                              hiddenFields: enrollmentFormState.hiddenFields,
                              hiddenSections:
                                  enrollmentFormState.hiddenSections,
                              formSections: formSections,
                              mandatoryFieldObject: mandatoryFieldObject,
                              hiddenInputFieldOptions:
                                  enrollmentFormState.hiddenInputFieldOptions,
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
                                        : 'Save and Continue',
                                labelColor: Colors.white,
                                buttonColor: const Color(0xFF009688),
                                fontSize: 15.0,
                                onPressButton: () => !isSaving
                                    ? onSaveAndContinue(
                                        context,
                                        enrollmentFormState.formState,
                                      )
                                    : null,
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
      ),
    );
  }
}
