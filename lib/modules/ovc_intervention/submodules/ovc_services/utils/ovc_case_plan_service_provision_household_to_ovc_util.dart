
import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_util.dart';

class OvcCasePlanServiceProvisionHouseholdToOvcUtil {
  /// Propagate a **household** service provision to **children** that:
  ///  1) have a GAP with the same case-plan linkage, and
  ///  2) have age-eligible service DEs per domain config.
  /// Also **patches the child GAP** with the SP linkage (if missing) so that
  /// child services render under the correct gap.
  static Future<void> autoSyncOvcsCasePlanServiceProvisions({
    required List<OvcHouseholdChild> childrens,
    required Map dataObject, // household service payload
    required String domainId,
    required String orgUnit,
    required String eventDate,
  }) async {
    try {
      final cpLinkage =
      (dataObject[OvcCasePlanConstant.casePlanToGapLinkage] ?? '')
          .toString()
          .trim();
      final spLinkage =
      (dataObject[OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage] ??
          '')
          .toString()
          .trim();

      if (cpLinkage.isEmpty || spLinkage.isEmpty) {
        if (kDebugMode) {
          debugPrint(
              '[SP Propagation] Missing linkage(s) cp="$cpLinkage" sp="$spLinkage". Abort.');
        }
        return;
      }

      // sections for updating child GAP (to add SP linkage)
      final gapSections = OvcServicesChildCasePlanGap.getFormSections(firstDate: '')
          .where((s) => (s.id ?? '') == domainId)
          .toList();

      const hiddenGapFields = <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      ];
      const hiddenServiceFields = <String>[
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      ];

      List<String> _validIdsForAge(int age) {
        final domainConfig = OvcChildCasePlanConstant
            .domainToAutopopuledCasePlanServiceProvision[domainId] ??
            const <String, dynamic>{};
        return OvcChildCasePlanConstant.getValidIdForAutoPopulatingServiceData(
          domainConfig: domainConfig,
          age: age,
        );
      }

      for (final child in childrens) {
        final tei = child.teiData;
        if (tei == null) continue;

        // must have child gap with same cp linkage
        final childGaps = await OvcCasePlanUtil.getCasePlanGapsForLinkage(
          teiId: tei.trackedEntityInstance ?? '',
          programStageId:
          OvcChildCasePlanConstant.casePlanGapProgramStage,
          linkage: cpLinkage,
        );
        if (childGaps.isEmpty) {
          if (kDebugMode) {
            debugPrint(
                '[SP Propagation] Child ${child.id} has no matching gap (cp=$cpLinkage). Skipping.');
          }
          continue;
        }

        // ensure child gap has SP linkage
        final gapEvent = childGaps.first;
        final hasSpLink = ((gapEvent.eventData?.dataValues ?? []) as List)
            .any((dv) =>
        dv is Map &&
            dv['dataElement'] ==
                OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage &&
            ('${dv['value']}'.trim().isNotEmpty));
        if (!hasSpLink) {
          final patch = <String, dynamic>{
            'eventId': gapEvent.eventData?.event,
            OvcCasePlanConstant.casePlanToGapLinkage: cpLinkage,
            OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage: spLinkage,
          };
          try {
            await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
              OvcChildCasePlanConstant.program,
              OvcChildCasePlanConstant.casePlanGapProgramStage,
              tei.orgUnit ?? orgUnit,
              gapSections,
              patch,
              gapEvent.eventData?.eventDate ?? eventDate,
              tei.trackedEntityInstance,
              gapEvent.eventData?.event,
              hiddenGapFields,
            );
            if (kDebugMode) {
              debugPrint(
                  '[SP Propagation] Patched child gap SP linkage for ${child.id}.');
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint(
                  '[SP Propagation] Failed to patch SP linkage for ${child.id}: $e');
            }
          }
        }

        // build child service using allowed DEs only
        final int age = int.tryParse(child.age ?? '0') ?? 0;
        final allowed = _validIdsForAge(age).toSet();

        final childService = <String, dynamic>{};
        dataObject.forEach((k, v) {
          final ks = '$k';
          if (!allowed.contains(ks)) return;
          if (v == null) return;
          if (v is bool && v == false) return;
          if (v is String && v.trim().isEmpty) return;
          childService[ks] = v;
        });

        // Always include SP linkage + eventDate
        childService[OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage] =
            spLinkage;
        final String childEventDate =
        (childService['eventDate'] ?? '$eventDate').toString();

        // skip if nothing besides required fields
        final ks = childService.keys.toSet();
        final requiredOnly =
            ks.length <= 2 &&
                ks.contains('eventDate') &&
                ks.contains(OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage);
        if (requiredOnly) {
          if (kDebugMode) {
            debugPrint(
                '[SP Propagation] No age-eligible service fields for ${child.id}. Skipping.');
          }
          continue;
        }

        try {
          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            OvcChildCasePlanConstant.program,
            OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage,
            tei.orgUnit ?? orgUnit,
            const <FormSection>[],
            childService,
            childEventDate,
            tei.trackedEntityInstance,
            null,
            hiddenServiceFields,
          );
          if (kDebugMode) {
            debugPrint(
                '[SP Propagation] Created child service for ${child.id} (domain="$domainId").');
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint(
                '[SP Propagation] Failed to create child service for ${child.id}: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SP Propagation] Fatal error: $e');
      }
    }
  }
}
