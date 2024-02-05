import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/models/bursary_referral_event.dart';
import 'package:provider/provider.dart';

class EducationBursaryReferralBody extends StatelessWidget {
  const EducationBursaryReferralBody({
    Key? key,
    required this.bursaryReferral,
  }) : super(key: key);

  final BursaryReferralEvent bursaryReferral;

  final Color labelColor = const Color(0xFF009688);
  final Color valueColor = const Color(0xFF82898D);

  Container _getReferralDetailData({
    required Color labelColor,
    required Color valueColor,
    required String label,
    String? value,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle().copyWith(
                color: labelColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value!,
              style: const TextStyle().copyWith(
                color: valueColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
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
      String? currentLanguage = languageTranslationState.currentLanguage;
      return Column(
        children: [
          LineSeparator(
            color: const Color(0xFF009688).withOpacity(0.2),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: Column(
                children: [
                  _getReferralDetailData(
                    labelColor: labelColor,
                    valueColor: valueColor,
                    label: currentLanguage == 'lesotho' ? 'Date' : 'Date',
                    value: bursaryReferral.date,
                  ),
                  _getReferralDetailData(
                    labelColor: labelColor,
                    valueColor: valueColor,
                    label:
                        currentLanguage == 'lesotho' ? 'Phetisetso' : 'Referral',
                    value: bursaryReferral.referral,
                  ),
                  _getReferralDetailData(
                    labelColor: labelColor,
                    valueColor: valueColor,
                    label: currentLanguage == 'lesotho'
                        ? 'Phetisetso ho'
                        : 'Referred To',
                    value: bursaryReferral.referralTo,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
