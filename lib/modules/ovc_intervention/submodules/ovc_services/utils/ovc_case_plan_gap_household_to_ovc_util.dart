
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
  /// Propagate selected HH case-plan gaps to every eligible child.
  /// - Ensures a **linkage** is present on the child container before saving
  /// - Stamps the same linkage on every child gap
  /// - **Dedupes** child gaps by (linkage + selected toggles)
  static Future<void> autoSyncOvcsCasPlanGaps({
    required String currentCasePlanDate,
    required List<OvcHouseholdChild> childrens,
    required Map dataObject, // HH case-plan dataObject
    required String orgUnit,
    required String eventDate,
  }) async {
    try {
      final List<FormSection> casePlanSections =
      OvcServicesCasePlan.getFormSections(firstDate: '');

      for (final child in childrens) {
        // Build the caregiver selection filtered by child's age
        final sanitized = _getSanitizedCaregiverSelectionForChild(
          caregiverDataObject: dataObject,
          child: child,
        );
        if (sanitized.isEmpty) {
          continue;
        }

        // Merge with existing child CP for the same "currentCasePlanDate"
        final merged = await _mergeIntoChildForDate(
          currentCasePlanDate: currentCasePlanDate,
          child: child,
          caregiverSelection: sanitized,
        );

        // Persist per domain
        for (final domainType in merged.keys) {
          final Map<String, dynamic> domainCP =
          Map<String, dynamic>.from(merged[domainType] as Map);

          // Always stamp domain on the child container (used by list renderers)
          domainCP[OvcCasePlanConstant.casePlanDomainType] = domainType;

          // Ensure linkage on the container BEFORE saving
          final linkageDe = OvcCasePlanConstant.casePlanToGapLinkage;
          String cpLinkage = (domainCP[linkageDe] ?? '').toString().trim();
          if (cpLinkage.isEmpty) {
            cpLinkage = AppUtil.getUid();
            domainCP[linkageDe] = cpLinkage;
          }

          // Get sections
          final List<FormSection> domainFormSections =
          casePlanSections.where((s) => s.id == domainType).toList();
          final List<FormSection> domainGapSections =
          OvcServicesChildCasePlanGap.getFormSections(firstDate: '')
              .where((s) => s.id == domainType)
              .toList();

          // Remove transient keys
          final String? existingEventId =
          (domainCP['eventId'] ?? '').toString().trim().isEmpty
              ? null
              : domainCP['eventId'].toString();
          domainCP.remove('eventId');

          // Save/Update child container
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            OvcChildCasePlanConstant.program,
            OvcChildCasePlanConstant.casePlanProgramStage,
            orgUnit,
            domainFormSections,
            domainCP,
            eventDate,
            child.id,
            existingEventId, // update if there is one
            const [
              OvcCasePlanConstant.casePlanToGapLinkage,
              OvcCasePlanConstant.casePlanDomainType,
            ],
          );

          // Dedupe & save child gaps
          final List gaps = (domainCP['gaps'] as List?) ?? const [];
          if (gaps.isEmpty) continue;

          final existingForLinkage =
          await OvcCasePlanService().getCasePlanGapEvents(
            date: currentCasePlanDate,
            programStageId: OvcChildCasePlanConstant.casePlanGapProgramStage,
            teiId: child.id!,
            casePlanToGaps: [cpLinkage],
          );

          final toggleIds = _collectToggleIds(domainGapSections);
          final existingSignatures = <String>{};
          for (final e in existingForLinkage) {
            existingSignatures.add(
              _gapSignature(Map<String, dynamic>.from(e.toDataObject()), toggleIds),
            );
          }

          int saved = 0;
          for (final g in gaps) {
            final gap = Map<String, dynamic>.from(g as Map);

            // stamp linkage to match container
            gap[linkageDe] = cpLinkage;

            // never rely on container eventId as linkage; use cpLinkage above
            gap.remove('eventId');

            final sig = _gapSignature(gap, toggleIds);
            if (sig.isEmpty || existingSignatures.contains(sig)) continue;

            await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
              OvcChildCasePlanConstant.program,
              OvcChildCasePlanConstant.casePlanGapProgramStage,
              orgUnit,
              domainGapSections,
              gap,
              eventDate,
              child.id,
              null,
              const [
                OvcCasePlanConstant.casePlanToGapLinkage,
                OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
                OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
              ],
            );
            existingSignatures.add(sig);
            saved++;
          }

          // Debug
          // ignore: avoid_print
          print('[HH→Child] ${child.id} domain=$domainType linkage=$cpLinkage saved=$saved');
        }
      }
    } catch (_) {
      // swallow – don't break HH save flow
    }
  }

  // ---------- helpers ----------

  static Map<String, dynamic> _getSanitizedCaregiverSelectionForChild({
    required Map caregiverDataObject,
    required OvcHouseholdChild child,
  }) {
    // Age gating – re-use your constant map
    final Map<String, Map> cfg =
        OvcChildCasePlanConstant.domainToAutopopuledCasePlanGaps;

    int age = int.tryParse((child.age ?? '').toString()) ?? 0;
    final out = <String, dynamic>{};

    for (final domain in cfg.keys) {
      final selected = Map<String, dynamic>.from(
        (caregiverDataObject[domain] ?? {}) as Map,
      );
      if (selected.isEmpty) continue;

      // keep only fields that are "valid for age"
      final List<String> valid =
      OvcChildCasePlanConstant.getValidIdForAutoPopulatingServiceData(
        domainConfig: cfg[domain] ?? {},
        age: age,
      );

      final keptGaps = <Map<String, dynamic>>[];
      final List gaps = (selected['gaps'] as List?) ?? const [];
      for (final g in gaps) {
        final m = Map<String, dynamic>.from(g as Map);
        final filtered = <String, dynamic>{};
        for (final k in m.keys) {
          if (valid.contains(k)) filtered[k] = m[k];
        }
        if (filtered.isNotEmpty) keptGaps.add(filtered);
      }
      if (keptGaps.isEmpty) continue;

      final container = <String, dynamic>{};
      for (final k in selected.keys) {
        if (valid.contains(k)) container[k] = selected[k];
      }
      // preserve linkage if HH already has one – helps "same plan" semantics
      final lk = OvcCasePlanConstant.casePlanToGapLinkage;
      if ((selected[lk] ?? '').toString().trim().isNotEmpty) {
        container[lk] = selected[lk];
      }
      container['gaps'] = keptGaps;
      out[domain] = container;
    }
    return out;
  }

  static Future<Map<String, dynamic>> _mergeIntoChildForDate({
    required String currentCasePlanDate,
    required OvcHouseholdChild child,
    required Map<String, dynamic> caregiverSelection,
  }) async {
    final out = <String, dynamic>{};

    // Pull existing child CP for that date
    List<CasePlanEvent> childPlans = await OvcCasePlanService().getCasePlanEvents(
      date: currentCasePlanDate,
      programStageId: OvcChildCasePlanConstant.casePlanProgramStage,
      teiId: child.id!,
    );

    // Map by domain for quick lookup
    final byDomain = <String, CasePlanEvent>{};
    for (final cp in childPlans) {
      final d = cp.domainType ?? '';
      if (d.isNotEmpty) byDomain[d] = cp;
    }

    // For each caregiver domain, either hydrate existing or prepare a fresh one
    for (final domain in caregiverSelection.keys) {
      final Map<String, dynamic> cg = Map<String, dynamic>.from(
        caregiverSelection[domain] as Map,
      );
      final cp = byDomain[domain];

      if (cp == null) {
        // No child CP yet for this domain/date – pass caregiver selection
        out[domain] = cg;
        continue;
      }

      // Merge gaps on top of existing (by linkage alignment only; dedupe happens on save)
      final obj = cp.toDataObject();
      final linkageDe = OvcCasePlanConstant.casePlanToGapLinkage;
      final cpLink = (cp.casePlanToGap ?? obj['eventId'] ?? '').toString();

      final existingGaps = await OvcCasePlanService().getCasePlanGapEvents(
        date: currentCasePlanDate,
        programStageId: OvcChildCasePlanConstant.casePlanGapProgramStage,
        teiId: child.id!,
        casePlanToGaps: [cpLink],
      );

      final existingObjs = existingGaps.map((e) => e.toDataObject()).toList();

      final mergedGaps = <Map<String, dynamic>>[];
      final List cgGaps = (cg['gaps'] as List?) ?? const [];
      for (final g in cgGaps) {
        final m = Map<String, dynamic>.from(g as Map);
        // force the container linkage onto gap
        m[linkageDe] = cpLink;
        // simple overlay (dedupe handled during save by signature)
        mergedGaps.add(m);
      }

      obj['gaps'] = mergedGaps;
      obj[OvcCasePlanConstant.casePlanToGapLinkage] = cpLink;
      obj[OvcCasePlanConstant.casePlanDomainType] = domain;
      out[domain] = obj;
    }

    return out;
  }

  static Set<String> _collectToggleIds(List<FormSection> gapSections) {
    final ids = <String>{};
    for (final s in gapSections) {
      for (final f in (s.inputFields ?? const [])) {
        ids.add(f.id);
      }
    }
    ids.removeAll({
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      'eventId',
      'eventDate',
      'location',
    });
    return ids;
  }

  static String _gapSignature(
      Map<String, dynamic> gap,
      Set<String> candidateIds,
      ) {
    final on = <String>[];
    for (final id in candidateIds) {
      final v = (gap[id] ?? '').toString().toLowerCase();
      if (v == 'true' || v == '1' || v == 'yes') on.add(id);
    }
    on.sort();
    return on.join('|');
  }
}

