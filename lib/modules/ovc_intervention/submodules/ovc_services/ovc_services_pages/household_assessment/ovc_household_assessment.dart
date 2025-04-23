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
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_assessment/pages/ovc_household_hts_screening_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_assessment/pages/ovc_husehold_tb_assessment_form.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/utils/app_util.dart';
import '../../../../../../core/utils/tracked_entity_instance_util.dart';
import '../../../ovc_referral/ovc_referral_pages/ovc_house_referral_pages/pages/ovc_household_add_referral_form.dart';
import '../../constants/ovc_household_hts_assessment_constant.dart';
import '../../constants/ovc_household_tb_assessment_constant.dart';
import '../../models/ovc_service_household_hts_screening_form.dart';
import '../child_assessment/pages/ovc_service_hiv_assessment_form.dart';
import '../child_assessment/pages/ovc_service_nutrition_assesment_form.dart';
import '../child_assessment/pages/ovc_service_tb_assessment18.dart';
import '../child_assessment/pages/ovc_service_tb_assessment_form.dart';
import '../child_assessment/pages/ovc_service_well_being_assessment_form.dart';
import 'components/ovc_household_assessment_list_card.dart';
import 'components/ovc_household_assessment_selection.dart';

class OvcHouseholdAssessment extends StatefulWidget {
  const OvcHouseholdAssessment({Key? key}) : super(key: key);

  @override
  State<OvcHouseholdAssessment> createState() => _OvcHouseholdAssessmentState();
}

class _OvcHouseholdAssessmentState extends State<OvcHouseholdAssessment> {
  final String label = 'Household Assessment';
  final String translatedName = 'Hlahlobo ea lelapa';
  final List<String> programStageIds = [
    OvcHouseholdAssessmentConstant.programStage,

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

  /*void onAddNewHouseholdAssessment(
    BuildContext context,
    OvcHousehold? houseHold,
  ) {
    updateFormState(context, true, null, houseHold);
  }*/
  void onAddNewHouseholdAssessment(
      BuildContext context,
      OvcHousehold household,
      ) async {
    updateFormStateData(context, null, household);
    Widget model = const OvcHouseholdAssessmentSelection();
    var assessmentResponse =
    await AppUtil.showPopUpModal(context, model, false);
    onRedirectToAssessmentForm(context, assessmentResponse, true);
  }

  void onRedirectToAssessmentForm(
      BuildContext context,
      String? assessmentResponse,
      bool isEditableMode,
      ) {
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    if (assessmentResponse != null) {
      assessmentResponse == 'Household Assessment'
          ? Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OvcHouseholdAssessmentForm(),
        ),
      )
          : assessmentResponse == 'TB Screening'
          ? Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OvcServiceHouseholdTBAssessmentForm(),
        ),
      )

          : assessmentResponse == 'HTS Screening'
          ? Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OvcHouseholdAddReferralForm(),
        ),
      )
          : '';
    }
  }

  void updateFormStateData(
      BuildContext context,
      Events? eventData,
      OvcHousehold household,
      ) {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('age', household.age);
    if (eventData != null) {
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventDate', eventData.eventDate);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventId', eventData.event);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('location', eventData.orgUnit);
      for (Map dataValue in eventData.dataValues) {
        if (dataValue['value'] != '') {
          Provider.of<ServiceFormState>(context, listen: false)
              .setFormFieldState(dataValue['dataElement'], dataValue['value']);
        }
      }
    }
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
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, household) {
        String currentLanguage = languageTranslationState.currentLanguage;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(65.0),
            child: Consumer<InterventionCardState>(
              builder: (context, interventionCardState, household) {
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
            body: Consumer<OvcHouseholdCurrentSelectionState>(
              builder: (context, ovcHouseholdCurrentSelectionState, child) {
                OvcHousehold? currentOvcHousehold =
                    ovcHouseholdCurrentSelectionState.currentOvcHousehold;
                OvcHousehold? currentHousehold =
                    ovcHouseholdCurrentSelectionState.currentOvcHousehold;
                return Column(
                  children: [
                    OvcHouseholdInfoTopHeader(currentOvcHousehold: currentOvcHousehold,),
                    Consumer<ServiceEventDataState>(
                      builder: (context, serviceEventDataState, household) {
                        bool isLoading = serviceEventDataState.isLoading;
                        Map<String?, List<Events>> eventListByProgramStage =
                            serviceEventDataState.eventListByProgramStage;
                        Map programStageMap = OvcServiceHouseholdTBAssessmentConstant
                            .getOvcAssessmentProgramStageMap();
                        List<String> programStageIds = [];
                        for (var id in programStageMap.keys.toList()) {
                          programStageIds.add('$id');
                        }
                        List<Events> events = TrackedEntityInstanceUtil
                            .getAllEventListFromServiceDataStateByProgramStages(
                            eventListByProgramStage, programStageIds);
                        return isLoading
                            ? const CircularProcessLoader(
                          color: Colors.blueGrey,
                        )
                            : Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: events.isEmpty
                              ? const Center(
                            child: Text(
                                'There is no assessment at moment'),
                          )
                              : Column(
                            children: events
                                .map(
                                  (Events eventData) =>
                                  OvcHouseholdAssessmentListCard(
                                    eventData: eventData,
                                    programStageMap:
                                    programStageMap,
                                    canEdit: (currentOvcHousehold!
                                        .hasExitedProgram !=
                                        true &&
                                        currentHousehold
                                            ?.hasExitedProgram !=
                                            true),
                                    onEditAssessment: () {
                                      String? assessmentResponse =
                                      programStageMap[eventData
                                          .programStage];
                                      onEditAssessment(
                                          context,
                                          assessmentResponse,
                                          eventData,
                                          currentOvcHousehold);
                                    },
                                    onViewAssessment: () {
                                      String? assessmentResponse =
                                      programStageMap[eventData
                                          .programStage];
                                      onViewAssessment(
                                          context,
                                          assessmentResponse,
                                          eventData,
                                          currentOvcHousehold);
                                    },
                                  ),
                            )
                                .toList(),
                          ),
                        );
                      },
                    ),
                    Consumer<CurrentUserState>(
                      builder: (context, currentUserState, child) {
                        bool isKbFacilitySocialWorker =
                            currentUserState.isKbFacilitySocialWorker;
                        return Visibility(
                          visible: !isKbFacilitySocialWorker &&
                              currentOvcHousehold?.hasExitedProgram !=
                                  true &&
                              currentHousehold?.hasExitedProgram != true,
                          child: EntryFormSaveButton(
                            label: currentLanguage == 'lesotho'
                                ? 'Hlahlobo e ncha'
                                : 'NEW ASSESSMENT',
                            labelColor: Colors.white,
                            fontSize: 14,
                            buttonColor: const Color(0xFF4B9F46),
                            onPressButton: () => onAddNewHouseholdAssessment(
                              context,
                              currentOvcHousehold!,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
        );
      },
    );
  }
  void onEditAssessment(BuildContext context, String? assessmentResponse,
      Events eventData, OvcHousehold child) {
    bool isEditableMode = true;
    updateFormStateData(context, eventData, child);
    onRedirectToAssessmentForm(context, assessmentResponse, isEditableMode);
  }

  void onViewAssessment(BuildContext context, String? assessmentResponse,
      Events eventData, OvcHousehold child) {
    bool isEditableMode = false;
    updateFormStateData(context, eventData, child);
    onRedirectToAssessmentForm(context, assessmentResponse, isEditableMode);
  }

/*
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
                                                  context, currentOvcHousehold!),
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
  }*/
}
