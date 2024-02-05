import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/constants/pp_prev_gender_norms_session_constants.dart';
import 'package:provider/provider.dart';

class PpPrevGenderNormsFormSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};

  static const String sessionNumberInputField = 'vL6NpUA0rIU';

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
      // add logic per input field id here
      print(inputFieldId);
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

  static bool evaluateSkipLogicBySessionReoccurrence(
    Map dataObject,
    String serviceField,
  ) {
    Map sessionsPerInterventions = dataObject['interventionSessions'];

    String sessionNumber = dataObject[sessionNumberInputField] ?? '';

    String service = dataObject[serviceField] ?? '';

    List interventionSessions = sessionsPerInterventions[service] ?? [];

    return serviceField.isEmpty || interventionSessions.isEmpty
        ? false
        : interventionSessions.contains(sessionNumber.toUpperCase());
  }

  static bool evaluateSkipLogicBySessions(
    Map dataObject,
    String serviceField,
  ) {
    String interventionType = dataObject[serviceField] ?? '';
    String sessionNumber = dataObject[sessionNumberInputField] ?? '';

    List sessionMapping =
        PpPrevGenderNormsSessionConstants.sessionMapping[interventionType] ??
            [];

    return sessionNumber.isEmpty || sessionMapping.isEmpty
        ? true
        : sessionMapping.contains(sessionNumber.toUpperCase());
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
    Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
      inputFieldId,
      value,
      isChangesBasedOnSkipLogic: true,
    );
  }
}
