
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';

import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';

import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/ovc_monitoring_top_bar_selection.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_service_monitoring/ovc_service_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_viral_load_monitoring/ovc_vial_load_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/pages/ovc_hei_monitoring/ovc_hei_monitoring.dart'; // <-- make sure this path matches your project

class OvcChildMonitor extends StatefulWidget {
  const OvcChildMonitor({Key? key}) : super(key: key);

  @override
  State<OvcChildMonitor> createState() => _OvcChildMonitorState();
}

class _OvcChildMonitorState extends State<OvcChildMonitor> {
  final String label = 'Child Monitoring tool';
  final String translatedNamed = 'Sesebelisoa sa ho Lekola Bana';

  ChildMonTab _selected = ChildMonTab.assessment;

  bool _childVLEligible(OvcHouseholdChild? child) {
    if (child == null) return false;
    final hiv = (child.hivStatus ?? '').trim().toLowerCase();
    final onArt = child.artStatus == true;
    return hiv == 'positive' && onArt;
  }

  bool _childHEIEligible(OvcHouseholdChild? child) {
    // Adjust to your real flag(s). Common patterns:
    //  - child.isHei == true
    //  - child.heiStatus == 'HEI'
    //  - child.ageInMonths < 24 && child.hivExposed == true
    return child?.isHei == true; // <-- change if your model differs
  }

  void _toast(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));

  void _selectAssessment() => setState(() => _selected = ChildMonTab.assessment);

  void _selectViralLoad(BuildContext context, bool eligible) {
    if (!eligible) {
      final isSesotho = context.read<LanguageTranslationState>().isSesothoLanguage;
      _toast(
        context,
        isSesotho
            ? 'Viral Load e fumaneha feela ho bana ba Positive le ba ART'
            : 'Viral Load is only available for children who are HIV-positive and on ART',
      );
      return;
    }
    setState(() => _selected = ChildMonTab.viralLoad);
  }

  void _selectHei(BuildContext context, bool eligible) {
    if (!eligible) {
      final isSesotho = context.read<LanguageTranslationState>().isSesothoLanguage;
      _toast(
        context,
        isSesotho
            ? 'HEI e fumaneha feela ho bana ba HEI'
            : 'HEI Card is only available for HEI',
      );
      return;
    }
    setState(() => _selected = ChildMonTab.hei);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            final InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return SubPageAppBar(
              label: label,
              translatedName: translatedNamed,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
      body: SubPageBody(
        body: Column(
          children: [
            const OvcChildInfoTopHeader(),
            Consumer<ServiceEventDataState>(
              builder: (context, serviceEventDataState, child) {
                final isLoading = serviceEventDataState.isLoading;
                final currentChild = context
                    .watch<OvcHouseholdCurrentSelectionState>()
                    .currentOvcHouseholdChild;

                final vlEligible = _childVLEligible(currentChild);
                final heiEligible = _childHEIEligible(currentChild);

                // If tab is now invalid (e.g., data changed), snap back to Assessment
                if (!vlEligible && _selected == ChildMonTab.viralLoad) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _selected = ChildMonTab.assessment);
                  });
                }
                if (!heiEligible && _selected == ChildMonTab.hei) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _selected = ChildMonTab.assessment);
                  });
                }

                if (isLoading) {
                  return const CircularProcessLoader(color: Colors.blueGrey);
                }

                return Column(
                  children: [
                    OvcMonitoringTopBarSelection(
                      selected: _selected,
                      isVLEligible: vlEligible,
                      isHEIEligible: heiEligible,
                      onSelectAssessment: _selectAssessment,
                      onSelectViralLoad: () => _selectViralLoad(context, vlEligible),
                      onSelectHei: () => _selectHei(context, heiEligible),
                    ),
                    if (_selected == ChildMonTab.assessment) const OvcServiceMonitoring()
                    else if (_selected == ChildMonTab.viralLoad) const OvcViralLoadMonitoring()
                    else const OvcHeiMonitoring(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
