import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/referrals/beneficiary_referral_follow_up_container.dart';
import 'package:kb_mobile_app/core/components/referrals/beneficiary_referral_follow_up_modal.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/referral_outcome_event.dart';
import 'package:kb_mobile_app/models/referral_outcome_follow_up_event.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_referral/models/dreams_referral_follow_up.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/models/ovc_referral_follow_up.dart';
import 'package:provider/provider.dart';

class BeneficiaryReferralOutcome extends StatelessWidget {
  const BeneficiaryReferralOutcome({
    Key? key,
    required this.valueColor,
    required this.referralOutcomeEvent,
    required this.labelColor,
    required this.onEditReferralOutcome,
    required this.referralOutcomeFollowingUpProgramStage,
    required this.referralOutcomeFollowingUpLinkage,
    required this.beneficiary,
    required this.enrollmentOuAccessible,
    required this.referralProgram,
    required this.isOvcIntervention,
    required this.isHouseholdReferral,
    required this.isOnEditMode,
    required this.isIncomingReferral,
  }) : super(key: key);

  final Color valueColor;
  final ReferralOutcomeEvent referralOutcomeEvent;
  final Color labelColor;
  final String referralOutcomeFollowingUpProgramStage;
  final String referralOutcomeFollowingUpLinkage;
  final TrackedEntityInstance beneficiary;
  final bool enrollmentOuAccessible;
  final String referralProgram;
  final bool isOvcIntervention;
  final bool isOnEditMode;
  final bool isIncomingReferral;
  final bool isHouseholdReferral;

  final VoidCallback onEditReferralOutcome;

  final double editIconHeight = 20.0;

  void updateFormState(
    BuildContext context,
    ReferralOutcomeFollowUpEvent? referralOutcomeFollowUpEvent,
  ) {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: true);

