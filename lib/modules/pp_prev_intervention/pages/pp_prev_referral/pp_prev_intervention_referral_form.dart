import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/implementing_partner_referral_service_state/implementing_partner_referral_service_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/pp_prev_beneficiary.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/components/pp_prev_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/constants/pp_prev_intervention_constant.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_current_selection_state.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/constants/pp_prev_routes_constant.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/models/pp_prev_referral_form.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/skip_logics/pp_prev_referral_form_skip_logic.dart';

class PpPrevInterventionReferralForm extends StatefulWidget {
  const PpPrevInterventionReferralForm({Key? key}) : super(key: key);

  @override
  State<PpPrevInterventionReferralForm> createState() =>
      _PpPrevInterventionReferralFormState();
}

class _PpPrevInterventionReferralFormState
    extends State<PpPrevInterventionReferralForm> {
  final String label = "PP Prev Referral Form";
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

  setFormSections() {
    setState(() {
      final List<String> mandatoryFields =
          PpPrevReferralForm.getMandatoryField();
      for (String id in mandatoryFields) {
        mandatoryFieldObject[id] = true;
      }
      formSections = PpPrevReferralForm.getFormSections();
    });

    Timer(const Duration(seconds: 1), () {
      setState(() {
        isFormReady = true;
        evaluateSkipLogics();
      });
    });
  }

  evaluateSkipLogics() {
    Map<String, dynamic> implementingPartnerReferralServices =
        Provider.of<ImplementingPartnerReferralServiceState>(context,
                listen: false)
            .implementingPartnerServices;

    PpPrevBeneficiary currentPpPrev =
        Provider.of<PpPrevInterventionCurrentSelectionState>(context,
                listen: false)
            .currentPpPrev!;
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await PpPrevReferralFormSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
          implementingPartnerReferralServices,
          currentPpPrev,
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

  void clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    String formAutoSaveId =
        "${PpPrevRoutesConstant.referralFormPageModule}_${beneficiaryId}_$eventId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  void onUpdateFormAutoSaveState(
    BuildContext context, {
    bool isSaveForm = false,
    String nextPageModule = "",
  }) async {
    var currentPpPrev = Provider.of<PpPrevInterventionCurrentSelectionState>(
            context,
            listen: false)
        .currentPpPrev;
    String? beneficiaryId = currentPpPrev!.id;
    Map dataObject =
        Provider.of<ServiceFormState>(context, listen: false).formState;
    String eventId = dataObject['eventId'] ?? '';
    String id =
        "${PpPrevRoutesConstant.referralFormPageModule}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: PpPrevRoutesConstant.serviceFormPageModule,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : PpPrevRoutesConstant.referralFormNextPageModule
          : PpPrevRoutesConstant.referralFormPageModule,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
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

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    PpPrevBeneficiary ppPrevBeneficiary,
  ) async {
    setMandatoryFields(dataObject);
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
      if (FormUtil.geFormFilledStatus(dataObject, formSections)) {
        isSaving = true;
        setState(() {});
        String? eventDate = dataObject['eventDate'];
        String? eventId = dataObject['eventId'];
        List<String> hiddenFields = [];
        String orgUnit = dataObject['location'] ?? ppPrevBeneficiary.orgUnit;
        orgUnit = orgUnit.isEmpty ? ppPrevBeneficiary.orgUnit ?? '' : orgUnit;
        try {
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            PpPrevInterventionConstant.program,
            PpPrevInterventionConstant.referralProgramStage,
            orgUnit,
            formSections!,
            dataObject,
            eventDate,
            ppPrevBeneficiary.id,
            eventId,
            hiddenFields,
          );
          Provider.of<ServiceEventDataState>(context, listen: false)
              .resetServiceEventDataState(ppPrevBeneficiary.id);
          Timer(const Duration(seconds: 1), () {
            setState(() {
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
                context,
                ppPrevBeneficiary.id,
                eventId ?? '',
              );
              Navigator.pop(context);
            });
          });
        } catch (e) {
          Timer(const Duration(seconds: 1), () {
            setState(() {
              AppUtil.showToastMessage(
                  message: e.toString(), position: ToastGravity.BOTTOM);
            });
          });
        }
      } else {
        AppUtil.showToastMessage(
          message: 'Please fill at least one form field',
          position: ToastGravity.TOP,
        );
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
    return SafeArea(
      child: Scaffold(
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
            return Consumer<PpPrevInterventionCurrentSelectionState>(
              builder:
                  (context, ppPrevInterventionCurrentSelectionState, child) {
                return Consumer<ServiceFormState>(
                  builder: (context, serviceFormState, child) {
                    PpPrevBeneficiary? ppPrevBeneficiary =
                        ppPrevInterventionCurrentSelectionState.currentPpPrev;
                    return Column(
                      children: [
                        PpPrevBeneficiaryTopHeader(
                          ppPrevBeneficiary: ppPrevBeneficiary!,
                        ),
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
                                      child: EntryFormContainer(
                                        hiddenFields:
                                            serviceFormState.hiddenFields,
                                        hiddenInputFieldOptions:
                                            serviceFormState
                                                .hiddenInputFieldOptions,
                                        hiddenSections:
                                            serviceFormState.hiddenSections,
                                        formSections: formSections,
                                        mandatoryFieldObject:
                                            mandatoryFieldObject,
                                        unFilledMandatoryFields:
                                            unFilledMandatoryFields,
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
                                            : currentLanguage == 'lesotho'
                                                ? 'Boloka'
                                                : 'Save',
                                        labelColor: Colors.white,
                                        buttonColor: const Color(0xFF9B2BAE),
                                        fontSize: 15.0,
                                        onPressButton: () => onSaveForm(
                                          context,
                                          serviceFormState.formState,
                                          ppPrevBeneficiary,
                                        ),
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
          }),
        ),
      ),
    );
  }
}
