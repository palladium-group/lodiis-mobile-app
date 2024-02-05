import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/referrals_old/referral_outcome_card.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:provider/provider.dart';

class ReferralOutComeCardContainer extends StatelessWidget {
  const ReferralOutComeCardContainer({
    Key? key,
    required this.currentProgramStage,
    required this.currentEventId,
    required this.beneficiary,
    required this.referralFollowUpStage,
    required this.referralToFollowUpLinkage,
    required this.referralProgram,
    required this.isOvcIntervention,
    required this.isIncomingReferral,
    required this.enrollmentOuAccessible,
    this.isHouseholdReferral = false,
  }) : super(key: key);

  final String? currentProgramStage;
  final String? currentEventId;
  final TrackedEntityInstance? beneficiary;
  final String referralFollowUpStage;
  final String referralToFollowUpLinkage;
  final String referralProgram;
  final bool isOvcIntervention;
  final bool enrollmentOuAccessible;
  final bool isHouseholdReferral;
  final bool isIncomingReferral;

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceEventDataState>(
      builder: (context, serviceEventDataState, child) {
        bool isLoading = serviceEventDataState.isLoading;
        Map<String?, List<Events>> eventListByProgramStage =
            serviceEventDataState.eventListByProgramStage;
        List<Events> events = TrackedEntityInstanceUtil
            .getAllEventListFromServiceDataStateByProgramStages(
          eventListByProgramStage,
          [currentProgramStage],
        ).where((Events event) => event.event == currentEventId).toList();
        Events? eventData = events.isNotEmpty ? events[0] : null;
        return isLoading
            ? const CircularProcessLoader(
                color: Colors.blueGrey,
              )
            : eventData != null
                ? ReferralOutComeCard(
                    isIncomingReferral: isIncomingReferral,
                    isOvcIntervention: isOvcIntervention,
                    enrollmentOuAccessible: enrollmentOuAccessible,
                    beneficiary: beneficiary,
                    eventData: eventData,
                    referralProgram: referralProgram,
                    referralFollowUpStage: referralFollowUpStage,
                    referralToFollowUpLinkage: referralToFollowUpLinkage,
                  )
                : Container();
      },
    );
  }
}
