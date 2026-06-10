import 'dart:io' show Platform, exit;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kb_mobile_app/core/constants/app_info_reference.dart';
import 'package:new_version_plus/model/version_status.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kb_mobile_app/core/components/app_update_redirect/app_update_action_buttons.dart';
import 'package:kb_mobile_app/core/components/app_update_redirect/app_update_warning_message.dart';

import 'package:kb_mobile_app/app_state/app_info_state/app_info_state.dart';
import 'package:provider/provider.dart';

class AppUpdateRedirectPage extends StatelessWidget {
  const AppUpdateRedirectPage({
    Key? key,
    required this.savedAppStoreVersion,
  }) : super(key: key);

  final String savedAppStoreVersion;

  void onCloseApp(BuildContext context) {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  void onUpdateApp(String appStoreLink) async {
    Uri appStoreLinkUri = Uri.parse(appStoreLink);
    await canLaunchUrl(appStoreLinkUri)
        ? await launchUrl(appStoreLinkUri)
        : throw 'Could not launch $appStoreLink';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: const Color(0xFF4B9F46),
          child:
              Consumer<AppInfoState>(builder: (context, appInfoState, child) {
            VersionStatus? versionStatus = appInfoState.versionStatus;
            String appStoreLink = versionStatus != null
                ? versionStatus.appStoreLink
                : AppInfoReference.androidId;
            String appName = appInfoState.currentAppName;
            String storeVersion = versionStatus != null
                ? versionStatus.storeVersion
                : savedAppStoreVersion;
            return Container(
              margin: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppUpdateWarningMessage(
                    message:
                        "$appName application should be updated to version $storeVersion in order to be used. Click below to update!",
                    color: const Color(0xFFFAFAFA),
                  ),
                  AppUpdateActionButtons(
                    onCloseApp: () => onCloseApp(context),
                    onUpdateApp: () => onUpdateApp(appStoreLink),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
