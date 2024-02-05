import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card_body.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/components/service_card_botton_action.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/anc/agyw_dreams_anc.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/art_refill/agyw_dreams_art_refill.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/condoms/agyw_dreams_condoms.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/family_planning_srh/agyw_dreams_family_planning_srh.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hiv_message/agyw_dreams_hiv_message.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hiv_prevention_education/agyw_dreams_hiv_prevention_education.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_short_form/hts_short_form_home_page.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/parenting/agyw_dreams_parenting.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/pep/agyw_dreams_pep.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/post_gbv/agyw_dreams_post_gbv.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/post_gbv_legal/agyw_dreams_post_gbv.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/prep/agyw_dreams_prep.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/prep_short_form/agyw_dreams_prep_short_form_home_page.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/service_form/agyw_dreams_service_form_page.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/violence_prevention_education/agyw_dreams_violence_prevention_education_page.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

class DreamsServicesPage extends StatefulWidget {
  const DreamsServicesPage({Key? key}) : super(key: key);

  @override
  State<DreamsServicesPage> createState() => _DreamsServicesPageState();
}

class _DreamsServicesPageState extends State<DreamsServicesPage> {
  final String title = 'BENEFICIARY LIST';
  final String translatedTitle = "Lethathamo la bana ka hara morero";
  final bool canEdit = false;
  final bool canView = false;
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

  void onOpenHTSShortForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HTSShortFormHomePage(),
      ),
    );
  }

  void onOpenPrepLongForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) async {
    updateStateData(context, agywBeneficiary);
    String? beneficiaryId = agywBeneficiary.id;
    String formAutoSaveId =
        "${DreamsRoutesConstant.agywDreamsPrEPHTSConsentPage}_$beneficiaryId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);

    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave);
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AgywDreamsPrep(),
        ),
      );
    }
  }

  void onOpenPrepShortForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsPrepShortFormHomePage(),
      ),
    );
  }

  void onOpenCondomForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsCondoms(),
      ),
    );
  }

  void onOpenContraceptivesForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamFamilyPlanningSrh(),
      ),
    );
  }

  void onOpenMSGHIVForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamHIVMessage(),
      ),
    );
  }

  void onOpenANCForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsANC(),
      ),
    );
  }

  void onOpenPostGBVForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsPostGBV(),
      ),
    );
  }

  void onOpenArtRefillForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsArtRefill(),
      ),
    );
  }

  void onOpenPEPForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsPEP(),
      ),
    );
  }

  void onOpenServiceForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsServiceFormPage(),
      ),
    );
  }

  void onOpenPostGBVLegalForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsPostGBVLegal(),
      ),
    );
  }

  void onOpenParentingForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsParenting(),
      ),
    );
  }

  void onOpenHIVPreventionEducationForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsHIVPreventionEducation(),
      ),
    );
  }

  void onOpenViolencePreventionEducationForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    updateStateData(context, agywBeneficiary);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgywDreamsViolencePreventionEducationPage(),
      ),
    );
  }

  void updateStateData(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
        .setCurrentAgywDream(agywBeneficiary);
    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(agywBeneficiary.id);
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: true);
  }

  void refreshBeneficiaryList(
      DreamsInterventionListState dreamsInterventionListState) {
    dreamsInterventionListState.refreshBeneficiariesNumber();
    Provider.of<ReferralNotificationState>(context, listen: false)
        .reloadReferralNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) =>
          Consumer<DreamsInterventionListState>(
        builder: (context, dreamInterventionListState, child) {
          return SubModuleHomeContainer(
            header: languageState.currentLanguage == 'lesotho'
                ? '$translatedTitle : ${dreamInterventionListState.numberOfAgywDreamsBeneficiaries} Ba unang melemo ka hare ho morero'
                : '$title : ${dreamInterventionListState.numberOfAgywDreamsBeneficiaries} beneficiaries',
            bodyContents: _buildBody(),
            showFilter: true,
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) =>
          Consumer<DreamsInterventionListState>(
        builder: (context, dreamInterventionListState, child) {
          return RefreshIndicator(
            onRefresh: () async {
              refreshBeneficiaryList(dreamInterventionListState);
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
                  canViewServiceCategory: true,
                  isVerticalLayout: agywBeneficiary.id == toggleCardId,
                ),
                cardButtonActions: ServiceCardButtonAction(
                  agywBeneficiary: agywBeneficiary,
                  onOpenPrepLongForm: () => onOpenPrepLongForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenPrepShortForm: () => onOpenPrepShortForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenHTSShortForm: () => onOpenHTSShortForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenCondomForm: () => onOpenCondomForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenContraceptivesForm: () => onOpenContraceptivesForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenANCForm: () => onOpenANCForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenMSGHIVForm: () => onOpenMSGHIVForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenArtRefillForm: () => onOpenArtRefillForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenPEPForm: () => onOpenPEPForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenPostGBVForm: () => onOpenPostGBVForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenServiceForm: () => onOpenServiceForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenPostGBVLegalForm: () => onOpenPostGBVLegalForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenParentingForm: () => onOpenParentingForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenHIVPreventionEducationForm: () =>
                      onOpenHIVPreventionEducationForm(
                    context,
                    agywBeneficiary,
                  ),
                  onOpenViolencePreventionEducationForm: () =>
                      onOpenViolencePreventionEducationForm(
                    context,
                    agywBeneficiary,
                  ),
                ),
                cardButtonContent: Container(),
              ),
              pagingController: dreamInterventionListState.agywPagingController,
              emptyListWidget: Center(
                child: Text(
                  languageState.currentLanguage == 'lesotho'
                      ? 'Ha hona lethathamo la bana'
                      : 'There is no beneficiary list at a moment',
                ),
              ),
              errorWidget: Center(
                child: Text(
                  languageState.currentLanguage == 'lesotho'
                      ? 'Ha hona lethathamo la bana'
                      : 'There is no beneficiary list at a moment',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
