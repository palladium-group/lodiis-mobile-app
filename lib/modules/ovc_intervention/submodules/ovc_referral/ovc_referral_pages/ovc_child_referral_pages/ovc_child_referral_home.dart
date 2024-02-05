import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/components/ovc_referral_top_bar_selection.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_child_referral_pages/constants/ovc_child_referral_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_child_referral_pages/ovc_child_referral.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_child_referral_pages/ovc_child_referral_clo.dart';
import 'package:provider/provider.dart';

class OvcChildReferralHome extends StatefulWidget {
  const OvcChildReferralHome({
    Key? key,
    required this.isIncomingReferral,
  }) : super(key: key);
  final bool isIncomingReferral;

  @override
  State<OvcChildReferralHome> createState() => _OvcChildReferralHomeState();
}

class _OvcChildReferralHomeState extends State<OvcChildReferralHome> {
  final String label = 'Child Referral';
  final List<String> programStageIds = [OvcChildReferralConstant.referralStage];
  bool isCloReferralSelected = false;

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
            return Consumer<ServiceEventDataState>(
              builder: (context, serviceFormState, child) {
                bool isLoading = serviceFormState.isLoading;
                return Column(
                  children: [
                    const OvcChildInfoTopHeader(),
                    Container(
                      child: isLoading
                          ? const CircularProcessLoader(
                              color: Colors.blueGrey,
                            )
                          : Column(
                              children: [
                                OvcReferralTopBarSelection(
                                  isClicked: isCloReferralSelected,
                                  onSelectCLOReferral: () => setState(() {
                                    isCloReferralSelected =
                                        !isCloReferralSelected;
                                  }),
                                  onSelectReferral: () => setState(() {
                                    isCloReferralSelected =
                                        !isCloReferralSelected;
                                  }),
                                ),
                                isCloReferralSelected
                                    ? const OvcChildCLOReferral()
                                    : OvcChildReferral(
                                        isIncomingReferral:
                                            widget.isIncomingReferral,
                                      )
                              ],
                            ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
