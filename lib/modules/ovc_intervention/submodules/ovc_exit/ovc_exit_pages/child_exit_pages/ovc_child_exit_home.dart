import 'package:flutter/material.dart';
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
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/child_exit_pages/constants/ovc_exit_case_closure_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/child_exit_pages/constants/ovc_exit_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/child_exit_pages/pages/ovc_exit_case_closure_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/child_exit_pages/pages/ovc_exit_case_transfer_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/child_exit_pages/pages/ovc_exit_caseplan_graduation_readiness_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/child_exit_pages/pages/ovc_exit_information_form.dart';
import 'package:provider/provider.dart';
import 'components/ovc_exit_list_card.dart';
import 'components/ovc_exit_selection.dart';

class OvcChildExitHome extends StatefulWidget {
  const OvcChildExitHome({Key? key}) : super(key: key);

  @override
  State<OvcChildExitHome> createState() => _OvcChildExitHomeState();
}

class _OvcChildExitHomeState extends State<OvcChildExitHome> {
  final String label = 'Child Exit';

  final List<String> programStageIds = [];

  void onAddNewExit(BuildContext context, List<Events> events) async {
    List<String?> programStageIdsWithData =
        events.map((Events event) => event.programStage).toList();
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Widget model = OvcChildExitSelection(
      programStageIdsWithData: programStageIdsWithData,
    );
    String? exitResponse = await AppUtil.showPopUpModal(context, model, false);
    onRedirectToExitForm(context, exitResponse, true);
  }

  void onRedirectToExitForm(
      BuildContext context, String? exitResponse, bool isEditableMode,
      {String eventId = ''}) async {
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    if (exitResponse != null) {
      OvcHouseholdChild? beneficiary =
          Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
              .currentOvcHouseholdChild;
      String beneficiaryId = beneficiary!.id ?? '';
      String exitForm = exitResponse == 'Exit'
          ? OvcRoutesConstant.ovcExitFormPage
          : exitResponse == 'Transfer'
              ? OvcRoutesConstant.ovcTransferFormPage
              : exitResponse == 'Case closure'
                  ? OvcRoutesConstant.ovcClosureFormPage
                  : exitResponse == 'Graduation'
                      ? OvcRoutesConstant.ovcGraduationFormPage
                      : '';
      String formAutoSaveId = '${exitForm}_${beneficiaryId}_$eventId';

      FormAutoSave formAutoSave = await FormAutoSaveOfflineService()
          .getSavedFormAutoData(formAutoSaveId);
      bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
          .shouldResumeWithUnSavedChanges(context, formAutoSave);

      if (shouldResumeWithUnSavedChanges) {
        AppResumeRoute().redirectToPages(context, formAutoSave);
      } else {
        exitResponse == 'Exit'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OvcExitInformationForm(),
                ),
              )
            : exitResponse == 'Transfer'
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OvcExitCaseTransferForm(),
                    ),
                  )
                : exitResponse == 'Case closure'
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OvcExitCaseClosureForm(),
                        ),
                      )
                    : exitResponse == 'Graduation'
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HouseholdGraduationReadinessFormForm(),
                            ),
                          )
                        : '';
      }
    }
  }

  void updateFormStateData(BuildContext context, Events eventData) {
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

  void onViewExit(
    BuildContext context,
    String? exitResponse,
    Events eventData,
  ) {
    bool isEditableMode = false;
    updateFormStateData(context, eventData);
    onRedirectToExitForm(context, exitResponse, isEditableMode);
  }

  void onEditExit(
    BuildContext context,
    String? exitResponse,
    Events eventData,
  ) {
    bool isEditableMode = true;
    updateFormStateData(context, eventData);
    onRedirectToExitForm(context, exitResponse, isEditableMode,
        eventId: eventData.event!);
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
        body: Column(children: [
          const OvcChildInfoTopHeader(),
          Consumer<ServiceEventDataState>(
            builder: (context, serviceEventDataState, child) {
              bool isLoading = serviceEventDataState.isLoading;
              Map<String?, List<Events>> eventListByProgramStage =
                  serviceEventDataState.eventListByProgramStage;
              Map programStageMap = OvcExitConstant.getOvcExitProgramStageMap();
              for (var id in programStageMap.keys.toList()) {
                programStageIds.add('$id');
              }
              List<Events> events = TrackedEntityInstanceUtil
                  .getAllEventListFromServiceDataStateByProgramStages(
                      eventListByProgramStage, programStageIds);
              bool shouldAllowAddNewButton = events
                      .map((Events event) => event.programStage)
                      .toList()
                      .length <
                  programStageIds.toSet().toList().length;
              return isLoading
                  ? const CircularProcessLoader(
                      color: Colors.blueGrey,
                    )
                  : Consumer<OvcHouseholdCurrentSelectionState>(builder:
                      (context, ovcHouseholdCurrentSelectionState, child) {
                      var currentOvcHouseholdChild =
                          ovcHouseholdCurrentSelectionState
                              .currentOvcHouseholdChild!;

                      var currentOvcHousehold =
                          ovcHouseholdCurrentSelectionState
                              .currentOvcHousehold!;

                      List<String?> programStageIdsWithData = events
                          .map((Events event) => event.programStage)
                          .toList();
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: events.isEmpty
                                ? const Center(
                                    child: Text(
                                        'There is no any exit details at moment'),
                                  )
                                : Column(
                                    children: events
                                        .map(
                                          (Events eventData) => OvcExitListCard(
                                            eventData: eventData,
                                            programStageMap: programStageMap,
                                            onEditExit: () {
                                              String? exitResponse =
                                                  programStageMap[
                                                      eventData.programStage];
                                              onEditExit(context, exitResponse,
                                                  eventData);
                                            },
                                            onViewExit: () {
                                              String? exitResponse =
                                                  programStageMap[
                                                      eventData.programStage];
                                              onViewExit(context, exitResponse,
                                                  eventData);
                                            },
                                            canEditExit:
                                                currentOvcHouseholdChild
                                                            .hasExitedProgram !=
                                                        true &&
                                                    currentOvcHousehold
                                                            .hasExitedProgram !=
                                                        true,
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ),
                          Visibility(
                            visible: shouldAllowAddNewButton &&
                                !programStageIdsWithData.contains(
                                    OvcExitCaseClosureConstant.programStage) &&
                                currentOvcHousehold.hasExitedProgram != true &&
                                currentOvcHouseholdChild.hasExitedProgram !=
                                    true,
                            child: EntryFormSaveButton(
                              label: 'ADD',
                              labelColor: Colors.white,
                              fontSize: 14,
                              buttonColor: const Color(0xFF4B9F46),
                              onPressButton: () => onAddNewExit(
                                context,
                                events,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
            },
          ),
        ]),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
