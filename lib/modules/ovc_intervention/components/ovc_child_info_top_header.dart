import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/constants/program_status.dart';
import 'package:provider/provider.dart';

class OvcChildInfoTopHeader extends StatelessWidget {
  const OvcChildInfoTopHeader({
    Key? key,
  }) : super(key: key);

  Expanded _getOvcChildInfoDetailsWidget({
    String? currentLanguage,
    required String key,
    required Color keyColor,
    required String value,
    required Color valueColor,
    required double fontSize,
  }) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          text: key != '' ? '$key: ' : '',
          style: const TextStyle().copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: keyColor,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle().copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getStatus({
    required String programStatus,
    required int flex,
  }) {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 5.0,
            ),
            decoration: BoxDecoration(
              color: (programStatus == ProgramStatus.active
                      ? const Color(0xFF4B9F46)
                      : programStatus == ProgramStatus.transferred
                          ? Colors.amberAccent
                          : programStatus == ProgramStatus.exit
                              ? Colors.redAccent
                              : programStatus == ProgramStatus.graduated
                                  ? const Color(0xFF1F8DCE)
                                  : Colors.blueGrey)
                  .withOpacity(0.2),
              border: Border.all(
                color: programStatus == ProgramStatus.active
                    ? const Color(0xFF4B9F46)
                    : programStatus == ProgramStatus.transferred
                        ? Colors.amberAccent
                        : programStatus == ProgramStatus.exit
                            ? Colors.redAccent
                            : programStatus == ProgramStatus.graduated
                                ? const Color(0xFF1F8DCE)
                                : Colors.blueGrey,
              ),
              borderRadius: BorderRadius.circular(35.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 2.0,
            ),
            child: Text(
              programStatus,
              style: const TextStyle().copyWith(
                color: programStatus == ProgramStatus.active
                    ? const Color(0xFF4B9F46)
                    : programStatus == ProgramStatus.transferred
                        ? Colors.amberAccent.shade700
                        : programStatus == ProgramStatus.exit
                            ? Colors.redAccent
                            : programStatus == ProgramStatus.graduated
                                ? const Color(0xFF1F8DCE)
                                : Colors.blueGrey,
                fontSize: 12.0,
              ),
            ))
      ],
    );
  }

  Container _getChildStatusRow({
    required String status,
    required String key,
  }) {
    double fontSize = 13.0;
    Color keyColor = const Color(0xFF92A791);

    return status.isEmpty
        ? Container()
        : Container(
            margin: const EdgeInsets.symmetric(
              vertical: 2.0,
            ),
            child: Row(
              children: [
                Text(
                  key,
                  style: const TextStyle().copyWith(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: keyColor,
                  ),
                ),
                _getStatus(programStatus: status, flex: 2),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String? currentLanguage = languageTranslationState.currentLanguage;
        return Consumer<OvcHouseholdCurrentSelectionState>(
          builder: (context, ovcHouseholdCurrentSelectionState, child) {
            var currentOvcHouseholdChild =
                ovcHouseholdCurrentSelectionState.currentOvcHouseholdChild!;
            var currentOvcHousehold =
                ovcHouseholdCurrentSelectionState.currentOvcHousehold;
            return Material(
              type: MaterialType.card,
              elevation: 1.0,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _getOvcChildInfoDetailsWidget(
                            currentLanguage: currentLanguage,
                            key: "",
                            value: currentOvcHouseholdChild.toString(),
                            keyColor: const Color(0xFF1A3518),
                            valueColor: const Color(0xFF1A3518),
                            fontSize: 14.0,
                          ),
                          _getOvcChildInfoDetailsWidget(
                            currentLanguage: currentLanguage,
                            key: "",
                            value: currentOvcHouseholdChild.primaryUIC ?? "",
                            keyColor: const Color(0xFF1A3518),
                            valueColor: const Color(0xFF1A3518),
                            fontSize: 14.0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: const LineSeparator(color: Color(0XFFECF5EC)),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _getOvcChildInfoDetailsWidget(
                            currentLanguage: currentLanguage,
                            key:
                                currentLanguage == 'lesotho' ? 'Boleng' : 'Sex',
                            value: currentOvcHouseholdChild.sex ?? "",
                            keyColor: const Color(0xFF92A791),
                            valueColor: const Color(0xFF4B9F46),
                            fontSize: 12.0,
                          ),
                          _getOvcChildInfoDetailsWidget(
                            currentLanguage: currentLanguage,
                            key:
                                currentLanguage == 'lesotho' ? 'Lilemo' : 'Age',
                            value: currentOvcHouseholdChild.age ?? "",
                            keyColor: const Color(0xFF92A791),
                            valueColor: const Color(0xFF4B9F46),
                            fontSize: 12.0,
                          ),
                          _getOvcChildInfoDetailsWidget(
                            currentLanguage: currentLanguage,
                            key: currentLanguage == 'lesotho'
                                ? 'Boemo ba HIV'
                                : 'HIV Status',
                            value: currentOvcHouseholdChild.hivStatus ?? "",
                            keyColor: const Color(0xFF92A791),
                            valueColor: const Color(0xFF4B9F46),
                            fontSize: 12.0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _getOvcChildInfoDetailsWidget(
                            currentLanguage: currentLanguage,
                            key: currentLanguage == 'lesotho'
                                ? 'Nomoro ea mohala'
                                : 'Phone #',
                            value: currentOvcHousehold!.phoneNumber ?? '',
                            keyColor: const Color(0xFF92A791),
                            valueColor: const Color(0xFF4B9F46),
                            fontSize: 12.0,
                          ),
                          _getOvcChildInfoDetailsWidget(
                            currentLanguage: currentLanguage,
                            key: currentLanguage == 'lesotho'
                                ? 'Motse'
                                : 'Village',
                            value: currentOvcHousehold.village ?? '',
                            keyColor: const Color(0xFF92A791),
                            valueColor: const Color(0xFF4B9F46),
                            fontSize: 12.0,
                          ),
                          _getChildStatusRow(
                              key: currentLanguage == 'lesotho'
                                  ? 'Boemo'
                                  : 'Status',
                              status: currentOvcHouseholdChild.ovcStatus ?? ''),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _getOvcChildInfoDetailsWidget(
                            currentLanguage: currentLanguage,
                            key: currentLanguage == 'lesotho'
                                ? 'Mohlokomeli'
                                : 'Caregiver',
                            value: currentOvcHousehold.toString(),
                            keyColor: const Color(0xFF92A791),
                            valueColor: const Color(0xFF4B9F46),
                            fontSize: 12.0,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
