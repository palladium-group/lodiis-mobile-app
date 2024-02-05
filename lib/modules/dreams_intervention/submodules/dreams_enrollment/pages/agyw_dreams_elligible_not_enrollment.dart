import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/services/agyw_dreams_eligible_not_enrollment.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/models/agyw_elligible_not_enrollment.dart';
import 'package:provider/provider.dart';

class AgywEligibleNotEnrollmentForm extends StatefulWidget {
  const AgywEligibleNotEnrollmentForm({Key? key}) : super(key: key);

  @override
  State<AgywEligibleNotEnrollmentForm> createState() =>
      _AgywEnrollmentNoneParticipationFormState();
}

class _AgywEnrollmentNoneParticipationFormState
    extends State<AgywEligibleNotEnrollmentForm> {
  List<FormSection>? formSections;
  final String label = 'Eligible Not Enrollment';
  final List<String> mandatoryFields =
      AgywElligibleNotEnrollment.getMandatoryField();
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
      formSections = AgywElligibleNotEnrollment.getFormSections();
      isFormReady = true;
    });
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
  }) async {
    String beneficiaryId = "";
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String id = "${DreamsRoutesConstant.agywConsentPage}_$beneficiaryId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: DreamsRoutesConstant.agywNoneParticipationPage,
      nextPageModule: isSaveForm
          ? DreamsRoutesConstant.agywNoneParticipationNextPage
          : DreamsRoutesConstant.agywNoneParticipationPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void clearFormAutoSaveState(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywConsentPage}_$beneficiaryId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState(id, value);
    autoFillInputFields(id, value);
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
      String eventId = dataObject['eventId'] ?? AppUtil.getUid();
      await AgywDreamsEligibleNotEnrollmentService()
          .saveEnrolledNotEligibleForm(formSections!, dataObject, eventId);
      Provider.of<DreamsInterventionListState>(context, listen: false)
          .refreshAllDreamsLists();
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
          clearFormAutoSaveState(context);
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

  void autoFillInputFields(String id, dynamic value) {
    if (id == 'qZP982qpSPS') {
      int age = AppUtil.getAgeInYear(value);
      Provider.of<EnrollmentFormState>(context, listen: false)
          .setFormFieldState('ls9hlz2tyol', age.toString());
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
                        builder: (context, enrollmentFormState, child) =>
                            Column(
                          children: [
                            EntryFormContainer(
                              formSections: formSections,
                              isEditableMode:
                                  enrollmentFormState.isEditableMode,
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
                                buttonColor: const Color(0xFF258DCC),
                                fontSize: 15.0,
                                onPressButton: () => isSaving
                                    ? null
                                    : onSaveAndContinue(
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
      ),
    );
  }
}
