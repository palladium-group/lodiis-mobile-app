import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';

import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';

import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/skip_logics/ovc_case_plan_gap_skip_logic.dart';

import '../../../../../../app_state/enrollment_service_form_state/service_event_data_state.dart';
import '../../../../../../core/services/organisation_unit_service.dart';
import '../../../../../../core/utils/tracked_entity_instance_util.dart';

import '../../constants/ovc_household_assessment_constant.dart';
import '../../constants/ovc_service_well_being_assessment_constant.dart';

class CasePlanGapFormContainer extends StatefulWidget {
  const CasePlanGapFormContainer({
    Key? key,
    required this.formSections,
    required this.isEditableMode,
    required this.formSectionColor,
    required this.dataObject,
    this.isChildCasePlan = false, // << pass true for CHILD case plan
  }) : super(key: key);

  final List<FormSection> formSections;
  final bool isEditableMode;
  final Color formSectionColor;
  final Map dataObject;

  /// When true, use child-specific logic based on the selected child's latest assessment.
  final bool isChildCasePlan;

  @override
  State<CasePlanGapFormContainer> createState() =>
      _CasePlanGapFormContainerState();
}

class _CasePlanGapFormContainerState extends State<CasePlanGapFormContainer>
    with OvcCasePlanGapSkipLogic {
  Map mandatoryFieldObject = {};
  List mandatoryFields = [];
  List unFilledMandatoryFields = [];
  Map dataObject = {};

  @override
  void initState() {
    super.initState();
    // ensure providers are ready before reading them
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepareForm());
  }

  // ----------------- helpers -----------------

  String? _normHiv(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    if (s.isEmpty) return null;
    const pos = {'positive', 'pos', 'positive (known)', '1', 'true', 'yes'};
    const neg = {'negative', 'neg', '0', 'false', 'no'};
    if (pos.contains(s)) return 'Positive';
    if (neg.contains(s)) return 'Negative';
    return (v ?? '').toString().trim();
  }

  // NOTE: uses only child.age (no DOB fallback)
  int _ageFromChild(OvcHouseholdChild child) {
    return int.tryParse((child.age ?? '').toString()) ?? -1;
  }

  bool _hasChildAgeAtMost(int years) {
    final household =
        context.read<OvcHouseholdCurrentSelectionState>().currentOvcHousehold;
    final children = household?.children ?? const <OvcHouseholdChild>[];
    for (final child in children) {
      final age = _ageFromChild(child);
      if (age >= 0 && age <= years) return true;
    }
    return false;
  }

  /// Latest **CHILD** assessment values (Well-Being Assessment stage)
  Future<Map<String, String?>> _latestValuesForChildAssessment(String tei) async {
    final accessibleOrgUnits =
    await OrganisationUnitService().getOrganisationUnitAccessedByCurrentUser();

    final all = await TrackedEntityInstanceUtil
        .getSavedTrackedEntityInstanceEventData(
      tei,
      accessibleOrgUnits: accessibleOrgUnits,
    );

    final stageId = OvcServiceWellBeingAssessmentConstant.programStage;
    final stageEvents = all.where((e) => e.programStage == stageId).toList();
    if (stageEvents.isEmpty) return {};

    stageEvents.sort((a, b) {
      final ad = DateTime.tryParse(a.eventDate ?? '');
      final bd = DateTime.tryParse(b.eventDate ?? '');
      if (ad != null && bd != null) return bd.compareTo(ad);
      return (b.eventDate ?? '').compareTo(a.eventDate ?? '');
    });

    final latest = stageEvents.first;
    final map = <String, String?>{};
    final dvs = (latest.dataValues as List?) ?? const [];
    for (final dv in dvs) {
      if (dv is Map && dv['dataElement'] != null) {
        map[dv['dataElement'] as String] = dv['value']?.toString();
      }
    }
    map['eventDate'] = latest.eventDate;
    map['eventId'] = latest.event;
    return map;
  }

  // ----------------- prepare -----------------

  void _prepareForm() {
    dataObject = widget.dataObject;

    // Decide path ONLY from explicit flag to avoid accidental branch selection
    final runChildPath = widget.isChildCasePlan;
    debugPrint('[CasePlanGap] isChildCasePlan=${widget.isChildCasePlan} -> runChildPath=$runChildPath');

    if (!runChildPath) {
      // HOUSEHOLD/CAREGIVER PATH — uses latest HH assessment
      Future.microtask(() async {
        final assessmentVals = context
            .read<ServiceEventDataState>()
            .latestValuesForStage(OvcHouseholdAssessmentConstant.programStage);

        debugPrint('[CasePlanGap] Running CAREGIVER mapping with $assessmentVals');

        await _applyCaregiverAssessmentToGaps(assessmentVals);

        for (final id in mandatoryFields) {
          mandatoryFieldObject[id] = true;
        }
        _evaluateSkipLogics();
        if (mounted) setState(() {});
      });
      return;
    }

    // CHILD PATH — reads ONLY the child’s latest assessment (no HH reads)
    Future.microtask(() async {
      final child = context
          .read<OvcHouseholdCurrentSelectionState>()
          .currentOvcHouseholdChild;

      if (child != null) {
        final tei =
        (child.id ?? '').toString();
        if (tei.isNotEmpty) {
          final childVals = await _latestValuesForChildAssessment(tei);
          debugPrint('[CasePlanGap] Running CHILD mapping for TEI=$tei with $childVals');
          await _applyChildAssessmentToGaps(childVals, child);
        } else {
          debugPrint('[CasePlanGap] CHILD mapping skipped: empty TEI');
        }
      } else {
        debugPrint('[CasePlanGap] CHILD mapping skipped: no selected child');
      }

      for (final id in mandatoryFields) {
        mandatoryFieldObject[id] = true;
      }
      _evaluateSkipLogics();
      if (mounted) setState(() {});
    });
  }

  // ----------------- caregiver mapper (HH assessment ONLY) -----------------

  Future<void> _applyCaregiverAssessmentToGaps(
      Map<String, String?> a) async {
    // Assessment DEs (household)
    const hivStatusDE = 'vNeOE9abQBB';
    const artStatusDE = 'Icgkv0xkUow';
    const areYouCoughingDE = 'tMvluCbiiUm';
    const lastTestedDE = 'Uv26fX0HQvO';
    const oralHealthMessagingDE = 'wRhamvRZj87';
    const dietDE = 'iqBsSAfCyJb';

    // Gap DEs
    const hivAdherenceGapDE = 'HKCv7lkLexo';
    const hivTreatGapDE = 'ylSjcj6cv42';
    const tbTreatGapDE = 'bRv4ZZy5MDH';
    const hivSndGapDE = 'cx4xBY4jZXM';
    const comArtAdherenceGapDE = 'gff7hjjVoI6';
    const artLiteracyGapDE = 'vqRohVpTK2G';
    const htsGapDE = 'XoSPWmpWXCy';
    const nutritionMessagingDE = 'CaAOIbC10yv';
    const oralHealthGapDE = 'ztDAwmkSwKf';
    const foodSupportGapDE = 'EaJTFrklMo5';

    bool _isTrue(dynamic v) {
      final s = (v ?? '').toString().trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }

    bool _testedWithin3Months(dynamic v) {
      final raw = (v ?? '').toString().trim();
      if (raw.isEmpty) return false;
      final l = raw.toLowerCase();
      const recentLabels = {'less than 3 months', 'lt_3_months', 'lt3m', 'recent'};
      if (recentLabels.contains(l)) return true;
      final dt = DateTime.tryParse(raw);
      if (dt != null) {
        final diff = DateTime.now().difference(dt).inDays.abs();
        return diff <= 90;
      }
      return false;
    }

    bool _dietIsOneType(Map<String, String?> m) {
      final raw = (m[dietDE] ?? '').toString().trim().toLowerCase();
      return raw == '1' ||
          raw == 'one type of food group' ||
          raw == 'one types of food groups';
    }

    // caregiver values
    final hiv = _normHiv(a[hivStatusDE]);
    final hivPositive = hiv == 'Positive';
    final onArt = _isTrue(a[artStatusDE]);
    final coughing = _isTrue(a[areYouCoughingDE]);
    final recentTest = _testedWithin3Months(a[lastTestedDE]);
    final oralHealthFlag = _isTrue(a[oralHealthMessagingDE]);

    // rules
    dataObject[hivSndGapDE] = true;
    if (onArt) dataObject[hivAdherenceGapDE] = true;
    if (coughing) dataObject[tbTreatGapDE] = true;
    if (hivPositive && !onArt) dataObject[hivTreatGapDE] = true;
    if (hivPositive) {
      dataObject[comArtAdherenceGapDE] = true;
      dataObject[artLiteracyGapDE] = true;
    }
    if (!hivPositive && !recentTest) dataObject[htsGapDE] = true;
    if (oralHealthFlag) dataObject[oralHealthGapDE] = true;

    // nutrition messaging if any child <= 5
    if (_hasChildAgeAtMost(5)) {
      dataObject[nutritionMessagingDE] = true;
    }

    // caregiver NOT positive + any child (0–8) positive (from CHILD assessment)
    if (!hivPositive) {
      final hh =
          context.read<OvcHouseholdCurrentSelectionState>().currentOvcHousehold;
      final children = hh?.children ?? const <OvcHouseholdChild>[];

      for (final child in children) {
        final tei =
        (child.id ?? '').toString();
        if (tei.isEmpty) continue;
        final age = _ageFromChild(child);
        if (age < 0 || age > 8) continue;
        final childVals = await _latestValuesForChildAssessment(tei);
        final childHiv = _normHiv(childVals['c5TMWtM4VVJ']); // child HIV DE
        if (childHiv == 'Positive') {
          if (_dietIsOneType(a)) {
            dataObject[foodSupportGapDE] = true;
          }
          dataObject[hivAdherenceGapDE] = true;
          dataObject[artLiteracyGapDE] = true;
          break;
        }
      }
    }
  }

  // ----------------- child mapper (CHILD assessment ONLY) -----------------

  Future<void> _applyChildAssessmentToGaps(
      Map<String, String?> a, OvcHouseholdChild child) async {
    // Child assessment DEs
    const hivStatusDE = 'c5TMWtM4VVJ'; // child HIV status DE
    const malnutritionSignsDE = 'OBugEkynJG0';
    // Gap DEs (reuse or swap for child-specific if different)

    const foodSupplementsGapDE = 'uvJV4WGc5ct';



    bool _isTrue(dynamic v) {
      final s = (v ?? '').toString().trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }
    final hiv = _normHiv(a[hivStatusDE]);
    final mulnutriotSigns = _isTrue(a[malnutritionSignsDE]);

    final age = _ageFromChild(child);
    if (age >= 0 && age <= 5 && mulnutriotSigns) {
      print('Mulnutrion Signs?? $mulnutriotSigns');
      dataObject[foodSupplementsGapDE] = true;
    }

    // add more child-only rules here using `a[...]` if needed
  }

  // ----------------- Skip-logic / UI -----------------

  void _evaluateSkipLogics() {
    OvcHouseholdChild? currentHouseholdChild =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild;
    CurrentUser? currentUser =
        Provider.of<CurrentUserState>(context, listen: false).currentUser;
    dataObject = {
      ...dataObject,
      "implementingPartner": currentUser?.implementingPartner ?? ""
    };
    evaluateSkipLogics(
      context,
      widget.formSections,
      dataObject,
      currentHouseholdChild: currentHouseholdChild,
    );
  }

  void onInputValueChange(String id, dynamic value) {
    dataObject[id] = value;
    setState(() {});
    _evaluateSkipLogics();
    setState(() {});
  }

  void setMandatoryFieldForVacLegalMessage() {
    List vacLegalMessagingMandatoryFields = [
      "TizNGPP6e1d",
      "Q7GxvZD6h99",
      "A4xYu8BYOg7"
    ];
    bool isVacMessageSelected = "${dataObject['aPmPhwm8Zln']}" == "true";
    bool isVacLegalMessageSelected = "${dataObject['AaqeRcyjbyS']}" == "true";
    if (isVacMessageSelected && !isVacLegalMessageSelected) {
      dataObject['AaqeRcyjbyS'] = true;
    } else if (!isVacMessageSelected) {
      dataObject['AaqeRcyjbyS'] = '';
      for (String id in vacLegalMessagingMandatoryFields) {
        dataObject[id] = '';
      }
    }
    isVacLegalMessageSelected = "${dataObject['AaqeRcyjbyS']}" == "true";
    mandatoryFields = [];
    unFilledMandatoryFields = [];
    for (String id in vacLegalMessagingMandatoryFields) {
      if (isVacLegalMessageSelected && isVacMessageSelected) {
        mandatoryFieldObject[id] = true;
        mandatoryFields.add(id);
      }
    }
    _evaluateSkipLogics();
    setState(() {});
  }

  onSaveGapForm(BuildContext context) {
    bool isAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields:
      Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: widget.formSections,
      ),
    );
    unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
      mandatoryFields,
      dataObject,
      hiddenFields:
      Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: widget.formSections,
      ),
    );
    setState(() {});
    if (isAllMandatoryFilled) {
      bool hasAtLeastOnFieldFilled = FormUtil.hasAtLeastOnFieldFilled(
        hiddenFields: hiddenFields,
        formSections: widget.formSections,
        dataObject: dataObject,
      );
      if (hasAtLeastOnFieldFilled) {
        Navigator.pop(context, dataObject);
      } else {
        AppUtil.showToastMessage(
          message: 'Please fill at least one field',
        );
      }
    } else {
      AppUtil.showToastMessage(
        message: 'Please fill  all mandatory fields',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      child: Column(
        children: [
          EntryFormContainer(
            elevation: 0.0,
            formSections: widget.formSections,
            hiddenFields: hiddenFields,
            hiddenSections: hiddenSections,
            mandatoryFieldObject: mandatoryFieldObject,
            dataObject: dataObject,
            isEditableMode: widget.isEditableMode,
            onInputValueChange: onInputValueChange,
            unFilledMandatoryFields: unFilledMandatoryFields,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 13.0,
            ),
            child: Visibility(
              visible: widget.isEditableMode,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: widget.formSectionColor,
                      ),
                      onPressed: () => onSaveGapForm(context),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          vertical: 22.0,
                        ),
                        child: Consumer<LanguageTranslationState>(
                          builder: (context, languageTranslationState, child) =>
                              Text(
                                languageTranslationState.isSesothoLanguage
                                    ? "Eketsa sekheo"
                                    : 'CONFIRM',
                                style: const TextStyle().copyWith(
                                  color: const Color(0xFFFAFAFA),
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
            ),
          )
        ],
      ),
    );
  }
}
