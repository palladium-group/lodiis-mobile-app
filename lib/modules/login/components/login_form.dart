import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/login_form_state/login_form_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/form_field_input_icon.dart';
import 'package:kb_mobile_app/core/constants/custom_color.dart';
import 'package:kb_mobile_app/core/services/device_tracking_service.dart';
import 'package:kb_mobile_app/core/services/implementing_partner_referral_config_service.dart';
import 'package:kb_mobile_app/core/services/program_service.dart';
import 'package:kb_mobile_app/core/services/user_access.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/modules/intervention_selection/intervention_selection.dart';
import 'package:kb_mobile_app/modules/login/components/login_button.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/modules/login/constants/login_page_style.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/core/services/organisation_unit_service.dart';

class LoginForm extends StatefulWidget {
  final String? currentLanguage;

  const LoginForm({Key? key, required this.currentLanguage}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  CurrentUser? currentUser;
  late LoginFormState loginFormState;
  TextEditingController? usernameController;
  TextEditingController? passwordController;

  @override
  void initState() {
    super.initState();
    loginFormState = Provider.of<LoginFormState>(context, listen: false);
    UserService().getCurrentUser().then((CurrentUser? user) {
      currentUser = user ??
          CurrentUser(
            username: '',
            password: '',
          );
      currentUser!.password = "";
      usernameController = TextEditingController(text: currentUser!.username);
      passwordController = TextEditingController(text: currentUser!.password);
      setState(() {});
    });
  }

  void updateInputActiveStatus(String activeField) {
    loginFormState.setActiveInput(activeField);
  }

  void updatePasswordVisibilityStatus(bool value) {
    loginFormState.setIsPasswordVisible(value);
  }

  void onFieldValueChanges(String value, String key) {
    currentUser!.username =
        key == 'username' ? value.trim() : currentUser!.username;
    currentUser!.password =
        key == 'password' ? value.trim() : currentUser!.password;
    setState(() {});
  }

  void onFieldSubmitted(String value, String key) {
    onFieldValueChanges(value, key);
    updateInputActiveStatus('');
  }

  void onLogin(bool isLoginProcessActive) async {
    bool? isOnline =
        Provider.of<DeviceConnectivityState>(context, listen: false)
            .connectivityStatus;
    bool status = currentUser!.isCurrentUserSet();
    FocusScope.of(context).unfocus();
    updateInputActiveStatus('');
    if (!isLoginProcessActive && status) {
      loginFormState.setHasLoginErrorStatus(false);
      loginFormState.setIsLoginProcessActive(true);
      loginFormState.setCurrentLoginProcessMessage(
          widget.currentLanguage == 'lesotho'
              ? 'E netefatsa hore mosebelisi ke ea nang le tokelo '
              : 'Authenticating user...');
      if (isOnline!) {
        await onlineAuthentication(
          username: currentUser!.username!.trim(),
          password: currentUser!.password!.trim(),
        );
      } else {
        await offlineAuthentication(
          username: currentUser!.username!.trim(),
          password: currentUser!.password!.trim(),
        );
      }
    }
  }

  Future<void> offlineAuthentication({
    required String username,
    required String password,
  }) async {
    try {
      CurrentUser? user = await UserService().login(
        username: username,
        password: password,
        isOnlineAuthentication: false,
      );
      if (user != null) {
        var userAccessConfigurations =
            await UserAccess().getSavedUserAccessConfigurations();
        await setCurrentUserAccess(user, userAccessConfigurations);
        redirectToInterventionPage(user);
      }
    } catch (error) {
      resetLoginFormState(
        showErrorOnInputFields: true,
        toastMessage: error.toString(),
      );
    }
  }

  Future<void> onlineAuthentication({
    required String username,
    required String password,
  }) async {
    try {
      CurrentUser? user = await UserService().login(
        username: username,
        password: password,
      );
      if (user != null) {
        bool hasPreviousSuccessLogin =
            await UserService().hasUserPreviousSuccessLogin(
          username: username,
          password: password,
        );
        await DeviceTrackingService()
            .checkAndRegistertDeviceTrackingInfo(user: user);
        var userAccessConfigurations =
            await UserAccess().getUserAccessConfigurationsFromTheServer(
          user.username,
          user.password,
        );
        await setCurrentUserAccess(user, userAccessConfigurations);
        if (!hasPreviousSuccessLogin) {
          UserService().resetUserAssociatedMetadata(user.id);
          loginFormState.setCurrentLoginProcessMessage(
              widget.currentLanguage == 'lesotho'
                  ? 'Basebelise ba polokelo ba abetsoeng sebaka'
                  : "Saving user's assigned locations...");
          await OrganisationUnitService()
              .discoveringOrgananisationUnitsFromTheServer();
          loginFormState.setCurrentLoginProcessMessage(
              widget.currentLanguage == 'lesotho'
                  ? 'Polokelo e abetsoeng phihlelo ba keng sa ho kena lipakeng.'
                  : "Saving assigned access for interventions...");
          for (dynamic program in user.programs ?? []) {
            await ProgramService()
                .discoverProgramOrganisationUnitsFromTheServer("$program");
          }
        }
        user.isLogin = true;
        user.hasPreviousSuccessLogin = true;
        await UserService().setCurrentUser(user);
        redirectToInterventionPage(user);
      } else {
        String message = widget.currentLanguage == 'lesotho'
            ? 'Lebitso la mosebelisi kapa nomoro ea lekunutu e fosahetseng'
            : 'Incorrect username or password';
        resetLoginFormState(
          toastMessage: message,
          showErrorOnInputFields: true,
        );
      }
    } catch (error) {
      resetLoginFormState(
          toastMessage: error.toString(), showErrorOnInputFields: false);
    }
  }

  Future<void> setCurrentUserAccess(
    CurrentUser user,
    userAccessConfigurations,
  ) async {
    await UserService().setCurrentUser(user);
    loginFormState.setCurrentLoginProcessMessage('Saving user access...');
    await UserAccess().savingUserAccessConfigurations(userAccessConfigurations);
    Provider.of<CurrentUserState>(context, listen: false)
        .setCurrentUser(user, userAccessConfigurations);
    await Provider.of<ReferralNotificationState>(context, listen: false)
        .setCurrentImplementingPartner(user.implementingPartner!);
    await ImplementingPartnerReferralConfigService()
        .addImplementingPartnerReferralServices(user.username, user.password);
  }

  void resetLoginFormState({
    bool showErrorOnInputFields = false,
    String toastMessage = "",
  }) {
    loginFormState.setIsLoginProcessActive(false);
    loginFormState.setHasLoginErrorStatus(showErrorOnInputFields);
    AppUtil.showToastMessage(message: toastMessage);
    loginFormState.setCurrentLoginProcessMessage('');
  }

  void redirectToInterventionPage(CurrentUser user) async {
    Provider.of<CurrentUserState>(context, listen: false)
        .setCurrentUserCountryLevelReferences();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InterventionSelection(),
        ),
      ).then(
        (value) => loginFormState.setIsLoginProcessActive(false),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Color activeInputColor = const Color(0xFF4B9F46);
    Color inActiveInputColor = const Color(0xFFD2E7D1);
    return SingleChildScrollView(
      child: Consumer<LanguageTranslationState>(
        builder: (context, languageState, child) => Consumer<LoginFormState>(
          builder: (context, loginFormState, child) {
            String activeInput = loginFormState.activeInput;
            bool hasLoginFormError = loginFormState.hasLoginFormError;
            bool isLoginProcessActive = loginFormState.isLoginProcessActive;
            bool isPasswordVisible = loginFormState.isPasswordVisible;
            return currentUser == null
                ? CircularProcessLoader(
                    color: CustomColor.defaultSecondaryColor,
                    size: 2.0,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            languageState.currentLanguage == 'lesotho'
                                ? 'Lebitso la mosebelisi'
                                : 'Username',
                            style: !hasLoginFormError
                                ? LoginPageStyles.formLabelStyle
                                : LoginPageStyles.formLabelStyle.copyWith(
                                    color: Colors.redAccent,
                                  ),
                          )
                        ],
                      ),
                      TextFormField(
                        controller: usernameController,
                        onTap: () => updateInputActiveStatus('username'),
                        onChanged: (value) =>
                            onFieldValueChanges(value, 'username'),
                        onFieldSubmitted: (value) =>
                            onFieldSubmitted(value, 'username'),
                        readOnly: isLoginProcessActive,
                        autocorrect: false,
                        style: LoginPageStyles.formInputValueStyle,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const FormFieldInputIcon(
                            backGroundColor: Color(0xFFEDF5EC),
                            svgIcon: 'assets/icons/login-user-input.svg',
                          ),
                          prefixIconConstraints:
                              LoginPageStyles.loginBoxConstraints,
                        ),
                      ),
                      LineSeparator(
                        color: activeInput == 'username'
                            ? activeInputColor
                            : inActiveInputColor,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              languageState.currentLanguage == 'lesotho'
                                  ? 'Nomoro/lentsoe la lekunutu'
                                  : 'Password',
                              style: !hasLoginFormError
                                  ? LoginPageStyles.formLabelStyle
                                  : LoginPageStyles.formLabelStyle.copyWith(
                                      color: Colors.redAccent,
                                    ),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        onTap: () => updateInputActiveStatus('password'),
                        onChanged: (value) =>
                            onFieldValueChanges(value, 'password'),
                        onFieldSubmitted: (value) =>
                            onFieldSubmitted(value, 'password'),
                        obscureText: !isPasswordVisible,
                        autocorrect: false,
                        style: LoginPageStyles.formInputValueStyle,
                        readOnly: isLoginProcessActive,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          prefixIcon: const FormFieldInputIcon(
                            backGroundColor: Color(0xFFEDF5EC),
                            svgIcon: 'assets/icons/login-lock.svg',
                          ),
                          prefixIconConstraints:
                              LoginPageStyles.loginBoxConstraints,
                          suffixIcon: GestureDetector(
                            onTap: () => updatePasswordVisibilityStatus(
                              !isPasswordVisible,
                            ),
                            child: FormFieldInputIcon(
                              backGroundColor: const Color(0xFFFFFFFF),
                              svgIcon: isPasswordVisible
                                  ? 'assets/icons/login-close-eye.svg'
                                  : 'assets/icons/login-open-eye.svg', // show and hide password icon
                            ),
                          ),
                          suffixIconConstraints:
                              LoginPageStyles.loginBoxConstraints,
                        ),
                      ),
                      LineSeparator(
                        color: activeInput == 'password'
                            ? activeInputColor
                            : inActiveInputColor,
                      ),
                      LoginButton(
                        currentLanguage: widget.currentLanguage,
                        isLoginProcessActive: isLoginProcessActive,
                        onLogin: () => onLogin(
                          isLoginProcessActive,
                        ),
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }
}
