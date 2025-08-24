import 'package:kb_mobile_app/core/services/organisation_unit_service.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

// To avoid auto-adding IP/username/device DEs when we want a truly minimal event
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';

import '../ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';

class AutoCasePlanService {
  /// Create or update a minimal Household Case Plan when an Assessment is saved.
  /// Idempotent per Assessment eventId:
  /// - If linked case plan exists => no new event; update date if changed.
  /// - Else => create:
  ///    * eventDate
  ///    * OvcCasePlanConstant.casePlanFromAssessmentLinkage = assessment eventId (hidden DE)
  static Future<void> saveFromAssessment({
    required String teiId,
    required String orgUnit,
    required String firstDate, // (kept for compatibility; unused here)
    required Map assessmentData,
  }) async {
    final String eventDate = (assessmentData['eventDate'] ?? '').toString().trim();
    final String assessmentEventId = (assessmentData['eventId'] ?? '').toString().trim();
    if (eventDate.isEmpty || assessmentEventId.isEmpty) return;

    final accessibleOrgUnits =
    await OrganisationUnitService().getOrganisationUnitAccessedByCurrentUser();

    final List<Events> allEvents =
    await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(
      teiId,
      accessibleOrgUnits: accessibleOrgUnits,
    );

    const String stageId = OvcHouseholdCasePlanConstant.casePlanProgramStage;
    const String linkageDe = OvcCasePlanConstant.casePlanFromAssessmentLinkage;

    // 1) Look for an existing Case Plan already linked to this assessment
    Events? linkedCasePlan;
    for (final e in allEvents.where((e) => e.programStage == stageId)) {
      final List dvs = (e.dataValues as List?) ?? const [];
      final hasLink = dvs.any((dv) =>
      dv is Map &&
          dv['dataElement'] == linkageDe &&
          (dv['value']?.toString() ?? '') == assessmentEventId);
      if (hasLink) {
        linkedCasePlan = e;
        break;
      }
    }

    // 2a) If exists: update eventDate if it changed; else do nothing
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
          skippedFields: [
            UserAccountReference.implementingPartnerDataElement,
            UserAccountReference.subImplementingPartnerDataElement,
            UserAccountReference.serviceProviderDataElement,
            UserAccountReference.appAndDeviceTrackingDataElement,
          ],
        );
      }
      return; // ✔️ done (no duplicate)
    }

    // 2b) Else: create a new minimal Case Plan event (date + hidden linkage)
    const List<FormSection> emptySections = [];
    final Map<String, dynamic> dataObject = {
      'eventDate': eventDate,
      linkageDe: assessmentEventId, // <-- the idempotency key
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
      skippedFields: [
        UserAccountReference.implementingPartnerDataElement,
        UserAccountReference.subImplementingPartnerDataElement,
        UserAccountReference.serviceProviderDataElement,
        UserAccountReference.appAndDeviceTrackingDataElement,
      ],
    );
  }
}
