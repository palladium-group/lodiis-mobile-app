import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

class OfflineDataSummary extends StatelessWidget {
  const OfflineDataSummary({
    Key? key,
    required this.beneficiaryCount,
    required this.beneficiaryServiceCount,
    required this.onInitializeSyncAction,
    required this.syncAction,
    this.isSyncActive = false,
  }) : super(key: key);

  final int beneficiaryCount;
  final int beneficiaryServiceCount;
  final Function(String) onInitializeSyncAction;
  final String syncAction;
  final bool isSyncActive;

  onSyncButtonPress() {
    onInitializeSyncAction(syncAction);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => MaterialCard(
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                    languageState.currentLanguage == 'lesotho'
                        ? 'Kakaretso ea data e sa tsamayang'
                        : 'Offline data summary',
                    style: const TextStyle().copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              LineSeparator(color: Colors.blueGrey.withOpacity(0.2)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        languageState.currentLanguage == 'lesotho'
                            ? 'Basebeletsuoa ba so sync'
                            : 'Unsynced Beneficiaries',
                        style: const TextStyle().copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '$beneficiaryCount',
                        style: const TextStyle().copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        languageState.currentLanguage == 'lesotho'
                            ? "Lits'ebeletso tsa basebeletsuoa tse so sync"
                            : "Unsynced Beneficiaries' services",
                        style: const TextStyle().copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '$beneficiaryServiceCount',
                        style: const TextStyle().copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
                child: EntryFormSaveButton(
                  marginLeft: 30.0,
                  marginRight: 30.0,
                  vertical: 5.0,
                  label: 'Data download and upload',
                  svgIconPath: 'assets/icons/sync.svg',
                  svgIconHeight: 15.0,
                  svgIconWidth: 15.0,
                  labelColor: Colors.white,
                  buttonColor:
                      Provider.of<InterventionCardState>(context, listen: false)
                          .currentInterventionProgram
                          .primaryColor,
                  fontSize: 15.0,
                  onPressButton: () =>
                      !isSyncActive ? onSyncButtonPress() : null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
