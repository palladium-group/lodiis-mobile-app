import 'dart:async';
import 'dart:convert';
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
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_enrollment_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/models/dreams_service_service_form.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/service_form/constants/service_form_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/service_form/skip_logics/agyw_dreams_service_form_skip_logic.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:provider/provider.dart';

class AgywDreamsServiceForm extends StatefulWidget {
  const AgywDreamsServiceForm(
      {Key? key,
      this.isFormEdited = false,
      this.currentUserImplementingPartner})
      : super(key: key);

  final bool isFormEdited;
  final String? currentUserImplementingPartner;
  @override
  State<AgywDreamsServiceForm> createState() => _AgywDreamsServiceFormState();
}

class _AgywDreamsServiceFormState extends State<AgywDreamsServiceForm> {
  final String label = 'Service Form';
  final String translatedLabel = 'Foromo ea Tšebeletso';
  final String sessionNumberInputField = 'vL6NpUA0rIU';
  final String typeOfIntervention = 'Eug4BXDFLym';
  List<FormSection>? formSections;
  List<FormSection>? defaultFormSections;
  List<String> mandatoryFields = DreamsServiceForm.getMandatoryField();
  final Map mandatoryFieldObject = {};
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
    var agyw =
        Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
            .currentAgywDream!;
    defaultFormSections = DreamsServiceForm.getFormSections(
      firstDate: agyw.createdDate!,
    );
    if (agyw.enrollmentOuAccessible!) {
      formSections = defaultFormSections;
    } else {
      FormSection serviceProvisionForm =
          AppUtil.getServiceProvisionLocationSection(
        inputColor: AgywDreamsEnrollmentConstant.inputColor,
        labelColor: AgywDreamsEnrollmentConstant.labelColor,
        sectionLabelColor: AgywDreamsEnrollmentConstant.labelColor,
        allowedSelectedLevels: [
          AppHierarchyReference.communityLevel,
          AppHierarchyReference.facilityLevel
        ],
        program: AgywDreamsEnrollmentConstant.program,
      );
      formSections = [serviceProvisionForm, ...defaultFormSections!];
      mandatoryFields.addAll(
        FormUtil.getFormFieldIds(
          [serviceProvisionForm],
          includeLocationId: true,
        ),
      );
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
        await AgywDreamsServiceFormSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
          isFormEdited: widget.isFormEdited,
          implementingPartner: widget.currentUserImplementingPartner,
        );
      },
    );
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
    if (id == sessionNumberInputField || id == typeOfIntervention) {
      Timer(const Duration(milliseconds: 200), () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        if (dataObject[sessionNumberInputField] != null) {
          bool allowedNumberOfSessions =
              AgywDreamsServiceFormSkipLogic.evaluateSkipLogicsBySession(
                  dataObject);
          bool sessionAlreadyExists = AgywDreamsServiceFormSkipLogic
              .evaluateSkipLogicBySessionReoccurrence(dataObject);
          if (!allowedNumberOfSessions) {
            AppUtil.showToastMessage(
              message:
                  "Sessions ${dataObject[sessionNumberInputField]} is not valid for ${dataObject[typeOfIntervention]}",
              position: ToastGravity.TOP,
            );
          } else if (sessionAlreadyExists) {
            AppUtil.showToastMessage(
              message: ServiceFormConstant.oneOffServices
                      .contains(dataObject[typeOfIntervention])
                  ? '${dataObject[typeOfIntervention]} should only be offered once!'
                  : "Sessions ${dataObject[sessionNumberInputField]} for ${dataObject[typeOfIntervention]} already exists",
              position: ToastGravity.TOP,
            );
          }
        }
      });
    }
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    AgywDream? agywDream,
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
      if (FormUtil.geFormFilledStatus(dataObject, formSections)) {
        bool shouldSaveForm =
            AgywDreamsServiceFormSkipLogic.evaluateSkipLogicsBySession(
          dataObject,
        );
        if (shouldSaveForm) {
          bool sessionAlreadyExists = AgywDreamsServiceFormSkipLogic
              .evaluateSkipLogicBySessionReoccurrence(dataObject);
          if (sessionAlreadyExists) {
            AppUtil.showToastMessage(
              message: ServiceFormConstant.oneOffServices
                      .contains(dataObject[typeOfIntervention])
                  ? '${dataObject[typeOfIntervention]} is already offered!'
                  : "Sessions ${dataObject[sessionNumberInputField]} for ${dataObject[typeOfIntervention]} already exists",
              position: ToastGravity.TOP,
            );
          } else {
            setState(() {
              isSaving = true;
            });
            String? eventDate = dataObject['eventDate'];
            String? eventId = dataObject['eventId'];
            List<String> hiddenFields = [];
            List<String> skippedFields = [
              'interventionSessions',
              'eventSessions'
            ];
            String orgUnit = dataObject['location'] ?? agywDream!.orgUnit;
            orgUnit = orgUnit.isEmpty ? agywDream!.orgUnit ?? '' : orgUnit;
            try {
              await TrackedEntityInstanceUtil
                  .savingTrackedEntityInstanceEventData(
                ServiceFormConstant.program,
                ServiceFormConstant.programStage,
                orgUnit,
                defaultFormSections!,
                dataObject,
                eventDate,
                agywDream!.id,
                eventId,
                hiddenFields,
                skippedFields: skippedFields,
              );
              Provider.of<ServiceEventDataState>(context, listen: false)
                  .resetServiceEventDataState(agywDream.id);
              Timer(const Duration(seconds: 1), () {
                setState(() {
                  isSaving = false;
                });
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
                clearFormAutoSaveState(context, agywDream.id, eventId ?? '');
                Navigator.pop(context);
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
            message:
                "You have reached the maximum number of sessions for ${dataObject[typeOfIntervention]}",
            position: ToastGravity.TOP,
          );
        }
      } else {
        AppUtil.showToastMessage(
          message: 'Please fill at least one form field',
          position: ToastGravity.TOP,
        );
        Navigator.pop(context);
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
        message: 'Please fill all mandatory fields',
        position: ToastGravity.TOP,
      );
    }
  }

  void clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywDreamsServiceFormPage}_${beneficiaryId}_$eventId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    var agyw =
        Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
            .currentAgywDream!;
    String? beneficiaryId = agyw.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String? eventId = dataObject['eventId'] ?? "";
    String id =
        "${DreamsRoutesConstant.agywDreamsServiceFormPage}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: DreamsRoutesConstant.agywDreamsServiceFormPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : DreamsRoutesConstant.agywDreamsServiceFormNextPage
          : DreamsRoutesConstant.agywDreamsServiceFormPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
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
              translatedName: translatedLabel,
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
                                      hiddenInputFieldOptions: serviceFormState
                                          .hiddenInputFieldOptions,
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
