import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_intervention_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
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
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/education_beneficiary.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/education_intervention/components/education_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_lbse/constants/lbse_intervention_constant.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_lbse/constants/lbse_routes_constant.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_lbse/models/education_lbse_learning_outcome_form.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_lbse/skip_logics/education_lbse_learning_outcome_skip_logic.dart';
import 'package:provider/provider.dart';

class EducationLbseLearningOutcomeFormPage extends StatefulWidget {
  const EducationLbseLearningOutcomeFormPage({
    Key? key,
    required this.isNewLearningOutcomeForm,
  }) : super(key: key);
  final bool isNewLearningOutcomeForm;

  @override
  State<EducationLbseLearningOutcomeFormPage> createState() =>
      _EducationLbseLearningOutcomeFormPageState();
}

class _EducationLbseLearningOutcomeFormPageState
    extends State<EducationLbseLearningOutcomeFormPage> {
  final String label = 'Learning Outcome Form';
  List<FormSection>? formSections;
  List<FormSection>? defaultFormSections;
  List<String> mandatoryFields =
      EducationLbseLearningOutcomeForm.getMandatoryField();
  final Map mandatoryFieldObject = {};
  List unFilledMandatoryFields = [];
  bool isFormReady = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    setFormSections();
    Timer(const Duration(seconds: 1), () {
      _setCurrentServiceProvider();
      isFormReady = true;
      evaluateSkipLogics();
      setState(() {});
    });
  }

  _setCurrentServiceProvider() {
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String currentServiceProvider =
        dataObject[LbseInterventionConstant.serviceProvider] ?? '';
    if (currentServiceProvider.isEmpty) {
      CurrentUser? user =
          Provider.of<CurrentUserState>(context, listen: false).currentUser;
      currentServiceProvider = user?.name ?? currentServiceProvider;
      if (currentServiceProvider.isNotEmpty) {
        onInputValueChange(
          LbseInterventionConstant.serviceProvider,
          currentServiceProvider,
        );
      }
    }
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await EducationLbseLearningOutcomeSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
        );
      },
    );
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
    EducationBeneficiary lbseBeneficiary =
        Provider.of<EducationInterventionCurrentSelectionState>(context,
                listen: false)
            .currentBeneficiciary!;
    defaultFormSections = EducationLbseLearningOutcomeForm.getFormSections();
    if (lbseBeneficiary.enrollmentOuAccessible!) {
      formSections = defaultFormSections;
    } else {
      FormSection serviceProvisionForm =
          AppUtil.getServiceProvisionLocationSection(
              inputColor: LbseInterventionConstant.inputColor,
              labelColor: LbseInterventionConstant.labelColor,
              sectionLabelColor: LbseInterventionConstant.inputColor,
              allowedSelectedLevels: [AppHierarchyReference.communityLevel],
              program: LbseInterventionConstant.program);
      formSections = [serviceProvisionForm, ...defaultFormSections!];
      mandatoryFields.addAll(FormUtil.getFormFieldIds(
        [serviceProvisionForm],
        includeLocationId: true,
      ));
    }
    for (String fieldId in mandatoryFields) {
      mandatoryFieldObject[fieldId] = true;
    }
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
  }

  List<String> getMandatoryFielOnFormSubmission() {
    List<String> allMandatoryFields = widget.isNewLearningOutcomeForm
        ? mandatoryFields
        : EducationLbseLearningOutcomeForm.getMandatoryField();
    return allMandatoryFields.toSet().toList();
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    EducationBeneficiary lbseBeneficiary,
  ) async {
    setMandatoryFields(dataObject);
    List<String> allMandatoryFields = getMandatoryFielOnFormSubmission();
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      allMandatoryFields,
      dataObject,
      hiddenFields:
          Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections ?? [],
      ),
    );
    if (hadAllMandatoryFilled) {
      setState(() {
        isSaving = true;
      });
      String? eventDate = dataObject['eventDate'];
      String? eventId = dataObject['eventId'];
      List<String> hiddenFields = [];
      String orgUnit = dataObject['location'] ?? lbseBeneficiary.orgUnit;
      orgUnit = orgUnit.isEmpty ? lbseBeneficiary.orgUnit ?? '' : orgUnit;
      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          LbseInterventionConstant.program,
          LbseInterventionConstant.learningOutcomeProgamStage,
          orgUnit,
          defaultFormSections!,
          dataObject,
          eventDate,
          lbseBeneficiary.id,
          eventId,
          hiddenFields,
        ).then((response) {
          Provider.of<ServiceEventDataState>(context, listen: false)
              .resetServiceEventDataState(lbseBeneficiary.id);
          Timer(const Duration(seconds: 1), () {
            String? currentLanguage =
                Provider.of<LanguageTranslationState>(context, listen: false)
                    .currentLanguage;
            AppUtil.showToastMessage(
              message: currentLanguage == 'lesotho'
                  ? 'Fomo e bolokeile'
                  : 'Form has been saved successfully',
              position: ToastGravity.TOP,
            );
            clearFormAutoSaveState(
              context,
              lbseBeneficiary.id,
              eventId ?? '',
            );
            Navigator.pop(context);
          });
        }).catchError((error) {
          Timer(const Duration(seconds: 1), () {
            setState(() {
              AppUtil.showToastMessage(
                message: error.toString(),
                position: ToastGravity.BOTTOM,
              );
            });
          });
        });
      } catch (error) {
        Timer(const Duration(seconds: 1), () {
          setState(() {
            AppUtil.showToastMessage(
              message: error.toString(),
              position: ToastGravity.BOTTOM,
            );
          });
        });
      }
    } else {
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
        position: ToastGravity.TOP,
      );
    }
  }

  void clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    String formAutoSaveId =
        '${LbseRoutesConstant.learningOutcomePageModule}_${beneficiaryId}_$eventId';
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = '',
  }) async {
    var lbseBeneficiary =
        Provider.of<EducationInterventionCurrentSelectionState>(context,
                listen: false)
            .currentBeneficiciary;
    String? beneficiaryId = lbseBeneficiary!.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String eventId = dataObject['eventId'] ?? '';
    String id =
        '${LbseRoutesConstant.learningOutcomePageModule}_${beneficiaryId}_$eventId';
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: LbseRoutesConstant.learningOutcomePageModule,
      nextPageModule: isSaveForm
          ? nextPageModule != ''
              ? nextPageModule
              : LbseRoutesConstant.learningOutcomeNextPageModule
          : LbseRoutesConstant.learningOutcomePageModule,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
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
            return Consumer<EducationInterventionCurrentSelectionState>(
              builder:
                  (context, educationInterventionCurrentSelectionState, child) {
                return Consumer<ServiceFormState>(
                  builder: (context, serviceFormState, child) {
                    EducationBeneficiary? lbseBeneficiary =
                        educationInterventionCurrentSelectionState
                            .currentBeneficiciary;
                    return Column(
                      children: [
                        EducationBeneficiaryTopHeader(
                          educationBeneficiary: lbseBeneficiary!,
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
                                        hiddenSections:
                                            serviceFormState.hiddenSections,
                                        formSections: formSections,
                                        mandatoryFieldObject:
                                            mandatoryFieldObject,
                                        hiddenInputFieldOptions:
                                            serviceFormState
                                                .hiddenInputFieldOptions,
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
                                        buttonColor: const Color(0xFF009688),
                                        fontSize: 15.0,
                                        onPressButton: () => !isSaving
                                            ? onSaveForm(
                                                context,
                                                serviceFormState.formState,
                                                lbseBeneficiary,
                                              )
                                            : null,
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
