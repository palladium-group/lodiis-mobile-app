import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:provider/provider.dart';

class OvcHouseholdChildCount extends StatelessWidget {
  const OvcHouseholdChildCount({
    Key? key,
    required this.currentLanguage,
    required this.ovcHousehold,
  }) : super(key: key);

  final String? currentLanguage;
  final OvcHousehold ovcHousehold;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) => Container(
        margin: const EdgeInsets.symmetric(
          vertical: 2.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                languageTranslationState.currentLanguage == 'lesotho'
                    ? 'Palo ea OVC'
                    : '# of OVC',
                
                style: const TextStyle().copyWith(
                  fontSize: 14.0,
                  color: const Color(0XFF92A791),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text(
                    currentLanguage == 'lesotho'
                        ? 'Mosali - ${ovcHousehold.ovcFemaleCount}'
                        : 'Female - ${ovcHousehold.ovcFemaleCount}',
                    style: const TextStyle().copyWith(
                      fontSize: 14.0,
                      color: const Color(0XFF536852),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    height: 14.0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Color(0xFFC9E2C7),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    currentLanguage == 'lesotho'
                        ? 'Monna - ${ovcHousehold.ovcMaleCount}'
                        : 'Male - ${ovcHousehold.ovcMaleCount}',
                    style: const TextStyle().copyWith(
                      fontSize: 14.0,
                      color: const Color(0XFF536852),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
