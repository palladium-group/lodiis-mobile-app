import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/constants/program_status.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_child_count.dart';
import 'package:provider/provider.dart';

class OvcHouseholdCardBody extends StatelessWidget {
  const OvcHouseholdCardBody({
    Key? key,
    required this.ovcHousehold,
  }) : super(key: key);

  final OvcHousehold ovcHousehold;
  Expanded _getOvcHouseholdDetailsWidget({
    required String value,
    required int flex,
    required Color color,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        value,
        style: const TextStyle().copyWith(
          fontSize: 14.0,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Container _getOvcHouseholdRowWidget({
    required String key,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 2.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _getOvcHouseholdDetailsWidget(
            value: key,
            flex: 1,
            color: const Color(0XFF536852),
          ),
          _getOvcHouseholdDetailsWidget(
            value: value,
            flex: 2,
            color: const Color(0XFF92A791),
          ),
        ],
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
          ),
        ),
        // work around to avoid large status icon
        Expanded(child: Container())
      ],
    );
  }

  Container _getHouseholdStatusRow({
    required String status,
    required String key,
  }) {
    return status.isEmpty
        ? Container()
        : Container(
            margin: const EdgeInsets.symmetric(
              vertical: 2.0,
            ),
            child: Row(
              children: [
                _getOvcHouseholdDetailsWidget(
                  value: key,
                  flex: 1,
                  color: const Color(0XFF536852),
                ),
                Expanded(
                    flex: 2, child: _getStatus(programStatus: status, flex: 2))
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
            vertical: 10.0,
          ),
          child: Column(
            children: [
              _getOvcHouseholdRowWidget(
                key: currentLanguage == 'lesotho' ? 'Mohlokomeli' : 'Caregiver',
                value: ovcHousehold.toString(),
              ),
              _getOvcHouseholdRowWidget(
                key: "Created",
                value: ovcHousehold.createdDate!,
              ),
              _getOvcHouseholdRowWidget(
                key: currentLanguage == 'lesotho' ? 'Sebaka' : 'Location',
                value: ovcHousehold.location!,
              ),
              _getHouseholdStatusRow(
                key: currentLanguage == 'lesotho' ? 'Boemo' : 'Status',
                status: ovcHousehold.houseHoldStatus ?? '',
              ),
              OvcHouseholdChildCount(
                currentLanguage: currentLanguage,
                ovcHousehold: ovcHousehold,
              )
            ],
          ),
        );
      },
    );
  }
}
