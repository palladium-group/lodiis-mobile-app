import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card_body.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/constant/non_agyw_dreams_hts_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/pages/non_agyw_dreams_hts_consent_form.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/none_agyw/sub_pages/none_agyw_prep/none_agyw_prep.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

class NoneAgyw extends StatefulWidget {
  const NoneAgyw({Key? key}) : super(key: key);

  @override
  State<NoneAgyw> createState() => _NoneAgywState();
}

class _NoneAgywState extends State<NoneAgyw> {
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

  void onOpenPrep(BuildContext context, AgywDream agywDream) {
    Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
        .setCurrentAgywDream(agywDream);
    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(agywDream.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NoneAgywPrep(),
      ),
    );
  }

  void onAddNoneAgywBeneficiary(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId =
        "${DreamsRoutesConstant.noneAgywHtsConsentPage}_$beneficiaryId";
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
            return const NonAgywDreamsHTSConsentForm();
          },
        ),
      );
    }
  }

  void refreshBeneficiaryList(
      DreamsInterventionListState dreamsInterventionListState) {
    dreamsInterventionListState.refreshBeneficiariesNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) =>
          Consumer<DreamsInterventionListState>(
        builder: (context, dreamInterventionListState, child) {
          return SubModuleHomeContainer(
            header: languageState.currentLanguage == 'lesotho'
                ? '$translatedTitle : ${dreamInterventionListState.numberOfNoneAgywDreamsBeneficiaries} Ba unang melemo ka hare ho morero'
                : '$title : ${dreamInterventionListState.numberOfNoneAgywDreamsBeneficiaries} beneficiaries',
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
          onRefresh: () async =>
              refreshBeneficiaryList(dreamInterventionListState),
          child: CustomPaginatedListView(
            emptyListWidget: Center(
              child: Column(
                children: [
                  Text(
                    languageState.currentLanguage == 'lesotho'
                        ? 'Ha hona lethathamo la bana'
                        : 'There is no beneficiary list at a moment',
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/add-beneficiary.svg',
                      colorFilter: const ColorFilter.mode(
                        Colors.blueGrey,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => onAddNoneAgywBeneficiary(context),
                  )
                ],
              ),
            ),
            errorWidget: Center(
              child: Text(
                languageState.currentLanguage == 'lesotho'
                    ? 'Ha hona lethathamo la bana'
                    : 'There is no beneficiary list at a moment',
              ),
            ),
            pagingController:
                dreamInterventionListState.nonAgywPagingController,
            childBuilder: (context, agywBeneficiary, child) {
              List dataObject =
                  agywBeneficiary.trackedEntityInstanceData.attributes;
              List filteredDataObject = dataObject
                  .where((element) =>
                      element['attribute'] ==
                      NonAgywDreamsHTSConstant.hivResultStatus)
                  .toList();
              bool isBeneficiaryHIVNegative = false;
              if (filteredDataObject.isNotEmpty) {
                isBeneficiaryHIVNegative =
                    filteredDataObject.first['value'] == 'Negative';
              }
              return DreamsBeneficiaryCard(
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
                  canViewServiceCategory: false,
                  isVerticalLayout: agywBeneficiary.id == toggleCardId,
                ),
                cardButtonActions: isBeneficiaryHIVNegative
                    ? Column(
                        children: [
                          const LineSeparator(
                            color: Color(0xFFE9F4FA),
                          ),
                          MaterialButton(
                            onPressed: () => onOpenPrep(
                              context,
                              agywBeneficiary,
                            ),
                            child: Text(
                              'PREP',
                              style: const TextStyle().copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF1F8ECE),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(),
                cardButtonContent: Container(),
              );
            },
          ),
        );
      }),
    );
  }
}
