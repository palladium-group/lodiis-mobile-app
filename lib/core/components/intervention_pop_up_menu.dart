import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/intervention_pop_action_menu.dart';
import 'package:kb_mobile_app/core/utils/intervention_selection_helper.dart';
import 'package:provider/provider.dart';

class InterventionPopUpMenu extends StatelessWidget {
  const InterventionPopUpMenu({
    Key? key,
    required this.activeInterventionProgram,
    required this.disableSelectionOfActiveIntervention,
  }) : super(key: key);

  final InterventionCard activeInterventionProgram;
  final bool disableSelectionOfActiveIntervention;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 45,
        right: 45,
        bottom: 20,
      ),
      child: Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
          String? currentLanguage = languageTranslationState.currentLanguage;
          return Consumer<CurrentUserState>(
            builder: (context, currentUserState, child) {
              List<InterventionPopActionMenu> popUpMenus =
                  InterventionPopActionMenu
                      .getDefaultInterventionPopActionMenus();
              List<InterventionCard> interventionPrograms =
                  InterventionSelectionHelper.getInterventionSelections(
                      InterventionCard.getInterventions(), currentUserState);
              popUpMenus.addAll(
                interventionPrograms.map(
                  (interventionProgram) {
                    return InterventionPopActionMenu(
                        id: interventionProgram.id,
                        name: 'Switch to ${interventionProgram.shortName}',
                        translatedName:
                            'Fetolela ho ${interventionProgram.shortName}',
                        color: interventionProgram.primaryColor,
                        fontWeight: FontWeight.bold);
                  },
                ),
              );
              return Column(
                children: popUpMenus
                    .map((InterventionPopActionMenu popUpMenu) => Visibility(
                          visible:
                              popUpMenu.id != activeInterventionProgram.id ||
                                  !disableSelectionOfActiveIntervention,
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.pop(context, popUpMenu),
                            },
                            child: Column(
                              children: [
                                Wrap(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Text(
                                        currentLanguage == 'lesotho' &&
                                                popUpMenu.translatedName != null
                                            ? popUpMenu.translatedName!
                                            : popUpMenu.name!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: popUpMenu.color,
                                            fontSize: 14.0,
                                            fontWeight: popUpMenu.fontWeight),
                                      ),
                                    )
                                  ],
                                ),
                                const LineSeparator(
                                  color: Color(0xFFE0E6E0),
                                  height: 1,
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}
