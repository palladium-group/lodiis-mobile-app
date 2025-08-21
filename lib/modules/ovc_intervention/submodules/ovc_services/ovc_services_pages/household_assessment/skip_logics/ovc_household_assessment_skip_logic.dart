import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:provider/provider.dart';

import '../pages/ovc_household_hts_screening_form.dart';

class OvchouseHoldAssessmentSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};
  static Map hiddenInputFieldOptions = {};

  static Future evaluateSkipLogics(BuildContext context,
      List<FormSection> formSections, Map dataObject, String? hivStatus, bool? artStatus,String? sex, bool? caregiverTestedForHiv, DateTime? artInitiationDate) async {
    hiddenFields.clear();
    hiddenSections.clear();
    hiddenInputFieldOptions.clear();

    hiddenSections['domainsafe'] = true;
    hiddenSections['healthcaseplangaps'] = true;
    hiddenSections['otherdetails'] = true;
    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }
    inputFieldIds = inputFieldIds.toSet().toList();
    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';

      if (inputFieldId == 'PiXi6AtLqiQ' && value != 'true') {
        hiddenFields['zUU33n41Soa'] = true;
      }
      if (inputFieldId == 'yqwX3XCGAUN' && value != 'true') {
        hiddenFields['BKDRNiyoMgV'] = true;
      }

      if (inputFieldId == 'p8htbyJHydl' && value != 'true') {
        hiddenFields['p8htbyJHydl_checkbox'] = true;
        hiddenFields['kFRCZNQIF51'] = true;
        hiddenFields['Pe3CHmZicqT'] = true;
        hiddenFields['DgzwMbXo0ZK'] = true;
        hiddenFields['GC6eZ5TOt9z'] = true;
        hiddenFields['bKkHP4C1WzO'] = true;
        hiddenFields['roCpGtUYOhp'] = true;
        hiddenFields['mXBvp9ahws3'] = true;
        hiddenFields['jtCijspeacL'] = true;
      }
      if (inputFieldId == 'jtCijspeacL' && value != 'true') {
        hiddenFields['Vur0hsmfhQ5'] = true;
      }
      if (inputFieldId == 'W3N2e2SaBCp' && value != 'true') {
        hiddenFields['jvbE4vFHjA6'] = true;
      }
      if (inputFieldId == 'ut8LqpHyZnR' && value != 'true') {
        hiddenFields['ut8LqpHyZnR_checkbox'] = true;
        hiddenFields['TeVmOZEH9ww'] = true;
        hiddenFields['WYUkGeSWaZY'] = true;
        hiddenFields['KA3l4V5NDWu'] = true;
        hiddenFields['NpxDYjUFlKS'] = true;
        hiddenFields['sftyaTdwBKz'] = true;
        hiddenFields['bEXtDfYHP4B'] = true;
        hiddenFields['KexFaUmJpt5'] = true;
        hiddenFields['gcW6652C8Bt'] = true;
        hiddenFields['AccHyrWqhI0'] = true;
      }
      if (inputFieldId == 'gcW6652C8Bt' && value != 'true') {
        hiddenFields['bmJjZctbkhX'] = true;
        hiddenFields['HQdMUzgaIXr'] = true;
      }
      if (inputFieldId == 'blod3xZ2dPP' && value == '1') {
        dataObject['HKCv7lkLexo'] = 'true';
        hiddenFields['ubin7MjQ5OI'] = true;
        hiddenFields['JzlLk2tW4xh'] = false;
      }

      if (inputFieldId == 'sLyfb45aLkl') {
        if (value == '1') { // Yes
          hiddenFields.remove('P52dMXyK4eA');
        } else {            // No or empty
          hiddenFields['P52dMXyK4eA'] = true;
        }
      }

      if (inputFieldId == 'aRNGDZcwWmS' && value != "High (above 1,000 copies/ml)") {
        hiddenFields['tYN12Es3707'] = true;
      }

      if (inputFieldId == 'tYN12Es3707' && value != 'true') {
        hiddenFields['o1GBFscjs4y'] = true;
      }

      if (hivStatus!='Positive') {
        hiddenFields['BYZu8p33lzP'] = true;
        hiddenFields['KFCBwn7ypws'] = true;
        hiddenFields['Uv26fX0HQvO'] = false;

      }else{
        hiddenFields['Uv26fX0HQvO'] = true;
      }
      if(inputFieldId=='Uv26fX0HQvO' && value == 'Less than 3 months' || (inputFieldId=='Uv26fX0HQvO' && value == 'null') || (caregiverTestedForHiv == false) || (hivStatus =='Positive')) {
        hiddenSections['hivscreening'] = true;
      }

      if (inputFieldId == 'blod3xZ2dPP' && value != '1') {
        dataObject['HKCv7lkLexo'] = 'false';
        hiddenFields['ubin7MjQ5OI'] = true;
        hiddenFields['HKCv7lkLexo'] = true;
        hiddenFields['JzlLk2tW4xh'] = true;
      }
      if (inputFieldId == 'dE3bwyB7guF' && value != '1') {

        hiddenFields['w6xeZ47TwwI'] = true;
      }

      if (inputFieldId == 'NdvnM08tekD' && value != '1') {

        hiddenFields['sVpDAdtsGR6'] = true;
      }

      if (inputFieldId == 'eAVGC2zqUjP' && value != '1') {

        hiddenFields['ir5Pzw7MyIT'] = true;
      }

      if (inputFieldId == 'ehtYoYKxATO' && value != '1') {

        hiddenFields['crEW7U1Tbqg'] = true;
      }

      if (inputFieldId == 'z9StVriYu0Q' && value != '1') {

        hiddenFields['kn1dKAwP5wD'] = true;
      }

      if (inputFieldId == 'HQdMUzgaIXr' && value != '1') {

        hiddenFields['mH9DgJoa0nT'] = true;
      }

      if (sex != 'Female'){
        hiddenFields['pJ1UrnLU9mh'] = true; // Pregnant
        hiddenFields['dCIDHw3RrQ9'] = true; // Breastfeeding

      }

      if (caregiverTestedForHiv != true){
        hiddenFields['Uv26fX0HQvO'] = true;
        hiddenFields['vNeOE9abQBB'] = true;
        hiddenFields['Icgkv0xkUow'] = true;
        hiddenFields['sLyfb45aLkl'] = true;
        print(' Na o kila hlahloba: $caregiverTestedForHiv');
        print('Perffrom HIV screening');
      }

      if (artInitiationDate != null) {
        final now = DateTime.now();
        final sixMonthsFromNow = DateTime(now.year, now.month - 6, now.day);

        // Check if ART start date is before six months from now
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
         // hiddenFields['T4grVrCVDkk'] = true;
          dataObject[inputFieldId] = 'false';
        }
      }
      if (inputFieldId == 'blod3xZ2dPP' && value != '1') {
        hiddenFields['ubin7MjQ5OI'] = true;
      }
      if (inputFieldId == 'Icb6vUJXVDX' && value != 'Other') {
        hiddenFields['IiKxc53TdqL'] = true;
      }
      if (inputFieldId == 'HLPSkYfLYlS' && value != 'true') {
        hiddenFields['I3hI2UTkKyx'] = true;
      }
      if (inputFieldId == 'loGTnsw9R9G' && value != 'true') {
        hiddenFields['dfdeOt1y7me'] = true;
      }
      if (inputFieldId == 'X094f7yANdc' && value != 'true') {
        hiddenFields['J8gzZEMnQLX'] = true;
        hiddenFields['uznwDGvHcie'] = true;
      }
      if (inputFieldId == 'ajrDVp6cI2k' && value != 'true') {
        hiddenFields['hiRnasaeK9H'] = true;
      }
      if (inputFieldId == 'RxvDeJX3b3k' && value != 'true') {
        hiddenFields['E4UFvIBBEDk'] = true;
        hiddenFields['RWcOcPqBnFj'] = true;
        hiddenFields['zWpm4lCpRxbR'] = true;
      }
      if (inputFieldId == 'E4UFvIBBEDk' && value != 'Others') {
        hiddenFields['RWcOcPqBnFj'] = true;
      }

      if (inputFieldId == 'T4grVrCVDkk') {
        if (hivStatus != null) {
          dataObject[inputFieldId] = "true";

        } else {
          hiddenFields['vNeOE9abQBB'] = true;
        }
      }




      if (inputFieldId == 'vNeOE9abQBB') {
        if (hivStatus != null) {
          dataObject[inputFieldId] = hivStatus;

          if (dataObject[inputFieldId] != 'Positive') {
            hiddenFields['sLyfb45aLkl'] = true;
            hiddenFields['ubin7MjQ5OI'] = true;
            hiddenFields['Icgkv0xkUow'] = true;
          }
        }
      }

      if (inputFieldId == 'Icgkv0xkUow') {
        if (artStatus != null) {
         // print('ART satatus at Assessment== $artStatus');
         //  print('Boelng: $sex');
         //  print(' Na o kila hlahloba: $caregiverTestedForHiv');
         // print(' Date: $artInitiationDate');
          dataObject[inputFieldId] = artStatus;
        }
      }


      if (inputFieldId == 'UffKzmI4698' && value != 'true') {
        hiddenFields['Icgkv0xkUow'] = true;
        hiddenFields['ubin7MjQ5OI'] = true;
      }

      if (inputFieldId == 'vNeOE9abQBB') {
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

      if (inputFieldId == 'vNeOE9abQBB') {
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


      // if (inputFieldId == 'BvNaiaoxc6w') {
      //   // Grab value from registration
      //   final bool? caregiverEverTested = dataObject['BvNaiaoxc6w'] as bool?;
      //
      //   if (caregiverEverTested != null) {
      //     dataObject[inputFieldId] = caregiverEverTested;
      //
      //     // If false (No), hide fields
      //     if (caregiverEverTested == false) {
      //       hiddenFields['Icgkv0xkUow'] = true; // Hide ART question
      //       hiddenFields['ubin7MjQ5OI'] = true; // Hide ART duration question
      //     }
      //   }
      //
      // }



      if (inputFieldId == 'Js9auywpL0O' && value != 'true') {
        hiddenFields['SQUodtvxYLs'] = true;
      }

      if (inputFieldId == 'WYUkGeSWaZY' && value != 'true') {
        hiddenFields['dE3bwyB7guF'] = true;
      }

      if (inputFieldId == 'KA3l4V5NDWu' && value != 'true') {
        hiddenFields['NdvnM08tekD'] = true;
      }

      if (inputFieldId == 'NpxDYjUFlKS' && value != 'true') {
        hiddenFields['eAVGC2zqUjP'] = true;
      }

      if (inputFieldId == 'sftyaTdwBKz' && value != 'true') {
        hiddenFields['ehtYoYKxATO'] = true;
      }

      if (inputFieldId == 'bEXtDfYHP4B' && value != 'true') {
        hiddenFields['z9StVriYu0Q'] = true;
      }

      if (inputFieldId == 'gcW6652C8Bt' && value != 'true') {
        hiddenFields['bmJjZctbkhX'] = true;
      }

      if (inputFieldId == 'bmJjZctbkhX' && (value == null || value.isEmpty)) {
        hiddenFields['HQdMUzgaIXr'] = true;
      }

      if (inputFieldId == 'cqusz74t5OH' && value != 'true') {
        hiddenFields['ZuCnNb9G6EM'] = true;
      }

      if (inputFieldId == 'sLyfb45aLkl' && value != '1') {
        hiddenFields['aRNGDZcwWmS'] = true;
      }
      if (inputFieldId == 'BYZu8p33lzP' && value != 'Yes') {
        hiddenFields['ToWhhydys'] = true;
      }
      if (inputFieldId == 'SLajij5j1KI' && value != 'Yes') {
        hiddenFields['RxvDeJX3b3k'] = true;
        hiddenFields['E4UFvIBBEDk'] = true;
      }
      if (inputFieldId == 'RxvDeJX3b3k' && value != 'true') {
        hiddenFields['E4UFvIBBEDk'] = true;
      }
      if (inputFieldId == 'doJJzw4NX8m' && value == 'true') {
        hiddenFields['doJJzw4NX8m_checkbox'] = true;
      }
      if (inputFieldId == 'LGrG9fGZfXP' && value == 'true') {
        hiddenFields['ZuaV20IvVV2'] = true;
      }
      if (inputFieldId == 'ZuaV20IvVV2') {
        Map hiddenOptions = {};
        if (value == 'Regular') {
          hiddenOptions['Sometimes a month'] = true;
          hiddenOptions['Once a week'] = true;
          hiddenOptions['During some seasons'] = true;
        } else if (value == 'Irregular') {
          hiddenOptions['Daily'] = true;
          hiddenOptions['Fulltime'] = true;
        } else {
          hiddenFields['kCuxe1Psh8E'] = true;
          hiddenFields['lnFXCB5NcYk'] = true;
        }
        hiddenInputFieldOptions['kCuxe1Psh8E'] = hiddenOptions;
      }
      if (inputFieldId == 'kCuxe1Psh8E' && value != 'Other') {
        hiddenFields['lnFXCB5NcYk'] = true;
      }
      if (inputFieldId == 'JmLdZM3XYfY' && value == 'No') {
        hiddenFields['JmLdZM3XYfY_checkbox'] = true;
      }
      if (inputFieldId == 'blod3xZ2dPP' && value != '0') {
        hiddenFields['eShHDoV4ARm'] = true;
      }

      if (inputFieldId == 'iXf2St64o0a' && value == 'true') {
        hiddenFields['JcaEaDrtOFj'] = true;
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
