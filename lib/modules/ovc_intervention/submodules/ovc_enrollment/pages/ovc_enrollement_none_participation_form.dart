import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
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
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_enrollment_none_participation_service.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/models/ovc_enrollement_none_participation.dart';
import 'package:provider/provider.dart';

class OvcEnrollmentNoneParticipationForm extends StatefulWidget {
  const OvcEnrollmentNoneParticipationForm({Key? key}) : super(key: key);

  @override
  State<OvcEnrollmentNoneParticipationForm> createState() =>
      _OvcEnrollmentNoneParticipationFormState();
}

class _OvcEnrollmentNoneParticipationFormState
    extends State<OvcEnrollmentNoneParticipationForm> {
  List<FormSection>? formSections;
  final String label = 'None Participation Form';
  final List<String> mandatoryFields =
      OvcEnrollmentNoneParticipation.getMandatoryField();
  final Map mandatoryFieldObject = {};

  List unFilledMandatoryFields = [];

  bool isSaving = false;
  bool isFormReady = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      for (String id in mandatoryFields) {
        mandatoryFieldObject[id] = true;
      }
      formSections = OvcEnrollmentNoneParticipation.getFormSections();
      isFormReady = true;
    });
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
      isSaving = true;
      setState(() {});
      String eventId = dataObject['eventId'] ?? AppUtil.getUid();
      await OvcEnrollmentNoneParticipationService()
          .saveNoneParticipationForm(formSections!, dataObject, eventId);
      Provider.of<OvcInterventionListState>(context, listen: false)
          .onNoneParticipantAdd();
      Provider.of<OvcInterventionListState>(context, listen: false)
          .refreshOvcList();
      clearFormAutoSaveState(context);
      Timer(const Duration(seconds: 1), () {
        if (Navigator.canPop(context)) {
          isSaving = false;
          String? currentLanguage =
              Provider.of<LanguageTranslationState>(context, listen: false)
                  .currentLanguage;
          AppUtil.showToastMessage(
            message: currentLanguage == 'lesotho'
                ? 'Fomo e bolokeile'
                : 'Form has been saved successfully',
            position: ToastGravity.TOP,
          );
          setState(() {});
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      });
    } else {
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
      setState(() {});
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
        position: ToastGravity.TOP,
      );
    }
  }

  void clearFormAutoSaveState(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId =
        "${OvcRoutesConstant.ovcConcentFormPage}_$beneficiaryId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    String beneficiaryId = "";
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String id = "${OvcRoutesConstant.ovcConcentFormPage}_$beneficiaryId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: OvcRoutesConstant.ovcNoneParticipationFormPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : OvcRoutesConstant.ovcNoneParticipationFormNextPage
          : OvcRoutesConstant.ovcNoneParticipationFormNextPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
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
                        builder: (context, enrollmentFormState, child) {
                          return Column(
                            children: [
                              EntryFormContainer(
                                isEditableMode:
                                    enrollmentFormState.isEditableMode,
                                formSections: formSections,
                                mandatoryFieldObject: mandatoryFieldObject,
                                dataObject: enrollmentFormState.formState,
                                onInputValueChange: onInputValueChange,
                                unFilledMandatoryFields:
                                    unFilledMandatoryFields,
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
                                  buttonColor: const Color(0xFF4B9F46),
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
                          );
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
