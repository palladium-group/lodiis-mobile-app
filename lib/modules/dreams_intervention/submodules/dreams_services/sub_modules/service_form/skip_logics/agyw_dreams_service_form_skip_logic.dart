import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/service_form/constants/agyw_dreams_service_form_sessions.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/service_form/constants/service_form_constant.dart';
import 'package:provider/provider.dart';

class AgywDreamsServiceFormSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};
  static Map hiddenInputFieldOptions = {};

  static Future evaluateSkipLogics(
      BuildContext context, List<FormSection> formSections, Map dataObject,
      {bool? isFormEdited, String? implementingPartner}) async {
    hiddenFields.clear();
    hiddenSections.clear();
    hiddenInputFieldOptions.clear();
    Map hiddenOptions = {};
    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }

    inputFieldIds = inputFieldIds.toSet().toList();
    // skip logic as per age
    int agywDreamAge = int.parse(dataObject['age']);

    if (agywDreamAge < 10 || agywDreamAge > 17) {
      hiddenOptions['AFLATEEN/TOUN'] = true;
      hiddenOptions['PARENTING'] = true;
      hiddenOptions['SAVING GROUP'] = true;
      hiddenOptions['VACLegalMessaging'] = true;
      hiddenOptions['EducationSubsidiesSupport'] = true;
    }
    if (agywDreamAge < 10 || agywDreamAge > 19) {
      hiddenOptions['LBSE'] = true;
    }
    if (agywDreamAge < 10 || agywDreamAge > 24) {
      hiddenOptions['FinancialLiteracyEducation'] = true;
      hiddenOptions['HIV Prevention Education'] = true;
      hiddenOptions['ViolencePreventionEducation'] = true;
    }
    if (agywDreamAge < 18) {
      hiddenOptions['Go Girls'] = true;
      hiddenOptions['SILC'] = true;
    }

    if (agywDreamAge < 18 || agywDreamAge > 24) {
      hiddenOptions['GBVLegalMessaging'] = true;
    }

    if (agywDreamAge < 15) {
      hiddenOptions['STEPPING STONES'] = true;
      hiddenOptions['CondomEducationProvision'] = true;
    }

    // skip logic as per implementing partner
    if (implementingPartner != 'Paralegal') {
      hiddenOptions['GBVLegalMessaging'] = true;
      hiddenOptions['VACLegalMessaging'] = true;
    } else {
      hiddenOptions['LBSE'] = true;
      hiddenOptions['FinancialLiteracyEducation'] = true;
      hiddenOptions['STEPPING STONES'] = true;
      hiddenOptions['CondomEducationProvision'] = true;
      hiddenOptions['Go Girls'] = true;
      hiddenOptions['SILC'] = true;
      hiddenOptions['AFLATEEN/TOUN'] = true;
      hiddenOptions['PARENTING'] = true;
      hiddenOptions['SAVING GROUP'] = true;
      hiddenOptions['HIV Prevention Education'] = true;
      hiddenOptions['ViolencePreventionEducation'] = true;
    }
    hiddenInputFieldOptions['Eug4BXDFLym'] = hiddenOptions;

    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';

      if (inputFieldId == 'Eug4BXDFLym') {
        if ([
          'FinancialLiteracyEducation',
          'SILC',
          'SAVING GROUP',
        ].contains(value)) {
          hiddenFields['FoLeDcnocv4'] = true;
          hiddenFields['JjX25d72ume'] = true;
          hiddenFields['qxO13pu8vAk'] = true;
        }
        if (value != 'PARENTING') {
          hiddenFields['JT7pbPBJkoF'] = true;
          hiddenFields['QATqUC6i5x2'] = true;
        }

        if (ServiceFormConstant.oneOffServices.contains(value)) {
          hiddenFields['vL6NpUA0rIU'] = true;
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
    resetValuesForHiddenInputFieldOptions(context, formSections);
  }

  static bool evaluateSkipLogicBySessionReoccurrence(Map dataObject) {
    String interventionType = dataObject['Eug4BXDFLym'] ?? '';
    Map sessionsPerInterventions = dataObject['interventionSessions'];
    String currentSession = '';
    currentSession = '${dataObject['vL6NpUA0rIU']}' != 'null'
        ? '${dataObject['vL6NpUA0rIU']}'
        : currentSession;

    List interventionSessions =
        sessionsPerInterventions[interventionType] ?? [];
    return interventionType != ''
        ? ServiceFormConstant.oneOffServices.contains(interventionType)
            ? interventionSessions.isNotEmpty
            : currentSession != '' &&
                interventionSessions.contains(currentSession.toLowerCase())
        : false;
  }

  static bool evaluateSkipLogicsBySession(Map dataObject) {
    const String sessionNumberInputField = 'vL6NpUA0rIU';
    const String typeOfIntervention = 'Eug4BXDFLym';

    String interventionType = dataObject[typeOfIntervention] ?? '';
    String sessionNumber = dataObject[sessionNumberInputField] ?? '';

    List sessionMapping =
        AgywDreamsServiceFormSessions.sessionMapping[interventionType] ?? [];

    return sessionNumber.isEmpty || sessionMapping.isEmpty
        ? true
        : sessionMapping.contains(sessionNumber.toLowerCase());
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
    List<FormSection> formSections,
  ) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenInputFieldOptions(hiddenInputFieldOptions);
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
