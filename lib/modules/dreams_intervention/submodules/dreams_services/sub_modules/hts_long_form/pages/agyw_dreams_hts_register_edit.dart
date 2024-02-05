import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/models/hts_register.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/constants/agyw_dreams_hts_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/pages/agyw_dreams_hts_tb_screening.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/skip_logics/agyw_dreams_hts_register_skip_logic.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:provider/provider.dart';

class AgywDreamsHTSRegisterFormEdit extends StatefulWidget {
  const AgywDreamsHTSRegisterFormEdit({Key? key}) : super(key: key);

  @override
  State<AgywDreamsHTSRegisterFormEdit> createState() =>
      _AgywDreamsHTSRegisterFormEditState();
}

class _AgywDreamsHTSRegisterFormEditState
    extends State<AgywDreamsHTSRegisterFormEdit> {
  final String label = 'HTS Register';
  List<FormSection>? formSections;
  final List<String> mandatoryFields = HTSRegister.getMandatoryFields();
  final Map mandatoryFieldObject = {};
  bool isFormReady = false;
  bool isSaving = false;
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    formSections = HTSRegister.getFormSections();
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
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
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await AgywDreamsHTSRegisterSkipLogic.evaluateSkipLogics(
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

  void onSaveForm(
      BuildContext context, Map dataObject, AgywDream? agywDream) async {
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
    if (hadAllMandatoryFilled) {
      if (FormUtil.geFormFilledStatus(dataObject, formSections)) {
        isSaving = true;
        setState(() {});
        String? eventDate = dataObject['eventDate'];
        String? eventId = dataObject['eventId'];
        List<String> hiddenFields = [];
        try {
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            AgywDreamsHTSLongFormConstant.program,
            AgywDreamsHTSLongFormConstant.htsRegisterProgramStage,
            agywDream!.orgUnit,
            formSections!,
            dataObject,
            eventDate,
            agywDream.id,
            eventId,
            hiddenFields,
            skippedFields: [AgywDreamsHTSLongFormConstant.bmiKey],
          );
          Provider.of<ServiceEventDataState>(context, listen: false)
              .resetServiceEventDataState(agywDream.id);
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
              if (dataObject[AgywDreamsHTSLongFormConstant.hivResultStatus] ==
                  'Positive') {
                // reset event id and event date
                dataObject.remove('eventId');
                dataObject.remove('eventDate');

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgywDreamsHTSTBForm(
                            htsToTBLinkageValue: dataObject[
                                AgywDreamsHTSLongFormConstant
                                    .htsToTBLinkage])));
              } else {
                Navigator.pop(context);
              }
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
            position: ToastGravity.TOP);
      }
    } else {
      setState(() {
        unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
          mandatoryFields,
          dataObject,
          hiddenFields: Provider.of<ServiceFormState>(context, listen: false)
              .hiddenFields,
          checkBoxInputFields: FormUtil.getInputFieldByValueType(
            valueType: 'CHECK_BOX',
            formSections: formSections ?? [],
          ),
        );
      });
      AppUtil.showToastMessage(
          message: 'Please fill all mandatory field',
          position: ToastGravity.TOP);
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
            return Consumer<DreamsBeneficiarySelectionState>(
              builder: (context, nonAgywState, child) {
                AgywDream? agywDream = nonAgywState.currentAgywDream;
                return Consumer<ServiceFormState>(
                  builder: (context, serviceFormState, child) {
                    return Column(
                      children: [
                        DreamsBeneficiaryTopHeader(
                          agywDream: agywDream,
                        ),
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
                                      hiddenFields:
                                          serviceFormState.hiddenFields,
                                      hiddenSections:
                                          serviceFormState.hiddenSections,
                                      formSections: formSections,
                                      mandatoryFieldObject:
                                          mandatoryFieldObject,
                                      isEditableMode:
                                          serviceFormState.isEditableMode,
                                      dataObject: serviceFormState.formState,
                                      onInputValueChange: onInputValueChange,
                                      unFilledMandatoryFields:
                                          unFilledMandatoryFields,
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
                                      buttonColor: const Color(0xFF258DCC),
                                      fontSize: 15.0,
                                      onPressButton: () => onSaveForm(
                                        context,
                                        serviceFormState.formState,
                                        agywDream,
                                      ),
                                    ),
                                  )
                                ],
                              )
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
