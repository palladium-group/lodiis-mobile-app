import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/models/ogac_beneficiary.dart';
import 'package:provider/provider.dart';

class OgacBeneficiaryCardBody extends StatelessWidget {
  const OgacBeneficiaryCardBody({
    Key? key,
    required this.ogacBeneficiary,
  }) : super(key: key);

  final OgacBeneficiary ogacBeneficiary;

  Widget _getRowBeneficiaryData(
      {required String key, required String value, String? translatedKey}) {
    return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
      String? currentLanguage = languageTranslationState.currentLanguage;
      return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                currentLanguage == 'lesotho' ? translatedKey ?? key : key,
                style: const TextStyle().copyWith(
                  color: const Color(0xFF651900).withOpacity(0.4),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value,
                style: const TextStyle().copyWith(
                  color: const Color(0xFF651900).withOpacity(0.8),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      child: Column(
        children: [
          _getRowBeneficiaryData(
            key: 'Beneficiary Id',
            translatedKey: 'Nomoro ea boitsebiso ea ngoana',
            value: ogacBeneficiary.beneficiaryId!,
          ),
          _getRowBeneficiaryData(
            key: 'Age',
            translatedKey: 'Lilemo',
            value: ogacBeneficiary.age!,
          ),
          _getRowBeneficiaryData(
            key: 'Sex',
            translatedKey: 'Boleng',
            value: ogacBeneficiary.sex!,
          ),
          _getRowBeneficiaryData(
            key: 'Phone number',
            translatedKey: 'Nomoro ea mohala',
            value: ogacBeneficiary.phoneNumber!,
          ),
          _getRowBeneficiaryData(
            key: 'Location',
            translatedKey: 'Sebaka',
            value: ogacBeneficiary.location!,
          ),
          _getRowBeneficiaryData(
            key: 'Village',
            translatedKey: 'Motse',
            value: ogacBeneficiary.village!,
          ),
          _getRowBeneficiaryData(
            key: 'Created on',
            translatedKey: 'O kentsoe ka letsatsi la',
            value: ogacBeneficiary.beneficiaryId!,
          ),
        ],
      ),
    );
  }
}
