
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';

import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';

import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_child_info_top_header.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_top_header.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_case_plan_service.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_enrollment_household_service.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/components/case_plan/case_plan_form_container.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_case_plan.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_util.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_gap_household_to_ovc_util.dart';

class OvcCasePlanForm extends StatefulWidget {
  const OvcCasePlanForm({
    Key? key,
    required this.casePlanLabel,
    required this.enrollmentDate,
    required this.currentCasePlanDate,
    required this.hasEditAccessToCasePlan,
    required this.enrollmentOuAccessible,
    required this.isHouseholdCasePlan,
    required this.casePlanProgram,
    required this.casePlanProgramStage,
    required this.casePlanGapProgramStage,
    required this.casePlanServiceProgramStage,
    required this.casePlanMonitoringProgramStage,
    required this.isOnCasePlanPage,
    required this.isOnCasePlanServiceProvision,
    required this.isOnCasePlanServiceMonitoring,
  }) : super(key: key);

  final String casePlanLabel;
  final String currentCasePlanDate;
  final String enrollmentDate;
  final bool hasEditAccessToCasePlan;
  final String casePlanProgram;
  final String casePlanProgramStage;
  final String casePlanGapProgramStage;
  final String casePlanServiceProgramStage;
  final String casePlanMonitoringProgramStage;

  final bool enrollmentOuAccessible;
  final bool isHouseholdCasePlan;
  final bool isOnCasePlanPage;
  final bool isOnCasePlanServiceProvision;
  final bool isOnCasePlanServiceMonitoring;

  @override
  State<OvcCasePlanForm> createState() => _OvcCasePlanFormState();
}

class _OvcCasePlanFormState extends State<OvcCasePlanForm> {
  List<FormSection> formSections = [];
  Map borderColors = {};
  bool _isSaving = false;
  bool _isFormNotReady = true;
  final List<String> mandatoryFields = OvcServicesCasePlan.getMandatoryField();
  final Map mandatoryFieldObject = {};

  // Hide these from the UI
  static const String _goal1Id = OvcCasePlanConstant.casePlanFirstGoal;
  static const String _goal2Id = OvcCasePlanConstant.casePlansSecondGoal;

  @override
  void initState() {
    super.initState();
    _setFormMetadata();
  }

  // ---------- UI metadata (strip goals) ----------
  List<FormSection> _stripGoalsFromSections(List<FormSection> sections) {
    return sections.map(_cloneSectionWithoutGoals).toList();
  }

  FormSection _cloneSectionWithoutGoals(FormSection s) {
    final keptInputs = <InputField>[];
    for (final f in (s.inputFields ?? const <InputField>[])) {
      if (f.id == _goal1Id || f.id == _goal2Id) continue;
      keptInputs.add(f);
    }
    final keptSubs = <FormSection>[];
    for (final sub in (s.subSections ?? const <FormSection>[])) {
      keptSubs.add(_cloneSectionWithoutGoals(sub));
    }
    return FormSection(
      id: s.id,
      name: s.name,
      translatedName: s.translatedName,
      description: s.description,
      color: s.color,
      borderColor: s.borderColor,
      inputFields: keptInputs,
      subSections: keptSubs,
    );
  }

  void _setFormMetadata() {
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
    }
    _isFormNotReady = true;
    setState(() {});
    formSections = [];

    final base = OvcServicesCasePlan.getFormSections(firstDate: widget.enrollmentDate);
    final withoutGoals = _stripGoalsFromSections(base);

    for (FormSection formSection in withoutGoals) {
      if (!(['Safe', 'Stable', 'Schooled'].contains(formSection.id))) {
        borderColors[formSection.id] = formSection.borderColor;
        formSection.borderColor = Colors.transparent;
        formSections.add(formSection);
      }
      if (!widget.isHouseholdCasePlan &&
          formSection.id == OvcCasePlanConstant.householdCategorizationSection) {
        formSections.remove(formSection);
      }
    }

