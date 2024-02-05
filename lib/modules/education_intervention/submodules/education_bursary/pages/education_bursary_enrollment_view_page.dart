import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/education_bursary_assessment_form.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/education_bursary_enrollment_form.dart';
import 'package:provider/provider.dart';

class EducationBursaryEnrollmentViewPage extends StatefulWidget {
  const EducationBursaryEnrollmentViewPage({Key? key}) : super(key: key);

  @override
  State<EducationBursaryEnrollmentViewPage> createState() =>
      _EducationBursaryEnrollmentViewPageState();
}

class _EducationBursaryEnrollmentViewPageState
    extends State<EducationBursaryEnrollmentViewPage> {
  final String label = 'Bursary Enrollment Form';

  final List<String> mandatoryFields =
      EducationBursaryEnrollmentForm.getMandatoryField();

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
      List<FormSection> assessmentFormSections =
          EducationBursaryAssessment.getFormSections();
      List<FormSection> enrollmentFormSections =
          EducationBursaryEnrollmentForm.getFormSections();
      formSections = assessmentFormSections + enrollmentFormSections;
      isFormReady = true;
    });
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
                              unFilledMandatoryFields: unFilledMandatoryFields,
                            ),
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
