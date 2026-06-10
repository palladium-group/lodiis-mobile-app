import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lncmis_mobile_app/app_state/app_info_state/app_device_info_state.dart';
import 'package:lncmis_mobile_app/app_state/app_info_state/app_info_state.dart';
import 'package:lncmis_mobile_app/app_state/app_logs_state/app_logs_state.dart';
import 'package:lncmis_mobile_app/app_state/beneficiary_filter_state/beneficiary_filter_state.dart';
import 'package:lncmis_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:lncmis_mobile_app/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:lncmis_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:lncmis_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:lncmis_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:lncmis_mobile_app/app_state/intervention_bottom_navigation_state/intervention_bottom_navigation_state.dart';
import 'package:lncmis_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:lncmis_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:lncmis_mobile_app/app_state/login_form_state/login_form_state.dart';
import 'package:lncmis_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:lncmis_mobile_app/app_state/synchronization_state/synchronization_state.dart';
import 'package:lncmis_mobile_app/app_state/synchronization_state/synchronization_status_state.dart';
import 'package:lncmis_mobile_app/app_state/mgysd_case_management_list_state/mgysd_case_management_list_state.dart';
import 'package:lncmis_mobile_app/core/constants/custom_color.dart';
import 'package:lncmis_mobile_app/modules/splash/splash.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SynchronizationStatusState()),
        ChangeNotifierProvider(create: (_) => AppInfoState()),
        ChangeNotifierProvider(create: (_) => AppDeviceInfoState()),
        ChangeNotifierProvider(create: (_) => LanguageTranslationState()),
        ChangeNotifierProvider(create: (_) => CurrentUserState()),
        ChangeNotifierProvider(create: (_) => InterventionCardState()),
        ChangeNotifierProvider(create: (_) => LoginFormState()),
        ChangeNotifierProvider(create: (_) => InterventionBottomNavigationState()),
        ChangeNotifierProvider(create: (_) => ReferralNotificationState()),
        ChangeNotifierProvider(create: (BuildContext context) => EnrollmentFormState(context)),
        ChangeNotifierProvider(create: (BuildContext context) => ServiceFormState(context)),
        ChangeNotifierProvider(create: (BuildContext context) => ServiceEventDataState(context)),
        ChangeNotifierProvider(create: (BuildContext context) => SynchronizationState(context: context)),
        ChangeNotifierProvider(create: (_) => AppLogsState()),
        ChangeNotifierProvider(create: (_) => DeviceConnectivityState()),
        ChangeNotifierProvider(create: (_) => BeneficiaryFilterState()),
        ChangeNotifierProvider(create: (_) => MgysdCaseManagementListState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LNCMIS',
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          primaryColor: CustomColor.defaultPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SafeArea(child: Splash()),
      ),
    );
  }
}
