import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/education_beneficiary.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/education_intervention/components/education_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/constants/bursary_intervention_constant.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/constants/bursary_routes_constant.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/education_bursary_referral_form.dart';
import 'package:provider/provider.dart';

class EducationBursaryReferralFormPage extends StatefulWidget {
  const EducationBursaryReferralFormPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EducationBursaryReferralFormPage> createState() =>
      _EducationBursaryReferralFormPageState();
}

class _EducationBursaryReferralFormPageState
    extends State<EducationBursaryReferralFormPage> {
  final String label = 'Referral Form';
  final String translatedLabel = 'Foromo ea phetisetso';
  List<FormSection>? formSections;
  List<FormSection>? defaultFormSections;
  List<String> mandatoryFields =
      EducationBursaryReferralForm.getMandatoryField();
  final Map mandatoryFieldObject = {};
  List unFilledMandatoryFields = [];
  bool isFormReady = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    setFormSections();
    Timer(const Duration(seconds: 1), () {
      isFormReady = true;
      setState(() {});
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
    EducationBeneficiary lbseBeneficiary =
        Provider.of<EducationInterventionCurrentSelectionState>(context,
                listen: false)
            .currentBeneficiciary!;
    defaultFormSections = EducationBursaryReferralForm.getFormSections();
    if (lbseBeneficiary.enrollmentOuAccessible!) {
      formSections = defaultFormSections;
    } else {
      FormSection serviceProvisionForm =
          AppUtil.getServiceProvisionLocationSection(
        inputColor: BursaryInterventionConstant.inputColor,
        labelColor: BursaryInterventionConstant.labelColor,
        sectionLabelColor: BursaryInterventionConstant.inputColor,
        allowedSelectedLevels:
            BursaryInterventionConstant.allowedSelectedLevels,
        program: BursaryInterventionConstant.program,
      );
      formSections = [serviceProvisionForm, ...defaultFormSections!];
      mandatoryFields.addAll(FormUtil.getFormFieldIds(
        [serviceProvisionForm],
        includeLocationId: true,
      ));
      for (String fieldId in mandatoryFields) {
        mandatoryFieldObject[fieldId] = true;
      }
    }
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    onUpdateFormAutoSaveState(context);
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    EducationBeneficiary lbseBeneficiary,
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
    if (hadAllMandatoryFilled) {
      setState(() {
        isSaving = true;
      });
      String clubAttendanceToReferralLinkage =
          BursaryInterventionConstant.clubAttendanceToReferralLinkage;
      String referralToReferralOutcomeLinkage = BursaryInterventionConstant
          .clubAttendanceReferralToReferralOutcomeLinkage;
      dataObject[clubAttendanceToReferralLinkage] =
          dataObject[clubAttendanceToReferralLinkage] ?? AppUtil.getUid();
      dataObject[referralToReferralOutcomeLinkage] =
          dataObject[referralToReferralOutcomeLinkage] ?? AppUtil.getUid();
      String? eventDate = dataObject['eventDate'];
      String? eventId = dataObject['eventId'];
      List<String> hiddenFields = [
        clubAttendanceToReferralLinkage,
        referralToReferralOutcomeLinkage
      ];
      String orgUnit = dataObject['location'] ?? lbseBeneficiary.orgUnit;
      orgUnit = orgUnit.isEmpty ? lbseBeneficiary.orgUnit ?? '' : orgUnit;
      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          BursaryInterventionConstant.program,
          BursaryInterventionConstant.clubAttendanceReferralProgamStage,
          orgUnit,
          formSections!,
          dataObject,
          eventDate,
          lbseBeneficiary.id,
          eventId,
          hiddenFields,
        );
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
      } catch (e) {
        Timer(const Duration(seconds: 1), () {
          setState(() {
            AppUtil.showToastMessage(
              message: e.toString(),
              position: ToastGravity.BOTTOM,
            );
          });
        });
      }
    } else {
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
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory field',
        position: ToastGravity.TOP,
      );
    }
  }

  void clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    String formAutoSaveId =
        '${BursaryRoutesConstant.clubReferralPageModule}_${beneficiaryId}_$eventId';
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = '',
  }) async {
    var bursaryBeneficiary =
        Provider.of<EducationInterventionCurrentSelectionState>(context,
                listen: false)
            .currentBeneficiciary;
    String? beneficiaryId = bursaryBeneficiary!.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String eventId = dataObject['eventId'] ?? '';
    String id =
        '${BursaryRoutesConstant.clubReferralPageModule}_${beneficiaryId}_$eventId';
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: BursaryRoutesConstant.clubReferralPageModule,
      nextPageModule: isSaveForm
          ? nextPageModule != ''
              ? nextPageModule
              : BursaryRoutesConstant.clubReferralNextPageModule
          : BursaryRoutesConstant.clubReferralPageModule,
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
