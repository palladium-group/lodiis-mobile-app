import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

import '../../../../../../app_state/enrollment_service_form_state/service_event_data_state.dart';
import '../../../../../../core/utils/tracked_entity_instance_util.dart';
import '../../constants/ovc_household_assessment_constant.dart';

class CasePlanGapFormContainer extends StatefulWidget {
  const CasePlanGapFormContainer({
    Key? key,
    required this.formSections,
    required this.isEditableMode,
    required this.formSectionColor,
    required this.dataObject,
  }) : super(key: key);

  final List<FormSection> formSections;
  final bool isEditableMode;
  final Color formSectionColor;
  final Map dataObject;

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
    _prepareForm();
  }

  void _prepareForm() {
    dataObject = widget.dataObject;

    // 1) Pull latest Assessment values
    final assessmentVals = context
        .read<ServiceEventDataState>()
        .latestValuesForStage(OvcHouseholdAssessmentConstant.programStage);
    debugPrint('Assessment latest values: $assessmentVals');
    // 2) Apply mapping rules (Assessment -> Case Plan Gaps)
    _applyAssessmentToGaps(assessmentVals);


    // 3) Continue with normal setup
    for (final id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
    }
    _evaluateSkipLogics();
    setState(() {});
  }

  String? _normHiv(dynamic v) {
    final s = (v ?? '').toString().trim().toLowerCase();
    if (s.isEmpty) return null;
    const pos = {'positive','pos','positive (known)','1','true','yes'};
    const neg = {'negative','neg','0','false','no'};
    if (pos.contains(s)) return 'Positive';
    if (neg.contains(s)) return 'Negative';
    return (v ?? '').toString().trim();
  }

  /// Reads the latest value for DE vNeOE9abQBB (HIV status) from ANY stage on a TEI
  Future<String?> _latestChildHivStatus(String tei) async {
    final all = await TrackedEntityInstanceUtil
        .getSavedTrackedEntityInstanceEventData(tei);
    if (all.isEmpty) return null;

    // sort newest first
    all.sort((a,b) {
      final ad = DateTime.tryParse(a.eventDate ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = DateTime.tryParse(b.eventDate ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });

    for (final e in all) {
      print('KJesuuuuu ${e.dataValues}');
      final list = (e.dataValues as List?) ?? const [];
      for (final dv in list) {
        if (dv is Map && dv['dataElement'] == 'c5TMWtM4VVJ') {

          return _normHiv(dv['value']);
        }
      }
    }
    return null;
  }

  Future<void> _applyAssessmentToGaps(Map<String, String?> a) async {
    // --- Assessment DE UIDs ---
    const hivStatusDE = 'vNeOE9abQBB';
    const artStatusDE = 'Icgkv0xkUow';
    const areYouCoughingDE = 'tMvluCbiiUm';
    const lastTestedDE = 'Uv26fX0HQvO';
    const oralHealthMessagingDE = 'wRhamvRZj87';

    // --- Case plan gap DE UIDs ---
    const hivAdherenceGapDE = 'HKCv7lkLexo';
    const hivTreatGapDE = 'ylSjcj6cv42';
    const tbTreatGapDE = 'bRv4ZZy5MDH';
    const hivSndGapDE = 'cx4xBY4jZXM';
    const comArtAdherenceGapDE = 'gff7hjjVoI6';
    const artLiteracyGapDE = 'vqRohVpTK2G'; // <- confirm real UID
    const htsGapDE = 'XoSPWmpWXCy'; // <- if HTS has a different UID, change this
    const nutritionMessagingDE = 'CaAOIbC10yv';
    const oralHealthGapDE = 'ztDAwmkSwKf';

    bool _isTrue(dynamic v) {
      final s = (v ?? '').toString().trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }

    bool _testedWithin3Months(dynamic v) {
      final raw = (v ?? '').toString().trim();
      if (raw.isEmpty) return false;
      final l = raw.toLowerCase();
      const recentLabels = {'less than 3 months','lt_3_months','lt3m','recent'};
      if (recentLabels.contains(l)) return true;
      final dt = DateTime.tryParse(raw);
      if (dt != null) {
        final diff = DateTime.now().difference(dt).inDays.abs();
        return diff <= 90;
      }
      return false;
    }

    // ---- caregiver/household assessment values ----
    final hiv = _normHiv(a[hivStatusDE]);
    final hivPositive = hiv == 'Positive';
    final onArt = _isTrue(a[artStatusDE]);
    final coughing = _isTrue(a[areYouCoughingDE]);
    final recentTest = _testedWithin3Months(a[lastTestedDE]);
    final oralHealthFlag = _isTrue(a[oralHealthMessagingDE]);

    // ======= YOUR EXISTING GAP RULES (household) ======={
      dataObject[hivSndGapDE] = true;
    dataObject[nutritionMessagingDE] = true;
 if(onArt){
   dataObject[hivAdherenceGapDE] = true;

 }
    if (coughing) {
      dataObject[tbTreatGapDE] = true;
    }
    if (hivPositive && !onArt) {
      dataObject[hivTreatGapDE] = true;
    }
    if (hivPositive) {
      dataObject[comArtAdherenceGapDE] = true;

      dataObject[artLiteracyGapDE] = true;
    }
    if (!hivPositive && !recentTest) {
      dataObject[htsGapDE] = true;
    }
    if (oralHealthFlag) {
      dataObject[oralHealthGapDE] = true;
    }

    // ======= NEW: CHILDREN RULE (your request) =======
    // If caregiver NOT Positive and there exists ANY child age 0–8 with Positive,
    // then set household HIV Adherence Support gap to true.
    if (!hivPositive) {

      final household =
          context.read<OvcHouseholdCurrentSelectionState>().currentOvcHousehold;
      final children = household?.children ?? const [];

      for (final child in children) {
        final childTei = (child.id ?? '');
        if (childTei.isEmpty) continue;

        final age = int.parse(child.age ?? '') ;

        if (age < 0 || age > 8) continue;

        final childHiv = await _latestChildHivStatus(childTei);
        if (_normHiv(childHiv) == 'Positive') {
          dataObject[artLiteracyGapDE] = true;
          dataObject[comArtAdherenceGapDE] = true;
          break; // one positive child (0–8) is enough
        }
      }
    }
  }



  void _evaluateSkipLogics() {
    OvcHouseholdChild? currentHouseholdChild =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild;
    CurrentUser? currentUser =
        Provider.of<CurrentUserState>(context, listen: false).currentUser;
    dataObject = {
      ...dataObject,
      "implementingPartner": currentUser!.implementingPartner ?? ""
    };
    evaluateSkipLogics(context, widget.formSections, dataObject,
        currentHouseholdChild: currentHouseholdChild);
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
