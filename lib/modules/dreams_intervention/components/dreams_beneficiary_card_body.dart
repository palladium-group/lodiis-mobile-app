import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card_service_summary.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_service_summary_constant.dart';
import 'package:provider/provider.dart';

class DreamsBeneficiaryCardBody extends StatelessWidget {
  const DreamsBeneficiaryCardBody({
    Key? key,
    required this.isVerticalLayout,
    required this.agywBeneficiary,
    required this.canViewServiceCategory,
  }) : super(key: key);

  final bool isVerticalLayout;
  final bool canViewServiceCategory;
  final Color labelColor = const Color(0xFF8FBAD3);
  final Color valueColor = const Color(0xFF444E54);
  final AgywDream agywBeneficiary;

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

  Container _getVerticalRowCardData({
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
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 13.0,
            vertical: 20.0,
          ),
          child: isVerticalLayout
              ? Column(
                  children: [
                    _getVerticalRowCardData(
                      label: 'Created',
                      value: agywBeneficiary.createdDate,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: 'Primary UIC',
                      value: agywBeneficiary.primaryUIC,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: currentLanguage == 'lesotho'
                          ? 'Letsatsi la tsoalo'
                          : 'Date of Birth',
                      value: agywBeneficiary.dateOfBirth,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: currentLanguage == 'lesotho' ? 'Lilemo' : 'Age',
                      value: agywBeneficiary.age.toString(),
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: currentLanguage == 'lesotho'
                          ? 'Sehlopha sa lilemo'
                          : 'Age band',
                      value: agywBeneficiary.ageBand,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: currentLanguage == 'lesotho' ? 'Boleng' : 'Sex',
                      value: agywBeneficiary.sex,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: currentLanguage == 'lesotho'
                          ? 'Nomoro ea mohala'
                          : 'Phone #',
                      value: agywBeneficiary.phoneNumber,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label:
                          currentLanguage == 'lesotho' ? 'Sebaka' : 'Location',
                      value: agywBeneficiary.location,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: currentLanguage == 'lesotho' ? 'Motse' : 'Village',
                      value: agywBeneficiary.village,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: currentLanguage == 'lesotho'
                          ? 'Sebaka se tsejoang haufi'
                          : 'Land mark near residence',
                      value: agywBeneficiary.landMark,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    _getVerticalRowCardData(
                      label: 'Enrolled Organisation unit',
                      value: agywBeneficiary.enrolledOrganisation,
                      labelColor: labelColor,
                      valueColor: valueColor,
                    ),
                    Visibility(
                        visible: agywBeneficiary.beneficiaryType != '',
                        child: _getVerticalRowCardData(
                          label: 'PrEP beneficiary type',
                          value: agywBeneficiary.beneficiaryType,
                          labelColor: labelColor,
                          valueColor: valueColor,
                        )),
                    Visibility(
                      visible: canViewServiceCategory && isVerticalLayout,
                      child: DreamsBeneficiaryCardServiceSummary(
                        services: AgywDreamsServiceSummaryConstant
                            .getServiceSummaryList(),
                        labelColor: valueColor,
                      ),
                    )
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
                                              value: agywBeneficiary.age
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
                                              value: agywBeneficiary.sex,
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
                                              label: 'En Org',
                                              value: agywBeneficiary
                                                  .enrolledOrganisation,
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
