import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card_body.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_common_constant.dart';
import 'package:provider/provider.dart';
import 'pages/dream_referral_page_home.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

class DreamsIncomingReferralPage extends StatefulWidget {
  const DreamsIncomingReferralPage({Key? key}) : super(key: key);
  @override
  State<DreamsIncomingReferralPage> createState() =>
      _DreamsIncomingReferralPageState();
}

class _DreamsIncomingReferralPageState
    extends State<DreamsIncomingReferralPage> {
  final String title = 'BENEFICIARY LIST';
  final String translatedTitle = "Lethathamo la bana ka hara morero";
  final bool canEdit = false;
  final bool canView = false;
  final bool canExpand = true;
  final bool isIncomingReferral = true;

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

  void onOpenReferralForm(
    BuildContext context,
    AgywDream agywBeneficiary,
  ) {
    Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
        .setCurrentAgywDream(agywBeneficiary);
    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(agywBeneficiary.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DreamsAgywReferralPage(
          isIncomingReferral: isIncomingReferral,
        ),
      ),
    );
  }

  void refreshBeneficiaryList(
      DreamsInterventionListState dreamInterventionListState) {
    dreamInterventionListState.refreshBeneficiariesNumber();
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
                ? '$translatedTitle :  ${dreamInterventionListState.numberOfAgywDreamsIncomingReferralBeneficiaries} Ba unang melemo ka hare ho morero'
                : '$title :  ${dreamInterventionListState.numberOfAgywDreamsIncomingReferralBeneficiaries} beneficiaries',
            bodyContents: _buildBody(),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) =>
          Consumer<ReferralNotificationState>(
        builder: (context, referralNotificationState, child) {
          return Consumer<DreamsInterventionListState>(
            builder: (context, dreamInterventionListState, child) {
              return RefreshIndicator(
                onRefresh: () async =>
                    refreshBeneficiaryList(dreamInterventionListState),
                child: CustomPaginatedListView(
                  childBuilder: (context, agywBeneficiary, child) =>
                      DreamsBeneficiaryCard(
                    isAgywEnrollment: false,
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
                    cardButtonActions: Column(
                      children: [
                        const LineSeparator(
                          color: Color(0xFFE9F4FA),
                        ),
                        MaterialButton(
                          onPressed: () => onOpenReferralForm(
                            context,
                            agywBeneficiary,
                          ),
                          child: Text(
                            languageState.currentLanguage == 'lesotho'
                                ? 'PHETISETSO'
                                : 'REFERRAL',
                            style: const TextStyle().copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: AgywDreamsCommonConstant.defaultColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    cardButtonContent: Container(),
                  ),
                  pagingController: dreamInterventionListState
                      .agywIncomingReferralPagingController,
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
          );
        },
      ),
    );
  }
}
