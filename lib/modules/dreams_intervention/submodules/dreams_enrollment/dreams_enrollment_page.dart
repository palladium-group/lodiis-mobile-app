import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_re_assessment_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card_body.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/pages/agyw_dreams_consent.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/pages/agyw_dreams_for_re_assessment.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

class DreamsEnrollmentPage extends StatefulWidget {
  const DreamsEnrollmentPage({Key? key}) : super(key: key);

  @override
  State<DreamsEnrollmentPage> createState() => _DreamsEnrollmentPageState();
}

class _DreamsEnrollmentPageState extends State<DreamsEnrollmentPage> {
  final String title = 'BENEFICIARY LIST';
  final String translatedTitle = "Lethathamo la bana ka hara morero";
  final bool canEdit = true;
  final bool canView = true;
  final bool canExpand = true;

  String? toggleCardId = '';

  void onCardToggle(BuildContext context, String? trackedEntityInstance) {
    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(trackedEntityInstance);
    setState(() {
      toggleCardId = canExpand && trackedEntityInstance != toggleCardId
          ? trackedEntityInstance
          : '';
    });
  }

  void onAddAgywBeneficiary(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywConsentPage}_$beneficiaryId";
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
            return const AgywDreamsConsentForm();
          },
        ),
      );
    }
  }

  void onViewBeneficiariesWhoRequireReAssessment(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const AgywDreamForReAssessment(),
    );
  }

  void refreshBeneficiaryList(BuildContext context) {
    Provider.of<DreamsInterventionListState>(context, listen: false)
        .refreshBeneficiariesNumber();
    Provider.of<ReferralNotificationState>(context, listen: false)
        .reloadReferralNotifications();
    Provider.of<DreamsRaAssessmentListState>(context, listen: false)
        .refreshBeneficiariesNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) =>
          Consumer<DreamsRaAssessmentListState>(
              builder: (context, dreamsRaAssessmentListState, child) {
        return Consumer<DreamsInterventionListState>(
          builder: (context, dreamInterventionListState, child) {
            return SubModuleHomeContainer(
              onOpenInfo: () =>
                  onViewBeneficiariesWhoRequireReAssessment(context),
              hasInfo: dreamsRaAssessmentListState.numberOfDreamsToReAssess > 0,
              header: languageState.currentLanguage == 'lesotho'
                  ? '$translatedTitle : ${dreamInterventionListState.numberOfAgywDreamsBeneficiaries} Ba unang melemo ka hare ho morero'
                  : '$title : ${dreamInterventionListState.numberOfAgywDreamsBeneficiaries} beneficiaries',
              showFilter: true,
              bodyContents: _buildBody(),
            );
          },
        );
      }),
    );
  }

  Widget _buildBody() {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) =>
          Consumer<DreamsInterventionListState>(
        builder: (context, dreamInterventionListState, child) {
          return RefreshIndicator(
            onRefresh: () async {
              refreshBeneficiaryList(context);
            },
            child: CustomPaginatedListView(
              childBuilder: (context, agywBeneficiary, child) =>
                  DreamsBeneficiaryCard(
                isAgywEnrollment: true,
                agywDream: agywBeneficiary,
                canEdit: canEdit,
                canExpand: canExpand,
                beneficiaryName: agywBeneficiary.toString(),
                canView: canView,
                isExpanded: agywBeneficiary.id == toggleCardId,
                onCardToggle: () {
                  onCardToggle(
                    context,
                    agywBeneficiary.id,
                  );
                },
                cardBody: DreamsBeneficiaryCardBody(
                  agywBeneficiary: agywBeneficiary,
                  canViewServiceCategory: false,
                  isVerticalLayout: agywBeneficiary.id == toggleCardId,
                ),
                cardButtonActions: Container(),
                cardButtonContent: Container(),
              ),
              pagingController: dreamInterventionListState.agywPagingController,
              emptyListWidget: Column(
                children: [
                   Center(
                    child: Text(
                      languageState.currentLanguage == 'lesotho'
                          ? 'Ha hona lethathamo la bana'
                          : 'There is no beneficiary list at a moment',
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/add-beneficiary.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.blueGrey,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () => onAddAgywBeneficiary(context),
                    ),
                  )
                ],
              ),
              errorWidget: const Center(
                child: Text(
                  'Error in loading beneficiary list ',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
