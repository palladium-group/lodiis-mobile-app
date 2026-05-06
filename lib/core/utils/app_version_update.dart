import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_info_reference.dart';
import 'package:kb_mobile_app/core/services/app_info_service.dart';
import 'package:new_version_plus/model/version_status.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:new_version_plus/new_version_plus.dart';

class AppVersionUpdate {
  static showAppUpdateWarning(
      BuildContext context, VersionStatus? versionStatus) async {
    String modalTitle = 'Update Available';
    String appStoreLink = versionStatus != null
        ? versionStatus.appStoreLink
        : AppInfoReference.androidId;
    String localVersion = versionStatus != null
        ? versionStatus.localVersion
        : AppInfoReference.currentAppVersion;
    String storeVersion = versionStatus != null
        ? versionStatus.storeVersion
        : await AppInfoService.getSavedApStoreVersion();
    String message =
        'You can now update this app from $localVersion to $storeVersion';

    Widget modal = getDialogWidget(context, message, appStoreLink);
    AppUtil.showPopUpModal(context, modal, false, title: modalTitle);
  }

  static Widget getDialogWidget(
      BuildContext context, String message, String appStoreLink) {
    Uri appStoreLinkUrI = Uri.parse(appStoreLink);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Text(
              message,
              style: const TextStyle().copyWith(
                color: const Color(0xFF82898D),
                fontSize: 14.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 5.0,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await canLaunchUrl(appStoreLinkUrI)
                            ? await launchUrl(appStoreLinkUrI)
                            : throw 'Could not launch $appStoreLink';
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color(0xFF7FBA7C),
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        "Update Now",
                        style: TextStyle(
                          color: Color(0xFF7FBA7C),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.redAccent,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
