import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/components/education_bursary_referral_outcome_card.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/components/education_bursary_referral_outcome_follow_up_container.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/components/education_bursary_referral_outcome_follow_up_modal.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/components/education_bursary_referral_outcome_modal.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/constants/bursary_intervention_constant.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/bursary_referral_event.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/bursary_referral_outcome_event.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/bursary_referral_outcome_follow_up_event.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/education_bursary_referral_outcome_follow_up_form.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/education_bursary_referral_outcome_form.dart';
import 'package:provider/provider.dart';

class EducationBursaryReferralOutComeContainer extends StatelessWidget {
  const EducationBursaryReferralOutComeContainer({
    Key? key,
    required this.bursaryReferral,
  }) : super(key: key);

  final BursaryReferralEvent bursaryReferral;

  void updateFormState(
    BuildContext context,
    bool isEditableMode,
    Events? eventData,
  ) {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    if (eventData != null) {
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventDate', eventData.eventDate);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventId', eventData.event);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('location', bursaryReferral.eventData!.orgUnit);
      for (Map dataValue in eventData.dataValues) {
        if (dataValue['value'] != '') {
          Provider.of<ServiceFormState>(context, listen: false)
              .setFormFieldState(dataValue['dataElement'], dataValue['value']);
        }
      }
    }
  }

  void onAddOrEditOutcome(
    BuildContext context,
    bool isEditableMode,
    Events? eventData,
  ) async {
    updateFormState(context, isEditableMode, eventData);
    String currentLanguage =
        Provider.of<LanguageTranslationState>(context, listen: false)
            .currentLanguage;
    Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
        BursaryInterventionConstant
            .clubAttendanceReferralToReferralOutcomeLinkage,
        bursaryReferral.referralToReferralOutcomeLinkage);
    List<FormSection> formSections =
        EducationBursaryReferralOutcomeForm.getFormSections(
      firstDate: AppUtil.formattedDateTimeIntoString(
        AppUtil.getDateIntoDateTimeFormat(''),
      ),
    );
    List mandatoryFields =
        EducationBursaryReferralOutcomeForm.getMandatoryField();
    Widget modal = EducationBursaryReferralOutcomeModal(
      formSections: formSections,
      mandatoryFields: mandatoryFields,
    );
    await AppUtil.showPopUpModal(
      context,
      modal,
      true,
      title: currentLanguage == 'lesotho'
          ? 'Sephetho sa phetisetso'
          : 'Referral Outcome',
    );
  }

  void onAddOrEditOutcomeFollowingUp(
    BuildContext context,
    BursaryReferralOutcomeEvent referralOutcomeEvent,
    bool isEditableMode,
    Events? eventData,
  ) async {
    updateFormState(context, isEditableMode, eventData);
    Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
        BursaryInterventionConstant
            .clubAttendanceReferralOutcomeToReferralOutComeFollowingUpLinkage,
        referralOutcomeEvent
            .referralOutcomeToReferralOutComeFollowingUpLinkage);
    List mandatoryFields =
        EducationBursaryReferralOutcomeFollowUpForm.getMandatoryField();
    List<FormSection> formSections =
        EducationBursaryReferralOutcomeFollowUpForm.getFormSections(
      firstDate: referralOutcomeEvent.eventDate!,
    );
    Widget modal = EducationBursaryReferralOutcomeFollowUpModal(
      formSections: formSections,
      mandatoryFields: mandatoryFields,
    );
    await AppUtil.showPopUpModal(
      context,
      modal,
      true,
      title: 'Referral Follow up',
    );
  }

  void onAddingOutcome(BuildContext context) {
    bool isEditableMode = true;
    onAddOrEditOutcome(context, isEditableMode, null);
  }

  void onEditOutcome(
    BuildContext context,
    BursaryReferralOutcomeEvent referralOutcomeEvent,
  ) {
    bool isEditableMode = true;
    onAddOrEditOutcome(context, isEditableMode, referralOutcomeEvent.eventData);
  }

  void onAddOutComeFollowingUp(
    BuildContext context,
    BursaryReferralOutcomeEvent referralOutcomeEvent,
  ) {
    bool isEditableMode = true;
    onAddOrEditOutcomeFollowingUp(
      context,
      referralOutcomeEvent,
      isEditableMode,
      null,
    );
  }

  void onEditOutComeFollowingUp(
    BuildContext context,
    BursaryReferralOutcomeEvent referralOutcomeEvent,
    Events eventData,
  ) {
    bool isEditableMode = true;
    onAddOrEditOutcomeFollowingUp(
      context,
      referralOutcomeEvent,
      isEditableMode,
      eventData,
    );
  }

  ClipRRect _getActionButton({
    required Color backgroundColor,
    required String label,
    required Color labelColor,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      ),
      child: Container(
        width: double.infinity,
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 15.0,
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle().copyWith(
                  color: labelColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;

        List<String> programStageIds = [
          BursaryInterventionConstant.clubAttendanceReferralOutcomeProgamStage
        ];

        return Consumer<ServiceEventDataState>(
            builder: (context, serviceEventDataState, child) {
          bool isLoading = serviceEventDataState.isLoading;
          Map<String?, List<Events>> eventListByProgramStage =
              serviceEventDataState.eventListByProgramStage;
          List<Events> events = TrackedEntityInstanceUtil
              .getAllEventListFromServiceDataStateByProgramStages(
                  eventListByProgramStage, programStageIds);
          List<BursaryReferralOutcomeEvent> referralOutcomeEvents = events
              .map((Events eventData) =>
                  BursaryReferralOutcomeEvent().fromTeiModel(eventData))
              .toList()
              .where((BursaryReferralOutcomeEvent referralOutcomeEvent) =>
                  referralOutcomeEvent.referralToReferralOutcomeLinkage ==
                  bursaryReferral.referralToReferralOutcomeLinkage)
              .toList();
          bool shouldAddOutcome = referralOutcomeEvents.isEmpty;
          return isLoading
              ? const CircularProcessLoader(
                  color: Colors.blueGrey,
                )
              : Column(
                  children: [
                    Visibility(
                      visible: shouldAddOutcome &&
                          bursaryReferral.enrollmentOuAccessible!,
                      child: LineSeparator(
                        color: const Color(0xFF009688).withOpacity(0.3),
                      ),
                    ),
                    Container(
                      child: shouldAddOutcome
                          ? Visibility(
                              visible: bursaryReferral.enrollmentOuAccessible!,
                              child: _getActionButton(
                                backgroundColor:
                                    const Color(0xFF009688).withOpacity(0.1),
                                label: currentLanguage == 'lesotho'
                                    ? 'kenya Sephetho'
                                    : 'ADD OUTCOME',
                                labelColor: const Color(0xFF009688),
                                onTap: () => onAddingOutcome(context),
                              ))
                          : Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 15.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFB2B7B9),
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  children: referralOutcomeEvents
                                      .map(
                                        (BursaryReferralOutcomeEvent
                                                referralOutcomeEvent) =>
                                            Column(
                                          children: [
                                            EducationBursaryReferralOutcomeCard(
                                              referralOutcomeEvent:
                                                  referralOutcomeEvent,
                                              onEditReferralOutcome: () =>
                                                  onEditOutcome(context,
                                                      referralOutcomeEvent),
                                            ),
                                            EdcucationBursaryReferralOutcomeFollowUpContainer(
                                              referralOutcomeEvent:
                                                  referralOutcomeEvent,
                                              isFollowingUpNeeded:
                                                  referralOutcomeEvent
                                                      .isRequireFollowUp!,
                                              onAddOutComeFollowingUp: () =>
                                                  onAddOutComeFollowingUp(
                                                      context,
                                                      referralOutcomeEvent),
                                              editAddOutComeFollowingUp:
                                                  (BursaryReferralOutcomeFollowUpEvent
                                                          referralOutcomeFollowUpEvent) =>
                                                      onEditOutComeFollowingUp(
                                                          context,
                                                          referralOutcomeEvent,
                                                          referralOutcomeFollowUpEvent
                                                              .eventData!),
                                            )
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                    ),
                  ],
                );
        });
      },
    );
  }
}
