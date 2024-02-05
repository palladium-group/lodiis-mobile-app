import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/models/non_agyw_hts_consent.dart';
import 'package:provider/provider.dart';
import 'non_agyw_dreams_hts_client_information.dart';

class NonAgywDreamsHTSConsentForm extends StatefulWidget {
  const NonAgywDreamsHTSConsentForm({Key? key, this.isComingFromPrep})
      : super(key: key);

  final bool? isComingFromPrep;

  @override
  State<NonAgywDreamsHTSConsentForm> createState() =>
      _NonAgywDreamsHTSConsentFormState();
}

class _NonAgywDreamsHTSConsentFormState
    extends State<NonAgywDreamsHTSConsentForm> {
  final String label = 'HTS Consent';
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;
  bool? isComingFromPrep;

  @override
  void initState() {
    super.initState();
    isComingFromPrep = widget.isComingFromPrep;
    formSections = NonAgywHTSConsent.getFormSections();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isFormReady = true;
      });
    });
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
  }) async {
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String beneficiaryId = "";
    String id = "${DreamsRoutesConstant.noneAgywHtsConsentPage}_$beneficiaryId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: DreamsRoutesConstant.noneAgywHtsConsentPage,
      nextPageModule: isSaveForm
          ? DreamsRoutesConstant.noneAgywHtsConsentNextPage
          : DreamsRoutesConstant.noneAgywHtsConsentPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState(id, value);
    onUpdateFormAutoSaveState(context);
  }

  bool isConsentGiven(Map dataObject) {
    List<String> consentFields = [
      'lDBdxPHndqZ',
      'ue9kOx3UeTa',
      'lYPlsVaINE2',
      'mv3oo5ZwG6E',
      't8qcja4SqOG',
      'nL0ybbExLV5',
      'm8AsVhFfJe2'
    ];

    return !consentFields.every((field) =>
        '${dataObject[field]}' == 'false' || '${dataObject[field]}' == 'null');
  }

  void onSaveForm(BuildContext context, Map dataObject) {
    if (isConsentGiven(dataObject)) {
      onUpdateFormAutoSaveState(context, isSaveForm: true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NonAgywDreamsHTSClientInformation(),
        ),
      );
    } else {
      AppUtil.showToastMessage(
        message: 'Cannot proceed without consent',
        position: ToastGravity.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;

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
            body: Consumer<EnrollmentFormState>(
              builder: (context, enrollmentFormState, child) {
                return Column(
                  children: [
                    !isFormReady
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
                                  formSections: formSections,
                                  mandatoryFieldObject: const {},
                                  isEditableMode:
                                      enrollmentFormState.isEditableMode,
                                  dataObject: enrollmentFormState.formState,
                                  onInputValueChange: onInputValueChange,
                                ),
                              ),
                              Visibility(
                                visible: enrollmentFormState.isEditableMode,
                                child: EntryFormSaveButton(
                                  label: isSaving
                                      ? currentLanguage == 'lesotho'
                                          ? 'E ntse e boloka...'
                                          : 'Saving ...'
                                      : 'Save and Continue',
                                  labelColor: Colors.white,
                                  buttonColor: const Color(0xFF258DCC),
                                  fontSize: 15.0,
                                  onPressButton: () => onSaveForm(
                                    context,
                                    enrollmentFormState.formState,
                                  ),
                                ),
                              )
                            ],
                          )
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
        );
      },
    );
  }
}
