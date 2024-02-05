import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_intervention_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_lbse_state.dart';
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
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_lbse/constants/lbse_routes_constant.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_lbse/pages/education_lbse_enrollment_form_page.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_lbse/pages/education_lbse_learning_outcome_home.dart';
import 'package:provider/provider.dart';

class EducationLbse extends StatefulWidget {
  const EducationLbse({Key? key}) : super(key: key);

  @override
  State<EducationLbse> createState() => _EducationLbseState();
}

class _EducationLbseState extends State<EducationLbse> {
  final String title = 'LBSE List';
  final String translatedTitle = 'Lethathamo la LBSE';
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
    EducationBeneficiary lbseBeneficiary,
    bool isEditableMode,
  ) {
    Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
    Provider.of<EnrollmentFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    Provider.of<EnrollmentFormState>(context, listen: false).setFormFieldState(
        'location',
        isEditableMode ? lbseBeneficiary.orgUnit : lbseBeneficiary.location);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('trackedEntityInstance', lbseBeneficiary.id);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('orgUnit', lbseBeneficiary.orgUnit);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('enrollment', lbseBeneficiary.enrollment);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('enrollmentDate', lbseBeneficiary.createdDate);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('incidentDate', lbseBeneficiary.createdDate);
    if (lbseBeneficiary.trackedEntityInstanceData != null) {
      for (Map attributeObj
          in lbseBeneficiary.trackedEntityInstanceData!.attributes) {
        Provider.of<EnrollmentFormState>(context, listen: false)
            .setFormFieldState(
                attributeObj['attribute'], attributeObj['value']);
      }
    }
  }

  void onAddLbseBeneficiary(BuildContext context) async {
    String beneficiaryId = '';
    String formAutoSaveId =
        '${LbseRoutesConstant.enrollmentPageModule}_$beneficiaryId';
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave);
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
      redirectToLbseEnrollmentForm(context);
    }
  }

  void redirectToLbseEnrollmentForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const EducationLbseEnrollmentFormPage();
        },
      ),
    );
  }

  void onViewBeneficiary(
    BuildContext context,
    EducationBeneficiary educationBeneficiary,
  ) {
    bool isEditableMode = false;
    onUpdateFormState(context, educationBeneficiary, isEditableMode);
    redirectToLbseEnrollmentForm(context);
  }

  void onEditBeneficiary(
    BuildContext context,
    EducationBeneficiary lbseBeneficiary,
  ) async {
    String beneficiaryId = lbseBeneficiary.id!;
    String formAutoSaveId =
        '${LbseRoutesConstant.enrollmentPageModule}_$beneficiaryId';
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges =
        await AppResumeRoute().shouldResumeWithUnSavedChanges(
      context,
      formAutoSave,
      beneficiaryName: lbseBeneficiary.toString(),
    );
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      bool isEditableMode = true;
      onUpdateFormState(context, lbseBeneficiary, isEditableMode);
      redirectToLbseEnrollmentForm(context);
    }
  }

  void onOpenBeneficiaryLearningOutcome(
    BuildContext context,
    EducationBeneficiary lbseBeneficiary,
  ) {
    Provider.of<EducationInterventionCurrentSelectionState>(context,
            listen: false)
        .setCurrentBeneficiary(lbseBeneficiary);
    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(lbseBeneficiary.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const EducationLbseLearningOutcomeHome();
        },
      ),
    );
  }

  void refreshBeneficiaryList(
      EducationLbseInterventionState educationLbseInterventionState) {
    educationLbseInterventionState.refreshEducationLbseNumber();
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
                  ? 'Ha ho na bana ba LBSE ba ngolisitseng hajoale'
                  : 'There is no LBSE beneficiaries enrolled at the moment',
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
            onPressed: () => onAddLbseBeneficiary(context),
          )
        ],
      ),
    );
  }

  Consumer<EducationLbseInterventionState> _buildBody() {
    return Consumer<EducationLbseInterventionState>(
      builder: (context, educationLbseInterventionState, child) {
        return RefreshIndicator(
          onRefresh: () async =>
              refreshBeneficiaryList(educationLbseInterventionState),
          child: CustomPaginatedListView(
            childBuilder: (context, lbseBeneficiary, child) =>
                EducationBeneficiaryCard(
                    canEdit: canEdit,
                    canView: canView,
                    canExpand: canExpand,
                    isExpanded: toggleCardId == lbseBeneficiary.id,
                    isLbseLearningOutcomeVisible: true,
                    isBursarySchoolVisible: false,
                    isBursaryClubVisible: false,
                    isBursaryClubReferralVisible: false,
                    educationBeneficiary: lbseBeneficiary,
                    onEdit: () => onEditBeneficiary(context, lbseBeneficiary),
                    onView: () => onViewBeneficiary(context, lbseBeneficiary),
                    onCardToggle: () =>
                        onCardToggle(context, lbseBeneficiary.id),
                    onOpenLbseLearningOutcome: () =>
                        onOpenBeneficiaryLearningOutcome(
                            context, lbseBeneficiary)),
            pagingController: educationLbseInterventionState.pagingController!,
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
        return Consumer<EducationLbseInterventionState>(
          builder: (context, educationLbseInterventionState, child) {
            int maleCount = educationLbseInterventionState
                    .numberOfEducationLbseBySex["male"] ??
                0;
            int femaleCount = educationLbseInterventionState
                    .numberOfEducationLbseBySex["female"] ??
                0;
            String sexCountLabel = isSesotho
                ? '$maleCount Botona  $femaleCount Botsehali'
                : '$maleCount Male  $femaleCount Female';
            return SubModuleHomeContainer(
              header:  isSesotho ? '$translatedTitle : $sexCountLabel' : '$title : $sexCountLabel',
              bodyContents: _buildBody(),
              showFilter: true,
            ); 
          },
        );
      },
    );
  }
}
