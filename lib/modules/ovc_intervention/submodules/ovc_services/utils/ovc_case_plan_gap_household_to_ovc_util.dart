
import 'package:flutter/foundation.dart';

import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';

import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_case_plan.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';

/// HH → Children (container + gaps propagation; NO services/monitoring)
/// Copied behavior from the working OvcCasePlanHouseholdToOvcUtil:
/// - ensure child CP container (update if exists)
/// - propagate only NEW gap DEs for the SAME cpLinkage
/// - age-filtered DEs using OvcChildCasePlanConstant.domainToAutopopuledCasePlanGaps
class OvcCasePlanGapHouseholdToOvcUtil {
  // Prevent double writes within a single cascade
  static final Set<String> _inFlight = <String>{};

  // ---------------- small helpers ----------------

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    final s = v.toString().trim();
    final i = int.tryParse(s);
    return i ?? fallback;
  }

  static int _coerceAge(OvcHouseholdChild child) {
    final a = _asInt(child.age, fallback: 0);
    return a >= 0 ? a : 0;
  }

  static String _childName(OvcHouseholdChild c) {
    final parts = <String>[];
    if ((c.firstName ?? '').trim().isNotEmpty) parts.add(c.firstName!.trim());
    if ((c.surname ?? '').trim().isNotEmpty) parts.add(c.surname!.trim());
    final name = parts.join(' ');
    if (name.isNotEmpty) return name;
    return c.id ?? c.toString();
  }

  static bool _isTrueLike(dynamic v) {
    if (v is bool) return v;
    final s = (v ?? '').toString().trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes' || s == 'y';
  }

  static List<String> _validIdsForChildAge({
    required Map domainConfig,
    required int age,
  }) {
    final valid = <String>[];

    final generic = (domainConfig['generic'] ?? const <String>[]);
    if (generic is List) {
      for (final it in generic) {
        final s = it?.toString();
        if (s != null && s.isNotEmpty) valid.add(s);
      }
    }

    final ageBased = (domainConfig['ageBased'] ?? const <Map>[]);
    if (ageBased is List) {
      for (final dyn in ageBased) {
        if (dyn is! Map) continue;
        final minAge = _asInt(dyn['minAge'], fallback: -0x7fffffff);
        final maxAge = _asInt(dyn['maxAge'], fallback: 0x7fffffff);
        if (age >= minAge && age < maxAge) {
          final ids = dyn['ids'];
          if (ids is List) {
            for (final it in ids) {
              final s = it?.toString();
              if (s != null && s.isNotEmpty) valid.add(s);
            }
          }
        }
      }
    }
    return valid.toSet().toList();
  }

  // ---------------- existing reads (dedupe intelligence) ----------------

  /// Returns the eventId of an existing **child CP container** (case plan stage)
  /// that matches the given domain and cpLink; null if none.
  static Future<String?> _findExistingChildCpEventId({
    required String teiId,
    required String domainId,
    required String cpLink,
  }) async {
    final all =
    await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(
      teiId,
    );
    final stageId = OvcChildCasePlanConstant.casePlanProgramStage;
    String? found;

    for (final e in all) {
      if (e.programStage != stageId) continue;
      // materialize dataValues into a map
      final dvMap = <String, dynamic>{};
      final raw = e.dataValues;
      if (raw is Map) {
        raw.forEach((k, v) => dvMap['$k'] = v);
      } else if (raw is List) {
        for (final row in raw) {
          if (row is Map && row['dataElement'] != null) {
            dvMap['${row['dataElement']}'] = row['value'];
          }
        }
      }
      final link =
      (dvMap[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
      final dom =
      (dvMap[OvcCasePlanConstant.casePlanDomainType] ?? '').toString();
      if (link == cpLink && dom == domainId) {
        found = e.event;
        break;
      }
    }
    return (found != null && found!.trim().isNotEmpty) ? found : null;
  }

  /// Collect all TRUE DE IDs from the child GAP stage for the given cpLink.
  static Future<Set<String>> _existingTrueGapIdsForLinkage({
    required String teiId,
    required String cpLink,
  }) async {
    final out = <String>{};
    final all =
    await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(
      teiId,
    );
    final stageId = OvcChildCasePlanConstant.casePlanGapProgramStage;

    for (final e in all) {
      if (e.programStage != stageId) continue;
      // build map
      final dvMap = <String, dynamic>{};
      final raw = e.dataValues;
      if (raw is Map) {
        raw.forEach((k, v) => dvMap['$k'] = v);
      } else if (raw is List) {
        for (final row in raw) {
          if (row is Map && row['dataElement'] != null) {
            dvMap['${row['dataElement']}'] = row['value'];
          }
        }
      }
      // require same cpLink
      final link =
      (dvMap[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
      if (link != cpLink) continue;

      // collect TRUE toggles
      dvMap.forEach((de, val) {
        if (de == OvcCasePlanConstant.casePlanToGapLinkage ||
            de == OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage ||
            de == OvcCasePlanConstant.casePlanGapToMonitoringLinkage ||
            de == 'eventDate') {
          return;
        }
        if (_isTrueLike(val)) out.add('$de');
      });
    }
    return out;
  }

  // ---------------- writers (container + gaps) ----------------

  /// Ensure child has a CP container for (domainId, cpLink). **Updates** if one already exists.
  static Future<void> _ensureChildCasePlanContainer({
    required String domainId,
    required String cpLink,
    required String orgUnit,
    required String eventDate,
    required TrackedEntityInstance tei,
  }) async {
    final containerSections = OvcServicesCasePlan
        .getFormSections(firstDate: '')
        .where((s) => (s.id ?? '') == domainId)
        .toList();

    final payload = <String, dynamic>{
      OvcCasePlanConstant.casePlanToGapLinkage: cpLink,
      OvcCasePlanConstant.casePlanDomainType: domainId,
      'eventDate': eventDate,
    };

    final existingEventId = await _findExistingChildCpEventId(
      teiId: tei.trackedEntityInstance ?? '',
      domainId: domainId,
      cpLink: cpLink,
    );

    await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
      OvcChildCasePlanConstant.program,
      OvcChildCasePlanConstant.casePlanProgramStage,
      orgUnit,
      containerSections,
      payload,
      eventDate,
      tei.trackedEntityInstance,
      existingEventId, // <-- update if present, create otherwise
      <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanDomainType,
      ],
    );
  }

  /// Create a child GAP event filtered to valid DEs and **not already TRUE**.
  static Future<void> _createChildGapEvent({
    required String domainId,
    required Map<String, dynamic> hhGapObject,
    required List<String> allowedIds,
    required String cpLink,
    required String orgUnit,
    required String eventDate,
    required TrackedEntityInstance tei,
  }) async {
    final gapSections = OvcServicesChildCasePlanGap
        .getFormSections(firstDate: '')
        .where((s) => (s.id ?? '') == domainId)
        .toList();

    // IDs already present for this linkage
    final already = await _existingTrueGapIdsForLinkage(
      teiId: tei.trackedEntityInstance ?? '',
      cpLink: cpLink,
    );

    final allowed = <String>{
      ...allowedIds,
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      'eventDate',
    };

    final toSave = <String, dynamic>{};

    hhGapObject.forEach((k, v) {
      final ks = k.toString();
      if (!allowed.contains(ks)) return;

      // linkage and eventDate are always kept
      if (ks == OvcCasePlanConstant.casePlanToGapLinkage ||
          ks == OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage ||
          ks == OvcCasePlanConstant.casePlanGapToMonitoringLinkage ||
          ks == 'eventDate') {
        toSave[ks] = v;
        return;
      }

      // only add NEW true-ish toggles that are not already in child's GAPs
      if (_isTrueLike(v) && !already.contains(ks)) {
        toSave[ks] = true; // normalize
      }
    });

    // force link + date
    toSave[OvcCasePlanConstant.casePlanToGapLinkage] = cpLink;
    toSave['eventDate'] = eventDate;

    // If there are no NEW DEs besides meta (link/date), skip creating noise
    final hasNewToggle = toSave.keys.any((k) =>
    k != OvcCasePlanConstant.casePlanToGapLinkage &&
        k != OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage &&
        k != OvcCasePlanConstant.casePlanGapToMonitoringLinkage &&
        k != 'eventDate');

    if (!hasNewToggle) {
      if (kDebugMode) {
        debugPrint(
          '[GAP Propagation] No new gap DEs for ${tei.trackedEntityInstance} (domain="$domainId"). Skip create.',
        );
      }
      return;
    }

    await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
      OvcChildCasePlanConstant.program,
      OvcChildCasePlanConstant.casePlanGapProgramStage,
      orgUnit,
      gapSections,
      toSave,
      eventDate,
      tei.trackedEntityInstance,
      null, // always a new gap event if there is something new to add
      <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      ],
    );
  }

  // ---------------- PUBLIC API (HH form calls only this) ----------------

  /// For each domain in HH dataObject:
  ///  - ensure a child CP container for (domain, cpLink) (update if exists)
  ///  - for each HH gap in that domain, add only NEW true DEs to the child (age-filtered)
  static Future<void> autoSyncOvcsCasPlanGaps({
    required String currentCasePlanDate, // kept for parity (not used)
    required List<OvcHouseholdChild> childrens,
    required Map dataObject,            // HH CP object (domainId -> {..., gaps: [...]})
    required String orgUnit,
    required String eventDate,
  }) async {
    try {
      for (final entry in dataObject.entries) {
        final domainId = '${entry.key}';

        // skip non-domain sections
        if (domainId == OvcCasePlanConstant.casePlanLocatinSectionId ||
            domainId == OvcCasePlanConstant.casePlanEventDateSectionId ||
            domainId == OvcCasePlanConstant.householdCategorizationSection) {
          continue;
        }

        final domainMap = Map<String, dynamic>.from(entry.value as Map? ?? {});
        final cpLinkDe = OvcCasePlanConstant.casePlanToGapLinkage;

        // Resolve linkage for this domain
        String cpLink = (domainMap[cpLinkDe] ?? '').toString().trim();
        if (cpLink.isEmpty) {
          cpLink = (domainMap['eventId'] ?? '').toString().trim().isNotEmpty
              ? domainMap['eventId']
              : AppUtil.getUid();
        }

        // HH gaps list
        final gaps = (domainMap['gaps'] as List?) ?? const [];

        for (final child in childrens) {
          final tei = child.teiData;
          if (tei == null) continue;

          final childOrg = tei.orgUnit ?? orgUnit;
          final guardKey = '${tei.trackedEntityInstance}|$domainId|$cpLink';
          if (_inFlight.contains(guardKey)) continue;
          _inFlight.add(guardKey);

          try {
            // 1) ensure container
            await _ensureChildCasePlanContainer(
              domainId: domainId,
              cpLink: cpLink,
              orgUnit: childOrg,
              eventDate: eventDate,
              tei: tei,
            );

            // 2) propagate each HH gap (respecting age-based allowed ids)
            final Map domainCfg = OvcChildCasePlanConstant
                .domainToAutopopuledCasePlanGaps[domainId] ??
                const <String, dynamic>{};
            final age = _coerceAge(child);
            final allowedIds = _validIdsForChildAge(
              domainConfig: domainCfg,
              age: age,
            );

            for (final g in gaps) {
              final gap = Map<String, dynamic>.from(g as Map);
              await _createChildGapEvent(
                domainId: domainId,
                hhGapObject: gap,
                allowedIds: allowedIds,
                cpLink: cpLink,
                orgUnit: childOrg,
                eventDate: eventDate,
                tei: tei,
              );
            }

            if (kDebugMode) {
              debugPrint(
                '[GAP Propagation] Processed child ${_childName(child)} (domain="$domainId").',
              );
            }
          } catch (e, st) {
            if (kDebugMode) {
              debugPrint(
                  '[GAP Propagation] ERROR for child ${_childName(child)} => $e');
              debugPrint('$st');
            }
          } finally {
            _inFlight.remove(guardKey);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GAP Propagation] Fatal error: $e');
      }
    }
  }
}
