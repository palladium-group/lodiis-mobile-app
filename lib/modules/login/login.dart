import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/constants/custom_color.dart';
import 'package:kb_mobile_app/core/services/device_connectivity_provider.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/modules/login/components/login_form_container.dart';
import 'package:kb_mobile_app/modules/login/components/login_top_icon.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final String appLabel = "Training App";
  final String translatedAppLabel = "App ea boikoetliso";
  late StreamSubscription connectionSubscription;
  @override
  void initState() {
    super.initState();
    connectionSubscription = DeviceConnectivityProvider()
        .checkChangeOfDeviceConnectionStatus(context);
    AppUtil.setStatusBarColor(CustomColor.defaultPrimaryColor);
  }

  @override
  void dispose() {
    connectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                color: CustomColor.defaultPrimaryColor,
              ),
            ),
            SingleChildScrollView(
              child: Consumer<LanguageTranslationState>(
                builder: (context, languageTranslationState, child) {
                  String? currentLanguage =
                      languageTranslationState.currentLanguage;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LoginTopIcon(
                        appLabel:currentLanguage == 'lesotho' ? translatedAppLabel :appLabel,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LoginFormContainer(
                        currentLanguage: currentLanguage,
                        appLabel:currentLanguage == 'lesotho' ? translatedAppLabel :appLabel,
                      
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
