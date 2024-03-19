import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/pp_prev_beneficiary.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/components/pp_prev_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/constants/pp_prev_intervention_constant.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/constants/pp_prev_routes_constant.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/models/pp_prev_gender_norms_form.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/skip_logics/pp_prev_gender_norms_form_skip_logic.dart';
import 'package:provider/provider.dart';

class PpPrevInterventionGenderNormsForm extends StatefulWidget {
  const PpPrevInterventionGenderNormsForm({Key? key}) : super(key: key);

  @override
  State<PpPrevInterventionGenderNormsForm> createState() =>
      _PpPrevInterventionGenderNormsFormState();
}

class _PpPrevInterventionGenderNormsFormState
    extends State<PpPrevInterventionGenderNormsForm> {
  final String label = "PP Prev Gender Norms Form";
  final String sessionNumberInputField = 'vL6NpUA0rIU';
  final List<String> offeredServices = [
    "IOW7iC5ZuRQ",
  ];
  List<String> mandatoryFields = PpPrevGenderNormsForm.getMandatoryField();
  final Map mandatoryFieldObject = {};

  List<FormSection>? formSections;
  List<FormSection>? defaultFormSections;
  bool isFormReady = false;
  bool isSaving = false;
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setFormSections();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isFormReady = true;
        evaluateSkipLogics();
      });
    });
  }

  void setMandatoryFields(Map<dynamic, dynamic> dataObject) {
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
  }

  setFormSections() {
    var currentPpPrev = Provider.of<PpPrevInterventionCurrentSelectionState>(
      context,
      listen: false,
    ).currentPpPrev;
    defaultFormSections = PpPrevGenderNormsForm.getFormSections(
      firstDate: currentPpPrev!.createdDate!,
    );
    if (currentPpPrev.enrollmentOuAccessible!) {
      formSections = defaultFormSections;
    } else {
      FormSection serviceProvisionForm =
          AppUtil.getServiceProvisionLocationSection(
        inputColor: PpPrevInterventionConstant.inputColor,
        sectionLabelColor: PpPrevInterventionConstant.inputColor,
        labelColor: PpPrevInterventionConstant.labelColor,
        allowedSelectedLevels: [AppHierarchyReference.communityLevel],
        program: PpPrevInterventionConstant.program,
      );
      formSections = [serviceProvisionForm, ...defaultFormSections!];
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
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await PpPrevGenderNormsFormSkipLogic.evaluateSkipLogics(
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
    onUpdateFormAutoSaveState(context);
    if (id == sessionNumberInputField || offeredServices.contains(id)) {
      for (var serviceId in offeredServices) {
        Timer(
          const Duration(milliseconds: 200),
          () async {
            Map dataObject =
                Provider.of<ServiceFormState>(context, listen: false).formState;
            if (dataObject[sessionNumberInputField] != null) {
              bool allowedNumberOfSessions =
                  PpPrevGenderNormsFormSkipLogic.evaluateSkipLogicBySessions(
                dataObject,
                serviceId,
              );
              bool sessionAlreadyExists = PpPrevGenderNormsFormSkipLogic
                  .evaluateSkipLogicBySessionReoccurrence(
                dataObject,
                serviceId,
              );
              if (!allowedNumberOfSessions) {
                AppUtil.showToastMessage(
                  message:
                      "Sessions ${dataObject[sessionNumberInputField]} is not valid for the offered Service!",
                  position: ToastGravity.BOTTOM,
                );
              } else if (sessionAlreadyExists) {
                AppUtil.showToastMessage(
                  message:
                      "Sessions ${dataObject[sessionNumberInputField]} already exists for this service!",
                  position: ToastGravity.BOTTOM,
                );
              }
            }
          },
        );
      }
    }
  }

  void clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    String formAutoSaveId =
        "${PpPrevRoutesConstant.genderNormsFormPageModule}_${beneficiaryId}_$eventId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    var currentPpPrev = Provider.of<PpPrevInterventionCurrentSelectionState>(
            context,
            listen: false)
        .currentPpPrev;
    String? beneficiaryId = currentPpPrev!.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String eventId = dataObject['eventId'] ?? '';
    String id =
        "${PpPrevRoutesConstant.genderNormsFormPageModule}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: PpPrevRoutesConstant.genderNormsFormPageModule,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : PpPrevRoutesConstant.genderNormsFormNextPageModule
          : PpPrevRoutesConstant.genderNormsFormPageModule,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    PpPrevBeneficiary ppPrevBeneficiary,
  ) async {
    setMandatoryFields(dataObject);
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
      if (FormUtil.geFormFilledStatus(dataObject, defaultFormSections)) {
        bool sessionExists = offeredServices.any((String service) =>
            PpPrevGenderNormsFormSkipLogic
                .evaluateSkipLogicBySessionReoccurrence(dataObject, service));

        bool allowedNumberOfSessions = offeredServices.any((String service) =>
            PpPrevGenderNormsFormSkipLogic.evaluateSkipLogicBySessions(
              dataObject,
              service,
            ));

        if (!allowedNumberOfSessions) {
          AppUtil.showToastMessage(
            message:
                "Sessions ${dataObject[sessionNumberInputField]} is not valid for the offered Service!",
            position: ToastGravity.BOTTOM,
          );
        } else if (sessionExists) {
          AppUtil.showToastMessage(
            message:
                "Sessions ${dataObject[sessionNumberInputField]} already exists for this service!",
            position: ToastGravity.BOTTOM,
          );
        } else {
          isSaving = true;
          setState(() {});
          String? eventDate = dataObject['eventDate'];
          String? eventId = dataObject['eventId'];
          List<String> hiddenFields = [];
          String orgUnit = dataObject['location'] ?? ppPrevBeneficiary.orgUnit;
          orgUnit = orgUnit.isEmpty ? ppPrevBeneficiary.orgUnit ?? '' : orgUnit;
          try {
            await TrackedEntityInstanceUtil
                .savingTrackedEntityInstanceEventData(
              PpPrevInterventionConstant.program,
              PpPrevInterventionConstant.genderNormsProgramStage,
              orgUnit,
              defaultFormSections!,
              dataObject,
              eventDate,
              ppPrevBeneficiary.id,
              eventId,
              hiddenFields,
              skippedFields: ['interventionSessions'],
            );
            Provider.of<ServiceEventDataState>(context, listen: false)
                .resetServiceEventDataState(ppPrevBeneficiary.id);
            Timer(const Duration(seconds: 1), () {
              setState(() {
                String? currentLanguage = Provider.of<LanguageTranslationState>(
                        context,
                        listen: false)
                    .currentLanguage;
                AppUtil.showToastMessage(
                  message: currentLanguage == 'lesotho'
                      ? 'Fomo e bolokeile'
                      : 'Form has been saved successfully',
                  position: ToastGravity.TOP,
                );
                clearFormAutoSaveState(
                  context,
                  ppPrevBeneficiary.id,
                  eventId ?? '',
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
        }
      } else {
        AppUtil.showToastMessage(
          message: 'Please fill at least one form field',
          position: ToastGravity.TOP,
        );
      }
    } else {
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
        position: ToastGravity.TOP,
      );
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
          body: Consumer<LanguageTranslationState>(
              builder: (context, languageTranslationState, child) {
            String? currentLanguage = languageTranslationState.currentLanguage;
            return Consumer<PpPrevInterventionCurrentSelectionState>(
              builder:
                  (context, ppPrevInterventionCurrentSelectionState, child) {
                return Consumer<ServiceFormState>(
                  builder: (context, serviceFormState, child) {
                    PpPrevBeneficiary? ppPrevBeneficiary =
                        ppPrevInterventionCurrentSelectionState.currentPpPrev;
                    return Column(
                      children: [
                        PpPrevBeneficiaryTopHeader(
                          ppPrevBeneficiary: ppPrevBeneficiary!,
                        ),
                        Container(
                          child: !isFormReady
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
                                        hiddenInputFieldOptions:
                                            serviceFormState
                                                .hiddenInputFieldOptions,
                                        hiddenSections:
                                            serviceFormState.hiddenSections,
                                        formSections: formSections,
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
                                        buttonColor: const Color(0xFF9B2BAE),
                                        fontSize: 15.0,
                                        onPressButton: () => onSaveForm(
                                          context,
                                          serviceFormState.formState,
                                          ppPrevBeneficiary,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
