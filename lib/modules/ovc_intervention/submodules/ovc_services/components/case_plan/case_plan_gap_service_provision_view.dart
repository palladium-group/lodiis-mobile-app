import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_provision_event.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_util.dart';
import 'package:provider/provider.dart';

class CasePlanGapServiceProvisionView extends StatefulWidget {
  const CasePlanGapServiceProvisionView({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap,
    required this.isHouseholdCasePlan,
    required this.hasEditAccess,
    required this.onEditCasePlanService,
    required this.onViewCasePlanService,
  }) : super(key: key);

  final String domainId;
  final Color formSectionColor;
  final Map casePlanGap;
  final bool isHouseholdCasePlan;
  final bool hasEditAccess;

  final Function onEditCasePlanService;
  final Function onViewCasePlanService;

  @override
  State<CasePlanGapServiceProvisionView> createState() =>
      _CasePlanGapServiceProvisionViewState();
}

class _CasePlanGapServiceProvisionViewState
    extends State<CasePlanGapServiceProvisionView> {
  final double iconHeight = 20.0;
  bool _isViewReady = false;
  String programStage = '';
  String casePlanGapToServiceProvisionLinkage = '';

  @override
  void initState() {
    super.initState();
    _setViewMetadata();
  }

  void _setViewMetadata() {
    programStage = widget.isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
        : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;
    casePlanGapToServiceProvisionLinkage = widget.casePlanGap[
            OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage] ??
        '';
    _isViewReady = true;
    Timer(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(),
      child: Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
          String currentLanguage = languageTranslationState.currentLanguage;
          return Consumer<ServiceEventDataState>(
            builder: (context, serviceEventDataState, child) {
              bool isLoading = serviceEventDataState.isLoading;
              List<CasePlanGapServiceProvisionEvent> casePlanServiceProvisions =
                  OvcCasePlanUtil.getCasePlanGapServiceProvisionEvents(
                      casePlanGapToServiceProvisionLinkage:
                          casePlanGapToServiceProvisionLinkage,
                      programStageIds: [programStage],
                      eventListByProgramStage:
                          serviceEventDataState.eventListByProgramStage);
              return (isLoading || !_isViewReady)
                  ? const CircularProcessLoader(
                      color: Colors.blueGrey,
                    )
                  : Column(
                      children: [
                        Visibility(
                          visible: casePlanServiceProvisions.isNotEmpty,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: Text(
                              currentLanguage != 'lesotho'
                                  ? 'Services'
                                  : 'Litsebeletso',
                              style: const TextStyle().copyWith(
                                color: widget.formSectionColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        ...casePlanServiceProvisions.map(
                          (casePlanServiceProvision) => Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 7.0,
                            ),
                            child: Row(
                              children: [
                                _getTableView(
                                  currentLanguage: currentLanguage,
                                  casePlanServiceProvision:
                                      casePlanServiceProvision,
                                ),
                                _getActionIcon(
                                  icon: 'assets/icons/expand_icon.svg',
                                  onTap: () => widget.onViewCasePlanService(
                                    OvcCasePlanUtil.getMappedEventObject(
                                        casePlanServiceProvision.eventData!),
                                  ),
                                ),
                                Consumer<CurrentUserState>(
                                  builder: (context, currentUserState, child) {
                                    bool isKbFacilitySocialWorker =
                                        currentUserState
                                            .isKbFacilitySocialWorker;
                                    return Visibility(
                                      visible: !isKbFacilitySocialWorker &&
                                          widget.hasEditAccess &&
                                          casePlanServiceProvision
                                              .canCurrentUserEdit,
                                      child: _getActionIcon(
                                        icon: 'assets/icons/edit-icon.svg',
                                        onTap: () =>
                                            widget.onEditCasePlanService(
                                          OvcCasePlanUtil.getMappedEventObject(
                                              casePlanServiceProvision
                                                  .eventData!),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
            },
          );
        },
      ),
    );
  }

  Widget _getActionIcon({
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: iconHeight,
        width: iconHeight,
        margin: const EdgeInsets.symmetric(
          vertical: 7.0,
          horizontal: 7.0,
        ),
        child: SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(
            widget.formSectionColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _getTableView({
    required String currentLanguage,
    required CasePlanGapServiceProvisionEvent casePlanServiceProvision,
  }) {
    return Expanded(
      child: Table(
        children: [
          TableRow(children: [
            _getTableCell(
                label: currentLanguage == 'lesotho' ? 'Letsatsi' : 'Date',
                color: const Color(0xFF8A9589)),
            _getTableCell(
                label: currentLanguage == 'lesotho'
                    ? "Lits'ebeletso li fanoe"
                    : 'Service provided',
                color: const Color(0xFF8A9589)),
            _getTableCell(
                label: currentLanguage == 'lesotho' ? "Maikutlo" : 'Comment',
                color: const Color(0xFF8A9589)),
          ]),
          TableRow(children: [
            _getTableCell(
                label: casePlanServiceProvision.date!,
                color: const Color(0xFF1A3518)),
            _getTableCell(
                label: casePlanServiceProvision.result!,
                color: const Color(0xFF1A3518)),
            _getTableCell(
                label: casePlanServiceProvision.reason!,
                color: const Color(0xFF1A3518)),
          ]),
        ],
      ),
    );
  }

  Widget _getTableCell({
    required String label,
    required Color color,
  }) {
    return TableCell(
      child: Text(
        label,
        style: const TextStyle().copyWith(
          color: color,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
