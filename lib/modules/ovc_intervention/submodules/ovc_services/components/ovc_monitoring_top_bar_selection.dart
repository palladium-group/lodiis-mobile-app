
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:provider/provider.dart';

enum ChildMonTab { assessment, viralLoad, hei }

class OvcMonitoringTopBarSelection extends StatelessWidget {
  final VoidCallback onSelectAssessment;
  final VoidCallback onSelectViralLoad;
  final VoidCallback onSelectHei;

  final ChildMonTab selected;
  final bool isVLEligible;
  final bool isHEIEligible;

  const OvcMonitoringTopBarSelection({
    Key? key,
    required this.onSelectAssessment,
    required this.onSelectViralLoad,
    required this.onSelectHei,
    required this.selected,
    this.isVLEligible = false,
    this.isHEIEligible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        final isSesotho = languageTranslationState.isSesothoLanguage;

        TextStyle tabStyle(bool active, bool enabled) => TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: active
              ? Colors.white
              : (enabled ? const Color(0xFF1A3518) : Colors.black38),
        );

        Color bg(bool active) => active ? const Color(0xFF4B9F46) : Colors.transparent;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: const BoxDecoration(color: Colors.black12),
          child: Row(
            children: [
              // Assessment
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: bg(selected == ChildMonTab.assessment),
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  ),
                  onPressed: onSelectAssessment,
                  child: Text(
                    isSesotho ? "Ts'ebeletso" : 'Assessment',
                    style: tabStyle(selected == ChildMonTab.assessment, true),
                  ),
                ),
              ),

              // Viral Load
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: bg(selected == ChildMonTab.viralLoad),
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  ),
                  onPressed: onSelectViralLoad, // screen handles eligibility + toast
                  child: Text(
                    'Viral Load',
                    style: tabStyle(selected == ChildMonTab.viralLoad, isVLEligible),
                  ),
                ),
              ),

              // HEI Card (visible always; screen handles toast & gating)
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: bg(selected == ChildMonTab.hei),
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  ),
                  onPressed: onSelectHei,
                  child: Text(
                    isSesotho ? 'HEI Karete' : 'HEI Card',
                    style: tabStyle(selected == ChildMonTab.hei, isHEIEligible),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
