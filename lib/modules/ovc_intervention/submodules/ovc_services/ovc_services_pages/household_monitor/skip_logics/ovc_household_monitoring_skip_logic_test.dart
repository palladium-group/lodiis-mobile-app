import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:provider/provider.dart';

// NEW: read assessment values from state
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_household_assessment_constant.dart';

import '../../household_case_plan/constants/ovc_household_case_plan_constant.dart';
import '../../household_service/constants/ovc_service_household_constant.dart';

class OvchouseHoldMonitoringSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};
  static Map hiddenInputFieldOptions = {};

  // ----------------------------
  // Helpers to access Assessment
  // ----------------------------
  static Map<String, String?> _latestAssessmentVals(BuildContext context) {
    try {
      return Provider.of<ServiceEventDataState>(context, listen: false)
          .latestValuesForStage(OvcHouseholdAssessmentConstant.programStage);
    } catch (_) {
      return const {};
    }
  }


  // ----------------------------
  // Helpers to access Service Provision
  // ----------------------------
  static Map<String, String?> _latestServiceVals(BuildContext context) {
    try {
      return Provider.of<ServiceEventDataState>(context, listen: false)
          .latestValuesForStage(OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage);
    } catch (_) {
      return const {};
    }
  }

  // Normalize HIV status values coming from Assessment (labels/codes)
  // Returns "Positive", "Negative", or the original string if unknown.
  static String? _normalizeHivStatus(String? raw) {
    final s = raw?.trim().toLowerCase();
    if (s == null || s.isEmpty) return null;

    const positives = {'positive', 'pos', 'positive (known)', '1', 'true', 'yes'};
    const negatives = {'negative', 'neg', '0', 'false', 'no'};

    if (positives.contains(s)) return 'Positive';
    if (negatives.contains(s)) return 'Negative';
    return raw; // leave as-is if not matched
  }

  static Future evaluateSkipLogics(
      BuildContext context,
      List<FormSection> formSections,
      Map dataObject,
      String? hivStatus,
      bool? artStatus,
      String? sex,
      bool? caregiverTestedForHiv,
      DateTime? artInitiationDate,
      ) async {
    hiddenFields.clear();
    hiddenSections.clear();
    hiddenInputFieldOptions.clear();

    hiddenSections['domainsafe'] = true;
    hiddenSections['healthcaseplangaps'] = true;
    hiddenSections['otherdetails'] = true;

    // -------------------------------------------------------------
    // 1) Pull latest Assessment values and prefill Monitoring fields
    // -------------------------------------------------------------
    final assessmentVals = _latestAssessmentVals(context);
    final servicesVals = _latestServiceVals(context);

    var hivSDprovided = servicesVals['HzI5X2yHef6'];
print('Services:$servicesVals');
    // HIV status DE used in both Assessment and Monitoring
    const hivStatusDE = 'vNeOE9abQBB';

    // Prefer Assessment HIV status if present
    final hivFromAssessmentNorm =
    _normalizeHivStatus(assessmentVals[hivStatusDE]?.toString());

    // If monitoring field is empty OR caller didn't supply hivStatus, use Assessment
    if ((dataObject[hivStatusDE] == null || '${dataObject[hivStatusDE]}'.isEmpty) &&
        hivFromAssessmentNorm != null) {
      dataObject[hivStatusDE] = hivFromAssessmentNorm;
    }
    if ((hivStatus == null || hivStatus.isEmpty) && hivFromAssessmentNorm != null) {
      hivStatus = hivFromAssessmentNorm;
    }

    // ---------------------------------------------
    // 2) Proceed with your existing dynamic behavior
    // ---------------------------------------------
    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }
    inputFieldIds = inputFieldIds.toSet().toList();

    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';

      if (inputFieldId == 'sLyfb45aLkl') {
        if (value == '1') {
          hiddenFields.remove('P52dMXyK4eA');
        } else {
          hiddenFields['P52dMXyK4eA'] = true;
        }
      }
      if (inputFieldId == 'BvNaiaoxc6w' && value != 'true'){
        hiddenFields['Uv26fX0HQvO'] = true;
        hiddenFields['vNeOE9abQBB'] = true;
        hiddenFields['Icgkv0xkUow'] = true;
        hiddenFields['ubin7MjQ5OI'] = true;
        hiddenFields['sLyfb45aLkl'] = true;
        hiddenFields['aRNGDZcwWmS'] = true;
        hiddenFields['P52dMXyK4eA'] = true;
        hiddenFields['tYN12Es3707'] = true;
        hiddenFields['o1GBFscjs4y'] = true;
        hiddenFields['BYZu8p33lzP'] = true;
        hiddenFields['ToWhhydys'] = true;
        hiddenFields['I3hI2UTkKyx'] = true;
        hiddenFields['KFCBwn7ypws'] = true;
      }
      if (inputFieldId == 'aRNGDZcwWmS' &&
          value != "High (above 1,000 copies/ml)") {
        hiddenFields['tYN12Es3707'] = true;
      }

      //////////////


  if(inputFieldId == 'HzI5X2yHef6' ){

    dataObject[inputFieldId] = hivSDprovided;

  }


  ////////////////
      if (inputFieldId == 'tYN12Es3707' && value != 'true') {
        hiddenFields['o1GBFscjs4y'] = true;
      }

      // Use normalized HIV status for decisions (handles POS/positive/etc.)
      final bool isHivPositive = (hivStatus == 'Positive');

      if (!isHivPositive) {
        // Not Positive → show "When last did you test" (Uv26fX0HQvO),
        // hide adherence/ART-only fields
        hiddenFields['BYZu8p33lzP'] = true;
        hiddenFields['KFCBwn7ypws'] = true;
        hiddenFields['Uv26fX0HQvO'] = false; // ✳️ ensure visible
      } else {
        // Positive → hide "When last did you test"
        hiddenFields['Uv26fX0HQvO'] = true;
      }

      if (inputFieldId == 'Uv26fX0HQvO' && value == 'Less than 3 months' ||
          (inputFieldId == 'Uv26fX0HQvO' && value == 'null') ||
          (caregiverTestedForHiv == false) || (!isHivPositive)) {
        hiddenSections['hivscreening'] = true;
      }

      if (inputFieldId == 'blod3xZ2dPP' && value != '1') {
        dataObject['HKCv7lkLexo'] = 'false';
        hiddenFields['ubin7MjQ5OI'] = true;
        hiddenFields['HKCv7lkLexo'] = true;
        hiddenFields['JzlLk2tW4xh'] = true;
      }

      if (sex != 'Female') {
        hiddenFields['pJ1UrnLU9mh'] = true; // Pregnant
        hiddenFields['dCIDHw3RrQ9'] = true; // Breastfeeding

        if (caregiverTestedForHiv != true) {
          hiddenFields['Uv26fX0HQvO'] = true;
          hiddenFields['vNeOE9abQBB'] = true;
          hiddenFields['Icgkv0xkUow'] = true;
          hiddenFields['sLyfb45aLkl'] = true;
        }

        if (artInitiationDate != null) {
          final now = DateTime.now();
          final sixMonthsFromNow = DateTime(now.year, now.month - 6, now.day);
          if (artInitiationDate.isBefore(sixMonthsFromNow)) {
            dataObject['ubin7MjQ5OI'] = 'more than six months';
          } else {
            dataObject['ubin7MjQ5OI'] = 'less than six months';
          }
        }

        if (inputFieldId == 'BvNaiaoxc6w') {
          if (hivStatus != null) {
            dataObject[inputFieldId] = 'true';
          } else if (hivStatus == null) {
            hiddenFields['Uv26fX0HQvO'] = true;
            dataObject[inputFieldId] = 'false';
          }
        }

        if (inputFieldId == 'T4grVrCVDkk') {
          if (hivStatus != null) {
            dataObject[inputFieldId] = "true";
          } else {
            hiddenFields['vNeOE9abQBB'] = true;
          }
        }

        if (inputFieldId == hivStatusDE) {
          if (hivStatus != null) {
            dataObject[inputFieldId] = hivStatus;

            if (dataObject[inputFieldId] != 'Positive') {
              hiddenFields['blod3xZ2dPP'] = true;
              hiddenFields['ubin7MjQ5OI'] = true;
              hiddenFields['Icb6vUJXVDX'] = true;
            }
          }
        }

        if (inputFieldId == 'Icgkv0xkUow') {
          if (artStatus != null) {
            dataObject[inputFieldId] = artStatus;
          }
        }

        if (inputFieldId == 'UffKzmI4698' && value != 'true') {
          hiddenFields['Icgkv0xkUow'] = true;
          hiddenFields['ubin7MjQ5OI'] = true;
        }

        if (inputFieldId == hivStatusDE) {
          if (hivStatus != null) {
            dataObject[inputFieldId] = hivStatus;
            if (dataObject[inputFieldId] == 'Negative') {
              hiddenFields['sLyfb45aLkl'] = true;
              hiddenFields['aRNGDZcwWmS'] = true;
              hiddenFields['KgLtXquRot3'] = true;
              hiddenFields['why_choose_this_facility'] = true;
              hiddenFields['WKT65kLT9AT'] = true;
              hiddenFields['QgWzwLkRjul'] = true;
              hiddenFields['I4M6NLNMbG3'] = true;
              hiddenFields['FqLADURlSw6'] = true;
              hiddenFields['NlWEhu1onQW'] = true;
              hiddenFields['aUZ2HTFvI4A'] = true;
              hiddenFields['WUwcEkmhaan'] = true;
              hiddenFields['beztnfLGhxi'] = true;
              hiddenFields['Icgkv0xkUow'] = true;
            }
          }
        }

        if (inputFieldId == hivStatusDE) {
          if (hivStatus != null) {
            dataObject[inputFieldId] = hivStatus;
            if (dataObject[inputFieldId] == 'Positive') {
              dynamic onArtToTreatHiv = dataObject['blod3xZ2dPP'] ?? '';
              if ('$onArtToTreatHiv' == '0') {
                hiddenFields['Icb6vUJXVDX'] = true;
              }
            }
          }
        }

        if (inputFieldId == 'BvNaiaoxc6w') {
          final bool? caregiverEverTested =
          dataObject['BvNaiaoxc6w'] as bool?;
          if (caregiverEverTested != null) {
            dataObject[inputFieldId] = caregiverEverTested;
            if (caregiverEverTested == false) {
              hiddenFields['Icgkv0xkUow'] = true;
              hiddenFields['ubin7MjQ5OI'] = true;
            }
          }
        }
      }
    }

    for (String sectionId in hiddenSections.keys) {
      List<FormSection> allFormSections =
      FormUtil.getFlattenFormSections(formSections);
      List<String> hiddenSectionInputFieldIds = FormUtil.getFormFieldIds(
          allFormSections
              .where((formSection) => formSection.id == sectionId)
              .toList());
      for (String inputFieldId in hiddenSectionInputFieldIds) {
        hiddenFields[inputFieldId] = true;
      }
    }
    resetValuesForHiddenFields(context, hiddenFields.keys);
    resetValuesForHiddenSections(context, formSections);
    resetValuesForHiddenInputFieldOptions(context);
  }

  static resetValuesForHiddenFields(BuildContext context, inputFieldIds) {
    for (String inputFieldId in inputFieldIds) {
      if (hiddenFields[inputFieldId]) {
        assignInputFieldValue(context, inputFieldId, null);
      }
    }
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenFields(hiddenFields);
  }

  static resetValuesForHiddenSections(
      BuildContext context,
      List<FormSection> formSections,
      ) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenSections(hiddenSections);
  }

  static resetValuesForHiddenInputFieldOptions(
      BuildContext context,
      ) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenInputFieldOptions(hiddenInputFieldOptions);
  }

  static assignInputFieldValue(
      BuildContext context,
      String inputFieldId,
      String? value,
      ) {
    Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
      inputFieldId,
      value,
      isChangesBasedOnSkipLogic: true,
    );
  }
}
