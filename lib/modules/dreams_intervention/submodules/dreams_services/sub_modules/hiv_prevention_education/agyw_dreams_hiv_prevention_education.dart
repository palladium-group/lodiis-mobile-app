import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/components/dreams_services_visit_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hiv_prevention_education/constants/hiv_prevention_education_constants.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hiv_prevention_education/pages/hiv_prevention_education_form.dart';
import 'package:provider/provider.dart';

class AgywDreamsHIVPreventionEducation extends StatefulWidget {
  const AgywDreamsHIVPreventionEducation({Key? key}) : super(key: key);

  @override
  State<AgywDreamsHIVPreventionEducation> createState() =>
      _HIVPreventionEducationState();
}

class _HIVPreventionEducationState
    extends State<AgywDreamsHIVPreventionEducation> {
  final String label = 'HIV Prevention Education';
  List<String> programStageIds = [HIVPreventionEducationConstants.programStage];
  @override
  void initState() {
    super.initState();
  }

  void onAddHIVPreventionEducation(
    BuildContext context,
    AgywDream agywDream,
  ) async {
    FormUtil.updateServiceFormState(context, true, null);
    String? beneficiaryId = agywDream.id;
    String eventId = "";
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywDreamHIVPreventionEducationFormPage}_${beneficiaryId}_$eventId";
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
          builder: (context) => const HIVPreventionEducationForm(),
        ),
      );
    }
  }

  void onViewHIVPreventionEducation(
    BuildContext context,
    Events eventData,
  ) async {
    FormUtil.updateServiceFormState(context, false, eventData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HIVPreventionEducationForm(),
      ),
    );
  }

  void onEditHIVPreventionEducation(
    BuildContext context,
    Events eventData,
    AgywDream agywDream,
  ) async {
    FormUtil.updateServiceFormState(context, true, eventData);
    String? beneficiaryId = agywDream.id;
    String? eventId = eventData.event;
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywDreamHIVPreventionEducationFormPage}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges =
        await AppResumeRoute().shouldResumeWithUnSavedChanges(
      context,
      formAutoSave,
      beneficiaryName: agywDream.toString(),
    );
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HIVPreventionEducationForm(),
        ),
      );
    }
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
          builder: (context, languageTranslationState, child) =>
              Consumer<DreamsBeneficiarySelectionState>(
            builder: (context, dreamBeneficiarySelectionState, child) {
              return Consumer<ServiceEventDataState>(
                builder: (context, serviceEventDataState, child) {
                  AgywDream? agywDream =
                      dreamBeneficiarySelectionState.currentAgywDream;
                  bool isLoading = serviceEventDataState.isLoading;
                  Map<String?, List<Events>> eventListByProgramStage =
                      serviceEventDataState.eventListByProgramStage;
                  List<Events> events = TrackedEntityInstanceUtil
                      .getAllEventListFromServiceDataStateByProgramStages(
                    eventListByProgramStage,
                    programStageIds,
                    shouldSortByDate: true,
                  );
                  int hivMessageIndex = events.length + 1;
                  return Column(
                    children: [
                      DreamsBeneficiaryTopHeader(
                        agywDream: agywDream,
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
                                            languageTranslationState
                                                        .currentLanguage ==
                                                    'lesotho'
                                                ? 'Ha ho na ketelo hajoale'
                                                : 'There is no visit at a moment',
                                            textAlign: TextAlign.center,
                                          )
                                        : Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 5.0,
                                              horizontal: 13.0,
                                            ),
                                            child: Column(
                                              children: events
                                                  .map((Events eventData) {
                                                hivMessageIndex--;
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                    bottom: 15.0,
                                                  ),
                                                  child: DreamsServiceVisitCard(
                                                    visitName: languageTranslationState
                                                                .currentLanguage ==
                                                            'lesotho'
                                                        ? 'Thuto ea Thibelo ea HIV'
                                                        : "HIV Prevention Education",
                                                    onEdit: () =>
                                                        onEditHIVPreventionEducation(
                                                      context,
                                                      eventData,
                                                      agywDream!,
                                                    ),
                                                    onView: () =>
                                                        onViewHIVPreventionEducation(
                                                            context, eventData),
                                                    eventData: eventData,
                                                    visitCount: hivMessageIndex,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                  ),
                                  EntryFormSaveButton(
                                    label: 'ADD HIV Prevention Education',
                                    labelColor: Colors.white,
                                    buttonColor: const Color(0xFF1F8ECE),
                                    fontSize: 15.0,
                                    onPressButton: () =>
                                        onAddHIVPreventionEducation(
                                      context,
                                      agywDream!,
                                    ),
                                  ),
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
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
