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
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/models/household_graduation_rediness_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/household_exit_pages/household_graduation/constants/ovc_household_graduation_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/household_exit_pages/skip_logics/ovc_household_case_plan_achievement_skip_logic.dart';
import 'package:provider/provider.dart';

class OvcHouseholdGraduationForm extends StatefulWidget {
  const OvcHouseholdGraduationForm({Key? key}) : super(key: key);

  @override
  State<OvcHouseholdGraduationForm> createState() =>
      _OvcHouseholdGraduationFormState();
}

class _OvcHouseholdGraduationFormState
    extends State<OvcHouseholdGraduationForm> {
  final String label = 'Household Case Plan Graduation Readiness';
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;
  Map mandatoryFieldObject = {};
  List<String> mandatoryFields = [];
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setFromSection();
  }

  int? _parseAgeInYears(dynamic value) {
    final raw = '$value'.trim();
    if (raw.isEmpty || raw == 'null') return null;

    final directAge = int.tryParse(raw);
    if (directAge != null) return directAge;

    final match = RegExp(r'\d+').firstMatch(raw);
    if (match == null) return null;

    return int.tryParse(match.group(0) ?? '');
  }

  bool _isYes(dynamic value) {
    final raw = '$value'.trim().toLowerCase();
    return raw == 'yes' || raw == 'true' || raw == '1';
  }

  bool _isFemale(dynamic value) {
    final raw = '$value'.trim().toLowerCase();
    return raw == 'female' || raw == 'f';
  }

  bool _hasAdolescentAged10To17(OvcHousehold household) {
    return (household.children ?? []).any((child) {
      final age = _parseAgeInYears(child.age);
      return age != null && age >= 10 && age <= 17;
    });
  }

  bool _hasChildUnder5(OvcHousehold household) {
    return (household.children ?? []).any((child) {
      final age = _parseAgeInYears(child.age);
      return age != null && age < 5;
    });
  }

  bool _isCaregiverPregnant(OvcHousehold household) {
    if (!_isFemale(household.sex)) return false;

    final attributes = household.teiData?.attributes ?? [];

    for (final attribute in attributes) {
      if (attribute is! Map) continue;

      final attributeId = '${attribute['attribute']}'.trim();
      final value = '${attribute['value']}'.trim();

      if (attributeId == 'XYPRtYgQUF8' && _isYes(value)) {
        return true;
      }
    }

    return false;
  }

  bool _hasPregnantAdolescentOrWoman(OvcHousehold household) {
    final hasPregnantChildOrAdolescent = (household.children ?? []).any(
          (child) => child.isPregnant || _isYes(child.pregnancyStatus),
    );

    return hasPregnantChildOrAdolescent || _isCaregiverPregnant(household);
  }

  bool _hasHeiInHousehold(OvcHousehold household) {
    return (household.children ?? []).any((child) => child.isHei == true);
  }

  void _setCparaSkipPatternState({
    required bool hasAdolescentAged10To17,
    required bool hasChildUnder5,
    required bool hasPmtctTarget,
    required bool shouldSkipPmtctHivTestQuestion,
  }) {
    final serviceFormState =
    Provider.of<ServiceFormState>(context, listen: false);

    serviceFormState.setFormFieldState(
      HouseholdGraduationReadinessForm.cparaHasAdolescentAged10To17,
      '$hasAdolescentAged10To17',
    );

    serviceFormState.setFormFieldState(
      HouseholdGraduationReadinessForm.cparaHasChildUnder5,
      '$hasChildUnder5',
    );

    serviceFormState.setFormFieldState(
      HouseholdGraduationReadinessForm.cparaHasPmtctTarget,
      '$hasPmtctTarget',
    );

    serviceFormState.setFormFieldState(
      HouseholdGraduationReadinessForm.cparaSkipPmtctHivTestQuestion,
      '$shouldSkipPmtctHivTestQuestion',
    );

    if (!hasAdolescentAged10To17) {
      serviceFormState.setFormFieldState(
        HouseholdGraduationReadinessForm.bm3MetId,
        'true',
      );
    }

    if (!hasChildUnder5) {
      serviceFormState.setFormFieldState(
        HouseholdGraduationReadinessForm.bm4MetId,
        'true',
      );
    }

    if (!hasPmtctTarget) {
      serviceFormState.setFormFieldState(
        HouseholdGraduationReadinessForm.bm5MetId,
        'true',
      );
    }
  }

  setFromSection() {
    OvcHousehold? household =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold;

    if (household == null) return;

    final hasAdolescentAged10To17 = _hasAdolescentAged10To17(household);
    final hasChildUnder5 = _hasChildUnder5(household);
    final hasHeiInHousehold = _hasHeiInHousehold(household);
    final hasPregnantAdolescentOrWoman =
    _hasPregnantAdolescentOrWoman(household);

    final hasPmtctTarget = hasPregnantAdolescentOrWoman || hasHeiInHousehold;
    final shouldSkipPmtctHivTestQuestion = hasHeiInHousehold;

    formSections = HouseholdGraduationReadinessForm.getFormSections(
      firstDate: household.createdDate ??
          DateTime.now().toIso8601String().substring(0, 10),
      hasAdolescentAged10To17: hasAdolescentAged10To17,
      hasChildUnder5: hasChildUnder5,
      hasPmtctTarget: hasPmtctTarget,
      shouldSkipPmtctHivTestQuestion: shouldSkipPmtctHivTestQuestion,
    );

    _setCparaSkipPatternState(
      hasAdolescentAged10To17: hasAdolescentAged10To17,
      hasChildUnder5: hasChildUnder5,
      hasPmtctTarget: hasPmtctTarget,
      shouldSkipPmtctHivTestQuestion: shouldSkipPmtctHivTestQuestion,
    );

    mandatoryFields = ['eventDate'];

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
      addCaregiverAttributesNeededForGraduation(household);

      _setCparaSkipPatternState(
        hasAdolescentAged10To17: hasAdolescentAged10To17,
        hasChildUnder5: hasChildUnder5,
        hasPmtctTarget: hasPmtctTarget,
        shouldSkipPmtctHivTestQuestion: shouldSkipPmtctHivTestQuestion,
      );

      setState(() {});
      isFormReady = true;
      evaluateSkipLogics();
    });
  }

  void addCaregiverAttributesNeededForGraduation(OvcHousehold ovcHousehold) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('hivStatus', ovcHousehold.hivStatus);
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
          () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;

        await OvcHouseholdCasePlanAchievementSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
        );
      },
    );
  }

  void clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    String formAutoSaveId =
        "${OvcRoutesConstant.householdGraduationFormPage}_${beneficiaryId}_$eventId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState(
      BuildContext context, {
        bool isSaveForm = false,
        String nextPageModule = "",
      }) async {
    var ovc =
    Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
        .currentOvcHousehold!;

    String? beneficiaryId = ovc.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String eventId = dataObject['eventId'] ?? '';
    String id =
        "${OvcRoutesConstant.householdGraduationFormPage}_${beneficiaryId}_$eventId";

    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: OvcRoutesConstant.householdGraduationFormPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
          ? nextPageModule
          : OvcRoutesConstant.householdGraduationFormNextPage
          : OvcRoutesConstant.householdGraduationFormPage,
      data: jsonEncode(dataObject),
    );

    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
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
      isSaving = true;
      setState(() {});

      String? eventDate = dataObject['eventDate'];
      String? eventId = dataObject['eventId'];
      String orgUnit =
          dataObject['location'] ?? currentOvcHousehold?.orgUnit ?? '';

      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          OvcInterventionConstant.caregiverProgram,
          OvcHouseholdGraduationConstant.programStage,
          orgUnit,
          formSections!,
          dataObject,
          eventDate,
          currentOvcHousehold?.id ?? '',
          eventId,
          null,
        );

        Provider.of<ServiceEventDataState>(context, listen: false)
            .resetServiceEventDataState(currentOvcHousehold?.id ?? '');

        Timer(const Duration(seconds: 1), () {
          isSaving = false;
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

          clearFormAutoSaveState(
              context, currentOvcHousehold?.id ?? '', eventId ?? '');

          Navigator.pop(context);
        });
      } catch (e) {
        Timer(const Duration(seconds: 1), () {
          isSaving = false;
          AppUtil.showToastMessage(
              message: e.toString(), position: ToastGravity.BOTTOM);
          Navigator.pop(context);
          setState(() {});
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
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Consumer<LanguageTranslationState>(
          builder: (context, languageTranslationState, child) {
            String? currentLanguage = languageTranslationState.currentLanguage;

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
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 13.0),
                          child: !isFormReady
                              ? const CircularProcessLoader(
                            color: Colors.blueGrey,
                          )
                              : Column(
                            children: [
                              EntryFormContainer(
                                hiddenFields:
                                serviceFormState.hiddenFields,
                                hiddenSections:
                                serviceFormState.hiddenSections,
                                formSections: formSections,
                                unFilledMandatoryFields:
                                unFilledMandatoryFields,
                                mandatoryFieldObject:
                                mandatoryFieldObject,
                                dataObject: serviceFormState.formState,
                                isEditableMode:
                                serviceFormState.isEditableMode,
                                onInputValueChange: onInputValueChange,
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
                          ),
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
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}