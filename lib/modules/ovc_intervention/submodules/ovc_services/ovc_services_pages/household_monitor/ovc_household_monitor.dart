import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_home_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:provider/provider.dart';

class OvcHouseholdMonitor extends StatelessWidget {
  const OvcHouseholdMonitor({Key? key}) : super(key: key);
  final String label = 'Household Monitor';
  final String translatedName = 'Tlhahlobo e hlophisitsoeng ea lelapa';

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
              translatedName: translatedName,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Consumer<OvcHouseholdCurrentSelectionState>(
          builder: (context, ovcHouseholdCurrentSelectionState, child) {
            OvcHousehold? currentOvcHousehold =
                ovcHouseholdCurrentSelectionState.currentOvcHousehold;
            return Column(
              children: [
                OvcHouseholdInfoTopHeader(
                  currentOvcHousehold: currentOvcHousehold,
                ),
                CasePlanHomeContainer(
                  casePlanProgram: OvcHouseholdCasePlanConstant.program,
                  casePlanProgramStage:
                      OvcHouseholdCasePlanConstant.casePlanProgramStage,
                  casePlanGapProgramStage:
                      OvcHouseholdCasePlanConstant.casePlanGapProgramStage,
                  casePlanServiceProgramStage: OvcHouseholdCasePlanConstant
                      .casePlanGapServiceProvisionProgramStage,
                  casePlanMonitoringProgramStage: OvcHouseholdCasePlanConstant
                      .casePlanGapServiceMonitoringProgramStage,
                  enrollmentDate: currentOvcHousehold!.createdDate!,
                  enrollmentOuAccessible:
                      currentOvcHousehold.enrollmentOuAccessible!,
                  isHouseholdCasePlan: true,
                  isOnCasePlanPage: false,
                  isOnCasePlanServiceMonitoring: true,
                  isOnCasePlanServiceProvision: false,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
