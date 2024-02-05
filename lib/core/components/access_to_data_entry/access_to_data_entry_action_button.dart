import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:provider/provider.dart';

class AccessToDataEntryActionButton extends StatelessWidget {
  const AccessToDataEntryActionButton({
    Key? key,
    required this.activeInterventionProgram,
    required this.onLogout,
    required this.onCloseApp,
  }) : super(key: key);

  final InterventionCard activeInterventionProgram;
  final VoidCallback onLogout;
  final VoidCallback onCloseApp;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Container(
        padding: const EdgeInsets.only(
          top: 40.0,
          left: 10.0,
          right: 10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.only(
                right: 5.0,
              ),
              child: TextButton(
                onPressed: onLogout,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: activeInterventionProgram.primaryColor ??
                          const Color(0xFFFAFAFA),
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    languageState.currentLanguage == 'lesotho'
                        ? "Tsoa"
                        : "Log out",
                    style: TextStyle(
                      color: activeInterventionProgram.primaryColor ??
                          const Color(0xFFFAFAFA),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 5.0,
              ),
              child: TextButton(
                onPressed: onCloseApp,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: activeInterventionProgram.primaryColor ??
                          const Color(0xFFFAFAFA),
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    languageState.currentLanguage == 'lesotho'
                        ? "Koala App"
                        : "Close App",
                    style: TextStyle(
                      color: activeInterventionProgram.primaryColor ??
                          const Color(0xFFFAFAFA),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
