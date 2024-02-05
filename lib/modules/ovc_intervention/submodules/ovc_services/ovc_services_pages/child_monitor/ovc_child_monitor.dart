import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/ovc_monitoring_top_bar_selection.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_school_monitoring/ovc_school_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_service_monitoring/ovc_service_monitoring.dart';
import 'package:provider/provider.dart';

class OvcChildMonitor extends StatefulWidget {
  const OvcChildMonitor({Key? key}) : super(key: key);

  @override
  State<OvcChildMonitor> createState() => _OvcChildMonitorState();
}

class _OvcChildMonitorState extends State<OvcChildMonitor> {
  String? currentLanguage;
  final String label = 'Child Monitoring tool';
  final String translatedNamed = 'Sesebelisoa sa ho Lekola Bana';
  bool isSchoolMonitoringSelected = false;

  @override
  void initState() {
    super.initState();
  }

  void onSelectSchoolMonitoring(context) {
    isSchoolMonitoringSelected = true;
    setState(() {});
  }

  void onSelectServiceMonitoring(context) {
    isSchoolMonitoringSelected = false;
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
          const OvcChildInfoTopHeader(),
          Consumer<ServiceEventDataState>(
            builder: (context, serviceEventDataState, child) {
              bool isLoading = serviceEventDataState.isLoading;
              return isLoading
                  ? const CircularProcessLoader(
                      color: Colors.blueGrey,
                    )
                  : Column(
                      children: [
                        OvcMonitoringTopBarSelection(
                            isClicked: isSchoolMonitoringSelected,
                            onSelectSchoolMonitoring: () =>
                                onSelectSchoolMonitoring(context),
                            onSelectServiceMonitoring: () =>
                                onSelectServiceMonitoring(context)),
                        isSchoolMonitoringSelected
                            ? const OvcSchoolMonitoring()
                            : const OvcServiceMonitoring()
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
