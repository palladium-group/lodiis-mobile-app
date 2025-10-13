
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';

import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';

import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/components/ovc_child_assessment_list_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/constants/ovc_asessment_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/pages/ovc_service_child_wellbeing_assessment_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/pages/ovc_service_well_being_assessment_form.dart';

import '../../../../../../app_state/enrollment_service_form_state/service_form_state.dart';
import '../../../../../../core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';

class OvcChildAssessment extends StatelessWidget {
  const OvcChildAssessment({Key? key}) : super(key: key);

  final String label = 'Child Assessment';

  // ---------- Helpers ----------

  List<String> _childAssessmentStageIds() {
    final map = OvcAssessmentConstant.getOvcAssessmentProgramStageMap();
    return map.keys.map((e) => '$e').toList();
  }

  List<Events> _childAssessmentEvents(BuildContext context) {
    final state = Provider.of<ServiceEventDataState>(context, listen: false);
    final byStage = state.eventListByProgramStage;
    final stageIds = _childAssessmentStageIds();
    return TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(byStage, stageIds);
  }

  /// Most-recent assessment event for this child (by eventDate)
  Events? _latestAssessmentForChild({
    required BuildContext context,
    required String teiId,
  }) {
    final events = _childAssessmentEvents(context)
        .where((e) => (e.trackedEntityInstance ?? '') == teiId)
        .toList();
    if (events.isEmpty) return null;

    events.sort((a, b) {
      final ad = AppUtil.getDateIntoDateTimeFormat(a.eventDate!);
      final bd = AppUtil.getDateIntoDateTimeFormat(b.eventDate!);
      return bd.compareTo(ad); // newest first
    });
    return events.first;
  }

  /// Next eligible date = latest event date + 12 months
  DateTime _nextEligibleDate(DateTime last) {
    // Safer month math than 365 days, handles leap years
    final y = last.year, m = last.month, d = last.day;
    final nextY = y + ((m + 12 - 1) ~/ 12);
    final nextM = ((m + 12 - 1) % 12) + 1;
    // Clamp day to end of month if needed
    final endOfNextMonth = DateTime(nextY, nextM + 1, 0).day;
    final safeDay = d.clamp(1, endOfNextMonth);
    return DateTime(nextY, nextM, safeDay);
  }

  String _fmt(DateTime dt) => AppUtil.formattedDateTimeIntoString(dt);

