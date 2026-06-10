import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lncmis_mobile_app/app_state/app_info_state/app_info_state.dart';
import 'package:lncmis_mobile_app/core/constants/app_info_reference.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateWarning extends StatelessWidget {
  const AppUpdateWarning({Key? key}) : super(key: key);

  void launchPlayStoreUrl(BuildContext context) async {
    String appUrl =
        'https://play.google.com/store/apps/details?id=${AppInfoReference.androidId}';
    Uri defaultUrl = Uri.parse(appUrl);
    if (!await launchUrl(
      defaultUrl,
      mode: LaunchMode.externalApplication,
    )) {
      AppUtil.showToastMessage(
        message: 'Could not open app store',
        position: ToastGravity.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.amberAccent;
    double iconHeight = 20.0;
    bool shouldUpdateApp =
        Provider.of<AppInfoState>(context, listen: false).shouldUpdateTheApp ||
            Provider.of<AppInfoState>(context, listen: false)
                .showWarningToAppUpdate;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: shouldUpdateApp
          ? GestureDetector(
              onTap: () => launchPlayStoreUrl(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New App Update Available! Tap to update',
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                  Icon(
                    Icons.system_security_update,
                    color: color,
                    size: iconHeight,
                  )
                ],
              ),
            )
          : Container(),
    );
  }
}
