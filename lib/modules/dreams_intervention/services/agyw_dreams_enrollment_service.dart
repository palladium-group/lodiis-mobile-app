import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/core/offline_db/enrollment_offline/enrollment_offline_provider.dart';
import 'package:kb_mobile_app/core/offline_db/event_offline/event_offline_provider.dart';
import 'package:kb_mobile_app/core/offline_db/tracked_entity_instance_offline/tracked_entity_instance_offline_provider.dart';
import 'package:kb_mobile_app/core/services/organisation_unit_service.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/enrollment.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/none_participation_beneficiary.dart';
import 'package:kb_mobile_app/models/organisation_unit.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_eligible_not_enrollment.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_enrollment_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_none_participation_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_without_enrollment_criteria_constants.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/models/agyw_enrollment_consent.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/models/agyw_enrollment_form_section.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/models/agyw_enrollment_risk_assessment.dart';

class AgywDreamsEnrollmentService {
  final String program = 'hOEIHJDrrvz';
  final String trackedEntityType = 'XZIKX0bA8WN';
  final List<FormSection> riskAssessmentFormSections =
      AgywEnrollmentRiskAssessment.getFormSections();
  final List<FormSection> concentFormSections =
      AgywEnrollmentConcent.getFormSections();
  final List<FormSection> enrollmentFormSections =
      AgywEnrollmentFormSection.getFormSections();

  Future savingAgywBeneficiary(
      Map dataObject,
      String? trackedEntityInstance,
      String? orgUnit,
      String? enrollment,
      String? enrollmentDate,
      String? incidentDate,
      List<String> hiddenFields) async {
    List<String> inputFieldIds = hiddenFields;
    inputFieldIds.addAll(FormUtil.getFormFieldIds(riskAssessmentFormSections));
    inputFieldIds.addAll(FormUtil.getFormFieldIds(concentFormSections));
    inputFieldIds.addAll(FormUtil.getFormFieldIds(enrollmentFormSections));
    TrackedEntityInstance trackedEntityInstanceData =
        await FormUtil.geTrackedEntityInstanceEnrollmentPayLoad(
            trackedEntityInstance,
            trackedEntityType,
            orgUnit,
            inputFieldIds,
            dataObject,
            hasBeneficiaryId: false);
    await FormUtil.savingTrackedEntityInstance(trackedEntityInstanceData);
    Enrollment enrollmentData = FormUtil.getEnrollmentPayLoad(
        enrollment,
        enrollmentDate,
        incidentDate,
        orgUnit,
        program,
        trackedEntityInstance,
        dataObject);
    await FormUtil.savingEnrollment(enrollmentData);
  }

  Future updateAgywBeneficiaryStatus(
    Map dataObject,
    String? trackedEntityInstance,
    String? orgUnit,
    List<String> hiddenFields, {
    List<FormSection> formSections = const [],
  }) async {
    List<String> inputFieldIds = hiddenFields;
    inputFieldIds.addAll(FormUtil.getFormFieldIds(formSections));
    TrackedEntityInstance trackedEntityInstanceData =
        await FormUtil.geTrackedEntityInstanceEnrollmentPayLoad(
            trackedEntityInstance,
            trackedEntityType,
            orgUnit,
            inputFieldIds,
            dataObject,
            hasBeneficiaryId: false);
    await FormUtil.savingTrackedEntityInstance(trackedEntityInstanceData);
  }

  Future updateReAssessedAgywBeneficiary(
    Map dataObject,
    String? trackedEntityInstance,
    String? orgUnit,
    List<String> hiddenFields, {
    List<FormSection> formSections = const [],
  }) async {
    List<String> inputFieldIds = hiddenFields;
    inputFieldIds.addAll(FormUtil.getFormFieldIds(formSections));
    TrackedEntityInstance trackedEntityInstanceData =
        await FormUtil.geTrackedEntityInstanceEnrollmentPayLoad(
            trackedEntityInstance,
            trackedEntityType,
            orgUnit,
            inputFieldIds,
            dataObject,
            hasBeneficiaryId: false);
    await FormUtil.savingTrackedEntityInstance(trackedEntityInstanceData);

    List<Enrollment> enrollments = await EnrollmentOfflineProvider()
        .getEnrollmentsFromTeiList([trackedEntityInstance ?? '']);
    for (var enrollment in enrollments) {
      enrollment.shouldReAssess = '';
      await await EnrollmentOfflineProvider().addOrUpdateEnrollment(enrollment);
    }
  }

