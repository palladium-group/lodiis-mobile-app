import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/models/agyw_enrollment_consent.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/models/agyw_enrollment_form_section.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/models/agyw_enrollment_risk_assessment.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/skip_logics/agyw_dreams_enrollment_skip_logic.dart';
import 'package:provider/provider.dart';

class AgywDreamsEnrollmentViewForm extends StatefulWidget {
  const AgywDreamsEnrollmentViewForm({Key? key}) : super(key: key);

  @override
  State<AgywDreamsEnrollmentViewForm> createState() =>
      _AgywDreamsEnrollmentViewFormState();
}

class _AgywDreamsEnrollmentViewFormState
    extends State<AgywDreamsEnrollmentViewForm> {
  List<FormSection>? formSections;
  late List<FormSection> enrollmentFormSections;
  late List<FormSection> consentFormSections;
  late List<FormSection> riskAssessmentFormSections;
  final String label = 'Agyw Enrolment Form';
  final String translatedLabel = 'Formo ea ngoliso ea AGYW';
  bool isFormReady = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      consentFormSections = AgywEnrollmentConcent.getFormSections();
      formSections = consentFormSections.map((FormSection consentFormSection) {
        consentFormSection.name = 'Consent';
        List<InputField> inputFields = consentFormSection.inputFields!
            .where((InputField inputField) => inputField.id != 'location')
            .toList();
        consentFormSection.inputFields = inputFields;
        return consentFormSection;
      }).toList();
      enrollmentFormSections = AgywEnrollmentFormSection.getFormSections();
      riskAssessmentFormSections =
          AgywEnrollmentRiskAssessment.getFormSections();
      formSections!.addAll(riskAssessmentFormSections);
      formSections!.addAll(enrollmentFormSections);
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
        await AgywDreamsEnrollmentSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
        );
      },
    );
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
                translatedName: translatedLabel,
                activeInterventionProgram: activeInterventionProgram,
              );
            },
          ),
        ),
        body: SubPageBody(
          body: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 13.0),
            child: Container(
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
                  : Consumer<EnrollmentFormState>(
                      builder: (context, enrollmentFormState, child) => Column(
                        children: [
                          EntryFormContainer(
                            lastUpdatedId:
                                enrollmentFormState.lastUpdatedFieldId,
                            hiddenFields: enrollmentFormState.hiddenFields,
                            hiddenSections: enrollmentFormState.hiddenSections,
                            formSections: formSections,
                            mandatoryFieldObject: const {},
                            isEditableMode: enrollmentFormState.isEditableMode,
                            dataObject: enrollmentFormState.formState,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
        bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
      ),
    );
  }
}
