import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/constants/program_status.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_enrollment_child_services.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/models/ovc_exit_case_transfer.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/child_exit_pages/constants/ovc_exit_case_transfer_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/skip_logics/ovc_case_transfer_skip_logic.dart';
import 'package:provider/provider.dart';

class OvcExitCaseTransferForm extends StatefulWidget {
  const OvcExitCaseTransferForm({Key? key}) : super(key: key);

  @override
  State<OvcExitCaseTransferForm> createState() =>
      _OvcExitCaseTransferFormState();
}

class _OvcExitCaseTransferFormState extends State<OvcExitCaseTransferForm>
    with OvcCaseTransferSkipLogic {
  final String label = 'Case Transfer';
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;
  Map mandatoryFieldObject = {};
  List<String> mandatoryFields = [];
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setFormSection();
  }

  void setFormSection() {
    OvcHouseholdChild? child =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild;
    formSections = OvcExitCaseTransfer.getFormSections(
      firstDate: child!.createdDate!,
    );
    mandatoryFields = [
      'eventDate',
      ...OvcExitCaseTransfer.getMandatoryFields()
    ];
    formSections = child.enrollmentOuAccessible!
        ? formSections
        : [
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
    for (String fieldId in mandatoryFields) {
      mandatoryFieldObject[fieldId] = true;
    }
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isFormReady = true;
        evaluateSkipLogics();
      });
    });
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await evaluateCaseTransferSkipLogics(
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
        "${OvcRoutesConstant.ovcTransferFormPage}_${beneficiaryId}_$eventId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    var ovc =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild!;
    String? beneficiaryId = ovc.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String eventId = dataObject['eventId'] ?? '';
    String id =
        "${OvcRoutesConstant.ovcTransferFormPage}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: OvcRoutesConstant.ovcTransferFormPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : OvcRoutesConstant.ovcTransferFormNextPage
          : OvcRoutesConstant.ovcTransferFormPage,
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
    OvcHouseholdChild? currentOvcHouseholdChild,
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
    if (hadAllMandatoryFilled) {
      setState(() {
        isSaving = true;
      });
      String? eventDate = dataObject['eventDate'];
      String? eventId = dataObject['eventId'];
      String programStatusId = 'PN92g65TkVI';
      String orgUnit =
          dataObject['location'] ?? currentOvcHouseholdChild?.orgUnit ?? '';
      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          OvcInterventionConstant.ovcProgramprogram,
          OvcExitCaseTransferConstant.programStage,
          orgUnit,
          formSections!,
          dataObject,
          eventDate,
          currentOvcHouseholdChild?.id ?? '',
          eventId,
          null,
        );
        await OvcEnrollmentChildService().updateOvcStatus(
          trackedEntityInstance: currentOvcHouseholdChild?.id ?? '',
          orgUnit: orgUnit,
          dataObject: {
            programStatusId: ProgramStatus.transferred,
          },
        );
        Provider.of<ServiceEventDataState>(context, listen: false)
            .resetServiceEventDataState(currentOvcHouseholdChild?.id ?? '');
        Provider.of<OvcInterventionListState>(context, listen: false)
            .refreshOvcList();
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .refetchCurrentHousehold();

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
              context, currentOvcHouseholdChild?.id ?? '', eventId ?? '');
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
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory field',
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
              String? currentLanguage =
                  languageTranslationState.currentLanguage;
              return Consumer<OvcHouseholdCurrentSelectionState>(
                builder: (context, ovcHouseholdCurrentSelectionState, child) {
                  OvcHouseholdChild? currentOvcHouseholdChild =
                      ovcHouseholdCurrentSelectionState
                          .currentOvcHouseholdChild;
                  return Consumer<ServiceFormState>(
                    builder: (context, serviceFormState, child) {
                      return Column(
                        children: [
                          const OvcChildInfoTopHeader(),
                          Container(
                            child: !isFormReady
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
                                        child: MaterialCard(
                                          body: EntryFormContainer(
                                            elevation: 0.0,
                                            hiddenFields: hiddenFields,
                                            hiddenSections: hiddenSections,
                                            formSections: formSections,
                                            mandatoryFieldObject:
                                                mandatoryFieldObject,
                                            unFilledMandatoryFields:
                                                unFilledMandatoryFields,
                                            dataObject:
                                                serviceFormState.formState,
                                            isEditableMode:
                                                serviceFormState.isEditableMode,
                                            onInputValueChange:
                                                onInputValueChange,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            serviceFormState.isEditableMode,
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
                                              currentOvcHouseholdChild),
                                        ),
                                      )
                                    ],
                                  ),
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
        bottomNavigationBar: const InterventionBottomNavigationBarContainer());
  }
}
