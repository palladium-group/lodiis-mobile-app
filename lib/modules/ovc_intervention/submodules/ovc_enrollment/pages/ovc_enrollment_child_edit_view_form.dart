import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/core/components/Intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_enrollment_child_services.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/models/ovc_enrollment_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/skip_logics/ovc_child_enrollment_skip_logic.dart';
import 'package:provider/provider.dart';

class OvcEnrollmentChildEditViewForm extends StatefulWidget {
  const OvcEnrollmentChildEditViewForm({Key? key}) : super(key: key);

  @override
  _OvcEnrollmentChildEditViewFormState createState() =>
      _OvcEnrollmentChildEditViewFormState();
}

class _OvcEnrollmentChildEditViewFormState
    extends State<OvcEnrollmentChildEditViewForm> {
  List<FormSection>? formSections;
  final String label = 'Child vulnerability form';

  bool isSaving = false;
  bool isFormReady = false;

  late List<String> mandatoryFields;
  final Map mandatoryFieldObject = Map();
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    formSections = OvcEnrollmentChild.getFormSections();
    mandatoryFields = OvcEnrollmentChild.getMandatoryField();
    setState(() {
      for (String id in mandatoryFields) {
        mandatoryFieldObject[id] = true;
      }
      isFormReady = true;
      evaluateSkipLogics();
    });
  }

  evaluateSkipLogics() {
    Timer(
      Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<EnrollmentFormState>(context, listen: false).formState;
        await OvcChildEnrollmentSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
        );
      },
    );
  }

  void onSaveForm(BuildContext context, Map dataObject) async {
    bool hadAllMandatoryFilled =
        AppUtil.hasAllMandatoryFieldsFilled(mandatoryFields, dataObject);
    if (hadAllMandatoryFilled) {
      setState(() {
        isSaving = true;
      });
      dataObject['PN92g65TkVI'] = dataObject['PN92g65TkVI'] ?? 'Active';
      List<Map> childrenObjects = [];
      childrenObjects.add(dataObject);
      String? parentTrackedEntityInstance =
          dataObject['parentTrackedEntityInstance'];
      String? orgUnit = dataObject['orgUnit'];
      String? enrollmentDate = dataObject['enrollmentDate'];
      String? incidentDate = dataObject['incidentDate'];
      bool shouldEnroll = dataObject['trackedEntityInstance'] == null;
      List<String> hiddenFields = [
        BeneficiaryIdentification.beneficiaryId,
        BeneficiaryIdentification.beneficiaryIndex,
        'PN92g65TkVI',
      ];

      await OvcEnrollmentChildService().savingChildrenEnrollmentForms(
        parentTrackedEntityInstance,
        orgUnit,
        childrenObjects,
        enrollmentDate,
        incidentDate,
        shouldEnroll,
        hiddenFields,
      );

      Provider.of<OvcInterventionListState>(context, listen: false)
          .refreshOvcList();
      Timer(Duration(seconds: 1), () {
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
        unFilledMandatoryFields =
            AppUtil.getUnFilledMandatoryFields(mandatoryFields, dataObject);
      });
      AppUtil.showToastMessage(
          message: 'Please fill all mandatory field',
          position: ToastGravity.TOP);
    }
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
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
          body: Container(
            child: !isFormReady
                ? Column(
                    children: [
                      Center(
                        child: CircularProcessLoader(
                          color: Colors.blueGrey,
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        child: Consumer<OvcHouseholdCurrentSelectionState>(
                          builder: (context, ovcHouseholdCurrentSelectionState,
                              child) {
                            OvcHousehold? currentOvcHousehold =
                                ovcHouseholdCurrentSelectionState
                                    .currentOvcHousehold;
                            return OvcHouseholdInfoTopHeader(
                              currentOvcHousehold: currentOvcHousehold,
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 13.0,
                        ),
                        child: Consumer<LanguageTranslationState>(
                          builder: (context, languageTranslationState, child) {
                            String? currentLanguage =
                                languageTranslationState.currentLanguage;
                            return Consumer<EnrollmentFormState>(
                              builder: (context, enrollmentFormState, child) {
                                return Column(
                                  children: [
                                    Container(
                                      child: EntryFormContainer(
                                        hiddenFields:
                                            enrollmentFormState.hiddenFields,
                                        hiddenSections:
                                            enrollmentFormState.hiddenSections,
                                        hiddenInputFieldOptions:
                                            enrollmentFormState
                                                .hiddenInputFieldOptions,
                                        formSections: formSections,
                                        mandatoryFieldObject:
                                            mandatoryFieldObject,
                                        isEditableMode:
                                            enrollmentFormState.isEditableMode,
                                        dataObject:
                                            enrollmentFormState.formState,
                                        onInputValueChange: onInputValueChange,
                                        unFilledMandatoryFields:
                                            unFilledMandatoryFields,
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          enrollmentFormState.isEditableMode,
                                      child: EntryFormSaveButton(
                                        label: isSaving
                                            ? 'Saving ...'
                                            : currentLanguage == 'lesotho'
                                                ? 'Boloka'
                                                : 'Save',
                                        labelColor: Colors.white,
                                        buttonColor: Color(0xFF4B9F46),
                                        fontSize: 15.0,
                                        onPressButton: () => onSaveForm(
                                          context,
                                          enrollmentFormState.formState,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        bottomNavigationBar: InterventionBottomNavigationBarContainer(),
      ),
    );
  }
}
