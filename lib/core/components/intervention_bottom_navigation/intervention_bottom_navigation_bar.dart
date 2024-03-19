import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_re_assessment_list_state.dart';
import 'package:kb_mobile_app/app_state/intervention_bottom_navigation_state/intervention_bottom_navigation_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_icon.dart';
import 'package:kb_mobile_app/models/Intervention_bottom_navigation.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:provider/provider.dart';

class InterventionBottomNavigationBar extends StatelessWidget {
  const InterventionBottomNavigationBar({
    Key? key,
    required this.activeInterventionProgram,
    required this.currentLanguage,
  }) : super(key: key);

  final InterventionCard activeInterventionProgram;
  final String? currentLanguage;

  void onTap(BuildContext context, int index, String? id) {
    Provider.of<InterventionBottomNavigationState>(context, listen: false)
        .setCurrentInterventionBottomNavigationStatus(index, id);
    if (Navigator.canPop(context)) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  List<InterventionBottomNavigation>
      _getSanitizedInterventionsByCurrentUserAccess(
          CurrentUserState currentUserState,
          List<InterventionBottomNavigation> interventionBottomNavigations,
          InterventionCardState interventionCardState) {
    if (!currentUserState.canManageReferral) {
      interventionBottomNavigations = interventionBottomNavigations
          .where(
            (InterventionBottomNavigation navigation) => ![
              'referral',
              'outGoingReferral',
              'incomingReferral'
            ].contains(navigation.id),
          )
          .toList();
    }
    if (!currentUserState.canManageNoneAgyw) {
      interventionBottomNavigations = interventionBottomNavigations
          .where((nav) => nav.id != 'noneAgyw')
          .toList();
    }

    String currentUserImplementingPartner =
        currentUserState.currentUser!.implementingPartner!;
    if (['Paralegal', 'KB-Facility Based Social Worker']
        .contains(currentUserImplementingPartner)) {
      interventionBottomNavigations = interventionBottomNavigations
          .where((InterventionBottomNavigation navigation) =>
              !['enrollment', 'exit'].contains(navigation.id))
          .toList();
    }

    return interventionBottomNavigations;
  }

  @override
  Widget build(BuildContext context) {
    List<InterventionBottomNavigation> interventionBottomNavigations =
        InterventionBottomNavigation.getInterventionNavigationButtons(
      activeInterventionProgram,
    );

    return Consumer<InterventionCardState>(
      builder: (context, interventionCardState, child) {
        return Consumer<InterventionBottomNavigationState>(
          builder: (context, interventionBottomNavigationState, child) {
            return Consumer<CurrentUserState>(
              builder: (context, currentUserState, child) {
                interventionBottomNavigations =
                    _getSanitizedInterventionsByCurrentUserAccess(
                  currentUserState,
                  interventionBottomNavigations,
                  interventionCardState,
                );
                int currentIndex = interventionBottomNavigationState
                    .currentInterventionBottomNavigationIndex;
                InterventionBottomNavigation
                    currentInterventionBottomNavigation =
                    interventionBottomNavigationState
                        .getCurrentInterventionBottomNavigation(
                  activeInterventionProgram,
                  currentUserState.implementingPartner,
                );
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: interventionBottomNavigations.map((
                    InterventionBottomNavigation interventionBottomNavigation,
                  ) {
                    int index = interventionBottomNavigations
                        .indexOf(interventionBottomNavigation);
                    double tabsWidth = MediaQuery.of(context).size.width /
                        interventionBottomNavigations.length;
                    return Stack(
                      children: [
                        SizedBox(
                          width: tabsWidth > 90.0 ? 90.0 : tabsWidth,
                          child: InkWell(
                            onTap: () => onTap(context, index,
                                interventionBottomNavigation.id),
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 5.0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 12.0,
                              ),
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? activeInterventionProgram.primaryColor
                                    : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                ),
                              ),
                              child: SizedBox(
                                height: 80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    InterventionBottomNavigationIcon(
                                      currentInterventionBottomNavigation:
                                          currentInterventionBottomNavigation,
                                      interventionBottomNavigation:
                                          interventionBottomNavigation,
                                    ),
                                    Text(
                                      currentLanguage == 'lesotho' &&
                                              interventionBottomNavigation
                                                      .translatedName !=
                                                  null
                                          ? interventionBottomNavigation
                                              .translatedName!
                                          : interventionBottomNavigation.name!,
                                      style: TextStyle(
                                        fontSize: 8.2,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            currentInterventionBottomNavigation
                                                        .id ==
                                                    interventionBottomNavigation
                                                        .id
                                                ? Colors.white
                                                : const Color(0xFF737373),
                                      ),
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 5,
                          child: Visibility(
                            visible: interventionCardState
                                        .currentInterventionProgram.id ==
                                    'dreams' &&
                                (interventionBottomNavigation.id ==
                                        "outGoingReferral" ||
                                    interventionBottomNavigation.id ==
                                        "incomingReferral" ||
                                    interventionBottomNavigation.id ==
                                        "enrollment"),
                            child: Consumer<InterventionCardState>(
                              builder:
                                  (context, interventionCardState, child) =>
                                      Consumer<DreamsRaAssessmentListState>(
                                builder: ((context, dreamsRaAssessmentListState,
                                    child) {
                                  int dreamsForReAssessment =
                                      dreamsRaAssessmentListState
                                          .numberOfDreamsToReAssess;
                                  return Consumer<ReferralNotificationState>(
                                    builder: (context,
                                        referralNotificationState, child) {
                                      String incomingReferralsResolved =
                                          referralNotificationState
                                              .incomingReferralsResolvedIndicator;
                                      String incomingReferralToResolve =
                                          referralNotificationState
                                              .incomingReferralToResolveIndicator;
                                      String reAssessedCount =
                                          dreamsForReAssessment > 0
                                              ? dreamsForReAssessment < 10
                                                  ? '$dreamsForReAssessment'
                                                  : '9+'
                                              : '';
                                      return ClipOval(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 3.0,
                                            horizontal: 5.0,
                                          ),
                                          color: (interventionBottomNavigation
                                                              .id ==
                                                          "outGoingReferral" &&
                                                      incomingReferralsResolved !=
                                                          "") ||
                                                  (interventionBottomNavigation
                                                              .id ==
                                                          "incomingReferral" &&
                                                      incomingReferralToResolve !=
                                                          "") ||
                                                  (interventionBottomNavigation
                                                              .id ==
                                                          "enrollment" &&
                                                      interventionCardState
                                                              .currentInterventionProgram
                                                              .id ==
                                                          'dreams' &&
                                                      dreamsForReAssessment > 0)
                                              ? activeInterventionProgram
                                                  .primaryColor!
                                                  .withOpacity(0.5)
                                              : activeInterventionProgram
                                                  .primaryColor!
                                                  .withOpacity(0.0),
                                          child: Text(
                                            interventionBottomNavigation.id ==
                                                    "outGoingReferral"
                                                ? incomingReferralsResolved
                                                : interventionBottomNavigation
                                                            .id ==
                                                        "incomingReferral"
                                                    ? incomingReferralToResolve
                                                    : interventionCardState
                                                                    .currentInterventionProgram
                                                                    .id ==
                                                                'dreams' &&
                                                            interventionBottomNavigation
                                                                    .id ==
                                                                "enrollment"
                                                        ? reAssessedCount
                                                        : '',
                                            style: const TextStyle().copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: currentInterventionBottomNavigation
                                                          .id ==
                                                      interventionBottomNavigation
                                                          .id
                                                  ? Colors.white
                                                  : activeInterventionProgram
                                                      .primaryColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}
