
import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:lncmis_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:lncmis_mobile_app/core/components/entry_form_save_button.dart';
import 'package:lncmis_mobile_app/core/components/line_separator.dart';
import 'package:lncmis_mobile_app/core/components/material_card.dart';
import 'package:lncmis_mobile_app/modules/synchronization/constants/synchronization_actions_constants.dart';
import 'package:provider/provider.dart';

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

  void _onSyncButtonPress() {
    onInitializeSyncAction(syncAction);
  }

  String _buttonLabel(String lang) {
    if (syncAction == SynchronizationActionsConstants.download) {
      return lang == 'lesotho' ? 'Khoasolla data' : 'Download Data';
    }
    if (syncAction == SynchronizationActionsConstants.downloadAndUpload) {
      return lang == 'lesotho' ? 'Khoasolla le ho Upload' : 'Download & Upload';
    }
    return lang == 'lesotho' ? 'Upload liphetoho' : 'Upload Changes';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) {
        final primaryColor =
            Provider.of<InterventionCardState>(context, listen: false)
                .currentInterventionProgram
                .primaryColor;

        final bool hasAnythingToUpload =
            beneficiaryCount > 0 || beneficiaryServiceCount > 0;

        // Enable rules by action:
        // - Upload: only if there is something to upload
        // - Download: allow always (download is not dependent on offline counts)
        // - Download+Upload: allow always (it can still download even if no uploads)
        final bool enabledByAction =
        syncAction == SynchronizationActionsConstants.upload
            ? hasAnythingToUpload
            : true;

        final bool canPress = !isSyncActive && enabledByAction;

        return MaterialCard(
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
                    ),
                  ),
                ),
                LineSeparator(color: Colors.blueGrey.withOpacity(0.2)),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 10.0),
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
                      vertical: 2.0, horizontal: 10.0),
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
                    label: _buttonLabel(languageState.currentLanguage),
                    svgIconPath: 'assets/icons/sync.svg',
                    svgIconHeight: 15.0,
                    svgIconWidth: 15.0,
                    labelColor: Colors.white,
                    buttonColor: primaryColor,
                    fontSize: 15.0,
                    onPressButton: () => canPress ? _onSyncButtonPress() : null,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
