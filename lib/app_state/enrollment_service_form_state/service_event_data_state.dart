import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/app_state/synchronization_state/synchronization_status_state.dart';
import 'package:lncmis_mobile_app/core/services/organisation_unit_service.dart';
import 'package:lncmis_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:lncmis_mobile_app/models/events.dart';
import 'package:provider/provider.dart';



extension EventValueHelpers on Events {
  Map<String, String?> valueMap() {
    final values = <String, String?>{};
    final list = (dataValues as List?) ?? const [];
    for (final dv in list) {
      if (dv is Map && dv['dataElement'] != null) {
        values[dv['dataElement'] as String] = dv['value']?.toString();
      }
    }
    return values;
  }
}

class ServiceEventDataState with ChangeNotifier {
  final BuildContext? context;
  // initial state
  bool _isLoading = false;
  final Map _eventListByProgramStage = <String?, List<Events>>{};

  ServiceEventDataState(this.context);

  // selector
  bool get isLoading => _isLoading;

  Map<String?, List<Events>> get eventListByProgramStage =>
      _eventListByProgramStage as Map<String?, List<Events>>? ??
      <String, List<Events>>{};

  // reducer

  void resetServiceEventDataState(
    String? trackedEntityInstance,
  ) async {
    _isLoading = true;
    _eventListByProgramStage.clear();
    notifyListeners();
    List<String> accessibleOrgUnits = await OrganisationUnitService()
        .getOrganisationUnitAccessedByCurrentUser();
    List<Events> eventList =
        await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(
      trackedEntityInstance,
      accessibleOrgUnits: accessibleOrgUnits,
    );
    List<String?> programStages =
        eventList.map((Events event) => event.programStage).toList();
    for (String? programStage in programStages) {
      _eventListByProgramStage[programStage] = eventList
          .where((Events event) => event.programStage == programStage)
          .toList();
    }
    Provider.of<SynchronizationStatusState>(context!, listen: false)
        .resetSyncStatusReferences();
    Timer(const Duration(seconds: 1), () {
      _isLoading = false;
      notifyListeners();
    });
  }


  List<Events> eventsForStage(String? programStage) {
    final list = _eventListByProgramStage[programStage];
    return (list is List<Events>) ? list : const [];
  }

  Events? latestEventForStage(String? programStage) {
    final list = eventsForStage(programStage);
    return list
        .sorted((a, b) => (b.eventDate ?? '').compareTo(a.eventDate ?? ''))
        .firstOrNull;
  }

  Map<String, String?> latestValuesForStage(String? programStage) {
    return latestEventForStage(programStage)?.valueMap() ?? const {};
  }

}
