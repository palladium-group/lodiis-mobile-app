
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_monitor/pages/household_service_monitoring/household_service_monitoring.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_service_monitoring/ovc_service_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_monitor/pages/household_viral_load_monitoring/household_viral_load_mornitoring.dart';

import '../../../../../../app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import '../../../../../../models/ovc_household.dart';
import '../../components/ovc_caregiver_monitoring_top_bar_selection.dart';


class OvcHouseholdMonitor extends StatefulWidget {
  const OvcHouseholdMonitor({Key? key}) : super(key: key);

  @override
  State<OvcHouseholdMonitor> createState() => _OvcHouseholdMonitorState();
}

class _OvcHouseholdMonitorState extends State<OvcHouseholdMonitor> {
  final String label = 'Household Monitoring tool';
  final String translatedNamed = 'Sesebelisoa sa ho Lekola Mohlokomeli';
  bool isViralLoadMonitoringSelected = false;

  void onSelectVLMonitoring(BuildContext _) {
    setState(() => isViralLoadMonitoringSelected = true);
  }

  void onSelectServiceMonitoring(BuildContext _) {
    setState(() => isViralLoadMonitoringSelected = false);
  }

  bool _computeVLEligible(OvcHousehold? hh) {
    if (hh == null) return false;
    final hiv = (hh.hivStatus ?? '').trim().toLowerCase(); // expects e.g. "Positive"
    final onArt = hh.artStatus == true;
    final isPositive = (hiv == 'positive');
    return isPositive && onArt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (_, interventionCardState, __) {
            final InterventionCard active = interventionCardState.currentInterventionProgram;
            return SubPageAppBar(
              label: label,
              translatedName: translatedNamed,
              activeInterventionProgram: active,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Consumer2<OvcHouseholdCurrentSelectionState, ServiceEventDataState>(
          builder: (_, sel, serviceEventDataState, __) {
            final OvcHousehold? currentOvcHousehold = sel.currentOvcHousehold;
            final bool isLoading = serviceEventDataState.isLoading;

            // Compute VL eligibility once
            final bool isVLEligible = _computeVLEligible(currentOvcHousehold);

            // If user somehow is on VL tab but now ineligible (status changed), bounce back to Assessment
            if (!isVLEligible && isViralLoadMonitoringSelected) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => isViralLoadMonitoringSelected = false);
              });
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (currentOvcHousehold != null)
                  OvcHouseholdInfoTopHeader(currentOvcHousehold: currentOvcHousehold),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProcessLoader(color: Colors.blueGrey)),
                  )
                else ...[
                  OvcHouseholdMonitoringTopBarSelection(
                    isClicked: isViralLoadMonitoringSelected,
                    onSelectVLMonitoring: () => onSelectVLMonitoring(context),
                    onSelectServiceMonitoring: () => onSelectServiceMonitoring(context),
                    isVLEligible: isVLEligible, // 👈 pass eligibility
                  ),
                  if (isViralLoadMonitoringSelected)
                    const OvcViralLoadMonitoring()
                  else
                    const OvcHouseholdMonitoring(),
                ],
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}


