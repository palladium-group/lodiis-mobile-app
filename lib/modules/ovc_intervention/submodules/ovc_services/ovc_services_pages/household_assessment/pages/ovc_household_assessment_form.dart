import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_household_service_adult_wellbeing.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_household_assessment_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_assessment/skip_logics/ovc_household_assessment_skip_logic.dart';
import 'package:provider/provider.dart';

class OvcHouseholdAssessmentForm extends StatefulWidget {
  const OvcHouseholdAssessmentForm({Key? key}) : super(key: key);

  @override
  State<OvcHouseholdAssessmentForm> createState() =>
      _OvcHouseholdAssessmentFormState();
}

class _OvcHouseholdAssessmentFormState
    extends State<OvcHouseholdAssessmentForm> {
  final String label = 'Household Assessment Form';
  final String translatedName = 'Foromo ea hlahlobo ea lelapa';
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;
  Map mandatoryFieldObject = {};
  List<String> mandatoryFields = [];
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setFormSections();
  }

  void setFormSections() {
    mandatoryFields = [
      'eventDate',
      ...OvcHouseholdServiceAdultWellbeing.getMandatoryFields()
    ];
    OvcHousehold? household =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold;
    formSections = OvcHouseholdServiceAdultWellbeing.getFormSections(
      firstDate: household!.createdDate!,
    );
    if (household.enrollmentOuAccessible != true) {
      formSections = [
        AppUtil.getServiceProvisionLocationSection(
          inputColor: const Color(0xFF4B9F46),
          labelColor: const Color(0xFF1A3518),
          sectionLabelColor: const Color(0xFF1A3518),
          formlabel: 'Location',
          allowedSelectedLevels: [
            AppHierarchyReference.communityLevel,
          ],
          program: OvcInterventionConstant.ovcProgramprogram,
        ),
        ...formSections ?? []
      ];
      mandatoryFields.add('location');
    }
    for (String fieldId in mandatoryFields) {
      mandatoryFieldObject[fieldId] = true;
    }
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isFormReady = true;
        evaluateSkipLogics();
        updateHouseHoldCount();
      });
    });
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        OvcHousehold? adult = Provider.of<OvcHouseholdCurrentSelectionState>(
                context,
                listen: false)
            .currentOvcHousehold;
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;

        await OvchouseHoldAssessmentSkipLogic.evaluateSkipLogics(
            context, formSections!, dataObject, adult?.hivStatus);
      },
    );
  }

  void updateHouseHoldCount() {
    int totalHouseHoldCount = 0;
    for (var attributeObject in Provider.of<OvcHouseholdCurrentSelectionState>(
            context,
            listen: false)
        .currentOvcHousehold!
        .teiData!
        .attributes) {
      if (attributeObject['attribute'] == 'BXUNH6LXeGA' ||
          attributeObject['attribute'] == 'kQehaqmaygZ' ||
          attributeObject['attribute'] == 'rGAQnszNGVN' ||
          attributeObject['attribute'] == 'l9tcZ2TNgx6') {
        totalHouseHoldCount += int.parse((attributeObject['value']) ?? '0');
      }
    }
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('Eg1fUXWnFU4', totalHouseHoldCount.toString());
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    if (id == 'ZuaV20IvVV2') {
      Provider.of<ServiceFormState>(context, listen: false)
          .removeFieldFromState('kCuxe1Psh8E');
    }
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
  }

  void clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    String formAutoSaveId =
        "${OvcRoutesConstant.houseHoldAssessmentFormPage}_${beneficiaryId}_$eventId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    var houseHold =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold!;
    String? beneficiaryId = houseHold.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String eventId = dataObject['eventId'] ?? '';
    String id =
        "${OvcRoutesConstant.houseHoldAssessmentFormPage}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: OvcRoutesConstant.houseHoldAssessmentFormPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : OvcRoutesConstant.houseHoldAssessmentFormNextPage
          : OvcRoutesConstant.houseHoldAssessmentFormPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    OvcHousehold? currentOvcHousehold,
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
    if (hadAllMandatoryFilled) {
      setState(() {
        isSaving = true;
      });
      String? eventDate = dataObject['eventDate'];
      String? eventId = dataObject['eventId'];
      String orgUnit =
          dataObject['location'] ?? currentOvcHousehold?.orgUnit ?? '';
      List<String> skippedFields = [];
      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          OvcHouseholdAssessmentConstant.program,
          OvcHouseholdAssessmentConstant.programStage,
          orgUnit,
          formSections!,
          dataObject,
          eventDate,
          currentOvcHousehold?.id ?? '',
          eventId,
          null,
          skippedFields: skippedFields,
        );
        Provider.of<ServiceEventDataState>(context, listen: false)
            .resetServiceEventDataState(currentOvcHousehold?.id ?? '');
        Timer(const Duration(seconds: 1), () {
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
              context, currentOvcHousehold?.id ?? '', eventId ?? '');
          Navigator.pop(context);
        });
      } catch (e) {
        Timer(const Duration(seconds: 1), () {
          setState(() {
            isSaving = false;
            AppUtil.showToastMessage(
                message: e.toString(), position: ToastGravity.BOTTOM);
            Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          body: Consumer<LanguageTranslationState>(
            builder: (context, languageTranslationState, child) {
              String? currentLanguage =
                  languageTranslationState.currentLanguage;
              return Consumer<OvcHouseholdCurrentSelectionState>(
                builder: (context, ovcHouseholdCurrentSelectionState, child) {
                  var currentOvcHousehold =
                      ovcHouseholdCurrentSelectionState.currentOvcHousehold;
                  return Consumer<ServiceFormState>(
                    builder: (context, serviceFormState, child) {
                      return Column(
                        children: [
                          OvcHouseholdInfoTopHeader(
                            currentOvcHousehold: currentOvcHousehold,
                          ),
                          !isFormReady
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
                                        hiddenSections:
                                            serviceFormState.hiddenSections,
                                        hiddenFields:
                                            serviceFormState.hiddenFields,
                                        hiddenInputFieldOptions:
                                            serviceFormState
                                                .hiddenInputFieldOptions,
                                        formSections: formSections,
                                        mandatoryFieldObject:
                                            mandatoryFieldObject,
                                        unFilledMandatoryFields:
                                            unFilledMandatoryFields,
                                        dataObject: serviceFormState.formState,
                                        isEditableMode:
                                            serviceFormState.isEditableMode,
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
                                        buttonColor: const Color(0xFF4B9F46),
                                        fontSize: 15.0,
                                        onPressButton: () => onSaveForm(
                                          context,
                                          serviceFormState.formState,
                                          currentOvcHousehold,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: const InterventionBottomNavigationBarContainer());
  }
}
