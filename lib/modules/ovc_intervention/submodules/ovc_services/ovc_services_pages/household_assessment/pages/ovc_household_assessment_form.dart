
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
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

import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_household_service_adult_wellbeing.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_household_assessment_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_assessment/skip_logics/ovc_household_assessment_skip_logic.dart';

import '../../../services/auto_case_plan_services.dart';

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

    final household =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold;

    if (household == null) {
      // defensive: no household context
      formSections = [];
      isFormReady = true;
      setState(() {});
      return;
    }

    formSections = OvcHouseholdServiceAdultWellbeing.getFormSections(
      firstDate: household.createdDate ?? '',
    );

    if (household.enrollmentOuAccessible != true) {
      formSections = [
        AppUtil.getServiceProvisionLocationSection(
          inputColor: const Color(0xFF4B9F46),
          labelColor: const Color(0xFF1A3518),
          sectionLabelColor: const Color(0xFF1A3518),
          formlabel: 'Location',
          allowedSelectedLevels: const [AppHierarchyReference.communityLevel],
          program: OvcInterventionConstant.ovcProgramprogram,
        ),
        ...formSections ?? [],
      ];
      mandatoryFields.add('location');
    }

    for (final fieldId in mandatoryFields) {
      mandatoryFieldObject[fieldId] = true;
    }

    // small delay so widgets mount before skip logic runs
    Timer(const Duration(milliseconds: 300), () {
      isFormReady = true;
      setState(() {});
      evaluateSkipLogics();
      updateHouseHoldCount();
    });
  }

  void evaluateSkipLogics() {
    Timer(const Duration(milliseconds: 100), () async {
      final adult =
          Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
              .currentOvcHousehold;
      final dataObject =
          Provider.of<ServiceFormState>(context, listen: false).formState;

      await OvchouseHoldAssessmentSkipLogic.evaluateSkipLogics(
        context,
        formSections ?? const [],
        dataObject,
        adult?.hivStatus,
        adult?.artStatus,
        adult?.sex,
        adult?.caregiverTestedForHiv,
        adult?.artInitiationDate,
        adult?.age,
      );
    });
  }

  void updateHouseHoldCount() {
    int total = 0;
    final household =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold;

    final attrs = household?.teiData?.attributes ?? const [];
    for (var a in attrs) {
      final id = a['attribute'];
      if (id == 'BXUNH6LXeGA' ||
          id == 'kQehaqmaygZ' ||
          id == 'rGAQnszNGVN' ||
          id == 'l9tcZ2TNgx6') {
        total += int.tryParse('${a['value'] ?? '0'}') ?? 0;
      }
    }
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('Eg1fUXWnFU4', total.toString());
  }

  void onInputValueChange(String id, dynamic value) {
    final form = Provider.of<ServiceFormState>(context, listen: false);
    form.setFormFieldState(id, value);
    if (id == 'ZuaV20IvVV2') {
      form.removeFieldFromState('kCuxe1Psh8E');
    }
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
  }

  Future<void> clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    final formAutoSaveId =
        "${OvcRoutesConstant.houseHoldAssessmentFormPage}_${beneficiaryId}_$eventId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  Future<void> onUpdateFormAutoSaveState(
      BuildContext context, {
        bool isSaveForm = false,
        String nextPageModule = "",
      }) async {
    final houseHold =
    Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
        .currentOvcHousehold!;
    final dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;

    final eventId = dataObject['eventId'] ?? '';
    final id =
        "${OvcRoutesConstant.houseHoldAssessmentFormPage}_${houseHold.id}_$eventId";
    final formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: houseHold.id,
      pageModule: OvcRoutesConstant.houseHoldAssessmentFormPage,
      nextPageModule: isSaveForm
          ? (nextPageModule.isNotEmpty
          ? nextPageModule
          : OvcRoutesConstant.houseHoldAssessmentFormNextPage)
          : OvcRoutesConstant.houseHoldAssessmentFormPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  Future<void> onSaveForm(
      BuildContext context,
      Map dataObject,
      OvcHousehold? currentOvcHousehold,
      ) async {
    // Validate
    final hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
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

    if (!hadAllMandatoryFilled) {
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
        position: ToastGravity.TOP,
      );
      return;
    }

    // Save assessment
    try {
      setState(() => isSaving = true);

      final teiId = currentOvcHousehold?.id ?? '';
      final orgUnit =
          dataObject['location'] ?? currentOvcHousehold?.orgUnit ?? '';
      final String? eventDate = dataObject['eventDate'];
      final String? eventId = dataObject['eventId'];

      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        OvcHouseholdAssessmentConstant.program,
        OvcHouseholdAssessmentConstant.programStage,
        orgUnit,
        formSections!,
        dataObject,
        eventDate,
        teiId,
        eventId,
        null,
        skippedFields: const [],
      );

      // 🔴 The key fix: create the Case Plan **now**, using the SAME date + ids we just saved
      // (Do not rely on a refresh to discover the just-saved assessment.)
      await AutoCasePlanService.saveFromAssessment(
        teiId: teiId,
        orgUnit: orgUnit,
        firstDate: currentOvcHousehold?.createdDate ?? '',
        assessmentData: dataObject,
        // these two props help AutoCasePlanService not depend on re-reads
      );

      // Refresh events so UI picks the new case plan immediately
     Provider.of<ServiceEventDataState>(context, listen: false).resetServiceEventDataState(teiId);


      // Wrap up UX
      final currentLanguage =
          Provider.of<LanguageTranslationState>(context, listen: false)
              .currentLanguage;
      AppUtil.showToastMessage(
        message: currentLanguage == 'lesotho'
            ? 'Fomo e bolokeile'
            : 'Form has been saved successfully',
        position: ToastGravity.TOP,
      );

      await clearFormAutoSaveState(context, teiId, dataObject['eventId'] ?? '');
      if (mounted) {
        setState(() => isSaving = false);
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => isSaving = false);
      AppUtil.showToastMessage(
        message: e.toString(),
        position: ToastGravity.BOTTOM,
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
            final InterventionCard activeInterventionProgram =
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
          builder: (context, languageTranslationState, _) {
            final currentLanguage = languageTranslationState.currentLanguage;
            return Consumer<OvcHouseholdCurrentSelectionState>(
              builder: (context, sel, __) {
                final currentOvcHousehold = sel.currentOvcHousehold;
                return Consumer<ServiceFormState>(
                  builder: (context, formState, __) {
                    return Column(
                      children: [
                        OvcHouseholdInfoTopHeader(
                          currentOvcHousehold: currentOvcHousehold,
                        ),
                        if (!isFormReady)
                          const CircularProcessLoader(color: Colors.blueGrey)
                        else
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 13.0,
                                  right: 13.0,
                                ),
                                child: EntryFormContainer(
                                  hiddenSections: formState.hiddenSections,
                                  hiddenFields: formState.hiddenFields,
                                  hiddenInputFieldOptions:
                                  formState.hiddenInputFieldOptions,
                                  formSections: formSections,
                                  mandatoryFieldObject: mandatoryFieldObject,
                                  unFilledMandatoryFields:
                                  unFilledMandatoryFields,
                                  dataObject: formState.formState,
                                  isEditableMode: formState.isEditableMode,
                                  onInputValueChange: onInputValueChange,
                                ),
                              ),
                              Visibility(
                                visible: formState.isEditableMode,
                                child: EntryFormSaveButton(
                                  label: isSaving
                                      ? (currentLanguage == 'lesotho'
                                      ? 'E ntse e boloka...'
                                      : 'Saving ...')
                                      : (currentLanguage == 'lesotho'
                                      ? 'Boloka'
                                      : 'Save'),
                                  labelColor: Colors.white,
                                  buttonColor: const Color(0xFF4B9F46),
                                  fontSize: 15.0,
                                  onPressButton: () => onSaveForm(
                                    context,
                                    formState.formState,
                                    currentOvcHousehold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
