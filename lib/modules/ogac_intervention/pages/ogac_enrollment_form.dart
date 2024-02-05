import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ogac_intervention_list_state/ogac_intervention_list_state.dart';
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
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/ogac_intervention/constants/ogac_routes_constant.dart';
import 'package:kb_mobile_app/modules/ogac_intervention/models/ogac_enrollment_form_section.dart';
import 'package:kb_mobile_app/modules/ogac_intervention/services/ogac_enrollment_service.dart';
import 'package:kb_mobile_app/modules/ogac_intervention/skip_logics/ogac_intervention_skip_logic.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:provider/provider.dart';

class OgacEnrollmentForm extends StatefulWidget {
  const OgacEnrollmentForm({Key? key}) : super(key: key);

  @override
  State<OgacEnrollmentForm> createState() => _OgacEnrollmentFormState();
}

class _OgacEnrollmentFormState extends State<OgacEnrollmentForm> {
  final String label = 'OGAC Enrollment Form';
  final String translatedName = 'Foromo ea ngoliso ea OGAC';
  final List<String> mandatoryFields =
      OgacInterventionFormSection.getMandatoryField();
  final Map mandatoryFieldObject = {};
  List<FormSection>? formSections;
  late List<FormSection> stageFormSections;
  bool isSaving = false;
  bool isFormReady = false;
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      for (String id in mandatoryFields) {
        mandatoryFieldObject[id] = true;
      }
      formSections = OgacInterventionFormSection.getEnrollmentFormSections();
      stageFormSections = OgacInterventionFormSection.getStageFormSections();
      formSections!.addAll(stageFormSections);
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
        await OgacInterventionSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
        );
      },
    );
  }

  void onUpdateFormAutoSaveState(BuildContext context) async {
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String beneficiaryId = dataObject['trackedEntityInstance'] ?? "";
    String id = "${OgacRoutesConstant.pageModule}_$beneficiaryId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: OgacRoutesConstant.pageModule,
      nextPageModule: OgacRoutesConstant.nextPageModule,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void clearFormAutoSaveState(BuildContext context) async {
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String beneficiaryId = dataObject['trackedEntityInstance'] ?? "";
    String formAutoSaveId = "${OgacRoutesConstant.pageModule}_$beneficiaryId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onSaveAndContinue(BuildContext context, Map dataObject) async {
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields:
          Provider.of<EnrollmentFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections ?? [],
      ),
    );
    if (hadAllMandatoryFilled) {
      isSaving = true;
      setState(() {});

      CurrentUser? user = await (UserService().getCurrentUser());
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
      String trackedEntityInstance =
          dataObject['trackedEntityInstance'] ?? AppUtil.getUid();
      String? orgUnit = dataObject['location'];
      String? enrollment = dataObject['enrollment'];
      String? enrollmentDate = dataObject['enrollmentDate'];
      String? incidentDate = dataObject['incidentDate'];
      List<String> hiddenFields = [
        BeneficiaryIdentification.beneficiaryId,
        BeneficiaryIdentification.beneficiaryIndex,
        UserAccountReference.implementingPartnerAttribute,
        UserAccountReference.serviceProviderAttribute,
        UserAccountReference.subImplementingPartnerAttribute
      ];
      try {
        await OgacEnrollmentService().savingOgacBeneficiaryEnrollment(
          dataObject,
          trackedEntityInstance,
          orgUnit,
          enrollment,
          enrollmentDate,
          incidentDate,
          hiddenFields,
        );
        Provider.of<OgacInterventionListState>(context, listen: false)
            .onBeneficiaryAdd();
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
            clearFormAutoSaveState(context);
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        });
      } catch (e) {
        setState(() {
          isSaving = false;
        });
        AppUtil.showToastMessage(
            message: e.toString(), position: ToastGravity.BOTTOM);
      }
    } else {
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
      setState(() {});
      AppUtil.showToastMessage(
          message: 'Please fill all mandatory field',
          position: ToastGravity.TOP);
    }
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
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
                translatedName: translatedName,
                activeInterventionProgram: activeInterventionProgram,
              );
            },
          ),
        ),
        body: SubPageBody(
          body: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 13.0),
            child: !isFormReady
                ? const Column(
                    children: [
                      Center(
                        child: CircularProcessLoader(
                          color: Colors.blueGrey,
                        ),
                      )
                    ],
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
                              isEditableMode:
                                  enrollmentFormState.isEditableMode,
                              hiddenFields: enrollmentFormState.hiddenFields,
                              hiddenSections:
                                  enrollmentFormState.hiddenSections,
                              formSections: formSections,
                              mandatoryFieldObject: mandatoryFieldObject,
                              dataObject: enrollmentFormState.formState,
                              onInputValueChange: onInputValueChange,
                              unFilledMandatoryFields: unFilledMandatoryFields,
                            ),
                            Visibility(
                              visible: enrollmentFormState.isEditableMode,
                              child: EntryFormSaveButton(
                                label: isSaving
                                    ? currentLanguage == 'lesotho'
                                        ? 'E ntse e boloka...'
                                        : 'Saving ...'
                                    : currentLanguage == 'lesotho'
                                        ? 'Boloka'
                                        : 'Save',
                                labelColor: Colors.white,
                                buttonColor: const Color(0xFFF05A2A),
                                fontSize: 15.0,
                                onPressButton: () => onSaveAndContinue(
                                  context,
                                  enrollmentFormState.formState,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
