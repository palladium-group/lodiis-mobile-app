
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

class OvcCasePlanHouseholdToOvcUtil {
  /// Safely coerce any dynamic to int (handles int, String like "9", null).
  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    final s = v.toString().trim();
    final i = int.tryParse(s);
    return i ?? fallback;
  }

  static int _coerceAge(OvcHouseholdChild child) {
    // Age is usually stored as String on the model
    final a = _asInt(child.age, fallback: 0);
    return a >= 0 ? a : 0;
  }

  static String _childName(OvcHouseholdChild c) {
    // Try best-effort human-friendly name
    final parts = <String>[];
    if ((c.firstName ?? '').trim().isNotEmpty) parts.add(c.firstName!.trim());
    if ((c.surname ?? '').trim().isNotEmpty) parts.add(c.surname!.trim());
    final name = parts.join(' ');
    if (name.isNotEmpty) return name;
    // Fallback to TEI or uid-ish printable
    return c.id ?? c.toString();
  }

  /// Build list of valid DE ids (generic + age-based), coercing min/max ages safely.
  static List<String> _validIdsForChildAge({
    required Map domainConfig,
    required int age,
  }) {
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
    return valid.toSet().toList(); // dedupe
  }

  /// Ensure child has a CP container (domain event) with the cpLink
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

    // Minimal payload to persist the container and linkage
    final payload = <String, dynamic>{
      OvcCasePlanConstant.casePlanToGapLinkage: cpLink,
      OvcCasePlanConstant.casePlanDomainType: domainId,
      'eventDate': eventDate,
    };

    await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
      OvcChildCasePlanConstant.program,
      OvcChildCasePlanConstant.casePlanProgramStage,
      orgUnit,
      containerSections,
      payload,
      eventDate,
      tei.trackedEntityInstance,
      null, // create if none
      <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanDomainType,
      ],
    );
  }

  /// Create a child GAP event filtered to valid DEs for that child's age.
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

    final allow = <String>{
      ...allowedIds,
      // Always keep linkages + eventDate if present
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      'eventDate',
    };

    final toSave = <String, dynamic>{};
    hhGapObject.forEach((k, v) {
      final ks = k.toString();
      if (!allow.contains(ks)) return;
      if (v == null) return;
      if (v is bool && v == false) return;
      if (v is String && v.trim().isEmpty) return;
      toSave[ks] = v;
    });

    // Force required link + date
    toSave[OvcCasePlanConstant.casePlanToGapLinkage] = cpLink;
    toSave['eventDate'] = eventDate;

    await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
      OvcChildCasePlanConstant.program,
      OvcChildCasePlanConstant.casePlanGapProgramStage,
      orgUnit,
      gapSections,
      toSave,
      eventDate,
      tei.trackedEntityInstance,
      null, // create
      <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      ],
    );
  }

  /// Public API used by your form after saving HH CPs.
  ///
  /// For each child:
  ///  - compute age safely (no casts),
  ///  - determine age-eligible + generic DEs for domain,
  ///  - ensure a child CP container exists with the same cpLink,
  ///  - create a child GAP event filtered to valid DEs.
  static Future<void> autoSyncHHGapsToChildren({
    required List<OvcHouseholdChild> children,
    required Map<String, dynamic> hhGapObject,
    required String domainId,
    required String orgUnit,
    required String eventDate,
  }) async {
    final cpLinkDe = OvcCasePlanConstant.casePlanToGapLinkage;
    String cpLink = (hhGapObject[cpLinkDe] ?? '').toString().trim();
    if (cpLink.isEmpty) cpLink = AppUtil.getUid();

    // domain config for GAP propagation
    final Map domainCfg =
        OvcChildCasePlanConstant.domainToAutopopuledCasePlanGaps[domainId] ??
            const <String, dynamic>{};

    for (final child in children) {
      try {
        final tei = child.teiData;
        if (tei == null) continue;

        final age = _coerceAge(child);
        final ids = _validIdsForChildAge(domainConfig: domainCfg, age: age);

        if (ids.isEmpty && (domainCfg['generic'] ?? const []) is! List) {
          if (kDebugMode) {
            debugPrint(
                '[GAP Propagation] No age-eligible HH gap fields for child ${_childName(child)} in "$domainId". Skip.');
          }
          continue;
        }

        // 1) ensure child has a CP container with that link
        await _ensureChildCasePlanContainer(
          domainId: domainId,
          cpLink: cpLink,
          orgUnit: orgUnit,
          eventDate: eventDate,
          tei: tei,
        );

        // 2) create the child GAP event filtered by age/generic DEs
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
              '[GAP Propagation] Created child gap for ${_childName(child)} (domain="$domainId").');
        }
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint(
              '[GAP Propagation] ERROR for child ${_childName(child)} => $e');
          debugPrint('$st');
        }
        // continue with next child
      }
    }
  }
}

