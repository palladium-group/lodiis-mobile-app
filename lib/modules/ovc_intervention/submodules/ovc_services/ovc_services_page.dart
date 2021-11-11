import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_card_body.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_card_botton_content.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_assessment/ovc_household_assessment.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/ovc_household_case_plan_home.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_monitor/ovc_household_monitor.dart';
import 'package:provider/provider.dart';

import 'ovc_services_pages/household_service/ovc_household_service.dart';

class OvcServicesPage extends StatefulWidget {
  const OvcServicesPage({Key? key}) : super(key: key);

  @override
  _OvcServicesPageState createState() => _OvcServicesPageState();
}

class _OvcServicesPageState extends State<OvcServicesPage> {
  final bool canEdit = false;
  final bool canView = false;
  final bool canExpand = true;
  final bool canAddChild = false;
  final bool canViewChildInfo = false;
  final bool canEditChildInfo = false;
  final bool canViewChildService = true;
  final bool canViewChildReferral = false;
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

  void onOpenHouseholdAssess(BuildContext context, OvcHousehold ovcHousehold) {
    setOvcHouseholdCurrentSelection(context, ovcHousehold);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OvcHouseholdAssessment(),
      ),
    );
  }

  void onOpenHouseholdCasePlan(
      BuildContext context, OvcHousehold ovcHousehold) {
    setOvcHouseholdCurrentSelection(context, ovcHousehold);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OvcHouseholdCasePlanHome(),
      ),
    );
  }

  void onOpenHouseholdMonitor(BuildContext context, OvcHousehold ovcHousehold) {
    setOvcHouseholdCurrentSelection(context, ovcHousehold);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OvcHouseholdMonitor(),
      ),
    );
  }

  void onOpenHouseholdService(BuildContext context, OvcHousehold ovcHousehold) {
    setOvcHouseholdCurrentSelection(context, ovcHousehold);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OvcHouseholdService(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
          String? currentLanguage = languageTranslationState.currentLanguage;
          return Consumer<OvcInterventionListState>(
            builder: (context, ovcInterventionListState, child) {
              String header = currentLanguage == 'lesotho'
                  ? 'Lethathamo la malapa'.toUpperCase() +
                      ': ${ovcInterventionListState.numberOfHouseholds} Malapa'
                  : 'Household list'.toUpperCase() +
                      ': ${ovcInterventionListState.numberOfHouseholds} households';
              return SubModuleHomeContainer(
                header: header,
                bodyContents: _buildBody(currentLanguage),
                showFilter: true,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(String? currentLanguage) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<OvcInterventionListState>(
      builder: (context, ovcListState, child) => CustomPaginatedListView(
        pagingController: ovcListState.pagingController,
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
                : BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
            child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFFF6FAF6),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  itemExtent:
                      screenWidth > 320 ? (screenWidth * 0.95) / 4 : null,
                  shrinkWrap: true,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: TextButton(
                            onPressed: () => onOpenHouseholdAssess(
                              context,
                              ovcHousehold,
                            ),
                            child: Text(
                              'ASSESS',
                              style: TextStyle().copyWith(
                                fontSize: 12.0,
                                color: Color(0xFF4B9F46),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Container(
                        child: TextButton(
                          onPressed: () => onOpenHouseholdCasePlan(
                            context,
                            ovcHousehold,
                          ),
                          child: Text(
                            'PLAN',
                            style: TextStyle().copyWith(
                              fontSize: 12.0,
                              color: Color(0xFF4B9F46),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Container(
                        child: TextButton(
                          onPressed: () => onOpenHouseholdService(
                            context,
                            ovcHousehold,
                          ),
                          child: Text(
                            currentLanguage == 'lesotho'
                                ? 'Litsebeletso'.toUpperCase()
                                : 'SERVICES',
                            style: TextStyle().copyWith(
                              fontSize: 12.0,
                              color: Color(0xFF4B9F46),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Container(
                        child: TextButton(
                          onPressed: () => onOpenHouseholdMonitor(
                            context,
                            ovcHousehold,
                          ),
                          child: Text(
                            'MONITOR',
                            style: TextStyle().copyWith(
                              fontSize: 12.0,
                              color: Color(0xFF4B9F46),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          cardButtonContent: OvcHouseholdCardButtonContent(
            isIncomingReferral: false,
            currentLanguage: currentLanguage,
            ovcHousehold: ovcHousehold,
            canAddChild: canAddChild,
            canViewChildInfo: canViewChildInfo,
            canEditChildInfo: canEditChildInfo,
            canViewChildService: canViewChildService,
            canViewChildReferral: canViewChildReferral,
            canViewChildExit: canViewChildExit,
          ),
        ),
        emptyListWidget: Center(
          child: Text(
            currentLanguage == 'lesotho'
                ? 'Ha hona lelapa le ngolisitsoeng ha hajoale'
                : 'There is no household enrolled at moment',
          ),
        ),
        errorWidget: Center(
          child: Text(
            currentLanguage == 'lesotho'
                ? 'Ha hona lelapa le ngolisitsoeng ha hajoale'
                : 'There is no household enrolled at moment',
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
