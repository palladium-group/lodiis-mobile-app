import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_home_list.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_case_plan.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/ovc_case_plan_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_util.dart';
import 'package:provider/provider.dart';

class CasePlanHomeContainer extends StatelessWidget {
  const CasePlanHomeContainer({
    Key? key,
    required this.enrollmentOuAccessible,
    required this.enrollmentDate,
    required this.isHouseholdCasePlan,
    required this.casePlanProgram,
    required this.casePlanProgramStage,
    required this.casePlanGapProgramStage,
    required this.casePlanServiceProgramStage,
    required this.casePlanMonitoringProgramStage,
    required this.isOnCasePlanPage,
    required this.isOnCasePlanServiceProvision,
    required this.isOnCasePlanServiceMonitoring,
    this.assessmentProgramStages = const [],
  }) : super(key: key);

  final String casePlanProgram;
  final String casePlanProgramStage;
  final String casePlanGapProgramStage;
  final String casePlanServiceProgramStage;
  final String casePlanMonitoringProgramStage;
  final String enrollmentDate;
  final List<String> assessmentProgramStages;
  final bool enrollmentOuAccessible;
  final bool isHouseholdCasePlan;
  final bool isOnCasePlanPage;
  final bool isOnCasePlanServiceProvision;
  final bool isOnCasePlanServiceMonitoring;

  bool _updateFormState({
    required BuildContext context,
    required List<Events> casePlanEvents,
    required List<String> casePlanDates,
    required bool isEditMode,
    required bool onAddCasePlan,
    required Map<String?, List<Events>> eventListByProgramStage,
  }) {
    bool shouldContinue = true;
    String eventDate = AppUtil.formattedDateTimeIntoString(DateTime.now());
    if (casePlanDates.contains(eventDate)) {
      if (onAddCasePlan) {
        AppUtil.showToastMessage(
          message:
              'There is exiting case plan that has already created on $eventDate',
        );
        shouldContinue = false;
      }
    }
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditMode);
    Map casePlanDataObject = {};

