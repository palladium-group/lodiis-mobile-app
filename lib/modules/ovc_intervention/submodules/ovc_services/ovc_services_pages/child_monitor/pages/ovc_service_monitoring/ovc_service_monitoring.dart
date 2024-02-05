import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_home_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:provider/provider.dart';

class OvcServiceMonitoring extends StatelessWidget {
  const OvcServiceMonitoring({Key? key}) : super(key: key);

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
                  OvcHouseholdChild? currentOvcHouseholdChild =
                      ovcHouseholdCurrentSelectionState
                          .currentOvcHouseholdChild;
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
                    isOnCasePlanServiceMonitoring: true,
                    isOnCasePlanServiceProvision: false,
                  );
                },
              );
      }),
    );
  }
}
