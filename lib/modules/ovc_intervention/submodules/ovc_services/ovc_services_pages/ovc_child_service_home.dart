import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_child_service_home_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_assessment/ovc_child_assessment.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/ovc_child_case_plan.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_monitor/ovc_child_monitor.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_service/ovc_service_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/ovc_service_child_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/clhiv_art_card/clhiv_art_card.dart';
import 'package:provider/provider.dart';

class OvcChildServiceHome extends StatefulWidget {
  const OvcChildServiceHome({Key? key}) : super(key: key);

  @override
  State<OvcChildServiceHome> createState() => _OvcChildServiceHomeState();
}

class _OvcChildServiceHomeState extends State<OvcChildServiceHome> {
  final String label = 'Child';
  final List<OvcChildServiceHomeConstant> ovcChildServiceHomeCards =
      OvcChildServiceHomeConstant.getOvcChildServiceHomeConstant();

  void onOpenChildAssessment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OvcChildAssessment(),
      ),
    );
  }

  void onOpenChildCasePlan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OvcChildCasePlan(),
      ),
    );
  }

  void onOpenChildMonitor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OvcChildMonitor(),
      ),
    );
  }

  void onOpenChildService(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OvcServiceSubPageChildView(),
      ),
    );
  }

  void onOpenClhivArtCardService(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClhivArtCard(),
      ),
    );
  }

  int getCountValueForOvcServiceChildCard(
    OvcChildServiceHomeConstant ovcChildServiceHomeCard,
    Map eventListByProgramStage,
  ) {
    int countValue = 0;
    for (String programStage in ovcChildServiceHomeCard.programStages!) {
      List<Events> events = eventListByProgramStage[programStage] ?? [];
      if (ovcChildServiceHomeCard.groupByDate! &&
          ovcChildServiceHomeCard.groupingProgramStages!
              .contains(programStage)) {
        Map groupedEventByDates =
            TrackedEntityInstanceUtil.getGroupedEventByDates(events);
        countValue += groupedEventByDates.keys.toList().length;
      } else {
        countValue += events.length;
      }
    }
    return countValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return SubPageAppBar(
              label: label,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Column(
          children: [
            const OvcChildInfoTopHeader(),
            Consumer<ServiceEventDataState>(
              builder: (context, serviceEventDataState, child) {
                bool isLoading = serviceEventDataState.isLoading;
                var eventListByProgramStage =
                    serviceEventDataState.eventListByProgramStage;
                return isLoading
                    ? Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: const CircularProcessLoader(
                          color: Colors.blueGrey,
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 13.0),
                        child: Consumer<OvcHouseholdCurrentSelectionState>(
                          builder: (
                            context,
                            ovcHouseholdCurrentSelectionState,
                            child,
                          ) {
                            var currentOvcSelection =
                                ovcHouseholdCurrentSelectionState
                                    .currentOvcHouseholdChild;
                            return GridView.count(
                              crossAxisCount: 2,
                              primary: false,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              shrinkWrap: true,
                              children: ovcChildServiceHomeCards
                                  .where((ovcChildServiceCard) =>
                                      ovcChildServiceCard.id != 'clhiv_art' ||
                                      (ovcChildServiceCard.id == 'clhiv_art' &&
                                          currentOvcSelection!.isClHiv))
                                  .map(
                                (OvcChildServiceHomeConstant
                                    ovcChildServiceHomeCard) {
                                  int countValue =
                                      getCountValueForOvcServiceChildCard(
                                    ovcChildServiceHomeCard,
                                    eventListByProgramStage,
                                  );
                                  return Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      child: OvcServiceChildCard(
                                        ovcChildServiceHomeCard:
                                            ovcChildServiceHomeCard,
                                        countValue: countValue.toString(),
                                      ),
                                      onTap: () => ovcChildServiceHomeCard.id ==
                                              'assessment'
                                          ? onOpenChildAssessment(context)
                                          : ovcChildServiceHomeCard.id ==
                                                  'casePlan'
                                              ? onOpenChildCasePlan(context)
                                              : ovcChildServiceHomeCard.id ==
                                                      'services'
                                                  ? onOpenChildService(context)
                                                  : ovcChildServiceHomeCard
                                                              .id ==
                                                          'monitor'
                                                      ? onOpenChildMonitor(
                                                          context)
                                                      : ovcChildServiceHomeCard
                                                                  .id ==
                                                              'clhiv_art'
                                                          ? onOpenClhivArtCardService(
                                                              context)
                                                          : null,
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