    if (!widget.enrollmentOuAccessible) {
      formSections = [
        AppUtil.getServiceProvisionLocationSection(
          id: OvcCasePlanConstant.casePlanLocatinSectionId,
          inputColor: const Color(0xFF4B9F46),
          labelColor: const Color(0xFF1A3518),
          sectionLabelColor: const Color(0xFF1A3518),
          formlabel: 'Location',
          allowedSelectedLevels: [AppHierarchyReference.communityLevel],
          program: widget.casePlanProgram,
        ),
        ...formSections
      ];
      mandatoryFieldObject['location'] = true;
    }

    // Mark HH Categorization mandatory on the UI for HOUSEHOLD plans
    if (widget.isHouseholdCasePlan) {
      mandatoryFieldObject[OvcCasePlanConstant.houseHoldCategorizationDataElement] = true;
    }

    Timer(const Duration(milliseconds: 500), () {
      _isFormNotReady = false;
      setState(() {});
    });
  }

  onInputValueChange(String? formSectionId, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(formSectionId, value);
  }

  bool _hasAtLeastOneGap(Map dataObject) {
    for (final key in dataObject.keys) {
      if (key == OvcCasePlanConstant.casePlanLocatinSectionId ||
          key == OvcCasePlanConstant.casePlanEventDateSectionId) {
        continue;
      }
      final map = (dataObject[key] as Map?) ?? const {};
      final gaps = (map['gaps'] as List?) ?? const [];
      if (gaps.isNotEmpty) return true;
    }
    return false;
  }

  // NEW: Require & detect HH Categorization value
  bool _hasHouseholdCategorizationProvided(Map dataObject) {
    final m = dataObject[OvcCasePlanConstant.householdCategorizationSection] as Map?;
    final val = m == null
        ? ''
        : (m[OvcCasePlanConstant.houseHoldCategorizationDataElement] ?? '')
        .toString()
        .trim();
    return val.isNotEmpty;
  }

  // ---------- Linkage helpers (stop the “two versions”) ----------
  Future<String?> _findExistingChildCpEventId({
    required String teiId,
    required String domainId,
    required String cpLink,
  }) async {
    final all = await TrackedEntityInstanceUtil.getSavedTrackedEntityInstanceEventData(teiId);
    final stageId = OvcChildCasePlanConstant.casePlanProgramStage;
    for (final e in all) {
      if (e.programStage != stageId) continue;

      final dvMap = <String, dynamic>{};
      final raw = e.dataValues;
      if (raw is Map) {
        raw.forEach((k, v) => dvMap['$k'] = v);
      } else if (raw is List) {
        for (final row in raw) {
          if (row is Map && row['dataElement'] != null) {
            dvMap['${row['dataElement']}'] = row['value'];
          }
        }
      }
      final link = (dvMap[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
      final dom = (dvMap[OvcCasePlanConstant.casePlanDomainType] ?? '').toString();
      if (link == cpLink && dom == domainId) {
        final id = (e.event ?? '').toString();
        if (id.trim().isNotEmpty) return id;
      }
    }
    return null;
  }

  Future<String?> _resolveChildCpLinkage({
    required String domainId,
    required String date,
  }) async {
    if (widget.isHouseholdCasePlan) return null;

    final sel = Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);
    final hhTei = sel.currentOvcHousehold?.teiData?.trackedEntityInstance ?? '';
    final childTei = sel.currentOvcHouseholdChild?.teiData?.trackedEntityInstance ?? '';

    try {
      // Prefer child GAPs (same date + domain)
      if (childTei.isNotEmpty) {
        final childGaps = await OvcCasePlanService().getCasePlanGapEvents(
          date: date,
          programStageId: OvcChildCasePlanConstant.casePlanGapProgramStage,
          teiId: childTei,
          casePlanToGaps: const [],
        );
        for (final e in childGaps) {
          final m = e.toDataObject();
          final d = (m[OvcCasePlanConstant.casePlanDomainType] ?? '').toString();
          if (d == domainId) {
            final link = (m[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
            if (link.isNotEmpty) return link;
          }
        }
      }

      // Try child CP containers
      if (childTei.isNotEmpty) {
        final childCps = await OvcCasePlanService().getCasePlanGapEvents(
          date: date,
          programStageId: OvcChildCasePlanConstant.casePlanProgramStage,
          teiId: childTei,
          casePlanToGaps: const [],
        );
        for (final e in childCps) {
          final m = e.toDataObject();
          final d = (m[OvcCasePlanConstant.casePlanDomainType] ?? '').toString();
          if (d == domainId) {
            final link = (m[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
            if (link.isNotEmpty) return link;
          }
        }
      }

      // Fallback to HH GAPs for linkage source
      if (hhTei.isNotEmpty) {
        final hhGaps = await OvcCasePlanService().getCasePlanGapEvents(
          date: date,
          programStageId: OvcHouseholdCasePlanConstant.casePlanGapProgramStage,
          teiId: hhTei,
          casePlanToGaps: const [],
        );
        for (final e in hhGaps) {
          final m = e.toDataObject();
          final d = (m[OvcCasePlanConstant.casePlanDomainType] ?? '').toString();
          if (d == domainId) {
            final link = (m[OvcCasePlanConstant.casePlanToGapLinkage] ?? '').toString();
            if (link.isNotEmpty) return link;
          }
        }
      }
    } catch (_) {}
    return null;
  }

  // ---------- Save ----------
  void onSaveCasePlan({required Map dataObject}) async {
    final hasAnyGaps = _hasAtLeastOneGap(dataObject);
    final requireHhCat = widget.isHouseholdCasePlan;
    final hasHhCat = _hasHouseholdCategorizationProvided(dataObject);

    final hasLocationFilled = OvcCasePlanUtil.isLocationOnCasePlanFormFilled(
      dataObject,
      sectionsId: OvcCasePlanConstant.casePlanLocatinSectionId,
      shouldCheck: !widget.enrollmentOuAccessible,
    );
    final hasCasePlanDateFilled = OvcCasePlanUtil.isCasePlanDateOnCasePlanFormFilled(
      dataObject,
      sectionsId: OvcCasePlanConstant.casePlanEventDateSectionId,
    );

    // Require HH Categorization for household case plans
    if (requireHhCat && !hasHhCat) {
      AppUtil.showToastMessage(message: 'Please select Household Categorization.');
      setState(() {});
      return;
    }

    // Still require the standard mandatory fields
    if (!hasLocationFilled || !hasCasePlanDateFilled) {
      AppUtil.showToastMessage(message: 'Please fill all mandatory fields.');
      setState(() {});
      return;
    }

    _isSaving = true;
    setState(() {});

    final selection =
    Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false);

    final OvcHousehold? hh = selection.currentOvcHousehold;
    final OvcHouseholdChild? child = selection.currentOvcHouseholdChild;
    final List<OvcHouseholdChild> children = hh?.children ?? [];

    final TrackedEntityInstance beneficiary =
    widget.isHouseholdCasePlan ? hh!.teiData! : child!.teiData!;

    String orgUnit = widget.enrollmentOuAccessible
        ? (beneficiary.orgUnit ?? '')
        : OvcCasePlanUtil.getLocationFromCasePlanForm(
        dataObject, OvcCasePlanConstant.casePlanLocatinSectionId);
    orgUnit = orgUnit.isEmpty ? (beneficiary.orgUnit ?? '') : orgUnit;

    final casePlanEventDate = OvcCasePlanUtil.getCasePlanDateFromCasePlanForm(
      dataObject,
      OvcCasePlanConstant.casePlanEventDateSectionId,
    );

    // Save domains/gaps (will gracefully do nothing if there are none)
    await _savingDomainsAndGaps(
      dataObject: dataObject,
      beneficiary: beneficiary,
      orgUnit: orgUnit,
      eventDate: casePlanEventDate,
    );

    // ALWAYS save HH categorization when provided (regardless of gaps)
    if (widget.isHouseholdCasePlan && hasHhCat) {
      await _updateHouseholdCategorizationIfProvided(beneficiary, dataObject);
    }

    if (widget.isHouseholdCasePlan) {
      await OvcCasePlanGapHouseholdToOvcUtil.autoSyncOvcsCasPlanGaps(
        currentCasePlanDate: widget.currentCasePlanDate,
        childrens: children,
        dataObject: dataObject,
        orgUnit: orgUnit,
        eventDate: casePlanEventDate,
      );
    }

    Provider.of<ServiceEventDataState>(context, listen: false)
        .resetServiceEventDataState(beneficiary.trackedEntityInstance);

    Timer(const Duration(milliseconds: 200), () {
      if (Navigator.canPop(context)) {
        final currentLanguage =
            Provider.of<LanguageTranslationState>(context, listen: false)
                .currentLanguage;
        AppUtil.showToastMessage(
          message: currentLanguage == 'lesotho'
              ? 'Fomo e bolokeile'
              : 'Form has been saved successfully',
        );
        _isSaving = false;
        setState(() {});
        Navigator.pop(context);
      }
    });
  }

  Future<void> _savingDomainsAndGaps({
    required Map dataObject,
    required TrackedEntityInstance beneficiary,
    required String orgUnit,
    required String eventDate,
  }) async {
    const linkageDe = OvcCasePlanConstant.casePlanToGapLinkage;
    const domainTypeDe = OvcCasePlanConstant.casePlanDomainType;
    const firstGoalDe = OvcCasePlanConstant.casePlanFirstGoal;
    const secondGoalDe = OvcCasePlanConstant.casePlansSecondGoal;

    List<FormSection> gapSectionsForDomain(String domain) {
      return widget.isHouseholdCasePlan
          ? OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: '')
          .where((s) => s.id == domain)
          .toList()
          : OvcServicesChildCasePlanGap.getFormSections(firstDate: '')
          .where((s) => s.id == domain)
          .toList();
    }

    final String program =
    widget.isHouseholdCasePlan ? OvcHouseholdCasePlanConstant.program : OvcChildCasePlanConstant.program;

    final String casePlanStage = widget.isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.casePlanProgramStage
        : OvcChildCasePlanConstant.casePlanProgramStage;

    final String gapStage = widget.isHouseholdCasePlan
        ? OvcHouseholdCasePlanConstant.casePlanGapProgramStage
        : OvcChildCasePlanConstant.casePlanGapProgramStage;

    final allSections = OvcServicesCasePlan.getFormSections(firstDate: '');
    final containerHidden = <String>[linkageDe, domainTypeDe];
    final gapHidden = <String>[
      linkageDe,
      OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
      OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
    ];

    Map<String, dynamic> _clean(Map src, {bool removeGoals = false}) {
      final out = <String, dynamic>{};
      src.forEach((k, v) {
        final ks = k.toString();
        if (ks == 'eventId') {
          out[ks] = v; // keep for update
          return;
        }
        if (removeGoals && (ks == firstGoalDe || ks == secondGoalDe)) return;
        if (v == null) return;
        if (v is bool && v == false) return;
        if (v is String && v.trim().isEmpty) return;
        out[ks] = v;
      });
      return out;
    }

    for (final domainType in dataObject.keys.toList()) {
      if (domainType == OvcCasePlanConstant.casePlanLocatinSectionId ||
          domainType == OvcCasePlanConstant.casePlanEventDateSectionId ||
          domainType == OvcCasePlanConstant.householdCategorizationSection) {
        continue;
      }

      final rawDomain = (dataObject[domainType] as Map?) ?? const {};
      final domainDataObject = Map<String, dynamic>.from(rawDomain);
      domainDataObject.remove(firstGoalDe);
      domainDataObject.remove(secondGoalDe);

      final gaps = (domainDataObject['gaps'] as List?) ?? const [];
      final hasAnyGap = gaps.isNotEmpty;
      if (!hasAnyGap && domainType != OvcCasePlanConstant.casePlanDomainType) {
        continue;
      }

      try {
        // Domain + stable casePlanDate
        domainDataObject[domainTypeDe] = domainType;
        domainDataObject['casePlanDate'] =
        (domainDataObject['casePlanDate'] ?? '').toString().trim().isNotEmpty
            ? domainDataObject['casePlanDate']
            : widget.currentCasePlanDate;

        // CHILD: force HH/child cpLinkage and reuse existing child CP container eventId
        String? existingChildCpEventId;
        if (!widget.isHouseholdCasePlan) {
          final forcedLink = await _resolveChildCpLinkage(
            domainId: domainType.toString(),
            date: widget.currentCasePlanDate,
          );
          if (forcedLink != null && forcedLink.isNotEmpty) {
            domainDataObject[linkageDe] = forcedLink;
            existingChildCpEventId = await _findExistingChildCpEventId(
              teiId: beneficiary.trackedEntityInstance ?? '',
              domainId: domainType.toString(),
              cpLink: forcedLink,
            );
          }
        }

        // Fallback cpLinkage
        if ((domainDataObject[linkageDe] ?? '').toString().isEmpty) {
          domainDataObject[linkageDe] =
              domainDataObject['eventId'] ?? AppUtil.getUid();
        }
        final cpLinkage = (domainDataObject[linkageDe] ?? '').toString();

        // Save/Update container
        final domainFormSections =
        allSections.where((s) => s.id == domainType).toList();
        final containerToSave = _clean(domainDataObject, removeGoals: true);

        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          program,
          casePlanStage,
          orgUnit,
          domainFormSections,
          containerToSave,
          eventDate,
          beneficiary.trackedEntityInstance,
          widget.isHouseholdCasePlan
              ? domainDataObject['eventId']
              : (existingChildCpEventId ?? domainDataObject['eventId']),
          containerHidden,
        );

        // Save gaps (same cpLinkage)
        final gapSections = gapSectionsForDomain(domainType);
        for (final g in gaps) {
          final gap = Map<String, dynamic>.from(g as Map);
          gap[linkageDe] = cpLinkage;

          final gapToSave = _clean(gap);
          if (gapToSave.keys.where((k) => k != 'eventId').isEmpty) continue;

          await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            program,
            gapStage,
            orgUnit,
            gapSections,
            gapToSave,
            eventDate,
            beneficiary.trackedEntityInstance,
            gap['eventId'],
            gapHidden,
          );
        }
      } catch (_) {
        // continue per domain
      }
    }
  }

  Future<void> _updateHouseholdCategorizationIfProvided(
      TrackedEntityInstance beneficiary,
      Map<dynamic, dynamic> dataObject,
      ) async {
    try {
      final hhCatSection =
      dataObject[OvcCasePlanConstant.householdCategorizationSection] as Map?;
      final hhCat = hhCatSection == null
          ? ''
          : (hhCatSection[OvcCasePlanConstant.houseHoldCategorizationDataElement] ?? '')
          .toString();
      if (hhCat.isEmpty) return;

      await OvcEnrollmentHouseholdService().updateHouseholdStatus(
        trackedEntityInstance: beneficiary.trackedEntityInstance,
        orgUnit: beneficiary.orgUnit,
        dataObject: {
          BeneficiaryIdentification.householdCategorization: hhCat,
        },
        inputFieldIds: [BeneficiaryIdentification.householdCategorization],
      );

      Provider.of<OvcInterventionListState>(context, listen: false).refreshOvcList();
      Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
          .refetchCurrentHousehold();
      Provider.of<ServiceEventDataState>(context, listen: false)
          .resetServiceEventDataState(beneficiary.trackedEntityInstance);
    } catch (_) {}
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            final InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return SubPageAppBar(
              label: widget.casePlanLabel,
              activeInterventionProgram: activeInterventionProgram,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Consumer<LanguageTranslationState>(
          builder: (context, languageTranslationState, child) {
            final String? currentLanguage = languageTranslationState.currentLanguage;
            return Consumer<OvcHouseholdCurrentSelectionState>(
              builder: (context, currentSel, child) {
                final OvcHousehold? currentOvcHousehold = currentSel.currentOvcHousehold;
                final OvcHouseholdChild? currentOvcHouseholdChild =
                    currentSel.currentOvcHouseholdChild;
                final int beneficiaryAge = int.tryParse(
                  widget.isHouseholdCasePlan
                      ? (currentOvcHousehold?.age ?? '0')
                      : (currentOvcHouseholdChild?.age ?? '0'),
                ) ??
                    0;

                return Consumer<ServiceFormState>(
                  builder: (context, serviceFormState, child) {
                    final Map dataObject = serviceFormState.formState;
                    return Container(
                      margin: const EdgeInsets.symmetric(),
                      child: _isFormNotReady
                          ? const CircularProcessLoader(color: Colors.blueGrey)
                          : Column(
                        children: [
                          widget.isHouseholdCasePlan
                              ? OvcHouseholdInfoTopHeader(
                            currentOvcHousehold: currentOvcHousehold,
                          )
                              : const OvcChildInfoTopHeader(),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 13.0,
                            ),
                            child: Column(
                              children: formSections
                                  .where((formSection) =>
                              formSection.id == 'Schooled'
                                  ? beneficiaryAge > 5
                                  : true)
                                  .toList()
                                  .map(
                                    (formSection) => Container(
                                  margin: const EdgeInsets.symmetric(),
                                  child: CasePlanFormContainer(
                                    mandatoryFieldObject:
                                    mandatoryFieldObject,
                                    canAddDomainGaps: ![
                                      OvcCasePlanConstant
                                          .householdCategorizationSection,
                                      OvcCasePlanConstant
                                          .casePlanLocatinSectionId,
                                      OvcCasePlanConstant
                                          .casePlanEventDateSectionId,
                                    ].contains(formSection.id),
                                    formSectionColor:
                                    borderColors[formSection.id] ??
                                        Colors.transparent,
                                    formSection: formSection,
                                    isEditableMode:
                                    serviceFormState.isEditableMode,
                                    dataObject:
                                    dataObject[formSection.id] ?? {},
                                    onInputValueChange: (value) =>
                                        onInputValueChange(
                                            formSection.id, value),
                                    isHouseholdCasePlan:
                                    widget.isHouseholdCasePlan,
                                    hasEditAccessToCasePlan:
                                    widget.hasEditAccessToCasePlan,
                                    enrollmentOuAccessible:
                                    widget.enrollmentOuAccessible,
                                    isOnCasePlanPage:
                                    widget.isOnCasePlanPage,
                                    isOnCasePlanServiceProvision:
                                    widget.isOnCasePlanServiceProvision,
                                    isOnCasePlanServiceMonitoring:
                                    widget.isOnCasePlanServiceMonitoring,
                                  ),
                                ),
                              )
                                  .toList()
                                ..add(
                                  Container(
                                    margin:
                                    const EdgeInsets.symmetric(),
                                    child: Visibility(
                                      visible:
                                      serviceFormState.isEditableMode,
                                      child: EntryFormSaveButton(
                                        label: _isSaving
                                            ? currentLanguage == 'lesotho'
                                            ? 'E ntse e boloka...'
                                            : 'Saving ...'
                                            : currentLanguage == 'lesotho'
                                            ? 'Boloka'
                                            : 'Save',
                                        labelColor: Colors.white,
                                        buttonColor:
                                        const Color(0xFF4B9F46),
                                        fontSize: 15.0,
                                        onPressButton: () => onSaveCasePlan(
                                          dataObject:
                                          serviceFormState.formState,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
    );
  }
}
