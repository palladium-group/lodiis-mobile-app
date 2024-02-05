import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/beneficiary_filter_state/beneficiary_filter_state.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_bursary_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_lbse_state.dart';
import 'package:kb_mobile_app/app_state/intervention_bottom_navigation_state/intervention_bottom_navigation_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ogac_intervention_list_state/ogac_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_state.dart';
import 'package:kb_mobile_app/core/components/input_fields/input_clear_icon.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/models/Intervention_bottom_navigation.dart';
import 'package:kb_mobile_app/models/beneficiary_filter.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:provider/provider.dart';

class BeneficiaryListFilter extends StatefulWidget {
  const BeneficiaryListFilter({Key? key}) : super(key: key);

  @override
  State<BeneficiaryListFilter> createState() => _BeneficiaryListFilterState();
}

class _BeneficiaryListFilterState extends State<BeneficiaryListFilter> {
  Widget makeFilterDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  List<BeneficiaryFilter> getFilterMetadata(
      InterventionCard currentIntervention) {
    final List<BeneficiaryFilter> filters =
        BeneficiaryFilter.getBeneficiaryFilters(currentIntervention);

    return filters
        .where((BeneficiaryFilter filter) =>
            filter.interventions!.isEmpty ||
            filter.interventions!.contains(currentIntervention.id))
        .toList();
  }

  void onClearFilterItem(
      String filterId, InterventionCard currentIntervention) {
    String intervention = currentIntervention.id ?? '';
    String implementingPartner =
        Provider.of<CurrentUserState>(context, listen: false)
            .implementingPartner;
    InterventionBottomNavigation interventionBottomNavigation =
        Provider.of<InterventionBottomNavigationState>(context, listen: false)
            .getCurrentInterventionBottomNavigation(
                currentIntervention, implementingPartner);
    String programId = intervention == 'education'
        ? interventionBottomNavigation.id!
        : intervention;
    Provider.of<BeneficiaryFilterState>(context, listen: false)
        .clearFilterById(programId, filterId);
    setFiltersToProgram(programId);
  }

  bool isFilterApplied(String filterId, InterventionCard currentIntervention) {
    String intervention = currentIntervention.id ?? '';
    String implementingPartner =
        Provider.of<CurrentUserState>(context, listen: false)
            .implementingPartner;
    InterventionBottomNavigation currentTab =
        Provider.of<InterventionBottomNavigationState>(context, listen: false)
            .getCurrentInterventionBottomNavigation(
                currentIntervention, implementingPartner);
    List<Map<String, dynamic>> filters = intervention == 'education'
        ? Provider.of<BeneficiaryFilterState>(context, listen: false)
            .getFiltersByProgram(currentTab.id!)
        : Provider.of<BeneficiaryFilterState>(context, listen: false)
            .getFiltersByProgram(intervention);
    List<Map<String, dynamic>> filter = filters
        .where((filterItem) => filterItem.keys.contains(filterId))
        .toList();
    return filter.isNotEmpty;
  }

  void setFiltersToProgram(String programId) {
    List<Map<String, dynamic>> filters =
        Provider.of<BeneficiaryFilterState>(context, listen: false)
            .getFiltersByProgram(programId);

    if (programId == 'ovc') {
      Provider.of<OvcInterventionListState>(context, listen: false)
          .setOvcFilters(filters);
    } else if (programId == 'dreams') {
      Provider.of<DreamsInterventionListState>(context, listen: false)
          .setAgywFilters(filters);
    } else if (programId == 'ogac') {
      Provider.of<OgacInterventionListState>(context, listen: false)
          .setOgacFilter(filters);
    } else if (programId == 'lbse') {
      Provider.of<EducationLbseInterventionState>(context, listen: false)
          .setLbseFilters(filters);
    } else if (programId == 'bursary') {
      Provider.of<EducationBursaryInterventionState>(context, listen: false)
          .setBursaryFilters(filters);
    } else if (programId == 'pp_prev') {
      Provider.of<PpPrevInterventionState>(context, listen: false)
          .setPpPrevFilters(filters);
    }
  }

