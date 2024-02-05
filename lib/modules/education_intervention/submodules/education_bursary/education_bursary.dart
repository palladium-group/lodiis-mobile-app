import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_bursary_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_intervention_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/models/education_beneficiary.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/modules/education_intervention/components/education_beneficiary_card.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/constants/bursary_routes_constant.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/pages/education_bursary_assessment_form_page.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/pages/education_bursary_club_referral_home.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/pages/education_bursary_clubs_attendance_page.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/pages/education_bursary_enrollment_form_edit_page.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/pages/education_bursary_enrollment_view_page.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/pages/education_bursary_school_page.dart';
import 'package:provider/provider.dart';

class EducationBursary extends StatefulWidget {
  const EducationBursary({Key? key}) : super(key: key);

  @override
  State<EducationBursary> createState() => _EducationBursaryState();
}

class _EducationBursaryState extends State<EducationBursary> {
  final String title = 'BURSARY List';
  final bool canEdit = true;
  final bool canView = true;
  final bool canExpand = true;

  String? toggleCardId = '';
  void onCardToggle(BuildContext context, String? trackedEntityInstance) {
    toggleCardId = canExpand && trackedEntityInstance != toggleCardId
        ? trackedEntityInstance
        : '';
    setState(() {});
  }

  void onUpdateFormState(
    BuildContext context,
    EducationBeneficiary bursaryBeneficiary,
    bool isEditableMode,
  ) {
    Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
    Provider.of<EnrollmentFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    Provider.of<EnrollmentFormState>(context, listen: false).setFormFieldState(
        'location',
        isEditableMode
            ? bursaryBeneficiary.orgUnit
            : bursaryBeneficiary.location);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('trackedEntityInstance', bursaryBeneficiary.id);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('orgUnit', bursaryBeneficiary.orgUnit);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('enrollment', bursaryBeneficiary.enrollment);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('enrollmentDate', bursaryBeneficiary.createdDate);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('incidentDate', bursaryBeneficiary.createdDate);
    if (bursaryBeneficiary.trackedEntityInstanceData != null) {
      for (Map attributeObj
          in bursaryBeneficiary.trackedEntityInstanceData!.attributes) {
        Provider.of<EnrollmentFormState>(context, listen: false)
            .setFormFieldState(
                attributeObj['attribute'], attributeObj['value']);
      }
    }
  }

