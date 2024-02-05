import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/models/dreams_service_prep_intake_form_info.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/prep/constants/prep_intake_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/prep/skip_logics/agyw_dreams_prep_skip_logic.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:provider/provider.dart';

class AgywDreamsPrepFormPageBody extends StatefulWidget {
  const AgywDreamsPrepFormPageBody({Key? key}) : super(key: key);

  @override
  State<AgywDreamsPrepFormPageBody> createState() =>
      _AgywDreamsPrepFormPageBodyState();
}

class _AgywDreamsPrepFormPageBodyState
    extends State<AgywDreamsPrepFormPageBody> {
  final String label = 'AGYW PrEP Intake Form';
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      formSections = DreamsServicePrepIntakeInfo.getFormSections();
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
        await AgywDreamsPrepSkipLogic.evaluateSkipLogics(
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
    if (FormUtil.geFormFilledStatus(dataObject, formSections)) {
      setState(() {
        isSaving = true;
      });
      String? eventDate = dataObject['eventDate'];
      String? eventId = dataObject['eventId'];
      List<String> hiddenFields = [];
      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            PrepIntakeConstant.program,
            PrepIntakeConstant.programStage,
            agywDream!.orgUnit,
            formSections!,
            dataObject,
            eventDate,
            agywDream.id,
            eventId,
            hiddenFields);
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
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
                                  top: 13.0,
                                  left: 13.0,
                                  right: 13.0,
                                ),
                                child: EntryFormContainer(
                                  hiddenFields: serviceFormState.hiddenFields,
                                  hiddenSections:
                                      serviceFormState.hiddenSections,
                                  formSections: formSections,
                                  mandatoryFieldObject: const {},
                                  isEditableMode:
                                      serviceFormState.isEditableMode,
                                  dataObject: serviceFormState.formState,
                                  onInputValueChange: onInputValueChange,
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
    );
  }
}
