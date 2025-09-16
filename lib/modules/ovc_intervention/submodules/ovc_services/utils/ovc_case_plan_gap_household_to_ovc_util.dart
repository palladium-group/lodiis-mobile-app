
import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_util.dart';

class OvcCasePlanGapHouseholdToOvcUtil {
  /// Propagate **household** case plan gaps to **children** for each domain found
  /// in `dataObject`. Applies **age-based + generic** configs from
  /// `OvcChildCasePlanConstant.domainToAutopopuledCasePlanGaps`.
  ///
  /// We upsert a child GAP event that carries the same
  /// `casePlanToGapLinkage` as the household’s container so later services can
  /// be tied correctly.
  static Future<void> autoSyncOvcsCasPlanGaps({
    required String currentCasePlanDate, // not used to filter; kept for parity
    required List<OvcHouseholdChild> childrens,
    required Map dataObject,            // household case plan form object
    required String orgUnit,            // household orgUnit (fallback)
    required String eventDate,          // household case plan date
  }) async {
    try {
      // helper: allowed IDs for age per domain config
      List<String> _validIdsForAge(String domainId, int age) {
        final domainConfig = OvcChildCasePlanConstant
            .domainToAutopopuledCasePlanGaps[domainId] ??
            const <String, dynamic>{};
        return OvcChildCasePlanConstant.getValidIdForAutoPopulatingServiceData(
          domainConfig: domainConfig,
          age: age,
        );
      }

      // helper: merge HH domain gaps into one Map (truthy and non-empty only)
      Map<String, dynamic> _mergeHouseholdGaps(Map domainMap) {
        final merged = <String, dynamic>{};
        final gaps = (domainMap['gaps'] as List?) ?? const [];
        for (final g in gaps) {
          final m = Map<String, dynamic>.from(g as Map);
          m.forEach((k, v) {
            final ks = '$k';
            if (v == null) return;
            if (v is bool && v == false) return;
            if (v is String && v.trim().isEmpty) return;
            // first one wins to keep intent (no override of existing)
            merged.putIfAbsent(ks, () => v);
          });
        }
        return merged;
      }

      // child GAP form sections (per domain)
      List<FormSection> _childGapSections(String domainId) {
        return OvcServicesChildCasePlanGap.getFormSections(firstDate: '')
            .where((s) => (s.id ?? '') == domainId)
            .toList();
      }

      const hiddenGapFields = <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      ];

      for (final entry in dataObject.entries) {
        final domainId = '${entry.key}';
        // skip non-domain sections
        if (domainId == OvcCasePlanConstant.casePlanLocatinSectionId ||
            domainId == OvcCasePlanConstant.casePlanEventDateSectionId ||
            domainId == OvcCasePlanConstant.householdCategorizationSection) {
          continue;
        }

        final domainMap = Map<String, dynamic>.from(entry.value as Map);
        // Need the CP linkage for this domain; derive if missing
        String cpLinkage = (domainMap[OvcCasePlanConstant.casePlanToGapLinkage] ?? '')
            .toString()
            .trim();
        if (cpLinkage.isEmpty) {
          cpLinkage =
          (domainMap['eventId'] ?? '').toString().trim().isNotEmpty
              ? domainMap['eventId']
              : AppUtil.getUid();
        }

        // merge HH gap flags/dates to a single map
        final hhMergedGap = _mergeHouseholdGaps(domainMap);

        for (final child in childrens) {
          final tei = child.teiData;
          if (tei == null) continue;

          // child age
          final int age = int.tryParse(child.age ?? '0') ?? 0;
          final allowed = _validIdsForAge(domainId, age).toSet();

          // Build payload for child gap: allowed items present on HH
          final childGap = <String, dynamic>{};
          hhMergedGap.forEach((k, v) {
            final ks = '$k';
            if (!allowed.contains(ks)) return;
            childGap[ks] = v;
          });

          // Always include link + date so it groups and is queryable
          childGap[OvcCasePlanConstant.casePlanToGapLinkage] = cpLinkage;
          // NOTE: we intentionally DO NOT set SP/MON linkages here;
          // SP util will patch child's gap with SP linkage when a household service is saved.

          // If no meaningful data (besides linkage), skip creating noise
          final keys = childGap.keys.toSet();
          final onlyLink =
              keys.length <= 1 && keys.contains(OvcCasePlanConstant.casePlanToGapLinkage);
          if (onlyLink) {
            if (kDebugMode) {
              debugPrint(
                  '[GAP Propagation] No age-eligible HH gap fields for child ${child.id} in "$domainId". Skip.');
            }
            continue;
          }

          // Upsert: find existing child gap by the same CP linkage
          final existing = await OvcCasePlanUtil.getCasePlanGapsForLinkage(
            teiId: tei.trackedEntityInstance ?? '',
            programStageId: OvcChildCasePlanConstant.casePlanGapProgramStage,
            linkage: cpLinkage,
          );

          final sections = _childGapSections(domainId);
          final childOrg = tei.orgUnit ?? orgUnit;
          final childEventDate = eventDate; // same day as HH container

          try {
            await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
              OvcChildCasePlanConstant.program,
              OvcChildCasePlanConstant.casePlanGapProgramStage,
              childOrg,
              sections,
              childGap,
              childEventDate,
              tei.trackedEntityInstance,
              existing.isNotEmpty ? existing.first.eventData?.event : null,
              hiddenGapFields,
            );
            if (kDebugMode) {
              debugPrint(
                  '[GAP Propagation] ${existing.isEmpty ? 'Created' : 'Updated'} child gap for ${child.id} (domain="$domainId").');
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint(
                  '[GAP Propagation] Failed for child ${child.id} in "$domainId": $e');
            }
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
