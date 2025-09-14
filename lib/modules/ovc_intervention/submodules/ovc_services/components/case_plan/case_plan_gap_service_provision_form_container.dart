
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';

import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/household_service_provision.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_service_provision.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/skip_logics/ovc_case_plan_service_provision_skip_logic.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_service_provision_household_to_ovc_util.dart';

class CasePlanGapServiceProvisionFormContainer extends StatefulWidget {
  const CasePlanGapServiceProvisionFormContainer({
    Key? key,
    required this.gapServiceObject,         // Map<String, dynamic>
    required this.isHouseholdCasePlan,
    required this.enrollmentOuAccessible,
    required this.domainId,
    required this.isEditableMode,
    required this.formSectionColor,
  }) : super(key: key);

  final Map gapServiceObject;
  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;
  final String domainId;
  final bool isEditableMode;
  final Color formSectionColor;

  @override
  State<CasePlanGapServiceProvisionFormContainer> createState() =>
      _CasePlanGapServiceProvisionFormContainerState();
}

class _CasePlanGapServiceProvisionFormContainerState
    extends State<CasePlanGapServiceProvisionFormContainer>
    with OvcCasePlanServiceProvisionSkipLogic {
  bool _isFormReady = false;
  bool _isSaving = false;

  List<FormSection> formSections = [];
  final List<String> mandatoryFields = [];
  final Map mandatoryFieldObject = {};
  List _unFilledMandatoryFields = [];

  static const String cpKey = OvcCasePlanConstant.casePlanToGapLinkage;
  static const String spKey = OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;

  @override
  void initState() {
    super.initState();
    _setFormMetadata();
  }

  void _setFormMetadata() {
    if (kDebugMode) {
      debugPrint(
          '[SP Form] init for domain="${widget.domainId}" isHH=${widget.isHouseholdCasePlan}, editable=${widget.isEditableMode}');
    }

    mandatoryFieldObject.clear();
    formSections = widget.isHouseholdCasePlan
        ? HouseholdServiceProvision.getFormSections(
        firstDate: widget.gapServiceObject['casePlanDate'] ??
            AppUtil.formattedDateTimeIntoString(DateTime.now()))
        : OvcServicesChildServiceProvision.getFormSections(
        firstDate: widget.gapServiceObject['casePlanDate'] ??
            AppUtil.formattedDateTimeIntoString(DateTime.now()));

    // Keep only this domain
    formSections = formSections
        .where((s) => (s.id ?? '') == widget.domainId)
        .map((s) {
      s.borderColor = Colors.transparent;
      return s;
    })
        .toList();

    // All DATE fields are mandatory
    mandatoryFields.addAll(
      FormUtil.getInputFieldIdsByValueType(
        valueType: "DATE",
        formSections: formSections,
      ),
    );

    // Add location selector section when OU is not accessible
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
      // pre-seed location if present
      final orgUnit = (widget.gapServiceObject['location'] ?? '').toString();
      if (orgUnit.isNotEmpty) {
        onInputValueChange('location', orgUnit);
      }
      mandatoryFields.add('location');
    }

    // Build mandatory object
    for (final f in mandatoryFields) {
      mandatoryFieldObject[f] = true;
    }

    // Evaluate skip-logic async (after UI builds)
    Timer(const Duration(milliseconds: 150), () {
      _isFormReady = true;
      evaluateSkipLogics(context, formSections, widget.gapServiceObject);
      if (mounted) setState(() {});
    });
  }

  void onInputValueChange(String id, dynamic value) {
    widget.gapServiceObject[id] = value;
    if (kDebugMode) debugPrint('[SP Form] onChange "$id"="$value"');
    setState(() {});
    evaluateSkipLogics(context, formSections, widget.gapServiceObject);
    // clear any previous mandatory marks
    _unFilledMandatoryFields = [];
    setState(() {});
  }

  List<String> _serviceProvisionDates() {
    return FormUtil.getInputFieldIdsByValueType(
      valueType: "DATE",
      formSections: formSections,
    ).map((inputFieldId) {
      final date = (widget.gapServiceObject[inputFieldId] ?? '').toString();
      return date;
    }).toList();
  }

  Future<void> _save() async {
    // Validate required linkages so list-views can find this event later
    final String cpLink = (widget.gapServiceObject[cpKey] ?? '').toString().trim();
    final String spLink = (widget.gapServiceObject[spKey] ?? '').toString().trim();

    if (cpLink.isEmpty || spLink.isEmpty) {
      AppUtil.showToastMessage(
          message: 'Case plan/service linkage missing. Open from the Service Provision tab again.');
      if (kDebugMode) {
        debugPrint('[SP Save] ABORT: missing linkages cp="$cpLink" sp="$spLink"');
      }
      return;
    }

    // Mandatory check (DATE + location if applicable)
    final hasAll = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      widget.gapServiceObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections,
      ),
    );
    _unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
      mandatoryFields,
      widget.gapServiceObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections,
      ),
    );
    setState(() {});
    if (!hasAll) {
      AppUtil.showToastMessage(message: 'Please fill all mandatory fields');
      return;
    }

    _isSaving = true;
    setState(() {});
    try {
      // Resolve beneficiary & orgUnit
      final hhSel = Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);
      final TrackedEntityInstance beneficiary = widget.isHouseholdCasePlan
          ? hhSel.currentOvcHousehold!.teiData!
          : hhSel.currentOvcHouseholdChild!.teiData!;
      String orgUnit = (widget.gapServiceObject['location'] ?? '').toString();
      if (orgUnit.isEmpty) {
        orgUnit = beneficiary.orgUnit ?? '';
      }

      // Pick event date = earliest of provided DATEs (or today)
      final dateList = _serviceProvisionDates().where((e) => e.toString().isNotEmpty).toList();
      final eventDate = widget.gapServiceObject['eventDate'] ??
          AppUtil.formattedDateTimeIntoString(
            AppUtil.getMinimumDateTimeFromDateList(dateList),
          );

      final program = widget.isHouseholdCasePlan
          ? OvcHouseholdCasePlanConstant.program
          : OvcChildCasePlanConstant.program;
      final stage = widget.isHouseholdCasePlan
          ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
          : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;

      if (kDebugMode) {
        debugPrint('[SP Save] domain="${widget.domainId}" HH=${widget.isHouseholdCasePlan}');
        debugPrint('[SP Save] program=$program stage=$stage');
        debugPrint('[SP Save] tei=${beneficiary.trackedEntityInstance} ou=$orgUnit');
        debugPrint('[SP Save] date=$eventDate');
        debugPrint('[SP Save] linkages: cp="$cpLink", sp="$spLink"');
        debugPrint('[SP Save] eventId="${widget.gapServiceObject['eventId'] ?? ''}"');
        debugPrint('[SP Save] payload keys=${widget.gapServiceObject.keys.toList()}');
      }

      // Persist HH SP event (must include cp & sp linkages so list-views find it)
      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        program,
        stage,
        orgUnit,
        formSections,
        widget.gapServiceObject,
        eventDate,
        beneficiary.trackedEntityInstance,
        widget.gapServiceObject['eventId'],
        const [cpKey, spKey],
      );

      // Propagate to eligible children (only in HH SP)
      if (widget.isHouseholdCasePlan) {
        final childrens = hhSel.currentOvcHousehold?.children ?? <OvcHouseholdChild>[];
        await OvcCasePlanServiceProvisionHouseholdToOvcUtil
            .autoSyncOvcsCasePlanServiceProvisions(
          childrens: childrens,
          hhSpObject: Map<String, dynamic>.from(widget.gapServiceObject),
          domainId: widget.domainId,
          orgUnit: orgUnit,
          eventDate: eventDate,
        );
      }

      // Refresh event lists
      Provider.of<ServiceEventDataState>(context, listen: false)
          .resetServiceEventDataState(beneficiary.trackedEntityInstance);

      final lang = Provider.of<LanguageTranslationState>(context, listen: false).currentLanguage;
      AppUtil.showToastMessage(
        message: lang == 'lesotho'
            ? 'Fomo e bolokeile'
            : 'Form has been saved successfully',
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _isSaving = false;
      if (mounted) setState(() {});
      AppUtil.showToastMessage(message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: !_isFormReady
          ? const CircularProcessLoader(color: Colors.blueGrey)
          : Column(
        children: [
          EntryFormContainer(
            hiddenFields: hiddenFields,          // from skip-logic mixin (Map)
            hiddenSections: hiddenSections,      // from skip-logic mixin (List)
            elevation: 0.0,
            formSections: formSections,
            mandatoryFieldObject: mandatoryFieldObject,
            dataObject: widget.gapServiceObject,
            isEditableMode: widget.isEditableMode,
            onInputValueChange: onInputValueChange,
            unFilledMandatoryFields: _unFilledMandatoryFields,
          ),
          Visibility(
            visible: widget.isEditableMode,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Consumer<LanguageTranslationState>(
                builder: (context, t, child) {
                  final saving = _isSaving;
                  final label = t.currentLanguage == 'lesotho'
                      ? (saving ? 'E EA BOLOKA LITSEBELETSO ...' : 'BOLOKA LITSEBELETSO')
                      : (saving ? 'SAVING SERVICE ...' : 'SAVE SERVICE');
                  return TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: widget.formSectionColor,
                    ),
                    onPressed: _save,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 22.0),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Color(0xFFFAFAFA),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------ helpers for error messages (unchanged) ------------
  List<String> getInputFieldsLabel(
      List<FormSection> formSections,
      List<String> inputFieldIds,
      ) {
    String? currentLanguage =
        Provider.of<LanguageTranslationState>(context, listen: false)
            .currentLanguage;
    List<String> inputFieldLabels = [];
    for (FormSection formSection in formSections) {
      for (InputField inputField in formSection.inputFields ?? []) {
        if (inputFieldIds.contains(inputField.id)) {
          if (inputField.id != '' &&
              inputField.id != 'location' &&
              inputField.valueType != 'CHECK_BOX') {
            String? label = currentLanguage == 'lesotho' &&
                (inputField.translatedName ?? '').isNotEmpty
                ? inputField.translatedName
                : inputField.name;
            inputFieldLabels.add(label ?? '');
          }
          if (inputField.valueType == 'CHECK_BOX') {
            for (var option in inputField.options ?? []) {
              String? label = currentLanguage == 'lesotho' &&
                  (option.translatedName ?? '').isNotEmpty
                  ? option.translatedName
                  : option.name;
              inputFieldLabels.add(label ?? '');
            }
          }
        }
      }
      List<String> subLabels =
      getInputFieldsLabel(formSection.subSections ?? [], inputFieldIds);
      inputFieldLabels.addAll(subLabels);
    }
    return inputFieldLabels.toSet().toList();
  }
}

