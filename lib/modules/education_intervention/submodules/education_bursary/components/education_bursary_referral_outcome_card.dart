import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/constants/bursary_intervention_constant.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/bursary_referral_outcome_event.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/bursary_referral_outcome_follow_up_event.dart';
import 'package:provider/provider.dart';

class EducationBursaryReferralOutcomeCard extends StatelessWidget {
  const EducationBursaryReferralOutcomeCard({
    Key? key,
    required this.referralOutcomeEvent,
    this.onEditReferralOutcome,
  }) : super(key: key);

  final BursaryReferralOutcomeEvent referralOutcomeEvent;
  final VoidCallback? onEditReferralOutcome;

  final double iconHeight = 18.0;
  final String svgIcon = 'assets/icons/edit-icon.svg';
  final Color labelColor = const Color(0xFF009688);
  final Color valueColor = const Color(0xFF82898D);

  Container _getReferralOutcomeDetailData({
    required Color labelColor,
    required Color valueColor,
    required String label,
    String? value,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              bottom: 5.0,
            ),
            child: Text(
              label,
              style: const TextStyle().copyWith(
                color: labelColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value!,
            style: const TextStyle().copyWith(
              color: valueColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> programStageIds = [
      BursaryInterventionConstant
          .clubAttendanceReferralOutcomeFollowUpProgamStage
    ];
    return Consumer<ServiceEventDataState>(
        builder: (context, serviceEventDataState, child) {
      Map<String?, List<Events>> eventListByProgramStage =
          serviceEventDataState.eventListByProgramStage;
      List<Events> events = TrackedEntityInstanceUtil
          .getAllEventListFromServiceDataStateByProgramStages(
              eventListByProgramStage, programStageIds);
      List<BursaryReferralOutcomeFollowUpEvent> referralOutcomeFollowUps =
          events
              .map((Events eventData) =>
                  BursaryReferralOutcomeFollowUpEvent().fromTeiModel(eventData))
              .toList()
              .where((BursaryReferralOutcomeFollowUpEvent
                      referralOutcomeFollowUpEvent) =>
                  referralOutcomeFollowUpEvent
                      .referralOutcomeToReferralOutComeFollowingUpLinkage ==
                  referralOutcomeEvent
                      .referralOutcomeToReferralOutComeFollowingUpLinkage)
              .toList();
      bool hasOutccomeHasFollowUps = referralOutcomeFollowUps.isNotEmpty;
      return Consumer<LanguageTranslationState>(
          builder: (context, languageTranslationState, child) {
        String? currentLanguage = languageTranslationState.currentLanguage;
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 15.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 7.0,
                      ),
                      child: Text(
                        currentLanguage == 'lesotho' ? 'Sephetho' : 'Outcome',
                        style: const TextStyle().copyWith(
                          color: const Color(0xFFB2B7B9),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !hasOutccomeHasFollowUps &&
                        referralOutcomeEvent.enrollmentOuAccessible!,
                    child: InkWell(
                      onTap: onEditReferralOutcome,
                      child: Container(
                        height: iconHeight,
                        width: iconHeight,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 5.0,
                        ),
                        child: SvgPicture.asset(
                          svgIcon,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF009688),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const LineSeparator(
              color: Color(0xFFB2B7B9),
              height: 1.0,
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10.0,
                left: 15.0,
                right: 15.0,
              ),
              child: Column(
                children: [
                  _getReferralOutcomeDetailData(
                    labelColor: labelColor,
                    valueColor: valueColor,
                    label: currentLanguage == 'lesotho'
                        ? "Letsatsi leo ts'ebeletso e fanoeng ka lona"
                        : 'Date service was provided',
                    value: referralOutcomeEvent.dateOfServiceProvided,
                  ),
                  _getReferralOutcomeDetailData(
                    labelColor: labelColor,
                    valueColor: valueColor,
                    label: currentLanguage == 'lesotho'
                        ? 'Maikutlo kapa mehato e latelang'
                        : 'Comments or next steps',
                    value: referralOutcomeEvent.comments,
                  ),
                ],
              ),
            )
          ],
        );
      });
    });
  }
}
