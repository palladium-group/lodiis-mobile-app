import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_school_monitoring/ovc_school_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_service_monitoring/ovc_service_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_monitor/pages/household_service_monitoring/household_service_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_monitor/pages/household_viral_load_monitoring/household_viral_load_mornitoring.dart';
import 'package:provider/provider.dart';

import '../../../../../../models/ovc_household.dart';
import '../../../../components/ovc_household_top_header.dart';
import '../../components/ovc_caregiver_monitoring_top_bar_selection.dart';

class OvcHouseholdMonitor extends StatefulWidget {
  const OvcHouseholdMonitor({Key? key}) : super(key: key);

  @override
  State<OvcHouseholdMonitor> createState() => _OvcHouseholdMonitorState();
}

class _OvcHouseholdMonitorState extends State<OvcHouseholdMonitor> {
  String? currentLanguage;
  final String label = 'Household Monitoring tool';
  final String translatedNamed = 'Sesebelisoa sa ho Lekola Mohlokomeli';
  bool isViralLoadMonitoringSelected = false;
  late final OvcHousehold? currentOvcHousehold;
  @override
  void initState() {
    super.initState();
  }

  void onSelectVLMonitoring(context) {
    isViralLoadMonitoringSelected = true;
    setState(() {});
  }

  void onSelectServiceMonitoring(context) {
    isViralLoadMonitoringSelected = false;
    setState(() {});
  }

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
              translatedName: translatedNamed,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Column(children: [
          Consumer<ServiceEventDataState>(
            builder: (context, serviceEventDataState, household) {
              bool isLoading = serviceEventDataState.isLoading;
              return isLoading
                  ? const CircularProcessLoader(
                color: Colors.blueGrey,
              )
                  : Column(
                children: [

                  OvcHouseholdMonitoringTopBarSelection(
                      isClicked: isViralLoadMonitoringSelected,
                      onSelectVLMonitoring: () =>
                          onSelectVLMonitoring(context),
                      onSelectServiceMonitoring: () =>
                          onSelectServiceMonitoring(context)),
                  isViralLoadMonitoringSelected
                      ? const OvcViralLoadMonitoring()
                      : const OvcHouseholdMonitoring()
                ],
              );
            },
          ),
        ]),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
