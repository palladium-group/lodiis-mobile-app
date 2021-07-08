import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/app_logs_state/app_logs_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/app_logs/components/app_logs_card.dart';
import 'package:kb_mobile_app/core/components/input_fields/search_input.dart';
import 'package:kb_mobile_app/modules/app_logs/helpers/app_logs_helper.dart';
import 'package:provider/provider.dart';

class AppLogsPage extends StatefulWidget {
  const AppLogsPage({
    Key key,
  }) : super(key: key);

  _AppLogsState createState() => _AppLogsState();
}

class _AppLogsState extends State<AppLogsPage> {
  final String label = 'Application Logs';
  final String translatedLabel = 'Application Logs';

  onSearchLogs(BuildContext context, String value) {
    Provider.of<AppLogsState>(context, listen: false).searchAppLogs(value);
  }

  Future<void> onDownloadLogs() async {
    var excel = await AppLogsHelper.generateLogsExcel();
    if (excel != null) {
      try {
        var fileBytes = excel.save();
        await AppLogsHelper.writeToExcelFile(fileBytes);
      } catch (e) {
        AppUtil.showToastMessage(message: 'Failed to save logs file');
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<IntervetionCardState>(
        builder: (context, intervetionCardState, child) {
          InterventionCard activeInterventionProgram =
              intervetionCardState.currentIntervetionProgram;
          return SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(65.0),
                  child: Container(
                    child: Consumer<LanguageTranslationState>(
                      builder: (context, languageTranslationState, child) {
                        String currentLanguage =
                            languageTranslationState.currentLanguage;
                        return SubPageAppBar(
                          label: currentLanguage == 'lesotho'
                              ? translatedLabel
                              : label,
                          activeInterventionProgram: activeInterventionProgram,
                          disableSelectionOfActiveIntervention: false,
                        );
                      },
                    ),
                  )),
              floatingActionButton: FloatingActionButton(
                backgroundColor: intervetionCardState
                    .currentIntervetionProgram.primmaryColor,
                onPressed: () async {
                  await onDownloadLogs();
                },
                tooltip: 'download',
                child: Icon(Icons.download),
              ),
              body: Consumer<AppLogsState>(
                builder: (context, appLogsState, child) {
                  return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: SearchInput(
                        onSearch: (value) => onSearchLogs(context, value),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    body: Container(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: activeInterventionProgram.background),
                          ),
                          Container(
                            child: Container(
                              child: CustomPaginatedListView(
                                  childBuilder: (context, appLog, child) =>
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: AppLogsCard(
                                            appLog: appLog,
                                            currentInterventionColor:
                                                activeInterventionProgram
                                                    .countLabelColor,
                                          )),
                                  pagingController:
                                      appLogsState.pagingController,
                                  emptyListWidget: Column(children: [
                                    Center(
                                      child: Text(
                                        'There are no application logs at a moment.',
                                      ),
                                    )
                                  ]),
                                  errorWidget: Center(
                                    child: Text(
                                      'There are no application logs list at a moment.',
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
