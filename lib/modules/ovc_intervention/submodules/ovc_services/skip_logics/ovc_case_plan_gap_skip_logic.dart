import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:provider/provider.dart';

import '../../../../../app_state/enrollment_service_form_state/service_event_data_state.dart';
import '../constants/ovc_household_assessment_constant.dart';
import '../ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';

mixin OvcCasePlanGapSkipLogic {
  Map hiddenFields = {};
  Map hiddenSections = {};
  Map childMapObject = {};

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




  Future evaluateSkipLogics(
    BuildContext context,
    List<FormSection> formSections,
    Map dataObject, {
    OvcHouseholdChild? currentHouseholdChild,
    Map caregiverDataObject = const {},
  }) async {

    hiddenFields.clear();
    hiddenSections.clear();
    childMapObject.clear();
    final assessmentVals = _latestAssessmentVals(context);
    const hivStatusDE = 'vNeOE9abQBB';
    final hivFromAssessmentNorm =
    _normalizeHivStatus(assessmentVals[hivStatusDE]?.toString());

    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }
    inputFieldIds = inputFieldIds.toSet().toList();

    String implementingPartner = dataObject['implementingPartner'];
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
    // Hiding gap based on the goal
    List<String> casPlanServiceGaps = OvcCasePlanConstant.casPlanServiceGaps;
/*
    for (String gap in casPlanServiceGaps) {
      if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] == 'KnowledgeableAboutHIVEducation' ||
              dataObject[OvcCasePlanConstant.casePlansSecondGoal] ==
                  'KnowledgeableAboutHIVEducation') &&
          ([
            "cx4xBY4jZXM",
            "XoSPWmpWXCy",
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] == 'To adhere to ART' ||
              dataObject[OvcCasePlanConstant.casePlansSecondGoal] ==
                  'To adhere to ART') &&
          ([
            "ylSjcj6cv42",
            "HKCv7lkLexo",
            "pbcXNnAuzfh",
            "bRv4ZZy5MDH",
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] == 'Proper nutrition for my children' ||
              dataObject[OvcCasePlanConstant.casePlansSecondGoal] ==
                  'Proper nutrition for my children') &&
          ([
            "BJrrrqQqwQO",
            "hJUuQ648wVF",
            "AwWKp6KmqgY", //Care givers, propagate
            "JSQ3xP1NhuN", //Care givers, propagate
            "x4yAqv4z2Xv",
            "AM9oJCOHM7f",
            "uvJV4WGc5ct",
            "DQxqyncQtwm", // Caregiver, propagate
            "Hvq9oisH7Gt", // Caregiver, propagate
            "qTf8VSoojJ2", // Caregiver, propagate
            "EaJTFrklMo5",// Caregiver, propagate
            "CaAOIbC10yv",// Caregiver, propagate
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] == 'Access to PMTCT services' ||
              dataObject[OvcCasePlanConstant.casePlansSecondGoal] ==
                  'Access to PMTCT services') &&
          ([
            "d2vXxEPeCq7",
            "LswSBpMoG5C",
            "dTFLFtUUeEK",
            "gCKoJgBFdob",
            "AxtahhoHcXV",
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] == 'Knowledgeable about food security' ||
              dataObject[OvcCasePlanConstant.casePlansSecondGoal] ==
                  'Knowledgeable about food security') &&
          ([
            'WrjNxZBVHCL', // Caregiver, propagate
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] ==
                  'Learn about food production and preservation' ||
              dataObject[OvcCasePlanConstant.casePlansSecondGoal] ==
                  'Learn about food production and preservation') &&
          ([
            'WrjNxZBVHCL', // Caregiver, propagate
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] == 'To improve my family financial status' ||
              dataObject[OvcCasePlanConstant.casePlansSecondGoal] ==
                  'To improve my family financial status') &&
          ([
            "e6NV2ZAzFEh", // Caregiver, propagate
            "yPP7lkomNfK",
            "HsxFZOuV4oZ",
            "kvF996ugmMl", //  Caregiver, propagate 9- 17
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] == 'Knowledgeable about VAC' ||
              dataObject[OvcCasePlanConstant.casePlansSecondGoal] ==
                  'Knowledgeable about VAC') &&
          ([
            "uQiyym8SEvd",
            "aPmPhwm8Zln",
            "AaqeRcyjbyS",
            "WdZ3PnW5yV6",
            "Ccp4Odlh3BE",
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] == 'Knowledgeable about child protection' ||
              dataObject[OvcCasePlanConstant.casePlansSecondGoal] ==
                  'Knowledgeable about child protection') &&
          ([
            "WiPTQhWLVU1", // Caregiver, propagate
            "PoxYSqq8Hgz", // Caregiver, propagate to <5
            "hS7aONLz2cq",
            "GO3Ojp1UEX7",
            "exHDkX1gPiC",
            "yf6KmY3Rm5I",
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] == 'Better school attendance and performance' ||
              dataObject[OvcCasePlanConstant.casePlansSecondGoal] == 'Better school attendance and performance') &&
          ([
            "X47zxNAqMv0",
            "qraZh4n14S4",
            "q2N7p3UbvSF",
            "NcMANzhhphO",
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else if ((dataObject[OvcCasePlanConstant.casePlanFirstGoal] == 'Equipped with social assets for better living' || dataObject[OvcCasePlanConstant.casePlansSecondGoal] == 'Equipped with social assets for better living') &&
          ([
            "Cb8qzfdrg7d",
            "TdReJf2LTXA",
          ].contains(gap))) {
        hiddenFields[gap] = shouldServiceBeHiddenByImplementingPartner(
            gap, implementingPartner);
      } else {
        hiddenFields[gap] = true;
      }
    }
*/

    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';
      if (inputFieldId == 'HKCv7lkLexo' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['d3X7sRgkQkl'] = true;
        hiddenFields['d8vFkGjiux4'] = true;
        hiddenFields['JzlLk2tW4xh'] = true;
      }
      if (inputFieldId == 'uvJV4WGc5ct' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['mvdraUOCfKA'] = true;
        hiddenFields['aZ1ogdjGHUV'] = true;
        hiddenFields['F2IOqOr4EuV'] = true;
      }
      if (inputFieldId == 'XoSPWmpWXCy' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['iFv7FJeG3V1'] = true;

      }
      if (inputFieldId == 'bRv4ZZy5MDH' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['mvDI6Jr40kI'] = true;
        hiddenFields['OPmcOXe5Ogy'] = true;
        hiddenFields['Wc58mUb3AXg'] = true;
        hiddenFields['IhzyIy3tzo0'] = true;
      }
      if (inputFieldId == 'ylSjcj6cv42' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['JDqgRJlOSeZ'] = true;
        hiddenFields['elqeNdaYNTS'] = true;
        hiddenFields['qMrZcC7VvCV'] = true;
        hiddenFields['IhzyIy3tzo0'] = true;
      }
      if (inputFieldId == 'cx4xBY4jZXM' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['b6hvMQuH3oJ'] = true;
        hiddenFields['iy0KZ7K4qld'] = true;


        hiddenFields['SIEeRmPm0Q0'] = true;

      }
      if (inputFieldId == 'ztDAwmkSwKf' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['bK18Ebt1cRa'] = true;

      }
      if (inputFieldId == 'zkbTGkrT6bH' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['G4kPVSr7I8U'] = true;

      }
      if (inputFieldId == 'XuZIbkwn5yi' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['uwuAbOBtPHf'] = true;

      }
      if (inputFieldId == 'gff7hjjVoI6' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['YI1Ckbt8mRn'] = true;

      }
      if (inputFieldId == 'vqRohVpTK2G' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['vUMhUm3i0b0'] = true;

      }
    if(hivFromAssessmentNorm == 'Positive'){

     hiddenFields['XoSPWmpWXCy'] = true;
     hiddenFields['iFv7FJeG3V1'] = true;


    }

      if (inputFieldId == 'd2vXxEPeCq7' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['HbjnW1JjroQ'] = true;
        hiddenFields['GnsYKEE2fnr'] = true;
        hiddenFields['kpzlTeM0673'] = true;
        hiddenFields['X2CA3iQZU74'] = true;
      }
      if (inputFieldId == 'dTFLFtUUeEK' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['b3vvyHQKsoK'] = true;
        hiddenFields['emAJOTWYHVq'] = true;
        hiddenFields['jlu7TDN7khJ'] = true;
        hiddenFields['lwa1qFrFISz'] = true;
      }
      if (inputFieldId == 'Hvq9oisH7Gt' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['pRhbAQNT0NO'] = true;
        hiddenFields['ue6xLPEURqt'] = true;
        hiddenFields['tQ3pKyJ0X9d'] = true;
        hiddenFields['vIbKIUgzBU4'] = true;
      }
      if (inputFieldId == 'qTf8VSoojJ2' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['qV0BwfYa8yU'] = true;
        hiddenFields['ontonbgTJ8k'] = true;
        hiddenFields['M2Aqvn027cd'] = true;
        hiddenFields['AjYKLfIQPtT'] = true;
      }
      if (inputFieldId == 'DQxqyncQtwm' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['LPDcGvb5bp7'] = true;
        hiddenFields['P4I6rK6Xqxw'] = true;
        hiddenFields['YJXb5rSVP0L'] = true;
        hiddenFields['WFKe1YpH1uK'] = true;
      }
      if (inputFieldId == 'e6NV2ZAzFEh' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['UJIxjjBeJTh'] = true;
        hiddenFields['JtfKB58MvNK'] = true;
        hiddenFields['Hdf3EtTGfAb'] = true;
        hiddenFields['MMjndp2xsoQ'] = true;
      }
      if (inputFieldId == 'kvF996ugmMl' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['x29nktyRKEn'] = true;
        hiddenFields['OMtcDA7tcVL'] = true;
        hiddenFields['zVCkEJuy2t8'] = true;
        hiddenFields['Mz24UpWclb3'] = true;
      }
      if (inputFieldId == 'iiJpQsEE4qx' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['Am9LJf6APMW'] = true;
        hiddenFields['xse9M31M9z1'] = true;
        hiddenFields['nIoqbMHf3AS'] = true;
        hiddenFields['uLi7eqd0eEy'] = true;
      }
      if (inputFieldId == 'ithLHgsAoxs' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['aN9rwRWUOr9'] = true;
        hiddenFields['cKJggm2OXFQ'] = true;
        hiddenFields['kCoBEKqJelO'] = true;
        hiddenFields['NUXAxwvM3FE'] = true;
      }
      if (inputFieldId == 'JqGGsDlZh8T' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['ixFuNoQKLoB'] = true;
        hiddenFields['a9geBDwDmXA'] = true;
        hiddenFields['XODRLh84TdQ'] = true;
        hiddenFields['s5mJvzRyfmW'] = true;
      }
      if (inputFieldId == 'WrjNxZBVHCL' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['aUJZcOapflH'] = true;
        hiddenFields['NWBZilCPutW'] = true;
        hiddenFields['d3k97F0fS2y'] = true;
        hiddenFields['boUUP8UeWDL'] = true;
      }
      if (inputFieldId == 'PoxYSqq8Hgz' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['ond1LSLwHBC'] = true;
        hiddenFields['O3mOdzWYmg3'] = true;
        hiddenFields['fCDk1LxN484'] = true;
        hiddenFields['WFscqdyjgUy'] = true;
      }
      if (inputFieldId == 'aPmPhwm8Zln' && value != 'true') {

        hiddenFields[inputFieldId] = true;
        hiddenFields['xMrGYeREh1d'] = true;
        hiddenFields['jKqWohAPqyW'] = true;
        hiddenFields['wGrQeSydiwd'] = true;
        hiddenFields['U8jnyQsnfBD'] = true;
      }
      if (inputFieldId == 'AaqeRcyjbyS' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['RCDsibNNIWq'] = true;
        hiddenFields['TizNGPP6e1d'] = true;
        hiddenFields['A4xYu8BYOg7'] = true;
        hiddenFields['Q7GxvZD6h99'] = true;
      }
      if (inputFieldId == 'Vd8dV7OweWB' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['VL3CAgTpdqK'] = true;
        hiddenFields['UDYd31rUKgN'] = true;
        hiddenFields['ZO2Zg7kaYyD'] = true;
        hiddenFields['XvOgqGxX39f'] = true;
      }
      if (inputFieldId == 'Ccp4Odlh3BE' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['tPDgzkbmywi'] = true;
        hiddenFields['kGoKVtkQxvk'] = true;
        hiddenFields['Io9nnYXCvWR'] = true;
        hiddenFields['yoI0bu18mPo'] = true;
      }
      if (inputFieldId == 'WdZ3PnW5yV6' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['Hvvdmc2rsKl'] = true;
        hiddenFields['dJR6GJyHCTr'] = true;
        hiddenFields['OIw6D3I6BmY'] = true;
        hiddenFields['cu1UkUUTbME'] = true;
      }
      if (inputFieldId == 'hS7aONLz2cq' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['psqUATvYzdu'] = true;
        hiddenFields['LDH3TLjHUYK'] = true;
        hiddenFields['SvkvfRNqyh2'] = true;
        hiddenFields['Pd5CyDu2Z54'] = true;
      }
      if (inputFieldId == 'TQSMaZgfZPO' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['y9Qs6zDLZM2'] = true;
        hiddenFields['do1fAllY7Jv'] = true;
        hiddenFields['mvuyd2jt4Jz'] = true;
        hiddenFields['y5v9t8Skiyi'] = true;
      }
      if (inputFieldId == 'SN2kJN3jAG9' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['LXX0ixRx2IT'] = true;
        hiddenFields['k9R0AUmBqHS'] = true;
        hiddenFields['bIMwh3ONDGq'] = true;
        hiddenFields['k2eUheeYmfk'] = true;
      }
      if (inputFieldId == 'X47zxNAqMv0' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['fVfftqUpEMa'] = true;
        hiddenFields['kfcqLf2d2dc'] = true;
        hiddenFields['rPhOdwWvfOA'] = true;
        hiddenFields['ewpLauNhb8N'] = true;
      }
      if (inputFieldId == 'yJQi4cbzeBF' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['l8HRb7CFYOW'] = true;
        hiddenFields['H4TLyWdOdrI'] = true;
        hiddenFields['DqlxkJ0dMA2'] = true;
        hiddenFields['iWH5MhwPSbD'] = true;
      }
      if (inputFieldId == 'x4yAqv4z2Xv' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['eTDE6zroxBC'] = true;

      }
      if (inputFieldId == 'bepi3n6Z4T0' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['A8iJ8Al2F68'] = true;

      }

      if (inputFieldId == 'SHWV7e088RT' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['gez23HygrJq'] = true;

      }

      if (inputFieldId == 'AM9oJCOHM7f' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['KzxrHSAQQa0'] = true;
        hiddenFields['SOPRtGCfa5Z'] = true;
        hiddenFields['RoJrwtEhpzk'] = true;
        hiddenFields['B9YT3pHNGOg'] = true;
      }
      if (inputFieldId == 'hJUuQ648wVF' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['aYFP1w8y96h'] = true;
        hiddenFields['o37J0mUPmg6'] = true;
        hiddenFields['QfqDdhGC5vR'] = true;
      }
      if (inputFieldId == 'BJrrrqQqwQO' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['joBt3RJP76y'] = true;
        hiddenFields['S6O1OxbLfzz'] = true;
        hiddenFields['wQDSOL4EJ8G'] = true;
      }
      if (inputFieldId == 'LswSBpMoG5C' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['RUoYTsLHBdY'] = true;
        hiddenFields['ziQvzVbjmcb'] = true;
        hiddenFields['FAJpI6PUK8w'] = true;
      }
      if (inputFieldId == 'gCKoJgBFdob' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['mWwizkG0EK2'] = true;
        hiddenFields['VmuVgr4tfor'] = true;
        hiddenFields['nUIvqATNc7A'] = true;
      }
      if (inputFieldId == 'JSQ3xP1NhuN' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['k6jzyzGOu5Y'] = true;
        hiddenFields['MdmCqSwcrlk'] = true;
        hiddenFields['HrCyUkuZath'] = true;
      }
      if (inputFieldId == 'AwWKp6KmqgY' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['cXCdR7BvrSM'] = true;
        hiddenFields['Mu0LxlAOoSp'] = true;
        hiddenFields['u8yn7sY5eOX'] = true;
      }

      if (inputFieldId == 'yPP7lkomNfK' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['oASchGdCDjh'] = true;
        hiddenFields['ZQ6jDrZ54ic'] = true;
        hiddenFields['vJx6vWPxGsJ'] = true;
        hiddenFields['XhG2eidZKCN'] = true;
      }
      if (inputFieldId == 'uQiyym8SEvd' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['HfJSiIYVwn9'] = true;
        hiddenFields['GjIU252Rcvq'] = true;
        hiddenFields['MEFwYLoRyPR'] = true;
        hiddenFields['meOOSrOPoLB'] = true;
      }
      if (inputFieldId == 'WiPTQhWLVU1' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields[inputFieldId]=true;
        hiddenFields['BpLk6ruSL7e'] = true;
      }
      if (inputFieldId == 'neF08iYV9Os' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['cVOG90HglRW'] = true;
        hiddenFields['kGQwyzaP5Km'] = true;
        hiddenFields['Y1ta8eJAWBT'] = true;
        hiddenFields['OyeIR1fmV4s'] = true;
      }
      if (inputFieldId == 'Cb8qzfdrg7d' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['JiqD0sYv7pH'] = true;
        hiddenFields['HeoYwEJukC8'] = true;
        hiddenFields['vqmvjogGeX5'] = true;
      }
      if (inputFieldId == 'qraZh4n14S4' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['dSS3xEVkH26'] = true;
        hiddenFields['ZwGE57BjVdJ'] = true;
        hiddenFields['JXx3FiIQe08'] = true;
      }
      if (inputFieldId == 'TdReJf2LTXA' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['EonyCjxIh5l'] = true;
        hiddenFields['YIFHsUgTAlI'] = true;
        hiddenFields['meR35m2WVNZ'] = true;
      }
      if (inputFieldId == 'q2N7p3UbvSF' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['XFY4FxA7ymC'] = true;
        hiddenFields['Gw1wRcsPemn'] = true;
        hiddenFields['rjKp0pEFJ2L'] = true;
      }
      if (inputFieldId == 'NcMANzhhphO' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['fT9sHAd6Gvw'] = true;
        hiddenFields['GhPb5Acr00X'] = true;
        hiddenFields['lO7yfY3mBYB'] = true;
      }
      if (inputFieldId == 'ksc7ov3MihX' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['Mq7g4k4lk44'] = true;
        hiddenFields['LGsvIyYkrP8'] = true;
        hiddenFields['XSTUvAjvijB'] = true;
      }

      if (inputFieldId == 'pbcXNnAuzfh' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['X4OdB7fDJs6'] = true;
        hiddenFields['rKeQ5AA6Gqt'] = true;
        hiddenFields['CgtL9IfeuTB'] = true;
      }
      if (inputFieldId == 'GO3Ojp1UEX7' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['Rm4ooBgON9O'] = true;
        hiddenFields['gi7tMxuE2nG'] = true;
        hiddenFields['Trhl3lfCSA6'] = true;
      }
      if (inputFieldId == 'exHDkX1gPiC' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['MaBOowDgrFF'] = true;
        hiddenFields['aVfUmmotSaB'] = true;
        hiddenFields['MDMmtTJTIyh'] = true;
      }
      if (inputFieldId == 'yf6KmY3Rm5I' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['oth3dRYox12'] = true;
        hiddenFields['RsCebbDkMx9'] = true;
        hiddenFields['YtwjCoHKA9G'] = true;
      }
      if (inputFieldId == 'CaAOIbC10yv' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['v7GBKBoqJPr'] = true;
      }
      if (inputFieldId == 'eQTJrTcKzVK' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['taejdmpbsoG'] = true;
      }
      if (inputFieldId == 'EaJTFrklMo5' && value != 'true') {
       hiddenFields[inputFieldId] = true;
        hiddenFields['WAq2HJHXZYS'] = true;
      }
      if (inputFieldId == 'AxtahhoHcXV' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['G6GkSeccLmB'] = true;
        hiddenFields['GULhHDCXRvz'] = true;
        hiddenFields['ugZKkd3UMNF'] = true;
      }

      if (inputFieldId == 'HsxFZOuV4oZ' && value != 'true') {
        hiddenFields[inputFieldId] = true;
        hiddenFields['KKZBSXc1Sg3'] = true;
        hiddenFields['DdNC3FdhhsW'] = true;
        hiddenFields['tRxPMAXY6VC'] = true;
      }
    }
    if (currentHouseholdChild != null) {
      evaluateAgeSkipLogics(inputFieldIds, currentHouseholdChild);
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
  }

  ///
  /// this function filter the services based on IP
  /// It's implemented based on Paralegal
  ///
  bool shouldServiceBeHiddenByImplementingPartner(
    String service,
    String implementingPartner,
  ) {
    if (OvcCasePlanConstant.paralegalServices.contains(service)) {
      var isCurrentUserParalegal = implementingPartner == 'Paralegal';
      return !isCurrentUserParalegal;
    } else if (implementingPartner == 'Paralegal') {
      return true;
    } else {
      return false;
    }
  }

  resetValuesForHiddenFields(BuildContext context, inputFieldIds) {
    for (String inputFieldId in inputFieldIds) {
      if (hiddenFields[inputFieldId]) {
        assignInputFieldValue(context, inputFieldId, null);
      }
    }
  }

  assignInputFieldValue(
    BuildContext context,
    String inputFieldId,
    String? value,
  ) {
    childMapObject[inputFieldId] = value;
  }

  void evaluateAgeSkipLogics(
      List<String> inputFieldIds, OvcHouseholdChild? currentHouseholdChild) {
    try {
      int age = int.parse(currentHouseholdChild!.age!);
      String sex = currentHouseholdChild.sex ?? '';
      bool isClHiv = currentHouseholdChild.isClHiv;
      if (age > 17 || !isClHiv) {
        hiddenFields['pbcXNnAuzfh'] = true;
      }

      if (age > 17) {
        hiddenFields['GO3Ojp1UEX7'] = true;
        hiddenFields['exHDkX1gPiC'] = true;
        hiddenFields['yf6KmY3Rm5I'] = true;
        hiddenFields['HsxFZOuV4oZ'] = true;
      }
      if (age < 9 || age > 17) {
        hiddenFields['yPP7lkomNfK'] = true;
        hiddenFields['aPmPhwm8Zln'] = true;
        hiddenFields['AaqeRcyjbyS'] = true;
        hiddenFields['Cb8qzfdrg7d'] = true;


      }
      if (age < 13 || age > 17) {
        hiddenFields['qraZh4n14S4'] = true;
        if (sex != 'Female') {
          hiddenFields['TdReJf2LTXA'] = true;
        }
      }
      if (age < 2 || age >= 5) {
        hiddenFields['BJrrrqQqwQO'] = true;
      }

    } catch (e) {
      //
    }
  }
}
