
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
/// - ensure child CP container (update if exists)
/// - propagate only NEW gap DEs for the SAME cpLinkage
/// - filter allowed DEs by age (ageBased), HIV status (hivstatusBased),
///   and VL results (vlresultsBased) using domain config.
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

  // ---------------- HIV status helpers ----------------

  static String _normHiv(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    if (s.isEmpty) return 'Unknown';
    const pos = {'positive', 'pos', 'positive (known)', '1', 'true', 'yes'};
    const neg = {'negative', 'neg', '0', 'false', 'no'};
    if (pos.contains(s)) return 'Positive';
    if (neg.contains(s)) return 'Negative';
    if (s == 'unknown' || s == 'unk') return 'Unknown';
    return 'Unknown';
  }

  /// Resolve child HIV status from TEI attributes first, then latest events.
  static Future<String> _childHivStatus(
      TrackedEntityInstance tei, {
        List<String> candidateKeys = const [
          'c5TMWtM4VVJ', // child HIV status (common)
          'vNeOE9abQBB', // generic HIV status
        ],
      }) async {
    // TEI attributes
    try {
      final attrs = tei.attributes ?? [];
      for (final a in attrs) {
        if (a is! Map) continue;
        final id = (a['attribute'] ?? a['id'] ?? '').toString();
        if (candidateKeys.contains(id)) {
          return _normHiv(a['value']);
        }
      }
    } catch (_) {}

    // latest events
    try {
      final teiId = tei.trackedEntityInstance ?? '';
      final all = await TrackedEntityInstanceUtil
          .getSavedTrackedEntityInstanceEventData(teiId);
      all.sort((a, b) => (b.eventDate ?? '').compareTo(a.eventDate ?? ''));
      for (final e in all) {
        final raw = e.dataValues;
        if (raw is Map) {
          for (final key in candidateKeys) {
            if (raw.containsKey(key)) {
              final val = raw[key];
              if (val != null && val.toString().trim().isNotEmpty) {
                return _normHiv(val);
              }
            }
          }
        } else if (raw is List) {
          for (final row in raw) {
            if (row is Map && row['dataElement'] != null) {
              final de = row['dataElement'].toString();
              if (candidateKeys.contains(de)) {
                final val = row['value'];
                if (val != null && val.toString().trim().isNotEmpty) {
                  return _normHiv(val);
                }
              }
            }
          }
        }
      }
    } catch (_) {}

    return 'Unknown';
  }

  // ---------------- VL results helpers (NEW) ----------------

  /// Normalize VL results into: High (>=1000), Low (<1000), Suppressed, Unknown
  static String _normVl(dynamic v) {
    final raw = (v ?? '').toString().trim();
    if (raw.isEmpty) return 'Unknown';
    final s = raw.toLowerCase();

    // Common textual labels
    if (s.contains('suppressed')) return 'Suppressed';
    if (s.contains('high') || s.contains('>') || s.contains('above')) {
      return 'High';
    }
    if (s.contains('low') || s.contains('<') || s.contains('below')) {
      return 'Low';
    }

    // Try numeric extraction
    final numMatch = RegExp(r'(\d{2,6})').firstMatch(s);
    if (numMatch != null) {
      final n = int.tryParse(numMatch.group(1)!);
      if (n != null) {
        if (n >= 1000) return 'High';
        if (n >= 1 && n < 1000) return 'Low';
        if (n == 0) return 'Suppressed';
      }
    }

    // Known option wording from forms
    if (s.contains('above 1,000') || s.contains('>=1000')) return 'High';
    if (s.contains('below 1,000') || s.contains('<1000')) return 'Low';

    return 'Unknown';
  }

  /// Resolve child's latest VL category from attributes (rare) then events.
  static Future<String> _childVlCategory(
      TrackedEntityInstance tei, {
        List<String> vlKeys = const [
          'aRNGDZcwWmS', // Viral load results DE commonly used
        ],
      }) async {
    // TEI attributes (unlikely, but safe)
    try {
      final attrs = tei.attributes ?? [];
      for (final a in attrs) {
        if (a is! Map) continue;
        final id = (a['attribute'] ?? a['id'] ?? '').toString();
        if (vlKeys.contains(id)) {
          return _normVl(a['value']);
        }
      }
    } catch (_) {}

    // latest events
    try {
      final teiId = tei.trackedEntityInstance ?? '';
      final all = await TrackedEntityInstanceUtil
          .getSavedTrackedEntityInstanceEventData(teiId);
      all.sort((a, b) => (b.eventDate ?? '').compareTo(a.eventDate ?? ''));
      for (final e in all) {
        final raw = e.dataValues;
        if (raw is Map) {
          for (final key in vlKeys) {
            if (raw.containsKey(key)) {
              final val = raw[key];
              if (val != null && val.toString().trim().isNotEmpty) {
                return _normVl(val);
              }
            }
          }
        } else if (raw is List) {
          for (final row in raw) {
            if (row is Map && row['dataElement'] != null) {
              final de = row['dataElement'].toString();
              if (vlKeys.contains(de)) {
                final val = row['value'];
                if (val != null && val.toString().trim().isNotEmpty) {
                  return _normVl(val);
                }
              }
            }
          }
        }
      }
    } catch (_) {}

    return 'Unknown';
  }

  // ---------------- allowed IDs resolution (age + HIV + VL) ----------------

  /// Collect allowed DE ids from:
  ///   - "generic"
  ///   - "ageBased": [{minAge, maxAge, ids: []}]
  ///   - "hivstatusBased": [{status: Positive|Negative|Unknown|Any, ids: []}]
  ///   - "vlresultsBased": [{status: High|Low|Suppressed|Unknown|Any, ids: []}]
  static Future<List<String>> _validIdsForChildAgeHivVl({
    required Map domainConfig,
    required int age,
    required TrackedEntityInstance tei,
  }) async {
    final valid = <String>[];

    // generic
    final generic = (domainConfig['generic'] ?? const <String>[]);
    if (generic is List) {
      for (final it in generic) {
        final s = it?.toString();
        if (s != null && s.isNotEmpty) valid.add(s);
      }
    }

    // ageBased
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

    // hivstatusBased
    final hivStatusKeys = (domainConfig['hivStatusKeys'] is List)
        ? List<String>.from(domainConfig['hivStatusKeys'])
        : const <String>['c5TMWtM4VVJ', 'vNeOE9abQBB'];
    final hivBlocks = (domainConfig['hivstatusBased'] ?? const <Map>[]);
    if (hivBlocks is List && hivBlocks.isNotEmpty) {
      final status = (await _childHivStatus(tei, candidateKeys: hivStatusKeys))
          .toLowerCase();
      List<String> pick(String wanted) {
        final out = <String>[];
        for (final blk in hivBlocks) {
          if (blk is! Map) continue;
          final s = (blk['status'] ?? '').toString().trim().toLowerCase();
          if (s == wanted) {
            final ids = blk['ids'];
            if (ids is List) {
              for (final it in ids) {
                final v = it?.toString();
                if (v != null && v.isNotEmpty) out.add(v);
              }
            }
          }
        }
        return out;
      }

      final exact = pick(status);
      if (exact.isNotEmpty) {
        valid.addAll(exact);
      } else {
        valid.addAll(pick('any'));
      }
    }

    // vlresultsBased (NEW)
    final vlKeys = (domainConfig['vlResultKeys'] is List)
        ? List<String>.from(domainConfig['vlResultKeys'])
        : const <String>['aRNGDZcwWmS'];
    final vlBlocks = (domainConfig['vlresultsBased'] ?? const <Map>[]);
    if (vlBlocks is List && vlBlocks.isNotEmpty) {
      final vlCat = (await _childVlCategory(tei, vlKeys: vlKeys)).toLowerCase();

      List<String> pick(String wanted) {
        final out = <String>[];
        for (final blk in vlBlocks) {
          if (blk is! Map) continue;
          final s = (blk['status'] ?? '').toString().trim().toLowerCase();
          if (s == wanted) {
            final ids = blk['ids'];
            if (ids is List) {
              for (final it in ids) {
                final v = it?.toString();
                if (v != null && v.isNotEmpty) out.add(v);
              }
            }
          }
        }
        return out;
      }

      final exact = pick(vlCat); // 'high' | 'low' | 'suppressed' | 'unknown'
      if (exact.isNotEmpty) {
        valid.addAll(exact);
      } else {
        valid.addAll(pick('any'));
      }
    }

    return valid.toSet().toList();
  }

  // ---------------- existing reads (dedupe intelligence) ----------------

  static Future<String?> _findExistingChildCpEventId({
    required String teiId,
    required String domainId,
    required String cpLink,
  }) async {
    final all = await TrackedEntityInstanceUtil
        .getSavedTrackedEntityInstanceEventData(teiId);
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

  static Future<Set<String>> _existingTrueGapIdsForLinkage({
    required String teiId,
    required String cpLink,
  }) async {
    final out = <String>{};
    final all = await TrackedEntityInstanceUtil
        .getSavedTrackedEntityInstanceEventData(teiId);
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
      existingEventId, // update if present, create otherwise
      <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanDomainType,
      ],
    );
  }

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

      if (ks == OvcCasePlanConstant.casePlanToGapLinkage ||
          ks == OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage ||
          ks == OvcCasePlanConstant.casePlanGapToMonitoringLinkage ||
          ks == 'eventDate') {
        toSave[ks] = v;
        return;
      }

      if (_isTrueLike(v) && !already.contains(ks)) {
        toSave[ks] = true; // normalize
      }
    });

    toSave[OvcCasePlanConstant.casePlanToGapLinkage] = cpLink;
    toSave['eventDate'] = eventDate;

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
      null,
      <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      ],
    );
  }

  // ---------------- PUBLIC API ----------------

  static Future<void> autoSyncOvcsCasPlanGaps({
    required String currentCasePlanDate, // not used; kept for parity
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

            // 2) allowed ids (AGE + HIV STATUS + VL CATEGORY + GENERIC)
            final Map domainCfg =
                OvcChildCasePlanConstant.domainToAutopopuledCasePlanGaps[domainId] ??
                    const <String, dynamic>{};
            final age = _coerceAge(child);
            final allowedIds = await _validIdsForChildAgeHivVl(
              domainConfig: domainCfg,
              age: age,
              tei: tei,
            );

            // 3) propagate each HH gap (respecting allowed ids)
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
                '[GAP Propagation] Processed child ${_childName(child)} '
                    '(domain="$domainId", allowedIds=${allowedIds.length}).',
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
