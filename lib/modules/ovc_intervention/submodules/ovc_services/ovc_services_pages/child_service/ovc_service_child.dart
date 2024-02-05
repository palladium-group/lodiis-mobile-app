import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_home_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:provider/provider.dart';

class OvcServiceSubPageChildView extends StatefulWidget {
  const OvcServiceSubPageChildView({Key? key}) : super(key: key);

  @override
  State<OvcServiceSubPageChildView> createState() =>
      _OvcServiceSubPageChildViewState();
}

class _OvcServiceSubPageChildViewState
    extends State<OvcServiceSubPageChildView> {
  final String label = 'Service Provision';
  final String translatedLabel = 'Phano ea Litsebeletso';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return Consumer<LanguageTranslationState>(
                builder: (context, languageTranslationState, child) {
              String? currentLanguage =
                  languageTranslationState.currentLanguage;
              return SubPageAppBar(
                label: currentLanguage != 'lesotho' ? label : translatedLabel,
                activeInterventionProgram: activeInterventionProgram,
              );
            });
          },
        ),
      ),
      body: SubPageBody(
        body: Column(
          children: [
            const OvcChildInfoTopHeader(),
            Consumer<OvcHouseholdCurrentSelectionState>(
              builder: (context, ovcHouseholdCurrentSelectionState, child) {
                OvcHouseholdChild? currentOvcHouseholdChild =
                    ovcHouseholdCurrentSelectionState.currentOvcHouseholdChild;
                return CasePlanHomeContainer(
                  casePlanProgram: OvcChildCasePlanConstant.program,
                  casePlanProgramStage:
                      OvcChildCasePlanConstant.casePlanProgramStage,
                  casePlanGapProgramStage:
                      OvcChildCasePlanConstant.casePlanGapProgramStage,
                  casePlanServiceProgramStage: OvcChildCasePlanConstant
                      .casePlanGapServiceProvisionProgramStage,
                  casePlanMonitoringProgramStage: OvcChildCasePlanConstant
                      .casePlanGapServiceMonitoringProgramStage,
                  enrollmentDate: currentOvcHouseholdChild!.createdDate!,
                  enrollmentOuAccessible:
                      currentOvcHouseholdChild.enrollmentOuAccessible!,
                  isHouseholdCasePlan: false,
                  isOnCasePlanPage: false,
                  isOnCasePlanServiceMonitoring: false,
                  isOnCasePlanServiceProvision: true,
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
