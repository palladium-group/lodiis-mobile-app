import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_bursary_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_lbse_state.dart';
import 'package:kb_mobile_app/app_state/intervention_bottom_navigation_state/intervention_bottom_navigation_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/ogac_intervention_list_state/ogac_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_state.dart';
import 'package:kb_mobile_app/core/components/beneficiary_list_filter.dart';
import 'package:kb_mobile_app/models/Intervention_bottom_navigation.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:provider/provider.dart';

class SubModuleHomeContainer extends StatelessWidget {
  final String? header;
  final Widget bodyContents;
  final Function? onOpenInfo;
  final bool hasInfo;
  final bool showFilter;

  const SubModuleHomeContainer(
      {Key? key,
      this.header,
      required this.bodyContents,
      this.onOpenInfo,
      this.hasInfo = false,
      this.showFilter = false})
      : super(key: key);

  void openFilters(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => const BeneficiaryListFilter());
  }

  int getCurrentInterventionFilterCount(
      BuildContext context, InterventionCard currentIntervention) {
    String? id = currentIntervention.id;
    String implementingPartner =
        Provider.of<CurrentUserState>(context, listen: false)
            .implementingPartner;
    InterventionBottomNavigation currentBottomNavigation =
        Provider.of<InterventionBottomNavigationState>(context, listen: false)
            .getCurrentInterventionBottomNavigation(
                currentIntervention, implementingPartner);
    return id == 'education'
        ? currentBottomNavigation.id == 'lbse'
            ? Provider.of<EducationLbseInterventionState>(context,
                    listen: false)
                .getLbseFilterCount()
            : Provider.of<EducationBursaryInterventionState>(context,
                    listen: false)
                .getBursaryFilterCount()
        : id == 'dreams'
            ? Provider.of<DreamsInterventionListState>(context, listen: false)
                .getAgywFiltersCount()
            : id == 'ovc'
                ? Provider.of<OvcInterventionListState>(context, listen: false)
                    .getOvcFiltersCount()
                : id == 'ogac'
                    ? Provider.of<OgacInterventionListState>(context,
                            listen: false)
                        .getOgacFilterCount()
                    : id == 'pp_prev'
                        ? Provider.of<PpPrevInterventionState>(context,
                                listen: false)
                            .getPpPrevFilterCount()
                        : 0;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: header != null && header != ''
          ? AppBar(
              actionsIconTheme: const IconThemeData().copyWith(
                color: Colors.white,
              ),
              iconTheme: const IconThemeData().copyWith(
                color: Colors.white,
              ),
              title: Row(
                children: [
                  Expanded(
                      child: Text(
                    header!,
                    style: const TextStyle().copyWith(
                        color: const Color(0xFF82898D),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  )),
                  Visibility(
                      visible: hasInfo,
                      child: InkWell(
                        onTap: onOpenInfo as void Function()?,
                        child: const Icon(
                          Icons.info_outline,
                          color: Color(0xFF82898D),
                          size: 24.0,
                        ),
                      )),
                  Visibility(
                    visible: showFilter,
                    child: Consumer<InterventionCardState>(
                      builder: (context, interventionCardState, child) {
                        int filterCount = getCurrentInterventionFilterCount(
                            context,
                            interventionCardState.currentInterventionProgram);
                        return Stack(
                          children: [
                            IconButton(
                              onPressed: () => openFilters(context),
                              icon: Icon(
                                Icons.filter_list_outlined,
                                color: interventionCardState
                                    .currentInterventionProgram.primaryColor,
                                size: 24.0,
                              ),
                            ),
                            filterCount != 0
                                ? Positioned(
                                    right: 11,
                                    top: 11,
                                    child: InkWell(
                                      onTap: () => openFilters(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                            color: interventionCardState
                                                .currentInterventionProgram
                                                .primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        constraints: const BoxConstraints(
                                          minWidth: 14,
                                          minHeight: 14,
                                        ),
                                        child: Text(
                                          "$filterCount",
                                          style: const TextStyle().copyWith(
                                              color: Colors.white,
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
              backgroundColor: const Color(0xFFFFFFFF),
              elevation: 1,
            )
          : null,
      body: Stack(
        children: [
          Consumer<InterventionCardState>(
            builder: (context, interventionCardState, child) {
              InterventionCard activeInterventionProgram =
                  interventionCardState.currentInterventionProgram;
              return Container(
                decoration:
                    BoxDecoration(color: activeInterventionProgram.background),
              );
            },
          ),
          Container(child: bodyContents)
        ],
      ),
    );
  }
}
