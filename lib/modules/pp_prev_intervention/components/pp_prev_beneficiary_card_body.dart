import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/models/pp_prev_beneficiary.dart';
import 'package:provider/provider.dart';

class PpPrevBeneficiaryCardBody extends StatelessWidget {
  const PpPrevBeneficiaryCardBody({
    Key? key,
    required this.ppPrevBeneficiary,
  }) : super(key: key);

  final PpPrevBeneficiary ppPrevBeneficiary;

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
                  color: const Color(0xFF9B2BAE).withOpacity(0.4),
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
                  color: const Color(0xFF9B2BAE).withOpacity(0.9),
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
            key: 'Location',
            translatedKey: 'Sebaka',
            value: ppPrevBeneficiary.location!,
          ),
          _getRowBeneficiaryData(
            key: 'Village',
            translatedKey: 'Motse',
            value: ppPrevBeneficiary.village!,
          ),
          _getRowBeneficiaryData(
            key: 'Age',
            translatedKey: 'Lilemo',
            value: ppPrevBeneficiary.age!,
          ),
          _getRowBeneficiaryData(
            key: 'Sex',
            translatedKey: 'Boleng',
            value: ppPrevBeneficiary.sex!,
          ),
          _getRowBeneficiaryData(
            key: 'Phone number',
            translatedKey: 'Nomoro ea mohala',
            value: ppPrevBeneficiary.phoneNumber!,
          ),
          _getRowBeneficiaryData(
            key: 'Created on',
            translatedKey: 'O kentsoe ka letsatsi la',
            value: ppPrevBeneficiary.createdDate!,
          ),
        ],
      ),
    );
  }
}
