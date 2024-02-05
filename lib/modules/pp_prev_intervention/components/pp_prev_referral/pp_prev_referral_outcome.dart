import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/models/pp_prev_referral_outcome_event.dart';
import 'package:provider/provider.dart';

class PpPrevReferralOutcome extends StatelessWidget {
  const PpPrevReferralOutcome({
    Key? key,
    required this.labelColor,
    required this.referralOutcomeEvent,
    required this.referralProgram,
    required this.valueColor,
    required this.onEditReferralOutcome,
    required this.canEdit,
  }) : super(key: key);

  final Color valueColor;
  final PpPrevReferralOutcomeEvent referralOutcomeEvent;
  final Color labelColor;
  final String referralProgram;
  final VoidCallback onEditReferralOutcome;
  final bool canEdit;

  final double editIconHeight = 20.0;

  Widget _getReferralOutcomeDetailsRow(
      {required String label, required Color color, String? translatedLabel}) {
    return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
      String? currentLanguage = languageTranslationState.currentLanguage;
      return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 2.5,
        ),
        width: double.infinity,
        child: Text(
          currentLanguage == 'lesotho' ? translatedLabel ?? label : label,
          style: const TextStyle().copyWith(
            fontSize: 14.0,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    });
  }

  Widget _getReferralOutcomeDetails() {
    return Column(
      children: [
        _getReferralOutcomeDetailsRow(
          label: 'Referral service provided',
          color: labelColor,
        ),
        _getReferralOutcomeDetailsRow(
          label: referralOutcomeEvent.referralServiceProvided == true
              ? 'Yes'
              : 'No',
          color: valueColor,
        ),
        Visibility(
          visible: referralOutcomeEvent.referralServiceProvided == true,
          child: _getReferralOutcomeDetailsRow(
            label: 'Date of service provision',
            color: labelColor,
          ),
        ),
        Visibility(
          visible: referralOutcomeEvent.referralServiceProvided == true,
          child: _getReferralOutcomeDetailsRow(
            label: referralOutcomeEvent.serviceProvisionDate ?? 'N/A',
            color: valueColor,
          ),
        ),
        _getReferralOutcomeDetailsRow(
          label: 'Follow up required',
          color: labelColor,
        ),
        _getReferralOutcomeDetailsRow(
          label: referralOutcomeEvent.followUpRequired == true ? 'Yes' : 'No',
          color: valueColor,
        ),
        Visibility(
          visible: referralOutcomeEvent.followUpRequired == true,
          child: _getReferralOutcomeDetailsRow(
            label: 'Follow Date',
            color: labelColor,
          ),
        ),
        Visibility(
          visible: referralOutcomeEvent.followUpRequired == true,
          child: _getReferralOutcomeDetailsRow(
            label: referralOutcomeEvent.followUpDate ?? '',
            color: valueColor,
          ),
        ),
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
          Visibility(
            visible: canEdit,
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: valueColor.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(16.0)),
      child: Column(
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
        ],
      ),
    );
  }
}
