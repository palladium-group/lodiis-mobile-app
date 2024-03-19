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
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/components/add_child_confirmation.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/components/enrolled_children_list.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/components/ovc_enrollment_form_saving_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/models/ovc_enrollment_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/skip_logics/ovc_child_enrollment_skip_logic.dart';
import 'package:provider/provider.dart';

class OvcEnrollmentChildFormContainer extends StatefulWidget {
  const OvcEnrollmentChildFormContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<OvcEnrollmentChildFormContainer> createState() =>
      _OvcEnrollmentChildFormContainerState();
}

class _OvcEnrollmentChildFormContainerState
    extends State<OvcEnrollmentChildFormContainer> {
  List<FormSection> formSections = [];
  final List<Map> childrenMapObjects = [];
  List unFilledMandatoryFields = [];
  Map childrenMapObject = {};
  Map hiddenFields = {};
  Map hiddenSections = {};
  Map hiddenInputFieldOptions = {};
  String lastUpdatedId = '';
  bool _isFormReady = false;
  bool _isSaving = false;
  final List<String> mandatoryFields = OvcEnrollmentChild.getMandatoryField();
  final Map mandatoryFieldObject = {};

  @override
  void initState() {
    super.initState();
    _assignChildrenOnAutoSaving();
    _resetSkipLogicAndFormStateObjects();
    _setFormState();
    _evaluateSkipLogics();
  }

  _resetSkipLogicAndFormStateObjects() {
    unFilledMandatoryFields = [];
    childrenMapObject.clear();
    hiddenFields.clear();
    hiddenSections.clear();
    hiddenInputFieldOptions.clear();
    lastUpdatedId = '';
    Map caregiverDataObject =
        Provider.of<EnrollmentFormState>(context, listen: false).formState;
    childrenMapObject['enrollmentDate'] =
        caregiverDataObject['enrollmentDate'] ?? '';
  }

  _evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () {
        Map caregiverDataObject =
            Provider.of<EnrollmentFormState>(context, listen: false).formState;
        caregiverDataObject.remove('children');
        Map resultResponse = OvcChildEnrollmentSkipLogic.evaluateSkipLogics(
          context,
          formSections,
          childrenMapObject,
          shouldSetEnrollmentState: false,
          caregiverDataObject: caregiverDataObject,
        );
        hiddenFields = resultResponse['hiddenFields'] ?? {};
        hiddenSections = resultResponse['hiddenSections'] ?? {};
        hiddenInputFieldOptions =
            resultResponse['hiddenInputFieldOptions'] ?? {};
        Map assignedFields = resultResponse['assignedFields'] ?? {};
        for (String key in assignedFields.keys) {
          childrenMapObject[key] = assignedFields[key];
        }
        for (String key in hiddenFields.keys) {
          childrenMapObject[key] = null;
        }
        setState(() {});
      },
    );
  }

  _setFormState() {
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
    }
    formSections = OvcEnrollmentChild.getFormSections(
      isEnrolmentDateEditable: false,
      enrollmentDate: childrenMapObject['enrollmentDate'],
    );
    _isFormReady = true;
    setState(() {});
  }

  void _assignChildrenOnAutoSaving() {
    try {
      Map dataObject =
          Provider.of<EnrollmentFormState>(context, listen: false).formState;
      for (Map childMapObject in dataObject["children"]) {
        childrenMapObjects.add(childMapObject);
      }
    } catch (e) {
      //
    }
  }

  bool _isADuplicateChildObject(Map childrenMapObject) {
    bool isDuplicate = false;
    for (var child in childrenMapObjects) {
      if (child['WTZ7GLTrE8Q'] == childrenMapObject['WTZ7GLTrE8Q']) {
        isDuplicate = true;
      }
    }
    return isDuplicate;
  }

  void onInputValueChange(String id, dynamic value) {
    if (id == 'enrollmentDate') {
      String previousEnrollmentDate = childrenMapObject['enrollmentDate'] ?? '';
      if (previousEnrollmentDate != value) {
        String dobId = 'qZP982qpSPS';
        childrenMapObject[dobId] = '';
      }
    }
    childrenMapObject[id] = value;
    lastUpdatedId = id;
    setState(() {});
    _evaluateSkipLogics();
  }

  void onSaveAndContinue(BuildContext context) async {
    unFilledMandatoryFields = [];
    setState(() {});
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      childrenMapObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections,
      ),
    );
    if (hadAllMandatoryFilled) {
      bool isDuplicatedChild = _isADuplicateChildObject(childrenMapObject);
      String childName = childrenMapObject['WTZ7GLTrE8Q'] ?? '';
      if (isDuplicatedChild) {
        AppUtil.showToastMessage(
          message: 'Child with  name $childName have already been added',
          position: ToastGravity.TOP,
        );
      } else {
        Widget modal = AddChildConfirmation(name: childName);
        bool shouldAddAnotherChild =
            await AppUtil.showPopUpModal(context, modal, false);
        if (shouldAddAnotherChild) {
          await _onUpdatingChildrenMapObjectsState(
              context, {...childrenMapObject});
          Timer(const Duration(milliseconds: 100), () {
            _resetSkipLogicAndFormStateObjects();
            setState(() {});
          });
        } else {
          await _onUpdatingChildrenMapObjectsState(
            context,
            {...childrenMapObject},
            shouldSaveForm: true,
          );
        }
      }
    } else {
      unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
        mandatoryFields,
        childrenMapObject,
        hiddenFields: hiddenFields,
        checkBoxInputFields: FormUtil.getInputFieldByValueType(
          valueType: 'CHECK_BOX',
          formSections: formSections,
        ),
      );
      setState(() {});
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
        position: ToastGravity.TOP,
      );
    }
  }

  Future _onUpdatingChildrenMapObjectsState(
    BuildContext context,
    Map dataObject, {
    bool shouldSaveForm = false,
  }) async {
    CurrentUser? user = await UserService().getCurrentUser();
    dataObject['PN92g65TkVI'] = 'Active';
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
    dataObject['fullName'] =
        '${dataObject['WTZ7GLTrE8Q']} ${dataObject['rSP9c21JsfC']}';
    childrenMapObjects.add(dataObject);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('children', childrenMapObjects);
    _onUpdateFormAutoSaveState(context, isSaveForm: shouldSaveForm);
    if (shouldSaveForm) {
      _isSaving = true;
      setState(() {});
    }
  }

  void _onUpdateFormAutoSaveState(
    BuildContext context, {
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
      pageModule: OvcRoutesConstant.ovcChildEditFormPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : OvcRoutesConstant.ovcChildRegisterFormNextPage
          : OvcRoutesConstant.ovcChildRegisterFormPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer<LanguageTranslationState>(
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
                      ? 'Foromo ea ngoliso ea ngoana'
                      : 'Child Registration form',
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
              child: !_isFormReady
                  ? const Center(
                      child: CircularProcessLoader(color: Colors.blueGrey),
                    )
                  : _isSaving
                      ? const OvcEnrollementFormSavingContaniner()
                      : Column(
                          children: [
                            childrenMapObjects.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12.0,
                                    ),
                                    child: EnrolledChildrenList(
                                      childrenList:
                                          childrenMapObjects.map((child) {
                                        String fullName =
                                            child['fullName'] ?? '';
                                        return fullName;
                                      }).toList(),
                                    ),
                                  )
                                : Container(),
                            EntryFormContainer(
                              formSections: formSections,
                              hiddenFields: hiddenFields,
                              lastUpdatedId: lastUpdatedId,
                              hiddenSections: hiddenSections,
                              hiddenInputFieldOptions: hiddenInputFieldOptions,
                              mandatoryFieldObject: mandatoryFieldObject,
                              dataObject: childrenMapObject,
                              onInputValueChange: onInputValueChange,
                              unFilledMandatoryFields: unFilledMandatoryFields,
                            ),
                            EntryFormSaveButton(
                              label: languageTranslationState.isSesothoLanguage
                                  ? 'Boloka ebe u fetela pele'
                                  : 'Save and Continue',
                              labelColor: Colors.white,
                              buttonColor: const Color(0xFF4B9F46),
                              fontSize: 15.0,
                              onPressButton: () => onSaveAndContinue(context),
                            ),
                          ],
                        ),
            ),
          ),
          bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
        );
      },
    ));
  }
}
