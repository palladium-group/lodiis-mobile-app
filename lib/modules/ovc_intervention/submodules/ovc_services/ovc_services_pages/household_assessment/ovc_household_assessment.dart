import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
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
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_assessment/components/ovc_household_assessment_list_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_household_assessment_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_assessment/pages/ovc_household_assessment_form.dart';
import 'package:provider/provider.dart';

class OvcHouseholdAssessment extends StatefulWidget {
  const OvcHouseholdAssessment({Key? key}) : super(key: key);

  @override
  State<OvcHouseholdAssessment> createState() => _OvcHouseholdAssessmentState();
}

class _OvcHouseholdAssessmentState extends State<OvcHouseholdAssessment> {
  final String label = 'Household Assessment';
  final String translatedName = 'Hlahlobo ea lelapa';
  final List<String> programStageIds = [
    OvcHouseholdAssessmentConstant.programStage
  ];
  void updateFormState(BuildContext context, bool isEditableMode,
      Events? assessment, OvcHousehold? household) async {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);

    if (assessment != null) {
      Provider.of<ServiceFormState>(context, listen: false);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventDate', assessment.eventDate);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventId', assessment.event);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('location', assessment.orgUnit);
      for (Map dataValue in assessment.dataValues) {
        if (dataValue['value'] != '') {
          Provider.of<ServiceFormState>(context, listen: false)
              .setFormFieldState(dataValue['dataElement'], dataValue['value']);
        }
      }
    }

    String? beneficiaryId = household!.id;
    String eventId = assessment == null ? '' : assessment.event ?? '';
    String formAutoSaveId =
        "${OvcRoutesConstant.houseHoldAssessmentFormPage}_${beneficiaryId}_$eventId";
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
              builder: (context) => const OvcHouseholdAssessmentForm()));
    }
  }

  void onAddNewHouseholdAssessment(
    BuildContext context,
    OvcHousehold? houseHold,
  ) {
    updateFormState(context, true, null, houseHold);
  }

  void onViewHouseholdAssessment(
      BuildContext context, OvcHousehold? houseHold, Events assessment) {
    updateFormState(context, false, assessment, houseHold);
  }

  void onEditHouseholdAssessment(
      BuildContext context, OvcHousehold? houseHold, Events assessment) {
    updateFormState(context, true, assessment, houseHold);
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
              translatedName: translatedName,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Consumer<OvcHouseholdCurrentSelectionState>(
          builder: (context, ovcHouseholdCurrentSelectionState, child) {
            var currentOvcHousehold =
                ovcHouseholdCurrentSelectionState.currentOvcHousehold;
            return Column(
              children: [
                OvcHouseholdInfoTopHeader(
                  currentOvcHousehold: currentOvcHousehold,
                ),
                Consumer<LanguageTranslationState>(
                  builder: (context, languageTranslationState, child) =>
                      Consumer<OvcHouseholdCurrentSelectionState>(
                    builder:
                        (context, ovcHouseholdCurrentSelectionState, child) {
                      OvcHousehold? currentOvcHousehold =
                          ovcHouseholdCurrentSelectionState.currentOvcHousehold;
                      return Consumer<ServiceEventDataState>(
                        builder: (context, serviceEventDataState, child) {
                          bool isLoading = serviceEventDataState.isLoading;
                          return isLoading
                              ? const CircularProcessLoader(
                                  color: Colors.blueGrey,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        top: 10.0,
                                        right: 13.0,
                                        left: 13.0,
                                      ),
                                      child:
                                          OvcHouseholdAssessmentListContainer(
                                        programStageIds: programStageIds,
                                        onEditHouseholdAssessment:
                                            (Events assessment) =>
                                                onEditHouseholdAssessment(
                                          context,
                                          currentOvcHousehold,
                                          assessment,
                                        ),
                                        onViewHouseholdAssessment:
                                            (Events assessment) =>
                                                onViewHouseholdAssessment(
                                          context,
                                          currentOvcHousehold,
                                          assessment,
                                        ),
                                      ),
                                    ),
                                    Consumer<CurrentUserState>(
                                      builder:
                                          (context, curentUserState, child) =>
                                              Visibility(
                                        visible: !curentUserState
                                                .isKbFacilitySocialWorker &&
                                            !isLoading &&
                                            currentOvcHousehold
                                                    ?.hasExitedProgram !=
                                                true,
                                        child: EntryFormSaveButton(
                                          label: languageTranslationState
                                                      .currentLanguage ==
                                                  'lesotho'
                                              ? 'HLAHLOBO E NCHA'
                                              : "NEW ASSESSMENT",
                                          labelColor: Colors.white,
                                          fontSize: 10,
                                          buttonColor: const Color(0xFF4B9F46),
                                          onPressButton: () =>
                                              onAddNewHouseholdAssessment(
                                                  context, currentOvcHousehold),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
