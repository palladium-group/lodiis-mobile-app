
import 'package:kb_mobile_app/core/services/organisation_unit_service.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_household_assessment_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';

// Keep the CP event minimal: skip auto audit fields
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';

class AutoCasePlanService {
  /// Create/update a minimal Household Case Plan when an Assessment is saved.
  /// Idempotent per Assessment eventId:
  /// - If a CP linked to this assessment exists => update date if needed.
  /// - Else => create one with eventDate + hidden linkage DE.
  static Future<void> saveFromAssessment({
    required String teiId,
    required String orgUnit,
    required String firstDate, // kept for compatibility (unused)
    required Map assessmentData,
  }) async {
    final String eventDate =
    (assessmentData['eventDate'] ?? '').toString().trim();
    if (eventDate.isEmpty) return;

    // 1) Ensure we have the assessment eventId (resolve if missing on first save)
    String assessmentEventId =
    (assessmentData['eventId'] ?? '').toString().trim();
    if (assessmentEventId.isEmpty) {
      final resolved = await _resolveAssessmentEventId(
        teiId: teiId,
        eventDate: eventDate,
      );
      if (resolved == null || resolved.isEmpty) return;
      assessmentEventId = resolved;
    }

    // 2) Pull all events for TEI (search for an existing CP linked to this assessment)
    final accessibleOrgUnits = await OrganisationUnitService()
        .getOrganisationUnitAccessedByCurrentUser();
    final List<Events> allEvents =
    await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(
      teiId,
      accessibleOrgUnits: accessibleOrgUnits,
    );

    const String cpStage = OvcHouseholdCasePlanConstant.casePlanProgramStage;
    const String linkageDe = OvcCasePlanConstant.casePlanFromAssessmentLinkage;

    // 3) Try to find an existing CP linked to this assessment
    Events? linkedCasePlan;
    for (final e in allEvents.where((e) => e.programStage == cpStage)) {
      final List dvs = (e.dataValues as List?) ?? const [];
      final hasLink = dvs.any(
            (dv) =>
        dv is Map &&
            dv['dataElement'] == linkageDe &&
            (dv['value']?.toString() ?? '') == assessmentEventId,
      );
      if (hasLink) {
        linkedCasePlan = e;
        break;
      }
    }

    // 4a) If exists: update eventDate if it changed; else nothing to do
    if (linkedCasePlan != null) {
      final String currentDate = linkedCasePlan.eventDate ?? '';
      if (currentDate != eventDate) {
        const List<FormSection> emptySections = [];
        final Map<String, dynamic> dataObject = {
          'eventDate': eventDate,
          linkageDe: assessmentEventId, // keep linkage intact
        };
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          OvcHouseholdCasePlanConstant.program,
          OvcHouseholdCasePlanConstant.casePlanProgramStage,
          orgUnit,
          emptySections,
          dataObject,
          eventDate,
          teiId,
          linkedCasePlan.event, // update existing event
          null,
          skippedFields: _skipAuditDes,
        );
      }
      return; // done
    }

    // 4b) Else: create a new minimal CP (date + hidden linkage)
    const List<FormSection> emptySections = [];
    final Map<String, dynamic> dataObject = {
      'eventDate': eventDate,
      linkageDe: assessmentEventId,
    };
    await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
      OvcHouseholdCasePlanConstant.program,
      OvcHouseholdCasePlanConstant.casePlanProgramStage,
      orgUnit,
      emptySections,
      dataObject,
      eventDate,
      teiId,
      null, // create
      null,
      skippedFields: _skipAuditDes,
    );
  }

  /// Resolve the assessment eventId when it isn’t in the form yet by looking up
  /// the assessment event saved for this TEI on the same date.
  static Future<String?> _resolveAssessmentEventId({
    required String teiId,
    required String eventDate,
  }) async {
    final accessibleOrgUnits = await OrganisationUnitService()
        .getOrganisationUnitAccessedByCurrentUser();
    final List<Events> allEvents =
    await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(
      teiId,
      accessibleOrgUnits: accessibleOrgUnits,
    );

    // Candidates: assessments on the same date
    final candidates = allEvents.where((e) =>
    e.programStage == OvcHouseholdAssessmentConstant.programStage &&
        (e.eventDate ?? '') == eventDate);

    if (candidates.isEmpty) return null;

    // Pick the "most likely latest" without relying on lastUpdated
    final best = _mostLikelyLatest(candidates.toList());
    return (best.event ?? '').toString();
  }

  /// Heuristic to choose the most likely latest event without lastUpdated:
  /// - prefer not-cancelled
  /// - prefer with more dataValues
  /// - fallback to lexicographically larger event id
  static Events _mostLikelyLatest(List<Events> list) {
    Events? best;
    int bestScore = -0x7fffffff;

    for (final e in list) {
      int score = 0;

      // prefer not-cancelled
      final status = (e.status ?? '').toString().toUpperCase();
      if (status != 'CANCELLED') score += 10;

      // prefer with more payload
      final dvLen = ((e.dataValues as List?) ?? const []).length;
      score += dvLen;

      // tie-breaker by event id
      final id = (e.event ?? '') as String? ?? '';
      score += id.hashCode & 0x7fffffff; // stable-ish tiebreaker

      if (best == null || score > bestScore) {
        best = e;
        bestScore = score;
      }
    }
    return best!;
  }

  static const List<String> _skipAuditDes = [
    UserAccountReference.implementingPartnerDataElement,
    UserAccountReference.subImplementingPartnerDataElement,
    UserAccountReference.serviceProviderDataElement,
    UserAccountReference.appAndDeviceTrackingDataElement,
  ];
}

