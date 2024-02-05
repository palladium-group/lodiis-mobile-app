import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/models/referral_outcome_follow_up_event.dart';
import 'package:provider/provider.dart';

class BeneficiaryReferralFollowUpContainer extends StatelessWidget {
  const BeneficiaryReferralFollowUpContainer({
    Key? key,
    required this.valueColor,
    required this.isOnEditMode,
    required this.referralOutcomeFollowUpEvents,
    required this.labelColor,
    required this.onEditReferralFollowUp,
  }) : super(key: key);

  final Color valueColor;
  final bool isOnEditMode;
  final List<ReferralOutcomeFollowUpEvent> referralOutcomeFollowUpEvents;
  final Color labelColor;

  final Function onEditReferralFollowUp;

  final double editIconHeight = 20.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;

        return Container(
          margin: const EdgeInsets.only(
            left: 20.0,
          ),
          child: Column(
            children: referralOutcomeFollowUpEvents.map((referralFollowUp) {
              int index =
                  referralOutcomeFollowUpEvents.indexOf(referralFollowUp) + 1;
              return Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: Column(
                  children: [
                    LineSeparator(
                      color: labelColor.withOpacity(0.3),
                      height: 1.0,
                    ),
                    _getReferralFollowingUpHeader(
                      index: index,
                      referralFollowUp: referralFollowUp,
                    ),
                    LineSeparator(
                      color: labelColor.withOpacity(0.3),
                      height: 1.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      child: Column(
                        children: [
                          _getReferralFollowUpDetail(
                            label: currentLanguage == 'lesotho'
                                ? 'Latsatsi la tlhahlobo e latelang'
                                : 'Follow-up date',
                            color: labelColor,
                          ),
                          _getReferralFollowUpDetail(
                            label: referralFollowUp.followUpDate!,
                            color: valueColor,
                          ),
                          _getReferralFollowUpDetail(
                            label: 'Follow-up Status',
                            color: labelColor,
                          ),
                          _getReferralFollowUpDetail(
                            label: referralFollowUp.followUpStatus!,
                            color: valueColor,
                          ),
                          _getReferralFollowUpDetail(
                            label: currentLanguage == 'lesotho'
                                ? "Maikutlo kapa mehato e latelang"
                                : 'Comments or next steps',
                            color: labelColor,
                          ),
                          _getReferralFollowUpDetail(
                            label: referralFollowUp.comments!,
                            color: valueColor,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _getReferralFollowUpDetail({
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

  Widget _getReferralFollowingUpHeader({
    required int index,
    required ReferralOutcomeFollowUpEvent referralFollowUp,
  }) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;

        return Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 5.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  currentLanguage == 'lesotho'
                      ? 'Tšalo-morao $index'
                      : 'FOLLOW UP $index',
                  style: const TextStyle().copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Visibility(
                visible: index == referralOutcomeFollowUpEvents.length &&
                    referralFollowUp.enrollmentOuAccessible! &&
                    isOnEditMode,
                child: InkWell(
                  onTap: () => onEditReferralFollowUp(referralFollowUp),
                  child: Container(
                    height: editIconHeight,
                    width: editIconHeight,
                    margin: const EdgeInsets.symmetric(
                      vertical: 1.0,
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
              )
            ],
          ),
        );
      },
    );
  }
}
