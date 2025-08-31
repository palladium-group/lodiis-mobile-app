import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/case_plan_event.dart';
import 'package:kb_mobile_app/models/case_plan_gap_event.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_case_plan_service.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_case_plan.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';

class OvcCasePlanGapHouseholdToOvcUtil {
  static Future<void> autoSyncOvcsCasPlanGaps({
    required String currentCasePlanDate,
    required List<OvcHouseholdChild> childrens,
    required Map dataObject,
    required String orgUnit,
    required String eventDate,
  }) async {
    try {
      final formSections = OvcServicesCasePlan.getFormSections(firstDate: '');

      for (final child in childrens) {
        // 1) Only keep affirmative + age-valid caregiver selections
        final Map<String, dynamic> sanitized =
        getSanitizedCaregiverDataObjects(
          dataObject: dataObject,
          child: child,
        );
        if (sanitized.isEmpty) continue;

        // 2) Merge with existing child CP (same date) & carry eventId when present
        final Map<String, dynamic> childDataObject =
        await getAutoPopulatingDataObejct(
          currentCasePlanDate,
          child,
          sanitized,
        );
        if (childDataObject.isEmpty) continue;

        // 3) Build dedupe map: for each linkage, which DEs are already TRUE across ALL child gap events
        final existingTrueByLinkage =
        await _existingChildGapTrueTogglesAcrossAllEvents(child.id!);

        for (final domainType in childDataObject.keys.toList()) {
          final Map<String, dynamic> domainDataObject =
          Map<String, dynamic>.from(childDataObject[domainType]);

          // Always stamp domain type on the child CP
          domainDataObject[OvcCasePlanConstant.casePlanDomainType] = domainType;

          // Ensure CP linkage exists
          final linkageDe = OvcCasePlanConstant.casePlanToGapLinkage;
          var linkageVal = (domainDataObject[linkageDe] ?? '').toString().trim();
          if (linkageVal.isEmpty) {
            linkageVal = AppUtil.getUid();
            domainDataObject[linkageDe] = linkageVal;
          }

          // DO NOT drop eventId here — keep it to UPDATE the child CP if it exists
          final domainFormSections =
          formSections.where((s) => s.id == domainType).toList();

          _pruneFalsey(domainDataObject); // keep only meaningful truths/values

          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            OvcChildCasePlanConstant.program,
            OvcChildCasePlanConstant.casePlanProgramStage,
            orgUnit,
            domainFormSections,
            domainDataObject,
            eventDate,
            child.id,
            domainDataObject['eventId'], // update if present, else create
            const [
              OvcCasePlanConstant.casePlanToGapLinkage,
              OvcCasePlanConstant.casePlanDomainType,
            ],
          );

          // 4) Save child gaps WITHOUT duplicating already-TRUE toggles for this linkage
          final Set<String> alreadyTrue =
              existingTrueByLinkage[linkageVal] ?? <String>{};
          final gapSections = OvcServicesChildCasePlanGap.getFormSections(firstDate: '')
              .where((s) => s.id == domainType)
              .toList();

          final List gaps = (domainDataObject['gaps'] as List?) ?? const [];
          for (final rawGap in gaps) {
            final Map<String, dynamic> gap =
            Map<String, dynamic>.from(rawGap as Map);

            // Ensure linkage + eventDate on each gap event
            gap[linkageDe] = linkageVal;
            gap['eventDate'] = eventDate;

            // Always create a new gap event; do NOT carry caregiver eventId
            gap.remove('eventId');

            // Filter out DEs that are already TRUE for this linkage (across ALL events)
            final filtered = _filterNewTrueToggles(
              incoming: gap,
              alreadyTrue: alreadyTrue,
            );

            if (filtered.isEmpty) continue; // nothing new -> skip save

            await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
              OvcChildCasePlanConstant.program,
              OvcChildCasePlanConstant.casePlanGapProgramStage,
              orgUnit,
              gapSections,
              filtered,
              eventDate,
              child.id,
              null, // new gap event
              const [
                OvcCasePlanConstant.casePlanToGapLinkage,
                OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
                OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
              ],
            );

            // Update in-memory dedupe set so subsequent gaps in this run won’t re-add same DEs
            for (final k in filtered.keys) {
              if (_isTrue(filtered[k])) {
                alreadyTrue.add(k);
              }
            }
            existingTrueByLinkage[linkageVal] = alreadyTrue;
          }
        }
      }
    } catch (e, st) {
      debugPrint('[HH→Child] autoSyncOvcsCasPlanGaps error: $e\n$st');
    }
  }

  // ---------- Sanitize caregiver selection (age/domain-valid & affirmative only) ----------
  static Map<String, dynamic> getSanitizedCaregiverDataObjects({
    required Map dataObject,
    required OvcHouseholdChild child,
  }) {
    final Map<String, dynamic> sanitized = {};
    final int age = int.tryParse(child.age ?? '') ?? 0;

    final List<String> domains = OvcChildCasePlanConstant
        .domainToAutopopuledCasePlanGaps
        .keys
        .toList();

    for (final domain in domains) {
      final Map domainCfg =
          OvcChildCasePlanConstant.domainToAutopopuledCasePlanGaps[domain] ??
              {};
      final List<String> validFields =
      OvcChildCasePlanConstant.getValidIdForAutoPopulatingServiceData(
        domainConfig: domainCfg,
        age: age,
      );

      final Map selected =
      Map<String, dynamic>.from((dataObject[domain] ?? {}) as Map);
      final List gaps = (selected['gaps'] as List?) ?? const [];

      final List<Map<String, dynamic>> keptGaps = [];
      for (final g in gaps) {
        final Map gap = Map<String, dynamic>.from(g as Map);
        final Map<String, dynamic> filtered = {};

        // keep useful meta if present
        for (final mk in [
          'eventDate',
          OvcCasePlanConstant.casePlanToGapLinkage,
          OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
          OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
        ]) {
          if (gap.containsKey(mk)) filtered[mk] = gap[mk];
        }

        // only age/domain-valid DEs that are affirmative
        gap.forEach((k, v) {
          if (validFields.contains(k) && _isTrue(v)) {
            filtered[k] = true;
          }
        });

        if (_hasAtLeastOneDE(filtered)) keptGaps.add(filtered);
      }

      if (keptGaps.isNotEmpty) {
        final Map<String, dynamic> out = {};
        // preserve valid top-level affirmative DEs if you had any (optional)
        selected.forEach((k, v) {
          if (validFields.contains(k) && _isTrue(v)) {
            out[k] = true;
          }
        });
        // Preserve CP linkage if present
        final linkageDe = OvcCasePlanConstant.casePlanToGapLinkage;
        if ((selected[linkageDe] ?? '').toString().isNotEmpty) {
          out[linkageDe] = selected[linkageDe];
        }
        out['gaps'] = keptGaps;
        // keep caregiver CP eventId ONLY for the CP merge step; it will be overwritten
        if ((selected['eventId'] ?? '').toString().isNotEmpty) {
          out['eventId'] = selected['eventId'];
        }
        sanitized[domain] = out;
      }
    }
    return sanitized;
  }

  // ---------- Merge caregiver selection with child's CP for the same date ----------
  static Future<Map<String, dynamic>> getAutoPopulatingDataObejct(
      String currentCasePlanDate,
      OvcHouseholdChild child,
      Map<String, dynamic> caregiverDataObjects,
      ) async {
    final Map<String, dynamic> dataObject = {};
    final Map domainCfg =
        OvcChildCasePlanConstant.domainToAutopopuledCasePlanGaps;

    List<CasePlanEvent> casePlans = await OvcCasePlanService().getCasePlanEvents(
      date: currentCasePlanDate,
      programStageId: OvcChildCasePlanConstant.casePlanProgramStage,
      teiId: child.id!,
    );
    casePlans = casePlans
        .where((cp) => domainCfg.keys.contains(cp.domainType))
        .toList();

    if (casePlans.isEmpty) {
      // No CP yet (this date) — use caregiver-derived selection
      dataObject.addAll(caregiverDataObjects);
      return dataObject;
    }

    // Existing CPs for this date — merge
    final List<CasePlanGapEvent> casePlanGaps =
    await OvcCasePlanService().getCasePlanGapEvents(
      date: currentCasePlanDate,
      programStageId: OvcChildCasePlanConstant.casePlanGapProgramStage,
      teiId: child.id!,
      casePlanToGaps:
      casePlans.map((cp) => cp.casePlanToGap).whereType<String>().toList(),
    );

    final Map<String, CasePlanEvent> cpByDomain = {
      for (final cp in casePlans) (cp.domainType ?? ''): cp,
    };

    for (final domainType in caregiverDataObjects.keys) {
      final Map<String, dynamic> caregiverDomain =
      Map<String, dynamic>.from(caregiverDataObjects[domainType]);
      final List caregiverGaps =
          (caregiverDomain['gaps'] as List?) ?? const [];

      final CasePlanEvent? existing = cpByDomain[domainType];

      if (existing != null) {
        final cpObj = existing.toDataObject();
        final linkageDe = OvcCasePlanConstant.casePlanToGapLinkage;

        // carry across existing child CP eventId & linkage
        final cpLinkage =
        (existing.casePlanToGap ?? cpObj['eventId'] ?? '').toString();
        if (cpLinkage.isNotEmpty) {
          caregiverDomain[linkageDe] = cpLinkage;
        }
        caregiverDomain['eventId'] = cpObj['eventId'];

        // Merge caregiver gaps with existing (field overlay)
        final existingGapsForLinkage = casePlanGaps
            .where((g) => (g.casePlanToGap ?? '') == cpLinkage)
            .map((g) => g.toDataObject())
            .toList();

        final merged = caregiverGaps.map<Map<String, dynamic>>((cg) {
          final cgm = Map<String, dynamic>.from(cg as Map);
          final found = existingGapsForLinkage.isNotEmpty
              ? Map<String, dynamic>.from(existingGapsForLinkage.first)
              : <String, dynamic>{};
          // overlay caregiver selection
          cgm.forEach((k, v) {
            if (k != 'eventId') found[k] = v;
          });
          found[linkageDe] = cpLinkage;
          return found;
        }).toList();

        caregiverDomain['gaps'] = merged;
        caregiverDomain[OvcCasePlanConstant.casePlanDomainType] = domainType;
        dataObject[domainType] = caregiverDomain;
      } else {
        // brand new domain CP for this date
        caregiverDomain[OvcCasePlanConstant.casePlanDomainType] = domainType;
        dataObject[domainType] = caregiverDomain;
      }
    }

    return dataObject;
  }

  // ---------- helpers ----------

  static Map<String, dynamic> _filterNewTrueToggles({
    required Map<String, dynamic> incoming,
    required Set<String> alreadyTrue,
  }) {
    final out = <String, dynamic>{};

    // always keep meta keys
    for (final k in [
      'eventDate',
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
    ]) {
      if (incoming.containsKey(k)) out[k] = incoming[k];
    }

    incoming.forEach((k, v) {
      if (out.containsKey(k)) return; // meta already copied
      if (_isTrue(v) && !alreadyTrue.contains(k)) {
        out[k] = true; // normalize to bool true
      }
    });

    // return empty if no new toggles
    final hasNew = out.keys.any((k) => !{
      'eventDate',
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
    }.contains(k));
    return hasNew ? out : <String, dynamic>{};
  }

  static bool _isTrue(dynamic v) {
    if (v is bool) return v;
    final s = (v ?? '').toString().trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
    // (anything else is treated as false)
  }

  static bool _hasAtLeastOneDE(Map<String, dynamic> m) {
    return m.keys.any((k) => !{
      'eventDate',
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
    }.contains(k));
  }

  static void _pruneFalsey(Map obj) {
    final keys = List.of(obj.keys);
    for (final k in keys) {
      final v = obj[k];
      final ok = (v is bool && v == true) ||
          (v is String && v.trim().isNotEmpty) ||
          (v is num && v != 0);
      if (!ok) obj.remove(k);
    }
  }

  /// Build map: linkage -> set of DEs that are already TRUE across ALL child GAP events
  static Future<Map<String, Set<String>>>
  _existingChildGapTrueTogglesAcrossAllEvents(String tei) async {
    final events =
    await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(tei);

    final stageId = OvcChildCasePlanConstant.casePlanGapProgramStage;
    final linkageDe = OvcCasePlanConstant.casePlanToGapLinkage;

    final res = <String, Set<String>>{};
    for (final e in events) {
      if (e.programStage != stageId) continue;

      String linkage = '';
      final dvs = (e.dataValues as List?) ?? const [];

      // linkage first
      for (final dv in dvs) {
        if (dv is Map && dv['dataElement'] == linkageDe) {
          linkage = (dv['value'] ?? '').toString();
          break;
        }
      }
      if (linkage.isEmpty) continue;

      final setForLink = res.putIfAbsent(linkage, () => <String>{});

      // collect TRUE toggles in this event
      for (final dv in dvs) {
        if (dv is! Map || dv['dataElement'] == null) continue;
        final de = dv['dataElement'] as String;
        final val = (dv['value'] ?? '').toString().trim().toLowerCase();
        if (val == 'true' || val == '1' || val == 'yes') {
          setForLink.add(de);
        }
      }
    }
    return res;
  }
}
