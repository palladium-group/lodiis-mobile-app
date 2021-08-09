import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kb_mobile_app/app_state/app_info_state/app_info_state.dart';
import 'package:kb_mobile_app/app_state/app_logs_state/app_logs_state.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/implementing_partner_referral_service_state/implementing_partner_referral_service_state.dart';
import 'package:kb_mobile_app/app_state/intervention_bottom_navigation_state/intervention_bottom_navigation_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/login_form_state/login_form_state.dart';
import 'package:kb_mobile_app/app_state/ogac_intervention_list_state/ogac_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/app_state/synchronization_state/synchronization_state.dart';
import 'package:kb_mobile_app/core/constants/custom_color.dart';
import 'package:kb_mobile_app/modules/splash/splash.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppInfoState()),
          ChangeNotifierProvider(create: (_) => LanguageTranslationState()),
          ChangeNotifierProvider(create: (_) => CurrentUserState()),
          ChangeNotifierProvider(create: (_) => InterventionCardState()),
          ChangeNotifierProvider(
              create: (_) => DreamsBeneficiarySelectionState()),
          ChangeNotifierProvider(create: (_) => LoginFormState()),
          ChangeNotifierProvider(
              create: (_) => InterventionBottomNavigationState()),
          ChangeNotifierProvider(create: (_) => ReferralNotificationState()),
          ChangeNotifierProvider(create: (_) => EnrollmentFormState()),
          ChangeNotifierProvider(create: (_) => ServiceFormState()),
          ChangeNotifierProvider(create: (_) => ServiceEventDataState()),
          ChangeNotifierProvider(
            create: (_) => OvcHouseholdCurrentSelectionState(),
          ),
          ChangeNotifierProvider(create: (_) => OvcInterventionListState()),
          ChangeNotifierProvider(create: (_) => DreamsInterventionListState()),
          ChangeNotifierProvider(create: (_) => OgacInterventionListState()),
          ChangeNotifierProvider(
              create: (BuildContext context) =>
                  SynchronizationState(context: context)),
          ChangeNotifierProvider(create: (_) => AppLogsState()),
          ChangeNotifierProvider(create: (_) => DeviceConnectivityState()),
          ChangeNotifierProvider(
              create: (_) => ImplementingPartnerReferralServiceState())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Lesotho OVC-DREAMS",
          theme: ThemeData(
              textTheme: GoogleFonts.robotoTextTheme(
                Theme.of(context).textTheme,
              ),
              primaryColor: CustomColor.defaultPrimaryColor,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: SafeArea(child: Splash()),
        ));
  }
}
