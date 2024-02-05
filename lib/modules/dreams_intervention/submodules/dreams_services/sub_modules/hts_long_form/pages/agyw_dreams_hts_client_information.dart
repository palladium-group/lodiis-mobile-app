import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/models/client_information.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/constants/agyw_dreams_hts_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/pages/agyw_dreams_hts_register.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/skip_logics/agyw_dreams_hts_skip_logic.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:provider/provider.dart';

class AgywDreamsHTSClientInformation extends StatefulWidget {
  const AgywDreamsHTSClientInformation({Key? key, this.isComingFromPrep})
      : super(key: key);
  final bool? isComingFromPrep;

  @override
  State<AgywDreamsHTSClientInformation> createState() =>
      _AgywDreamsHTSClientInformationState();
}

class _AgywDreamsHTSClientInformationState
    extends State<AgywDreamsHTSClientInformation> {
  final String label = 'Client Bio'; //Initially Client Information
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;
  bool? isComingFromPrep;

  @override
  void initState() {
    super.initState();
    isComingFromPrep = widget.isComingFromPrep;
    formSections = ClientInformation.getFormSections();
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
        await AgywDreamsHTCSkipLogic.evaluateSkipLogics(
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

  void onSaveForm(BuildContext context, Map dataObject, AgywDream? agywDream) {
    Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
        .setCurrentAgywDream(agywDream);
    dataObject.remove(AgywDreamsHTSLongFormConstant.bmiKey);
    onUpdateFormAutoSaveState(context, isSaveForm: true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgywDreamsHTSRegisterForm(
          isComingFromPrep: isComingFromPrep,
        ),
      ),
    );
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
                                      mandatoryFieldObject: const {},
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
                                          : 'Save and Continue',
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
