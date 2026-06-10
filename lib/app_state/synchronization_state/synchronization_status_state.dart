import 'package:flutter/foundation.dart';
import 'package:lncmis_mobile_app/core/offline_db/event_offline/event_offline_provider.dart';
import 'package:lncmis_mobile_app/core/offline_db/tracked_entity_instance_offline/tracked_entity_instance_offline_provider.dart';

class SynchronizationStatusState with ChangeNotifier {
  List<String> _unsyncedTeiReferences = [];
  List<String> get unsyncedTeiReferences => _unsyncedTeiReferences;

  resetSyncStatusReferences() async {
    List<String> teiWithUnsyncedEvents = await EventOfflineProvider()
        .getTrackedEntityInstanceReferenceByEventSyncStatus();
    List<String> teiWithUnsyncedAttributes =
        await TrackedEntityInstanceOfflineProvider()
            .getTrackedEntitiyInstanceReferencesBySyncStatus();
    _unsyncedTeiReferences =
        (teiWithUnsyncedEvents + teiWithUnsyncedAttributes).toSet().toList();
    notifyListeners();
  }
}
