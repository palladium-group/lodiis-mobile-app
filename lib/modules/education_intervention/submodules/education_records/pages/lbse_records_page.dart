import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_lbse_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/models/education_beneficiary.dart';
import 'package:kb_mobile_app/modules/education_intervention/components/education_beneficiary_card.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_lbse/pages/education_lbse_enrollment_form_page.dart';
import 'package:provider/provider.dart';

class LbseRecordsPage extends StatefulWidget {
  const LbseRecordsPage({Key? key}) : super(key: key);

  @override
  State<LbseRecordsPage> createState() => _LbseRecordsPageState();
}

class _LbseRecordsPageState extends State<LbseRecordsPage> {
  final String title = 'LBSE List';
  final String translatedTitle = 'Lethathamo la LBSE';
  final bool canEdit = false;
  final bool canView = true;
  final bool canExpand = true;

  String? toggleCardId = '';
  void onCardToggle(BuildContext context, String? trackedEntityInstance) {
    toggleCardId = canExpand && trackedEntityInstance != toggleCardId
        ? trackedEntityInstance
        : '';
    setState(() {});
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

  void onViewBeneficiary(
    BuildContext context,
    EducationBeneficiary educationBeneficiary,
  ) {
    bool isEditableMode = false;
    onUpdateFormState(context, educationBeneficiary, isEditableMode);
    redirectToLbseEnrollmentForm(context);
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
              isLbseLearningOutcomeVisible: false,
              isBursarySchoolVisible: false,
              isBursaryClubVisible: false,
              isBursaryClubReferralVisible: false,
              educationBeneficiary: lbseBeneficiary,
              onView: () => onViewBeneficiary(context, lbseBeneficiary),
              onCardToggle: () => onCardToggle(context, lbseBeneficiary.id),
            ),
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
      builder: (context, languageState, child) =>
          Consumer<EducationLbseInterventionState>(
        builder: (context, educationLbseInterventionState, child) {
          return SubModuleHomeContainer(
            header: languageState.currentLanguage == 'lesotho'
                ? '$translatedTitle : ${educationLbseInterventionState.numberOfEducationLbse} Ba unang melemo ka hare ho morero'
                : '$title : ${educationLbseInterventionState.numberOfEducationLbse} beneficiaries',
            bodyContents: _buildBody(),
          );
        },
      ),
    );
  }
}
