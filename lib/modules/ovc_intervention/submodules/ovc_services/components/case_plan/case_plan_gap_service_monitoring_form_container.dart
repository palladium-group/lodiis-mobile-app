
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/household_services_ongoing_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_ongoing_monitoring.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/skip_logics/ovc_service_monitoring_skip_logic.dart';
import 'package:provider/provider.dart';

class CasePlanGapServiceMonitoringFormContainer extends StatefulWidget {
  const CasePlanGapServiceMonitoringFormContainer({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.gapServiceMonitoringObject,
    required this.isHouseholdCasePlan,
    required this.enrollmentOuAccessible,
    required this.isEditableMode,
    required this.casePlanGapDate,
  }) : super(key: key);

  final String domainId;
  final String casePlanGapDate;
  final Color formSectionColor;
  final Map gapServiceMonitoringObject; // MUST contain cp linkage on open
  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;
  final bool isEditableMode;

  @override
  State<CasePlanGapServiceMonitoringFormContainer> createState() =>
      _CasePlanGapServiceMonitoringFormContainerState();
}

class _CasePlanGapServiceMonitoringFormContainerState
    extends State<CasePlanGapServiceMonitoringFormContainer>
    with OvcServiceMonitoringSkipLogic {
  bool _isFormReady = false;
  bool _isSaving = false;
  List<FormSection> formSections = [];
  List<String> mandatoryFields = [];
  List unFilledMandatoryFields = [];
  Map mandatoryFieldObject = {};

  static const String _cpDe = OvcCasePlanConstant.casePlanToGapLinkage;
  static const String _monDe = OvcCasePlanConstant.casePlanGapToMonitoringLinkage;

  @override
  void initState() {
    super.initState();
    setFormMetdata();
  }

  void setFormMetdata() {
    OvcHousehold? household = Provider.of<OvcHouseholdCurrentSelectionState>(
      context,
      listen: false,
    ).currentOvcHousehold;

    mandatoryFieldObject.clear();

    formSections = widget.isHouseholdCasePlan
        ? HouseholdServicesOngoingMonitoring.getFormSections()
        : OvcServicesOngoingMonitoring.getFormSections();

    formSections = formSections;

    // Add event date section at the top
    formSections = [
      AppUtil.getServiceProvisionEventDateSection(
        inputColor: widget.formSectionColor,
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: widget.formSectionColor,
        formSectionLabel: 'Monitoring Date',
        inputFieldLabel: 'Monitoring On',
        firstDate: widget.casePlanGapDate,
      ),
      ...formSections
    ];

    mandatoryFields = ['eventDate'];

    if (!widget.enrollmentOuAccessible) {
      formSections = [
        AppUtil.getServiceProvisionLocationSection(
          id: OvcCasePlanConstant.casePlanLocatinSectionId,
          inputColor: widget.formSectionColor,
          labelColor: const Color(0xFF1A3518),
          sectionLabelColor: widget.formSectionColor,
          formlabel: 'Location',
          allowedSelectedLevels: [AppHierarchyReference.communityLevel],
          program: widget.isHouseholdCasePlan
              ? OvcHouseholdCasePlanConstant.program
              : OvcChildCasePlanConstant.program,
        ),
        ...formSections
      ];
      String orgUnit = widget.gapServiceMonitoringObject['location'] ?? '';
      onInputValueChange('location', orgUnit);
      mandatoryFields.add('location');
    }

    formSections = formSections
        .map((formSection) => formSection..borderColor = Colors.transparent)
        .toList();

    for (String field in mandatoryFields) {
      mandatoryFieldObject[field] = true;
    }

    // Ensure linkages exist in the object before rendering
    _ensureLinkages();

    Timer(const Duration(milliseconds: 200), () async {
      _isFormReady = true;
     await  evaluateSkipLogics(
        context,
        formSections,
        widget.gapServiceMonitoringObject,
        household?.hivStatus,
        household?.artStatus,
        household?.sex,
        household?.caregiverTestedForHiv,
        household?.artInitiationDate,
       household?.age
      );
      setState(() {});
    });
  }

  void _ensureLinkages() {
    final domain = widget.domainId;
    final cp = (widget.gapServiceMonitoringObject[_cpDe] ??
        widget.gapServiceMonitoringObject['cp'] ??
        '')
        .toString();

    if (cp.isEmpty && kDebugMode) {
      debugPrint(
          '[MON Init] WARNING: cp linkage missing in gapServiceMonitoringObject. '
              'This should be set by the ViewContainer (cp=$cp, domain=$domain)');
    }

    final mon = '$cp|$domain';
    if ((widget.gapServiceMonitoringObject[_monDe] ?? '').toString().isEmpty) {
      widget.gapServiceMonitoringObject[_monDe] = mon;
    }

    if (kDebugMode) {
      debugPrint('[MON Init] domain=$domain cp="$cp" mon="$mon" keys=${widget.gapServiceMonitoringObject.keys.toList()}');
    }
  }

  void onInputValueChange(String id, dynamic value) {
    OvcHousehold? household = Provider.of<OvcHouseholdCurrentSelectionState>(
      context,
      listen: false,
    ).currentOvcHousehold;

    widget.gapServiceMonitoringObject[id] = value;
    setState(() {});
    evaluateSkipLogics(
      context,
      formSections,
      widget.gapServiceMonitoringObject,
      household?.hivStatus,
      household?.artStatus,
      household?.sex,
      household?.caregiverTestedForHiv,
      household?.artInitiationDate,
      household?.age
    );
  }

  void onSaveCasePlanMonitoring() async {
    bool hasAtLeastOneFilled = FormUtil.hasAtLeastOnFieldFilled(
      hiddenFields: hiddenFields,
      formSections: formSections,
      dataObject: widget.gapServiceMonitoringObject,
    );
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      widget.gapServiceMonitoringObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections,
      ),
    );

    unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
      mandatoryFields,
      widget.gapServiceMonitoringObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections,
      ),
    );
    setState(() {});

    if (!hadAllMandatoryFilled) {
      AppUtil.showToastMessage(message: 'Please fill all mandatory fields');
      return;
    }
    if (!hasAtLeastOneFilled) {
      AppUtil.showToastMessage(message: 'Please fill at least one field');
      return;
    }

    _isSaving = true;
    setState(() {});
    try {
      // Force linkages
      final domain = widget.domainId;
      final cp = (widget.gapServiceMonitoringObject[_cpDe] ??
          widget.gapServiceMonitoringObject['cp'] ??
          '')
          .toString();
      final mon = '$cp|$domain';

      widget.gapServiceMonitoringObject[_cpDe] = cp;
      widget.gapServiceMonitoringObject[_monDe] = mon;

      // program + stage
      final isHH = widget.isHouseholdCasePlan;
      final program = isHH
          ? OvcHouseholdCasePlanConstant.program
          : OvcChildCasePlanConstant.program;
      final stage = isHH
          ? OvcHouseholdCasePlanConstant.casePlanGapServiceMonitoringProgramStage
          : OvcChildCasePlanConstant.casePlanGapServiceMonitoringProgramStage;

      // tei + orgUnit + date
      final sel = Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);
      TrackedEntityInstance beneficiary = isHH
          ? sel.currentOvcHousehold!.teiData!
          : sel.currentOvcHouseholdChild!.teiData!;

      String orgUnit =
          widget.gapServiceMonitoringObject['location'] ?? beneficiary.orgUnit ?? '';
      if (orgUnit.isEmpty) orgUnit = beneficiary.orgUnit ?? '';
      String eventDate = widget.gapServiceMonitoringObject['eventDate'];

      if (kDebugMode) {
        debugPrint('[MON Save] isHH=$isHH '
            'tei=${beneficiary.trackedEntityInstance} '
            'ou=$orgUnit date=$eventDate cp=$cp mon=$mon domain=$domain '
            'stage=$stage keys=${widget.gapServiceMonitoringObject.keys.toList()}');
      }

      // Save (don’t hide CP; MON can be hidden if you don’t want it edited)
      final hidden = <String>[
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      ];

      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        program,
        stage,
        orgUnit,
        formSections,
        widget.gapServiceMonitoringObject,
        eventDate,
        beneficiary.trackedEntityInstance,
        widget.gapServiceMonitoringObject['eventId'],
        hidden,
      );

      Provider.of<ServiceEventDataState>(context, listen: false)
          .resetServiceEventDataState(beneficiary.trackedEntityInstance);

      final currentLanguage =
          Provider.of<LanguageTranslationState>(context, listen: false)
              .currentLanguage;
      AppUtil.showToastMessage(
          message: currentLanguage == 'lesotho'
              ? 'Fomo e bolokeile'
              : 'Form has been saved successfully');
      Navigator.pop(context);
    } catch (e) {
      _isSaving = false;
      setState(() {});
      AppUtil.showToastMessage(message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 15.0),
          child: !_isFormReady
              ? const CircularProcessLoader(color: Colors.blueGrey)
              : Column(
            children: [
              EntryFormContainer(
                hiddenFields: hiddenFields,
                hiddenSections: hiddenSections,
                elevation: 0.0,
                formSections: formSections,
                mandatoryFieldObject: mandatoryFieldObject,
                unFilledMandatoryFields: unFilledMandatoryFields,
                dataObject: widget.gapServiceMonitoringObject,
                isEditableMode: widget.isEditableMode,
                onInputValueChange: onInputValueChange,
              ),
              Visibility(
                visible: widget.isEditableMode,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: widget.formSectionColor,
                    ),
                    onPressed: onSaveCasePlanMonitoring,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 22.0),
                      child: Text(
                        _isSaving
                            ? currentLanguage == 'lesotho'
                            ? 'E ntse e boloka tlhahlobo e hlophisitsoeng ea lelapa'
                            : 'SAVING MONITORING ...'
                            : currentLanguage == 'lesotho'
                            ? 'Boloka tlhahlobo e hlophisitsoeng ea lelapa'
                            : 'SAVE MONITORING',
                        style: const TextStyle(
                          color: Color(0xFFFAFAFA),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
