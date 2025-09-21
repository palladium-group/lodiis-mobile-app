import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_home_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../models/ovc_household.dart';
import '../../../household_case_plan/constants/ovc_household_case_plan_constant.dart';

class OvcHouseholdMonitoring extends StatelessWidget {
  const OvcHouseholdMonitoring({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<ServiceEventDataState>(
          builder: (context, serviceEventDataState, _) {
            bool isLoading = serviceEventDataState.isLoading;
            return isLoading
                ? const CircularProgressIndicator()
                : Consumer<OvcHouseholdCurrentSelectionState>(
              builder: (context, ovcHouseholdCurrentSelectionState, child) {
                OvcHousehold? currentOvcHousehold =
                    ovcHouseholdCurrentSelectionState
                        .currentOvcHousehold;
                return  CasePlanHomeContainer(
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
                );
              },
            );
          }),
    );
  }
}
