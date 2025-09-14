import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';

class OvcCasePlanServiceProvisionHouseholdToOvcUtil {
  /// Copy HH Service Provision to each eligible child’s SP, **only if** that child
  /// already has a case-plan gap with the same CP linkage.
  static Future<void> autoSyncOvcsCasePlanServiceProvisions({
    required List<OvcHouseholdChild> childrens,
    required Map hhSpObject,
    required String domainId,
    required String orgUnit,
    required String eventDate,
  }) async {
    final cpLink = (hhSpObject[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString().trim();
    final spLink = (hhSpObject[OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage] ?? '').toString().trim();

    if (cpLink.isEmpty || spLink.isEmpty) {
      if (kDebugMode) {
        debugPrint('[SP Propagation] Missing linkage(s) cp="$cpLink" sp="$spLink". Abort.');
      }
      return;
    }

    for (final child in childrens) {
      final tei = child.teiData;
      if (tei == null) continue;

      // 1) Confirm the child has a GAP with matching CP linkage
      final childEvents = await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(tei.trackedEntityInstance);
      final String gapStage = OvcChildCasePlanConstant.casePlanGapProgramStage;

      final childHasMatchingGap = childEvents.any((e) {
        if ((e.programStage ?? '') != gapStage) return false;
        final dvs = (e.dataValues as List?) ?? const [];
        for (final dv in dvs) {
          if (dv is Map) {
            final de = (dv['dataElement'] ?? '').toString();
            final val = (dv['value'] ?? '').toString();
            if (de == OvcCasePlanConstant.casePlanToGapLinkage && val == cpLink) {
              return true;
            }
          }
        }
        return false;
      });

      if (!childHasMatchingGap) {
        if (kDebugMode) {
          debugPrint('[SP Propagation] Child ${tei.trackedEntityInstance} has no matching gap (cp=$cpLink). Skipping.');
        }
        continue;
      }

      // 2) Age-based filter of fields to copy
      final int age = int.parse(child.age ?? '');
      final domainCfg = OvcChildCasePlanConstant.domainToAutopopuledCasePlanServiceProvision[domainId] ?? {};
      final ids = OvcChildCasePlanConstant.getValidIdForAutoPopulatingServiceData(
        domainConfig: domainCfg,
        age: age,
      );

      // Always carry these
      final copyKeys = <String>{
        'eventDate',
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        OvcCasePlanConstant.casePlanToGapLinkage,
        ...ids,
      };

      final childPayload = <String, dynamic>{
        OvcCasePlanConstant.casePlanToGapLinkage: cpLink,
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage: spLink,
      };

      hhSpObject.forEach((k, v) {
        if (copyKeys.contains(k) && v != null && v.toString().isNotEmpty) {
          childPayload[k] = v;
        }
      });

      // 3) Save child SP event
      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          OvcChildCasePlanConstant.program,
          OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage,
          orgUnit,
          /* We don’t have the full child form sections here; pass empty and rely on payload */
          const [],
          childPayload,
          hhSpObject['eventDate'] ?? eventDate,
          tei.trackedEntityInstance,
          null,
          [
            OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
            OvcCasePlanConstant.casePlanToGapLinkage,
          ],
        );
        if (kDebugMode) {
          debugPrint('[SP Propagation] Created child service for ${tei.trackedEntityInstance} (domain="$domainId").');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[SP Propagation][ERROR] Child ${tei.trackedEntityInstance}: $e');
        }
      }
    }
  }
}