  Future<void> _openAssessmentFormForEvent(
      BuildContext context,
      Events event,
      OvcHouseholdChild child, {
        required bool isEditable,
      }) async {
    final form = Provider.of<ServiceFormState>(context, listen: false);
    form.resetFormState();
    form.updateFormEditabilityState(isEditableMode: isEditable);
    form.setFormFieldState('eventDate', event.eventDate);
    form.setFormFieldState('eventId', event.event);
    form.setFormFieldState('location', event.orgUnit);
    form.setFormFieldState('age', child.age);
    for (final dv in event.dataValues) {
      if (dv['value'] != '') {
        form.setFormFieldState(dv['dataElement'], dv['value']);
      }
    }

    final age = int.tryParse('${child.age}') ?? 0;
    if (age > 8) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OvcServiceWellBeingAssessmentForm()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OvcServiceChildWellBeingAssessmentForm()),
      );
    }
  }

  Future<void> _startNewAssessment(BuildContext context, OvcHouseholdChild child) async {
    final form = Provider.of<ServiceFormState>(context, listen: false);
    form.resetFormState();
    form.updateFormEditabilityState(isEditableMode: true);
    form.setFormFieldState('age', child.age);

    final age = int.tryParse('${child.age}') ?? 0;
    if (age > 8) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OvcServiceWellBeingAssessmentForm()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OvcServiceChildWellBeingAssessmentForm()),
      );
    }
  }

  void _onViewAssessment(
      BuildContext context,
      Events eventData,
      OvcHouseholdChild child,
      ) {
    _openAssessmentFormForEvent(context, eventData, child, isEditable: false);
  }

  void _onEditAssessment(
      BuildContext context,
      Events eventData,
      OvcHouseholdChild child,
      ) {
    _openAssessmentFormForEvent(context, eventData, child, isEditable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, lang, _) {
        final currentLanguage = lang.currentLanguage;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(65.0),
            child: Consumer<InterventionCardState>(
              builder: (context, interventionCardState, __) {
                final InterventionCard activeInterventionProgram =
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
              builder: (context, sel, __) {
                final OvcHouseholdChild? child = sel.currentOvcHouseholdChild;
                final OvcHousehold? household = sel.currentOvcHousehold;

                return Column(
                  children: [
                    const OvcChildInfoTopHeader(),
                    Consumer<ServiceEventDataState>(
                      builder: (context, serviceEventDataState, __) {
                        final isLoading = serviceEventDataState.isLoading;
                        final byStage = serviceEventDataState.eventListByProgramStage;
                        final stageMap =
                        OvcAssessmentConstant.getOvcAssessmentProgramStageMap();
                        final stageIds = _childAssessmentStageIds();
                        final events = TrackedEntityInstanceUtil
                            .getAllEventListFromServiceDataStateByProgramStages(
                            byStage, stageIds);

                        if (isLoading) {
                          return const CircularProcessLoader(color: Colors.blueGrey);
                        }

                        return Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: events.isEmpty
                              ? const Center(child: Text('There is no assessment at the moment'))
                              : Column(
                            children: events.map((event) {
                              return OvcChildAssessmentListCard(
                                eventData: event,
                                programStageMap: stageMap,
                                canEdit: (child?.hasExitedProgram != true &&
                                    household?.hasExitedProgram != true),
                                onEditAssessment: () => _onEditAssessment(context, event, child!),
                                onViewAssessment: () => _onViewAssessment(context, event, child!),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    Consumer<CurrentUserState>(
                      builder: (context, user, __) {
                        final isKbFacilitySocialWorker = user.isKbFacilitySocialWorker;

                        final teiId = child?.teiData?.trackedEntityInstance ?? '';
                        final latest = teiId.isEmpty
                            ? null
                            : _latestAssessmentForChild(context: context, teiId: teiId);

                        DateTime? lastDate;
                        DateTime? nextEligible;
                        bool locked = false;
                        if (latest != null) {
                          lastDate = AppUtil.getDateIntoDateTimeFormat(latest.eventDate!);
                          if (lastDate != null) {
                            nextEligible = _nextEligibleDate(lastDate);
                            locked = DateTime.now().isBefore(nextEligible);
                          }
                        }

                        final canShowAdd =
                            !isKbFacilitySocialWorker &&
                                child?.hasExitedProgram != true &&
                                household?.hasExitedProgram != true;

                        final buttonLabel = locked
                            ? (currentLanguage == 'lesotho'
                            ? 'E fumaneha ka: ${_fmt(nextEligible!)}'
                            : 'NEXT ELIGIBLE: ${_fmt(nextEligible!)}')
                            : (currentLanguage == 'lesotho'
                            ? 'Hlahlobo e ncha'
                            : 'NEW ASSESSMENT');

                        return Visibility(
                          visible: canShowAdd,
                          child: Column(
                            children: [
                              if (locked && lastDate != null && nextEligible != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    currentLanguage == 'lesotho'
                                        ? 'Hlahlobo ea morao-rao: ${_fmt(lastDate)} • E hlophisetsoe hape ka mora likhoeli tse 12: ${_fmt(nextEligible)}'
                                        : 'Last assessment: ${_fmt(lastDate)} • Next allowed after 12 months: ${_fmt(nextEligible)}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              EntryFormSaveButton(
                                label: buttonLabel,
                                labelColor: Colors.white,
                                fontSize: 14,
                                buttonColor: locked ? Colors.grey : const Color(0xFF4B9F46),
                                onPressButton: locked
                                    ? () async {
                                  // Offer to open the latest one while locked
                                  final open = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Assessment limit'),
                                      content: Text(
                                        currentLanguage == 'lesotho'
                                            ? 'Ho sebetsoa hlahlobo e ncha ho tla khonahala ho tloha ka ${_fmt(nextEligible!)}.\nNa u ka rata ho bula hlahlobo ea morao-rao?'
                                            : 'A new assessment can be created starting ${_fmt(nextEligible!)}.\nWould you like to open the latest assessment?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text('Cancel',style: TextStyle(color: Colors.green)),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text('Open',style: TextStyle(color: Colors.green)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (open == true && latest != null) {
                                    await _openAssessmentFormForEvent(
                                      context,
                                      latest,
                                      child!,
                                      isEditable: true,
                                    );
                                  }
                                }
                                    : () => _startNewAssessment(context, child!),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
