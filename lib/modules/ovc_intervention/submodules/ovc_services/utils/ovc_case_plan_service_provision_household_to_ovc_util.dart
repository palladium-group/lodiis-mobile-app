
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';

import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';

class OvcCasePlanServiceProvisionHouseholdToOvcUtil {
  static const String _cpKey = OvcCasePlanConstant.casePlanToGapLinkage;
  static const String _spKey = OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;

  /// Propagate HH Service Provision to all eligible children:
  /// - child must have a GAP with the same CP link
  /// - DEs filtered by age-based + generic service-provision allow-list
  static Future<void> autoSyncOvcsCasePlanServiceProvisions({
    required List<OvcHouseholdChild> children,
    required Map<dynamic, dynamic> hhSpObject,
    required String domainId,
    required String orgUnit,
    required String eventDate,
  }) async {
    if (children.isEmpty) return;

    // We need CP & SP to be meaningful
    final cp = (hhSpObject[_cpKey] ?? '').toString();
    final sp = (hhSpObject[_spKey] ?? '').toString();
    if (cp.isEmpty || sp.isEmpty) {
      if (kDebugMode) {
        debugPrint('[SP Propagation] Missing linkage(s) cp="$cp" sp="$sp". Abort.');
      }
      return;
    }

    // Build allowed DEs for the domain from child config (service-provision map)
    final Map domainCfg =
        OvcChildCasePlanConstant.domainToAutopopuledCasePlanServiceProvision[domainId] ?? {};
    if (domainCfg.isEmpty) return;

    for (final child in children) {
      final age = child.age ?? 0;

      final allow = <String>[
        ...(domainCfg['generic'] as List? ?? const []),
        ..._ageBasedIds(domainCfg['ageBased'], int.parse(age.toString())),
      ].map((e) => '$e').toList();

      // Make sure the child has a GAP with this CP link
      final hasChildGap = await _childHasMatchingGap(child, cp);
      if (!hasChildGap) {
        if (kDebugMode) {
          debugPrint('[SP Propagation] Child ${child.id} has no matching gap (cp=$cp). Skipping.');
        }
        continue;
      }

      // Build the SP payload for the child
      final payload = <String, dynamic>{};
      hhSpObject.forEach((k, v) {
        if (!allow.contains(k)) return;
        if (_isFalsy(v)) return;
        payload[k] = v;
      });

      if (payload.isEmpty) continue;

      // Carry over linkages
      payload[_cpKey] = cp;
      payload[_spKey] = sp;
      payload['eventDate'] = eventDate;

      // Build section with those DEs
      final section = _stubSection(payload.keys.toList());

      // Save child SP event
      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        OvcChildCasePlanConstant.program,
        OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage,
        orgUnit,
        section,
        payload,
        payload['eventDate'],
        child.teiData?.trackedEntityInstance ?? '',
        null,
        const [_cpKey, _spKey],
      );

      if (kDebugMode) {
        debugPrint('[SP Propagation] Created child service for ${child.id} (domain="$domainId").');
      }
    }
  }

  // ---------- helpers ----------

  static bool _isFalsy(dynamic v) {
    if (v == null) return true;
    if (v is bool) return v == false;
    if (v is String) return v.trim().isEmpty || v.trim().toLowerCase() == 'false';
    return false;
  }

  static List<String> _ageBasedIds(dynamic cfg, int age) {
    final out = <String>[];
    final list = (cfg as List?) ?? const [];
    for (final item in list) {
      if (item is Map) {
        final minAge = (item['minAge'] ?? 0) as int;
        final maxAge = (item['maxAge'] ?? 999) as int;
        if (age >= minAge && age < maxAge) {
          out.addAll((item['ids'] as List? ?? const []).map((e) => '$e'));
        }
      }
    }
    return out;
  }

  static List<FormSection> _stubSection(List<String> ids) {
    return [
      FormSection(
        id: 'auto_sp_child',
        name: 'auto_sp_child',
        color: const Color(0x00000000),
        borderColor: const Color(0x00000000),
        inputFields: ids
            .map((id) => InputField(
          id: id,
          name: id,
          valueType: 'TEXT',
        ))
            .toList(),
        subSections: const [],
      )
    ];
  }

  static Future<bool> _childHasMatchingGap(OvcHouseholdChild child, String cp) async {
    final events = await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(
      child.teiData?.trackedEntityInstance ?? '',
    );
    final stage = OvcChildCasePlanConstant.casePlanGapProgramStage;
    for (final  e in events) {
      if (e.programStage != stage) continue;
      final dvs = (e.dataValues ?? []) as List;
      for (final dv in dvs) {
        if (dv is Map &&
            (dv['dataElement'] ?? '') == _cpKey &&
            (dv['value'] ?? '') == cp) {
          return true;
        }
      }
    }
    return false;
  }
}
