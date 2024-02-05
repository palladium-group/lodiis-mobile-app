import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_re_assessment_list_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_bursary_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_lbse_state.dart';
import 'package:kb_mobile_app/app_state/intervention_bottom_navigation_state/intervention_bottom_navigation_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/ogac_intervention_list_state/ogac_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/core/components/app_update_warning.dart';
import 'package:kb_mobile_app/core/components/current_user_metadata_sync.dart';
import 'package:kb_mobile_app/core/components/data_download_message.dart';
import 'package:kb_mobile_app/core/components/offline_beneficiary_search.dart';
import 'package:kb_mobile_app/core/components/online_beneficiary_search.dart';
import 'package:kb_mobile_app/models/Intervention_bottom_navigation.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:provider/provider.dart';

class InterventionAppBar extends StatefulWidget {
  const InterventionAppBar(
      {Key? key,
      required this.activeInterventionProgram,
      this.onClickHome,
      this.onAddHousehold,
      this.onOpenMoreMenu,
      this.onAddAgywBeneficiary,
      this.onAddNoneAgywBeneficiary,
      this.onAddPpPrevBeneficiary,
      this.onAddLbseBeneficiary,
      this.onAddBursaryBeneficiary,
      this.onAddOgacBeneficiary,
      this.tabs = const [],
      this.tabController,
      this.hasTabs = false})
      : super(key: key);

  final InterventionCard activeInterventionProgram;
  final VoidCallback? onAddHousehold;
  final VoidCallback? onAddAgywBeneficiary;
  final VoidCallback? onAddNoneAgywBeneficiary;
  final VoidCallback? onAddPpPrevBeneficiary;
  final VoidCallback? onAddLbseBeneficiary;
  final VoidCallback? onAddBursaryBeneficiary;
  final VoidCallback? onAddOgacBeneficiary;
  final VoidCallback? onClickHome;
  final VoidCallback? onOpenMoreMenu;
  final List<Widget> tabs;
  final TabController? tabController;
  final bool hasTabs;

  @override
  State<InterventionAppBar> createState() => _InterventionAppBarState();
}

class _InterventionAppBarState extends State<InterventionAppBar> {
  int searchItemsCount = 0;
  InputField inputField = InputField(
    id: 'search',
    name: '',
    valueType: 'TEXT',
    inputColor: Colors.white,
  );

