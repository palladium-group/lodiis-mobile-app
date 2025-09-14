
import 'dart:async';
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
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_service_provision_util.dart';

class CasePlanGapServiceProvisionFormContainer extends StatefulWidget {
  const CasePlanGapServiceProvisionFormContainer({
    Key? key,
    required this.gapServiceObject,
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
  List<String> mandatoryFields = [];
  Map mandatoryFieldObject = {};
  List _unFilledMandatoryFields = [];

  static const String _cpDe = OvcCasePlanConstant.casePlanToGapLinkage;
  static const String _spDe =
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage;

  @override
  void initState() {
    super.initState();
    setFormMetadata();
  }

  void setFormMetadata() {
    if (kDebugMode) {
      debugPrint('[SP Form] init for domain="${widget.domainId}" '
          'isHH=${widget.isHouseholdCasePlan}, editable=${widget.isEditableMode}');
    }

    mandatoryFieldObject.clear();

    formSections = widget.isHouseholdCasePlan
        ? HouseholdServiceProvision.getFormSections(
      firstDate: widget.gapServiceObject['casePlanDate'] ??
          AppUtil.formattedDateTimeIntoString(DateTime.now()),
    )
        : OvcServicesChildServiceProvision.getFormSections(
      firstDate: widget.gapServiceObject['casePlanDate'] ??
          AppUtil.formattedDateTimeIntoString(DateTime.now()),
    );

    formSections =
        formSections.where((s) => (s.id ?? '') == widget.domainId).toList();

    // Make DATEs mandatory for submit
    mandatoryFields.addAll(
      FormUtil.getInputFieldIdsByValueType(
        valueType: "DATE",
        formSections: formSections,
      ),
    );

    // If OU not accessible, inject Location section
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
      final orgUnit = (widget.gapServiceObject['location'] ?? '').toString();
      onInputValueChange('location', orgUnit);
      mandatoryFields.add('location');
    }

    // Style tweak
    formSections = formSections
        .map((fs) {
      fs.borderColor = Colors.transparent;
      return fs;
    })
        .toList();

    for (final f in mandatoryFields) {
      mandatoryFieldObject[f] = true;
    }

    // Ensure linkages exist on the payload we’re about to save
    if ('${widget.gapServiceObject[_cpDe] ?? ''}'.trim().isEmpty) {
      // you pass CP from caller; if not, keep it blank (UI won’t list under CP-grouped views)
      // but propagation will still create child gap if needed.
    }
    if ('${widget.gapServiceObject[_spDe] ?? ''}'.trim().isEmpty) {
      widget.gapServiceObject[_spDe] = AppUtil.getUid();
    }

    Timer(const Duration(milliseconds: 150), () {
      _isFormReady = true;
      evaluateSkipLogics(context, formSections, widget.gapServiceObject);
      setState(() {});
    });
  }

  void onInputValueChange(String id, dynamic value) {
    widget.gapServiceObject[id] = value;
    if (kDebugMode) {
      debugPrint('[SP Form] onChange "$id"="${widget.gapServiceObject[id]}"');
    }
    setState(() {});
    evaluateSkipLogics(context, formSections, widget.gapServiceObject);

    final v = OvcServiceProvisionUtil.getSessionNumberValidation(
        widget.gapServiceObject);
    _unFilledMandatoryFields = [];
    setSessionNumberViolationMessages(v);
  }

  List<String> _collectServiceDates() => FormUtil
      .getInputFieldIdsByValueType(valueType: "DATE", formSections: formSections)
      .map((id) => (widget.gapServiceObject[id] ?? '').toString())
      .toList();

  Future<void> _save() async {
    final hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
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
    if (!hadAllMandatoryFilled) {
      AppUtil.showToastMessage(message: 'Please fill all mandatory fields');
      return;
    }

    final v = OvcServiceProvisionUtil.getSessionNumberValidation(
        widget.gapServiceObject);
    setSessionNumberViolationMessages(v);
    if (v["isSessionNumberExit"] == true || v["isSessionNumberInValid"] == true) {
      AppUtil.showToastMessage(
        message: 'Session number is invalid or already exist',
      );
      return;
    }

    _isSaving = true;
    setState(() {});
    try {
      final selection =
      Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);

      final childrens = selection.currentOvcHousehold?.children ?? <OvcHouseholdChild>[];
      final TrackedEntityInstance beneficiary = widget.isHouseholdCasePlan
          ? selection.currentOvcHousehold!.teiData!
          : selection.currentOvcHouseholdChild!.teiData!;

      String orgUnit =
      (widget.gapServiceObject['location'] ?? beneficiary.orgUnit ?? '')
          .toString();
      if (orgUnit.isEmpty) orgUnit = beneficiary.orgUnit ?? '';

      final eventDate = (widget.gapServiceObject['eventDate'] ??
          AppUtil.formattedDateTimeIntoString(
            AppUtil.getMinimumDateTimeFromDateList(_collectServiceDates()),
          ))
          .toString();

      final program = widget.isHouseholdCasePlan
          ? OvcHouseholdCasePlanConstant.program
          : OvcChildCasePlanConstant.program;
      final stage = widget.isHouseholdCasePlan
          ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
          : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;

      if (kDebugMode) {
        debugPrint('[SP Save] domain="${widget.domainId}" HH=${widget.isHouseholdCasePlan}');
        debugPrint('[SP Save] program=$program stage=$stage');
        debugPrint(
            '[SP Save] tei=${beneficiary.trackedEntityInstance} ou=$orgUnit date=$eventDate');
        debugPrint('[SP Save] linkages: cp="${widget.gapServiceObject[_cpDe]}", '
            'sp="${widget.gapServiceObject[_spDe]}"');
        debugPrint('[SP Save] eventId="${widget.gapServiceObject['eventId'] ?? ''}"');
        debugPrint('[SP Save] payload keys=${widget.gapServiceObject.keys.toList()}');
      }

      // Save HH/Child service event
      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        program,
        stage,
        orgUnit,
        formSections,
        widget.gapServiceObject,
        eventDate,
        beneficiary.trackedEntityInstance!,
        widget.gapServiceObject['eventId'],
        // Hide linkages on form
        [_cpDe, _spDe],
      );

      // Refresh service-event cache for THIS TEI so views rebuild with the new item
      Provider.of<ServiceEventDataState>(context, listen: false)
          .resetServiceEventDataState(beneficiary.trackedEntityInstance);

      // If HH, propagate to eligible children (age-based)
      if (widget.isHouseholdCasePlan) {
        await OvcCasePlanServiceProvisionHouseholdToOvcUtil
            .autoSyncOvcsCasePlanServiceProvisions(
          childrens: childrens,
          dataObject: Map<String, dynamic>.from(widget.gapServiceObject),
          domainId: widget.domainId,
          orgUnit: orgUnit,
          eventDate: eventDate,
        );

        // IMPORTANT: refresh HH data so lists & header counters update
        await Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .refetchCurrentHousehold();

        // Also reset children caches (optional but keeps lists fresh if you navigate in)
        for (final c in childrens) {
          final id = c.teiData?.trackedEntityInstance ?? c.id;
          if (id != null && id.isNotEmpty) {
            Provider.of<ServiceEventDataState>(context, listen: false)
                .resetServiceEventDataState(id);
          }
        }
      }

      final currentLanguage =
          Provider.of<LanguageTranslationState>(context, listen: false)
              .currentLanguage;

      AppUtil.showToastMessage(
        message: currentLanguage == 'lesotho'
            ? 'Fomo e bolokeile'
            : 'Form has been saved successfully',
      );
      if (Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      if (kDebugMode) debugPrint('[SP Save] ERROR: $e');
      _isSaving = false;
      setState(() {});
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
            hiddenFields: hiddenFields,
            hiddenSections: hiddenSections,
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
                builder: (context, languageTranslationState, child) {
                  final currentLanguage =
                      languageTranslationState.currentLanguage;
                  return TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: widget.formSectionColor,
                    ),
                    onPressed: _save,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 22.0),
                      child: Text(
                        currentLanguage == 'lesotho'
                            ? (_isSaving
                            ? 'E EA BOLOKA LITSEBELETSO ...'
                            : 'BOLOKA LITSEBELETSO')
                            : (_isSaving
                            ? 'SAVING SERVICE ...'
                            : 'SAVE SERVICE'),
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

  void setSessionNumberViolationMessages(
      Map<String, dynamic> sessionNumberValidation,
      ) {
    final isExit = sessionNumberValidation["isSessionNumberExit"] == true;
    final isInvalid = sessionNumberValidation["isSessionNumberInValid"] == true;

    String message = "";
    if (isInvalid) {
      final fields = sessionNumberValidation["sessionWithInvalidSessionNumber"] ?? <String>[];
      final labels = _labelsForIds(fields);
      message = "Session number for $labels are not valid session number";
    } else if (isExit) {
      final fields = sessionNumberValidation["sessionWithExistingSessionNumber"] ?? <String>[];
      final labels = _labelsForIds(fields);
      message = "Session number for $labels already existed for previous service provision";
    }
    if (message.isNotEmpty) {
      AppUtil.showToastMessage(message: message);
    }
  }

  String _labelsForIds(List<String> ids) {
    final lang =
        Provider.of<LanguageTranslationState>(context, listen: false).currentLanguage;
    final labels = <String>[];

    String? labelFor(InputField f) {
      if (f.id == '' || f.id == 'location' || f.valueType == 'CHECK_BOX') {
        return null;
      }
      if (lang == 'lesotho' && (f.translatedName ?? '').isNotEmpty) {
        return f.translatedName;
      }
      return f.name;
    }

    void walk(List<FormSection> sections) {
      for (final s in sections) {
        for (final f in (s.inputFields ?? const <InputField>[])) {
          if (ids.contains(f.id)) {
            final lb = labelFor(f);
            if (lb != null) labels.add(lb);
          }
          if (f.valueType == 'CHECK_BOX') {
            for (final o in (f.options ?? const [])) {
              if (ids.contains(o.code)) {
                labels.add(lang == 'lesotho' && (o.translatedName ?? '').isNotEmpty
                    ? o.translatedName!
                    : o.name!);
              }
            }
          }
        }
        walk(s.subSections ?? const <FormSection>[]);
      }
    }

    walk(formSections);
    return labels.toSet().join(", ");
  }
}