  void onAddBursaryBeneficiary(BuildContext context) async {
    String beneficiaryId = '';
    String formAutoSaveId =
        '${BursaryRoutesConstant.assessmentPageModule}_$beneficiaryId';
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave);
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const EducationBursaryAssessmentFormPage();
          },
        ),
      );
    }
  }

  void onViewBeneficiary(
    BuildContext context,
    EducationBeneficiary educationBeneficiary,
  ) {
    bool isEditableMode = false;
    onUpdateFormState(context, educationBeneficiary, isEditableMode);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const EducationBursaryEnrollmentViewPage();
        },
      ),
    );
  }

  void onEditBeneficiary(
    BuildContext context,
    EducationBeneficiary bursaryBeneficiary,
  ) async {
    String beneficiaryId = bursaryBeneficiary.id!;
    String formAutoSaveId =
        '${BursaryRoutesConstant.enrollmentEditPageModule}_$beneficiaryId';
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges =
        await AppResumeRoute().shouldResumeWithUnSavedChanges(
      context,
      formAutoSave,
      beneficiaryName: bursaryBeneficiary.toString(),
    );
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      bool isEditableMode = true;
      onUpdateFormState(context, bursaryBeneficiary, isEditableMode);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const EducationBursaryEnrollmentEditFormPage();
          },
        ),
      );
    }
  }

  void onOpenBeneficiarySchool(
    BuildContext context,
    EducationBeneficiary bursaryBeneficiary,
  ) {
    Provider.of<EducationInterventionCurrentSelectionState>(context,
            listen: false)
        .setCurrentBeneficiary(bursaryBeneficiary);
    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(bursaryBeneficiary.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const EducationBursarySchoolPage();
        },
      ),
    );
  }

  void onOpenBeneficiaryClub(
    BuildContext context,
    EducationBeneficiary bursaryBeneficiary,
  ) {
    Provider.of<EducationInterventionCurrentSelectionState>(context,
            listen: false)
        .setCurrentBeneficiary(bursaryBeneficiary);
    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(bursaryBeneficiary.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const EducationBursaryClubsAttendancePage();
        },
      ),
    );
  }

  void onOpenBursaryClubReferral(
    BuildContext context,
    EducationBeneficiary bursaryBeneficiary,
  ) {
    Provider.of<EducationInterventionCurrentSelectionState>(context,
            listen: false)
        .setCurrentBeneficiary(bursaryBeneficiary);
    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(bursaryBeneficiary.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const EducationBursaryClubReferralHome();
        },
      ),
    );
  }

  void refreshBeneficiaryList(
      EducationBursaryInterventionState educationBursaryInterventionState) {
    educationBursaryInterventionState.refreshEducationBursaryNumber();
  }

  Center _getEmptyListContainer(BuildContext context) {
    String? currentLanguage =
        Provider.of<LanguageTranslationState>(context, listen: false)
            .currentLanguage;
    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              currentLanguage == 'lesotho'
                  ? 'Ha ho na bana ba tholang lihlapiso ba ngolisitsoeng ka nako eo'
                  : 'There is no Bursary beneficiaries enrolled at the moment',
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/add-beneficiary.svg',
              colorFilter: const ColorFilter.mode(
                Colors.blueGrey,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => onAddBursaryBeneficiary(context),
          )
        ],
      ),
    );
  }

  Consumer<EducationBursaryInterventionState> _buildBody() {
    return Consumer<EducationBursaryInterventionState>(
      builder: (context, educationBursaryInterventionState, child) {
        return RefreshIndicator(
          onRefresh: () async =>
              refreshBeneficiaryList(educationBursaryInterventionState),
          child: CustomPaginatedListView(
            childBuilder: (context, bursaryBeneficiary, child) =>
                EducationBeneficiaryCard(
                    canEdit: canEdit,
                    canView: canView,
                    canExpand: canExpand,
                    isExpanded: toggleCardId == bursaryBeneficiary.id,
                    isLbseLearningOutcomeVisible: false,
                    isBursarySchoolVisible: true,
                    isBursaryClubVisible: true,
                    isBursaryClubReferralVisible: true,
                    educationBeneficiary: bursaryBeneficiary,
                    onEdit: () =>
                        onEditBeneficiary(context, bursaryBeneficiary),
                    onView: () =>
                        onViewBeneficiary(context, bursaryBeneficiary),
                    onCardToggle: () =>
                        onCardToggle(context, bursaryBeneficiary.id),
                    onOpenBursarySchool: () =>
                        onOpenBeneficiarySchool(context, bursaryBeneficiary),
                    onOpenBursaryClub: () =>
                        onOpenBeneficiaryClub(context, bursaryBeneficiary),
                    onOpenBursaryClubReferral: () =>
                        onOpenBursaryClubReferral(context, bursaryBeneficiary)),
            pagingController:
                educationBursaryInterventionState.pagingController!,
            emptyListWidget: _getEmptyListContainer(context),
            errorWidget: _getEmptyListContainer(context),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        bool isSesotho = languageTranslationState.currentLanguage == 'lesotho';
        return Consumer<EducationBursaryInterventionState>(
          builder: (context, educationBursaryInterventionState, child) {
            int maleCount = educationBursaryInterventionState
                    .numberOfEducationBursaryBySex["male"] ??
                0;
            int femaleCount = educationBursaryInterventionState
                    .numberOfEducationBursaryBySex["female"] ??
                0;
            String sexCountLabel = isSesotho
                ? '$maleCount Botona  $femaleCount Botsehali'
                : '$maleCount Male  $femaleCount Female';
            return SubModuleHomeContainer(
              header: '$title : $sexCountLabel',
              showFilter: true,
              bodyContents: _buildBody(),
            );
          },
        );
      },
    );
  }
}
