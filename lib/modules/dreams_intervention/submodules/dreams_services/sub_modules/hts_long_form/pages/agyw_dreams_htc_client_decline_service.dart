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
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/models/hts_decline_service.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/skip_logics/agyw_dreams_htc_service_decline.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/prep/constants/prep_intake_constant.dart';
import 'package:provider/provider.dart';

class AgywDreamsHTSClientServices extends StatefulWidget {
  const AgywDreamsHTSClientServices({Key? key, this.isComingFromPrep})
      : super(key: key);
  final bool? isComingFromPrep;

  @override
  State<AgywDreamsHTSClientServices> createState() =>
      _AgywDreamsHTSClientInformationServiceState();
}

class _AgywDreamsHTSClientInformationServiceState
    extends State<AgywDreamsHTSClientServices> {
  final String label = 'Client Service'; //Initially Client Information
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;
  bool? isComingFromPrep;
  Map mandatoryFieldObject = {};
  List<String> mandatoryFields = HTSConsentDeclineService.mandatoryField;

  @override
  void initState() {
    super.initState();
    isComingFromPrep = widget.isComingFromPrep;
    formSections = HTSConsentDeclineService.getFormSections();
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
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
        await AgywDreamsHTCServiceDecline.evaluateSkipLogics(
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
          PrepIntakeConstant.program,
          PrepIntakeConstant.programStage,
          orgUnit,
          formSections!,
          dataObject,
          eventDate,
          agywDream!.id,
          eventId,
          hiddenFields,
        );
        Provider.of<ServiceEventDataState>(context, listen: false)
            .resetServiceEventDataState(agywDream.id);
        Timer(const Duration(seconds: 1), () async {
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
          clearFormAutoSaveState(context);
          Navigator.popUntil(context, (route) => route.isFirst);
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
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory field',
        position: ToastGravity.TOP,
      );
    }
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    AgywDream agywDream =
        Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
            .currentAgywDream!;
    String? beneficiaryId = agywDream.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String id =
        "${isComingFromPrep! ? DreamsRoutesConstant.agywDreamsPrEPHTSConsentPage : ''}_$beneficiaryId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: DreamsRoutesConstant.agywDreamsPrEPHTSClientInformationPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : DreamsRoutesConstant.agywDreamsPrEPHTSClientInformationNextPage
          : DreamsRoutesConstant.agywDreamsPrEPHTSClientInformationPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  void clearFormAutoSaveState(BuildContext context) async {
    AgywDream agywDream =
        Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
            .currentAgywDream!;
    String? beneficiaryId = agywDream.id;
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywDreamsPrEPHTSConsentPage}_$beneficiaryId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
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
                  label: label,
                  activeInterventionProgram: activeInterventionProgram,
                );
              },
            ),
          ),
          body: SubPageBody(
            body: Consumer<DreamsBeneficiarySelectionState>(
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
                                      formSections: formSections,
                                      hiddenFields:
                                          serviceFormState.hiddenFields,
                                      hiddenSections:
                                          serviceFormState.hiddenSections,
                                      mandatoryFieldObject:
                                          mandatoryFieldObject,
                                      isEditableMode:
                                          serviceFormState.isEditableMode,
                                      dataObject: serviceFormState.formState,
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
                                          : 'Save ',
                                      labelColor: Colors.white,
                                      buttonColor: const Color(0xFF258DCC),
                                      fontSize: 15.0,
                                      onPressButton: () => onSaveForm(
                                          context,
                                          serviceFormState.formState,
                                          agywDream),
                                    ),
                                  )
                                ],
                              )
                      ],
                    );
                  },
                );
              },
            ),
          ),
          bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
        );
      },
    );
  }
}
