import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
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
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_enrollment_child_services.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_enrollment_household_service.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/models/ovc_enrollment_consent.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/models/ovc_enrollment_household.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/skip_logics/ovc_household_enrollment_skip_logic.dart';
import 'package:provider/provider.dart';

class OvcEnrollmentHouseholdViewEditContainer extends StatefulWidget {
  const OvcEnrollmentHouseholdViewEditContainer({
    Key? key,
    this.onViewHouseholdForm = true,
  }) : super(key: key);

  final bool onViewHouseholdForm;

  @override
  State<OvcEnrollmentHouseholdViewEditContainer> createState() =>
      _OvcEnrollmentHouseholdViewEditContainerState();
}

class _OvcEnrollmentHouseholdViewEditContainerState
    extends State<OvcEnrollmentHouseholdViewEditContainer> {
  List<FormSection> formSections = [];
  late List<FormSection> enrollmentFormSections;
  final Map mandatoryFieldObject = {};
  List<String> mandatoryFields = [];

  bool _isFormReady = false;
  bool _isSaving = false;
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    _setFormMetadata();
  }

  void _setFormMetadata() {
    bool isEnrolmentDateEditable =
        Provider.of<EnrollmentFormState>(context, listen: false).isEditableMode;
    mandatoryFields = widget.onViewHouseholdForm
        ? [
            ...OvcEnrollmentConsent.getMandatoryField(),
            ...OvcEnrollmentHousehold.getMandatoryField()
          ]
        : OvcEnrollmentHousehold.getMandatoryField();
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
    }
    formSections = formSections = widget.onViewHouseholdForm
        ? [
            ...OvcEnrollmentConsent.getFormSections(),
            ...OvcEnrollmentHousehold.getFormSections(
              isEnrolmentDateEditable: isEnrolmentDateEditable,
            )
          ]
        : OvcEnrollmentHousehold.getFormSections(
            isEnrolmentDateEditable: isEnrolmentDateEditable,
          );
    Timer(const Duration(milliseconds: 200), () {
      _isFormReady = true;
      setState(() {});
      _evaluateSkipLogics();
    });
  }

  _evaluateSkipLogics() {
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

  void clearFormAutoSaveState() async {
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String beneficiaryId = dataObject['trackedEntityInstance'] ?? "";
    String formAutoSaveId =
        "${OvcRoutesConstant.ovcCaregiverEditFormPage}_$beneficiaryId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState({
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    Map dataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    String beneficiaryId = dataObject['trackedEntityInstance'] ?? "";
    String id = "${OvcRoutesConstant.ovcCaregiverEditFormPage}_$beneficiaryId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: OvcRoutesConstant.ovcCaregiverEditFormPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : OvcRoutesConstant.ovcCaregiverEditFormPage
          : OvcRoutesConstant.ovcCaregiverEditFormPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void onInputValueChange(String id, dynamic value) {
    if (id == 'enrollmentDate') {
      Map dataObject =
          Provider.of<EnrollmentFormState>(context, listen: false).formState;
      String previousEnrollmentDate = dataObject['enrollmentDate'] ?? '';
      if (previousEnrollmentDate != value) {
        String dobId = 'qZP982qpSPS';
        Provider.of<EnrollmentFormState>(context, listen: false)
            .setFormFieldState(dobId, '');
      }
    }
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState(id, value);
    _evaluateSkipLogics();
    onUpdateFormAutoSaveState();
  }

  void onSaveForm(
    Map dataObject,
    Map hiddenFields,
  ) async {
    unFilledMandatoryFields = [];
    setState(() {});
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
      _isSaving = true;
      setState(() {});
      String trackedEntityInstance = dataObject['trackedEntityInstance'] ?? '';
      String orgUnit = dataObject['orgUnit'] ?? '';
      String enrollment = dataObject['enrollment'] ?? '';
      String enrollmentDate = dataObject['enrollmentDate'] ?? '';
      String incidentDate = dataObject['incidentDate'] ?? enrollmentDate;
      List<String> hiddenFields = [
        BeneficiaryIdentification.beneficiaryId,
        BeneficiaryIdentification.beneficiaryIndex,
        'PN92g65TkVI',
        UserAccountReference.implementingPartnerAttribute,
        UserAccountReference.serviceProviderAttribute,
        UserAccountReference.subImplementingPartnerAttribute
      ];
      CurrentUser? user = await UserService().getCurrentUser();
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
      await OvcEnrollmentHouseholdService().savingHouseholdForm(
        dataObject,
        trackedEntityInstance,
        orgUnit,
        enrollment,
        enrollmentDate,
        incidentDate,
        false,
        hiddenFields,
      );
      await _updateAllChildPhoneNumber(
        dataObject: dataObject,
        parentId: trackedEntityInstance,
      );
      Provider.of<OvcInterventionListState>(context, listen: false)
          .refreshOvcList();
      clearFormAutoSaveState();
      Timer(const Duration(seconds: 1), () {
        if (Navigator.canPop(context)) {
          _isSaving = false;
          setState(() {});
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
      unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
        mandatoryFields,
        dataObject,
        hiddenFields: hiddenFields,
        checkBoxInputFields: FormUtil.getInputFieldByValueType(
          valueType: 'CHECK_BOX',
          formSections: formSections,
        ),
      );
      setState(() {});
      AppUtil.showToastMessage(
          message: 'Please fill all mandatory fields',
          position: ToastGravity.TOP);
    }
  }

  Future _updateAllChildPhoneNumber({
    required Map dataObject,
    required String parentId,
  }) async {
    List<String> hiddenFields = [
      BeneficiaryIdentification.beneficiaryId,
      BeneficiaryIdentification.beneficiaryIndex,
      'PN92g65TkVI',
      BeneficiaryIdentification.phoneNumber,
    ];
    String phoneNumber =
        dataObject[BeneficiaryIdentification.phoneNumber] ?? '';
    var currentOvcHousehold =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold;
    for (OvcHouseholdChild child in currentOvcHousehold?.children ?? []) {
      if (child.phoneNumber != phoneNumber) {
        Map childObject = child.toMap(parentId: parentId);
        childObject[BeneficiaryIdentification.phoneNumber] = phoneNumber;
        await OvcEnrollmentChildService().savingChildrenEnrollmentForms(
          parentId,
          childObject['orgUnit'],
          [childObject],
          childObject['enrollmentDate'],
          childObject['incidentDate'],
          false,
          hiddenFields,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
          String currentLanguage = languageTranslationState.currentLanguage;
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
                child: Container(
                  child: !_isFormReady
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
                          builder: (context, enrollmentFormState, child) {
                            return Column(
                              children: [
                                EntryFormContainer(
                                  lastUpdatedId:
                                      enrollmentFormState.lastUpdatedFieldId,
                                  formSections: widget.onViewHouseholdForm
                                      ? formSections
                                      : OvcEnrollmentHousehold.getFormSections(
                                          isEnrolmentDateEditable: true,
                                        ),
                                  mandatoryFieldObject: mandatoryFieldObject,
                                  hiddenFields:
                                      enrollmentFormState.hiddenFields,
                                  hiddenSections:
                                      enrollmentFormState.hiddenSections,
                                  isEditableMode:
                                      enrollmentFormState.isEditableMode,
                                  dataObject: enrollmentFormState.formState,
                                  onInputValueChange: onInputValueChange,
                                  unFilledMandatoryFields:
                                      unFilledMandatoryFields,
                                ),
                                Visibility(
                                  visible: enrollmentFormState.isEditableMode,
                                  child: EntryFormSaveButton(
                                    label: _isSaving
                                        ? currentLanguage == 'lesotho'
                                            ? 'E ntse e boloka lelapa ...'
                                            : 'Saving Household ...'
                                        : currentLanguage == 'lesotho'
                                            ? 'Boloka lelapa'
                                            : 'Save Household',
                                    labelColor: Colors.white,
                                    buttonColor: const Color(0xFF4B9F46),
                                    fontSize: 15.0,
                                    onPressButton: () => _isSaving
                                        ? null
                                        : onSaveForm(
                                            enrollmentFormState.formState,
                                            enrollmentFormState.hiddenFields,
                                          ),
                                  ),
                                )
                              ],
                            );
                          },
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
