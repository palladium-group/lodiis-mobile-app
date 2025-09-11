
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:provider/provider.dart';

import '../../models/ovc_viral_load_monitoring_constant.dart';

class ViralLoadMonitoringFormContainer extends StatefulWidget {
  const ViralLoadMonitoringFormContainer({
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
  final Color formSectionColor;
  final Map gapServiceMonitoringObject;
  final bool isHouseholdCasePlan;
  final bool enrollmentOuAccessible;
  final bool isEditableMode;
  final String casePlanGapDate;

  @override
  State<ViralLoadMonitoringFormContainer> createState() =>
      _ViralLoadMonitoringFormContainerState();
}

class _ViralLoadMonitoringFormContainerState extends State<ViralLoadMonitoringFormContainer> {
  late List<FormSection> _sections;
  bool _saving = false;
  final Map<String, dynamic> _data = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _sections = OvcViralLoadMonitoringConstant.getFormSections(color: widget.formSectionColor);

    // seed with incoming (convert keys to String)
    widget.gapServiceMonitoringObject.forEach((k, v) {
      _data[k.toString()] = v;
    });
    _data['casePlanDate'] = widget.casePlanGapDate;
  }

  void _onInputValueChange(String id, dynamic value) {
    _data[id] = value;
    setState(() {});
  }

  Future<void> _save() async {
    if (!_validateHasAnyField()) {
      AppUtil.showToastMessage(message: 'Please fill at least one field');
      return;
    }
    setState(() => _saving = true);

    final selection = context.read<OvcHouseholdCurrentSelectionState>();
    final OvcHousehold? hh = selection.currentOvcHousehold;
    final OvcHouseholdChild? child = selection.currentOvcHouseholdChild;

    final TrackedEntityInstance beneficiary = widget.isHouseholdCasePlan
        ? hh!.teiData!
        : child!.teiData!;

    String orgUnit = widget.enrollmentOuAccessible
        ? (beneficiary.orgUnit ?? '')
        : (hh?.orgUnit ?? beneficiary.orgUnit ?? '');

    final program = widget.isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.program
        : OvcChildCasePlanConstant.program;

    final programStage = widget.isHouseholdCasePlan
        ? OvcViralLoadMonitoringConstant.hhMonitoringProgramStage
        : OvcViralLoadMonitoringConstant.childMonitoringProgramStage;

    final hidden = <String>[
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
    ];

    try {
      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        program,
        programStage,
        orgUnit,
        _sections,
        _data,
        widget.casePlanGapDate, // align under the gap’s date
        beneficiary.trackedEntityInstance,
        _data['eventId'],
        hidden,
      );

      context
          .read<ServiceEventDataState>()
          .resetServiceEventDataState(beneficiary.trackedEntityInstance);

      AppUtil.showToastMessage(message: 'Monitoring saved');
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      AppUtil.showToastMessage(message: 'Failed to save: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  bool _validateHasAnyField() {
    const blocked = <String>{
      'eventId',
      'eventDate',
      'location',
      OvcCasePlanConstant.casePlanToGapLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
    };
    return _data.keys.any((k) => !blocked.contains(k) && '${_data[k]}'.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.formSectionColor;
    return Column(
      children: [
        EntryFormContainer(
          elevation: 0.0,
          formSections: _sections,
          isEditableMode: widget.isEditableMode,
          dataObject: _data,
          onInputValueChange: _onInputValueChange,
          hiddenFields: const <String, dynamic>{},   // ✅ maps, not lists
          hiddenSections: const <String, dynamic>{}, // ✅ maps, not lists
          unFilledMandatoryFields: const <String>[],
          mandatoryFieldObject: const <String, dynamic>{},
        ),
        const SizedBox(height: 16),
        Visibility(
          visible: widget.isEditableMode,
          child: EntryFormSaveButton(
            label: _saving
                ? context.read<LanguageTranslationState>().isSesothoLanguage
                ? 'E ntse e boloka...'
                : 'Saving ...'
                : context.read<LanguageTranslationState>().isSesothoLanguage
                ? 'Boloka'
                : 'Save',
            labelColor: Colors.white,
            buttonColor: color,
            onPressButton: _saving ? null : _save,
          ),
        ),
      ],
    );
  }
}
