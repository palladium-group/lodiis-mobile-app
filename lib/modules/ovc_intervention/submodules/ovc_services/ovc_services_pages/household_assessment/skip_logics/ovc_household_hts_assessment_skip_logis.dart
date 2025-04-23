import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:provider/provider.dart';

import '../pages/ovc_household_hts_screening_form.dart';

class OvchouseHoldHtsAssessmentSkipLogic {
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
      if (inputFieldId == 'BvNaiaoxc6w' && value != 'true') {
        hiddenFields['Uv26fX0HQvO'] = true;
        hiddenFields['T4grVrCVDkk'] = true;
        hiddenFields['blod3xZ2dPP'] = true;
        hiddenFields['ubin7MjQ5OI'] = true;
        hiddenFields['QagndU441C1'] = true;
        hiddenFields['dtUOh1TfESL'] = true;
        hiddenFields['qoKPxEkgfdh'] = true;
        hiddenFields['NGZH2JYy86L'] = true;
        hiddenFields['vNeOE9abQBB'] = true;
      }
      if (inputFieldId == 'Uv26fX0HQvO' && value == '7-12 months ago' || value == 'Above 12 months ago') {
        hiddenFields['T4grVrCVDkk'] = true;
        hiddenFields['blod3xZ2dPP'] = true;
        hiddenFields['ubin7MjQ5OI'] = true;
        hiddenFields['QagndU441C1'] = true;
        hiddenFields['dtUOh1TfESL'] = true;
        hiddenFields['qoKPxEkgfdh'] = true;
        hiddenFields['NGZH2JYy86L'] = true;
        hiddenFields['vNeOE9abQBB'] = true;
      }

      if (inputFieldId == 'T4grVrCVDkk' && value != 'true') {
        hiddenFields['blod3xZ2dPP'] = true;
        hiddenFields['ubin7MjQ5OI'] = true;
        hiddenFields['QagndU441C1'] = true;
        hiddenFields['dtUOh1TfESL'] = true;
        hiddenFields['qoKPxEkgfdh'] = true;
        hiddenFields['NGZH2JYy86L'] = true;
        hiddenFields['vNeOE9abQBB'] = true;
      }

      if (inputFieldId == 'vNeOE9abQBB' && value != 'Positive') {
        hiddenFields['blod3xZ2dPP'] = true;
        hiddenFields['ubin7MjQ5OI'] = true;

      }else if(inputFieldId == 'vNeOE9abQBB' && value == 'Positive'){
        hiddenFields['dtUOh1TfESL'] = true;
        hiddenFields['qoKPxEkgfdh'] = true;
        hiddenFields['NGZH2JYy86L'] = true;
        hiddenFields['QagndU441C1'] = true;
      }
      if (inputFieldId == 'blod3xZ2dPP' && value != '1') {
        hiddenFields['ubin7MjQ5OI'] = true;


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

