import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/models/ovc_enrollment_household.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/pages/ovc_enrollment_child_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/skip_logics/ovc_household_enrollment_skip_logic.dart';
import 'package:provider/provider.dart';

class OvcEnrollmentHouseholdFormContainer extends StatefulWidget {
  const OvcEnrollmentHouseholdFormContainer({Key? key}) : super(key: key);

  @override
  State<OvcEnrollmentHouseholdFormContainer> createState() =>
      _OvcEnrollmentHouseholdFormContainerState();
}

class _OvcEnrollmentHouseholdFormContainerState
    extends State<OvcEnrollmentHouseholdFormContainer> {
  List<FormSection> formSections = [];
  final List<String> mandatoryFields =
      OvcEnrollmentHousehold.getMandatoryField();
  final Map mandatoryFieldObject = {};
  bool isFormReady = false;
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    _setFormState();
  }

  _setFormState() {
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
    }
    formSections = OvcEnrollmentHousehold.getFormSections(
      isEnrolmentDateEditable: false,
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
        await OvcHouseholdEnrollmentSkipLogic.evaluateSkipLogics(
          context,
          formSections,
          dataObject,
        );
      },
    );
  }

  void onUpdateFormAutoSaveState({
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    String beneficiaryId = "";
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String id = "${OvcRoutesConstant.ovcConcentFormPage}_$beneficiaryId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: OvcRoutesConstant.ovcCaregiverFormPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : OvcRoutesConstant.ovcCaregiverFormNextPage
          : OvcRoutesConstant.ovcCaregiverFormPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState();
  }

  void onSaveAndContinue(
    Map dataObject,
    Map hiddenFields,
  ) async {
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections,
      ),
    );
    if (hadAllMandatoryFilled) {
      onUpdateFormAutoSaveState(isSaveForm: true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OvcEnrollmentChildFormContainer(),
        ),
      );
    } else {
      setState(() {
        unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
          mandatoryFields,
          dataObject,
          hiddenFields: hiddenFields,
          checkBoxInputFields: FormUtil.getInputFieldByValueType(
            valueType: 'CHECK_BOX',
            formSections: formSections,
          ),
        );
      });
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
        position: ToastGravity.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65.0),
              child: Consumer<InterventionCardState>(
                builder: (context, interventionCardState, child) {
                  InterventionCard activeInterventionProgram =
                      interventionCardState.currentInterventionProgram;
                  return SubPageAppBar(
                    label: languageTranslationState.isSesothoLanguage
                        ? 'Foromo ea ngoliso ea lelapa'
                        : 'Household Registration form',
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
                    : Consumer<EnrollmentFormState>(
                        builder: (context, enrollmentFormState, child) =>
                            Column(
                          children: [
                            Consumer<EnrollmentFormState>(
                              builder: (context, enrollmentFormState, child) {
                                return EntryFormContainer(
                                  hiddenSections:
                                      enrollmentFormState.hiddenSections,
                                  hiddenFields:
                                      enrollmentFormState.hiddenFields,
                                  formSections: formSections =
                                      OvcEnrollmentHousehold.getFormSections(
                                          isEnrolmentDateEditable: false),
                                  mandatoryFieldObject: mandatoryFieldObject,
                                  dataObject: enrollmentFormState.formState,
                                  onInputValueChange: onInputValueChange,
                                  unFilledMandatoryFields:
                                      unFilledMandatoryFields,
                                );
                              },
                            ),
                            EntryFormSaveButton(
                              label: languageTranslationState.isSesothoLanguage
                                  ? 'Boloka ebe u fetela pele'
                                  : 'Save and Continue',
                              labelColor: Colors.white,
                              buttonColor: const Color(0xFF4B9F46),
                              fontSize: 15.0,
                              onPressButton: () => onSaveAndContinue(
                                enrollmentFormState.formState,
                                enrollmentFormState.hiddenFields,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            bottomNavigationBar:
                const InterventionBottomNavigationBarContainer(),
          );
        },
      ),
    );
  }
}
