
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

import '../../../../../core/services/organisation_unit_service.dart';
import '../constants/ovc_service_well_being_assessment_constant.dart';

class OvcCasePlanHouseholdToOvcUtil {
  // ---- small helpers --------------------------------------------------------

  Future<Map<String, String?>> _latestValuesForChildAssessment(String tei) async {
    final accessibleOrgUnits =
    await OrganisationUnitService().getOrganisationUnitAccessedByCurrentUser();
    final all = await TrackedEntityInstanceUtil
        .getSavedTrackedEntityInstanceEventData(tei, accessibleOrgUnits: accessibleOrgUnits);

    final stageId = OvcServiceWellBeingAssessmentConstant.programStage;
    final stageEvents = all.where((e) => e.programStage == stageId).toList();
    if (stageEvents.isEmpty) return {};

    stageEvents.sort((a, b) {
      final ad = DateTime.tryParse(a.eventDate ?? '');
      final bd = DateTime.tryParse(b.eventDate ?? '');
      if (ad != null && bd != null) return bd.compareTo(ad);
      return (b.eventDate ?? '').compareTo(a.eventDate ?? '');
    });

    final latest = stageEvents.first;
    final map = <String, String?>{};
    final dvs = (latest.dataValues as List?) ?? const [];
    for (final dv in dvs) {
      if (dv is Map && dv['dataElement'] != null) {
        map[dv['dataElement'] as String] = dv['value']?.toString();
      }
    }
    map['eventDate'] = latest.eventDate;
    map['eventId'] = latest.event;
    return map;
  }



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

  // Normalize HIV status to one of: Positive / Negative / Unknown
  static String _normHiv(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    if (s.isEmpty) return 'Unknown';
    const pos = {'positive', 'pos', 'positive (known)', '1', 'true', 'yes'};
    const neg = {'negative', 'neg', '0', 'false', 'no'};
    if (pos.contains(s)) return 'Positive';
    if (neg.contains(s)) return 'Negative';
    // leave original title-case for known strings
    final t = (v ?? '').toString().trim();
    if (t.toLowerCase() == 'unknown') return 'Unknown';
    // unknown-ish or unexpected → treat as Unknown
    return 'Unknown';
  }

  /// Try resolve HIV status from TEI attributes first, then latest event
   Future<String?> _childHivStatus(TrackedEntityInstance tei) async {

    final childVals = await _latestValuesForChildAssessment(tei as String);
    print(childVals);
    const hivDE = 'vNeOE9abQBB';
    final hivStatus = childVals[hivDE];
    // Common DE/attribute id used in your codebase for HIV status
    return hivStatus;
  }

  // Build list of valid DE ids (generic + ageBased + hivstatusBased)
  Future<List<String>> _validIdsForChild({
    required Map domainConfig,
    required int age,
    required TrackedEntityInstance tei,
  }) async {
    final valid = <String>[];

    // --- generic
    final generic = (domainConfig['generic'] ?? const <String>[]);
    if (generic is List) {
      for (final it in generic) {
        final s = it?.toString();
        if (s != null && s.isNotEmpty) valid.add(s);
      }
    }

    // --- ageBased
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

    // --- hivstatusBased (NEW)
    // structure:
    // "hivstatusBased": [
    //   {"status":"Positive","ids":[...]}
    //   {"status":"Negative","ids":[...]}
    //   {"status":"Unknown","ids":[...]}
    //   {"status":"Any","ids":[...]} // optional fallback
    // ]
    final hivBlocks = (domainConfig['hivstatusBased'] ?? const <Map>[]);
    if (hivBlocks is List && hivBlocks.isNotEmpty) {
      final status = await _childHivStatus(tei); // Positive / Negative / Unknown
      String statusLower = status!.toLowerCase();
      List _idsFor(String target) {
        final out = <String>[];
        for (final blk in hivBlocks) {
          if (blk is! Map) continue;
          final s = (blk['status'] ?? '').toString().trim().toLowerCase();
          if (s == target.toLowerCase()) {
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

      // exact match (Positive/Negative/Unknown)
      final exact = _idsFor(statusLower);
      if (exact.isNotEmpty) valid.addAll(exact as Iterable<String>);

      // fallback "Any"
      if (exact.isEmpty) {
        final any = _idsFor('any');
        if (any.isNotEmpty) valid.addAll(any as Iterable<String>);
      }
    }

    // uniqueness
    return valid.toSet().toList();
  }

  // ---- existing reads (dedupe intelligence) ---------------------------------

  /// Returns the eventId of an existing **child CP container** (case plan stage)
  /// that matches the given domain and cpLink; null if none.
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
      final link = (dvMap[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
      final dom  = (dvMap[OvcCasePlanConstant.casePlanDomainType] ?? '').toString();
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
      final link = (dvMap[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
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

  // ---- writers (dedupe preserved) -------------------------------------------

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
      existingEventId, // update if present, create otherwise
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

  // ---- PUBLIC API -----------------------------------------------------------

  /// For each child:
  ///  - compute allowed IDs from **generic + ageBased + hivstatusBased**
  ///  - ensure a child CP container exists for (domain, cpLink) without duplicating it
  ///  - create a child GAP event only with **new** DEs (no duplicate toggles)
  Future<void> autoSyncHHGapsToChildren({
    required List<OvcHouseholdChild> children,
    required Map<String, dynamic> hhGapObject,
    required String domainId,
    required String orgUnit,
    required String eventDate,
  }) async {
    final cpLinkDe = OvcCasePlanConstant.casePlanToGapLinkage;
    String cpLink = (hhGapObject[cpLinkDe] ?? '').toString().trim();
    if (cpLink.isEmpty) cpLink = AppUtil.getUid();

    final Map domainCfg =
        OvcChildCasePlanConstant.domainToAutopopuledCasePlanGaps[domainId] ??
            const <String, dynamic>{};

    for (final child in children) {
      try {
        final tei = child.teiData;
        if (tei == null) continue;

        final age = _coerceAge(child);
        final ids = await _validIdsForChild(
          domainConfig: domainCfg,
          age: age,
          tei: tei,
        );

        if (ids.isEmpty && (domainCfg['generic'] ?? const []) is! List) {
          if (kDebugMode) {
            debugPrint(
              '[GAP Propagation] No eligible HH gap fields for child ${_childName(child)} in "$domainId". Skip.',
            );
          }
          continue;
        }

        // 1) ensure child has a CP container (update if exists)
        await _ensureChildCasePlanContainer(
          domainId: domainId,
          cpLink: cpLink,
          orgUnit: orgUnit,
          eventDate: eventDate,
          tei: tei,
        );

        // 2) create a GAP event only with NEW toggles
        await _createChildGapEvent(
          domainId: domainId,
          hhGapObject: hhGapObject,
          allowedIds: ids,
          cpLink: cpLink,
          orgUnit: orgUnit,
          eventDate: eventDate,
          tei: tei,
        );

        if (kDebugMode) {
          debugPrint(
            '[GAP Propagation] Processed child ${_childName(child)} (domain="$domainId").',
          );
        }
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint(
            '[GAP Propagation] ERROR for child ${_childName(child)} => $e',
          );
          debugPrint('$st');
        }
      }
    }
  }
}

