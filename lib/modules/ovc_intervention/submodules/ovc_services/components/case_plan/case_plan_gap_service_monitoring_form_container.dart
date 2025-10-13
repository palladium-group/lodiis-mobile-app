
// CasePlanGapServiceMonitoringFormContainer.dart
import 'package:flutter/foundation.dart';
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
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/skip_logics/ovc_service_monitoring_skip_logic_child_u9.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/skip_logics/ovc_service_monitoring_skip_logic_child_9plus.dart';

import '../../models/ovc_child_ongoing_monitoring.dart';

class CasePlanGapServiceMonitoringFormContainer extends StatefulWidget {
  const CasePlanGapServiceMonitoringFormContainer({
    Key? key,
    required this.domainId,
    required this.formSectionColor,
    required this.gapServiceMonitoringObject, // MUST contain _cpDe or 'cp'
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
    extends State<CasePlanGapServiceMonitoringFormContainer> {
  // --- UI state ---
  bool _isFormReady = false;
  bool _isSaving = false;

  // --- Form model ---
  List<FormSection> formSections = [];
  List<String> mandatoryFields = [];
  List unFilledMandatoryFields = [];
  Map mandatoryFieldObject = {};

  // Active hidden maps (updated by skip logic)
  Map _hiddenFields = {};
  Map _hiddenSections = {};

  // --- Linkage DEs (HIDDEN IN UI) ---
  static const String _cpDe  = OvcCasePlanConstant.casePlanToGapLinkage;
  static const String _monDe = OvcCasePlanConstant.casePlanGapToMonitoringLinkage;

  // --- Skip logic instances ---
  final OvcServiceMonitoringSkipLogic _hhSkip = OvcServiceMonitoringSkipLogic();
  final OvcServiceMonitoringSkipLogicChildU9 _childU9Skip =
  OvcServiceMonitoringSkipLogicChildU9();
  final OvcServiceMonitoringSkipLogicChild9Plus _child9PlusSkip =
  OvcServiceMonitoringSkipLogicChild9Plus();

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  // ---------- Helpers ----------
  int _parseAge(String? raw) {
    if (raw == null) return -1;
    final m = RegExp(r'\d+').firstMatch(raw);
    if (m == null) return -1;
    return int.tryParse(m.group(0)!) ?? -1;
  }

  String _ymd(dynamic v) {
    final s = (v ?? '').toString().trim();
    if (s.isEmpty) return '';
    return s.length >= 10 ? s.substring(0, 10) : s; // YYYY-MM-DD
  }

  // Enforce one-per-day by (monKey,eventDate) on the same stage
  bool _existsSameDayWithSameMonKey({
    required String stageId,
    required String monKey,
    required String eventDateYmd,
    required String currentEventId, // '' for new
  }) {
    final sed = Provider.of<ServiceEventDataState>(context, listen: false);
    final byStage = sed.eventListByProgramStage;

    final all = TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(byStage, <String>[stageId]);

    for (final ev in all) {
      if ((ev.event ?? '') == currentEventId) continue; // allow updating self
      final evDateYmd = _ymd(ev.eventDate);
      if (evDateYmd != eventDateYmd) continue;

      // read this event's MON key
      String evMon = '';
      for (final dv in ev.dataValues) {
        final de = (dv['dataElement'] ?? '').toString();
        if (de == _monDe) {
          evMon = (dv['value'] ?? '').toString();
          break;
        }
      }
      if (evMon.isNotEmpty && evMon == monKey) return true;
    }
    return false;
  }
  // --------------------------------

  void _initForm() {
    final sel =
    Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);
    final OvcHousehold? hh = sel.currentOvcHousehold;
    final OvcHouseholdChild? child = sel.currentOvcHouseholdChild;

    mandatoryFieldObject.clear();

    // Pick form sections + mandatory fields
    if (widget.isHouseholdCasePlan) {
      mandatoryFields = [
        'eventDate',
        ...HouseholdServicesOngoingMonitoring.getMandatoryFields()
      ];
      formSections = HouseholdServicesOngoingMonitoring.getFormSections();
    } else {
      final age = _parseAge(child?.age);
      if (age >= 9) {
        formSections = OvcServicesOngoingMonitoring.getFormSections();
        mandatoryFields = [
          'eventDate',
          ...OvcServicesOngoingMonitoring.getMandatoryFields()
        ];
      } else {
        formSections = OvcChildOngoingMonitoring.getFormSections();
        mandatoryFields = [
          'eventDate',
          ...OvcChildOngoingMonitoring.getMandatoryFields()
        ];
      }
    }

    // Add event date section first
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

    // Add location if OU not accessible
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
      final orgUnit =
      (widget.gapServiceMonitoringObject['location'] ?? '').toString();
      onInputValueChange('location', orgUnit);
      mandatoryFields.add('location');
    }

    // Cosmetics
    formSections =
        formSections.map((s) => s..borderColor = Colors.transparent).toList();
    for (final f in mandatoryFields) {
      mandatoryFieldObject[f] = true;
    }

    // Ensure linkages exist in the working object (but hide in UI)
    _ensureLinkages();

    // Always hide link fields from UI
    _hiddenFields[_cpDe] = true;
    _hiddenFields[_monDe] = true;

    // Run initial skip logic to pick up default hidden states
    Future.delayed(const Duration(milliseconds: 100), () async {
      if (widget.isHouseholdCasePlan) {
        await _hhSkip.evaluateSkipLogics(
          context,
          formSections,
          widget.gapServiceMonitoringObject,
          hh?.hivStatus,
          hh?.artStatus,
          hh?.sex,
          hh?.caregiverTestedForHiv,
          hh?.artInitiationDate,
          hh?.age,
        );
        _hiddenFields.addAll(_hhSkip.hiddenFields);
        _hiddenSections = _hhSkip.hiddenSections;
      } else {
        final age = _parseAge(child?.age);
        if (age >= 0 && age < 9) {
          await _childU9Skip.evaluateSkipLogics(
            context,
            formSections,
            widget.gapServiceMonitoringObject,
            child?.hivStatus,
            child?.tested,
            child?.isHei,
            child?.artStatus,
            child?.testedHeiAlgorithm,
          );
          _hiddenFields.addAll(_childU9Skip.hiddenFields);
          _hiddenSections = _childU9Skip.hiddenSections;
        } else {
          await _child9PlusSkip.evaluateSkipLogics(
            context,
            formSections,
            widget.gapServiceMonitoringObject,
            child?.hivStatus,
            child?.tested,
            child?.artStatus,
          );
          _hiddenFields.addAll(_child9PlusSkip.hiddenFields);
          _hiddenSections = _child9PlusSkip.hiddenSections;
        }
      }

      // make sure linkage fields stay hidden
      _hiddenFields[_cpDe] = true;
      _hiddenFields[_monDe] = true;

      _isFormReady = true;
      if (mounted) setState(() {});
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
          '[MON Init] WARNING: cp linkage missing in object. domain=$domain');
    }

    final mon = '$cp|$domain';
    widget.gapServiceMonitoringObject[_cpDe] = cp;
    widget.gapServiceMonitoringObject[_monDe] =
    (widget.gapServiceMonitoringObject[_monDe] ?? '').toString().isEmpty
        ? mon
        : widget.gapServiceMonitoringObject[_monDe];
  }

  Future<void> onInputValueChange(String id, dynamic value) async {
    final sel =
    Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);
    final OvcHousehold? hh = sel.currentOvcHousehold;
    final OvcHouseholdChild? child = sel.currentOvcHouseholdChild;

    widget.gapServiceMonitoringObject[id] = value;

    if (widget.isHouseholdCasePlan) {
      await _hhSkip.evaluateSkipLogics(
        context,
        formSections,
        widget.gapServiceMonitoringObject,
        hh?.hivStatus,
        hh?.artStatus,
        hh?.sex,
        hh?.caregiverTestedForHiv,
        hh?.artInitiationDate,
        hh?.age,
      );
      _hiddenFields = Map.from(_hhSkip.hiddenFields);
      _hiddenSections = Map.from(_hhSkip.hiddenSections);
    } else {
      final age = _parseAge(child?.age);
      if (age >= 0 && age < 9) {
        await _childU9Skip.evaluateSkipLogics(
          context,
          formSections,
          widget.gapServiceMonitoringObject,
          child?.hivStatus,
          child?.tested,
          child?.isHei,
          child?.artStatus,
          child?.testedHeiAlgorithm,
        );
        _hiddenFields = Map.from(_childU9Skip.hiddenFields);
        _hiddenSections = Map.from(_childU9Skip.hiddenSections);
      } else {
        await _child9PlusSkip.evaluateSkipLogics(
          context,
          formSections,
          widget.gapServiceMonitoringObject,
          child?.hivStatus,
          child?.tested,
          child?.artStatus,
        );
        _hiddenFields = Map.from(_child9PlusSkip.hiddenFields);
        _hiddenSections = Map.from(_child9PlusSkip.hiddenSections);
      }
    }

    // keep linkages hidden no matter what
    _hiddenFields[_cpDe] = true;
    _hiddenFields[_monDe] = true;

    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    final hasAtLeastOneFilled = FormUtil.hasAtLeastOnFieldFilled(
      hiddenFields: _hiddenFields,
      formSections: formSections,
      dataObject: widget.gapServiceMonitoringObject,
    );
    final hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      widget.gapServiceMonitoringObject,
      hiddenFields: _hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: formSections,
      ),
    );
    unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
      mandatoryFields,
      widget.gapServiceMonitoringObject,
      hiddenFields: _hiddenFields,
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
      // Linkage (keep & hide from UI)
      final domain = widget.domainId;
      final cp = (widget.gapServiceMonitoringObject[_cpDe] ??
          widget.gapServiceMonitoringObject['cp'] ??
          '')
          .toString();
      final mon = '$cp|$domain';
      widget.gapServiceMonitoringObject[_cpDe] = cp;
      widget.gapServiceMonitoringObject[_monDe] = mon;

      // Program / Stage
      final isHH = widget.isHouseholdCasePlan;
      final program = isHH
          ? OvcHouseholdCasePlanConstant.program
          : OvcChildCasePlanConstant.program;
      final stage = isHH
          ? OvcHouseholdCasePlanConstant
          .casePlanGapServiceMonitoringProgramStage
          : OvcChildCasePlanConstant
          .casePlanGapServiceMonitoringProgramStage;

      // Beneficiary / orgUnit / eventDate
      final sel =
      Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);
      final TrackedEntityInstance beneficiary =
      isHH ? sel.currentOvcHousehold!.teiData! : sel.currentOvcHouseholdChild!.teiData!;
      String orgUnit =
      (widget.gapServiceMonitoringObject['location'] ?? '').toString();
      if (orgUnit.isEmpty) orgUnit = beneficiary.orgUnit ?? '';

      final rawEventDate = widget.gapServiceMonitoringObject['eventDate'];
      final eventDate = _ymd(rawEventDate);
      if (eventDate.isEmpty) {
        _isSaving = false;
        setState(() {});
        AppUtil.showToastMessage(message: 'Monitoring date is missing');
        return;
      }
      widget.gapServiceMonitoringObject['eventDate'] = eventDate;

      // -------- ONE-PER-DAY (by monKey + date) ----------
      final currentEventId =
      (widget.gapServiceMonitoringObject['eventId'] ?? '').toString();
      final exists = _existsSameDayWithSameMonKey(
        stageId: stage,
        monKey: mon,
        eventDateYmd: eventDate,
        currentEventId: currentEventId,
      );
      if (exists) {
        _isSaving = false;
        setState(() {});
        AppUtil.showToastMessage(
          message: 'Monitoring for this case plan already exists on $eventDate',
        );
        return;
      }
      // ---------------------------------------------------

      // Hide MON linkage from the payload on save (optional)
      final hidden = <String>[
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
      ];

      if (kDebugMode) {
        debugPrint('[MON Save] isHH=$isHH tei=${beneficiary.trackedEntityInstance} '
            'ou=$orgUnit date=$eventDate cp=$cp mon=$mon stage=$stage');
      }

      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        program,
        stage,
        orgUnit,
        formSections,
        widget.gapServiceMonitoringObject,
        eventDate,
        beneficiary.trackedEntityInstance,
        currentEventId.isEmpty ? null : currentEventId,
        hidden,
      );

      // Refresh list
      Provider.of<ServiceEventDataState>(context, listen: false)
          .resetServiceEventDataState(beneficiary.trackedEntityInstance);

      final currentLanguage =
          Provider.of<LanguageTranslationState>(context, listen: false)
              .currentLanguage;
      AppUtil.showToastMessage(
        message: currentLanguage == 'lesotho'
            ? 'Fomo e bolokeile'
            : 'Form has been saved successfully',
      );
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
        final currentLanguage = languageTranslationState.currentLanguage;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 15.0),
          child: !_isFormReady
              ? const CircularProcessLoader(color: Colors.blueGrey)
              : Column(
            children: [
              EntryFormContainer(
                hiddenFields: _hiddenFields
                  ..[ _cpDe ] = true
                  ..[ _monDe ] = true,
                hiddenSections: _hiddenSections,
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
                    onPressed: _save,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 22.0),
                      child: Text(
                        _isSaving
                            ? (currentLanguage == 'lesotho'
                            ? 'E ntse e boloka tlhahlobo e hlophisitsoeng ea lelapa'
                            : 'SAVING MONITORING ...')
                            : (currentLanguage == 'lesotho'
                            ? 'Boloka tlhahlobo e hlophisitsoeng ea lelapa'
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
