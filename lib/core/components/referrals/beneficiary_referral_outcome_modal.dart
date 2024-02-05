import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/referral_event.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_referral/skip_logics/dreams_agyw_referral_outcome_skip_logic.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_house_referral_pages/skip_logics/ovc_referral_outcome.dart';
import 'package:provider/provider.dart';

class BeneficiaryReferralOutcomeModal extends StatefulWidget {
  const BeneficiaryReferralOutcomeModal({
    Key? key,
    required this.enrollmentOuAccessible,
    required this.beneficiary,
    required this.themeColor,
    required this.formSections,
    required this.hiddenFields,
    required this.referralProgramStage,
    required this.referralOutcomeLinkage,
    required this.referralToFollowUpLinkage,
    required this.mandatoryFields,
    required this.referralEvent,
    required this.isOvcIntervention,
  }) : super(key: key);

  final TrackedEntityInstance beneficiary;
  final bool enrollmentOuAccessible;
  final Color themeColor;
  final List<FormSection> formSections;
  final String referralProgramStage;
  final String referralToFollowUpLinkage;
  final String referralOutcomeLinkage;
  final List<String> hiddenFields;
  final List<String> mandatoryFields;
  final ReferralEvent referralEvent;
  final bool isOvcIntervention;

  @override
  State<BeneficiaryReferralOutcomeModal> createState() =>
      _BeneficiaryReferralOutcomeModalState();
}

class _BeneficiaryReferralOutcomeModalState
    extends State<BeneficiaryReferralOutcomeModal> {
  bool _isFormReady = false;
  bool _isSaving = false;
  final Map _mandatoryFieldsObject = {};
  List unFilledMandatoryFields = [];
  List<FormSection>? formSections;

  @override
  void initState() {
    super.initState();
    setEntryFormMetadata();
  }

  void setEntryFormMetadata() {
    _mandatoryFieldsObject.clear();
    if (!widget.enrollmentOuAccessible) {
      FormSection serviceProvisionForm =
          AppUtil.getServiceProvisionLocationSection(
        inputColor: widget.themeColor,
        allowedSelectedLevels: widget.isOvcIntervention
            ? [AppHierarchyReference.communityLevel]
            : [
                AppHierarchyReference.communityLevel,
                AppHierarchyReference.facilityLevel
              ],
        program: widget.referralEvent.eventData!.program!,
        labelColor: const Color(0xFF737373),
        sectionLabelColor: const Color(0xFF737373),
        formlabel: 'Referral Follow Up Location',
      );
      formSections = [serviceProvisionForm, ...widget.formSections];
      for (String id in FormUtil.getFormFieldIds(
        [serviceProvisionForm],
        includeLocationId: true,
      )) {
        _mandatoryFieldsObject[id] = true;
      }
    } else {
      formSections = widget.formSections;
    }
    for (String id in widget.mandatoryFields) {
      _mandatoryFieldsObject[id] = true;
    }
    evaluateSkipLogics();
    Timer(const Duration(milliseconds: 200), () {
      _isFormReady = true;
      setState(() {});
    });
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        if (widget.isOvcIntervention) {
          await OvcReferralOutcomeSkipLogic.evaluateSkipLogics(
            context,
            widget.formSections,
            dataObject,
          );
        } else {
          await DreamsAgywReferralOutcomeSkipLogic.evaluateSkipLogics(
            context,
            widget.formSections,
            dataObject,
          );
        }
      },
    );
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
  ) async {
    unFilledMandatoryFields = [];
    setState(() {});
    List mandatoryFields = _mandatoryFieldsObject.keys.toList();
    bool isAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields:
          Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: widget.formSections,
      ),
    );
    if (isAllMandatoryFilled) {
      try {
        _isSaving = true;
        setState(() {});
        dataObject[widget.referralOutcomeLinkage] =
            dataObject[widget.referralOutcomeLinkage] ??
                widget.referralEvent.id;
        dataObject[widget.referralToFollowUpLinkage] =
            dataObject[widget.referralToFollowUpLinkage] ?? AppUtil.getUid();
        var orgUnit = dataObject['location'] ?? '';
        var eventId = dataObject['eventId'];
        var eventDate = dataObject['eventDate'];
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          widget.referralEvent.eventData?.program,
          widget.referralProgramStage,
          orgUnit,
          formSections ?? [],
          dataObject,
          eventDate,
          widget.beneficiary.trackedEntityInstance,
          eventId,
          widget.hiddenFields,
          skippedFields: ['location'],
        );
        Provider.of<ServiceEventDataState>(context, listen: false)
            .resetServiceEventDataState(
                widget.beneficiary.trackedEntityInstance);
        updateReferralNotificationStatus();
        Timer(const Duration(milliseconds: 200), () {
          setState(() {
            _isSaving = false;
            String? currentLanguage =
                Provider.of<LanguageTranslationState>(context, listen: false)
                    .currentLanguage;
            AppUtil.showToastMessage(
              message: currentLanguage == 'lesotho'
                  ? 'Fomo e bolokeile'
                  : 'Form has been saved successfully',
            );
            Navigator.pop(context);
          });
        });
      } catch (e) {
        //
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
            formSections: widget.formSections,
          ),
        );
      });
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory field',
      );
    }
  }

  void updateReferralNotificationStatus() async {
    bool isCompleted = true;
    bool isViewed = false;
    await Provider.of<ReferralNotificationState>(context, listen: false)
        .updateReferralNotificationEvent(widget.referralEvent.id,
            widget.beneficiary.trackedEntityInstance, isCompleted, isViewed);
    List<String> teiWithIncomingReferral =
        Provider.of<ReferralNotificationState>(context, listen: false)
            .beneficiariesWithIncomingReferrals;
    Provider.of<DreamsInterventionListState>(context, listen: false)
        .setTeiWithIncomingReferral(
            teiWithIncomingReferral: teiWithIncomingReferral);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 13.0,
      ),
      child: !_isFormReady
          ? const CircularProcessLoader(
              color: Colors.blueGrey,
            )
          : Container(
              margin: const EdgeInsets.symmetric(),
              child: Consumer<ServiceFormState>(
                builder: (context, serviceFormState, child) {
                  return Column(
                    children: [
                      EntryFormContainer(
                        hiddenSections: serviceFormState.hiddenSections,
                        hiddenFields: serviceFormState.hiddenFields,
                        elevation: 2.0,
                        formSections: formSections,
                        mandatoryFieldObject: _mandatoryFieldsObject,
                        unFilledMandatoryFields: unFilledMandatoryFields,
                        dataObject: serviceFormState.formState,
                        isEditableMode: serviceFormState.isEditableMode,
                        onInputValueChange: onInputValueChange,
                      ),
                      ClipRRect(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                          ),
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: widget.themeColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => _isSaving
                                      ? null
                                      : onSaveForm(
                                          context,
                                          serviceFormState.formState,
                                        ),
                                  child: Text(
                                    _isSaving
                                        ? 'COMPLETING REFERRAL ...'
                                        : 'COMPLETE REFERRAL',
                                    style: const TextStyle().copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFFAFAFA),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
    );
  }
}
