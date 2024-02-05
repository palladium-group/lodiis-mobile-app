import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/core/components/referrals_old/referral_outcome_card_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_top_header.dart';
import 'package:kb_mobile_app/core/components/referrals_old/referral_detailed_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_house_referral_pages/constants/ovc_household_referral_constant.dart';
import 'package:provider/provider.dart';

class OvcHouseholdReferralManage extends StatefulWidget {
  const OvcHouseholdReferralManage({
    Key? key,
    required this.eventData,
    required this.referralIndex,
    required this.isIncomingReferral,
  }) : super(key: key);

  final Events eventData;
  final int referralIndex;
  final bool isIncomingReferral;

  @override
  State<OvcHouseholdReferralManage> createState() =>
      _OvcHouseholdReferralManageState();
}

class _OvcHouseholdReferralManageState
    extends State<OvcHouseholdReferralManage> {
  final String label = 'Manage Household Referral';

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
        body: Consumer<OvcHouseholdCurrentSelectionState>(
          builder: (context, ovcHouseholdCurrentSelectionState, child) {
            OvcHousehold currentOvcHousehold =
                ovcHouseholdCurrentSelectionState.currentOvcHousehold!;
            return Column(
              children: [
                OvcHouseholdInfoTopHeader(
                  currentOvcHousehold: currentOvcHousehold,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 13.0),
                  child: MaterialCard(
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReferralDetailedCard(
                          borderColor: const Color(0xFFEDF5EC),
                          titleColor: const Color(0xFF1B3518),
                          labelColor: const Color(0XFF92A791),
                          valueColor: const Color(0XFF536852),
                          referralIndex: widget.referralIndex,
                          isIncomingReferral: widget.isIncomingReferral,
                          isEditable: true,
                          isHouseholdReferral: true,
                          eventData: widget.eventData,
                        ),
                        ReferralOutComeCardContainer(
                          isIncomingReferral: widget.isIncomingReferral,
                          isOvcIntervention: true,
                          enrollmentOuAccessible:
                              currentOvcHousehold.enrollmentOuAccessible ==
                                  true,
                          currentEventId: widget.eventData.event,
                          currentProgramStage: widget.eventData.programStage,
                          beneficiary: currentOvcHousehold.teiData,
                          referralProgram: OvcHouseholdReferralConstant.program,
                          referralFollowUpStage: OvcHouseholdReferralConstant
                              .referralFollowUpStage,
                          referralToFollowUpLinkage:
                              OvcHouseholdReferralConstant
                                  .referralToFollowUpLinkage,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
