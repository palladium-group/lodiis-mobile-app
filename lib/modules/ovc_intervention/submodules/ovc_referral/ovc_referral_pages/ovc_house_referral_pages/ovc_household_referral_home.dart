import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_top_header.dart';
import 'package:kb_mobile_app/core/components/referrals_old/referral_card_summary.dart';
import 'package:kb_mobile_app/core/components/referrals_old/referral_card_body_summary.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_house_referral_pages/constants/ovc_household_referral_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_house_referral_pages/pages/ovc_household_referral_manage.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_house_referral_pages/pages/ovc_household_referral_view.dart';
import 'package:provider/provider.dart';
import 'pages/ovc_household_add_referral_form.dart';

class OvcHouseholdReferralHome extends StatefulWidget {
  const OvcHouseholdReferralHome({
    Key? key,
    required this.isIncomingReferral,
  }) : super(key: key);

  final bool isIncomingReferral;

  @override
  State<OvcHouseholdReferralHome> createState() =>
      _OvcHouseholdReferralHomeState();
}

class _OvcHouseholdReferralHomeState extends State<OvcHouseholdReferralHome> {
  final String label = 'Household Referral';
  List<String> programStageIds = [OvcHouseholdReferralConstant.referralStage];

  void onAddReferral(BuildContext context, OvcHousehold? household) async {
    FormUtil.updateServiceFormState(context, true, null);
    String? beneficiaryId = household!.id;
    String eventId = '';
    String formAutoSaveId =
        "${OvcRoutesConstant.houseHoldReferralFormPage}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave);
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OvcHouseholdAddReferralForm(),
        ),
      );
    }
  }

  void onViewHouseholdReferral(
    BuildContext context,
    Events eventData,
    int referralIndex,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OvcHouseholdReferralView(
          eventData: eventData,
          referralIndex: referralIndex,
          isIncomingReferral: widget.isIncomingReferral,
        ),
      ),
    );
  }

  void onManageHouseholdReferral(
    BuildContext context,
    Events eventData,
    referralIndex,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OvcHouseholdReferralManage(
          eventData: eventData,
          referralIndex: referralIndex,
          isIncomingReferral: widget.isIncomingReferral,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return SubPageAppBar(
              label: label,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Consumer<LanguageTranslationState>(
          builder: (context, languageTranslationState, child) {
            String? currentLanguage = languageTranslationState.currentLanguage;
            return Consumer<OvcHouseholdCurrentSelectionState>(
              builder: (context, ovcHouseholdCurrentSelectionState, child) {
                return Consumer<ServiceEventDataState>(
                  builder: (context, serviceEventDataState, child) {
                    OvcHousehold? currentOvcHousehold =
                        ovcHouseholdCurrentSelectionState.currentOvcHousehold;
                    bool isLoading = serviceEventDataState.isLoading;
                    Map<String?, List<Events>> eventListByProgramStage =
                        serviceEventDataState.eventListByProgramStage;
                    List<Events> events = TrackedEntityInstanceUtil
                        .getAllEventListFromServiceDataStateByProgramStages(
                            eventListByProgramStage, programStageIds);
                    int referralIndex = events.length;
                    return Column(
                      children: [
                        OvcHouseholdInfoTopHeader(
                          currentOvcHousehold: currentOvcHousehold,
                        ),
                        Container(
                          child: isLoading
                              ? const CircularProcessLoader(
                                  color: Colors.blueGrey,
                                )
                              : Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                      ),
                                      child: events.isEmpty
                                          ? Text(
                                              currentLanguage == 'lesotho'
                                                  ? 'Ha hona lelapa le lereferioeng ha hajoale'
                                                  : 'There is no Household Referral at a moment',
                                            )
                                          : Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 13.0,
                                              ),
                                              child: Column(
                                                children: events
                                                    .map((Events eventData) {
                                                  int count = referralIndex--;
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      bottom: 15.0,
                                                    ),
                                                    child: ReferralCardSummary(
                                                      borderColor: const Color(
                                                          0xFFEDF5EC),
                                                      buttonLabelColor:
                                                          const Color(
                                                              0xFF4B9F46),
                                                      titleColor: const Color(
                                                          0xFF1B3518),
                                                      count: count,
                                                      canManageReferral:
                                                          currentOvcHousehold
                                                                  ?.hasExitedProgram !=
                                                              true,
                                                      cardBody:
                                                          ReferralCardBodySummary(
                                                        isIncomingReferral:
                                                            false,
                                                        labelColor: const Color(
                                                            0XFF92A791),
                                                        valueColor: const Color(
                                                            0XFF536852),
                                                        referralEvent:
                                                            eventData,
                                                      ),
                                                      onView: () =>
                                                          onViewHouseholdReferral(
                                                        context,
                                                        eventData,
                                                        count,
                                                      ),
                                                      onManage: () =>
                                                          onManageHouseholdReferral(
                                                        context,
                                                        eventData,
                                                        count,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                    ),
                                    Visibility(
                                      visible: currentOvcHousehold
                                              ?.hasExitedProgram !=
                                          true,
                                      child: EntryFormSaveButton(
                                        label: currentLanguage == 'lesotho'
                                            ? 'Kenya Phetisetso'.toUpperCase()
                                            : 'ADD REFERRAL',
                                        labelColor: Colors.white,
                                        buttonColor: const Color(0xFF4B9F46),
                                        fontSize: 15.0,
                                        onPressButton: () => onAddReferral(
                                          context,
                                          currentOvcHousehold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
