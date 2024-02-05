import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:provider/provider.dart';

class ClhivArtCardServiceSkipLogics {
  static Map hiddenFields = {};
  static Map hiddenSections = {};

  static Future evaluateSkipLogics(
    BuildContext context,
    List<FormSection> formSections,
    Map dataObject,
  ) async {
    hiddenFields.clear();
    hiddenSections.clear();
    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }
    inputFieldIds = inputFieldIds.toSet().toList();

    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';

      if (inputFieldId == 'RIpmBgYc0ZN' && value != 'true') {
        hiddenFields['uVmlqLmHYpD'] = true;
        hiddenFields['JgNSiXuArwl'] = true;
        hiddenFields['wEKBn2SdrmA'] = true;
        hiddenFields['FLI5NLYCqH9'] = true;
        hiddenFields['LaeDyUWYcoN'] = true;
      } else if (inputFieldId == 'FLI5NLYCqH9') {
        if (value != 'true') {
          hiddenFields['IwM9O0a78QD'] = true;
          hiddenFields['WKdeD28Oyn7'] = true;
        }
        if (value != 'false') {
          hiddenFields['QkoJ1afnMMK'] = true;
        }
      } else if (inputFieldId == 'LaeDyUWYcoN') {
        if (value != '<3 Months') {
          hiddenFields['yWE2jEJxMdB'] = true;
        }
        if (value != 'Other (Specify)') {
          hiddenFields['YxJQ58njlLM'] = true;
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

  static assignInputFieldValue(
    BuildContext context,
    String inputFieldId,
    String? value,
  ) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(inputFieldId, value);
  }
}
