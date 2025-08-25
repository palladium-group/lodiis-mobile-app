import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_case_plan.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';

class OvcCasePlanGapHouseholdToOvcUtil {
  static Future autoSyncOvcsCasPlanGaps({
    required String currentCasePlanDate,
    required List<OvcHouseholdChild> childrens,
    required Map dataObject,
    required String orgUnit,
    required String eventDate,
  }) async {
    try {
      final allCasePlanSections =
      OvcServicesCasePlan.getFormSections(firstDate: '');
      final allGapSections =
      OvcServicesChildCasePlanGap.getFormSections(firstDate: '');

      for (final child in childrens) {
        final childTei = (child.id ?? '').toString();
        if (childTei.isEmpty) continue;

        final perChild = getSanitizedCaregiverDataObjects(
          dataObject: dataObject,
          child: child,
        );
        if (perChild.isEmpty) {
          if (kDebugMode) {
            debugPrint('[HH→Child] No age-eligible caregiver gaps for TEI=$childTei');
          }
          continue;
        }

        final childEvents =
        await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(childTei);

        for (final domain in perChild.keys) {
          final Map<String, dynamic> domainData =
          Map<String, dynamic>.from(perChild[domain] as Map);

          // linkage from domain or first gap
          final linkageDe = OvcCasePlanConstant.casePlanToGapLinkage;
          String? linkageValue = _readLinkValue(domainData, linkageDe);
          linkageValue ??= _readLinkageFromFirstGap(domainData, linkageDe);
          if (linkageValue == null) {
            if (kDebugMode) {
              debugPrint('[HH→Child] Skip domain="$domain" TEI=$childTei: missing linkage');
            }
            continue;
          }

          // sections / field ids (fallback to full list if filter is empty)
          var domainCasePlanSections =
          allCasePlanSections.where((s) => s.id == domain).toList();
          if (domainCasePlanSections.isEmpty) {
            domainCasePlanSections = allCasePlanSections;
          }
          final casePlanFieldIds = FormUtil.getFormFieldIds(domainCasePlanSections);

          var domainGapSections =
          allGapSections.where((s) => s.id == domain).toList();
          if (domainGapSections.isEmpty) {
            domainGapSections = allGapSections;
          }
          final gapFieldIds = FormUtil.getFormFieldIds(domainGapSections);

          // ================= CASE PLAN =================
          final existingCasePlan = _findEventByLinkage(
            events: childEvents,
            programStageId: OvcChildCasePlanConstant.casePlanProgramStage,
            linkageDe: linkageDe,
            linkageValue: linkageValue,
          );

          final casePlanIncoming =
          Map<String, dynamic>.from(domainData)..remove('gaps');

          final mergedCasePlan = _mergeExistingWithIncoming(
            existingEvent: existingCasePlan,
            incoming: casePlanIncoming,
            keepKeys: casePlanFieldIds,
            ensureKeys: <String, dynamic>{
              linkageDe: linkageValue,
              'eventDate': currentCasePlanDate,
              // NEW: ensure domain type is set so UI can group/display it
              OvcCasePlanConstant.casePlanDomainType: domain,
            },
          );

          final skippedCasePlan =
          _skippedFromSection(casePlanFieldIds, mergedCasePlan);

          if (kDebugMode) {
            debugPrint(
                '[HH→Child] CASEPLAN save TEI=$childTei domain=$domain linkage=$linkageValue keep=${casePlanFieldIds.length} set=${mergedCasePlan.keys.length} skip=${skippedCasePlan.length} updating=${existingCasePlan?.event != null}');
          }

          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            OvcChildCasePlanConstant.program,
            OvcChildCasePlanConstant.casePlanProgramStage,
            orgUnit,
            domainCasePlanSections,
            mergedCasePlan,
            eventDate,
            childTei,
            existingCasePlan?.event,
            <String>[
              OvcCasePlanConstant.casePlanToGapLinkage,
              OvcCasePlanConstant.casePlanDomainType, // keep domain hidden on form
            ],
            skippedFields: skippedCasePlan,
          );

          // ================= GAPS =================
          final List gaps = List.from((perChild[domain]['gaps']) ?? const []);
          if (gaps.isEmpty) continue;

          final mergedGapPayload =
          _mergeGapsForSameLinkage(gaps, linkageDe, linkageValue)
            ..['c'] = currentCasePlanDate;

          final existingGap = _findEventByLinkage(
            events: childEvents,
            programStageId: OvcChildCasePlanConstant.casePlanGapProgramStage,
            linkageDe: linkageDe,
            linkageValue: linkageValue,
          );

          final mergedGap = _mergeExistingWithIncoming(
            existingEvent: existingGap,
            incoming: mergedGapPayload,
            keepKeys: gapFieldIds,
            ensureKeys: <String, dynamic>{
              linkageDe: linkageValue,
              // keep linkage chain if already set, otherwise allow payload to seed
              OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage:
              existingGap == null
                  ? mergedGapPayload[OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage]
                  : _getDeValue(existingGap, OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage),
              OvcCasePlanConstant.casePlanGapToMonitoringLinkage:
              existingGap == null
                  ? mergedGapPayload[OvcCasePlanConstant.casePlanGapToMonitoringLinkage]
                  : _getDeValue(existingGap, OvcCasePlanConstant.casePlanGapToMonitoringLinkage),
            },
          );

          final skippedGap = _skippedFromSection(gapFieldIds, mergedGap);

          if (kDebugMode) {
            debugPrint(
                '[HH→Child] GAP save TEI=$childTei domain=$domain linkage=$linkageValue gapsIn=${gaps.length} set=${mergedGap.keys.length} skip=${skippedGap.length} updating=${existingGap?.event != null}');
          }

          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            OvcChildCasePlanConstant.program,
            OvcChildCasePlanConstant.casePlanGapProgramStage,
            orgUnit,
            domainGapSections,
            mergedGap,
            eventDate,
            childTei,
            existingGap?.event,
            <String>[
              OvcCasePlanConstant.casePlanToGapLinkage,
              OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
              OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
            ],
            skippedFields: skippedGap,
          );
        }
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[HH→Child] autoSyncOvcsCasPlanGaps error: $e\n$st');
      }
    }
  }

  // ---------- Sanitizer ----------
  static Map<String, dynamic> getSanitizedCaregiverDataObjects({
    required Map dataObject,
    required OvcHouseholdChild child,
  }) {
    final Map<String, dynamic> sanitized = <String, dynamic>{};
    final int age = int.tryParse((child.age ?? '').toString()) ?? 0;

    final List<String> domains =
    OvcChildCasePlanConstant.domainToAutopopuledCasePlanGaps.keys.toList();

    for (final String domain in domains) {
      final Map domainCfg =
          OvcChildCasePlanConstant.domainToAutopopuledCasePlanGaps[domain] ?? {};
      final List<String> validIds =
      OvcChildCasePlanConstant.getValidIdForAutoPopulatingServiceData(
        domainConfig: domainCfg,
        age: age,
      );

      final Map<String, dynamic> selected =
      Map<String, dynamic>.from((dataObject[domain] ?? const {}) as Map);

      final List gaps = List.from(selected['gaps'] ?? const []);
      if (gaps.isEmpty) continue;

      final keptGaps = <Map<String, dynamic>>[];
      for (final g in gaps) {
        final Map<String, dynamic> gap = Map<String, dynamic>.from(g as Map);
        final filtered = <String, dynamic>{};
        for (final key in gap.keys) {
          final k = key.toString();
          if (validIds.contains(k) || _isLinkageDe(k) || _isDomainDe(k)) {
            filtered[k] = gap[key];
          }
        }
        if (filtered.isNotEmpty) keptGaps.add(filtered);
      }
      if (keptGaps.isEmpty) continue;

      final filteredSelected = <String, dynamic>{};
      for (final key in selected.keys) {
        final k = key.toString();
        if (k == 'gaps') continue;
        if (validIds.contains(k) || _isLinkageDe(k) || _isDomainDe(k)) {
          filteredSelected[k] = selected[key];
        }
      }
      filteredSelected['gaps'] = keptGaps;

      // NEW: if caregiver payload didn’t carry domain type, stamp it here
      filteredSelected[OvcCasePlanConstant.casePlanDomainType] =
          filteredSelected[OvcCasePlanConstant.casePlanDomainType] ?? domain;

      sanitized[domain] = filteredSelected;
    }
    return sanitized;
  }

  // ---------- Helpers ----------
  static String? _readLinkValue(Map<String, dynamic> m, String de) {
    final v = (m[de] ?? '').toString().trim();
    return v.isEmpty ? null : v;
  }

  static String? _readLinkageFromFirstGap(Map<String, dynamic> m, String de) {
    final gaps = List.from(m['gaps'] ?? const []);
    for (final g in gaps) {
      final gap = Map<String, dynamic>.from(g as Map);
      final v = (gap[de] ?? '').toString().trim();
      if (v.isNotEmpty) return v;
    }
    return null;
  }

  static Events? _findEventByLinkage({
    required List<Events> events,
    required String programStageId,
    required String linkageDe,
    required String linkageValue,
  }) {
    for (final e in events) {
      if (e.programStage != programStageId) continue;
      final list = (e.dataValues as List?) ?? const [];
      for (final dv in list) {
        if (dv is Map &&
            (dv['dataElement']?.toString() == linkageDe) &&
            (dv['value']?.toString() == linkageValue)) {
          return e;
        }
      }
    }
    return null;
  }

  static Map<String, dynamic> _mergeExistingWithIncoming({
    required Events? existingEvent,
    required Map<String, dynamic> incoming,
    required List<String> keepKeys,
    Map<String, dynamic> ensureKeys = const {},
  }) {
    final base = existingEvent == null ? <String, dynamic>{} : _eventValueMap(existingEvent);

    final kept = <String, dynamic>{};
    for (final k in base.keys) {
      if (keepKeys.contains(k) || _isLinkageDe(k) || _isDomainDe(k) || k == 'eventDate' || k == 'eventId') {
        kept[k] = base[k];
      }
    }

    final merged = Map<String, dynamic>.from(kept);
    incoming.forEach((key, val) {
      if (!(keepKeys.contains(key) || _isLinkageDe(key) || _isDomainDe(key) || key == 'eventDate')) {
        return;
      }
      if (_isBoolLike(val)) {
        merged[key] = _isTruthy(merged[key]) || _isTruthy(val);
      } else if ((val ?? '').toString().trim().isNotEmpty) {
        merged[key] = val;
      }
    });

    ensureKeys.forEach((k, v) {
      if (v != null) merged[k] = v;
    });

    if (existingEvent?.event != null) merged['eventId'] = existingEvent!.event;
    return merged;
  }

  static Map<String, dynamic> _eventValueMap(Events e) {
    final m = <String, dynamic>{};
    final list = (e.dataValues as List?) ?? const [];
    for (final dv in list) {
      if (dv is Map && dv['dataElement'] != null) {
        m[dv['dataElement'] as String] = dv['value'];
      }
    }
    if (e.eventDate != null) m['eventDate'] = e.eventDate;
    if (e.event != null) m['eventId'] = e.event;
    return m;
  }

  static Map<String, dynamic> _mergeGapsForSameLinkage(
      List gaps,
      String linkageDe,
      String linkageValue,
      ) {
    final out = <String, dynamic>{linkageDe: linkageValue};
    for (final g in gaps) {
      final gap = Map<String, dynamic>.from(g as Map);
      for (final key in gap.keys) {
        final k = key.toString();
        if (k == linkageDe) continue;
        if (_isLinkageDe(k) || _isDomainDe(k)) {
          out[k] ??= gap[key];
          continue;
        }
        final v = gap[key];
        if (_isBoolLike(v)) {
          out[k] = _isTruthy(out[k]) || _isTruthy(v);
        } else if ((v ?? '').toString().trim().isNotEmpty) {
          out[k] = v;
        }
      }
    }
    return out;
  }

  static List<String> _skippedFromSection(
      List<String> sectionFieldIds,
      Map<String, dynamic> payload,
      ) {
    final keep = payload.keys.map((e) => e.toString()).toSet();
    return sectionFieldIds.where((id) => !keep.contains(id)).toList();
  }

  static bool _isLinkageDe(String key) {
    return key == OvcCasePlanConstant.casePlanToGapLinkage ||
        key == OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage ||
        key == OvcCasePlanConstant.casePlanGapToMonitoringLinkage;
  }

  // NEW: consider domain type a required/display key
  static bool _isDomainDe(String key) {
    return key == OvcCasePlanConstant.casePlanDomainType;
  }

  static String? _getDeValue(Events? e, String de) {
    if (e == null) return null;
    final list = (e.dataValues as List?) ?? const [];
    for (final dv in list) {
      if (dv is Map && dv['dataElement']?.toString() == de) {
        return (dv['value'] ?? '').toString();
      }
    }
    return null;
  }

  static bool _isBoolLike(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    return {'true', 'false', '1', '0', 'yes', 'no'}.contains(s);
  }

  static bool _isTruthy(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }
}
