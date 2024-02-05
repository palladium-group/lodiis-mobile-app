import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:provider/provider.dart';

class EducationBeneficiaryButton extends StatelessWidget {
  const EducationBeneficiaryButton({
    Key? key,
    required this.label,
    required this.isVisible,
    required this.hasSplitBorder,
    this.translatedLabel,
    this.onTap,
  }) : super(key: key);

  final String label;
  final bool isVisible;
  final bool hasSplitBorder;
  final VoidCallback? onTap;
  final String? translatedLabel;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
      String? currentLanguage = languageTranslationState.currentLanguage;

      return Visibility(
        visible: isVisible,
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5.0,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 20.0,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        currentLanguage == 'lesotho'
                            ? translatedLabel ?? label
                            : label,
                        style: const TextStyle().copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF009688),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: hasSplitBorder,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 1.0,
                        color: Color(0xFF009688),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