    String location = enrollmentOuAccessible ? beneficiary.orgUnit ?? '' : '';
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('location', location);
    Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
        referralOutcomeFollowingUpLinkage,
        referralOutcomeEvent.referralFollowUpReference);
    if (referralOutcomeFollowUpEvent != null) {
      Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
          'eventDate', referralOutcomeFollowUpEvent.eventData?.eventDate);
      Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
          'eventId', referralOutcomeFollowUpEvent.eventData?.event);
      Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
          'location', referralOutcomeFollowUpEvent.eventData?.orgUnit);
      for (Map dataValue
          in referralOutcomeFollowUpEvent.eventData?.dataValues) {
        if (dataValue['value'] != '') {
          Provider.of<ServiceFormState>(context, listen: false)
              .setFormFieldState(dataValue['dataElement'], dataValue['value']);
        }
      }
    }
  }

  void onAddOrEditReferralFollowUp(
    BuildContext context,
    ReferralOutcomeFollowUpEvent? referralOutcomeFollowUpEvent,
  ) {
    updateFormState(context, referralOutcomeFollowUpEvent);
    double modalRatio = 0.65;
    Widget modal = BeneficiaryReferralFollowUpModal(
      referralToFollowUpLinkage: referralOutcomeFollowingUpLinkage,
      formSections: isOvcIntervention
          ? OvcReferralFollowUp.getFormSections(
              firstDate: referralOutcomeEvent.dateClientReachStation!,
            )
          : DreamsReferralFollowUp.getFormSections(
              firstDate: referralOutcomeEvent.dateClientReachStation!,
            ),
      hiddenFields: [
        referralOutcomeFollowingUpLinkage,
      ],
      mandatoryFields: isOvcIntervention
          ? OvcReferralFollowUp.getMandatoryFields()
          : DreamsReferralFollowUp.getMandatoryFields(),
      beneficiary: beneficiary,
      referralFollowUpStage: referralOutcomeFollowingUpProgramStage,
      referralProgram: referralProgram,
      isOvcIntervention: isOvcIntervention,
      enrollmentOuAccessible: enrollmentOuAccessible,
      themeColor:
          isOvcIntervention ? const Color(0xFF4B9F46) : const Color(0xFF1F8ECE),
    );
    AppUtil.showActionSheetModal(
      context: context,
      containerBody: modal,
      initialHeightRatio: modalRatio,
      maxHeightRatio: modalRatio,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 5.0,
          ),
          child: _getReferralOutcomeHeader(),
        ),
        LineSeparator(
          color: valueColor.withOpacity(0.3),
          height: 1,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 5.0,
          ),
          child: _getReferralOutcomeDetails(),
        ),
        Visibility(
          visible: referralOutcomeFollowingUpProgramStage.isNotEmpty &&
              referralOutcomeFollowingUpLinkage.isNotEmpty,
          child: Consumer<ServiceEventDataState>(
            builder: (context, serviceEventDataState, child) {
              List<ReferralOutcomeFollowUpEvent> referralOutcomeFollowUpEvents =
                  _getReferralOutcomFollowUps(
                      eventListByProgramStage:
                          serviceEventDataState.eventListByProgramStage);
              List<ReferralOutcomeFollowUpEvent> completedReferrals =
                  referralOutcomeFollowUpEvents
                      .where((followUp) => followUp.isCompleted!)
                      .toList();
              return Column(
                children: [
                  Visibility(
                    visible: referralOutcomeFollowUpEvents.isNotEmpty,
                    child: BeneficiaryReferralFollowUpContainer(
                      valueColor: valueColor,
                      isOnEditMode: isOnEditMode,
                      referralOutcomeFollowUpEvents:
                          referralOutcomeFollowUpEvents,
                      labelColor: labelColor,
                      onEditReferralFollowUp: (ReferralOutcomeFollowUpEvent
                              referralOutcomeFollowUpEvent) =>
                          onAddOrEditReferralFollowUp(
                              context, referralOutcomeFollowUpEvent),
                    ),
                  ),
                  Visibility(
                    visible: referralOutcomeEvent.requiredFollowUp! &&
                        completedReferrals.isEmpty &&
                        isOnEditMode,
                    child: Visibility(
                      visible: referralOutcomeEvent.referralServiceProvided!,
                      child: _getAddFollowUpButton(context),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Widget _getReferralOutcomeHeader() {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Text(
                languageState.currentLanguage == 'lesotho'
                    ? 'SEPHETHO'
                    : 'OUTCOME',
                style: const TextStyle().copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
          Consumer<ServiceEventDataState>(
            builder: (context, serviceEventDataState, child) {
              List<ReferralOutcomeFollowUpEvent> followingUps =
                  _getReferralOutcomFollowUps(
                eventListByProgramStage:
                    serviceEventDataState.eventListByProgramStage,
              );
              return Visibility(
                visible: followingUps.isEmpty &&
                    isOnEditMode &&
                    isIncomingReferral &&
                    enrollmentOuAccessible,
                child: Container(
                  margin: const EdgeInsets.symmetric(),
                  child: InkWell(
                    onTap: onEditReferralOutcome,
                    child: Container(
                      height: editIconHeight,
                      width: editIconHeight,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/edit-icon.svg',
                        colorFilter: ColorFilter.mode(
                          labelColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _getReferralOutcomeDetail({
    required String label,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 2.5,
      ),
      width: double.infinity,
      child: Text(
        label,
        style: const TextStyle().copyWith(
          fontSize: 14.0,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  List<ReferralOutcomeFollowUpEvent> _getReferralOutcomFollowUps({
    required Map<String?, List<Events>> eventListByProgramStage,
  }) {
    List<Events> events = TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(
      eventListByProgramStage,
      [referralOutcomeFollowingUpProgramStage],
      shouldSortByDate: true,
    ).where((Events eventData) {
      ReferralOutcomeFollowUpEvent referralOutcomeFollowUpEvent =
          ReferralOutcomeFollowUpEvent().fromTeiModel(
        eventData: eventData,
        referralToFollowUpLinkage: referralOutcomeFollowingUpLinkage,
      );
      return referralOutcomeFollowUpEvent.referralReference ==
          referralOutcomeEvent.referralFollowUpReference;
    }).toList();
    return events
        .map((Events eventData) => ReferralOutcomeFollowUpEvent().fromTeiModel(
              eventData: eventData,
              referralToFollowUpLinkage: referralOutcomeFollowingUpLinkage,
            ))
        .toList();
  }

  Widget _getReferralOutcomeDetails() {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Column(
        children: [
          _getReferralOutcomeDetail(
            label: 'Date client reached the referral station',
            color: labelColor,
          ),
          _getReferralOutcomeDetail(
            label: referralOutcomeEvent.dateClientReachStation!,
            color: valueColor,
          ),
          Visibility(
            visible: referralOutcomeEvent.referralServiceProvided!,
            child: _getReferralOutcomeDetail(
              label: languageState.currentLanguage == 'lesotho'
                  ? 'Ho fanoe ka tšebeletso ea letsatsi'
                  : 'Date service was provided',
              color: labelColor,
            ),
          ),
          Visibility(
            visible: referralOutcomeEvent.referralServiceProvided!,
            child: _getReferralOutcomeDetail(
              label: referralOutcomeEvent.dateServiceProvided!,
              color: valueColor,
            ),
          ),
          Visibility(
            visible: !referralOutcomeEvent.referralServiceProvided!,
            child: _getReferralOutcomeDetail(
              label: 'Reason for decline referral',
              color: labelColor,
            ),
          ),
          Visibility(
            visible: !referralOutcomeEvent.referralServiceProvided!,
            child: _getReferralOutcomeDetail(
              label: referralOutcomeEvent.reasonForDecline!,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAddFollowUpButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Column(
        children: [
          LineSeparator(
            color: labelColor.withOpacity(
              0.1,
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: labelColor,
              ),
              width: double.infinity,
              child: TextButton(
                onPressed: () => onAddOrEditReferralFollowUp(context, null),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Text(
                    'ADD FOLLOW UP',
                    style: const TextStyle().copyWith(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
