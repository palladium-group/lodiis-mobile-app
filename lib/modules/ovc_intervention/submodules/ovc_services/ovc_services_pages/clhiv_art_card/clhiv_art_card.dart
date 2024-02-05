import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/clhiv_art_card/components/clhiv_art_card_visit.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/clhiv_art_card/constants/clhiv_art_card_constants.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/clhiv_art_card/pages/clhiv_art_card_service_form.dart';
import 'package:provider/provider.dart';

class ClhivArtCard extends StatelessWidget {
  ClhivArtCard({Key? key}) : super(key: key);

  final String header = 'CLHIV ART Card Services';
  final List<String> programStageIds = [ClhivArtCardConstants.programStage];

  void updateFormStateData(
    BuildContext context,
    Events? eventData,
    bool isEditableMode,
  ) {
    FormUtil.updateServiceFormState(context, isEditableMode, eventData);
    if (isEditableMode) {
      CurrentUser? currentUser =
          Provider.of<CurrentUserState>(context, listen: false).currentUser;
      Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
          ClhivArtCardConstants.serviceProvider, currentUser?.name ?? '');
    }
  }

  Future<void> redirectToClhivArtCardServiceFormWithAutosave(
    BuildContext context,
    OvcHouseholdChild ovc,
    Events? eventData,
  ) async {
    String? beneficiaryId = ovc.id;
    String eventId = eventData?.event ?? '';
    String formAutoSaveId =
        '${OvcRoutesConstant.ovcClhivArtCardServiceFormPage}_${beneficiaryId}_$eventId';
    updateFormStateData(context, eventData, true);
    await FormAutoSaveOfflineService()
        .getSavedFormAutoData(formAutoSaveId)
        .then((formAutoSave) async => await AppResumeRoute()
                .shouldResumeWithUnSavedChanges(context, formAutoSave)
                .then((shouldResumeWithUnSavedChanges) {
              if (shouldResumeWithUnSavedChanges) {
                AppResumeRoute().redirectToPages(context, formAutoSave);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClhivArtCardServiceForm(),
                  ),
                );
              }
            }));
  }

  void onAddClhivArtCardService(
    BuildContext context,
    OvcHouseholdChild ovc,
    Events? eventData,
  ) async {
    redirectToClhivArtCardServiceFormWithAutosave(context, ovc, eventData);
  }

  void onEditClhivArtCardService(
    BuildContext context,
    OvcHouseholdChild ovc,
    Events? eventData,
  ) async {
    redirectToClhivArtCardServiceFormWithAutosave(context, ovc, eventData);
  }

  void onViewClhivArtCardService(
    BuildContext context,
    Events? eventData,
  ) {
    updateFormStateData(context, eventData, false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ClhivArtCardServiceForm(),
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
              label: header,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Column(
          children: [
            const OvcChildInfoTopHeader(),
            Consumer<OvcHouseholdCurrentSelectionState>(
              builder: (context, ovcHouseholdCurrentSelectionState, child) {
                var currentOvc =
                    ovcHouseholdCurrentSelectionState.currentOvcHouseholdChild;

                var currentHousehold =
                    ovcHouseholdCurrentSelectionState.currentOvcHousehold;

                return Consumer<ServiceEventDataState>(
                  builder: (context, serviceEventDataState, child) {
                    bool isLoading = serviceEventDataState.isLoading;
                    Map<String?, List<Events>> eventListByProgramStage =
                        serviceEventDataState.eventListByProgramStage;
                    List<Events> events = TrackedEntityInstanceUtil
                        .getAllEventListFromServiceDataStateByProgramStages(
                            eventListByProgramStage, programStageIds);
                    int serviceIndex = events.length + 1;
                    return isLoading
                        ? const CircularProcessLoader(
                            color: Colors.blueGrey,
                          )
                        : Consumer<LanguageTranslationState>(
                            builder:
                                (context, languageTranslationState, child) =>
                                    Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  child: events.isEmpty
                                      ? const Text(
                                          'There is no CLHIV ART Card services at a moment',
                                        )
                                      : Column(
                                          children: events.map((eventData) {
                                            serviceIndex--;
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 15.0,
                                              ),
                                              child: ClhivArtCardVisit(
                                                visitName:
                                                    " CLHIV ART Card service",
                                                eventData: eventData,
                                                visitCount: serviceIndex,
                                                editDisabled: eventData
                                                            .enrollmentOuAccessible !=
                                                        true ||
                                                    currentHousehold
                                                            ?.hasExitedProgram ==
                                                        true ||
                                                    currentOvc
                                                            ?.hasExitedProgram ==
                                                        true,
                                                onEdit: () =>
                                                    onEditClhivArtCardService(
                                                  context,
                                                  currentOvc!,
                                                  eventData,
                                                ),
                                                onView: () =>
                                                    onViewClhivArtCardService(
                                                  context,
                                                  eventData,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                ),
                                Visibility(
                                  visible: currentHousehold?.hasExitedProgram !=
                                          true &&
                                      currentOvc?.hasExitedProgram != true,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: EntryFormSaveButton(
                                      label: 'Add CLHIV ART Card Service',
                                      labelColor: Colors.white,
                                      fontSize: 14.0,
                                      buttonColor: const Color(0xFF4B9F46),
                                      onPressButton: () =>
                                          onAddClhivArtCardService(
                                              context, currentOvc!, null),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
