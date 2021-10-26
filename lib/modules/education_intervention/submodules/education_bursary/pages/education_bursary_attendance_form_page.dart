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
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/Intervention_bottom_navigation_bar_container.dart';
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
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/education_bursary_attendance_form.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/skip_logics/education_bursary_attendance_skip_logic.dart';
import 'package:provider/provider.dart';

class EducationBursaryAttendanceFormPage extends StatefulWidget {
  const EducationBursaryAttendanceFormPage(
      {Key? key, this.isSchoolAttendance = false})
      : super(key: key);
  final bool isSchoolAttendance;

  @override
  _EducationBursaryAttendanceFormPageState createState() =>
      _EducationBursaryAttendanceFormPageState();
}

class _EducationBursaryAttendanceFormPageState
    extends State<EducationBursaryAttendanceFormPage> {
  final String schoolAttendanceLabel = 'School Attendance Form';
  final String clubsAttendanceLabel = 'Clubs Attendance Form';
  List<FormSection>? formSections;
  final List<String> mandatoryFields =
      EducationBursaryAttendanceForm.getMandatoryField();
  final Map mandatoryFieldObject = Map();
  List unFilledMandatoryFields = [];
  bool isFormReady = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    formSections = EducationBursaryAttendanceForm.getFormSections();
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
    }
    Timer(Duration(seconds: 1), () {
      setState(() {
        isFormReady = true;
        evaluateSkipLogics();
      });
    });
  }

  evaluateSkipLogics() {
    Timer(
      Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await EducationBursaryAttendanceSKipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
        );
      },
    );
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    EducationBeneficiary bursaryBeneficiary,
  ) async {
    setState(() {
      isSaving = true;
    });
    bool hasAllMandatoryFilled =
        AppUtil.hasAllMandatoryFieldsFilled(mandatoryFields, dataObject);
    if (FormUtil.geFormFilledStatus(dataObject, formSections)) {
      if (hasAllMandatoryFilled) {
        String? eventDate = dataObject['eventDate'];
        String? eventId = dataObject['eventId'];
        List<String> hiddenFields = [];

        String programStage = widget.isSchoolAttendance
            ? BursaryInterventionConstant.schoolAttendanceProgramStage
            : BursaryInterventionConstant.clubsAttendanceProgramStage;
        String program = BursaryInterventionConstant.program;

        try {
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
              program,
              programStage,
              bursaryBeneficiary.orgUnit,
              formSections!,
              dataObject,
              eventDate,
              bursaryBeneficiary.id,
              eventId,
              hiddenFields);
          Provider.of<ServiceEventDataState>(context, listen: false)
              .resetServiceEventDataState(bursaryBeneficiary.id);
          Timer(Duration(seconds: 1), () {
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
            clearFormAutoSaveState(
                context, bursaryBeneficiary.id, eventId ?? "");
            Navigator.pop(context);
          });
        } catch (e) {
          print(e);
          Timer(Duration(seconds: 1), () {
            setState(() {
              AppUtil.showToastMessage(
                  message: e.toString(), position: ToastGravity.BOTTOM);
            });
          });
        }
      } else {
        setState(() {
          unFilledMandatoryFields =
              AppUtil.getUnFilledMandatoryFields(mandatoryFields, dataObject);
        });
        AppUtil.showToastMessage(
            message: 'Please fill all mandatory field',
            position: ToastGravity.TOP);
      }
    } else {
      AppUtil.showToastMessage(
          message: 'Please fill at least one form field',
          position: ToastGravity.TOP);
    }
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = "",
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
        "${widget.isSchoolAttendance ? BursaryRoutesConstant.schoolsAttendancePageModule : BursaryRoutesConstant.clubsAttendancePageModule}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: BursaryRoutesConstant.clubsAttendancePageModule,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : widget.isSchoolAttendance
                  ? BursaryRoutesConstant.schoolsAttendanceNextPageModule
                  : BursaryRoutesConstant.clubsAttendanceNextPageModule
          : widget.isSchoolAttendance
              ? BursaryRoutesConstant.schoolsAttendancePageModule
              : BursaryRoutesConstant.clubsAttendancePageModule,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    String formAutoSaveId =
        "${widget.isSchoolAttendance ? BursaryRoutesConstant.schoolsAttendancePageModule : BursaryRoutesConstant.clubsAttendancePageModule}_${beneficiaryId}_$eventId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
          child: Consumer<InterventionCardState>(
            builder: (context, interventionCardState, child) {
              InterventionCard activeInterventionProgram =
                  interventionCardState.currentInterventionProgram;
              return SubPageAppBar(
                label: widget.isSchoolAttendance
                    ? schoolAttendanceLabel
                    : clubsAttendanceLabel,
                activeInterventionProgram: activeInterventionProgram,
              );
            },
          ),
        ),
        body: SubPageBody(
          body: Container(child: Consumer<LanguageTranslationState>(
            builder: (context, languageTranslationState, child) {
              String? currentLanguage =
                  languageTranslationState.currentLanguage;

              return Consumer<EducationInterventionCurrentSelectionState>(
                builder: (context, educationInterventionCurrentSelectionState,
                    child) {
                  return Consumer<ServiceFormState>(
                    builder: (context, serviceFormState, child) {
                      EducationBeneficiary? bursaryBeneficiary =
                          educationInterventionCurrentSelectionState
                              .currentBeneficiciary;
                      return Container(
                        child: Column(
                          children: [
                            EducationBeneficiaryTopHeader(
                              educationBeneficiary: bursaryBeneficiary!,
                            ),
                            Container(
                              child: !isFormReady
                                  ? Container(
                                      child: CircularProcessLoader(
                                        color: Colors.blueGrey,
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
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
                                            dataObject:
                                                serviceFormState.formState,
                                            onInputValueChange:
                                                onInputValueChange,
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              serviceFormState.isEditableMode,
                                          child: EntryFormSaveButton(
                                            label: isSaving
                                                ? 'Saving ...'
                                                : currentLanguage == 'lesotho'
                                                    ? 'Boloka'
                                                    : 'Save',
                                            labelColor: Colors.white,
                                            buttonColor: Color(0xFF009688),
                                            fontSize: 15.0,
                                            onPressButton: () => isSaving
                                                ? null
                                                : onSaveForm(
                                                    context,
                                                    serviceFormState.formState,
                                                    bursaryBeneficiary,
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          )),
        ),
        bottomNavigationBar: InterventionBottomNavigationBarContainer());
  }
}
