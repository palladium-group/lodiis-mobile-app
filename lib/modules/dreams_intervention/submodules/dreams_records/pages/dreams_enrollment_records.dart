import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card_body.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

class DreamsEnrollmentRecords extends StatefulWidget {
  const DreamsEnrollmentRecords({Key? key}) : super(key: key);

  @override
  State<DreamsEnrollmentRecords> createState() =>
      _DreamsEnrollmentRecordsState();
}

class _DreamsEnrollmentRecordsState extends State<DreamsEnrollmentRecords> {
  final String title = 'AGYW/DREAMS BENEFICIARY';
  final String translatedTitle = "Ngoana oa AGYW/DREAMS";
  final bool canEdit = false;
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

  void refreshBeneficiaryList(
      DreamsInterventionListState dreamInterventionListState) {
    dreamInterventionListState.refreshBeneficiariesNumber();
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
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              errorWidget: const Center(
                child: Text(
                  'Error in loading beneficiary list ',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
