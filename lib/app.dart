import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kb_mobile_app/app_state/app_info_state/app_device_info_state.dart';
import 'package:kb_mobile_app/app_state/app_info_state/app_info_state.dart';
import 'package:kb_mobile_app/app_state/app_logs_state/app_logs_state.dart';
import 'package:kb_mobile_app/app_state/beneficiary_filter_state/beneficiary_filter_state.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_re_assessment_list_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_bursary_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_intervention_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_lbse_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/implementing_partner_referral_service_state/implementing_partner_referral_service_state.dart';
import 'package:kb_mobile_app/app_state/intervention_bottom_navigation_state/intervention_bottom_navigation_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/login_form_state/login_form_state.dart';
import 'package:kb_mobile_app/app_state/ogac_intervention_list_state/ogac_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/app_state/synchronization_state/synchronization_state.dart';
import 'package:kb_mobile_app/app_state/synchronization_state/synchronization_status_state.dart';
import 'package:kb_mobile_app/core/constants/custom_color.dart';
import 'package:kb_mobile_app/modules/splash/splash.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => SynchronizationStatusState(),
          ),
          ChangeNotifierProvider(
            create: (_) => AppInfoState(),
          ),
          ChangeNotifierProvider(
            create: (_) => AppDeviceInfoState(),
          ),
          ChangeNotifierProvider(
            create: (_) => LanguageTranslationState(),
          ),
          ChangeNotifierProvider(
            create: (_) => CurrentUserState(),
          ),
          ChangeNotifierProvider(
            create: (_) => InterventionCardState(),
          ),
          ChangeNotifierProvider(
            create: (_) => DreamsBeneficiarySelectionState(),
          ),
          ChangeNotifierProvider(
            create: (_) => LoginFormState(),
          ),
          ChangeNotifierProvider(
            create: (_) => InterventionBottomNavigationState(),
          ),
          ChangeNotifierProvider(
            create: (_) => ReferralNotificationState(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => EnrollmentFormState(context),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => ServiceFormState(context),
          ),
          ChangeNotifierProvider(
            create: (_) => EducationInterventionCurrentSelectionState(),
          ),
          ChangeNotifierProvider(
            create: (_) => PpPrevInterventionCurrentSelectionState(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => ServiceEventDataState(context),
          ),
          ChangeNotifierProvider(
            create: (_) => OvcHouseholdCurrentSelectionState(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => OvcInterventionListState(context),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) =>
                DreamsInterventionListState(context),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) =>
                OgacInterventionListState(context),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => PpPrevInterventionState(context),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) =>
                EducationBursaryInterventionState(context),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) =>
                EducationLbseInterventionState(context),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) =>
                SynchronizationState(context: context),
          ),
          ChangeNotifierProvider(
            create: (_) => AppLogsState(),
          ),
          ChangeNotifierProvider(
            create: (_) => DeviceConnectivityState(),
          ),
          ChangeNotifierProvider(
            create: (_) => ImplementingPartnerReferralServiceState(),
          ),
          ChangeNotifierProvider(
            create: (_) => BeneficiaryFilterState(),
          ),
          ChangeNotifierProvider(
            create: (_) => DreamsRaAssessmentListState(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "LODIIS",
          theme: ThemeData(
              textTheme: GoogleFonts.robotoTextTheme(
                Theme.of(context).textTheme,
              ),
              primaryColor: CustomColor.defaultPrimaryColor,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: const SafeArea(child: Splash()),
        ));
  }
}
