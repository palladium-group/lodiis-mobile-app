import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:provider/provider.dart';
class OvcReferralTopBarSelection extends StatelessWidget {
  final VoidCallback onSelectCLOReferral;
  final VoidCallback onSelectReferral;
  final bool isClicked;

  const OvcReferralTopBarSelection(
      {Key? key,
      required this.onSelectCLOReferral,
      required this.onSelectReferral,
      this.isClicked = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.only(),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Container(
            decoration: const BoxDecoration(color: Colors.black12),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: !isClicked
                          ? const Color(0xFF4B9F46)
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 5.0,
                      ),
                    ),
                    onPressed: onSelectReferral,
                    child: Text(
                      languageState.currentLanguage == 'lesotho'
                          ? 'phetisetso'
                          : 'Referral',
                      style: const TextStyle().copyWith(
                        fontSize: 14.0,
                        color:
                            !isClicked ? Colors.white : const Color(0xFF1A3518),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: isClicked
                          ? const Color(0xFF4B9F46)
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 5.0,
                      ),
                    ),
                    onPressed: onSelectCLOReferral,
                    child: Text(
                      'CLO Referral',
                      style: const TextStyle().copyWith(
                        fontSize: 14.0,
                        color:
                            isClicked ? Colors.white : const Color(0xFF1A3518),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
