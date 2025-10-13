
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';

import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/services/organisation_unit_service.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';

import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';

import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/skip_logics/ovc_case_plan_gap_skip_logic.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_monitor/constants/ovc_household_monitor_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_service_well_being_assessment_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_household_assessment_constant.dart';

class CasePlanGapFormContainer extends StatefulWidget {
  const CasePlanGapFormContainer({
    Key? key,
    required this.formSections,
    required this.isEditableMode,
    required this.formSectionColor,
    required this.dataObject,
    this.isChildCasePlan = false,
    this.isHouseholdCasePlan, // NEW: optional
  }) : super(key: key);

  final List<FormSection> formSections;
  final bool isEditableMode;
  final Color formSectionColor;
  final Map dataObject;

  /// Explicit child flag (old style). If true, use child logic and stages.
  final bool isChildCasePlan;

  /// Optional household flag. If provided and false -> child path;
  /// if true -> household path. If null, fallback to isChildCasePlan.
  final bool? isHouseholdCasePlan; // NEW

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

  /// Decides whether to run the CHILD path
  bool get _runChildPath {
    if (widget.isChildCasePlan) return true;
    if (widget.isHouseholdCasePlan != null) {
      return widget.isHouseholdCasePlan == false;
    }
    return false; // default to household when nothing is specified
  }

