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
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_monitor/constants/ovc_household_monitor_constant.dart';
import 'package:provider/provider.dart';

import 'components/ovc_household_home_monitoring_list_container.dart';
import 'ovc_household_mornitoring_form.dart';
class OvcHouseholdMonitorTest extends StatefulWidget {
  const OvcHouseholdMonitorTest({Key? key}) : super(key: key);

  @override
  State<OvcHouseholdMonitorTest> createState() =>
      _OvcHouseholdMonitorState();
}

class _OvcHouseholdMonitorState extends State<OvcHouseholdMonitorTest> {
  final String label = 'Household Monitoring';
  final String translatedName = 'Hlahlobo ea lelapa';
  Map dataObject = {};
  /// Stages shown in the monitoring list
  final List<String> programStageIds = <String>[
    OvcHouseholdMonitorConstant.programStage,
  ];

  /// Map Assessment -> default Monitoring values (called when creating NEW event)
  void _applyAssessmentDefaultsToMonitoring(
      BuildContext context,
      Map<String, String?> assessmentVals,
      ) {
    // UIDs provided by you:
    const String hivStatusDE = 'vNeOE9abQBB'; // Assessment: HIV status
    const String hivAdherenceSupportDE = 'vNeOE9abQBB'; // Monitoring field: HIV Adherence Support

    final String raw = (assessmentVals['vNeOE9abQBB'] ?? '')
        .trim()
        .toLowerCase();
print('HIV Status: $raw');
    // Add option codes/labels your HIV status actually uses
    const Set<String> positiveValues = {
      'positive',
      'pos',
      'positive (known)',
      'true',
      '1',
    };

    {
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('vNeOE9abQBB', raw);
    }

    // 👉 Extend here with more Assessment → Monitoring mappings if needed.
  }

  /// Central place to prepare form state for NEW/EDIT/VIEW
  void updateFormState(
      BuildContext context,
      bool isEditableMode,
      Events? event, // existing monitoring event or null for NEW
      OvcHousehold? household,
      ) async {
    final formState = Provider.of<ServiceFormState>(context, listen: false);
    formState.resetFormState();
    formState.updateFormEditabilityState(isEditableMode: isEditableMode);

    if (event != null) {
      // Editing or viewing existing Monitoring event → hydrate fields from event
      formState.setFormFieldState('eventDate', event.eventDate);
      formState.setFormFieldState('eventId', event.event);
      formState.setFormFieldState('location', event.orgUnit);
      for (final Map dataValue in (event.dataValues as List)) {
        final value = (dataValue['value'] ?? '').toString();
        if (value.isNotEmpty) {
          formState.setFormFieldState(
            dataValue['dataElement'],
            value,
          );
        }
      }
    } else {
      // NEW Monitoring event → prefill from latest Assessment
      final Map<String, String?> assessmentVals = context
          .read<ServiceEventDataState>()
          .latestValuesForStage(
        OvcHouseholdAssessmentConstant.programStage,
      );

      _applyAssessmentDefaultsToMonitoring(context, assessmentVals);
    }

    // Auto-save and resume logic (kept as in your original flow)
    final String? beneficiaryId = household!.id;
    final String eventId = event?.event ?? '';
    final String formAutoSaveId =
        "${OvcRoutesConstant.houseHoldAssessmentFormPage}_${beneficiaryId}_$eventId";

    final formAutoSave = await FormAutoSaveOfflineService()
        .getSavedFormAutoData(formAutoSaveId);

    final bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave);

    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OvcHouseholdMornitoringForm(),
        ),
      );
    }
  }

  void onAddNewHouseholdMonitoring(
      BuildContext context,
      OvcHousehold? houseHold,
      ) {
    updateFormState(context, true, null, houseHold);
  }

  void onViewHouseholdMonitoring(
      BuildContext context,
      OvcHousehold? houseHold,
      Events event,
      ) {
    updateFormState(context, false, event, houseHold);
  }

  void onEditHouseholdMonitoring(
      BuildContext context,
      OvcHousehold? houseHold,
      Events event,
      ) {
    updateFormState(context, true, event, houseHold);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            final InterventionCard activeInterventionProgram =
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
            final OvcHousehold? currentOvcHousehold =
                ovcHouseholdCurrentSelectionState.currentOvcHousehold;

            return Column(
              children: [
                OvcHouseholdInfoTopHeader(
                  currentOvcHousehold: currentOvcHousehold,
                ),
                Consumer<LanguageTranslationState>(
                  builder: (context, languageTranslationState, child) =>
                      Consumer<ServiceEventDataState>(
                        builder: (context, serviceEventDataState, child) {
                          final bool isLoading =
                              serviceEventDataState.isLoading;

                          if (isLoading) {
                            return const CircularProcessLoader(
                              color: Colors.blueGrey,
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                  right: 13.0,
                                  left: 13.0,
                                ),
                                child: OvcHouseholdMonitoringListContainer(
                                  programStageIds: programStageIds,
                                  onEditHouseholdAssessment: (Events e) =>
                                      onEditHouseholdMonitoring(
                                        context,
                                        currentOvcHousehold,
                                        e,
                                      ),
                                  onViewHouseholdAssessment: (Events e) =>
                                      onViewHouseholdMonitoring(
                                        context,
                                        currentOvcHousehold,
                                        e,
                                      ),
                                ),
                              ),
                              Consumer<CurrentUserState>(
                                builder:
                                    (context, currentUserState, child) =>
                                    Visibility(
                                      visible: !currentUserState
                                          .isKbFacilitySocialWorker &&
                                          !isLoading &&
                                          currentOvcHousehold
                                              ?.hasExitedProgram !=
                                              true,
                                      child: EntryFormSaveButton(
                                        label:
                                        languageTranslationState.currentLanguage ==
                                            'lesotho'
                                            ? 'HLAHLOBO E NCHA'
                                            : 'NEW MONITORING',
                                        labelColor: Colors.white,
                                        fontSize: 10,
                                        buttonColor: const Color(0xFF4B9F46),
                                        onPressButton: () =>
                                            onAddNewHouseholdMonitoring(
                                              context,
                                              currentOvcHousehold,
                                            ),
                                      ),
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar:
      const InterventionBottomNavigationBarContainer(),
    );
  }
}
