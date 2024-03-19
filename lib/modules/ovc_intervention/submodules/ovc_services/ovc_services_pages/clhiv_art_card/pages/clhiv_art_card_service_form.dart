import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_clhiv_art_service.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/clhiv_art_card/constants/clhiv_art_card_constants.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/clhiv_art_card/skip_logics/clhiv_art_card_service_skip_logics.dart';
import 'package:provider/provider.dart';

class ClhivArtCardServiceForm extends StatefulWidget {
  const ClhivArtCardServiceForm({Key? key}) : super(key: key);

  @override
  State<ClhivArtCardServiceForm> createState() =>
      _ClhivArtCardServiceFormState();
}

class _ClhivArtCardServiceFormState extends State<ClhivArtCardServiceForm> {
  final String header = 'CLHIV ART Card Service Form';
  List<FormSection>? formSections;
  List<FormSection>? defaultFormSections;
  bool isFormReady = false;
  bool isSaving = false;
  Map mandatoryFieldObject = {};
  List<String> mandatoryFields = [];
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setFormSections();
  }

  void evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await ClhivArtCardServiceSkipLogics.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
        );
      },
    );
  }

  void setFormSections() {
    var defaultFormSections = OvcClhivArtService.getFormSections();
    mandatoryFields = OvcClhivArtService.getMandatoryFields();
    var currentOvc =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild;

    if (currentOvc?.enrollmentOuAccessible == true) {
      formSections = defaultFormSections;
    } else {
      FormSection serviceProvisionForm =
          AppUtil.getServiceProvisionLocationSection(
        inputColor: const Color(0xFF4B9F46),
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: const Color(0xFF1A3518),
        allowedSelectedLevels: [
          AppHierarchyReference.communityLevel,
        ],
        program: OvcInterventionConstant.ovcProgramprogram,
      );
      formSections = [
        serviceProvisionForm,
        ...defaultFormSections,
      ];
      mandatoryFields = [
        ...mandatoryFields,
        ...FormUtil.getFormFieldIds(
          [serviceProvisionForm],
          includeLocationId: true,
        )
      ];
    }
    for (String fieldId in mandatoryFields) {
      mandatoryFieldObject[fieldId] = true;
    }
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isFormReady = true;
        evaluateSkipLogics();
      });
    });
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
  }

  void onUpdateFormAutoSaveState(BuildContext context) async {
    var currentOvc =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild!;
    String? beneficiaryId = currentOvc.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String? eventId = dataObject['eventId'] ?? "";
    String id =
        "${OvcRoutesConstant.ovcClhivArtCardServiceFormPage}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: OvcRoutesConstant.ovcClhivArtCardServiceFormPage,
      nextPageModule: OvcRoutesConstant.ovcClhivArtCardServiceFormPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void clearFormAutoSaveState(
    BuildContext context,
    String? ovcId,
    String? eventId,
  ) async {
    String formAutoSaveId =
        "${OvcRoutesConstant.ovcClhivArtCardServiceFormPage}_${ovcId}_$eventId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    OvcHouseholdChild ovc,
  ) async {
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
    unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
      mandatoryFields,
      dataObject,
      hiddenFields:
          Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections ?? [],
      ),
    );
    setState(() {});
    if (hadAllMandatoryFilled) {
      isSaving = true;
      setState(() {});
      String? eventDate = dataObject['eventDate'] ?? dataObject['uVmlqLmHYpD'];
      String? eventId = dataObject['eventId'];
      List<String> hiddenFields = [];
      String orgUnit = dataObject['location'] ?? ovc.orgUnit;
      orgUnit = orgUnit.isEmpty ? ovc.orgUnit ?? '' : orgUnit;
      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          ClhivArtCardConstants.program,
          ClhivArtCardConstants.programStage,
          orgUnit,
          formSections ?? [],
          dataObject,
          eventDate,
          ovc.id,
          eventId,
          hiddenFields,
        ).then(
          (_) {
            setState(() {
              isSaving = false;
            });
            Provider.of<ServiceEventDataState>(context, listen: false)
                .resetServiceEventDataState(ovc.id);
            String? currentLanguage =
                Provider.of<LanguageTranslationState>(context, listen: false)
                    .currentLanguage;
            AppUtil.showToastMessage(
              message: currentLanguage == 'lesotho'
                  ? 'Fomo e bolokeile'
                  : 'Form has been saved successfully',
              position: ToastGravity.TOP,
            );
            clearFormAutoSaveState(context, ovc.id, eventId ?? '');
            Navigator.pop(context);
          },
        );
      } catch (e) {
        Timer(
          const Duration(seconds: 1),
          () {
            setState(
              () {
                AppUtil.showToastMessage(
                  message: e.toString(),
                  position: ToastGravity.BOTTOM,
                );
              },
            );
          },
        );
      }
    } else {
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
        position: ToastGravity.TOP,
      );
    }
  }

  List<FormSection> getSanitizedFormSections(
    List<FormSection> formSections,
    Map dataObject,
  ) {
    List<FormSection> sanitizedFormSections = [];
    var currentOvc = Provider.of<OvcHouseholdCurrentSelectionState>(
      context,
      listen: false,
    ).currentOvcHouseholdChild;
    for (FormSection formSection in formSections) {
      List<InputField> inputFields = [];
      for (InputField inputField in formSection.inputFields ?? []) {
        if (inputField.id == 'uVmlqLmHYpD' || inputField.id == 'WKdeD28Oyn7') {
          inputField.firstDate = currentOvc != null
              ? currentOvc.artInitiationDate ?? currentOvc.createdDate ?? ''
              : '';
        }
        inputFields.add(inputField);
      }

      formSection.inputFields = inputFields;
      sanitizedFormSections.add(formSection);
    }
    return sanitizedFormSections;
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
              label: header,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Consumer<LanguageTranslationState>(
          builder: (context, languageTranslationState, child) {
            String? currentLanguage = languageTranslationState.currentLanguage;
            return Consumer<OvcHouseholdCurrentSelectionState>(
              builder: (context, agywState, child) {
                OvcHouseholdChild? currentOvc =
                    agywState.currentOvcHouseholdChild;
                return Consumer<ServiceFormState>(
                  builder: (context, serviceFormState, child) {
                    var sanitizedFormSections = getSanitizedFormSections(
                      formSections ?? [],
                      serviceFormState.formState,
                    );
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
                                      hiddenFields:
                                          serviceFormState.hiddenFields,
                                      hiddenSections:
                                          serviceFormState.hiddenSections,
                                      formSections: sanitizedFormSections,
                                      mandatoryFieldObject:
                                          mandatoryFieldObject,
                                      unFilledMandatoryFields:
                                          unFilledMandatoryFields,
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
                                      buttonColor: const Color(0xFF4B9F46),
                                      fontSize: 15.0,
                                      onPressButton: () => onSaveForm(
                                        context,
                                        serviceFormState.formState,
                                        currentOvc!,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
