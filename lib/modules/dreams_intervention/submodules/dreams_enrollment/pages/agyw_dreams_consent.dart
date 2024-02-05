import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/models/agyw_enrollment_consent.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/pages/agyw_enrollment_none_participation_form.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/skip_logics/agyw_dreams_enrollment_skip_logic.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:provider/provider.dart';
import 'agyw_dreams_risk_assessment.dart';

class AgywDreamsConsentForm extends StatefulWidget {
  const AgywDreamsConsentForm({Key? key}) : super(key: key);

  @override
  State<AgywDreamsConsentForm> createState() =>
      _AgywEnrollmentConsentFormState();
}

class _AgywEnrollmentConsentFormState extends State<AgywDreamsConsentForm> {
  List<FormSection>? formSections;
  final String label = 'Consent Form';
  final String translatedName = 'Foromo ea boitlamo';
  final List<String> mandatoryFields =
      AgywEnrollmentConcent.getMandatoryField();
  final Map mandatoryFieldObject = {};
  bool isFormReady = false;
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setFormSectionMetadata();
  }

  void setFormSectionMetadata() {
    CurrentUser? user =
        Provider.of<CurrentUserState>(context, listen: false).currentUser;
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
    }
    List<int> allowedSelectedLevels = UserAccountReference
            .dreamsFacilityBasedIpNames
            .contains(user?.implementingPartner)
        ? [AppHierarchyReference.facilityLevel]
        : UserAccountReference.dreamsCommunityBasedIpNames
                .contains(user?.implementingPartner)
            ? [AppHierarchyReference.communityLevel]
            : [
                AppHierarchyReference.communityLevel,
                AppHierarchyReference.facilityLevel
              ];
    formSections = AgywEnrollmentConcent.getFormSections(
      allowedSelectedLevels: allowedSelectedLevels,
    );
    isFormReady = true;
    evaluateSkipLogics();
    setState(() {});
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
    String nextPageModule = "",
  }) async {
    String beneficiaryId = "";
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String id = "${DreamsRoutesConstant.agywConsentPage}_$beneficiaryId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: DreamsRoutesConstant.agywConsentPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : DreamsRoutesConstant.agywConsentNextPage
          : DreamsRoutesConstant.agywConsentPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
  }

  void onSaveAndContinue(BuildContext context, Map dataObject) {
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
      bool hasConsent = dataObject['EsrJ2dgIMHY'];
      AppUtil.showToastMessage(
        message: 'Ensure you have documented AGYW consent on File',
        position: ToastGravity.TOP,
      );
      onUpdateFormAutoSaveState(
        context,
        isSaveForm: true,
        nextPageModule:
            hasConsent ? "" : DreamsRoutesConstant.agywNoneParticipationPage,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => hasConsent
              ? const AgywDreamsRiskAssessment()
              : const AgywEnrollmentNoneParticipationForm(),
        ),
      );
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
                translatedName: translatedName,
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
                              lastUpdatedId:
                                  enrollmentFormState.lastUpdatedFieldId,
                              hiddenFields: enrollmentFormState.hiddenFields,
                              hiddenSections:
                                  enrollmentFormState.hiddenSections,
                              formSections: formSections,
                              mandatoryFieldObject: mandatoryFieldObject,
                              dataObject: enrollmentFormState.formState,
                              onInputValueChange: onInputValueChange,
                              unFilledMandatoryFields: unFilledMandatoryFields,
                            ),
                            EntryFormSaveButton(
                              label: currentLanguage == 'lesotho'
                                  ? 'Boloka ebe u fetela pele'
                                  : 'Save and Continue',
                              labelColor: Colors.white,
                              buttonColor: const Color(0xFF258DCC),
                              fontSize: 15.0,
                              onPressButton: () => onSaveAndContinue(
                                  context, enrollmentFormState.formState),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
        bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
      ),
    );
  }
}
