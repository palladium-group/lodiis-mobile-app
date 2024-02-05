import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:provider/provider.dart';

class OvcMonitoringTopBarSelection extends StatelessWidget {
  final VoidCallback onSelectSchoolMonitoring;
  final VoidCallback onSelectServiceMonitoring;
  final bool isClicked;

  const OvcMonitoringTopBarSelection(
      {Key? key,
      required this.onSelectSchoolMonitoring,
      required this.onSelectServiceMonitoring,
      this.isClicked = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;

        return ClipRRect(
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
                      onPressed: onSelectServiceMonitoring,
                      child: Text(
                        currentLanguage == 'lesotho'
                            ? "Ts'ebeletso"
                            : 'Service',
                        style: const TextStyle().copyWith(
                          fontSize: 14.0,
                          color: !isClicked
                              ? Colors.white
                              : const Color(0xFF1A3518),
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
                      onPressed: onSelectSchoolMonitoring,
                      child: Text(
                        currentLanguage == 'lesotho' ? 'Sekolo' : 'School',
                        style: const TextStyle().copyWith(
                          fontSize: 14.0,
                          color: isClicked
                              ? Colors.white
                              : const Color(0xFF1A3518),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
