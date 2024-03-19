import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/models/case_plan_gap_service_monitoring_event.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_util.dart';
import 'package:provider/provider.dart';

class CasePlanGapServiceMonitoringView extends StatefulWidget {
  const CasePlanGapServiceMonitoringView({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap,
    required this.isHouseholdCasePlan,
    required this.hasEditAccess,
    required this.onEditCasePlanServiceMonitoring,
    required this.onViewCasePlanServiceMonitoring,
  }) : super(key: key);

  final String domainId;
  final Color formSectionColor;
  final Map casePlanGap;
  final bool isHouseholdCasePlan;
  final bool hasEditAccess;

  final Function onEditCasePlanServiceMonitoring;
  final Function onViewCasePlanServiceMonitoring;

  @override
  State<CasePlanGapServiceMonitoringView> createState() =>
      _CasePlanGapServiceMonitoringViewState();
}

class _CasePlanGapServiceMonitoringViewState
    extends State<CasePlanGapServiceMonitoringView> {
  String casePlanGapToServiceMonitoringLinkage = '';
  String programStage = '';
  bool _isViewReady = false;

  @override
  void initState() {
    super.initState();
    _setViewMetadata();
  }

  _setViewMetadata() {
    programStage = widget.isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.casePlanGapServiceMonitoringProgramStage
        : OvcChildCasePlanConstant.casePlanGapServiceMonitoringProgramStage;
    casePlanGapToServiceMonitoringLinkage = widget
            .casePlanGap[OvcCasePlanConstant.casePlanGapToMonitoringLinkage] ??
        '';
    _isViewReady = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
      String currentLanguage = languageTranslationState.currentLanguage;
      return Consumer<ServiceEventDataState>(
          builder: (context, serviceEventDataState, child) {
        bool isLoading = serviceEventDataState.isLoading;
        List<CasePlanGapServiceMonitoringEvent> casePlanServiceMonitorings =
            OvcCasePlanUtil.getCasePlanGapServiceMonitoringEvents(
                eventListByProgramStage:
                    serviceEventDataState.eventListByProgramStage,
                programStageIds: [programStage],
                casePlanGapToServiceMonitoringLinkage:
                    casePlanGapToServiceMonitoringLinkage);
        return isLoading || !_isViewReady
            ? const CircularProcessLoader(
                color: Colors.blueGrey,
              )
            : Column(
                children: [
                  Visibility(
                    visible: casePlanServiceMonitorings.isNotEmpty,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Monitoring',
                        style: const TextStyle().copyWith(
                          color: widget.formSectionColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ...casePlanServiceMonitorings.map(
                    (casePlanServiceMonitoring) {
                      int index = casePlanServiceMonitorings
                              .indexOf(casePlanServiceMonitoring) +
                          1;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            _getTableViewWidget(
                              currentLanguage,
                              casePlanServiceMonitoring,
                              index,
                            ),
                            _getActionIcon(
                              icon: 'assets/icons/expand_icon.svg',
                              onTap: () =>
                                  widget.onViewCasePlanServiceMonitoring(
                                OvcCasePlanUtil.getMappedEventObject(
                                    casePlanServiceMonitoring.eventData!),
                              ),
                            ),
                            Consumer<CurrentUserState>(
                              builder: (context, currentUserState, child) {
                                bool isKbFacilitySocialWorker =
                                    currentUserState.isKbFacilitySocialWorker;
                                return Visibility(
                                  visible: !isKbFacilitySocialWorker &&
                                      widget.hasEditAccess &&
                                      casePlanServiceMonitoring
                                          .canCurrentUserEdit,
                                  child: _getActionIcon(
                                    icon: 'assets/icons/edit-icon.svg',
                                    onTap: () =>
                                        widget.onEditCasePlanServiceMonitoring(
                                      OvcCasePlanUtil.getMappedEventObject(
                                          casePlanServiceMonitoring.eventData!),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList()
                ],
              );
      });
    });
  }

  Widget _getActionIcon({
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
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

  Expanded _getTableViewWidget(
    String currentLanguage,
    CasePlanGapServiceMonitoringEvent casePlanServiceMonitoring,
    int index,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(),
        child: Table(
          children: [
            TableRow(
              children: [
                _getTableCell(
                  color: const Color(
                    0xFF8A9589,
                  ),
                  label: currentLanguage == 'lesotho' ? 'Letsatsi' : 'Date',
                ),
                _getTableCell(
                  color: const Color(
                    0xFF8A9589,
                  ),
                  label: '',
                )
              ],
            ),
            TableRow(
              children: [
                _getTableCell(
                  color: const Color(
                    0xFF1A3518,
                  ),
                  label: casePlanServiceMonitoring.date!,
                ),
                _getTableCell(
                  color: const Color(
                    0xFF1A3518,
                  ),
                  label: 'Monitoring $index',
                )
              ],
            ),
          ],
        ),
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
