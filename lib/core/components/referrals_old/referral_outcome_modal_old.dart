import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_house_referral_pages/skip_logics/ovc_referral_outcome.dart';
import 'package:provider/provider.dart';

class ReferralOutcomeModalOld extends StatefulWidget {
  const ReferralOutcomeModalOld({
    Key? key,
    required this.themeColor,
    required this.referralOutcomeFormSections,
    required this.eventData,
    required this.hiddenFields,
    required this.referralToFollowUpLinkage,
    required this.referralOutcomeMandatoryFields,
  }) : super(key: key);

  final Color? themeColor;
  final List<FormSection>? referralOutcomeFormSections;
  final Events eventData;
  final String referralToFollowUpLinkage;
  final List<String> hiddenFields;
  final List<String> referralOutcomeMandatoryFields;

  @override
  State<ReferralOutcomeModalOld> createState() =>
      _ReferralOutcomeModalOldState();
}

class _ReferralOutcomeModalOldState extends State<ReferralOutcomeModalOld> {
  bool isFormReady = false;
  bool isSaving = false;
  Map referralOutcomeMandatoryFieldsObject = {};
  List unFilledMandatoryFields = [];

  @override
  void initState() {
    super.initState();
    setFormState();
  }

  void setFormState() {
    for (String id in widget.referralOutcomeMandatoryFields) {
      referralOutcomeMandatoryFieldsObject[id] = true;
    }
    evaluateSkipLogics();
    Timer(const Duration(seconds: 1), () {
      isFormReady = true;
      setState(() {});
    });
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () async {
        Map dataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;
        await OvcReferralOutcomeSkipLogic.evaluateSkipLogics(
          context,
          widget.referralOutcomeFormSections!,
          dataObject,
        );
      },
    );
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
    Events eventData,
  ) async {
    if (getReferralOutComeStatus(dataObject)) {
      bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
        widget.referralOutcomeMandatoryFields,
        dataObject,
        hiddenFields:
            Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
        checkBoxInputFields: FormUtil.getInputFieldByValueType(
          valueType: 'CHECK_BOX',
          formSections: widget.referralOutcomeFormSections ?? [],
        ),
      );
      if (hadAllMandatoryFilled) {
        isSaving = true;
        setState(() {});
        try {
          bool isCompleted = true;
          bool isViewed = false;
          Provider.of<ReferralNotificationState>(context, listen: false)
              .updateReferralNotificationEvent(
            eventData.event,
            eventData.trackedEntityInstance,
            isCompleted,
            isViewed,
          );
          dataObject[widget.referralToFollowUpLinkage] =
              dataObject[widget.referralToFollowUpLinkage] ?? AppUtil.getUid();
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
              eventData.program,
              eventData.programStage,
              eventData.orgUnit,
              widget.referralOutcomeFormSections!,
              dataObject,
              eventData.eventDate,
              eventData.trackedEntityInstance,
              eventData.event,
              widget.hiddenFields,
              skippedFields: ['phoneNumber', 'village']);
          Provider.of<ServiceEventDataState>(context, listen: false)
              .resetServiceEventDataState(eventData.trackedEntityInstance);
          Timer(const Duration(seconds: 1), () {
            setState(() {
              isSaving = false;
              String? currentLanguage =
                  Provider.of<LanguageTranslationState>(context, listen: false)
                      .currentLanguage;
              AppUtil.showToastMessage(
                message: currentLanguage == 'lesotho'
                    ? 'Fomo e bolokeile'
                    : 'Form has been saved successfully',
                position: ToastGravity.TOP,
              );
              Navigator.popUntil(context, (route) => route.isFirst);
            });
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
        setState(() {
          unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
            widget.referralOutcomeMandatoryFields,
            dataObject,
            hiddenFields: Provider.of<ServiceFormState>(context, listen: false)
                .hiddenFields,
            checkBoxInputFields: FormUtil.getInputFieldByValueType(
              valueType: 'CHECK_BOX',
              formSections: widget.referralOutcomeFormSections ?? [],
            ),
          );
        });
        AppUtil.showToastMessage(
          message: 'Please fill all mandatory fields',
          position: ToastGravity.TOP,
        );
      }
    } else {
      AppUtil.showToastMessage(
          message: 'Please fill at least one form field',
          position: ToastGravity.TOP);
    }
  }

  bool getReferralOutComeStatus(Map dataObject) {
    bool isReferralOutcomeFilled = false;
    List<String> inputFields =
        FormUtil.getFormFieldIds(widget.referralOutcomeFormSections!);
    for (String id in inputFields) {
      if (dataObject.containsKey(id) && '${dataObject[id]}'.trim() != '') {
        isReferralOutcomeFilled = true;
      }
    }
    return isReferralOutcomeFilled;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
      String currentLanguage = languageTranslationState.currentLanguage;

      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        child: Consumer<ServiceFormState>(
          builder: (context, serviceFormState, child) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 10.0,
                    left: 13.0,
                    right: 13.0,
                  ),
                  child: EntryFormContainer(
                    hiddenSections: serviceFormState.hiddenSections,
                    hiddenFields: serviceFormState.hiddenFields,
                    elevation: 0.0,
                    formSections: widget.referralOutcomeFormSections,
                    mandatoryFieldObject: referralOutcomeMandatoryFieldsObject,
                    unFilledMandatoryFields: unFilledMandatoryFields,
                    dataObject: serviceFormState.formState,
                    isEditableMode: serviceFormState.isEditableMode,
                    onInputValueChange: onInputValueChange,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: widget.themeColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => isSaving
                              ? null
                              : onSaveForm(
                                  context,
                                  serviceFormState.formState,
                                  widget.eventData,
                                ),
                          child: Text(
                            isSaving
                                ? currentLanguage == 'lesotho'
                                    ? 'E ntse e boloka sephetho ...'
                                    : 'SAVING OUTCOME ...'
                                : currentLanguage == 'lesotho'
                                    ? 'Boloka sephetho'
                                    : 'SAVE OUTCOME',
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
                )
              ],
            );
          },
        ),
      );
    });
  }
}
