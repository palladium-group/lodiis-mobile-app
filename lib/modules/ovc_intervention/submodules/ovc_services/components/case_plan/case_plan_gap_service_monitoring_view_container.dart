
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_gap_service_monitoring_view.dart';
import 'package:provider/provider.dart';

import '../../constants/ovc_household_assessment_constant.dart';
import '../../constants/ovc_service_well_being_assessment_constant.dart';
import '../monitoring/viral_load_monitoring_form_container.dart';

class CasePlanGapServiceMonitoringViewContainer extends StatefulWidget {
  const CasePlanGapServiceMonitoringViewContainer({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.casePlanGap,
    required this.isHouseholdCasePlan,
    required this.enrollmentOuAccessible,
  }) : super(key: key);

  final String domainId;
  final Color formSectionColor;
  final Map casePlanGap;
  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;

  @override
  State<CasePlanGapServiceMonitoringViewContainer> createState() =>
      _CasePlanGapServiceMonitoringViewContainerState();
}

class _CasePlanGapServiceMonitoringViewContainerState
    extends State<CasePlanGapServiceMonitoringViewContainer> {

  bool _isTrue(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }

  /// Only show Viral Load monitoring if HIV+ and on ART
  Future<bool> _isPositiveAndOnArt(BuildContext context) async {
    // HH assessment DEs
    const hhHivDe = 'vNeOE9abQBB';
    const artDe   = 'Icgkv0xkUow';

    // Child WBA DEs
    const childHivDe = 'c5TMWtM4VVJ';

    if (widget.isHouseholdCasePlan) {
      final hhVals = context
          .read<ServiceEventDataState>()
          .latestValuesForStage(OvcHouseholdAssessmentConstant.programStage);
      final hiv = (hhVals[hhHivDe] ?? '').toString().toLowerCase();
      final onArt = _isTrue(hhVals[artDe]);
      return (hiv == 'positive' || hiv == '1' || hiv == 'true') && onArt;
    } else {
      final child = context.read<OvcHouseholdCurrentSelectionState>().currentOvcHouseholdChild;
      if (child == null) return false;

      final all = await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(
        child.id ?? '',
      );
      final stageId = OvcServiceWellBeingAssessmentConstant.programStage;
      final events = all.where((e) => e.programStage == stageId).toList();
      if (events.isEmpty) return false;

      events.sort((a, b) => (b.eventDate ?? '').compareTo(a.eventDate ?? ''));
      final dvs = (events.first.dataValues as List?) ?? const [];
      String hiv = '';
      bool onArt = false;
      for (final dv in dvs) {
        if (dv is Map) {
          final de = (dv['dataElement'] ?? '').toString();
          final val = (dv['value'] ?? '').toString();
          if (de == childHivDe) hiv = val.toLowerCase();
          if (de == artDe) onArt = _isTrue(val);
        }
      }
      return (hiv == 'positive' || hiv == '1' || hiv == 'true') && onArt;
    }
  }

  Future<String?> _pickMonitoringType(BuildContext context, {required bool canShowVl}) async {
    final options = <String>['Assessment monitoring', if (canShowVl) 'Viral load monitoring'];
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text('Choose monitoring type',
                  style: Theme.of(ctx).textTheme.titleMedium),
              const Divider(),
              for (final opt in options)
                ListTile(
                  title: Text(opt),
                  onTap: () => Navigator.pop(ctx, opt),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void onManageCasePlanGapServiceMonitoring({
    Map? gapServiceMonitoringObject,
    bool isOnEditMode = true,
  }) async {
    double ratio = 0.8;
    gapServiceMonitoringObject = gapServiceMonitoringObject ?? {};

    // 1) Decide what to show
    final canShowVl = await _isPositiveAndOnArt(context);
    final picked = await _pickMonitoringType(context, canShowVl: canShowVl);
    if (picked == null) return;

    // 2) Seed the payload, keeping linkages and case plan date
    String location = (gapServiceMonitoringObject['location'] ?? '').toString();
    String casePlanGapDate = (widget.casePlanGap['eventDate'] ?? '').toString();

    const skippedKeys = [
      'eventId',
      'eventDate',
      UserAccountReference.appAndDeviceTrackingDataElement,
      UserAccountReference.implementingPartnerDataElement,
      UserAccountReference.subImplementingPartnerDataElement,
      UserAccountReference.serviceProviderDataElement
    ];

    final Map<String, dynamic> obj = <String, dynamic>{};
    // bring incoming edit values
    gapServiceMonitoringObject.forEach((k, v) => obj[k.toString()] = v);
    // copy from the gap, preserving linkages
    widget.casePlanGap.forEach((key, value) {
      final k = key.toString();
      if (!skippedKeys.contains(k) && !obj.containsKey(k)) {
        obj[k] = value;
      }
    });
    obj['location'] = location;
    obj['casePlanDate'] = casePlanGapDate;

    // 3) Route to correct monitoring form
    if (picked == 'Viral load monitoring') {
      AppUtil.showActionSheetModal(
        context: context,
        initialHeightRatio: ratio,
        maxHeightRatio: ratio,
        containerBody: ViralLoadMonitoringFormContainer(
          domainId: widget.domainId,
          formSectionColor: widget.formSectionColor,
          gapServiceMonitoringObject: obj,
          isHouseholdCasePlan: widget.isHouseholdCasePlan,
          enrollmentOuAccessible: widget.enrollmentOuAccessible,
          isEditableMode: isOnEditMode,
          casePlanGapDate: casePlanGapDate,
        ),
      );
    } else {
      AppUtil.showActionSheetModal(
        context: context,
        initialHeightRatio: ratio,
        maxHeightRatio: ratio,
        containerBody: CasePlanGapServiceMonitoringFormContainer(
          domainId: widget.domainId,
          formSectionColor: widget.formSectionColor,
          gapServiceMonitoringObject: obj,
          isHouseholdCasePlan: widget.isHouseholdCasePlan,
          enrollmentOuAccessible: widget.enrollmentOuAccessible,
          isEditableMode: isOnEditMode,
          casePlanGapDate: casePlanGapDate,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OvcHouseholdCurrentSelectionState>(
      builder: (context, state, child) {
        var hasBeneficiaryExited = widget.isHouseholdCasePlan
            ? state.currentOvcHousehold?.hasExitedProgram
            : state.currentOvcHousehold?.hasExitedProgram == true ||
            state.currentOvcHouseholdChild?.hasExitedProgram == true;
        return Container(
          margin: const EdgeInsets.symmetric(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CasePlanGapServiceMonitoringView(
                  domainId: widget.domainId,
                  formSectionColor: widget.formSectionColor,
                  casePlanGap: widget.casePlanGap,
                  isHouseholdCasePlan: widget.isHouseholdCasePlan,
                  hasEditAccess: hasBeneficiaryExited != true,
                  onViewCasePlanServiceMonitoring: (Map dataObject) =>
                      onManageCasePlanGapServiceMonitoring(
                        gapServiceMonitoringObject: dataObject,
                        isOnEditMode: false,
                      ),
                  onEditCasePlanServiceMonitoring: (Map dataObject) =>
                      onManageCasePlanGapServiceMonitoring(
                        gapServiceMonitoringObject: dataObject,
                        isOnEditMode: true,
                      ),
                ),
              ),
              Consumer<CurrentUserState>(
                builder: (context, currentUserState, child) {
                  bool isKbFacilitySocialWorker =
                      currentUserState.isKbFacilitySocialWorker;
                  return Visibility(
                    visible: !isKbFacilitySocialWorker &&
                        hasBeneficiaryExited != true,
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: widget.formSectionColor),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.all(15.0),
                        ),
                        onPressed: onManageCasePlanGapServiceMonitoring,
                        child: Consumer<LanguageTranslationState>(
                          builder: (context, languageTranslationState, child) =>
                              Text(
                                languageTranslationState.isSesothoLanguage
                                    ? 'KENYA TLHOKOMELO'
                                    : 'ADD MONITORING',
                                style: const TextStyle().copyWith(
                                  color: widget.formSectionColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
