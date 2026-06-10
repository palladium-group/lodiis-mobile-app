import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:lncmis_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:lncmis_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:lncmis_mobile_app/core/components/access_to_data_entry/access_to_data_entry_warning.dart';
import 'package:lncmis_mobile_app/core/components/language_selection_container.dart';
import 'package:lncmis_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:lncmis_mobile_app/core/services/language_selection_service.dart';
import 'package:lncmis_mobile_app/models/intervention_card.dart';
import 'package:lncmis_mobile_app/modules/login/login.dart';
import 'package:provider/provider.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({
    Key? key,
    this.showLanguageSettingAppBar = false,
  }) : super(key: key);

  final bool showLanguageSettingAppBar;

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  final String label = 'Language settings';
  final String translatedLabel = 'Khetha Puo';
  String selectionLanguageCode = '';

  @override
  void initState() {
    super.initState();
    LanguageSelectionService.getCurrentLanguageSelection().then((value) {
      selectionLanguageCode = value ?? selectionLanguageCode;
      setState(() {});
    });
  }

  void onSetSelectedLanguage(
    BuildContext context,
    String selectionLanguageCode,
  ) async {
    await LanguageSelectionService.setCurrentLanguageSelection(
      selectionLanguageCode,
    );
    Provider.of<LanguageTranslationState>(context, listen: false)
        .setLanguageTranslation(selectionLanguageCode);
    if (widget.showLanguageSettingAppBar) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: !widget.showLanguageSettingAppBar
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(65.0),
                child: Consumer<InterventionCardState>(
                  builder: (context, interventionCardState, child) {
                    InterventionCard activeInterventionProgram =
                        interventionCardState.currentInterventionProgram;
                    return Consumer<LanguageTranslationState>(
                      builder: (context, languageTranslationState, child) {
                        String? currentLanguage =
                            languageTranslationState.currentLanguage;
                        return SubPageAppBar(
                          label: currentLanguage == 'lesotho'
                              ? translatedLabel
                              : label,
                          activeInterventionProgram: activeInterventionProgram,
                          disableSelectionOfActiveIntervention: false,
                        );
                      },
                    );
                  },
                ),
              ),
        body: Consumer<CurrentUserState>(
            builder: (context, currentUserState, child) {
          bool hasAccessToDataEntry =
              currentUserState.canCurrentUserDoDataEntry;
          return !hasAccessToDataEntry
              ? const AccessToDataEntryWarning()
              : Consumer<LanguageTranslationState>(
                  builder: (context, languageTranslationState, child) {
                    String? currentLanguage =
                        languageTranslationState.currentLanguage;
                    return LanguageSelectionContainer(
                      currentLanguage: currentLanguage,
                      selectionLanguageCode: selectionLanguageCode,
                      showLanguageSettingAppBar:
                          widget.showLanguageSettingAppBar,
                      onSetSelectedLanguage: (String selectionLanguageCode) =>
                          onSetSelectedLanguage(
                        context,
                        selectionLanguageCode,
                      ),
                    );
                  },
                );
        }),
      ),
    );
  }
}
