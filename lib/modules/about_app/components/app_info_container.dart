import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/app_info_state/app_info_state.dart';
import 'package:kb_mobile_app/modules/about_app/utils/about_page_util.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

class AppInfoContainer extends StatelessWidget {
  const AppInfoContainer({
    Key? key,
    required this.currentLanguage,
  }) : super(key: key);

  final String currentLanguage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Consumer<AppInfoState>(
        builder: (context, appInfoState, child) {
          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: size.width * 0.1,
                  backgroundColor: const Color(0xFFF3F3F3),
                  backgroundImage:
                      const AssetImage('assets/logos/app-logo.png'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Text(
                  languageState.currentLanguage == 'lesotho'
                      ? 'Lintlha tsa app'
                      : 'App Info',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Table(
                    defaultColumnWidth: FixedColumnWidth(size.width * 0.35),
                    children: [
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'Lebitso la App'
                            : 'App Name',
                        appInfoState.currentAppName,
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'Mofuta oa App'
                            : 'App Version',
                        appInfoState.currentAppVersion,
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho' ? 'Id ea App' : 'App Id',
                        appInfoState.currentAppId,
                      ),
                      AboutPageUtil.getTableRowContent(
                        currentLanguage == 'lesotho'
                            ? 'Server Url'
                            : 'Server Url',
                        appInfoState.serverUrl,
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
