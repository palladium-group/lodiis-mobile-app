import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/referrals_old/referral_outcome_follow_up.dart';
import 'package:kb_mobile_app/core/components/referrals_old/referral_outcome_following_up_modal_old.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/referral_outcome_event.dart';
import 'package:kb_mobile_app/models/referral_outcome_follow_up_event.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:provider/provider.dart';

class ReferralOutComeView extends StatelessWidget {
  const ReferralOutComeView({
    Key? key,
    required this.themeColor,
    required this.referralOutComeEvent,
    required this.beneficiary,
    required this.referralFollowUpStage,
    required this.referralToFollowUpLinkage,
    required this.referralOutcomeFollowUpFormSections,
    required this.referralProgram,
    required this.isEditableMode,
    required this.enrollmentOuAccessible,
  }) : super(key: key);

  final ReferralOutcomeEvent? referralOutComeEvent;
  final List<FormSection>? referralOutcomeFollowUpFormSections;
  final Color? themeColor;
  final TrackedEntityInstance? beneficiary;
  final String referralFollowUpStage;
  final String referralToFollowUpLinkage;
  final String referralProgram;
  final bool isEditableMode;
  final bool enrollmentOuAccessible;

  void updateFormState(BuildContext context, String? referralReference) {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: true);
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(referralToFollowUpLinkage, referralReference);
  }

  void onAddReferralOutComeFollowUp(BuildContext context) async {
    double modalRatio = 0.75;
    updateFormState(context, referralOutComeEvent!.referralReference);
    Widget modal = ReferralOutComeFollowUpModalOld(
      themeColor: themeColor,
      referralProgram: referralProgram,
      enrollmentOuAccessible: enrollmentOuAccessible,
      referralFollowUpStage: referralFollowUpStage,
      referralToFollowUpLinkage: referralToFollowUpLinkage,
      referralOutcomeFollowUpFormSections:
          referralOutcomeFollowUpFormSections ?? [],
      beneficiary: beneficiary,
    );
    AppUtil.showActionSheetModal(
      context: context,
      containerBody: modal,
      initialHeightRatio: modalRatio,
      maxHeightRatio: modalRatio,
    );
  }

  void onEditOutComeFollowUp(BuildContext context) async {
    double modalRatio = 0.75;
    Widget modal = ReferralOutComeFollowUpModalOld(
      themeColor: themeColor,
      referralProgram: referralProgram,
      enrollmentOuAccessible: enrollmentOuAccessible,
      referralFollowUpStage: referralFollowUpStage,
      referralToFollowUpLinkage: referralToFollowUpLinkage,
      referralOutcomeFollowUpFormSections:
          referralOutcomeFollowUpFormSections ?? [],
      beneficiary: beneficiary,
    );
    AppUtil.showActionSheetModal(
      context: context,
      containerBody: modal,
      initialHeightRatio: modalRatio,
      maxHeightRatio: modalRatio,
    );
  }

  List<ReferralOutcomeFollowUpEvent> getReferralOutComeFollowUps(
    Map<String?, List<Events>> eventListByProgramStage,
  ) {
    TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(
      eventListByProgramStage,
      [referralFollowUpStage],
    );
    List<Events> events = TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(
      eventListByProgramStage,
      [referralFollowUpStage],
    );
    List<ReferralOutcomeFollowUpEvent> referralOutComeFollowUps = events
        .map((Events event) => ReferralOutcomeFollowUpEvent().fromTeiModel(
            eventData: event,
            referralToFollowUpLinkage: referralToFollowUpLinkage))
        .toList();
    return referralOutComeFollowUps
        .where((referralOutComeFollowUp) =>
            referralOutComeFollowUp.referralReference ==
            referralOutComeEvent!.referralReference)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;

        return ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Date client reached the referral station',
                                  style: const TextStyle().copyWith(
                                    fontSize: 14.0,
                                    color: themeColor!.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                referralOutComeEvent!.dateClientReachStation!,
                                style: const TextStyle().copyWith(
                                  fontSize: 14.0,
                                  color: const Color(0xFF1A3518),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  currentLanguage == 'lesotho'
                                      ? 'Ho fanoe ka tšebeletso ea letsatsi'
                                      : 'Date service was provided',
                                  style: const TextStyle().copyWith(
                                    fontSize: 14.0,
                                    color: themeColor!.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                referralOutComeEvent!.dateServiceProvided!,
                                style: const TextStyle().copyWith(
                                  fontSize: 14.0,
                                  color: const Color(0xFF1A3518),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  currentLanguage == 'lesotho'
                                      ? "Maikutlo kapa mehato e latelang"
                                      : 'Comments or next steps',
                                  style: const TextStyle().copyWith(
                                    fontSize: 14.0,
                                    color: themeColor!.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                referralOutComeEvent!.comments!,
                                style: const TextStyle().copyWith(
                                  fontSize: 14.0,
                                  color: const Color(0xFF1A3518),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Consumer<ServiceEventDataState>(
                builder: (context, serviceEventDataState, child) {
                  Map<String?, List<Events>> eventListByProgramStage =
                      serviceEventDataState.eventListByProgramStage;
                  List<ReferralOutcomeFollowUpEvent>
                      referralOutComeFollowUpEvents =
                      getReferralOutComeFollowUps(eventListByProgramStage);
                  bool? canAddFollowUp = true;
                  for (var referralOutcomeFollowUpEvent
                      in referralOutComeFollowUpEvents) {
                    if (referralOutcomeFollowUpEvent
                                .additionalFollowUpRequired !=
                            null &&
                        !referralOutcomeFollowUpEvent
                            .additionalFollowUpRequired!) {
                      canAddFollowUp = referralOutcomeFollowUpEvent
                          .additionalFollowUpRequired;
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 10.0,
                          left: 20.0,
                        ),
                        child: ReferralOutComeFollowUp(
                          isEditableMode: isEditableMode,
                          themeColor: themeColor,
                          onEditFollowUp: () => onEditOutComeFollowUp(context),
                          referralOutComeFollowUpEvents:
                              referralOutComeFollowUpEvents,
                        ),
                      ),
                      Visibility(
                        visible: isEditableMode &&
                            referralOutComeEvent!.requiredFollowUp! &&
                            referralOutComeEvent!
                                .enrollmentOuAccessible!, //TODO
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeColor,
                          ),
                          child: Visibility(
                            visible: canAddFollowUp!,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () =>
                                        onAddReferralOutComeFollowUp(context),
                                    child: Text(
                                      'ADD FOLLOW-UP',
                                      style: const TextStyle().copyWith(
                                        color: const Color(0XFFFAFAFA),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