  @override
  void initState() {
    super.initState();
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

  int _ageFromChild(OvcHouseholdChild child) {
    final raw = (child.age ?? '').toString().trim().toLowerCase();
    if (raw.isEmpty) return -1;
    final m = RegExp(r'(\d+(\.\d+)?)').firstMatch(raw);
    if (m == null) return -1;
    final d = double.tryParse(m.group(1) ?? '');
    return d == null ? -1 : d.floor();
  }

  void _pruneFalseyToggles(Map obj) {
    final keys = List<String>.from(obj.keys);
    for (final k in keys) {
      final v = obj[k];
      final isTrueBool = v is bool && v == true;
      final isNonEmptyString = v is String && v.trim().isNotEmpty;
      final isNonZeroNum = v is num && v != 0;
      if (!(isTrueBool || isNonEmptyString || isNonZeroNum)) {
        obj.remove(k);
      }
    }
  }

  /// Latest **CHILD** assessment values (Well-Being Assessment)
  Future<Map<String, String?>> _latestValuesForChildAssessment(String tei) async {
    final accessibleOrgUnits =
    await OrganisationUnitService().getOrganisationUnitAccessedByCurrentUser();
    final all = await TrackedEntityInstanceUtil
        .getSavedTrackedEntityInstanceEventData(tei, accessibleOrgUnits: accessibleOrgUnits);

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

  /// TEI for current screen (HH or Child)
  String? _currentTei() {
    final sel = context.read<OvcHouseholdCurrentSelectionState>();
    if (_runChildPath) {
      final c = sel.currentOvcHouseholdChild;
      final tei = (c?.teiData?.trackedEntityInstance ?? c?.id ?? '').toString();
      return tei.isEmpty ? null : tei;
    } else {
      final h = sel.currentOvcHousehold;
      final tei = (h?.teiData?.trackedEntityInstance ?? h?.id ?? '').toString();
      return tei.isEmpty ? null : tei;
    }
  }

  /// Collect **all** gap DEs ever saved as `true` in the Case Plan Gap stage
  Future<Set<String>> _existingGapTogglesAcrossAllEvents() async {
    final tei = _currentTei();
    if (tei == null) return <String>{};

    final stageId = _runChildPath
        ? OvcChildCasePlanConstant.casePlanGapProgramStage
        : OvcHouseholdCasePlanConstant.casePlanGapProgramStage;

    final accessibleOrgUnits =
    await OrganisationUnitService().getOrganisationUnitAccessedByCurrentUser();
    final events = await TrackedEntityInstanceUtil
        .getSavedTrackedEntityInstanceEventData(tei, accessibleOrgUnits: accessibleOrgUnits);

    final existing = <String>{};
    for (final e in events) {
      if (e.programStage != stageId) continue;
      final dvs = (e.dataValues as List?) ?? const [];
      for (final dv in dvs) {
        if (dv is Map && dv['dataElement'] != null) {
          final val = (dv['value'] ?? '').toString().trim().toLowerCase();
          if (val == 'true' || val == '1' || val == 'yes') {
            existing.add(dv['dataElement'] as String);
          }
        }
      }
    }
    return existing;
  }

  // ----------------- prepare -----------------

  void _prepareForm() {
    dataObject = Map.of(widget.dataObject);
    final runChildPath = _runChildPath;
    debugPrint(
        '[CasePlanGap] runChildPath=$runChildPath isChildCasePlan=${widget.isChildCasePlan} isHouseholdCasePlan=${widget.isHouseholdCasePlan}');

    if (!runChildPath) {
      // ===== HOUSEHOLD path =====
      Future.microtask(() async {
        final assessmentVals = context
            .read<ServiceEventDataState>()
            .latestValuesForStage(OvcHouseholdAssessmentConstant.programStage);

        final monitoringVals = context
            .read<ServiceEventDataState>()
            .latestValuesForStage(OvcHouseholdMonitorConstant.programStage);

        // map from monitoring if available else assessment
        final source = monitoringVals.isEmpty ? assessmentVals : monitoringVals;
        await _applyCaregiverAssessmentToGaps(source);

        // remove gaps that exist in ANY past HH case plan gap event
        final existing = await _existingGapTogglesAcrossAllEvents();
        for (final id in existing) {
          dataObject.remove(id);
        }

        _pruneFalseyToggles(dataObject);

        for (final id in mandatoryFields) {
          mandatoryFieldObject[id] = true;
        }
        _evaluateSkipLogics();
        if (mounted) setState(() {});
      });
      return;
    }

    // ===== CHILD path =====
    Future.microtask(() async {
      final child =
          context.read<OvcHouseholdCurrentSelectionState>().currentOvcHouseholdChild;
      if (child != null) {
        final tei = (child.id ?? '').toString();
        if (tei.isNotEmpty) {
          final childVals = await _latestValuesForChildAssessment(tei);
          final monitoringVals = context
              .read<ServiceEventDataState>()
              .latestValuesForStage(OvcChildCasePlanConstant
              .casePlanGapServiceMonitoringProgramStage);
          final source = monitoringVals.isEmpty ? childVals : monitoringVals;
          await _applyChildAssessmentToGaps(source, child);
        }
      }

      // remove gaps that exist in ANY past CHILD case plan gap event
      final existing = await _existingGapTogglesAcrossAllEvents();
      for (final id in existing) {
        dataObject.remove(id);
      }

      _pruneFalseyToggles(dataObject);

      for (final id in mandatoryFields) {
        mandatoryFieldObject[id] = true;
      }
      _evaluateSkipLogics();
      if (mounted) setState(() {});
    });
  }

  // ----------------- CAREGIVER mapper (HH) -----------------

  Future<void> _applyCaregiverAssessmentToGaps(Map<String, String?> a) async {
    // Assessment DEs (household)
    const pregnantDE = 'nSh4v0iBjKW';
    const ancDE = 'fINHdGnfAMA';
    const hivStatusDE = 'vNeOE9abQBB';
    const artStatusDE = 'Icgkv0xkUow';
    const areYouCoughingDE = 'tMvluCbiiUm';
    const havelostWeight = 'P9hiqrTjAdg';
    const havedrenching = 'Y8Xzy7bEWsi';
    const havefever = 'VETgonq6tFr';
    const lastTestedDE = 'Uv26fX0HQvO';
    const oralHealthMessagingDE = 'wRhamvRZj87';
    const dietDE = 'iqBsSAfCyJb';
    const durationOnArt = 'ubin7MjQ5OI';
    const feelingSupportedDE = 'KFCBwn7ypws';
    const viralLoadResultsDE = 'aRNGDZcwWmS';
    const hadsexwithmorethanone = 'upkFeuyd1fX';
    const sexwithoucondomPositve = 'R38Mm0YgXcx';
    const sexwithoucondomUnknown = 'qoKPxEkgfdh';
    const genitalsores = 'B46Zeuzafkg';
    const vltestingDE = 'sLyfb45aLkl';
    const cd4testingDE = 'tYN12Es3707';

    // Gap DEs
    const ancGapDE = 'vbUdFOsYrxP';
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
    const disclosureSupportGapDE = 'eQTJrTcKzVK';
    const dewormingGapDE = 'x4yAqv4z2Xv';
    const feedingsessionsGapDE = 'zkbTGkrT6bH';
    const enhancedAdherenceCouncilingGapDE = 'XuZIbkwn5yi';
    const psycosocialsupportGapDE = 'WiPTQhWLVU1';
    const viralLoadTestingGapDE = 'bepi3n6Z4T0';
    const cd4TestingGapDE = 'SHWV7e088RT';

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

    bool moreThanSixMonthsOnArt(Map<String, String?> m) {
      final raw = (m[durationOnArt] ?? '').toString().trim().toLowerCase();
      return raw == 'more than six months';
    }

    // caregiver values
    final attandingANC = _isTrue(a[ancDE]);
    final hiv = _normHiv(a[hivStatusDE]);
    final hivPositive = hiv == 'Positive';
    final onArt = _isTrue(a[artStatusDE]);
    final coughing = _isTrue(a[areYouCoughingDE]);
    final lostWeight = _isTrue(a[havelostWeight]);
    final haveDrenching = _isTrue(a[havedrenching]);
    final hasFever = _isTrue(a[havefever]);
    final recentTest = _testedWithin3Months(a[lastTestedDE]);
    final oralHealthFlag = _isTrue(a[oralHealthMessagingDE]);
    final feelingSupported = a[feelingSupportedDE];
    final viralLoadResults = a[viralLoadResultsDE];
    final hadsexWithMoreThanOne = _isTrue(a[hadsexwithmorethanone]);
    final sexWithouCondomPositive = _isTrue(a[sexwithoucondomPositve]);
    final sexWithouCondomUnknown = _isTrue(a[sexwithoucondomUnknown]);
    final genitalSores = _isTrue(a[genitalsores]);
    final testForVL = _isTrue(a[vltestingDE]);
    final testdforCD4 = _isTrue(a[cd4testingDE]);
    final overSixMonthsOnArt = moreThanSixMonthsOnArt(a);

    final hh =
        context.read<OvcHouseholdCurrentSelectionState>().currentOvcHousehold;
    final children = hh?.children ?? const <OvcHouseholdChild>[];
    final isFemale = _isTrue(hh?.sex == 'Female');
  if(a[hivStatusDE] == null){
  dataObject[htsGapDE] = true;
  }

    if( isFemale && a[pregnantDE] == 'Yes' && !attandingANC){
      dataObject[ancGapDE] = true;
    }
    if (overSixMonthsOnArt && !testForVL) {
      dataObject[viralLoadTestingGapDE] = true;
    }
    if (hivPositive && (viralLoadResults ?? '').isNotEmpty) {
      if (viralLoadResults == 'High (above 1,000 copies/ml)') {
        if (!testdforCD4) {
          dataObject[cd4TestingGapDE] = true;
        }
        dataObject[viralLoadTestingGapDE] = true;
        dataObject[enhancedAdherenceCouncilingGapDE] = true;
      }
    }
    dataObject[hivSndGapDE] = true;
    dataObject[nutritionMessagingDE] = true;
    if (feelingSupported != null && feelingSupported != 'Yes') {
      dataObject[disclosureSupportGapDE] = true;
      dataObject[psycosocialsupportGapDE] = true;
    }
    if (onArt) dataObject[hivAdherenceGapDE] = true;
    if (coughing || lostWeight || hasFever || haveDrenching) {
      dataObject[tbTreatGapDE] = true;
    }
    if (hivPositive && !onArt) dataObject[hivTreatGapDE] = true;
    if (hivPositive) {
      if (_dietIsOneType(a)) dataObject[foodSupportGapDE] = true;
      dataObject[comArtAdherenceGapDE] = true;
      dataObject[artLiteracyGapDE] = true;
    }
    if (!hivPositive && !recentTest) {
      if (hadsexWithMoreThanOne ||
          sexWithouCondomPositive ||
          sexWithouCondomUnknown ||
          genitalSores) {
        dataObject[htsGapDE] = true;
      }
    }
    if (oralHealthFlag) dataObject[oralHealthGapDE] = true;

    // CHILD-driven additions (caregiver NOT positive scenarios)
    if (!hivPositive) {

      for (final child in children) {
        final tei = (child.id ?? '').toString();
        if (tei.isEmpty) continue;
        final age = _ageFromChild(child);
        if (age < 0 || age > 8) continue;
        final childVals = await _latestValuesForChildAssessment(tei);
        final childHiv = _normHiv(childVals['c5TMWtM4VVJ']);
        if (childHiv == 'Positive') {
          dataObject[artLiteracyGapDE] = true;
          break;
        }
      }

      for (final child in children) {
        final tei = (child.id ?? '').toString();
        if (tei.isEmpty) continue;
        final age = _ageFromChild(child);

        // age-based nutrition
        if (age >= 0 && age <= 5) {
          if (age < 4) dataObject[feedingsessionsGapDE] = true;
          dataObject[dewormingGapDE] = true;
        }
        if (age < 0 || age > 8) continue;
        final childVals = await _latestValuesForChildAssessment(tei);
        final childHiv = _normHiv(childVals['c5TMWtM4VVJ']);
        if (childHiv == 'Positive') {
          dataObject[artLiteracyGapDE] = true;
          break;
        }
      }
    }
  }

  // ----------------- CHILD mapper -----------------

  Future<void> _applyChildAssessmentToGaps(
      Map<String, String?> a,
      OvcHouseholdChild child,
      ) async {
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

    // Child assessment DEs
    const pregnantDE = 'nSh4v0iBjKW';
    const ancDE = 'fINHdGnfAMA';
    const highRiskAssessDE = 'hivriskres';
    const durationOnArt = 'ubin7MjQ5OI';
    const underFiveCLinicDE = 'eDuHTPn7rhh';
    const hivStatusDE = 'vNeOE9abQBB';
    const malnutritionSignsDE = 'OBugEkynJG0';
    const feelingSupportedDE = 'KFCBwn7ypws';
    const artStatusDE = 'Icgkv0xkUow';
    const areYouCoughingDE = 'tMvluCbiiUm';
    const havelostWeight = 'P9hiqrTjAdg';
    const havedrenching = 'Y8Xzy7bEWsi';
    const havefever = 'VETgonq6tFr';
    const lastTestedDE = 'Uv26fX0HQvO';
    const oralHealthMessagingDE = 'wRhamvRZj87';
    const hadsexwithmorethanone = 'upkFeuyd1fX';
    const sexwithoucondomPositve = 'R38Mm0YgXcx';
    const sexwithoucondomUnknown = 'qoKPxEkgfdh';
    const genitalsores = 'B46Zeuzafkg';
    const vltestingDE = 'sLyfb45aLkl';
    const cd4testingDE = 'tYN12Es3707';
    const viralLoadResultsDE = 'aRNGDZcwWmS';


    bool moreThanSixMonthsOnArt(Map<String, String?> m) {
      final raw = (m[durationOnArt] ?? '').toString().trim().toLowerCase();
      return raw == 'more than six months';
    }
    // Gap DEs
    const ancGapDE = 'vbUdFOsYrxP';
    const eidTestingGapDE = 'WcSjQ6oQ4dw';
    const uderFiveClinicGapDE = 'wR6vGDR8nHi';
    const foodSupplementsGapDE = 'uvJV4WGc5ct';
    const hivSndGapDE = 'cx4xBY4jZXM';
    const disclosureSupportGapDE = 'eQTJrTcKzVK';
    const hivAdherenceGapDE = 'HKCv7lkLexo';
    const hivTreatGapDE = 'ylSjcj6cv42';
    const tbTreatGapDE = 'bRv4ZZy5MDH';
    const comArtAdherenceGapDE = 'gff7hjjVoI6';
    const artLiteracyGapDE = 'vqRohVpTK2G';
    const htsGapDE = 'XoSPWmpWXCy';
    const oralHealthGapDE = 'ztDAwmkSwKf';
    const enhancedAdherenceCouncilingGapDE = 'XuZIbkwn5yi';
    const psycosocialsupportGapDE = 'WiPTQhWLVU1';
    const viralLoadTestingGapDE = 'bepi3n6Z4T0';
    const cd4TestingGapDE = 'SHWV7e088RT';


    final attandingANC = _isTrue(a[ancDE]);
    final hiv = _normHiv(a[hivStatusDE]);
    final malnutrition = _isTrue(a[malnutritionSignsDE]);
    final feelingSupported = a[feelingSupportedDE];
    final age = _ageFromChild(child);
    final hivPositive = hiv == 'Positive';
    final onArt = _isTrue(a[artStatusDE]);
    final coughing = _isTrue(a[areYouCoughingDE]);
    final lostWeight = _isTrue(a[havelostWeight]);
    final haveDrenching = _isTrue(a[havedrenching]);
    final hasFever = _isTrue(a[havefever]);
    final recentTest = _testedWithin3Months(a[lastTestedDE]);
    final oralHealthFlag = _isTrue(a[oralHealthMessagingDE]);
    final attendingUnderFiveClinic = _isTrue(a[underFiveCLinicDE]);
    final childisHei = _isTrue(child.isHei);
    final childTestedAsperHeiAlg = _isTrue(child.testedHeiAlgorithm);
    final hadsexWithMoreThanOne = _isTrue(a[hadsexwithmorethanone]);
    final sexWithouCondomPositive = _isTrue(a[sexwithoucondomPositve]);
    final sexWithouCondomUnknown = _isTrue(a[sexwithoucondomUnknown]);
    final genitalSores = _isTrue(a[genitalsores]);
    final testForVL = _isTrue(a[vltestingDE]);
    final testdforCD4 = _isTrue(a[cd4testingDE]);
    final overSixMonthsOnArt = moreThanSixMonthsOnArt(a);
    final viralLoadResults = a[viralLoadResultsDE];

    final isFemale = _isTrue(child.sex == 'Female');

    if( isFemale && !attandingANC){
      dataObject[ancGapDE] = true;
    }
    if (overSixMonthsOnArt && !testForVL) {
      dataObject[viralLoadTestingGapDE] = true;
    }
    if (hivPositive && (viralLoadResults ?? '').isNotEmpty) {
      if (viralLoadResults == 'High (above 1,000 copies/ml)') {
        if (!testdforCD4) {
          dataObject[cd4TestingGapDE] = true;
        }
        dataObject[enhancedAdherenceCouncilingGapDE] = true;
      }
    }
    if (!hivPositive && !recentTest) {
      if (hadsexWithMoreThanOne ||
          sexWithouCondomPositive ||
          sexWithouCondomUnknown ||
          genitalSores) {
        dataObject[htsGapDE] = true;
      }
    }


    if(childisHei){
      if(!childTestedAsperHeiAlg){
        dataObject[eidTestingGapDE] = true;
      }

    }

    if( age < 5 && !attendingUnderFiveClinic){
      dataObject[uderFiveClinicGapDE] = true;
    }
    if(age > 3 && a[hivStatusDE] == null){
      dataObject[htsGapDE] = true;
    }

    if (age >= 0 && age <= 5 && malnutrition) {
      dataObject[foodSupplementsGapDE] = true;
    }

    if (age > 8) {
      dataObject[hivSndGapDE] = true;
      if (oralHealthFlag) dataObject[oralHealthGapDE] = true;
      if (feelingSupported != null && feelingSupported != 'Yes') {
        dataObject[disclosureSupportGapDE] = true;
      }
      if (onArt) dataObject[hivAdherenceGapDE] = true;
      if (coughing) dataObject[tbTreatGapDE] = true;
      if (hivPositive && !onArt) dataObject[hivTreatGapDE] = true;
      if (hivPositive) {
        dataObject[comArtAdherenceGapDE] = true;
        dataObject[artLiteracyGapDE] = true;
      }
      if (age > 8 && !hivPositive && !recentTest) dataObject[htsGapDE] = true;
      if (age > 3 && age <= 8 && a[highRiskAssessDE] == 'High risk') dataObject[htsGapDE] = true;
    } else {
      if (hivPositive) {
        dataObject[hivAdherenceGapDE] = true;
        dataObject[artLiteracyGapDE] = true;
      }
    }
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

  void onSaveGapForm(BuildContext context) {
    _pruneFalseyToggles(dataObject);

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
          message: 'No new gaps for this beneficiary',
        );
      }
    } else {
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
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
            ),
          )
        ],
      ),
    );
  }
}

