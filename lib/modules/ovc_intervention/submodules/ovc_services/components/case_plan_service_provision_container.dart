import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan_gap_service_monitoring_view_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan_service_monitoring_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan_service_provision_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan_gap_service_provision_view_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_service_provision_util.dart';
import 'package:provider/provider.dart';

class CasePlanServiceProvisionContainer extends StatefulWidget {
  const CasePlanServiceProvisionContainer({
    Key? key,
    required this.formSectionColor,
    required this.isCasePlanForHousehold,
    required this.isServiceMonitoring,
    required this.casePlanGap,
    required this.shouldEditCaseGapServiceProvision,
    required this.shouldViewCaseGapServiceProvision,
    required this.domainId,
    required this.hasEditAccess,
  }) : super(key: key);

  final Map casePlanGap;
  final Color? formSectionColor;
  final bool isCasePlanForHousehold;
  final bool isServiceMonitoring;
  final bool hasEditAccess;
  final bool shouldEditCaseGapServiceProvision;
  final bool shouldViewCaseGapServiceProvision;
  final String? domainId;

  @override
  _CasePlanServiceProvisionContainerState createState() =>
      _CasePlanServiceProvisionContainerState();
}

class _CasePlanServiceProvisionContainerState
    extends State<CasePlanServiceProvisionContainer> {
  late String casePlanGapToServiceProvisionLinkageValue;
  late String casePlanGapToServiceMonitoringLinkageValue;

  @override
  void initState() {
    super.initState();
    setState(() {
      String casePlanGapToServiceProvisionLinkage =
          OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;
      String casePlanGapToServiceMonitoringLinkage =
          OvcCasePlanConstant.casePlanGapToMonitoringLinkage;
      casePlanGapToServiceProvisionLinkageValue =
          widget.casePlanGap[casePlanGapToServiceProvisionLinkage] ??
              AppUtil.getUid();
      casePlanGapToServiceMonitoringLinkageValue =
          widget.casePlanGap[casePlanGapToServiceMonitoringLinkage] ??
              AppUtil.getUid();
    });
  }

  void addServiceMonitoring(BuildContext context) async {
    Map dataObject = {};
    for (var key in widget.casePlanGap.keys) {
      if (key != 'eventId' && key != 'eventDate') {
        dataObject[key] = widget.casePlanGap[key];
      }
    }

    // Add case plan to service monitoring linkage if not exist
    if (widget
            .casePlanGap[OvcCasePlanConstant.casePlanGapToMonitoringLinkage] ==
        null) {
      Map casePlanGapDataObject = widget.casePlanGap;
      casePlanGapDataObject[
              OvcCasePlanConstant.casePlanGapToMonitoringLinkage] =
          casePlanGapToServiceMonitoringLinkageValue;
      await editCasePlanGap(context, casePlanGapDataObject);
    }

    dataObject[OvcCasePlanConstant.casePlanGapToMonitoringLinkage] =
        casePlanGapToServiceMonitoringLinkageValue;

    Widget modal = CasePlanServiceMonitoringFormContainer(
      dataObject: dataObject,
      domainId: widget.domainId,
      isCasePlanForHousehold: widget.isCasePlanForHousehold,
      isEditableMode: true,
    );

    await AppUtil.showPopUpModal(context, modal, true);
  }

  Future<void> editCasePlanGap(
    BuildContext context,
    Map casePlanGapDataObject,
  ) async {
    String programId = widget.isCasePlanForHousehold
        ? OvcHouseholdCasePlanConstant.program
        : OvcChildCasePlanConstant.program;
    String programStageId = widget.isCasePlanForHousehold
        ? OvcHouseholdCasePlanConstant.casePlanGapProgramStage
        : OvcChildCasePlanConstant.casePlanGapProgramStage;
    String orgUnit = widget.isCasePlanForHousehold
        ? Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold!
            .orgUnit!
        : Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild!
            .orgUnit!;
    String tei = widget.isCasePlanForHousehold
        ? Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold!
            .id!
        : Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild!
            .id!;
    List<FormSection> formSections = widget.isCasePlanForHousehold
        ? OvcHouseholdServicesCasePlanGaps.getFormSections(
                firstDate: casePlanGapDataObject['eventDate'])
            .where((FormSection form) => form.id == widget.domainId)
            .toList()
        : OvcServicesChildCasePlanGap.getFormSections(
                firstDate: casePlanGapDataObject['eventDate'])
            .where((FormSection form) => form.id == widget.domainId)
            .toList();
    List<String> hiddenFields = [
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage
    ];

    await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
      programId,
      programStageId,
      orgUnit,
      formSections,
      casePlanGapDataObject,
      casePlanGapDataObject['eventDate'],
      tei,
      casePlanGapDataObject['eventId'],
      hiddenFields,
    );
  }

  void addServiceProvision(BuildContext context) async {
    String programStage = widget.isCasePlanForHousehold
        ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
        : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;

    Map dataObject = {};
    for (var key in widget.casePlanGap.keys) {
      if (key != 'eventId' && key != 'eventDate') {
        dataObject[key] = widget.casePlanGap[key];
      }
    }
    Map<String, List<String>> previousSessionMapping =
        OvcServiceProvisionUtil.getPreviousSessionMapping(
      context,
      [programStage],
    );
    dataObject["previousSessionMapping"] = previousSessionMapping;
    dataObject[OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage] =
        casePlanGapToServiceProvisionLinkageValue;
    Widget modal = CasePlanServiceProvisionFormModalContainer(
      dataObject: dataObject,
      domainId: widget.domainId,
      isCasePlanForHousehold: widget.isCasePlanForHousehold,
      isEditableMode: widget.shouldViewCaseGapServiceProvision,
    );
    await AppUtil.showPopUpModal(context, modal, true);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.shouldEditCaseGapServiceProvision ||
          widget.shouldViewCaseGapServiceProvision,
      child: Column(
        children: [
          Container(
            child: widget.isServiceMonitoring
                ? CasePlanGapServiceMonitoringViewContainer(
                    hasEditAccess: widget.hasEditAccess,
                    casePlanGap: widget.casePlanGap,
                    domainId: widget.domainId,
                    themeColor: widget.formSectionColor,
                    casePlanGapToServiceMonitoringLinkageValue:
                        casePlanGapToServiceMonitoringLinkageValue,
                    shouldEditCaseGapServiceMonitoring: false,
                    isCasePlanForHousehold: widget.isCasePlanForHousehold,
                  )
                : CasePlanGapServiceViewContainer(
                    hasEditAccess: widget.hasEditAccess,
                    casePlanGap: widget.casePlanGap,
                    domainId: widget.domainId,
                    themeColor: widget.formSectionColor,
                    casePlanGapToServiceProvisionLinkageValue:
                        casePlanGapToServiceProvisionLinkageValue,
                    shouldEditCaseGapServiceProvision: false,
                    isCasePlanForHousehold: widget.isCasePlanForHousehold,
                  ),
          ),
          Visibility(
            visible: widget.shouldViewCaseGapServiceProvision &&
                widget.hasEditAccess,
            child: Consumer<LanguageTranslationState>(
              builder: (context, languageTranslationState, child) {
                String? currentLanguage =
                    languageTranslationState.currentLanguage;
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: widget.formSectionColor!,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(15.0),
                    ),
                    onPressed: () => widget.isServiceMonitoring
                        ? addServiceMonitoring(context)
                        : addServiceProvision(context),
                    child: Text(
                      widget.isServiceMonitoring
                          ? 'ADD MONITORING'
                          : currentLanguage != 'lesotho'
                              ? 'ADD SERVICE'
                              : 'KENYA LITSEBELETSO',
                      style: const TextStyle().copyWith(
                        color: widget.formSectionColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
