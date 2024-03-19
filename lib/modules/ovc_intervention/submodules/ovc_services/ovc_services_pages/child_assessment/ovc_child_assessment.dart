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
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/components/ovc_child_assessment_list_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/components/ovc_child_assessment_selection.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/constants/ovc_asessment_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/pages/ovc_service_hiv_assessment_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/pages/ovc_service_tb_assessment_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/pages/ovc_service_well_being_assessment_form.dart';
import 'package:provider/provider.dart';

class OvcChildAssessment extends StatelessWidget {
  final String label = 'Child Assessment';

  const OvcChildAssessment({Key? key}) : super(key: key);

  void onAddNewChildAssessment(
    BuildContext context,
    OvcHouseholdChild child,
  ) async {
    updateFormStateData(context, null, child);
    Widget model = const OvcChildAssessmentSelection();
    String? assessmentResponse =
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
      assessmentResponse == 'Well-being'
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OvcServiceWellBeingAssessmentForm(),
              ),
            )
          : assessmentResponse == 'TB'
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OvcServiceTBAssessmentForm(),
                  ),
                )
              : assessmentResponse == 'HIV'
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OvcServiceHIVAssessmentForm(),
                      ),
                    )
                  : '';
    }
  }

  void updateFormStateData(
    BuildContext context,
    Events? eventData,
    OvcHouseholdChild child,
  ) {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('age', child.age);
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

  void onViewAssessment(BuildContext context, String? assessmentResponse,
      Events eventData, OvcHouseholdChild child) {
    bool isEditableMode = false;
    updateFormStateData(context, eventData, child);
    onRedirectToAssessmentForm(context, assessmentResponse, isEditableMode);
  }

  void onEditAssessment(BuildContext context, String? assessmentResponse,
      Events eventData, OvcHouseholdChild child) {
    bool isEditableMode = true;
    updateFormStateData(context, eventData, child);
    onRedirectToAssessmentForm(context, assessmentResponse, isEditableMode);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;

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
            body: Consumer<OvcHouseholdCurrentSelectionState>(
              builder: (context, ovcHouseholdCurrentSelectionState, child) {
                OvcHouseholdChild? currentOvcHouseholdChild =
                    ovcHouseholdCurrentSelectionState.currentOvcHouseholdChild;
                OvcHousehold? currentHousehold =
                    ovcHouseholdCurrentSelectionState.currentOvcHousehold;
                return Column(
                  children: [
                    const OvcChildInfoTopHeader(),
                    Consumer<ServiceEventDataState>(
                      builder: (context, serviceEventDataState, child) {
                        bool isLoading = serviceEventDataState.isLoading;
                        Map<String?, List<Events>> eventListByProgramStage =
                            serviceEventDataState.eventListByProgramStage;
                        Map programStageMap = OvcAssessmentConstant
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
                                                  OvcChildAssessmentListCard(
                                                eventData: eventData,
                                                programStageMap:
                                                    programStageMap,
                                                canEdit: (currentOvcHouseholdChild!
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
                                                      currentOvcHouseholdChild);
                                                },
                                                onViewAssessment: () {
                                                  String? assessmentResponse =
                                                      programStageMap[eventData
                                                          .programStage];
                                                  onViewAssessment(
                                                      context,
                                                      assessmentResponse,
                                                      eventData,
                                                      currentOvcHouseholdChild);
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
                              currentOvcHouseholdChild?.hasExitedProgram !=
                                  true &&
                              currentHousehold?.hasExitedProgram != true,
                          child: EntryFormSaveButton(
                            label: currentLanguage == 'lesotho'
                                ? 'Hlahlobo e ncha'
                                : 'NEW ASSESSMENT',
                            labelColor: Colors.white,
                            fontSize: 14,
                            buttonColor: const Color(0xFF4B9F46),
                            onPressButton: () => onAddNewChildAssessment(
                              context,
                              currentOvcHouseholdChild!,
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
}
