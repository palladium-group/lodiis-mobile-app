import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/services/agyw_dreams_enrollment_service.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/skip_logics/agyw_dreams_enrollment_skip_logic.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:provider/provider.dart';
import '../models/agyw_enrollment_consent.dart';
import '../models/agyw_enrollment_form_section.dart';
import '../models/agyw_enrollment_risk_assessment.dart';

class AgywDreamsEnrollmentEditForm extends StatefulWidget {
  const AgywDreamsEnrollmentEditForm({Key? key}) : super(key: key);

  @override
  State<AgywDreamsEnrollmentEditForm> createState() =>
      _AgywDreamsEnrollmentEditFormState();
}

class _AgywDreamsEnrollmentEditFormState
    extends State<AgywDreamsEnrollmentEditForm> {
  List<FormSection>? formSections;
  late List<FormSection> enrollmentFormSections;
  List<FormSection>? consentFormSections;
  late List<FormSection> riskAssessmentFormSections;
  final String label = 'Agyw Enrolment Form';
  final translatedLabel = 'Formo ea ngoliso ea AGYW';
  final Map mandatoryFieldObject = {};
  final List<String> mandatoryFields =
      AgywEnrollmentFormSection.getMandatoryField();
  bool isFormReady = false;
  bool isSaving = false;
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      for (String id in mandatoryFields) {
        mandatoryFieldObject[id] = true;
      }
      enrollmentFormSections = AgywEnrollmentFormSection.getFormSections();
      consentFormSections = AgywEnrollmentConcent.getFormSections();
      riskAssessmentFormSections =
          AgywEnrollmentRiskAssessment.getFormSections();
      List<String> skippedInputs = [
        'location',
        'WTZ7GLTrE8Q',
        'rSP9c21JsfC',
        'qZP982qpSPS',
        'B4ojlzKypUF',
        'HJIHPjOf5s1',
        'bApA6X6TVvJ',
        'yc3BlUIEup3',
        'p33MrrhsQRz',
        'iY67qYnywgS',
        'rh881j2vfvT',
        'AZCVLPzD0Vd',
        'cifBFSTHgv5',
        'JTNxMQPT134',
        'ls9hlz2tyol',
        'VJiWumvINR6',
      ];
      List<String> readOnlyFields = [
        'ls9hlz2tyol',
        'VJiWumvINR6',
        'qZP982qpSPS',
      ];
      FormSection demographicInformationFormSection =
          riskAssessmentFormSections[0];
      FormSection householdInformationFormSection =
          riskAssessmentFormSections[1];
      demographicInformationFormSection.inputFields =
          demographicInformationFormSection.inputFields!
              .map((InputField inputField) {
        if (readOnlyFields.contains(inputField.id)) {
          inputField.isReadOnly = true;
        }
        return inputField;
      }).toList();
      formSections = [
        demographicInformationFormSection,
        householdInformationFormSection,
      ];
      for (var enrollmentFormSection in enrollmentFormSections) {
        formSections!.add(enrollmentFormSection);
      }
      formSections = FormUtil.getFormSectionWithReadOnlyStatus(
        formSections!,
        false,
        skippedInputs,
      );
      isFormReady = true;
      evaluateSkipLogics();
    });
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<EnrollmentFormState>(context, listen: false).formState;
        await AgywDreamsEnrollmentSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
        );
      },
    );
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
  }) async {
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String beneficiaryId = dataObject['trackedEntityInstance'] ?? "";
    String id =
        "${DreamsRoutesConstant.agywEnrollmentFormEditPage}_$beneficiaryId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: DreamsRoutesConstant.agywEnrollmentFormEditPage,
      nextPageModule: isSaveForm
          ? DreamsRoutesConstant.agywEnrollmentFormEditNextPage
          : DreamsRoutesConstant.agywEnrollmentFormEditPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void clearFormAutoSaveState(BuildContext context) async {
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String beneficiaryId = dataObject['trackedEntityInstance'] ?? "";
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywEnrollmentFormEditPage}_$beneficiaryId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
  }

  void onSaveForm(BuildContext context, Map dataObject,
      {Map hiddenFields = const {}}) async {
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections ?? [],
      ),
    );
    if (hadAllMandatoryFilled) {
      setState(() {
        isSaving = true;
      });
      CurrentUser? user = await UserService().getCurrentUser();
      String? trackedEntityInstance = dataObject['trackedEntityInstance'];
      String? orgUnit = dataObject['orgUnit'];
      String? enrollment = dataObject['enrollment'];
      String? enrollmentDate = dataObject['enrollmentDate'];
      String? incidentDate = dataObject['incidentDate'];
      dataObject[UserAccountReference.implementingPartnerAttribute] =
          dataObject[UserAccountReference.implementingPartnerAttribute] ??
              user!.implementingPartner;
      dataObject[UserAccountReference.serviceProviderAttribute] =
          dataObject[UserAccountReference.serviceProviderAttribute] ??
              user!.username;
      if (user!.subImplementingPartner != '') {
        dataObject[UserAccountReference.subImplementingPartnerAttribute] =
            dataObject[UserAccountReference.subImplementingPartnerAttribute] ??
                user.subImplementingPartner;
      }
      List<String> hiddenFields = [
        BeneficiaryIdentification.beneficiaryId,
        BeneficiaryIdentification.beneficiaryIndex,
        'PN92g65TkVI',
        UserAccountReference.implementingPartnerAttribute,
        UserAccountReference.subImplementingPartnerAttribute,
        UserAccountReference.serviceProviderAttribute
      ];
      await AgywDreamsEnrollmentService().savingAgywBeneficiary(
        dataObject,
        trackedEntityInstance,
        orgUnit,
        enrollment,
        enrollmentDate,
        incidentDate,
        hiddenFields,
      );
      Provider.of<DreamsInterventionListState>(context, listen: false)
          .refreshAllDreamsLists();
      clearFormAutoSaveState(context);
      Timer(const Duration(seconds: 1), () {
        if (Navigator.canPop(context)) {
          setState(() {
            isSaving = false;
          });
          String? currentLanguage =
              Provider.of<LanguageTranslationState>(context, listen: false)
                  .currentLanguage;
          AppUtil.showToastMessage(
            message: currentLanguage == 'lesotho'
                ? 'Fomo e bolokeile'
                : 'Form has been saved successfully',
            position: ToastGravity.TOP,
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      });
    } else {
      setState(() {
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
      });
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory field',
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
                translatedName: translatedLabel,
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
            child: Container(
              child: !isFormReady
                  ? const Center(
                      child: CircularProcessLoader(
                        color: Colors.blueGrey,
                      ),
                    )
                  : Consumer<LanguageTranslationState>(
                      builder: (context, languageTranslationState, child) {
                      String? currentLanguage =
                          languageTranslationState.currentLanguage;
                      return Consumer<EnrollmentFormState>(
                        builder: (context, enrollmentFormState, child) =>
                            Column(
                          children: [
                            EntryFormContainer(
                              lastUpdatedId:
                                  enrollmentFormState.lastUpdatedFieldId,
                              hiddenFields: enrollmentFormState.hiddenFields,
                              hiddenSections:
                                  enrollmentFormState.hiddenSections,
                              formSections: formSections,
                              mandatoryFieldObject: mandatoryFieldObject,
                              isEditableMode:
                                  enrollmentFormState.isEditableMode,
                              dataObject: enrollmentFormState.formState,
                              onInputValueChange: onInputValueChange,
                              unFilledMandatoryFields: unFilledMandatoryFields,
                            ),
                            EntryFormSaveButton(
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
                              onPressButton: () => isSaving
                                  ? null
                                  : onSaveForm(
                                      context,
                                      enrollmentFormState.formState,
                                      hiddenFields:
                                          enrollmentFormState.hiddenFields,
                                    ),
                            )
                          ],
                        ),
                      );
                    }),
            ),
          ),
        ),
        bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
      ),
    );
  }
}
