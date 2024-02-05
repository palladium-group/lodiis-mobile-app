import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_re_assessment_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/input_fields/search_input.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_card_body.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_common_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/pages/agyw_dreams_re_assessment_form.dart';
import 'package:provider/provider.dart';

class AgywDreamForReAssessment extends StatefulWidget {
  const AgywDreamForReAssessment({Key? key}) : super(key: key);

  @override
  State<AgywDreamForReAssessment> createState() =>
      _AgywDreamForReAssessmentState();
}

class _AgywDreamForReAssessmentState extends State<AgywDreamForReAssessment> {
  final bool canEdit = true;

  final bool canView = true;

  final bool canExpand = true;

  String? toggleCardId = '';

  void onCardToggle(BuildContext context, String? trackedEntityInstance) {
    setState(() {
      toggleCardId = canExpand && trackedEntityInstance != toggleCardId
          ? trackedEntityInstance
          : '';
    });
  }

  void onSearchBeneficiary(BuildContext context, String searchedAttributes) {
    Provider.of<DreamsRaAssessmentListState>(context, listen: false)
        .searchDreamsReAssessmentBeneficiaries(searchedAttributes);
  }

  void onReAssess(BuildContext context, AgywDream agywDream) {
    Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
        .setCurrentAgywDream(agywDream);
    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(agywDream.id);
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: true);
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState('age', '${agywDream.age}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsReAssessmentForm(),
      ),
    );
  }

  Widget makeFilterDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => makeFilterDismissible(
          child: DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.25,
              maxChildSize: 0.9,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Consumer<LanguageTranslationState>(
                    builder: (context, languageTranslationState, child) {
                  return Consumer<InterventionCardState>(
                      builder: (context, interventionCardState, child) {
                    var lineColor = interventionCardState
                        .currentInterventionProgram.countLabelColor;
                    var backgroundColor = interventionCardState
                        .currentInterventionProgram.background;
                    var primary = interventionCardState
                        .currentInterventionProgram.primaryColor;

                    return Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          color: Color.alphaBlend(
                              backgroundColor ?? Colors.white, Colors.white)),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      languageState.currentLanguage == 'lesotho'
                                          ? 'AGYW DREAMS bajalefa bakeng sa tekolo botja'
                                          : 'AGYW DREAMS Beneficiaries for Re-assessment',
                                      style: TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LineSeparator(color: lineColor!),
                          SearchInput(
                            onSearch: (String searchedValue) =>
                                onSearchBeneficiary(
                              context,
                              searchedValue,
                            ),
                          ),
                          Flexible(
                            child: Consumer<DreamsRaAssessmentListState>(
                              builder: (context, dreamsRaAssessmentListState,
                                  child) {
                                return RefreshIndicator(
                                  onRefresh: () async {
                                    dreamsRaAssessmentListState
                                        .refreshBeneficiariesNumber();
                                  },
                                  child: CustomPaginatedListView(
                                    childBuilder:
                                        (context, agywBeneficiary, child) =>
                                            DreamsBeneficiaryCard(
                                      isAgywEnrollment: true,
                                      agywDream: agywBeneficiary,
                                      canEdit: canEdit,
                                      canExpand: canExpand,
                                      beneficiaryName:
                                          agywBeneficiary.toString(),
                                      canView: canView,
                                      isExpanded:
                                          agywBeneficiary.id == toggleCardId,
                                      onCardToggle: () {
                                        onCardToggle(
                                          context,
                                          agywBeneficiary.id,
                                        );
                                      },
                                      cardBody: DreamsBeneficiaryCardBody(
                                        agywBeneficiary: agywBeneficiary,
                                        canViewServiceCategory: false,
                                        isVerticalLayout:
                                            agywBeneficiary.id == toggleCardId,
                                      ),
                                      cardButtonActions: Column(
                                        children: [
                                          const LineSeparator(
                                            color: Color(0xFFE9F4FA),
                                          ),
                                          MaterialButton(
                                            onPressed: () => onReAssess(
                                              context,
                                              agywBeneficiary,
                                            ),
                                            child: Text(
                                              languageState.currentLanguage ==
                                                      'lesotho'
                                                  ? 'Lekola bocha'
                                                  : 'RE-ASSESS',
                                              style: const TextStyle().copyWith(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: AgywDreamsCommonConstant
                                                    .defaultColor,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      cardButtonContent: Container(),
                                    ),
                                    pagingController:
                                        dreamsRaAssessmentListState
                                            .pagingController,
                                    emptyListWidget: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            languageState.currentLanguage ==
                                                    'lesotho'
                                                ? 'Ha hona lethathamo la bana'
                                                : 'There is no beneficiary list at a moment',
                                          ),
                                        ),
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
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom))
                        ],
                      ),
                    );
                  });
                });
              })),
    );
  }
}