  Future<List<AgywDream>> getAgywBeneficiariesWithIncomingReferralList({
    int? page,
    List teiList = const [],
    Map searchedAttributes = const {},
  }) async {
    List<AgywDream> agywDreamList = [];
    try {
      List<String> accessibleOrgUnits = await OrganisationUnitService()
          .getOrganisationUnitAccessedByCurrentUser();
      List<Enrollment> enrollments =
          await EnrollmentOfflineProvider().getFilteredEnrollments(
        program,
        page: page,
        requiredTeiList: teiList as List<String>,
        searchedAttributes: searchedAttributes,
      );
      for (Enrollment enrollment in enrollments) {
        List<OrganisationUnit> ous = await OrganisationUnitService()
            .getOrganisationUnits([enrollment.orgUnit]);
        String? location = ous.isNotEmpty ? ous[0].name : enrollment.orgUnit;
        String? orgUnit = enrollment.orgUnit;
        String? createdDate = enrollment.enrollmentDate;
        String? enrollmentId = enrollment.enrollment;
        bool enrollmentOuAccessible = accessibleOrgUnits.contains(orgUnit);
        List<TrackedEntityInstance> trackedEntityInstances =
            await TrackedEntityInstanceOfflineProvider()
                .getTrackedEntityInstanceByIds(
                    [enrollment.trackedEntityInstance]);
        for (TrackedEntityInstance tei in trackedEntityInstances) {
          agywDreamList.add(AgywDream().fromTeiModel(tei, orgUnit, location,
              createdDate, enrollmentId, enrollmentOuAccessible));
        }
      }
    } catch (e) {
      //
    }
    return agywDreamList;
  }

  Future<List<AgywDream>> getAgywDreamsToReAssess(int page,
      {String searchableAttribute = ''}) async {
    List<AgywDream> agywDreamList = [];
    try {
      List<String> accessibleOrgUnits = await OrganisationUnitService()
          .getOrganisationUnitAccessedByCurrentUser();
      List<Enrollment> enrollments =
          await EnrollmentOfflineProvider().getEnrollmentToReassess(page: page);
      for (Enrollment enrollment in enrollments) {
        List<OrganisationUnit> ous = await OrganisationUnitService()
            .getOrganisationUnits([enrollment.orgUnit]);
        String? location = ous.isNotEmpty ? ous[0].name : enrollment.orgUnit;
        String? orgUnit = enrollment.orgUnit;
        String? createdDate = enrollment.enrollmentDate;
        String? enrollmentId = enrollment.enrollment;
        bool enrollmentOuAccessible = accessibleOrgUnits.contains(orgUnit);
        List<TrackedEntityInstance> trackedEntityInstances =
            await TrackedEntityInstanceOfflineProvider()
                .getTrackedEntityInstanceByIds(
                    [enrollment.trackedEntityInstance]);
        for (TrackedEntityInstance trackedEntityInstance
            in trackedEntityInstances) {
          agywDreamList.add(AgywDream().fromTeiModel(
            trackedEntityInstance,
            orgUnit,
            location,
            createdDate,
            enrollmentId,
            enrollmentOuAccessible,
          ));
        }
      }
    } catch (error) {
      //
    }

    if (searchableAttribute.isNotEmpty) {
      Map<String, dynamic> metadata = {
        'searchableAttribute': searchableAttribute,
        'agywDreamList': agywDreamList
      };
      agywDreamList = await compute(getFilteredAgywDreamsToReAssess, metadata);
    }
    return agywDreamList;
  }

