import 'package:kb_mobile_app/models/case_plan_gap_event.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_case_plan_service.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

/// Utility to prepare a gap payload so we UPDATE an existing gap when it
/// already exists for the same case-plan linkage + eventDate, and CREATE
/// otherwise. We compare/merge using only map fields (no model properties).
class CasePlanGapDedupeUtil {
  /// Returns a payload map to save:
  /// - If an existing gap for the same [linkage] and [date] exists:
  ///    - payload includes existing eventId so `savingTrackedEntityInstanceEventData`
  ///      will update it.
  ///    - drops fields that didn't change (no-op).
  ///    - returns null if nothing changed.
  /// - If no existing gap found: returns a full create payload.
  static Future<Map<String, dynamic>?> prepareGapUpsertPayload({
    required String teiId,
    required String programStageId,
    required String date,    // 'YYYY-MM-DD'
    required String linkage, // value for OvcCasePlanConstant.casePlanToGapLinkage
    required Map<String, dynamic> newGap,
  }) async {
    // 1) Fetch gaps on that date for that linkage
    final sameDayGaps = await OvcCasePlanService().getCasePlanGapEvents(
      date: date,
      programStageId: programStageId,
      teiId: teiId,
      casePlanToGaps: [linkage],
    );

    Map<String, dynamic> existingMap = const {};
    for (final g in sameDayGaps) {
      final m = g.toDataObject();
      final gDate = (m['eventDate'] ?? '').toString();
      final gLink = (m[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
      if (gDate == date && gLink == linkage) {
        existingMap = m;
        break;
      }
    }

    // 2) Build a normalized payload from the new gap content
    final payload = Map<String, dynamic>.from(newGap);
    payload['eventDate'] = date;
    payload[OvcCasePlanConstant.casePlanToGapLinkage] = linkage;

    // 3) If we have an existing gap, convert to UPDATE payload
    if (existingMap.isNotEmpty) {
      final eventId =
      (existingMap['eventId'] ?? existingMap['event'] ?? '').toString();
      if (eventId.isNotEmpty) {
        payload['eventId'] = eventId;
      }

      // Remove no-op fields (same value as existing)
      final keys = List<String>.from(payload.keys);
      for (final k in keys) {
        if (k == 'eventId' ||
            k == 'eventDate' ||
            k == OvcCasePlanConstant.casePlanToGapLinkage) {
          continue;
        }
        if (_norm(payload[k]) == _norm(existingMap[k])) {
          payload.remove(k);
        }
      }

      // If nothing but meta fields remain, skip saving
      final remaining = payload.keys.where(
            (k) =>
        k != 'eventId' &&
            k != 'eventDate' &&
            k != OvcCasePlanConstant.casePlanToGapLinkage,
      );
      if (remaining.isEmpty) return null;
    }

    return payload;
  }

  static String _norm(dynamic v) => (v ?? '').toString().trim().toLowerCase();
}
