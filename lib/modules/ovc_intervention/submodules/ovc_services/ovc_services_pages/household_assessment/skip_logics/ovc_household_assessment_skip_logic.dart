import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:provider/provider.dart';

class OvchouseHoldAssessmentSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};
  static Map hiddenInputFieldOptions = {};

  static Future evaluateSkipLogics(BuildContext context,
      List<FormSection> formSections, Map dataObject, String? hivStatus) async {
    hiddenFields.clear();
    hiddenSections.clear();
    hiddenInputFieldOptions.clear();
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
      }
      if (inputFieldId == 'AccHyrWqhI0' && value != '1') {
        hiddenFields['w6xeZ47TwwI'] = true;
      }
      if (inputFieldId == 'BvNaiaoxc6w') {
        if (hivStatus != null) {
          dataObject[inputFieldId] = 'true';
        } else if (hivStatus == null) {
          hiddenFields['Uv26fX0HQvO'] = true;
          hiddenFields['T4grVrCVDkk'] = true;
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
            hiddenFields['blod3xZ2dPP'] = true;
            hiddenFields['ubin7MjQ5OI'] = true;
            hiddenFields['Icb6vUJXVDX'] = true;
          }
        }
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

      if (inputFieldId == 'Js9auywpL0O' && value != 'true') {
        hiddenFields['SQUodtvxYLs'] = true;
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