  Future<List<AgywDream>> getAgywBeneficiaryList(
      {page,
      Map searchedAttributes = const {},
      List<Map<String, dynamic>> filters = const []}) async {
    List<AgywDream> agywDreamList = [];
    try {
      List<String> accessibleOrgUnits = await OrganisationUnitService()
          .getOrganisationUnitAccessedByCurrentUser();
      List<Enrollment> enrollments = await EnrollmentOfflineProvider()
          .getEnrollmentsByProgram(program,
              page: page, searchedAttributes: searchedAttributes);
      for (Enrollment enrollment in enrollments) {
        List<OrganisationUnit> ous = await OrganisationUnitService()
            .getOrganisationUnits([enrollment.orgUnit]);
        String? location = ous.isNotEmpty ? ous[0].name : enrollment.orgUnit;
        String? orgUnit = enrollment.orgUnit;
        String? createdDate = enrollment.enrollmentDate;
        String? enrollmentId = enrollment.enrollment;
        bool enrollmentOuAccessible = accessibleOrgUnits.contains(orgUnit);
        List<TrackedEntityInstance> trackedEntityInstances =
            await TrackedEntityInstanceOfflineProvider()
                .getTrackedEntityInstanceByIds(
                    [enrollment.trackedEntityInstance]);
        for (TrackedEntityInstance tei in trackedEntityInstances) {
          agywDreamList.add(AgywDream().fromTeiModel(tei, orgUnit, location,
              createdDate, enrollmentId, enrollmentOuAccessible));
        }
      }
    } catch (e) {
      //
    }
    if (filters.isNotEmpty) {
      Map<String, dynamic> metadata = {
        'filters': filters,
        'agywDreamList': agywDreamList
      };
      agywDreamList = await compute(filterAgywDreamsBeneficiaries, metadata);
    }

    return agywDreamList;
  }

// Helper function to parse age range into individual ages
  List<String> parseAgeRange(dynamic ageFilter) {
    List<String> ages = [];
    if (ageFilter is String && ageFilter.contains('-')) {
      List<String> ageBoundLimits = ageFilter.split('-');
      if (ageBoundLimits.length == 2) {
        int startAgeLimit = int.parse(ageBoundLimits.first);
        int endAgeLimit = int.parse(ageBoundLimits.last);
        for (int age = startAgeLimit; age <= endAgeLimit; age++) {
          ages.add(age.toString());
        }
      }
    } else if (ageFilter is String) {
      ages.add(ageFilter);
    } else if (ageFilter is List<String>) {
      ages = ageFilter;
    }
    return ages;
  }

  List<AgywDream> filterAgywDreamsBeneficiaries(Map<String, dynamic> metadata) {
    List<Map<String, dynamic>> filters =
        metadata['filters'] as List<Map<String, dynamic>>;
    List<AgywDream> agywDreamList =
        metadata['agywDreamList'] as List<AgywDream>;

    for (Map<String, dynamic> filter in filters) {
      String? implementingPartner = filter['implementingPartner'];
      dynamic ageFilterValue = filter['age'];
      String? sex = filter['sex'];
      agywDreamList = implementingPartner == null
          ? agywDreamList
          : agywDreamList
              .where((AgywDream agyw) =>
                  agyw.enrolledOrganisation == implementingPartner)
              .toList();

      if (ageFilterValue != null) {
        List<String> ageRanges = parseAgeRange(ageFilterValue);
        agywDreamList = agywDreamList.where((AgywDream agyw) {
          int? individualAge = int.tryParse(agyw.age ?? "0");
          return individualAge != null &&
              ageRanges.contains(individualAge.toString());
        }).toList();
      }

      // Sex filter
      agywDreamList = sex == null
          ? agywDreamList
          : agywDreamList.where((AgywDream agyw) => agyw.sex == sex).toList();
    }
    return agywDreamList;
  }