  void onOpenOnlineSearchSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => const OnlineBeneficiarySearch());
  }

  void onOpenOfflineSearchSheet(BuildContext context) {
    Map searchedAttributes = _getSearchedAttributes(context);
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => OfflineBeneficiarySearch(
              searchedAttributes: searchedAttributes,
            )).then((_) => _getSearchedAttributes(context));
  }

  Map _getSearchedAttributes(BuildContext context) {
    Map searchedAttributes = {};
    InterventionCard activeInterventionProgram =
        Provider.of<InterventionCardState>(context, listen: false)
            .currentInterventionProgram;
    String? currentInterventionBottomNavigationId =
        Provider.of<InterventionBottomNavigationState>(context, listen: false)
            .currentInterventionBottomNavigationId;
    if (activeInterventionProgram.id == 'ogac') {
      searchedAttributes =
          Provider.of<OgacInterventionListState>(context, listen: false)
              .searchedAttributes;
    } else if (activeInterventionProgram.id == 'dreams') {
      if (currentInterventionBottomNavigationId == 'records') {
        searchedAttributes = {
          ...Provider.of<DreamsInterventionListState>(context, listen: false)
              .agywSearchableValue,
          ...Provider.of<DreamsInterventionListState>(context, listen: false)
              .nonAgywSearchableValue,
          ...Provider.of<DreamsInterventionListState>(context, listen: false)
              .incomingReferralsSearchableValue,
          ...Provider.of<DreamsInterventionListState>(context, listen: false)
              .beneficiariesWithoutAgywDreamsCriteriaSearchedAttributes
        };
      } else if (currentInterventionBottomNavigationId == 'incomingReferral') {
        searchedAttributes =
            Provider.of<DreamsInterventionListState>(context, listen: false)
                .incomingReferralsSearchableValue;
      } else if (currentInterventionBottomNavigationId == 'noneAgyw') {
        searchedAttributes =
            Provider.of<DreamsInterventionListState>(context, listen: false)
                .nonAgywSearchableValue;
      } else {
        searchedAttributes =
            Provider.of<DreamsInterventionListState>(context, listen: false)
                .agywSearchableValue;
      }
    } else if (activeInterventionProgram.id == 'ovc') {
      if (currentInterventionBottomNavigationId == 'records') {
        searchedAttributes = {
          ...Provider.of<OvcInterventionListState>(context, listen: false)
              .ovcSearchableValue,
          ...Provider.of<OvcInterventionListState>(context, listen: false)
              .noneParticipationSearchableValue
        };
      } else {
        searchedAttributes =
            Provider.of<OvcInterventionListState>(context, listen: false)
                .ovcSearchableValue;
      }
    } else if (activeInterventionProgram.id == 'pp_prev') {
      searchedAttributes =
          Provider.of<PpPrevInterventionState>(context, listen: false)
              .searchedAttributes;
    } else if (activeInterventionProgram.id == 'education') {
      if (currentInterventionBottomNavigationId == 'records') {
        searchedAttributes = {
          ...Provider.of<EducationBursaryInterventionState>(context,
                  listen: false)
              .bursarySearchedAttributes,
          ...Provider.of<EducationBursaryInterventionState>(context,
                  listen: false)
              .bursaryWithoutVulnerabilitySearchedAttributes
        };
      } else if (currentInterventionBottomNavigationId == "lbse") {
        searchedAttributes =
            Provider.of<EducationLbseInterventionState>(context, listen: false)
                .searchedAttributes;
      } else if (currentInterventionBottomNavigationId == "bursary") {
        searchedAttributes = Provider.of<EducationBursaryInterventionState>(
                context,
                listen: false)
            .bursarySearchedAttributes;
      }
    }
    setState(() {
      searchItemsCount = searchedAttributes.values.length;
    });
    return searchedAttributes;
  }

  void refreshBeneficiaryList(BuildContext context) async {
    if (widget.activeInterventionProgram.id == 'ogac') {
      Provider.of<OgacInterventionListState>(context, listen: false)
          .refreshOgacNumber();
    } else if (widget.activeInterventionProgram.id == 'dreams') {
      Provider.of<DreamsInterventionListState>(context, listen: false)
          .refreshBeneficiariesNumber();
      Provider.of<ReferralNotificationState>(context, listen: false)
          .reloadReferralNotifications();
      Provider.of<DreamsRaAssessmentListState>(context, listen: false)
          .refreshBeneficiariesNumber();
    } else if (widget.activeInterventionProgram.id == 'ovc') {
      Provider.of<OvcInterventionListState>(context, listen: false)
          .refreshOvcNumber();
    } else if (widget.activeInterventionProgram.id == 'pp_prev') {
      Provider.of<PpPrevInterventionState>(context, listen: false)
          .refreshPpPrevNumber();
    } else if (widget.activeInterventionProgram.id == 'education') {
      await Provider.of<EducationBursaryInterventionState>(context,
              listen: false)
          .refreshEducationBursaryNumber();
      await Provider.of<EducationLbseInterventionState>(context, listen: false)
          .refreshEducationLbseNumber();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsIconTheme: const IconThemeData().copyWith(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData().copyWith(
        color: Colors.white,
      ),
      backgroundColor: widget.activeInterventionProgram.primaryColor,
      title: Row(
        children: [
          GestureDetector(
            onTap: widget.onClickHome,
            child: Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 9.0, horizontal: 13.5),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: widget.activeInterventionProgram.svgIconColor!,
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          widget.activeInterventionProgram.svgIcon!,
                          colorFilter: ColorFilter.mode(
                            widget.activeInterventionProgram.svgIconColor!,
                            BlendMode.srcIn,
                          ),
                          height: 19.2,
                          width: 19.2,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 20,
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            widget.activeInterventionProgram.shortName!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => onOpenOfflineSearchSheet(context),
            ),
            Visibility(
              visible: searchItemsCount > 0,
              child: Positioned(
                right: 11,
                top: 11,
                child: InkWell(
                  onTap: () => onOpenOfflineSearchSheet(context),
                  child: Consumer<InterventionCardState>(
                    builder: ((context, interventionCardState, child) =>
                        Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: interventionCardState
                                  .currentInterventionProgram.primaryColor!
                                  .withOpacity(1),
                              borderRadius: BorderRadius.circular(12.0)),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            "$searchItemsCount",
                            style: const TextStyle().copyWith(
                                color: Colors.amberAccent,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                ),
              ),
            )
          ],
        ),
        Consumer<DeviceConnectivityState>(
            builder: (context, deviceConnectivityState, child) {
          return IconButton(
            icon: const Icon(Icons.travel_explore),
            onPressed: () => onOpenOnlineSearchSheet(context),
          );
        }),
        Consumer<CurrentUserState>(
          builder: (context, currentUserState, child) {
            return Consumer<InterventionBottomNavigationState>(
              builder: (context, interventionBottomNavigationState, child) {
                InterventionBottomNavigation
                    currentInterventionBottomNavigation =
                    interventionBottomNavigationState
                        .getCurrentInterventionBottomNavigation(
                            widget.activeInterventionProgram,
                            currentUserState.implementingPartner);
                return Visibility(
                  visible: widget.activeInterventionProgram.id == 'pp_prev' ||
                      widget.activeInterventionProgram.id == 'education' ||
                      widget.activeInterventionProgram.id == 'ogac' ||
                      (currentInterventionBottomNavigation.id == 'enrollment' ||
                          currentInterventionBottomNavigation.id == 'noneAgyw'),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      widget.activeInterventionProgram.enrollmentIcon!,
                    ),
                    onPressed: currentInterventionBottomNavigation.id ==
                            'noneAgyw'
                        ? widget.onAddNoneAgywBeneficiary
                        : currentInterventionBottomNavigation.id == 'lbse'
                            ? widget.onAddLbseBeneficiary
                            : currentInterventionBottomNavigation.id ==
                                    'bursary'
                                ? widget.onAddBursaryBeneficiary
                                : widget.activeInterventionProgram.id ==
                                        'dreams'
                                    ? widget.onAddAgywBeneficiary
                                    : widget.activeInterventionProgram.id ==
                                            'ogac'
                                        ? widget.onAddOgacBeneficiary
                                        : widget.activeInterventionProgram.id ==
                                                'pp_prev'
                                            ? widget.onAddPpPrevBeneficiary
                                            : widget.activeInterventionProgram
                                                        .id ==
                                                    "ovc"
                                                ? widget.onAddHousehold
                                                : () => {},
                  ),
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: widget.onOpenMoreMenu,
        )
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Column(
          children: [
            const AppUpdateWarning(),
            (widget.hasTabs &&
                    widget.tabs.isNotEmpty &&
                    widget.tabController != null
                ? TabBar(
                    isScrollable: true,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    controller: widget.tabController,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    tabs: widget.tabs
                        .map((tab) => Tab(
                              child: tab,
                            ))
                        .toList())
                : const DataDownloadMessage()),
            CurrentUserMetadataSync(
              color: widget.activeInterventionProgram.secondaryColor!,
            )
          ],
        ),
      ),
    );
  }
}
