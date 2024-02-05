import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/bursary_referral_outcome_follow_up_event.dart';
import 'package:provider/provider.dart';

class EducationBursaryReferralOutcomeFollowUpCard extends StatelessWidget {
  const EducationBursaryReferralOutcomeFollowUpCard({
    Key? key,
    required this.color,
    required this.followUpIndex,
    required this.shouldEditFollowingUp,
    required this.referralOutcomeFollowUpEvent,
    required this.onAddOutComeFollowingUp,
  }) : super(key: key);

  final Color color;
  final int followUpIndex;
  final bool shouldEditFollowingUp;
  final BursaryReferralOutcomeFollowUpEvent referralOutcomeFollowUpEvent;
  final VoidCallback? onAddOutComeFollowingUp;

  final double iconHeight = 18.0;
  final String svgIcon = 'assets/icons/edit-icon.svg';
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
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;

        return Column(
          children: [
            LineSeparator(
              color: color.withOpacity(0.7),
              height: 1.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      currentLanguage == 'lesotho'
                          ? 'Tšalo-morao $followUpIndex'
                          : 'FOLLOW UP $followUpIndex',
                      style: const TextStyle().copyWith(
                        color: color,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: shouldEditFollowingUp,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: InkWell(
                        onTap: onAddOutComeFollowingUp,
                        child: Container(
                          height: iconHeight,
                          width: iconHeight,
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 5.0,
                          ),
                          child: SvgPicture.asset(
                            svgIcon,
                            colorFilter: ColorFilter.mode(
                              color,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            LineSeparator(
              color: color.withOpacity(0.7),
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
                    labelColor: color,
                    valueColor: valueColor,
                    label: currentLanguage == 'lesotho'
                        ? "Letsatsi la ts'alo morao"
                        : 'Follow up date',
                    value: referralOutcomeFollowUpEvent.followUpDate,
                  ),
                  _getReferralOutcomeDetailData(
                    labelColor: color,
                    valueColor: valueColor,
                    label: currentLanguage == 'lesotho'
                        ? 'Follow up status'
                        : 'Follow up status',
                    value: referralOutcomeFollowUpEvent.followUpStatus,
                  ),
                  _getReferralOutcomeDetailData(
                    labelColor: color,
                    valueColor: valueColor,
                    label: currentLanguage == 'lesotho'
                        ? 'Maikutlo kapa mehato e latelang'
                        : 'Comments or next steps',
                    value: referralOutcomeFollowUpEvent.comments,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