    if (casePlanEvents.isNotEmpty) {
      eventDate = casePlanEvents.first.eventDate ?? eventDate;
      List<Events> casePlanGapsEvents =
          eventListByProgramStage[casePlanGapProgramStage] ?? [];
      casePlanDataObject = OvcCasePlanUtil.getMappedCasePlanWithGapsByDomain(
        casePlanEvents: casePlanEvents,
        casePlanGapsEvents: casePlanGapsEvents,
      );
      if (!enrollmentOuAccessible) {
        Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
            OvcCasePlanConstant.casePlanLocatinSectionId,
            {"location": casePlanEvents.first.orgUnit ?? ''});
      }
    }
    for (FormSection formSection
        in OvcServicesCasePlan.getFormSections(firstDate: '')) {
      String formSectionId = formSection.id!;
      String casePlanToGapLinkage = AppUtil.getUid();
      Map map = casePlanDataObject.containsKey(formSectionId)
          ? casePlanDataObject[formSectionId]
          : {};
      map['gaps'] = map['gaps'] ?? [];
      map['eventDate'] = map['eventDate'] ?? eventDate;
      map[OvcCasePlanConstant.casePlanToGapLinkage] =
          map[OvcCasePlanConstant.casePlanToGapLinkage] ?? casePlanToGapLinkage;
      map[OvcCasePlanConstant.casePlanDomainType] = formSectionId;
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState(formSectionId, map);
    }
    return shouldContinue;
  }

  onManageCasePlan({
    required BuildContext context,
    required List<String> casePlanDates,
    bool isEditMode = true,
    bool onAddCasePlan = false,
    List<Events> casePlanEvents = const [],
    Map<String?, List<Events>> eventListByProgramStage = const {},
    String currentCasePlanDate = '',
  }) {
    bool shouldContinue = _updateFormState(
      context: context,
      casePlanEvents: casePlanEvents,
      casePlanDates: casePlanDates,
      isEditMode: isEditMode,
      onAddCasePlan: onAddCasePlan,
      eventListByProgramStage: eventListByProgramStage,
    );
    if (shouldContinue) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Consumer<LanguageTranslationState>(
            builder: (context, languageTranslationState, child) {
              String? currentLanguage =
                  languageTranslationState.currentLanguage;
              return OvcCasePlanForm(
                currentCasePlanDate: currentCasePlanDate,
                casePlanLabel: isHouseholdCasePlan
                    ? isOnCasePlanServiceProvision
                        ? currentLanguage == 'lesotho'
                            ? 'Litsebeletso tsa lelapa'
                            : 'Household Service Provision'
                        : isOnCasePlanServiceMonitoring
                            ? 'Household Service monitoring tool'
                            : 'Household Case Plan Form'
                    : isOnCasePlanServiceProvision
                        ? currentLanguage == 'lesotho'
                            ? 'Phano ea Litsebeletso'
                            : 'Service Provision'
                        : isOnCasePlanServiceMonitoring
                            ? currentLanguage == 'lesotho'
                                ? "Sesebelisoa sa Tlhokomelo ya Ts'ebeletso"
                                : 'Service monitoring tool'
                            : 'Child Case Plan Form',
                isOnCasePlanPage: isOnCasePlanPage,
                enrollmentOuAccessible: enrollmentOuAccessible,
                enrollmentDate: enrollmentDate,
                isOnCasePlanServiceMonitoring: isOnCasePlanServiceMonitoring,
                isOnCasePlanServiceProvision: isOnCasePlanServiceProvision,
                hasEditAccessToCasePlan: OvcCasePlanUtil.hasAccessToEdit(
                  casePlanEvents,
                ), //Contrpol editing gaps for case plams
                isHouseholdCasePlan: isHouseholdCasePlan,
                casePlanProgram: casePlanProgram,
                casePlanProgramStage: casePlanProgramStage,
                casePlanGapProgramStage: casePlanGapProgramStage,
                casePlanServiceProgramStage: casePlanServiceProgramStage,
                casePlanMonitoringProgramStage: casePlanMonitoringProgramStage,
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OvcHouseholdCurrentSelectionState>(
        builder: (context, ovcHouseholdCurrentSelectionState, child) {
      var hasBeneficiaryExitedProgram = ovcHouseholdCurrentSelectionState
                  .currentOvcHousehold?.hasExitedProgram ==
              true ||
          ovcHouseholdCurrentSelectionState
                  .currentOvcHouseholdChild?.hasExitedProgram ==
              true;

      return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
          String currentLanguage = languageTranslationState.currentLanguage;

          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 15.0,
            ),
            child: Consumer<ServiceEventDataState>(
              builder: (context, serviceEventDataState, child) {
                bool isLoading = serviceEventDataState.isLoading;
                bool isAssessmentConducted = TrackedEntityInstanceUtil
                        .getAllEventListFromServiceDataStateByProgramStages(
                            serviceEventDataState.eventListByProgramStage,
                            assessmentProgramStages)
                    .isNotEmpty;
                Map<String, List<Events>> casePlanByDates =
                    OvcCasePlanUtil.getCasePlanByDates(
                        eventListByProgramStage:
                            serviceEventDataState.eventListByProgramStage,
                        programStageIds: [casePlanProgramStage]);
                List<String> casePlanDates = casePlanByDates.keys.toList();
                return isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.blueGrey,
                      )
                    : Column(
                        children: [
                          Visibility(
                            visible: casePlanByDates.keys.toList().isEmpty,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 17.0,
                              ),
                              child: Center(
                                child: Text(currentLanguage == 'lesotho'
                                    ? 'Ha hona Case Plan ha joale'
                                    : 'There is no case plan at moment'),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: casePlanByDates.keys.toList().isNotEmpty,
                            child: CasePlanHomeList(
                              isOnCasePlanServiceProvision:
                                  isOnCasePlanServiceProvision,
                              isOnCasePlanServiceMonitoring:
                                  isOnCasePlanServiceMonitoring,
                              casePlanByDates: casePlanByDates,
                              hasBeneficiaryExitedProgram:
                                  hasBeneficiaryExitedProgram,
                              onViewCasePlan: (
                                List<Events> casePlanEvents,
                                String currentCasePlanDate,
                              ) =>
                                  onManageCasePlan(
                                      context: context,
                                      casePlanDates: casePlanDates,
                                      eventListByProgramStage:
                                          serviceEventDataState
                                              .eventListByProgramStage,
                                      isEditMode: false,
                                      currentCasePlanDate: currentCasePlanDate,
                                      casePlanEvents: casePlanEvents),
                              onEditCasePlan: (
                                List<Events> casePlanEvents,
                                String currentCasePlanDate,
                              ) =>
                                  onManageCasePlan(
                                context: context,
                                casePlanDates: casePlanDates,
                                eventListByProgramStage: serviceEventDataState
                                    .eventListByProgramStage,
                                currentCasePlanDate: currentCasePlanDate,
                                casePlanEvents: casePlanEvents,
                              ),
                            ),
                          ),
                          Consumer<CurrentUserState>(
                            builder: (context, currentUserState, child) {
                              bool isKbFacilitySocialWorker =
                                  currentUserState.isKbFacilitySocialWorker;
                              return Visibility(
                                visible: !isKbFacilitySocialWorker &&
                                    !hasBeneficiaryExitedProgram &&
                                    !(isOnCasePlanServiceMonitoring ||
                                        isOnCasePlanServiceProvision) &&
                                    isAssessmentConducted,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical:
                                        casePlanByDates.keys.toList().isEmpty
                                            ? 5.0
                                            : 10.0,
                                  ),
                                  child: EntryFormSaveButton(
                                    label: currentLanguage == 'lesotho'
                                        ? 'NEW MORALO OA NYEOE'
                                        : 'NEW CASE PLAN',
                                    labelColor: Colors.white,
                                    fontSize: 14.0,
                                    buttonColor: const Color(0xFF4B9F46),
                                    onPressButton: () => onManageCasePlan(
                                      context: context,
                                      casePlanDates: casePlanDates,
                                      onAddCasePlan: true,
                                      currentCasePlanDate:
                                          AppUtil.formattedDateTimeIntoString(
                                              DateTime.now()),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      );
              },
            ),
          );
        },
      );
    });
  }
}
