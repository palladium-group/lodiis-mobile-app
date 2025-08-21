import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';

class ProgramStageDataService {
  ProgramStageDataService._();

  /// Print what's cached for this TEI so you can see which stages are present.
  static void debugAvailableStages({
    required BuildContext context,
    required String teiId,
    String logPrefix = 'PSDS',
  }) {
    final state = Provider.of<ServiceEventDataState>(context, listen: false);

    Map byStage = {};
    Map byProgram = {};

    try {
      // Common shape 1
      // ignore: avoid_dynamic_calls
      byStage = (state as dynamic).eventListByProgramStage as Map? ?? {};
    } catch (_) {}

    try {
      // Common shape 2
      // ignore: avoid_dynamic_calls
      byProgram = (state as dynamic).eventListByProgram as Map? ?? {};
    } catch (_) {}

    final teiStage = (byStage[teiId] as Map?) ?? const {};
    final teiProg = (byProgram[teiId] as Map?) ?? const {};

    // Log summary
    final stageKeys = teiStage.keys.map((e) => e.toString()).toList();
    final progStageKeys = <String>[];
    teiProg.values.forEach((v) {
      if (v is Map) progStageKeys.addAll(v.keys.map((e) => e.toString()));
    });

    // ignore: avoid_print
    print('[$logPrefix] byStage keys for $teiId -> ${stageKeys.isEmpty ? 'none' : stageKeys}');
    // ignore: avoid_print
    print('[$logPrefix] byProgram->stage keys for $teiId -> ${progStageKeys.isEmpty ? 'none' : progStageKeys}');
  }

  /// Return events for a stage, newest first, from in-memory state.
  static List<Map<String, dynamic>> getStageEventsFromState({
    required BuildContext context,
    required String teiId,
    required String programStage,
  }) {
    final state = Provider.of<ServiceEventDataState>(context, listen: false);

    Map byStage = {};
    Map byProgram = {};

    try {
      // ignore: avoid_dynamic_calls
      byStage = (state as dynamic).eventListByProgramStage as Map? ?? {};
    } catch (_) {}

    try {
      // ignore: avoid_dynamic_calls
      byProgram = (state as dynamic).eventListByProgram as Map? ?? {};
    } catch (_) {}

    List events = const [];

    // Shape 1: by TEI → by programStage
    if (byStage is Map) {
      final Map teiMap = (byStage[teiId] as Map?) ?? const {};
      events = (teiMap[programStage] as List?) ?? const [];
    }

    // Shape 2: by TEI → by program → by programStage
    if ((events.isEmpty) && byProgram is Map) {
      final Map teiMap = (byProgram[teiId] as Map?) ?? const {};
      for (final progEntry in teiMap.values) {
        if (progEntry is Map && progEntry.containsKey(programStage)) {
          events = (progEntry[programStage] as List?) ?? const [];
          break;
        }
      }
    }

    final list = List<Map<String, dynamic>>.from(events.cast<Map>());

    // sort newest first; handle both raw eventDate or flattened data.eventDate
    list.sort((a, b) {
      String ad = (a['eventDate'] ?? a['data']?['eventDate'] ?? '').toString();
      String bd = (b['eventDate'] ?? b['data']?['eventDate'] ?? '').toString();
      // normalize ISO -> yyyy-MM-dd
      if (ad.contains('T')) ad = ad.split('T').first;
      if (bd.contains('T')) bd = bd.split('T').first;
      return bd.compareTo(ad);
    });
    return list;
  }

  /// Latest event Map for a stage from state.
  static Map<String, dynamic>? getLatestStageEventFromState({
    required BuildContext context,
    required String teiId,
    required String programStage,
  }) {
    final list = getStageEventsFromState(
      context: context,
      teiId: teiId,
      programStage: programStage,
    );
    return list.isEmpty ? null : list.first;
  }

  /// Flatten to DE→value map; adds eventDate, eventId, location.
  static Map<String, dynamic> eventToDataObject(Map event) {
    final out = <String, dynamic>{};

    // DHIS2 event shape
    final dvs = (event['dataValues'] as List?) ?? const [];
    for (final dv in dvs) {
      final de = dv['dataElement']?.toString();
      if (de != null && de.isNotEmpty) out[de] = dv['value'];
    }

    // flattened cache shape
    if (out.isEmpty && event['data'] is Map) {
      (event['data'] as Map).forEach((k, v) {
        if (k != null && k.toString().isNotEmpty) out[k.toString()] = v;
      });
    }

    String rawDate =
    (event['eventDate'] ?? event['data']?['eventDate'] ?? '').toString();
    if (rawDate.contains('T')) rawDate = rawDate.split('T').first;
    out['eventDate'] = rawDate;

    if (event['event'] != null) out['eventId'] = event['event'];
    if (event['orgUnit'] != null) out['location'] = event['orgUnit'];
    return out;
  }

  /// Latest event flattened, or null.
  static Map<String, dynamic>? latestDataObjectFromState({
    required BuildContext context,
    required String teiId,
    required String programStage,
  }) {
    final e = getLatestStageEventFromState(
      context: context,
      teiId: teiId,
      programStage: programStage,
    );
    return e == null ? null : eventToDataObject(e);
  }
}
