import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/skip_logics/ovc_case_closure_skip_logic.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/skip_logics/ovc_case_exit_skip_logic.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/skip_logics/ovc_case_transfer_skip_logic.dart';
import 'package:provider/provider.dart';

class OvcHouseholdExitFormContainer extends StatefulWidget {
  const OvcHouseholdExitFormContainer({
    Key? key,
    required this.event,
    required this.formSections,
    required this.isSaving,
    required this.exitType,
    this.mandatoryFieldObject = const {},
    this.unFilledMandatoryFields = const [],
    this.onSaveForm,
  }) : super(key: key);

  final String exitType;
  final Events? event;
  final List<FormSection>? formSections;
  final Map mandatoryFieldObject;
  final List unFilledMandatoryFields;
  final bool isSaving;
  final Function? onSaveForm;

  @override
  State<OvcHouseholdExitFormContainer> createState() =>
      _OvcHouseholdExitFormContainerState();
}

class _OvcHouseholdExitFormContainerState
    extends State<OvcHouseholdExitFormContainer>
    with
        OvcCaseClosureSkipLogic,
        OvcCaseExitSkipLogic,
        OvcCaseTransferSkipLogic {
  bool isFormReady = false;

  @override
  void initState() {
    super.initState();
    if (!isFormReady) {
      Timer(const Duration(seconds: 1), () {
        bool isEditableMode = widget.event == null;
        updateFormState(context, isEditableMode, widget.event);
        setState(() {
          isFormReady = true;
          evaluateSkipLogics();
        });
      });
    }
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;

        if (widget.exitType == 'closure') {
          await evaluateCaseClosureSkipLogics(
            context,
            widget.formSections!,
            dataObject,
          );
        }
        if (widget.exitType == 'exit') {
          await evaluateCaseExitSkipLogics(
            context,
            widget.formSections!,
            dataObject,
          );
        }
        if (widget.exitType == 'transfer') {
          await evaluateCaseTransferSkipLogics(
            context,
            widget.formSections!,
            dataObject,
          );
        }
      },
    );
  }

  void onEditForm() {
    bool isEditableMode = true;
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
  }

  void updateFormState(
    BuildContext context,
    bool isEditableMode,
    Events? event,
  ) {
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    if (event != null) {
      Provider.of<ServiceFormState>(context, listen: false);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventDate', event.eventDate);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventId', event.event);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('location', event.orgUnit);
      for (Map dataValue in event.dataValues) {
        if (dataValue['value'] != '') {
          Provider.of<ServiceFormState>(context, listen: false)
              .setFormFieldState(dataValue['dataElement'], dataValue['value']);
        }
      }
    }
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    var ovc =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold!;
    String? beneficiaryId = ovc.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    if (dataObject['eventId'] == null) {
      String eventId = '';
      String currentPage = widget.exitType == 'exit'
          ? OvcRoutesConstant.householdExitFormPage
          : widget.exitType == 'transfer'
              ? OvcRoutesConstant.householdTransferFormPage
              : widget.exitType == 'closure'
                  ? OvcRoutesConstant.householdClosureFormPage
                  : '';
      String nextPage = widget.exitType == 'exit'
          ? OvcRoutesConstant.householdExitFormNextPage
          : widget.exitType == 'transfer'
              ? OvcRoutesConstant.householdTransferFormNextPage
              : widget.exitType == 'closure'
                  ? OvcRoutesConstant.householdClosureFormNextPage
                  : '';
      String id = "${currentPage}_${beneficiaryId}_$eventId";
      FormAutoSave formAutoSave = FormAutoSave(
        id: id,
        beneficiaryId: beneficiaryId,
        pageModule: currentPage,
        nextPageModule: isSaveForm
            ? nextPageModule != ""
                ? nextPageModule
                : nextPage
            : currentPage,
        data: jsonEncode(dataObject),
      );
      await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
    }
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
  }

  @override
  Widget build(BuildContext context) {
    return !isFormReady
        ? const CircularProcessLoader(
            color: Colors.blueGrey,
          )
        : Container(
            margin:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 13.0),
            child: Consumer<LanguageTranslationState>(
              builder: (context, languageTranslationState, child) {
                String? currentLanguage =
                    languageTranslationState.currentLanguage;
                return Consumer<ServiceFormState>(
                  builder: (context, serviceFormState, child) {
                    return Column(
                      children: [
                        MaterialCard(
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topRight,
                                child:
                                    Consumer<OvcHouseholdCurrentSelectionState>(
                                  builder: (context, state, child) {
                                    var currentHousehold =
                                        state.currentOvcHousehold;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Visibility(
                                        visible:
                                            !serviceFormState.isEditableMode &&
                                                widget.event!
                                                    .enrollmentOuAccessible! &&
                                                (widget.exitType == 'closure' ||
                                                    currentHousehold
                                                            ?.hasExitedProgram !=
                                                        true),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: const Color(0xFF4B9F46)
                                                    .withOpacity(0.3),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            padding: const EdgeInsets.all(5.0),
                                          ),
                                          onPressed: () => onEditForm(),
                                          child: Text(
                                            'Update',
                                            style: const TextStyle().copyWith(
                                              color: const Color(0xFF4B9F46),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              EntryFormContainer(
                                elevation: 0.0,
                                hiddenFields: serviceFormState.hiddenFields,
                                hiddenSections: serviceFormState.hiddenSections,
                                formSections: widget.formSections,
                                mandatoryFieldObject:
                                    widget.mandatoryFieldObject,
                                unFilledMandatoryFields:
                                    widget.unFilledMandatoryFields,
                                dataObject: serviceFormState.formState,
                                isEditableMode: serviceFormState.isEditableMode,
                                onInputValueChange: onInputValueChange,
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: serviceFormState.isEditableMode,
                          child: EntryFormSaveButton(
                            label: widget.isSaving
                                ? currentLanguage == 'lesotho'
                                    ? 'E ntse e boloka...'
                                    : 'Saving ...'
                                : currentLanguage == 'lesotho'
                                    ? 'Boloka'
                                    : 'Save',
                            labelColor: Colors.white,
                            buttonColor: const Color(0xFF4B9F46),
                            fontSize: 15.0,
                            onPressButton: () {
                              widget.onSaveForm!(serviceFormState.formState);
                            },
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          );
  }
}
