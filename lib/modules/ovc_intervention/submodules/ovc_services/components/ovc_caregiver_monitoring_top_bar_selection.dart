
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:provider/provider.dart';

class OvcHouseholdMonitoringTopBarSelection extends StatelessWidget {
  final VoidCallback onSelectVLMonitoring;
  final VoidCallback onSelectServiceMonitoring;
  final bool isClicked;

  /// NEW: whether the beneficiary is eligible to view Viral Load
  final bool isVLEligible;

  const OvcHouseholdMonitoringTopBarSelection({
    Key? key,
    required this.onSelectVLMonitoring,
    required this.onSelectServiceMonitoring,
    this.isClicked = false,
    this.isVLEligible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        final String currentLanguage = languageTranslationState.currentLanguage;
        final Color active = const Color(0xFF4B9F46);
        final Color inactiveText = const Color(0xFF1A3518);

        return ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: const BorderRadius.only(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: const BoxDecoration(color: Colors.black12),
            child: Row(
              children: [
                // Assessment / Services
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: !isClicked ? active : Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),
                    onPressed: onSelectServiceMonitoring,
                    child: Text(
                      currentLanguage == 'lesotho' ? "Tlhahlobo" : 'Assessment',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: !isClicked ? Colors.white : inactiveText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Viral Load
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: (isClicked && isVLEligible) ? active : Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),
                    // Disable if not eligible
                    onPressed: isVLEligible ? onSelectVLMonitoring : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentLanguage == 'lesotho' ? 'Viral Load' : 'Viral Load',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: (isClicked && isVLEligible) ? Colors.white : inactiveText.withOpacity(isVLEligible ? 1 : 0.4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isVLEligible) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.lock_outline, size: 16, color: inactiveText.withOpacity(0.4)),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

