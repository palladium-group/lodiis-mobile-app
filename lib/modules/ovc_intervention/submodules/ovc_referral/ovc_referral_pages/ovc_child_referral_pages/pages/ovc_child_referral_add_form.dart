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
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/models/ovc_referral.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_child_referral_pages/constants/ovc_child_referral_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_child_referral_pages/skip_logics/ovc_child_referral.dart';
import 'package:provider/provider.dart';

class OvcChildReferralAddForm extends StatefulWidget {
  const OvcChildReferralAddForm({Key? key}) : super(key: key);

  @override
  State<OvcChildReferralAddForm> createState() =>
      _OvcChildReferralAddFormState();
}

class _OvcChildReferralAddFormState extends State<OvcChildReferralAddForm> {
  List<FormSection> formSections = [];
  List<String> mandatoryFields = [];
  Map mandatoryFieldObject = {};
  List unFilledMandatoryFields = [];
  bool isFormReady = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    setFormState();
  }

  void setFormState() {
    mandatoryFieldObject.clear();
    OvcHouseholdChild currentOvcHousehold =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild!;
    mandatoryFields = OvcReferral.getMandatoryFields();
    formSections = OvcReferral.getFormSections(
        enrollmentDate: currentOvcHousehold.createdDate ?? '');
    if (currentOvcHousehold.enrollmentOuAccessible != true) {
      formSections = [
        AppUtil.getServiceProvisionLocationSection(
          inputColor: const Color(0xFF4B9F46),
          labelColor: const Color(0xFF1A3518),
          sectionLabelColor: const Color(0xFF1A3518),
          formlabel: 'Referral Location',
          allowedSelectedLevels: [
            AppHierarchyReference.communityLevel,
          ],
          program: OvcInterventionConstant.ovcProgramprogram,
        ),
        ...formSections
      ];
      mandatoryFields.add('location');
    }
    for (String field in mandatoryFields) {
      mandatoryFieldObject[field] = true;
    }
    Timer(const Duration(seconds: 1), () {
      isFormReady = true;
      _autoPopulatingNextOfKinInfo();
      evaluateSkipLogics();
      setState(() {});
    });
  }

  void _autoPopulatingNextOfKinInfo() {
    OvcHousehold currentOvcHousehold =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold!;
    String phoneNumber = currentOvcHousehold.phoneNumber != 'N/A'
        ? currentOvcHousehold.phoneNumber!
        : '';
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('tRvDAZxam3P', currentOvcHousehold.toString());
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('qCu2f4kEfzW', phoneNumber);
  }

  void clearFormAutoSaveState(
      BuildContext context, String? beneficiaryId, String eventId) async {
    String formAutoSaveId =
        "${OvcRoutesConstant.ovcReferralFormPage}_${beneficiaryId}_$eventId";
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
        "${OvcRoutesConstant.ovcReferralFormPage}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: OvcRoutesConstant.ovcReferralFormPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : OvcRoutesConstant.ovcReferralFormNextPage
          : OvcRoutesConstant.ovcReferralFormPage,
      data: jsonEncode(dataObject),
    );
    await FormAutoSaveOfflineService().saveFormAutoSaveData(formAutoSave);
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await OvcChildReferralSkipLogic.evaluateSkipLogics(
          context,
          formSections,
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
    if (id == 'LLWTHwhnch0') {
      Provider.of<ServiceFormState>(context, listen: false)
          .removeFieldFromState('rsh5Kvx6qAU');
    } else if (id == 'AuCryxQYmrk') {
      Provider.of<ServiceFormState>(context, listen: false)
          .removeFieldFromState('OrC9Bh2bcFz');
    }
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    Map hiddenFieldsObject,
    OvcHouseholdChild? currentOvcHouseholdChild,
  ) async {
    unFilledMandatoryFields = [];
    bool hasAtLeasrOnFieldFilled = FormUtil.hasAtLeastOnFieldFilled(
      hiddenFields: hiddenFieldsObject,
      formSections: formSections,
      dataObject: dataObject,
    );
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields: hiddenFieldsObject,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections,
      ),
    );
    if (hadAllMandatoryFilled) {
      if (hasAtLeasrOnFieldFilled) {
        isSaving = true;
        setState(() {});
        String? eventDate = dataObject['eventDate'];
        String? eventId = dataObject['eventId'];
        String orgUnit =
            dataObject['location'] ?? currentOvcHouseholdChild?.orgUnit ?? '';
        dataObject[OvcChildReferralConstant.referralToFollowUpLinkage] =
            dataObject[OvcChildReferralConstant.referralToFollowUpLinkage] ??
                AppUtil.getUid();
        List<String> hiddenFields = [
          OvcChildReferralConstant.referralToFollowUpLinkage
        ];
        try {
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            OvcChildReferralConstant.program,
            OvcChildReferralConstant.referralStage,
            orgUnit,
            formSections,
            dataObject,
            eventDate,
            currentOvcHouseholdChild?.id,
            eventId,
            hiddenFields,
          );
          Provider.of<ServiceEventDataState>(context, listen: false)
              .resetServiceEventDataState(currentOvcHouseholdChild?.id);
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
                context, currentOvcHouseholdChild?.id, eventId ?? '');
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
        AppUtil.showToastMessage(
          message: 'Please fill at least one field',
        );
      }
    } else {
      unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
        mandatoryFields,
        dataObject,
        hiddenFields:
            Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
        checkBoxInputFields: FormUtil.getInputFieldByValueType(
          valueType: 'CHECK_BOX',
          formSections: formSections,
        ),
      );
      setState(() {});
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<LanguageTranslationState>(
          builder: (context, languageTranslationState, child) {
            String? currentLanguage = languageTranslationState.currentLanguage;
            return Consumer<InterventionCardState>(
              builder: (context, interventionCardState, child) {
                InterventionCard activeInterventionProgram =
                    interventionCardState.currentInterventionProgram;
                return SubPageAppBar(
                  label: currentLanguage == 'lesotho'
                      ? 'Fomo ea Referral ea ngoana'
                      : 'Child Referral Form',
                  activeInterventionProgram: activeInterventionProgram,
                );
              },
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
                OvcHouseholdChild? currentOvcHouseholdChild =
                    ovcHouseholdCurrentSelectionState.currentOvcHouseholdChild;
                return Consumer<ServiceFormState>(
                  builder: (context, serviceFormState, child) {
                    return Column(
                      children: [
                        const OvcChildInfoTopHeader(),
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
                                      hiddenFields:
                                          serviceFormState.hiddenFields,
                                      hiddenSections:
                                          serviceFormState.hiddenSections,
                                      hiddenInputFieldOptions: serviceFormState
                                          .hiddenInputFieldOptions,
                                      formSections: formSections,
                                      mandatoryFieldObject:
                                          mandatoryFieldObject,
                                      isEditableMode:
                                          serviceFormState.isEditableMode,
                                      dataObject: serviceFormState.formState,
                                      onInputValueChange: onInputValueChange,
                                      unFilledMandatoryFields:
                                          unFilledMandatoryFields,
                                    ),
                                  ),
                                  EntryFormSaveButton(
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
                                      serviceFormState.hiddenFields,
                                      currentOvcHouseholdChild,
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
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
