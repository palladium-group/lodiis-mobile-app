import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/models/education_beneficiary.dart';
import 'package:provider/provider.dart';

class EducationBeneficiaryCardBody extends StatelessWidget {
  const EducationBeneficiaryCardBody({
    Key? key,
    required this.isVerticalLayout,
    required this.educationBeneficiary,
  }) : super(key: key);

  final bool isVerticalLayout;
  final Color labelColor = const Color(0xFF009688);
  final Color valueColor = const Color(0xFF82898D);
  final EducationBeneficiary educationBeneficiary;

  Expanded _getHorizontalRowCardData({
    required Color labelColor,
    required Color valueColor,
    required String label,
    required String? value,
  }) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle().copyWith(
            color: labelColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle().copyWith(
                color: valueColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getVerticalRowCardData(
      {required Color labelColor,
      required Color valueColor,
      required String label,
      String? value,
      String? translatedLabel}) {
    return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
      String? currentLanguage = languageTranslationState.currentLanguage;
      return Container(
        margin: const EdgeInsets.only(
          bottom: 10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                currentLanguage == 'lesotho' ? translatedLabel ?? label : label,
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String? currentLanguage = languageTranslationState.currentLanguage;
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 13.0,
            vertical: 20.0,
          ),
          child: isVerticalLayout
              ? Column(
                  children: [
                    _getVerticalRowCardData(
                      label: 'Beneficiary ID',
                      translatedLabel: 'Nomoro ea boitsebiso ea ngoana',
                      value: educationBeneficiary.beneficiaryId,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: currentLanguage == 'lesotho' ? 'Lilemo' : 'Age',
                      value: educationBeneficiary.age.toString(),
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: currentLanguage == 'lesotho'
                          ? 'Lebitso la Sekolo'
                          : 'School Name',
                      value: educationBeneficiary.schoolName,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: currentLanguage == 'lesotho' ? 'Boleng' : 'Sex',
                      value: educationBeneficiary.sex,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label:
                          currentLanguage == 'lesotho' ? 'Sehlopha' : 'Grade',
                      value: educationBeneficiary.grade,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label:
                          currentLanguage == 'lesotho' ? 'Sebaka' : 'Location',
                      value: educationBeneficiary.location,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Table(
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Row(
                                          children: [
                                            _getHorizontalRowCardData(
                                              labelColor: labelColor,
                                              valueColor: valueColor,
                                              label:
                                                  currentLanguage == 'lesotho'
                                                      ? 'Lilemo'
                                                      : 'Age',
                                              value: educationBeneficiary.age
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: [
                                            _getHorizontalRowCardData(
                                              labelColor: labelColor,
                                              valueColor: valueColor,
                                              label:
                                                  currentLanguage == 'lesotho'
                                                      ? 'Boleng'
                                                      : 'Sex',
                                              value: educationBeneficiary.sex,
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                        child: Row(
                                          children: [
                                            _getHorizontalRowCardData(
                                              labelColor: labelColor,
                                              valueColor: valueColor,
                                              label:
                                                  currentLanguage == 'lesotho'
                                                      ? 'Sehlopha'
                                                      : 'Grade',
                                              value: educationBeneficiary.grade,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}
