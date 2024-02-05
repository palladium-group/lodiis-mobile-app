import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/login_form_state/login_form_state.dart';
import 'package:kb_mobile_app/modules/login/components/login_form.dart';
import 'package:provider/provider.dart';

class LoginFormContainer extends StatelessWidget {
  const LoginFormContainer({
    Key? key,
    required this.currentLanguage,
    required this.appLabel,
  }) : super(key: key);

  final String? currentLanguage;
  final String appLabel;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Container(
        padding: const EdgeInsets.all(30.0),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ),
        ),
        width: size.width * 0.8,
        child: Column(
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  languageState.currentLanguage == 'lesotho'
                      ? 'Kena'
                      :'Login',
                  style:const TextStyle(
                    color: Color(0xFF387A34),
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Column(
              children: [
                Column(
                  children: [
                    Text(
                      languageState.currentLanguage == 'lesotho'
                          ? 'Ka kopo, kenya lintlha tsa hau ho kena ka hara app'
                          : 'Please enter your account details in order to login to the app',
                      style: const TextStyle(
                        color: Color(0xFF737373),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            LoginForm(
              currentLanguage: currentLanguage,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Consumer<LoginFormState>(builder: (context, loginFormState, child) {
              return Column(
                children: [
                  Column(
                    children: [
                      Text(
                        loginFormState.currentLoginProcessMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF737373),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )
                ],
              );
            }),
            Visibility(
              visible: appLabel != "",
              child: Text(
                languageState.currentLanguage == 'lesotho'
                    ? "Ela Hloko: Ena ke $appLabel"
                    : "NB : This is $appLabel",
                style: const TextStyle().copyWith(
                  color: Colors.redAccent,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
