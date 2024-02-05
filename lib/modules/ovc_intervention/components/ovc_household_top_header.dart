import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/constants/program_status.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_card_header.dart';
import 'package:provider/provider.dart';

class OvcHouseholdInfoTopHeader extends StatelessWidget {
  const OvcHouseholdInfoTopHeader({
    Key? key,
    required this.currentOvcHousehold,
  }) : super(key: key);
  final OvcHousehold? currentOvcHousehold;
  final String svgIcon = 'assets/icons/hh_icon.svg';

  Expanded _getOvcHouseholdDetailsWidget({
    required String key,
    required String value,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: RichText(
          text: TextSpan(
            text: '$key: ',
            style: const TextStyle().copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF92A791),
            ),
            children: [
              TextSpan(
                text: value,
                style: const TextStyle().copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF536852),
                ),
              )
            ],
          ),
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

  Container _getHouseholdStatusRow({
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
        return Material(
          type: MaterialType.card,
          elevation: 1.0,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OvcHouseholdCardHeader(
                  ovcHousehold: currentOvcHousehold,
                  svgIcon: svgIcon,
                  canEdit: false,
                  canExpand: false,
                  canView: false,
                  isExpanded: false,
                ),
                Row(
                  children: [
                    _getOvcHouseholdDetailsWidget(
                      key: currentLanguage == 'lesotho'
                          ? 'Mohlokomeli'
                          : 'Caregiver',
                      value: currentOvcHousehold.toString(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _getOvcHouseholdDetailsWidget(
                      key: currentLanguage == 'lesotho'
                          ? 'Nomoro ea mohala'
                          : 'Phone #',
                      value: currentOvcHousehold!.phoneNumber ?? '',
                    ),
                    _getOvcHouseholdDetailsWidget(
                      key: currentLanguage == 'lesotho' ? 'Motse' : 'Village',
                      value: currentOvcHousehold!.village ?? '',
                    ),
                    _getHouseholdStatusRow(
                        key: currentLanguage == 'lesotho' ? 'Boemo' : 'Status',
                        status: currentOvcHousehold?.houseHoldStatus ?? '')
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
