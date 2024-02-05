import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/app_update_warning.dart';
import 'package:kb_mobile_app/core/utils/app_bar_util.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:provider/provider.dart';

class SubPageAppBar extends StatelessWidget {
  const SubPageAppBar({
    Key? key,
    required this.label,
    required this.activeInterventionProgram,
    this.disableSelectionOfActiveIntervention = true,
    this.translatedName,
  }) : super(key: key);

  final String label;
  final InterventionCard activeInterventionProgram;
  final bool disableSelectionOfActiveIntervention;
  final String? translatedName;

  void onOpenMoreMenu(
      BuildContext context, InterventionCard activeInterventionProgram) async {
    AppBarUtil.onOpenMoreMenu(context, activeInterventionProgram,
        disableSelectionOfActiveIntervention);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => AppBar(
        title: Text(
          languageState.currentLanguage == "lesotho"
              ? translatedName ?? label
              : label,
          style: const TextStyle().copyWith(
            fontSize: 19.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actionsIconTheme: const IconThemeData().copyWith(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData().copyWith(
          color: Colors.white,
        ),
        backgroundColor: activeInterventionProgram.primaryColor,
        actions: [
          Visibility(
            visible: disableSelectionOfActiveIntervention,
            child: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () =>
                    onOpenMoreMenu(context, activeInterventionProgram)),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            child: const AppUpdateWarning(),
          ),
        ),
      ),
    );
  }
}
