import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/components/ovc_child_school_monitor_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_hei_monitoring/pages/ovc_hei_monitoring_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_school_monitoring/constants/ovc_school_monitoring_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_school_monitoring/pages/ovc_school_monitoring_form.dart';
import 'package:provider/provider.dart';

import '../../components/ovc_child_hei_monitor_container.dart';

class OvcHeiMonitoring extends StatefulWidget {
  const OvcHeiMonitoring({Key? key}) : super(key: key);

  @override
  State<OvcHeiMonitoring> createState() => _OvcHeiMonitoringState();
}

class _OvcHeiMonitoringState extends State<OvcHeiMonitoring> {
  final List<String> programStageIds = [
    OvcSchoolMonitoringConstant.programStage
  ];

  void onAddHeiMonitoring(BuildContext context) {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OvcHeiMonitoringForm(),
      ),
    );
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

  void onEditHeiMonitoring(
      BuildContext context,
      Events eventData,
      ) {
    bool isEditableMode = true;
    updateFormStateData(context, eventData);
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OvcHeiMonitoringForm(),
      ),
    );
  }

  void onViewHeiMonitoring(
      BuildContext context,
      Events eventData,
      ) {
    bool isEditableMode = false;
    updateFormStateData(context, eventData);
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OvcHeiMonitoringForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceEventDataState>(
        builder: (context, serviceEventDataState, _) {
          bool isLoading = serviceEventDataState.isLoading;
          Map<String?, List<Events>> eventListByProgramStage =
              serviceEventDataState.eventListByProgramStage;

          List<Events> events = TrackedEntityInstanceUtil
              .getAllEventListFromServiceDataStateByProgramStages(
              eventListByProgramStage, programStageIds);
          int monitoringCount = events.length;
          return isLoading
              ? const CircularProcessLoader(
            color: Colors.blueGrey,
          )
              : Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: events.isEmpty
                    ? const Text('There is no Hei Card at a moment')
                    : Column(
                  children: events.map((Events event) {
                    int index = monitoringCount--;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15.0),
                      child: OvcChildHeiMonitorContainer(
                        eventData: event,
                        index: index,
                        onEditMonitor: () =>
                            onEditHeiMonitoring(context, event),
                        onViewMonitor: () =>
                            onViewHeiMonitoring(context, event),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Consumer<CurrentUserState>(
                builder: (context, currentUserState, child) {
                  bool isKbFacilitySocialWorker =
                      currentUserState.isKbFacilitySocialWorker;
                  return Consumer<OvcHouseholdCurrentSelectionState>(
                    builder:
                        (context, ovcHouseholdCurrentSelectionState, child) {
                      var currentOvcHouseholdChild =
                      ovcHouseholdCurrentSelectionState
                          .currentOvcHouseholdChild!;
                      var currentOvcHousehold =
                      ovcHouseholdCurrentSelectionState
                          .currentOvcHousehold!;
                      return Consumer<LanguageTranslationState>(
                        builder: (context, languageTranslationState, child) =>
                            Visibility(
                              visible: !isKbFacilitySocialWorker &&
                                  currentOvcHouseholdChild.hasExitedProgram !=
                                      true &&
                                  currentOvcHousehold.hasExitedProgram != true,
                              child: EntryFormSaveButton(
                                label: languageTranslationState.isSesothoLanguage
                                    ? "KENYA TLHOKOMELO"
                                    : 'ADD MONITORING',
                                labelColor: Colors.white,
                                buttonColor: const Color(0xFF4B9F46),
                                fontSize: 15.0,
                                onPressButton: () =>
                                    onAddHeiMonitoring(context),
                              ),
                            ),
                      );
                    },
                  );
                },
              )
            ],
          );
        });
  }
}
