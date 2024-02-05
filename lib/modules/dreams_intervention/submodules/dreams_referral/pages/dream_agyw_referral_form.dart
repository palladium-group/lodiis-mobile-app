import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/implementing_partner_referral_service_state/implementing_partner_referral_service_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/services/referral_notification_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/referral_event_notification.dart';
import 'package:kb_mobile_app/models/referral_notification.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_common_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_enrollment_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_referral/constant/dreams_agyw_referral_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_referral/models/dreams_referral.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_referral/skip_logics/dreams_agyw_referral_skip_logic.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:provider/provider.dart';

class DreamsAgywAddReferralForm extends StatefulWidget {
  const DreamsAgywAddReferralForm({Key? key, this.currentUser})
      : super(key: key);

  final CurrentUser? currentUser;

  @override
  State<DreamsAgywAddReferralForm> createState() =>
      _DreamsAgywAddReferralFormState();
}

class _DreamsAgywAddReferralFormState extends State<DreamsAgywAddReferralForm> {
  final String label = 'Dream Referral Form';
  final Map mandatoryFieldObject = {};
  List<String> mandatoryFields = DreamsReferral.getMandatoryFields();
  List unFilledMandatoryFields = [];
  List<FormSection>? formSections;
  List<FormSection>? defaultFormSections;
  bool isFormReady = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    setFormSections();
    Timer(const Duration(seconds: 1), () {
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
    defaultFormSections = DreamsReferral.getFormSections();
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
      mandatoryFields.addAll(FormUtil.getFormFieldIds(
        [serviceProvisionForm],
        includeLocationId: true,
      ));
      for (String fieldId in mandatoryFields) {
        mandatoryFieldObject[fieldId] = true;
      }
    }
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        Map<String, dynamic> implementingPartnerReferralServices =
            Provider.of<ImplementingPartnerReferralServiceState>(context,
                    listen: false)
                .implementingPartnerServices;
        await DreamsAgywReferralSkipLogic.evaluateSkipLogics(
          context,
          formSections!,
          dataObject,
          widget.currentUser!.implementingPartner ?? '',
          implementingPartnerReferralServices,
        );
      },
    );
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    if (id == 'AuCryxQYmrk') {
      Provider.of<ServiceFormState>(context, listen: false)
          .removeFieldFromState('OrC9Bh2bcFz');
    } else if (id == 'LLWTHwhnch0') {
      Provider.of<ServiceFormState>(context, listen: false)
          .removeFieldFromState('rsh5Kvx6qAU');
    }
    evaluateSkipLogics();
    onUpdateFormAutoSaveState(context);
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    AgywDream? currentAgywDream, {
    Map hiddenFieldsObject = const {},
  }) async {
    setMandatoryFields(dataObject);
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields: hiddenFieldsObject,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections ?? [],
      ),
    );
    if (hadAllMandatoryFilled) {
      setState(() {
        // isSaving = true;
      });
      String? eventDate = dataObject['eventDate'];
      String? eventId = dataObject['eventId'];
      String orgUnit = dataObject['location'] ?? currentAgywDream!.orgUnit;
      orgUnit = orgUnit.isEmpty ? currentAgywDream!.orgUnit ?? '' : orgUnit;
      dataObject[DreamsAgywReferralConstant.referralToFollowUpLinkage] =
          dataObject[DreamsAgywReferralConstant.referralToFollowUpLinkage] ??
              AppUtil.getUid();
      List<String> hiddenFields = [
        DreamsAgywReferralConstant.referralToFollowUpLinkage
      ];
      try {
        if (eventId == null) {
          eventId = AppUtil.getUid();
          String currentImplementingPartner =
              Provider.of<ReferralNotificationState>(context, listen: false)
                  .currentImplementingPartner;
          await updateReferralNotification(
            eventId,
            dataObject,
            currentAgywDream!,
            currentImplementingPartner,
          );
        }
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          DreamsAgywReferralConstant.program,
          DreamsAgywReferralConstant.programStage,
          orgUnit,
          formSections!,
          dataObject,
          eventDate,
          currentAgywDream!.id,
          eventId,
          hiddenFields,
          skippedFields: [],
        );
        Provider.of<ServiceEventDataState>(context, listen: false)
            .resetServiceEventDataState(currentAgywDream.id);
        clearFormAutoSaveState(
          context,
          currentAgywDream.id,
          dataObject['eventId'] ?? '',
        );
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

            if (Navigator.canPop(context)) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          });
        });
      } catch (error) {
        Timer(const Duration(seconds: 1), () {
          setState(() {
            AppUtil.showToastMessage(
              message: error.toString(),
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

  updateReferralNotification(
    String eventId,
    Map dataObject,
    AgywDream currentAgywDream,
    String currentImplementingPartner,
  ) async {
    String implementingPartner =
        dataObject[ReferralNotification.implementingPartnerFormVariable] ?? "";
    implementingPartner = implementingPartner.split("/").join("-");
    String location = dataObject[ReferralNotification.facility] ?? "";
    location = location == ""
        ? dataObject[ReferralNotification.communityCouncil] ?? ""
        : location;
    String tei = currentAgywDream.id ?? "";
    String nameSpaceKey = "${location}_$implementingPartner";
    ReferralNotification referralNotification = ReferralNotification(
      id: "${nameSpaceKey}_$tei",
      implementingPartner: implementingPartner,
      nameSpaceKey: nameSpaceKey,
      tei: tei,
      referrals: [
        ReferralEventNotification(
          id: eventId,
          tei: tei,
          fromImplementingPartner: currentImplementingPartner,
          nameSpaceKey: nameSpaceKey,
        )
      ],
    );
    await ReferralNotificationService()
        .savingReferralNotificationToOfflineDb([referralNotification]);
  }

  void clearFormAutoSaveState(
    BuildContext context,
    String? beneficiaryId,
    String eventId,
  ) async {
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywDreamsReferralPage}_${beneficiaryId}_$eventId";
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
    String eventId = dataObject['eventId'] ?? '';
    String id =
        "${DreamsRoutesConstant.agywDreamsReferralPage}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave = FormAutoSave(
      id: id,
      beneficiaryId: beneficiaryId,
      pageModule: DreamsRoutesConstant.agywDreamsReferralPage,
      nextPageModule: isSaveForm
          ? nextPageModule != ""
              ? nextPageModule
              : DreamsRoutesConstant.agywDreamsReferralNextPage
          : DreamsRoutesConstant.agywDreamsReferralPage,
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
              builder: (context, dreamBeneficiaryCurrentSelectionState, child) {
                AgywDream? currentAgywDream =
                    dreamBeneficiaryCurrentSelectionState.currentAgywDream;
                return Consumer<ServiceFormState>(
                  builder: (context, serviceFormState, child) {
                    return Column(
                      children: [
                        DreamsBeneficiaryTopHeader(agywDream: currentAgywDream),
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
                                    buttonColor:
                                        AgywDreamsCommonConstant.defaultColor,
                                    fontSize: 15.0,
                                    onPressButton: () => onSaveForm(
                                        context,
                                        serviceFormState.formState,
                                        currentAgywDream,
                                        hiddenFieldsObject:
                                            serviceFormState.hiddenFields),
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
