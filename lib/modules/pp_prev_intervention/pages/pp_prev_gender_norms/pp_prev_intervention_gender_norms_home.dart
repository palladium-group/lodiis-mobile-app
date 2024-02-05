import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/pp_prev_beneficiary.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/components/pp_prev_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/components/pp_prev_services_visit_card.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/constants/pp_prev_intervention_constant.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/constants/pp_prev_routes_constant.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/pages/pp_prev_gender_norms/pp_prev_intervention_gender_norms_form.dart';

class PpPrevInterventionGenderNormsHome extends StatelessWidget {
  const PpPrevInterventionGenderNormsHome({Key? key}) : super(key: key);

  final String title = 'PP Prev Gender Norms';

  void redirectToPpPrevGenderNormsForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const PpPrevInterventionGenderNormsForm();
        },
      ),
    );
  }

  onAddNewPpPrevGenderNorms(
    BuildContext context,
    PpPrevBeneficiary ppPrevBeneficiary,
    List<Events> allEvents,
  ) async {
    bool isEditableMode = true;
    String? beneficiaryId = ppPrevBeneficiary.id;
    String eventId = '';
    String formAutoSaveId =
        "${PpPrevRoutesConstant.genderNormsFormPageModule}_${beneficiaryId}_$eventId";
    updateFormState(context, isEditableMode, allEvents, null);
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave,
            beneficiaryName: ppPrevBeneficiary.toString());
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      redirectToPpPrevGenderNormsForm(context);
    }
  }

  onViewPpPrevGenderNorms(
    BuildContext context,
    PpPrevBeneficiary ppPrevBeneficiary,
    Events eventData,
  ) {
    bool isEditableMode = false;
    updateFormState(context, isEditableMode, null, eventData);
    redirectToPpPrevGenderNormsForm(context);
  }

  onEditPpPrevGenderNorms(
    BuildContext context,
    PpPrevBeneficiary ppPrevBeneficiary,
    Events eventData,
    List<Events> allEvents,
  ) async {
    bool isEditableMode = true;
    String? beneficiaryId = ppPrevBeneficiary.id;
    String eventId = eventData.event!;
    updateFormState(context, isEditableMode, allEvents, eventData);
    String formAutoSaveId =
        "${PpPrevRoutesConstant.genderNormsFormPageModule}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave,
            beneficiaryName: ppPrevBeneficiary.toString());
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      redirectToPpPrevGenderNormsForm(context);
    }
  }

 Map<String?, List<String>> getSessionsPerIntervention(
  Events? currentEvent,
  List<Events>? events,
) {
  String sessionNumberDataElement = 'vL6NpUA0rIU';
  String interventionsDataElementId = 'IOW7iC5ZuRQ';
  Map<String?, List<String>> interventionSessions = {};

  String currentEventId =
      currentEvent != null ? currentEvent.event ?? '' : '';

  // A copy of the events list to avoid modifying the original list
  List<Events> copiedEvents = List<Events>.from(events ?? []);

  // Remove the current event from the copied list
  copiedEvents.removeWhere((eventData) => eventData.event == currentEventId);

  for (Events event in (copiedEvents)) {
    Map<String, String> data = {};
    for (Map dataValues in (event.dataValues ?? [])) {
      String? dataElement = dataValues['dataElement'];
      if (dataElement != null) {
        data[dataElement] = '${dataValues['value']}'.trim();
      }
    }
    // Check if the interventions data element is present in the event data
    if (data.containsKey(interventionsDataElementId)) {
      var selectedIntervention = data[interventionsDataElementId];
      var sessionNumber = data[sessionNumberDataElement] ?? '';
      if (selectedIntervention != null && selectedIntervention != 'null') {
        interventionSessions[selectedIntervention] = [
          ...(interventionSessions[selectedIntervention] ?? []),
          sessionNumber,
        ];
      }
    }
  }
  return interventionSessions;
}


  // print("interventionSessions $interventionSessions");

  void updateFormState(
    BuildContext context,
    bool isEditableMode,
    List<Events>? events,
    Events? currentEvent,
  ) {
    FormUtil.updateServiceFormState(context, isEditableMode, currentEvent);
    Map<String?, List<String?>> interventionSessions =
        getSessionsPerIntervention(currentEvent, events);
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('interventionSessions', interventionSessions);
    if (isEditableMode) {
      var currentUser =
          Provider.of<CurrentUserState>(context, listen: false).currentUser;
      var currentUserName = currentUser!.name;
      String youthMentorNameField = 'W79837fEI3C';
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState(youthMentorNameField, currentUserName);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> programStageIds = [
      PpPrevInterventionConstant.genderNormsProgramStage
    ];
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65.0),
          child: Consumer<InterventionCardState>(
            builder: (context, interventionCardState, child) {
              InterventionCard activeInterventionProgram =
                  interventionCardState.currentInterventionProgram;
              return SubPageAppBar(
                label: title,
                activeInterventionProgram: activeInterventionProgram,
              );
            },
          ),
        ),
        body: SubPageBody(
          body: Consumer<LanguageTranslationState>(
            builder: (context, languageState, child) =>
                Consumer<PpPrevInterventionCurrentSelectionState>(
              builder:
                  (context, ppPrevInterventionCurrentSelectionState, child) {
                return Consumer<ServiceEventDataState>(
                  builder: (context, serviceEventDataState, child) {
                    PpPrevBeneficiary? ppPrevBeneficiary =
                        ppPrevInterventionCurrentSelectionState.currentPpPrev;
                    bool isLoading = serviceEventDataState.isLoading;
                    Map<String?, List<Events>> eventListByProgramStage =
                        serviceEventDataState.eventListByProgramStage;
                    List<Events> events = TrackedEntityInstanceUtil
                        .getAllEventListFromServiceDataStateByProgramStages(
                            eventListByProgramStage, programStageIds,
                            shouldSortByDate: true);
                    int serviceIndex = events.length + 1;
                    return Column(
                      children: [
                        PpPrevBeneficiaryTopHeader(
                          ppPrevBeneficiary: ppPrevBeneficiary!,
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
                                          ? const Text(
                                              'There is no Gender Norms services at a moment',
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
                                                  serviceIndex--;
                                                  return PpPrevServiceVisitCard(
                                                    eventData: eventData,
                                                    visitName: languageState
                                                                .currentLanguage ==
                                                            'lesotho'
                                                        ? 'Tšebeletso ea litloaelo tsa tekano $serviceIndex'
                                                        : "Gender norms Service $serviceIndex",
                                                    onEdit: () =>
                                                        onEditPpPrevGenderNorms(
                                                      context,
                                                      ppPrevBeneficiary,
                                                      eventData,
                                                      events,
                                                    ),
                                                    onView: () =>
                                                        onViewPpPrevGenderNorms(
                                                      context,
                                                      ppPrevBeneficiary,
                                                      eventData,
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                    ),
                                    EntryFormSaveButton(
                                      label: 'ADD Gender Norms',
                                      labelColor: Colors.white,
                                      buttonColor: const Color(0xFF9B2BAE),
                                      fontSize: 15.0,
                                      onPressButton: () =>
                                          onAddNewPpPrevGenderNorms(
                                        context,
                                        ppPrevBeneficiary,
                                        events,
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
            ),
          ),
        ),
      ),
    );
  }
}
