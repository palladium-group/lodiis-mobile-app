import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
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
import 'package:provider/provider.dart';

import 'pp_prev_intervention_service_provision_form.dart';

class PpPrevInterventionServiceHome extends StatelessWidget {
  const PpPrevInterventionServiceHome({Key? key}) : super(key: key);
  final String label = "PP Prev Service Provision";

  void redirectToPpPrevServiceForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const PpPrevInterventionServiceProvisionForm();
        },
      ),
    );
  }

  onAddNewPpPrevService(
    BuildContext context,
    PpPrevBeneficiary ppPrevBeneficiary,
  ) async {
    bool isEditableMode = true;
    String? beneficiaryId = ppPrevBeneficiary.id;
    String eventId = '';
    String formAutoSaveId =
        "${PpPrevRoutesConstant.serviceFormPageModule}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave,
            beneficiaryName: ppPrevBeneficiary.toString());
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      FormUtil.updateServiceFormState(context, isEditableMode, null);
      redirectToPpPrevServiceForm(context);
    }
  }

  onViewPpPrevService(
    BuildContext context,
    PpPrevBeneficiary ppPrevBeneficiary,
    Events eventData,
  ) {
    bool isEditableMode = false;
    FormUtil.updateServiceFormState(context, isEditableMode, eventData);
    redirectToPpPrevServiceForm(context);
  }

  onEditPpPrevService(
    BuildContext context,
    PpPrevBeneficiary ppPrevBeneficiary,
    Events eventData,
  ) async {
    bool isEditableMode = true;
    String? beneficiaryId = ppPrevBeneficiary.id;
    String eventId = eventData.event!;
    String formAutoSaveId =
        "${PpPrevRoutesConstant.serviceFormPageModule}_${beneficiaryId}_$eventId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave,
            beneficiaryName: ppPrevBeneficiary.toString());
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      FormUtil.updateServiceFormState(context, isEditableMode, eventData);
      redirectToPpPrevServiceForm(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> programStageIds = [
      PpPrevInterventionConstant.servicesProgramStage
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
                label: label,
                activeInterventionProgram: activeInterventionProgram,
              );
            },
          ),
        ),
        body: SubPageBody(
          body: Consumer<LanguageTranslationState>(
            builder: (context, languageState, child) =>
                Consumer<PpPrevInterventionCurrentSelectionState>(
              builder: (context, dreamBeneficiarySelectionState, child) {
                return Consumer<ServiceEventDataState>(
                  builder: (context, serviceEventDataState, child) {
                    PpPrevBeneficiary? ppPrevBeneficiary =
                        dreamBeneficiarySelectionState.currentPpPrev;
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
                                          ? Text(
                                              languageState.currentLanguage ==
                                                      'lesotho'
                                                  ? 'Ha ho na Litšebeletso hajoale'
                                                  : 'There is no Services at a moment',
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
                                                    visitName:
                                                        "Service $serviceIndex",
                                                    onEdit: () =>
                                                        onEditPpPrevService(
                                                            context,
                                                            ppPrevBeneficiary,
                                                            eventData),
                                                    onView: () =>
                                                        onViewPpPrevService(
                                                            context,
                                                            ppPrevBeneficiary,
                                                            eventData),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                    ),
                                    EntryFormSaveButton(
                                      label: languageState.currentLanguage ==
                                              'lesotho'
                                          ? 'TLATSA TŠEBELETSO'
                                          : 'ADD Service',
                                      labelColor: Colors.white,
                                      buttonColor: const Color(0xFF9B2BAE),
                                      fontSize: 15.0,
                                      onPressButton: () =>
                                          onAddNewPpPrevService(
                                              context, ppPrevBeneficiary),
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
