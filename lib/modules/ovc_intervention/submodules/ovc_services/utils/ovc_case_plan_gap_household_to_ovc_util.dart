// lib/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_gap_household_to_ovc_util.dart
import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

/// Utilities for saving Household (Caregiver) case plans and gaps without duplicates.
/// Deduplication is **by linkage**, never by event date.
///
/// How to use (in your HH "Generate → Confirm → Save"):
///
/// await OvcCasePlanGapHouseholdToOvcUtil.upsertHouseholdCasePlanAndGapsByLinkage(
///   teiId: household.id!,
///   orgUnit: household.orgUnit!,
///   eventDate: currentCasePlanDate,              // used as payload only (not as uniqueness)
///   domain: activeDomainId,                      // "Health" | "Safe" | "Stable"
///   domainData: selectedDomainPayload,           // must include 'gaps': [ ... ] and linkage de(s)
///   casePlanSections: casePlanSectionsForDomain, // sections you use to save HH case plan
///   gapSections: gapSectionsForDomain,           // sections you use to save HH gaps
///   programId: OvcCasePlanConstant.program,
///   casePlanStageId: OvcCasePlanConstant.casePlanProgramStage,
///   gapStageId: OvcCasePlanConstant.casePlanGapProgramStage,
/// );
class OvcCasePlanGapHouseholdToOvcUtil {
  /// Upsert (no-dup) for **HOUSEHOLD/CAREGIVER** Case Plan + Gaps by linkage.
  /// - If linkage already exists: update existing events.
  /// - If linkage missing: create new events.
  /// - Never deletes; never duplicates.
  static Future<void> upsertHouseholdCasePlanAndGapsByLinkage({
    required String teiId,
    required String orgUnit,
    required String eventDate,
    required String domain, // e.g. "Health" | "Safe" | "Stable"
    required Map<String, dynamic> domainData, // includes 'gaps': [...]
    required List<FormSection> casePlanSections,
    required List<FormSection> gapSections,
    required String programId,
    required String casePlanStageId,
    required String gapStageId,
  }) async {
    // Pull ALL events for the HH TEI (we're not using eventDate for uniqueness!)
    final hhEvents =
    await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(
      teiId,
    );

    // 1) Find linkage from domain payload or its first gap
    const linkageDe = OvcCasePlanConstant.casePlanToGapLinkage;
    final linkageValue = _readLinkValue(domainData, linkageDe) ??
        _readLinkageFromFirstGap(domainData, linkageDe);

    if (linkageValue == null || linkageValue.isEmpty) {
      debugPrint(
          '[HH CasePlan] Skip domain="$domain" TEI=$teiId (no linkage present)');
      return;
    }

    // 2) Field allowlists from the sections provided by the caller
    final casePlanFieldIds = FormUtil.getFormFieldIds(
      casePlanSections,
    );
    final gapFieldIds = FormUtil.getFormFieldIds(
      gapSections,
    );

    // 3) ----- CASE PLAN (HH) -----
    final existingCasePlan = _findEventByLinkage(
      events: hhEvents,
      programStageId: casePlanStageId,
      linkageDe: linkageDe,
      linkageValue: linkageValue,
    );

    // Prepare incoming (without gaps list)
    final incomingCasePlan =
    Map<String, dynamic>.from(domainData)..remove('gaps');

    final mergedCasePlan = _mergeExistingWithIncoming(
      existingEvent: existingCasePlan,
      incoming: incomingCasePlan,
      keepKeys: casePlanFieldIds,
      ensureKeys: <String, dynamic>{
        linkageDe: linkageValue,
        'eventDate': eventDate,
        // Keep domain type so UI renders in correct domain
        OvcCasePlanConstant.casePlanDomainType: domain,
      },
    );

    final skippedCasePlan =
    _skippedFromSection(casePlanFieldIds, mergedCasePlan);

    debugPrint(
        '[HH CasePlan] save TEI=$teiId domain=$domain linkage=$linkageValue keep=${casePlanFieldIds.length} set=${mergedCasePlan.keys.length} skip=${skippedCasePlan.length} updating=${existingCasePlan?.event != null}');

    await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
      programId,
      casePlanStageId,
      orgUnit,
      casePlanSections,
      mergedCasePlan,
      eventDate,
      teiId,
      existingCasePlan?.event, // update if exists
      <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanDomainType,
      ],
      skippedFields: skippedCasePlan,
    );

    // 4) ----- GAPS (HH) -----
    final List<dynamic> rawGaps = List<dynamic>.from(
      domainData['gaps'] ?? const <dynamic>[],
    );
    if (rawGaps.isEmpty) {
      return;
    }

    // Flatten all selected gaps for this domain into one payload by OR-merging
    final mergedGapPayload = _mergeGapsForSameLinkage(
      rawGaps,
      linkageDe,
      linkageValue,
    )..['eventDate'] = eventDate;

    final existingGap = _findEventByLinkage(
      events: hhEvents,
      programStageId: gapStageId,
      linkageDe: linkageDe,
      linkageValue: linkageValue,
    );

    final mergedGap = _mergeExistingWithIncoming(
      existingEvent: existingGap,
      incoming: mergedGapPayload,
      keepKeys: gapFieldIds,
      ensureKeys: <String, dynamic>{
        linkageDe: linkageValue,
        // Preserve existing SP/Monitoring linkages if present (avoid breaking chains)
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage:
        existingGap == null
            ? mergedGapPayload[OvcCasePlanConstant
            .casePlanGapToServiceProvisionLinkage]
            : _getDeValue(existingGap,
            OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage),
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage:
        existingGap == null
            ? mergedGapPayload[
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage]
            : _getDeValue(existingGap,
            OvcCasePlanConstant.casePlanGapToMonitoringLinkage),
      },
    );

    final skippedGap = _skippedFromSection(gapFieldIds, mergedGap);

    debugPrint(
        '[HH CasePlan] GAP save TEI=$teiId domain=$domain linkage=$linkageValue set=${mergedGap.keys.length} skip=${skippedGap.length} updating=${existingGap?.event != null}');

    await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
      programId,
      gapStageId,
      orgUnit,
      gapSections,
      mergedGap,
      eventDate,
      teiId,
      existingGap?.event, // update if exists
      <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      ],
      skippedFields: skippedGap,
    );
  }

  // ---------------------------------------------------------------------------
  // Helper utilities
  // ---------------------------------------------------------------------------

  /// Find first event in [events] for [programStageId] where dataElement [linkageDe] == [linkageValue]
  static Events? _findEventByLinkage({
    required List<Events> events,
    required String programStageId,
    required String linkageDe,
    required String linkageValue,
  }) {
    for (final e in events) {
      if ((e.programStage ?? '') != programStageId) continue;
      final dvs = (e.dataValues as List?) ?? const <dynamic>[];
      for (final dv in dvs) {
        if (dv is Map &&
            dv['dataElement'] == linkageDe &&
            (dv['value'] ?? '') == linkageValue) {
          return e;
        }
      }
    }
    return null;
  }

  /// Gets a single DE value from an Events dataValues list.
  static dynamic _getDeValue(Events? event, String de) {
    if (event == null) return null;
    final dvs = (event.dataValues as List?) ?? const <dynamic>[];
    for (final dv in dvs) {
      if (dv is Map && dv['dataElement'] == de) {
        return dv['value'];
      }
    }
    return null;
  }

  /// Merge an existing event's values with an incoming payload:
  /// - For boolean-like fields: OR (true wins).
  /// - For strings: prefer non-empty incoming; else keep existing.
  /// - Only keep keys present in [keepKeys] plus [ensureKeys].
  static Map<String, dynamic> _mergeExistingWithIncoming({
    required Events? existingEvent,
    required Map<String, dynamic> incoming,
    required List<String> keepKeys,
    required Map<String, dynamic> ensureKeys,
  }) {
    final Map<String, dynamic> out = <String, dynamic>{};

    // Seed with ensure keys
    out.addAll(ensureKeys);

    // 1) Load existing from event
    if (existingEvent != null) {
      final dvs = (existingEvent.dataValues as List?) ?? const <dynamic>[];
      for (final dv in dvs) {
        if (dv is! Map) continue;
        final id = (dv['dataElement'] ?? '').toString();
        if (!keepKeys.contains(id) && !_isLinkageDe(id) && !_isDomainDe(id)) {
          // Skip any noise not in the section (but we still keep linkage/domain elsewhere)
          continue;
        }
        final existingVal = dv['value'];
        if (existingVal == null) continue;
        // Only set if not already in out (ensure keys win)
        if (!out.containsKey(id) || _isEmpty(out[id])) {
          out[id] = existingVal;
        }
      }
    }

    // 2) Apply incoming within the allowed keys
    incoming.forEach((key, val) {
      if (!keepKeys.contains(key) && !_isLinkageDe(key) && !_isDomainDe(key)) {
        return;
      }
      final existing = out[key];
      out[key] = _mergeValue(existing, val);
    });

    // Clean up any null/empty keys that slipped in (except linkage/domain/eventDate)
    final keys = List<String>.from(out.keys);
    for (final k in keys) {
      if (_isLinkageDe(k) || _isDomainDe(k) || k == 'eventDate') continue;
      if (_isEmpty(out[k])) out.remove(k);
    }

    return out;
  }

  /// OR merge for booleans, otherwise prefer non-empty incoming.
  static dynamic _mergeValue(dynamic existing, dynamic incoming) {
    // boolean-like? -> OR
    if (_looksBool(existing) || _looksBool(incoming)) {
      final a = _isTruthy(existing);
      final b = _isTruthy(incoming);
      return (a || b) ? 'true' : 'false';
    }
    // strings / others: prefer incoming if not empty
    if (!_isEmpty(incoming)) return incoming;
    return existing;
  }

  static bool _looksBool(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    return {'true', 'false', '1', '0', 'yes', 'no'}.contains(s);
  }

  static bool _isTruthy(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }

  static bool _isEmpty(dynamic v) {
    if (v == null) return true;
    if (v is String) return v.trim().isEmpty;
    return false;
  }

  /// Merge many gap maps (all for the same linkage) into a single payload:
  /// - Booleans OR'd, last non-empty string wins
  static Map<String, dynamic> _mergeGapsForSameLinkage(
      List<dynamic> gaps,
      String linkageDe,
      String linkageValue,
      ) {
    final Map<String, dynamic> out = <String, dynamic>{
      linkageDe: linkageValue,
    };

    for (final raw in gaps) {
      if (raw is! Map) continue;
      final gap = Map<String, dynamic>.from(raw);
      // Never carry eventId across different saves; we upsert by linkage
      gap.remove('eventId');

      gap.forEach((key, val) {
        if (key == 'eventDate') return; // handled by caller
        final prev = out[key];
        out[key] = _mergeValue(prev, val);
      });
    }
    // Strip empty
    final keys = List<String>.from(out.keys);
    for (final k in keys) {
      if (k == linkageDe) continue;
      if (_isEmpty(out[k])) out.remove(k);
    }
    return out;
  }

  /// Build "skippedFields" list: anything present in [keepIds] but missing in [payload].
  static List<String> _skippedFromSection(
      List<String> keepIds,
      Map<String, dynamic> payload,
      ) {
    final List<String> skipped = <String>[];
    for (final id in keepIds) {
      if (!payload.containsKey(id) && !_isLinkageDe(id) && !_isDomainDe(id)) {
        skipped.add(id);
      }
    }
    return skipped;
  }

  static bool _isLinkageDe(String id) {
    return id == OvcCasePlanConstant.casePlanToGapLinkage ||
        id == OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage ||
        id == OvcCasePlanConstant.casePlanGapToMonitoringLinkage;
  }

  static bool _isDomainDe(String id) {
    return id == OvcCasePlanConstant.casePlanDomainType;
  }

  static String? _readLinkValue(
      Map<String, dynamic> m,
      String linkageDe,
      ) {
    final v = m[linkageDe];
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static String? _readLinkageFromFirstGap(
      Map<String, dynamic> m,
      String linkageDe,
      ) {
    final gaps = m['gaps'];
    if (gaps is! List) return null;
    for (final g in gaps) {
      if (g is! Map) continue;
      final v = g[linkageDe];
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return null;
  }
}
