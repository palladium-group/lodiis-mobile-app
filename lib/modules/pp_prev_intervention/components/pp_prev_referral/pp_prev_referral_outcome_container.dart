import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/pp_prev_beneficiary.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/components/pp_prev_referral/pp_prev_referral_outcome.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/models/pp_prev_referral_event.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/models/pp_prev_referral_outcome_event.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/pages/pp_prev_referral/pp_prev_intervention_referral_outcome_form.dart';
import 'package:provider/provider.dart';

class PpPrevReferralOutcomeContainer extends StatelessWidget {
  const PpPrevReferralOutcomeContainer({
    Key? key,
    required this.enrollmentOuAccessible,
    required this.beneficiary,
    required this.referralEvent,
    required this.labelColor,
    required this.valueColor,
    required this.referralProgram,
    required this.referralOutcomeProgramStage,
    required this.referralOutcomeLinkage,
    required this.canAddViewOutcome,
    required this.canEditOutcome,
  }) : super(key: key);

  final String referralOutcomeProgramStage;
  final String referralOutcomeLinkage;
  final PpPrevBeneficiary beneficiary;
  final bool enrollmentOuAccessible;
  final bool canAddViewOutcome;
  final bool canEditOutcome;
  final PpPrevReferralEvent referralEvent;
  final String referralProgram;
  final Color valueColor;
  final Color labelColor;

  PpPrevReferralOutcomeEvent _getReferralOutcomeEvent({
    required Map<String?, List<Events>> eventListByProgramStage,
  }) {
    List<Events> events = TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(
      eventListByProgramStage,
      [referralOutcomeProgramStage],
      shouldSortByDate: true,
    ).where((Events eventData) {
      PpPrevReferralOutcomeEvent referralOutComeEvent =
          PpPrevReferralOutcomeEvent().fromEventModel(
        eventData: eventData,
        referralToOutcomeReference: referralOutcomeLinkage,
      );
      return referralOutComeEvent.referralReference == referralEvent.id;
    }).toList();
    PpPrevReferralOutcomeEvent referralOutComeEvent =
        PpPrevReferralOutcomeEvent().fromEventModel(
      eventData: events.isEmpty ? Events(dataValues: []) : events.first,
      referralToOutcomeReference: referralOutcomeLinkage,
    );
    return referralOutComeEvent;
  }

  void updateFormState(
    BuildContext context,
    PpPrevReferralOutcomeEvent? referralOutcomeEvent,
  ) {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: true);
    String location = enrollmentOuAccessible ? beneficiary.orgUnit ?? '' : '';
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(referralOutcomeLinkage, referralEvent.id);
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('location', location);
    if (referralOutcomeEvent != null) {
      Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
          'eventDate', referralOutcomeEvent.eventData?.eventDate);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventId', referralOutcomeEvent.eventData?.event);
      Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
          'location', referralOutcomeEvent.eventData?.orgUnit);
      for (Map dataValue in referralOutcomeEvent.eventData?.dataValues) {
        if (dataValue['value'] != '') {
          Provider.of<ServiceFormState>(context, listen: false)
              .setFormFieldState(dataValue['dataElement'], dataValue['value']);
        }
      }
    }
  }

  void onAddOrEditReferralOutcome(
    BuildContext context,
    PpPrevReferralOutcomeEvent? referralOutcomeEvent,
    PpPrevBeneficiary beneficiary,
  ) {
    double modalRatio = 0.75;
    updateFormState(context, referralOutcomeEvent);
    Widget modal = PpPrevInterventionReferralOutcomeForm(
      referralOutcomeLinkage: referralOutcomeLinkage,
    );

    AppUtil.showActionSheetModal(
      context: context,
      containerBody: modal,
      initialHeightRatio: modalRatio,
      maxHeightRatio: modalRatio,
    );
  }

  Widget _getReferralButton({
    required Color color,
    required VoidCallback onTap,
  }) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) =>  Container(
        margin: const EdgeInsets.symmetric(),
        child: Column(
          children: [
            LineSeparator(
              color: color.withOpacity(
                0.1,
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.03),
                ),
                width: double.infinity,
                child: TextButton(
                  onPressed: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: Text(
                     languageState.currentLanguage == 'lesotho'
                          ? 'QETELA SEPHETHO'
                          : 'COMPLETE OUTCOME',
                      style: const TextStyle().copyWith(
                        color: color,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceEventDataState>(
        builder: (context, serviceEventDataState, child) {
      PpPrevReferralOutcomeEvent referralOutcomeEvent =
          _getReferralOutcomeEvent(
        eventListByProgramStage: serviceEventDataState.eventListByProgramStage,
      );

      bool hasReferralOutcome = referralOutcomeEvent.id != null;

      return serviceEventDataState.isLoading
          ? Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: const CircularProcessLoader(
                color: Colors.blueGrey,
              ),
            )
          : !hasReferralOutcome && canAddViewOutcome
              ? Visibility(
                  visible: canEditOutcome,
                  child: _getReferralButton(
                    color: labelColor,
                    onTap: () => onAddOrEditReferralOutcome(
                      context,
                      null,
                      beneficiary,
                    ),
                  ),
                )
              : Visibility(
                  visible: hasReferralOutcome,
                  child: PpPrevReferralOutcome(
                    canEdit: canEditOutcome,
                    labelColor: labelColor,
                    referralOutcomeEvent: referralOutcomeEvent,
                    referralProgram: referralProgram,
                    valueColor: valueColor,
                    onEditReferralOutcome: () => onAddOrEditReferralOutcome(
                      context,
                      referralOutcomeEvent,
                      beneficiary,
                    ),
                  ),
                );
    });
  }
}
