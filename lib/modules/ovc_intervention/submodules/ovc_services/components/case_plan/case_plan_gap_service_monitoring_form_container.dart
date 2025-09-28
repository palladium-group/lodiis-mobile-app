
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final Map gapServiceMonitoringObject;
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

  // ---- Ensure CP + Domain (and stable MON id) are always present on the object ----
  void _ensureCpAndDomainOnObject(Map obj) {
    const cpKey  = OvcCasePlanConstant.casePlanToGapLinkage;
    const domKey = OvcCasePlanConstant.casePlanDomainType;
    const monKey = OvcCasePlanConstant.casePlanGapToMonitoringLinkage;

    // domain must always be stamped
    obj[domKey] = widget.domainId;

    // keep a stable monitoring linkage if missing
    final cp = (obj[cpKey] ?? '').toString();
    if ((obj[monKey] ?? '').toString().isEmpty && cp.isNotEmpty) {
      obj[monKey] = '$cp|${widget.domainId}';
    }
  }

  @override
  void initState() {
    super.initState();
    setFormMetdata();
  }

  void setFormMetdata() {
    final household = Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
        .currentOvcHousehold;

    mandatoryFieldObject.clear();
    formSections = widget.isHouseholdCasePlan
        ? HouseholdServicesOngoingMonitoring.getFormSections()
        : OvcServicesOngoingMonitoring.getFormSections();

    formSections = formSections
        .where((formSection) =>
    formSection.id == widget.domainId ||
        formSection.id == '' ||
        formSection.id == null)
        .toList();

    // Event date section
    formSections = [
      AppUtil.getServiceProvisionEventDateSection(
        inputColor: widget.formSectionColor,
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: widget.formSectionColor,
        formSectionLabel: 'Service Monitoring Date',
        inputFieldLabel: 'Service Monitoring On',
        firstDate: widget.casePlanGapDate,
      ),
      ...formSections
    ];
    mandatoryFields = ['eventDate'];

    // Optional Location
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
      final orgUnit = (widget.gapServiceMonitoringObject['location'] ?? '').toString();
      onInputValueChange('location', orgUnit);
      mandatoryFields.add('location');
    }

    formSections = formSections.map((f) => f..borderColor = Colors.transparent).toList();
    for (final field in mandatoryFields) {
      mandatoryFieldObject[field] = true;
    }

    // Ensure CP + Domain present on the object before skip logic
    _ensureCpAndDomainOnObject(widget.gapServiceMonitoringObject);

    Timer(const Duration(milliseconds: 200), () {
      _isFormReady = true;
      evaluateSkipLogics(
        context,
        formSections,
        widget.gapServiceMonitoringObject,
        household?.hivStatus,
        household?.artStatus,
        household?.sex,
        household?.caregiverTestedForHiv,
        household?.artInitiationDate,
      );
      setState(() {});
    });
  }

  void onInputValueChange(String id, dynamic value) {
    final household = Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
        .currentOvcHousehold;

    widget.gapServiceMonitoringObject[id] = value;

    // Keep CP + Domain stamped as user edits
    _ensureCpAndDomainOnObject(widget.gapServiceMonitoringObject);

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
    );
  }

  Future<void> onSaveCasePlanMonitoring() async {
    final hasAnyField = FormUtil.hasAtLeastOnFieldFilled(
      hiddenFields: hiddenFields,
      formSections: formSections,
      dataObject: widget.gapServiceMonitoringObject,
    );
    final allMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
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
    if (!allMandatoryFilled) {
      AppUtil.showToastMessage(message: 'Please fill all mandatory fields');
      return;
    }
    if (!hasAnyField) {
      AppUtil.showToastMessage(message: 'Please fill at least one field');
      return;
    }

    // Ensure CP + Domain before save
    _ensureCpAndDomainOnObject(widget.gapServiceMonitoringObject);

    const cpKey  = OvcCasePlanConstant.casePlanToGapLinkage;
    const domKey = OvcCasePlanConstant.casePlanDomainType;
    final cp = (widget.gapServiceMonitoringObject[cpKey] ?? '').toString();
    if (cp.isEmpty) {
      AppUtil.showToastMessage(
        message: 'Missing Case Plan link. Please open monitoring from a Case Plan domain.',
      );
      return;
    }
    widget.gapServiceMonitoringObject[domKey] = widget.domainId;

    _isSaving = true;
    setState(() {});

    try {
      final sel = Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);
      final TrackedEntityInstance beneficiary = widget.isHouseholdCasePlan
          ? (sel.currentOvcHousehold?.teiData)!
          : (sel.currentOvcHouseholdChild?.teiData)!;

      String orgUnit = (widget.gapServiceMonitoringObject['location'] ?? '').toString();
      if (orgUnit.isEmpty) orgUnit = (beneficiary.orgUnit ?? '');

      final String eventDate = (widget.gapServiceMonitoringObject['eventDate'] ?? '').toString();

      // Include CP link & domain in hidden fields so they are actually persisted
      final List<String> hidden = <String>[
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanDomainType,
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      ];

      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        widget.isHouseholdCasePlan
            ? OvcHouseholdCasePlanConstant.program
            : OvcChildCasePlanConstant.program,
        widget.isHouseholdCasePlan
            ? OvcHouseholdCasePlanConstant.casePlanGapServiceMonitoringProgramStage
            : OvcChildCasePlanConstant.casePlanGapServiceMonitoringProgramStage,
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

      final lang = Provider.of<LanguageTranslationState>(context, listen: false)
          .currentLanguage;
      AppUtil.showToastMessage(
        message: lang == 'lesotho'
            ? 'Fomo e bolokeile'
            : 'Form has been saved successfully',
      );
      if (Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      AppUtil.showToastMessage(message: e.toString());
    } finally {
      _isSaving = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        final currentLanguage = languageTranslationState.currentLanguage;

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
                            ? (currentLanguage == 'lesotho'
                            ? 'E ntse e boloka...'
                            : 'SAVING MONITORING ...')
                            : (currentLanguage == 'lesotho'
                            ? 'Boloka Tlhokomelo'
                            : 'SAVE MONITORING'),
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

