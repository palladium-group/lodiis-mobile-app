import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/constant/non_agyw_dreams_hts_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/models/non_agyw_hts_client_information.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/models/non_agyw_hts_consent.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/models/non_agyw_hts_register.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/skip_logics/none_agyw_enrollment_skip_logic.dart';
import 'package:provider/provider.dart';
import '../models/none_agyw_enrollment_prep_screening.dart';

class NoneAgywEnrollmentViewForm extends StatefulWidget {
  const NoneAgywEnrollmentViewForm({Key? key}) : super(key: key);

  @override
  State<NoneAgywEnrollmentViewForm> createState() =>
      _NoneAgywEnrollmentViewFormState();
}

class _NoneAgywEnrollmentViewFormState
    extends State<NoneAgywEnrollmentViewForm> {
  List<FormSection>? formSections;
  late List<FormSection> prepScreeningFormSections;
  late List<FormSection> htsConsentFormSections;
  late List<FormSection> htsClientInformationFormSections;
  late List<FormSection> htsRegisterFormSections;

  final String label = 'None Agyw Enrolment Form';
  bool isFormReady = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      formSections = [];
      htsConsentFormSections = NonAgywHTSConsent.getFormSections();
      htsClientInformationFormSections =
          NonAgywHTSClientInformation.getFormSections();
      htsRegisterFormSections = NonAgywHTSRegister.getFormSections();
      formSections!.addAll(htsConsentFormSections);
      formSections!.addAll(htsClientInformationFormSections);
      formSections!.addAll(htsRegisterFormSections);
      if (isBeneficiaryHIVNegative()) {
        prepScreeningFormSections =
            NoneAgywEnrollmentPrepScreening.getFormSections();
        formSections!.addAll(prepScreeningFormSections);
      }
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
        await NoneAgywEnrollmentSkipLogic.evaluateSkipLogics(
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
                    activeInterventionProgram: activeInterventionProgram,
                  );
                },
              ),
            ),
            body: SubPageBody(
              body: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 13.0),
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
                          builder: (context, enrollmentFormState, child) =>
                              Column(
                            children: [
                              EntryFormContainer(
                                hiddenFields: enrollmentFormState.hiddenFields,
                                hiddenSections:
                                    enrollmentFormState.hiddenSections,
                                formSections: formSections,
                                mandatoryFieldObject: const {},
                                isEditableMode:
                                    enrollmentFormState.isEditableMode,
                                dataObject: enrollmentFormState.formState,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            bottomNavigationBar:
                const InterventionBottomNavigationBarContainer()));
  }

  bool isBeneficiaryHIVNegative() {
    bool isBeneficiaryNegative = false;
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    if (dataObject[NonAgywDreamsHTSConstant.hivResultStatus] == 'Negative') {
      isBeneficiaryNegative = true;
    }
    return isBeneficiaryNegative;
  }
}
