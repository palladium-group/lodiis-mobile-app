import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/household_exit_pages/household_graduation/components/ovc_household_graduation_list_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/household_exit_pages/household_graduation/constants/ovc_household_graduation_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/household_exit_pages/household_graduation/pages/ovc_household_graduation_form.dart';
import 'package:provider/provider.dart';

class OvcHouseholdGraduation extends StatefulWidget {
  const OvcHouseholdGraduation({Key? key}) : super(key: key);

  @override
  State<OvcHouseholdGraduation> createState() => _OvcHouseholdGraduationState();
}

class _OvcHouseholdGraduationState extends State<OvcHouseholdGraduation> {
  final String label = 'Household Case Plan Graduation Readiness';

  final List<String> programStageIds = [
    OvcHouseholdGraduationConstant.programStage
  ];

  void updateFormState(BuildContext context, bool isEditableMode,
      Events? graduation, OvcHousehold? houseHold) async {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);

    if (graduation != null) {
      Provider.of<ServiceFormState>(context, listen: false);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventDate', graduation.eventDate);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventId', graduation.event);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('location', graduation.orgUnit);
      for (Map dataValue in graduation.dataValues) {
        if (dataValue['value'] != '') {
          Provider.of<ServiceFormState>(context, listen: false)
              .setFormFieldState(dataValue['dataElement'], dataValue['value']);
        }
      }
    }
    if (isEditableMode) {
      String beneficiaryId = houseHold!.id!;
      String eventId = graduation == null ? '' : graduation.event ?? '';
      String formAutoSaveId =
          '${OvcRoutesConstant.householdGraduationFormPage}_${beneficiaryId}_$eventId';
      FormAutoSave formAutoSave = await FormAutoSaveOfflineService()
          .getSavedFormAutoData(formAutoSaveId);
      bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
          .shouldResumeWithUnSavedChanges(context, formAutoSave);
      if (shouldResumeWithUnSavedChanges) {
        AppResumeRoute().redirectToPages(context, formAutoSave);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OvcHouseholdGraduationForm(),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OvcHouseholdGraduationForm(),
        ),
      );
    }
  }

  void onAddNewHouseholdAchievement(
    BuildContext context,
    OvcHousehold? houseHold,
  ) {
    updateFormState(context, true, null, houseHold);
  }

  void onViewHouseholdAchievement(
      BuildContext context, OvcHousehold? houseHold, Events graduation) {
    updateFormState(context, false, graduation, houseHold);
  }

  void onEditHouseholdAchievement(
      BuildContext context, OvcHousehold? houseHold, Events graduation) {
    updateFormState(context, true, graduation, houseHold);
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
                var currentOvcHousehold =
                    ovcHouseholdCurrentSelectionState.currentOvcHousehold;
                return Column(
                  children: [
                    OvcHouseholdInfoTopHeader(
                      currentOvcHousehold: currentOvcHousehold,
                    ),
                    Consumer<OvcHouseholdCurrentSelectionState>(
                      builder:
                          (context, ovcHouseholdCurrentSelectionState, child) {
                        OvcHousehold? currentOvcHousehold =
                            ovcHouseholdCurrentSelectionState
                                .currentOvcHousehold;
                        return Consumer<ServiceEventDataState>(
                          builder: (context, serviceEventDataState, child) {
                            bool isLoading = serviceEventDataState.isLoading;
                            return isLoading
                                ? const CircularProcessLoader(
                                    color: Colors.blueGrey,
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 10.0,
                                          right: 13.0,
                                          left: 13.0,
                                        ),
                                        child:
                                            OvcHouseholdGraduationListContainer(
                                          programStageIds: programStageIds,
                                          hasBeneficiaryExited:
                                              currentOvcHousehold
                                                      ?.hasExitedProgram ==
                                                  true,
                                          onEditHouseholdAchievement:
                                              (Events graduation) =>
                                                  onEditHouseholdAchievement(
                                            context,
                                            currentOvcHousehold,
                                            graduation,
                                          ),
                                          onViewHouseholdAchievement:
                                              (Events graduation) =>
                                                  onViewHouseholdAchievement(
                                            context,
                                            currentOvcHousehold,
                                            graduation,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !isLoading &&
                                            currentOvcHousehold
                                                    ?.hasExitedProgram !=
                                                true,
                                        child: EntryFormSaveButton(
                                          label: currentLanguage == 'lesotho'
                                              ? 'Graduation e ncha'
                                                  .toUpperCase()
                                              : "NEW GRADUATION",
                                          labelColor: Colors.white,
                                          fontSize: 10,
                                          buttonColor: const Color(0xFF4B9F46),
                                          onPressButton: () =>
                                              onAddNewHouseholdAchievement(
                                            context,
                                            currentOvcHousehold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        );
                      },
                    )
                  ],
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
