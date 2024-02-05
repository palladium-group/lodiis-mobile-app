import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/app_info_state/app_info_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/about_app/components/app_info_container.dart';
import 'package:kb_mobile_app/modules/about_app/components/user_info_container.dart';
import 'package:provider/provider.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  final String label = 'About App';
  final String translatedName = 'Mabapi le App';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return SubPageAppBar(
              label: label,
              translatedName: translatedName,
              activeInterventionProgram: activeInterventionProgram,
              disableSelectionOfActiveIntervention: false,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return Consumer<LanguageTranslationState>(
              builder: (context, languageTranslationState, child) {
                String currentLanguage =
                    languageTranslationState.currentLanguage;
                return Consumer<AppInfoState>(
                  builder: (context, appInfoState, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AppInfoContainer(
                              currentLanguage: currentLanguage,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10.0,
                              ),
                              child: Table(
                                defaultColumnWidth:
                                    FixedColumnWidth(size.width * 0.8),
                                children: [
                                  TableRow(
                                    children: [
                                      LineSeparator(
                                        color: activeInterventionProgram
                                                .secondaryColor
                                                ?.withOpacity(0.3) ??
                                            Colors.black87.withOpacity(0.3),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            UserInfoContainer(
                              currentLanguage: currentLanguage,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
