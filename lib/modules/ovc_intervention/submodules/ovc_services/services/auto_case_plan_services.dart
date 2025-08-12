import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_case_plan.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';
import '../ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';

class AutoCasePlanService {
  /// Call this after a Household Assessment saves successfully.
  static Future<void> saveFromAssessment({
    required String teiId,
    required String orgUnit,
    required String firstDate, // household.createdDate
    required Map assessmentData,
  }) async {
    // 1) Build domain packages (you can extend with more rules below)
    final String eventDate = AppUtil.formattedDateTimeIntoString(DateTime.now());
    final List<_DomainPackage> pkgs = _mapAssessmentToDomains(assessmentData, eventDate);
    if (pkgs.isEmpty) {
      print('⚠️ Auto-CP: no domains triggered');
      return;
    }

    // Load sections once (same as manual)
    final cpAll = OvcServicesCasePlan.getFormSections(firstDate: firstDate);
    final gapAll = OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: firstDate);

    for (final _DomainPackage pkg in pkgs) {
      // --- Case Plan (domain) ---
      final List<FormSection> cpSections =
      cpAll.where((s) => s.id == pkg.domainId).toList();

      // Hidden fields MUST be passed like in manual form (positional last arg)
      final cpHiddenFields = <String>[
        OvcCasePlanConstant.casePlanToGapLinkage, // ajqTV28fydL
        OvcCasePlanConstant.casePlanDomainType,   // vexrPNgPBYg
      ];

      print('🧭 CP sections for ${pkg.domainId}: ${cpSections.expand((s) => s.inputFields!.map((f) => f.id)).toList()}');
      print('📤 Saving CP payload: ${pkg.casePlanData}');
      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        OvcHouseholdCasePlanConstant.program,
        OvcHouseholdCasePlanConstant.casePlanProgramStage,
        orgUnit,
        cpSections,
        pkg.casePlanData,
        eventDate,
        teiId,
        '', // new event
        cpHiddenFields, // << positional hiddenFields (like manual)
      );

      // --- Case Plan Gaps (domain) ---
      final List<FormSection> gapSections =
      gapAll.where((s) => s.id == pkg.domainId).toList();

      final gapHiddenFields = <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,                 // ajqTV28fydL
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage, // tDWIRBsuwsB
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,       // H7BMnqZEqGN
      ];

      for (final gap in pkg.gaps) {
        print('🧭 GAP sections for ${pkg.domainId}: ${gapSections.expand((s) => s.inputFields!.map((f) => f.id)).toList()}');
        print('📤 Saving GAP payload: $gap');
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          OvcHouseholdCasePlanConstant.program,
          OvcHouseholdCasePlanConstant.casePlanGapProgramStage,
          orgUnit,
          gapSections,
          gap,
          eventDate,
          teiId,
          '', // new event
          gapHiddenFields, // << positional hiddenFields (like manual)
        );
      }
    }

    print('✅ Auto-CP: saved ${pkgs.length} domain(s) on $eventDate');
  }

  /// Map assessment → one or more domain packages.
  /// Each package mirrors the manual structure: linkage + domain + gaps.
  static List<_DomainPackage> _mapAssessmentToDomains(Map a, String eventDate) {
    final out = <_DomainPackage>[];

    // --------- EXAMPLE RULE: HEALTH ----------
    // If blod3xZ2dPP == '1' then set HKCv7lkLexo (Health gap)
    if (a['blod3xZ2dPP'] == '1') {
      final link = AppUtil.getUid();             // ajqTV28fydL
      const domainId = 'Health';                 // must match section.id from CP & GAP models

      final cpData = <String, dynamic>{
        'eventDate': eventDate,
        OvcCasePlanConstant.casePlanToGapLinkage: link, // ajqTV28fydL
        OvcCasePlanConstant.casePlanDomainType: domainId, // vexrPNgPBYg
        'ADc3clrQRl4': 'Auto goal (Health)', // Goal 1 so CP isn’t empty
        // 'efNgDIqhlNs': 'Optional Goal 2',
      };

      final gap = <String, dynamic>{
        'eventDate': eventDate,
        OvcCasePlanConstant.casePlanToGapLinkage: link, // SAME linkage
        'HKCv7lkLexo': 'true',                          // gap DE (string)
        // 'JzlLk2tW4xh': eventDate,                    // optional due date
      };

      out.add(_DomainPackage(domainId: domainId, casePlanData: cpData, gaps: [gap]));
    }

    // --------- ADD MORE RULES HERE ----------
    // Example SAFE/STABLE/SCHOOLED mappings:
    // if (a['someSafeKey'] == 'Yes')  -> domainId: 'Safe',    gaps: [{'SAFE_DE_UID': 'true'}]
    // if (a['incomeLow']  == 'true')  -> domainId: 'Stable',  gaps: [{'STABLE_DE_UID': 'true'}]
    // if (a['childOutOfSchool']=='1')-> domainId: 'Schooled', gaps: [{'SCHOOLED_DE_UID':'true'}]

    return out;
  }
}

class _DomainPackage {
  final String domainId; // e.g. 'Health' | 'Safe' | 'Stable' | 'Schooled'
  final Map<String, dynamic> casePlanData;
  final List<Map<String, dynamic>> gaps;
  _DomainPackage({
    required this.domainId,
    required this.casePlanData,
    required this.gaps,
  });
}