  void onApplyFilters(InterventionCard currentIntervention) {
    String intervention = currentIntervention.id ?? '';
    String implementingPartner =
        Provider.of<CurrentUserState>(context, listen: false)
            .implementingPartner;
    InterventionBottomNavigation interventionBottomNavigation =
        Provider.of<InterventionBottomNavigationState>(context, listen: false)
            .getCurrentInterventionBottomNavigation(
                currentIntervention, implementingPartner);
    String programId = intervention == 'education'
        ? interventionBottomNavigation.id!
        : intervention;
    setFiltersToProgram(programId);
    Navigator.of(context).pop();
  }

  Widget _buildFilterWidget(
      BeneficiaryFilter filter, InterventionCard currentIntervention) {
    bool isFilterSelected = isFilterApplied(filter.id, currentIntervention);
    Color filterColor = currentIntervention.primaryColor ?? Colors.blue;

    return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
      String? currentLanguage = languageTranslationState.currentLanguage;

      return Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              childrenPadding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              title: Row(
                children: [
                  Expanded(
                      child: Text(
                    currentLanguage == 'lesotho'
                        ? filter.translatedName ?? filter.name
                        : filter.name,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w500),
                  )),
                  Visibility(
                    visible: isFilterSelected,
                    child: InputClearIcon(
                      onClearInput: () {
                        onClearFilterItem(filter.id, currentIntervention);
                      },
                      showClearIcon: true,
                    ),
                  )
                ],
              ),
              iconColor: filterColor,
              textColor: filterColor,
              collapsedTextColor: isFilterSelected ? filterColor : null,
              collapsedIconColor: isFilterSelected ? filterColor : null,
              children: [filter.filterInput],
            ),
          ));
    });
  }

  void onClearFilters(
      BuildContext context, InterventionCard currentIntervention) {
    String intervention = currentIntervention.id ?? '';
    String implementingPartner =
        Provider.of<CurrentUserState>(context, listen: false)
            .implementingPartner;
    InterventionBottomNavigation currentTab =
        Provider.of<InterventionBottomNavigationState>(context, listen: false)
            .getCurrentInterventionBottomNavigation(
                currentIntervention, implementingPartner);
    String currentProgramId =
        intervention == 'education' ? currentTab.id! : intervention;
    Provider.of<BeneficiaryFilterState>(context, listen: false)
        .clearFiltersByProgram(currentProgramId);
    setFiltersToProgram(currentProgramId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
      String? currentLanguage = languageTranslationState.currentLanguage;

      return makeFilterDismissible(
          child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.8,
        builder: (BuildContext context, ScrollController scrollController) {
          return Consumer<InterventionCardState>(
              builder: (context, interventionCardState, child) {
            List<BeneficiaryFilter> filters = getFilterMetadata(
                interventionCardState.currentInterventionProgram);
            var backgroundColor =
                interventionCardState.currentInterventionProgram.background;
            return Container(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    color: Color.alphaBlend(
                        backgroundColor ?? Colors.white, Colors.white)),
                child: Consumer<BeneficiaryFilterState>(
                  builder: (context, beneficiaryFilterState, child) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: const Text(
                                    'Filters',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0),
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: InkWell(
                                  onTap: () => onClearFilters(
                                      context,
                                      interventionCardState
                                          .currentInterventionProgram),
                                  child: Text(
                                    currentLanguage == 'lesotho'
                                        ? 'Hlakola Tsohle'
                                        : 'Clear All',
                                    style: TextStyle(
                                        color: interventionCardState
                                            .currentInterventionProgram
                                            .primaryColor),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        LineSeparator(
                            color: interventionCardState
                                .currentInterventionProgram.countLabelColor!),
                        Flexible(
                            child: ListView(
                          padding: const EdgeInsets.all(8.0),
                          children: filters
                              .map((BeneficiaryFilter filter) =>
                                  _buildFilterWidget(
                                      filter,
                                      interventionCardState
                                          .currentInterventionProgram))
                              .toList(),
                        )),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            color: interventionCardState
                                .currentInterventionProgram.primaryColor,
                          ),
                          padding: const EdgeInsets.only(
                            right: 5.0,
                          ),
                          child: TextButton(
                            onPressed: () => onApplyFilters(
                                interventionCardState
                                    .currentInterventionProgram),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                            ),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: const Text(
                                "Apply filters",
                                style: TextStyle(
                                  color: Color(0xFFFAFAFA),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom))
                      ],
                    );
                  },
                ));
          });
        },
      ));
    });
  }
}
