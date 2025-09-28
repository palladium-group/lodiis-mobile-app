
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_case_plan_service.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_monitoring_event.dart';

class CasePlanGapServiceMonitoringView extends StatefulWidget {
  const CasePlanGapServiceMonitoringView({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap, // MUST contain casePlanToGapLinkage
    required this.isHouseholdCasePlan,
    required this.hasEditAccess,
    required this.onViewCasePlanServiceMonitoring,
    required this.onEditCasePlanServiceMonitoring,
    this.title = 'Monitoring',
  }) : super(key: key);

  final String title;
  final String domainId;
  final Color formSectionColor;
  final Map<String, dynamic> casePlanGap;
  final bool isHouseholdCasePlan;
  final bool hasEditAccess;

  final void Function(Map dataObject) onViewCasePlanServiceMonitoring;
  final void Function(Map dataObject) onEditCasePlanServiceMonitoring;

  @override
  State<CasePlanGapServiceMonitoringView> createState() =>
      _CasePlanGapServiceMonitoringViewState();
}

class _CasePlanGapServiceMonitoringViewState
    extends State<CasePlanGapServiceMonitoringView> {
  bool _loading = true;

  /// Be lenient: items can be either `CasePlanGapServiceMonitoringEvent`
  /// or `Map<String, dynamic>` depending on the service version.
  List<dynamic> _items = const [];

  String get _cp =>
      (widget.casePlanGap[OvcCasePlanConstant.casePlanToGapLinkage] ?? '')
          .toString();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final sel =
      Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);
      final teiId = widget.isHouseholdCasePlan
          ? (sel.currentOvcHousehold?.teiData?.trackedEntityInstance ?? '')
          : (sel.currentOvcHouseholdChild?.teiData?.trackedEntityInstance ?? '');

      final stageId = widget.isHouseholdCasePlan
          ? OvcHouseholdCasePlanConstant.casePlanGapServiceMonitoringProgramStage
          : OvcChildCasePlanConstant.casePlanGapServiceMonitoringProgramStage;

      // May return List<CasePlanGapServiceMonitoringEvent> OR List<Map<String,dynamic>>
      final raw = await OvcCasePlanService()
          .getCasePlanServiceMonitoringEventsForCp(
        date: '', // ALL dates
        programStageId: stageId,
        teiId: teiId,
        casePlanToGapLinkage: _cp,
      );

      List<dynamic> list;
      if (raw is List) {
        list = raw;
      } else {
        list = const <dynamic>[];
      }

      if (kDebugMode) {
        debugPrint(
            '[MON List] domain="${widget.domainId}" cp="$_cp" count=${list.length}');
      }
      setState(() {
        _items = list;
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[MON List] error: $e');
      }
      setState(() => _loading = false);
    }
  }

  Map<String, dynamic> _asDataObject(dynamic item) {
    if (item is CasePlanGapServiceMonitoringEvent) {
      return item.toDataObject();
    }
    if (item is Map) {
      // Make sure map is typed
      return Map<String, dynamic>.from(item as Map);
    }
    return <String, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    if (_cp.isEmpty) {
      return const SizedBox.shrink();
    }
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: CircularProcessLoader(color: Colors.blueGrey),
      );
    }
    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No monitoring recorded for this Case Plan yet.',
          style: TextStyle(
            color: widget.formSectionColor.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // simple header
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: widget.formSectionColor,
            ),
          ),
        ),
        ..._items.map((e) {
          final data = _asDataObject(e);
          final eventDate = (data['eventDate'] ?? '').toString();
          final location = (data['location'] ?? '').toString();
          final subtitle = [
            if (eventDate.isNotEmpty) eventDate,
            if (location.isNotEmpty) location,
          ].join(' • ');

          return Card(
            elevation: 0.5,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              title: const Text(
                'Monitoring',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(subtitle),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'View',
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    onPressed: () =>
                        widget.onViewCasePlanServiceMonitoring(data),
                  ),
                  if (widget.hasEditAccess)
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () =>
                          widget.onEditCasePlanServiceMonitoring(data),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
