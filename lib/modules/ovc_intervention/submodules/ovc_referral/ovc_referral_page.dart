import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_card_body.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_card_botton_content.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_house_referral_pages/ovc_household_referral_home.dart';
import 'package:provider/provider.dart';

class OvcReferralPage extends StatefulWidget {
  const OvcReferralPage({
    Key? key,
    this.isIncomingReferral = false,
  }) : super(key: key);

  final bool isIncomingReferral;

  @override
  State<OvcReferralPage> createState() => _OvcReferralPageState();
}

class _OvcReferralPageState extends State<OvcReferralPage> {
  final bool canEdit = false;
  final bool canView = false;
  final bool canExpand = true;
  final bool canAddChild = false;
  final bool canViewChildInfo = false;
  final bool canEditChildInfo = false;
  final bool canViewChildService = false;
  final bool canViewChildReferral = true;
  final bool canViewChildExit = false;

  String? toggleCardId = '';

  void onCardToggle(String? cardId) {
    setState(() {
      toggleCardId = canExpand && cardId != toggleCardId ? cardId : '';
    });
  }

  void setOvcHouseholdCurrentSelection(
      BuildContext context, OvcHousehold ovcHousehold) {
    Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
        .setCurrentHousehold(ovcHousehold);
    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(ovcHousehold.id);
  }

  void onViewRerral(BuildContext context, OvcHousehold ovcHousehold) {
    setOvcHouseholdCurrentSelection(context, ovcHousehold);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OvcHouseholdReferralHome(
          isIncomingReferral: widget.isIncomingReferral,
        ),
      ),
    );
  }

  void refreshBeneficiaryList(
      OvcInterventionListState ovcInterventionListState) {
    ovcInterventionListState.refreshOvcNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String? currentLanguage = languageTranslationState.currentLanguage;
        return Consumer<OvcInterventionListState>(
          builder: (context, ovcInterventionListState, child) {
            String header = currentLanguage == 'lesotho'
                ? '${'Lethathamo la malapa'.toUpperCase()}: ${ovcInterventionListState.numberOfHouseholds} Malapa'
                : '${'Household list'.toUpperCase()}: ${ovcInterventionListState.numberOfHouseholds} households';
            return SubModuleHomeContainer(
              header: header,
              bodyContents: _buildBody(currentLanguage),
              showFilter: true,
            );
          },
        );
      },
    );
  }

  Widget _buildBody(String? currentLanguage) {
    return Consumer<OvcInterventionListState>(
      builder: (context, ovcList, child) => RefreshIndicator(
        onRefresh: () async => refreshBeneficiaryList(ovcList),
        child: CustomPaginatedListView(
          pagingController: ovcList.pagingController,
          errorWidget: Center(
            child: Text(
              currentLanguage == 'lesotho'
                  ? 'Ha hona lelapa le ngolisitsoeng ha hajoale'
                  : 'There is no household enrolled at the moment',
            ),
          ),
          emptyListWidget: Center(
            child: Text(
              currentLanguage == 'lesotho'
                  ? 'Ha hona lelapa le ngolisitsoeng ha hajoale'
                  : 'There is no household enrolled at the moment',
            ),
          ),
          childBuilder: (context, ovcHousehold, index) => OvcHouseholdCard(
            ovcHousehold: ovcHousehold,
            canEdit: canEdit,
            canExpand: canExpand,
            canView: canView,
            isExpanded: ovcHousehold.id == toggleCardId,
            onCardToggle: () {
              onCardToggle(ovcHousehold.id);
            },
            cardBody: OvcHouseholdCardBody(
              ovcHousehold: ovcHousehold,
            ),
            cardButtonActions: ClipRRect(
              borderRadius: ovcHousehold.id == toggleCardId
                  ? BorderRadius.zero
                  : const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0XFFF6FAF6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => onViewRerral(
                        context,
                        ovcHousehold,
                      ),
                      child: Text(
                        currentLanguage == 'lesotho'
                            ? 'PHETISETSO'
                            : 'REFERRAL',
                        style: const TextStyle().copyWith(
                          fontSize: 12.0,
                          color: const Color(0xFF4B9F46),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            cardButtonContent: OvcHouseholdCardButtonContent(
              currentLanguage: currentLanguage,
              ovcHousehold: ovcHousehold,
              canAddChild: canAddChild,
              canViewChildInfo: canViewChildInfo,
              canEditChildInfo: canEditChildInfo,
              canViewChildService: canViewChildService,
              canViewChildReferral: canViewChildReferral,
              canViewChildExit: canViewChildExit,
              isIncomingReferral: widget.isIncomingReferral,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
