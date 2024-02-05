import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/offline_db/enrollment_offline/enrollment_offline_provider.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/enrollment.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/tei_relationship.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/models/ovc_enrollment_child.dart';

class OvcEnrollmentChildService {
  final List<FormSection> formSections = OvcEnrollmentChild.getFormSections(
      isEnrolmentDateEditable: true, enrollmentDate: '');

  Future updateOvcStatus({
    String? trackedEntityInstance,
    String? orgUnit,
    Map dataObject = const {},
  }) async {
    String programStatusId = 'PN92g65TkVI';
    List<String> inputFieldIds = [programStatusId];
    TrackedEntityInstance trackedEntityInstanceData =
        await FormUtil.geTrackedEntityInstanceEnrollmentPayLoad(
            trackedEntityInstance,
            OvcInterventionConstant.trackedEntityType,
            orgUnit,
            inputFieldIds,
            dataObject,
            hasBeneficiaryId: false);
    await FormUtil.savingTrackedEntityInstance(trackedEntityInstanceData);
  }

  Future savingChildrenEnrollmentForms(
    String? parentTrackedEntityInstance,
    String? orgUnit,
    List<Map> childrenObjects,
    String? enrollmentDate,
    String? incidentDate,
    bool shouldEnroll,
    List<String> hiddenFields,
  ) async {
    CurrentUser? user = await UserService().getCurrentUser();
    hiddenFields = hiddenFields;
    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    inputFieldIds.addAll(hiddenFields);
    inputFieldIds.addAll([
      UserAccountReference.implementingPartnerAttribute,
      UserAccountReference.serviceProviderAttribute,
      UserAccountReference.subImplementingPartnerAttribute
    ]);
    List childTeiReferences = [];
    for (Map dataObject in childrenObjects) {
      dataObject[UserAccountReference.implementingPartnerAttribute] =
          dataObject[UserAccountReference.implementingPartnerAttribute] ??
              user!.implementingPartner;
      dataObject[UserAccountReference.serviceProviderAttribute] =
          dataObject[UserAccountReference.serviceProviderAttribute] ??
              user!.username;
      if (user!.subImplementingPartner != '') {
        dataObject[UserAccountReference.subImplementingPartnerAttribute] =
            dataObject[UserAccountReference.subImplementingPartnerAttribute] ??
                user.subImplementingPartner;
      }
      String trackedEntityInstance =
          dataObject['trackedEntityInstance'] ?? AppUtil.getUid();
      String? enrollment = dataObject['enrollment'];
      childTeiReferences.add(trackedEntityInstance);
      TrackedEntityInstance trackedEntityInstanceData =
          await FormUtil.geTrackedEntityInstanceEnrollmentPayLoad(
        trackedEntityInstance,
        OvcInterventionConstant.trackedEntityType,
        orgUnit,
        inputFieldIds,
        dataObject,
        hasBeneficiaryId: false,
      );
      await FormUtil.savingTrackedEntityInstance(trackedEntityInstanceData);
      if (shouldEnroll) {
        Enrollment enrollmentData = FormUtil.getEnrollmentPayLoad(
          enrollment,
          enrollmentDate,
          incidentDate,
          orgUnit,
          OvcInterventionConstant.ovcProgramprogram,
          trackedEntityInstance,
          dataObject,
        );
        await FormUtil.savingEnrollment(enrollmentData);
      }
    }
    for (String childTeiReference in childTeiReferences) {
      TeiRelationship teiRelationshipData = FormUtil.getTeiRelationshipPayload(
          OvcInterventionConstant.relationshipType,
          parentTrackedEntityInstance,
          childTeiReference);
      await FormUtil.savingTeiRelationship(teiRelationshipData);
    }
  }

  Future<int> getOvcCount() async {
    return await EnrollmentOfflineProvider()
        .getEnrollmentsCount(OvcInterventionConstant.ovcProgramprogram);
  }
}
