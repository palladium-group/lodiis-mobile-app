import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/monitoring_option.dart';

// Household constants you already use
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_household_assessment_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_monitor/constants/ovc_household_monitor_constant.dart';

// Child assessment stage (no child monitoring stage in your codebase yet)
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_service_well_being_assessment_constant.dart';

class MonitoringPickerUtil {
  // HIV DEs you already use in your forms
  static const _hhHivStatusDE = 'vNeOE9abQBB';
  static const _childHivStatusDE = 'c5TMWtM4VVJ';

  static String? _normHiv(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    if (s.isEmpty) return null;
    const pos = {'positive', 'pos', 'positive (known)', '1', 'true', 'yes'};
    const neg = {'negative', 'neg', '0', 'false', 'no'};
    if (pos.contains(s)) return 'Positive';
    if (neg.contains(s)) return 'Negative';
    return (v ?? '').toString().trim();
  }

  /// Returns latest values map by preferring Monitoring stage (if exists),
  /// otherwise falling back to Assessment stage.
  static Map<String, String?> _latestForHousehold(BuildContext context) {
    final data = context.read<ServiceEventDataState>();
    final mon = data.latestValuesForStage(OvcHouseholdMonitorConstant.programStage);
    if (mon.isNotEmpty) return mon;
    return data.latestValuesForStage(OvcHouseholdAssessmentConstant.programStage);
  }

  /// For child we only have the Well-Being Assessment in your codebase.
  static Map<String, String?> _latestForChild(BuildContext context) {
    final data = context.read<ServiceEventDataState>();
    return data.latestValuesForStage(OvcServiceWellBeingAssessmentConstant.programStage);
  }

  /// Build the monitoring options list for the CURRENT selection.
  /// - If isHousehold=true: uses household (caregiver) values
  /// - If isHousehold=false: uses selected child's values
  ///
  /// Example rule (as requested):
  ///  - If HIV status (latest) is Positive -> add "Viral load monitoring"
  ///  - Always add a generic "Assessment monitoring" entry
  static List<MonitoringOption> optionsForCurrentSelection(
      BuildContext context, {
        required bool isHousehold,
      }) {
    final currentSel = context.read<OvcHouseholdCurrentSelectionState>();

    // If it's child and none selected, return empty.
    if (!isHousehold && currentSel.currentOvcHouseholdChild == null) {
      return const <MonitoringOption>[];
    }

    final latest = isHousehold
        ? _latestForHousehold(context)
        : _latestForChild(context);

    final hiv = _normHiv(
      latest[isHousehold ? _hhHivStatusDE : _childHivStatusDE],
    );

    final List<MonitoringOption> items = [];

    // Always offer "Assessment monitoring"
    items.add(
      const MonitoringOption(
        id: 'assessment_monitoring',
        title: 'Assessment monitoring',
        icon: Icons.fact_check_outlined,
        // routeName: 'yourAssessmentMonitoringRouteName',
        // extra: {'programStage': '<stageIdIfNeeded>'},
      ),
    );

    // If HIV Positive, add Viral Load monitoring
    if (hiv == 'Positive') {
      items.add(
        const MonitoringOption(
          id: 'viral_load_monitoring',
          title: 'Viral load monitoring',
          icon: Icons.show_chart_outlined,
          // routeName: 'yourViralLoadMonitoringRoute',
          // extra: {'programStage': '<stageIdIfNeeded>'},
        ),
      );
    }

    return items;
  }
}