  List<AgywDream> getFilteredAgywDreamsToReAssess(
      Map<String, dynamic> metadata) {
    String searchableAttribute = metadata['searchableAttribute'] as String;
    List<AgywDream> agywDreamList =
        metadata['agywDreamList'] as List<AgywDream>;

    List<String> searchStrings = searchableAttribute.split(' ');

    agywDreamList = agywDreamList
        .where((AgywDream agywDream) => searchStrings.any((String attribute) =>
            (agywDream.searchableValue ?? '')
                .toLowerCase()
                .contains(attribute)))
        .toList();

    return agywDreamList;
  }

  Future<List<NoneParticipationBeneficiary>>
      getNoneParticipationBeneficiaryList(
          {page, Map searchedDataValues = const {}}) async {
    String programId = AgywDreamsEnrollmentNoneParticipationConstant.program;
    String programStageId =
        AgywDreamsEnrollmentNoneParticipationConstant.programStage;

    List<NoneParticipationBeneficiary> dreamsNoneParticipants =
        await EventOfflineProvider().getEventsByProgram(
            programId: programId,
            programStageId: programStageId,
            page: page,
            searchedDataValues: searchedDataValues);

    return dreamsNoneParticipants;
  }

  Future<List<NoneParticipationBeneficiary>>
      getEnrolledNotEligibleParticipationBeneficiaryList({
    page,
    Map searchedDataValues = const {},
  }) async {
    String programId = AgywDreamEnrollmentNotEligible.program;
    String programStageId = AgywDreamEnrollmentNotEligible.programStage;

    List<NoneParticipationBeneficiary> dreamsEnrollmentNotEligibleParticipants =
        await EventOfflineProvider().getEventsByProgram(
      programId: programId,
      programStageId: programStageId,
      page: page,
      searchedDataValues: searchedDataValues,
    );

    return dreamsEnrollmentNotEligibleParticipants;
  }

  Future<List<NoneParticipationBeneficiary>>
      getBeneficiariesWithoutEnrollmentCriteriaList(
          {page, Map searchedDataValues = const {}}) async {
    String programId = AgywDreamsWithoutEnrollmentCriteriaConstant.program;
    String programStageId =
        AgywDreamsWithoutEnrollmentCriteriaConstant.programStage;

    List<NoneParticipationBeneficiary> unenrolledDreamsBeneficiaries =
        await EventOfflineProvider().getEventsByProgram(
            programId: programId,
            programStageId: programStageId,
            page: page,
            searchedDataValues: searchedDataValues);

    return unenrolledDreamsBeneficiaries;
  }

  Future<int> getBeneficiariesWithoutEnrollmentCriteriaCount() async {
    String programId = AgywDreamsWithoutEnrollmentCriteriaConstant.program;
    String programStageId =
        AgywDreamsWithoutEnrollmentCriteriaConstant.programStage;

    return await EventOfflineProvider().getEventsByProgramCount(
        programId: programId, programStageId: programStageId);
  }

  Future<int> getNoneParticipationCount() async {
    String programId = AgywDreamsEnrollmentNoneParticipationConstant.program;
    String programStageId =
        AgywDreamsEnrollmentNoneParticipationConstant.programStage;

    return await EventOfflineProvider().getEventsByProgramCount(
        programId: programId, programStageId: programStageId);
  }

  Future<int> getAgywBeneficiaryCount() async {
    return await EnrollmentOfflineProvider().getEnrollmentsCount(program);
  }

  Future<int> getCountOfAgywBeneficiaryForReAssessment() async {
    String program = AgywDreamsEnrollmentConstant.program;
    return await EnrollmentOfflineProvider()
        .getEnrollmentToReassessCount(program);
  }

  Future<int> getEnrolledNotEligibleParticipationCount() async {
    String programId = AgywDreamEnrollmentNotEligible.program;
    String programStageId = AgywDreamEnrollmentNotEligible.programStage;
    return await EventOfflineProvider().getEventsByProgramCount(
        programId: programId, programStageId: programStageId);
  }

  Future<int> getIncomingReferralAgywBeneficiaryCount(
      List<String> filteredTei) async {
    return await EnrollmentOfflineProvider()
        .getFilteredEnrollmentsCount(program, filteredTei);
  }
}
