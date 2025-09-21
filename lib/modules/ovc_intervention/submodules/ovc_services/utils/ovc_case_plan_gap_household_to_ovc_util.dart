
import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';

class OvcCasePlanGapHouseholdToOvcUtil {
  // Prevent double writes within a single cascade
  static final Set<String> _inFlight = <String>{};

  // Meta keys we keep as-is on gap payloads
  static const Set<String> _metaKeys = {
    'eventDate',
    OvcCasePlanConstant.casePlanToGapLinkage,
    OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
    OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
  };

  static Future<void> autoSyncOvcsCasPlanGaps({
    required String currentCasePlanDate, // not used here (kept for parity)
    required List<OvcHouseholdChild> childrens,
    required Map dataObject,            // HH CP object (domainId -> {...})
    required String orgUnit,
    required String eventDate,
  }) async {
    try {
      for (final entry in dataObject.entries) {
        final domainId = '${entry.key}';

        // Skip non-domain containers
        if (domainId == OvcCasePlanConstant.casePlanLocatinSectionId ||
            domainId == OvcCasePlanConstant.casePlanEventDateSectionId ||
            domainId == OvcCasePlanConstant.householdCategorizationSection) {
          continue;
        }

        final domainMap = Map<String, dynamic>.from(entry.value as Map);

        // HH CP linkage for this domain (stable)
        String cpLinkage =
        (domainMap[OvcCasePlanConstant.casePlanToGapLinkage] ?? '')
            .toString()
            .trim();
        if (cpLinkage.isEmpty) {
          cpLinkage = (domainMap['eventId'] ?? '').toString().trim().isNotEmpty
              ? domainMap['eventId']
              : AppUtil.getUid();
        }

        // HH truthy gap IDs for this domain (merged)
        final hhTrue = _mergeHouseholdGaps(domainMap);
        if (kDebugMode) {
          debugPrint(
              '[GAP Propagation] DOMAIN="$domainId" HH gap IDs=${hhTrue.keys.toList()} cpLink=$cpLinkage');
        }
        if (hhTrue.isEmpty) continue;

        for (final child in childrens) {
          final tei = child.teiData?.trackedEntityInstance ?? '';
          final childOrg = child.teiData?.orgUnit ?? orgUnit;

          // TEI sanity — skip if not credible (prevents “One Power” type duplicates)
          if (!_looksLikeTei(tei)) {
            if (kDebugMode) {
              debugPrint(
                  '[GAP Propagation] SKIP (no valid TEI). childId="${child.id}" tei="$tei" domain="$domainId"');
            }
            continue;
          }

          final guardKey = '$tei|$domainId|$cpLinkage';
          if (_inFlight.contains(guardKey)) {
            if (kDebugMode) {
              debugPrint('[GAP Propagation] SKIP duplicate pass guard=$guardKey');
            }
            continue;
          }
          _inFlight.add(guardKey);

          try {
            // Age-allowed DE IDs (filters HH)
            final age = int.tryParse(child.age ?? '0') ?? 0;
            final allowedIds = _allowedIdsForAge(domainId, age);
            final hhEligibleIds =
            hhTrue.keys.where((id) => allowedIds.contains(id)).toSet();

            if (kDebugMode) {
              debugPrint(
                  '[GAP Propagation] TEI=$tei domain="$domainId" age=$age '
                      'allowed=${allowedIds.length} hhEligible=${hhEligibleIds.length}');
            }
            if (hhEligibleIds.isEmpty) {
              if (kDebugMode) {
                debugPrint(
                    '[GAP Propagation] No age-eligible HH gap IDs for TEI=$tei domain="$domainId".');
              }
              continue;
            }

            // Read all existing stage events for child and make snapshot
            final snap = await _snapshotChildGapStage(tei: tei);
            if (kDebugMode) {
              debugPrint(
                  '[GAP Propagation] Read events for TEI=$tei stage=${OvcChildCasePlanConstant.casePlanGapProgramStage} '
                      'count=${snap.stageEventsCount}');
              debugPrint(
                  '[GAP Propagation] Snapshot TEI=$tei hasAny=${snap.hadAnyStageEvent} '
                      'latestId=${snap.latestEventId ?? "<none>"} unionIds=${snap.unionTrueIds.length}');
            }

            // Choose baseline TRUE set:
            // Prefer per-linkage; if none, fallback to stage-wide union
            final existingForCp = snap.trueIdsByLinkage[cpLinkage] ?? <String>{};
            final baselineTrue =
            existingForCp.isNotEmpty ? existingForCp : snap.unionTrueIds;

            // Only NEW ids
            final newIds = hhEligibleIds.difference(baselineTrue);
            if (newIds.isEmpty) {
              if (kDebugMode) {
                debugPrint(
                    '[GAP Propagation] TEI=$tei domain="$domainId" '
                        'All gap IDs already present (cpLink=$cpLinkage). SKIP.');
              }
              continue;
            }

            // Build payload: ONLY new ids + (always) linkage + eventDate
            final payload = <String, dynamic>{
              OvcCasePlanConstant.casePlanToGapLinkage: cpLinkage,
              'eventDate': eventDate,
            };
            for (final id in newIds) {
              payload[id] = true;
            }

            // Save strategy:
            // - If child has any stage event: UPDATE the latest (retrofit linkage if absent)
            // - Else: CREATE a new event
            final List<FormSection> sections = OvcServicesChildCasePlanGap
                .getFormSections(firstDate: '')
                .where((s) => (s.id ?? '') == domainId)
                .toList();

            final eventIdToUpdate =
            snap.hadAnyStageEvent ? snap.latestEventId : null;

            await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
              OvcChildCasePlanConstant.program,
              OvcChildCasePlanConstant.casePlanGapProgramStage,
              childOrg,
              sections,
              payload,
              eventDate,
              tei,
              eventIdToUpdate,
              const [
                // DO NOT hide CP→Gap linkage — it must persist!
                OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
                OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
              ],
            );

            // Make the change instantly visible to this cascade
            // Update both the per-linkage set and the union set
            snap.trueIdsByLinkage
                .putIfAbsent(cpLinkage, () => <String>{})
                .addAll(newIds);
            snap.unionTrueIds.addAll(newIds);

            if (kDebugMode) {
              final verb = eventIdToUpdate == null ? 'Created' : 'Updated';
              debugPrint(
                '[GAP Propagation] $verb child gap for TEI=$tei '
                    '(domain="$domainId"). Added gap IDs: ${newIds.join(", ")} | '
                    'nowStageHas=${snap.hadAnyStageEvent || eventIdToUpdate == null} latest=${eventIdToUpdate ?? "<new>"}',
              );
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint(
                  '[GAP Propagation] Save failed for TEI=${child.teiData?.trackedEntityInstance ?? child.id} '
                      'in domain="$domainId": $e');
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

  // ---------- Helpers (purely inside this file) ----------

  static bool _isTrueLike(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    return v == true || s == 'true' || s == '1' || s == 'yes' || s == 'y';
  }

  // Merge HH domain gaps into a single map of TRUE DE ids
  static Map<String, bool> _mergeHouseholdGaps(Map domainMap) {
    final out = <String, bool>{};
    final gaps = (domainMap['gaps'] as List?) ?? const [];
    for (final g in gaps) {
      final m = Map<String, dynamic>.from(g as Map);
      m.forEach((k, v) {
        if (_isTrueLike(v)) out['$k'] = true;
      });
    }
    return out;
  }

  // Age filter
  static Set<String> _allowedIdsForAge(String domainId, int age) {
    final cfg = OvcChildCasePlanConstant
        .domainToAutopopuledCasePlanGaps[domainId] ??
        const <String, dynamic>{};
    return OvcChildCasePlanConstant.getValidIdForAutoPopulatingServiceData(
      domainConfig: cfg,
      age: age,
    ).toSet();
  }

  // TEI shape guard (very basic, avoids names being used as TEIs)
  static bool _looksLikeTei(String tei) {
    if (tei.isEmpty) return false;
    // DHIS2 TEIs are usually 11-char UID-ish, but installations vary.
    // Require >= 8 alnum to avoid obvious names.
    final ok = RegExp(r'^[A-Za-z0-9]{8,}$').hasMatch(tei);
    return ok;
  }

  // Snapshot of child's GAP stage: events count, latest, union TRUE ids and map by linkage
  static Future<_StageSnapshot> _snapshotChildGapStage({required String tei}) async {
    final events =
    await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(
      tei,
    );
    final stageId = OvcChildCasePlanConstant.casePlanGapProgramStage;

    final stage = events.where((e) => e.programStage == stageId).toList();
    stage.sort((a, b) {
      final da = DateTime.tryParse('${a.eventDate ?? ''}');
      final db = DateTime.tryParse('${b.eventDate ?? ''}');
      if (da != null && db != null) return db.compareTo(da);
      return (b.eventDate ?? '').toString().compareTo('${a.eventDate ?? ''}');
    });

    final union = <String>{};
    final byLinkage = <String, Set<String>>{};
    final linkageDe = OvcCasePlanConstant.casePlanToGapLinkage;

    for (final ev in stage) {
      final dvs = (ev.dataValues as List?) ?? const [];
      String linkage = '';
      // First pass: extract linkage
      for (final dv in dvs) {
        if (dv is Map && dv['dataElement'] == linkageDe) {
          linkage = (dv['value'] ?? '').toString().trim();
          break;
        }
      }

      // Collect true DEs
      final setForLink = linkage.isNotEmpty
          ? byLinkage.putIfAbsent(linkage, () => <String>{})
          : null;

      for (final dv in dvs) {
        if (dv is! Map || dv['dataElement'] == null) continue;
        final de = '${dv['dataElement']}';
        final val = (dv['value'] ?? '').toString().trim().toLowerCase();
        final isTrue = val == 'true' || val == '1' || val == 'yes' || val == 'y';
        if (isTrue) {
          union.add(de);
          if (setForLink != null) setForLink.add(de);
        }
      }
    }

    final latestId =
    stage.isNotEmpty ? (stage.first.event ?? '').toString() : null;

    return _StageSnapshot(
      stageEventsCount: stage.length,
      hadAnyStageEvent: stage.isNotEmpty,
      latestEventId: (latestId != null && latestId.isNotEmpty) ? latestId : null,
      unionTrueIds: union,
      trueIdsByLinkage: byLinkage,
    );
  }
}

class _StageSnapshot {
  final int stageEventsCount;
  final bool hadAnyStageEvent;
  final String? latestEventId;
  final Set<String> unionTrueIds;
  final Map<String, Set<String>> trueIdsByLinkage;
  _StageSnapshot({
    required this.stageEventsCount,
    required this.hadAnyStageEvent,
    required this.latestEventId,
    required this.unionTrueIds,
    required this.trueIdsByLinkage,
  });
}
