import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_enrollment_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/models/dreams_service_prep_intake_short_form.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/prep_short_form/constants/prep_intake_short_form_constants.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/prep_short_form/skip_logics/agyw_dreams_prep_short_form_skip_logic.dart';
import 'package:provider/provider.dart';

class AgywDreamsPrepShortForm extends StatefulWidget {
  const AgywDreamsPrepShortForm({Key? key}) : super(key: key);
  @override
  State<AgywDreamsPrepShortForm> createState() =>
      _AgywDreamsPrepShortFormState();
}

class _AgywDreamsPrepShortFormState extends State<AgywDreamsPrepShortForm> {
  final String label = 'AGYW PrEP Form';
  List<FormSection>? formSections;
  List<FormSection>? defaultFormSections;
  late List<String> mandatoryFields;
  Map mandatoryFieldObject = {};
  bool isFormReady = false;
  bool isSaving = false;
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      setFormSections();
      for (String id in mandatoryFields) {
        mandatoryFieldObject[id] = true;
      }
      setState(() {
        isFormReady = true;
        evaluateSkipLogics();
      });
    });
  }

  void setMandatoryFields(Map<dynamic, dynamic> dataObject) {
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
  }

  setFormSections() {
    var agyw =
        Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
            .currentAgywDream!;
    defaultFormSections = DreamsPrepIntakeShortForm.getFormSections(
      firstDate: agyw.createdDate!,
    );
    mandatoryFields = DreamsPrepIntakeShortForm.getMandatoryField();
    if (agyw.enrollmentOuAccessible!) {
      formSections = defaultFormSections;
    } else {
      FormSection serviceProvisionForm =
          AppUtil.getServiceProvisionLocationSection(
        inputColor: AgywDreamsEnrollmentConstant.inputColor,
        labelColor: AgywDreamsEnrollmentConstant.labelColor,
        sectionLabelColor: AgywDreamsEnrollmentConstant.labelColor,
        allowedSelectedLevels: [
          AppHierarchyReference.communityLevel,
          AppHierarchyReference.facilityLevel
        ],
        program: AgywDreamsEnrollmentConstant.program,
      );
      formSections = [serviceProvisionForm, ...defaultFormSections!];
      mandatoryFields.addAll(
        FormUtil.getFormFieldIds(
          [serviceProvisionForm],
          includeLocationId: true,
        ),
      );
    }
    for (String fieldId in mandatoryFields) {
      mandatoryFieldObject[fieldId] = true;
    }
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await AgywDreamsPrepShortFormSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
        );
      },
    );
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
    AgywDream? agywDream, {
    hiddenFields = const {},
  }) async {
    setMandatoryFields(dataObject);
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections ?? [],
      ),
    );
    if (hadAllMandatoryFilled) {
      setState(() {
        isSaving = true;
      });
      String? eventDate = dataObject['eventDate'];
      String? eventId = dataObject['eventId'];
      List<String> hiddenFields = [];
      String orgUnit = dataObject['location'] ?? agywDream!.orgUnit;
      orgUnit = orgUnit.isEmpty ? agywDream!.orgUnit ?? '' : orgUnit;
      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          PrepIntakeShortFormConstants.program,
          PrepIntakeShortFormConstants.programStage,
          orgUnit,
          defaultFormSections!,
          dataObject,
          eventDate,
          agywDream!.id,
          eventId,
          hiddenFields,
        );
        Provider.of<ServiceEventDataState>(context, listen: false)
            .resetServiceEventDataState(agywDream.id);
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
          clearFormAutoSaveState(context, agywDream.id, eventId ?? '');
          Navigator.pop(context);
        });
      } catch (e) {
        Timer(const Duration(seconds: 1), () {
          setState(() {
            AppUtil.showToastMessage(
              message: e.toString(),
              position: ToastGravity.BOTTOM,
            );
          });
        });
      }
    } else {
      setState(() {
        unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
          mandatoryFields,
          dataObject,
          hiddenFields: Provider.of<ServiceFormState>(context, listen: false)
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

  void clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywDreamsPrEPShortFormPage}_${beneficiaryId}_$eventId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    var agyw =
        Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
            .currentAgywDream!;
    String? beneficiaryId = agyw.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String id =
        "${DreamsRoutesConstant.agywDreamsPrEPShortFormPage}_$beneficiaryId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: DreamsRoutesConstant.agywDreamsPrEPShortFormPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : DreamsRoutesConstant.agywDreamsPrEPShortFormNextPage
          : DreamsRoutesConstant.agywDreamsPrEPShortFormPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
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
          return Consumer<DreamsBeneficiarySelectionState>(
              builder: (context, nonAgywState, child) {
            AgywDream? agywDream = nonAgywState.currentAgywDream;
            return Consumer<ServiceFormState>(
                builder: (context, serviceFormState, child) {
              return Column(
                children: [
                  DreamsBeneficiaryTopHeader(
                    agywDream: agywDream,
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
                                hiddenFields: serviceFormState.hiddenFields,
                                hiddenSections: serviceFormState.hiddenSections,
                                formSections: formSections,
                                mandatoryFieldObject: mandatoryFieldObject,
                                isEditableMode: serviceFormState.isEditableMode,
                                dataObject: serviceFormState.formState,
                                onInputValueChange: onInputValueChange,
                                unFilledMandatoryFields:
                                    unFilledMandatoryFields,
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
                                buttonColor: const Color(0xFF258DCC),
                                fontSize: 15.0,
                                onPressButton: () => onSaveForm(context,
                                    serviceFormState.formState, agywDream,
                                    hiddenFields:
                                        serviceFormState.hiddenFields),
                              ),
                            )
                          ],
                        )
                ],
              );
            });
          });
        }),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
