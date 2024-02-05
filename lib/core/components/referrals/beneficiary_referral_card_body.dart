import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/models/referral_event.dart';
import 'package:provider/provider.dart';

class BeneficiaryReferralCardBody extends StatelessWidget {
  const BeneficiaryReferralCardBody({
    Key? key,
    required this.referralEvent,
    required this.labelColor,
    required this.valueColor,
    required this.isIncomingReferral,
  }) : super(key: key);

  final ReferralEvent referralEvent;
  final bool isIncomingReferral;
  final Color valueColor;
  final Color labelColor;

  Widget _getReferralDetails({
    required String key,
    required String value,
    bool isVisible = true,
  }) {
    return Visibility(
      visible: isVisible,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 2.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                key,
                style: const TextStyle().copyWith(
                  fontSize: 14.0,
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value != "" ? value : 'N/A',
                style: const TextStyle().copyWith(
                  fontSize: 14.0,
                  color: valueColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 13.0,
            vertical: 10.0,
          ),
          child: Column(
            children: [
              _getReferralDetails(
                key: currentLanguage == 'lesotho' ? 'Letsatsi' : 'Date',
                value: referralEvent.date!,
              ),
              _getReferralDetails(
                key: currentLanguage == 'lesotho'
                    ? 'Tsela ea tsebetso'
                    : 'Service mode',
                value: referralEvent.serviceMode!,
              ),
              _getReferralDetails(
                key: currentLanguage == 'lesotho' ? 'Sehlopha' : 'Category',
                value: referralEvent.category!,
              ),
              _getReferralDetails(
                key: currentLanguage == 'lesotho'
                    ? 'Phetisetso ho'
                    : 'Referred to',
                value: referralEvent.location!,
              ),
              _getReferralDetails(
                isVisible: referralEvent.referredToIp!.isNotEmpty,
                key: isIncomingReferral
                    ? 'Referred issued from '
                    : 'Referred issued to ',
                value: isIncomingReferral
                    ? referralEvent.referredFromIp!
                    : referralEvent.referredToIp!,
              ),
              _getReferralDetails(
                key: currentLanguage == 'lesotho' ? 'Mofuta' : 'Type',
                value: referralEvent.type!,
              ),
              _getReferralDetails(
                key: currentLanguage == 'lesotho' ? 'Boemo' : 'Status',
                value: referralEvent.status!,
              ),
            ],
          ),
        );
      },
    );
  }
}
