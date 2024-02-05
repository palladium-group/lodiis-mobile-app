import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/constants/ovc_enrollment_child_form_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';
import 'package:provider/provider.dart';

class OvcChildEnrollmentSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};
  static Map hiddenInputFieldOptions = {};
  static Map assignedFields = {};

  static Map evaluateSkipLogics(
    BuildContext context,
    List<FormSection> formSections,
    Map dataObject, {
    bool shouldSetEnrollmentState = true,
    Map caregiverDataObject = const {},
  }) {
    hiddenFields.clear();
    hiddenSections.clear();
    hiddenInputFieldOptions.clear();
    assignedFields.clear();
    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }
    inputFieldIds = inputFieldIds.toSet().toList();

    var caregiverFirstName =
        caregiverDataObject[OvcInterventionConstant.firstName] ?? '';
    var caregiverMiddleName =
        caregiverDataObject[OvcInterventionConstant.middleName] ?? '';
    var caregiverDateOfBirth =
        caregiverDataObject[OvcInterventionConstant.dateOfBirth] ?? '';
    var caregiverSurname =
        caregiverDataObject[OvcInterventionConstant.surname] ?? '';
    var caregiverPhoneNumber =
        caregiverDataObject[OvcInterventionConstant.phoneNumber] ?? '';
    var caregiverVillage =
        caregiverDataObject[OvcInterventionConstant.phoneNumber] ?? '';
    var caregiverSubVillage =
        caregiverDataObject[OvcInterventionConstant.phoneNumber] ?? '';
    var caregiverHivStatus =
        caregiverDataObject[OvcInterventionConstant.hivStatus] ?? '';
    var caregiverArtStatus =
        caregiverDataObject[OvcInterventionConstant.artStatus] ?? '';
    var caregiverArtFacility =
        caregiverDataObject[OvcInterventionConstant.artFacility] ?? '';

    assignedFields[OvcEnrollmentChildConstant.village] = caregiverVillage;
    assignedFields[OvcEnrollmentChildConstant.subVillage] = caregiverSubVillage;

    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';
      if (inputFieldId == 'iS9mAp3jDaU') {
        if (value == 'Biological mother' || value == 'Biological father') {
          if (value == 'Biological mother') {
            assignedFields['R9e8v9r3lMM'] = 'Yes';
            assignedFields['d3HviODv676'] = caregiverFirstName;
            assignedFields['Zv8FOfjPZzm'] = caregiverMiddleName;
            assignedFields['FBdCMyESsdg'] = caregiverSurname;
            assignedFields['or2YNqJqVqZ'] = caregiverDateOfBirth;
            assignedFields['rP7oCRukLkq'] = caregiverPhoneNumber;
            assignedFields['nO38lKlKHYi'] = caregiverHivStatus;
            assignedFields['PAv1sKQn2hO'] = caregiverArtStatus;
            assignedFields['fa0BSFwqQGQ'] = caregiverArtFacility;
          } else if (value == 'Biological father') {
            assignedFields['cJl00w5DjIL'] = 'Yes';
            assignedFields['ZPf4iCd2aw3'] = caregiverFirstName;
            assignedFields['zKKeQ5pTCAd'] = caregiverMiddleName;
            assignedFields['JMwIgMSUnlu'] = caregiverSurname;
            assignedFields['PvLva3TSY9N'] = caregiverDateOfBirth;
            assignedFields['NzeeDnWJsNU'] = caregiverPhoneNumber;
            assignedFields['tbpqNLJotOi'] = caregiverHivStatus;
            assignedFields['xJfScNlfNS2'] = caregiverArtStatus;
            assignedFields['IWFLOoEtisa'] = caregiverArtFacility;
          }
        }
      } else if (inputFieldId == 'tNdoR0jYr7R') {
        if (caregiverPhoneNumber != 'N/A') {
          if (shouldSetEnrollmentState) {
            assignInputFieldValue(context, 'tNdoR0jYr7R', caregiverPhoneNumber);
          } else {
            assignedFields['tNdoR0jYr7R'] = caregiverPhoneNumber;
          }
        } else {
          hiddenFields['tNdoR0jYr7R'] = true;
        }
      } else if (inputFieldId == 'qZP982qpSPS') {
        int age = AppUtil.getAgeInYear(value);
        if (shouldSetEnrollmentState) {
          assignInputFieldValue(context, 'ls9hlz2tyol', age.toString());
        } else {
          assignedFields['ls9hlz2tyol'] = age.toString();
        }
        if (age > 2) {
          hiddenFields['GMcljM7jbNG'] = true;
        }
        if (age > 5) {
          hiddenFields['isPgJvbU8tT'] = true;
        }
      } else if (inputFieldId == 'nOgf8LKXS4k') {
        Map hiddenOptions = {};
        String relationShipToCaregiver = '${dataObject['iS9mAp3jDaU']}';
        if (relationShipToCaregiver == 'Biological mother') {
          hiddenOptions['Single Orphan(Mother)'] = true;
          hiddenOptions['Double Orphan'] = true;
        } else if (relationShipToCaregiver == 'Biological father') {
          hiddenOptions['Single Orphan(Father)'] = true;
          hiddenOptions['Double Orphan'] = true;
        }
        hiddenInputFieldOptions[inputFieldId] = hiddenOptions;

        if (dataObject['cJl00w5DjIL'] == 'Yes' &&
            dataObject['R9e8v9r3lMM'] == 'Yes') {
          hiddenOptions['Single Orphan(Father)'] = true;
          hiddenOptions['Single Orphan(Mother)'] = true;
          hiddenOptions['Double Orphan'] = true;
        }
        if (dataObject['cJl00w5DjIL'] == 'Yes') {
          hiddenOptions['Single Orphan(Father)'] = true;
          hiddenOptions['Double Orphan'] = true;
        }
        if (dataObject['R9e8v9r3lMM'] == 'Yes') {
          hiddenOptions['Single Orphan(Mother)'] = true;
          hiddenOptions['Double Orphan'] = true;
        }
      } else if (inputFieldId == 'UeF4OvjIIEK') {
        if (value.isEmpty || value.trim() != 'true') {
          hiddenFields['nOgf8LKXS4k'] = true;
        }
        if (dataObject['cJl00w5DjIL'] == 'No' ||
            dataObject['R9e8v9r3lMM'] == 'No') {
          dataObject[inputFieldId] = 'true';
          hiddenFields['nOgf8LKXS4k'] = false;
        } else if (dataObject['cJl00w5DjIL'] == 'Yes' &&
            dataObject['R9e8v9r3lMM'] == 'Yes') {
          dataObject[inputFieldId] = 'false';
          hiddenFields['nOgf8LKXS4k'] = true;
        }
      } else if (inputFieldId == 'wmKqYZML8GA' &&
          (value.isEmpty || value.trim() == 'true')) {
        hiddenFields['GMcljM7jbNG'] = true;
      } else if (inputFieldId == 'wmKqYZML8GA' &&
          (value.isEmpty || value.trim() == 'true')) {
        hiddenFields['GMcljM7jbNG'] = true;
      } else if (inputFieldId == 'Gkjp5XZD70V' &&
          (value.isEmpty || value.trim() != 'true')) {
        hiddenFields['Sa0KVprHUr7'] = true;
        hiddenFields['wtrZQadTkOL'] = true;
        hiddenFields['Mc3k3bSwXNe'] = true;
        hiddenFields['CePNVGSnj00'] = true;
        hiddenFields['GM2mJDlGZin'] = true;
      } else if (inputFieldId == 'GMcljM7jbNG') {
        int age =
            AppUtil.getAgeInYear('${dataObject["qZP982qpSPS"]}', ceil: true);
        if (age > 2) {
          hiddenFields[inputFieldId] = true;
        } else {
          var isOvcHIVExposedInfant = (age >= 0 && age <= 2) &&
              '${dataObject["nO38lKlKHYi"]}' == 'Positive';
          assignedFields[inputFieldId] = '$isOvcHIVExposedInfant';
        }
      } else if (inputFieldId == 'Mc3k3bSwXNe' &&
          (value.isEmpty || value.trim() != 'true')) {
        hiddenFields['CePNVGSnj00'] = true;
        hiddenFields['GM2mJDlGZin'] = true;
      } else if (inputFieldId == 'CePNVGSnj00' &&
          (value.isEmpty || value.trim() != 'Other')) {
        hiddenFields['GM2mJDlGZin'] = true;
      } else if (inputFieldId == 'YR7Xxk14qoP' && value != 'true') {
        hiddenFields['YR7Xxk14qoP_checkbox'] = true;
        List<String> checkBoxFieldIds = [
          'dufGxx0KVg0',
          'nfp9NHLf25K',
          'tbLVGG4zDrJ',
          'ULr0tYkjTTB',
          'BfbiOanp9Pi',
          'X3MQhmVA1Jt',
          'TPRVr4ua9f9'
        ];
        for (String id in checkBoxFieldIds) {
          hiddenFields[id] = true;
        }
      } else if (inputFieldId == 'omUPOnb4JVp' && value != 'true') {
        hiddenFields['WsmWkkFBiT6'] = true;
      } else if (inputFieldId == 'pJ5NAEmwnDq' && value != 'true') {
        hiddenFields['JPNe5w7zeki'] = true;
      } else if (inputFieldId == 'JTNxMQPT134' && value != 'true') {
        hiddenFields['iQdwzVfZdml'] = true;
        hiddenFields['EwZil0AnlYo'] = true;
        hiddenFields['f7WkgoF9uib'] = true;
        hiddenFields['h1HeZ2eEkGn'] = true;
        hiddenFields['NGVFqUVSHiU'] = true;
        hiddenFields['oioDyk1WK1j'] = true;
      } else if (inputFieldId == 'f7WkgoF9uib' && value != 'PrimaryLevel') {
        hiddenFields['h1HeZ2eEkGn'] = true;
      } else if (inputFieldId == 'f7WkgoF9uib' && value != 'SecondaryLevel') {
        hiddenFields['NGVFqUVSHiU'] = true;
      } else if (inputFieldId == 'f7WkgoF9uib' &&
          !(value == 'PrimaryLevel' || value == 'SecondaryLevel')) {
        hiddenFields['oioDyk1WK1j'] = true;
      } else if (inputFieldId == 'oSKX8fFQdWc') {
        assignedFields['wmKqYZML8GA'] = '${value == 'Positive'}';
        if (value != 'Positive') {
          hiddenFields['l7op0btSqSc'] = true;
        }
      } else if (inputFieldId == 'l7op0btSqSc' && value != 'true') {
        hiddenFields['iBws3HMjiUT'] = true;
        hiddenFields['aX0niP9AH6t'] = true;
        hiddenFields['EIMgHQW61kx'] = true;
      } else if (inputFieldId == 'tbpqNLJotOi' &&
          value != 'Positive' &&
          value != 'null') {
        hiddenFields['xJfScNlfNS2'] = true;
      } else if (inputFieldId == 'xJfScNlfNS2' &&
          value != 'true' &&
          value != 'null') {
        hiddenFields['IWFLOoEtisa'] = true;
      } else if (inputFieldId == 'cJl00w5DjIL') {
        if (value != 'No') {
          hiddenFields['wKEQZfKU2jX'] = true;
        }
        if (value == "Don't Know") {
          hiddenFields['ZPf4iCd2aw3'] = true;
          hiddenFields['zKKeQ5pTCAd'] = true;
          hiddenFields['JMwIgMSUnlu'] = true;
          hiddenFields['PvLva3TSY9N'] = true;
          hiddenFields['NzeeDnWJsNU'] = true;
          hiddenFields['wKEQZfKU2jX'] = true;
          hiddenFields['tbpqNLJotOi'] = true;
        }
      } else if (inputFieldId == 'nO38lKlKHYi' &&
          value != 'Positive' &&
          value != 'null') {
        hiddenFields['PAv1sKQn2hO'] = true;
      } else if (inputFieldId == 'PAv1sKQn2hO' &&
          value != 'true' &&
          value != 'null') {
        hiddenFields['fa0BSFwqQGQ'] = true;
      } else if (inputFieldId == 'R9e8v9r3lMM') {
        if (value != 'No') {
          hiddenFields['voFec8nlKRX'] = true;
        }
        if (value == "Don't Know") {
          hiddenFields['d3HviODv676'] = true;
          hiddenFields['Zv8FOfjPZzm'] = true;
          hiddenFields['FBdCMyESsdg'] = true;
          hiddenFields['or2YNqJqVqZ'] = true;
          hiddenFields['rP7oCRukLkq'] = true;
          hiddenFields['voFec8nlKRX'] = true;
          hiddenFields['nO38lKlKHYi'] = true;
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
    assignPrimaryVulnerability(context, dataObject, shouldSetEnrollmentState);
    if (shouldSetEnrollmentState) {
      setAssignedValues(context, assignedFields);
      resetValuesForHiddenFields(context, hiddenFields.keys);
      resetValuesForHiddenSections(context, formSections);
      resetValuesForHiddenInputFieldOptions(context, formSections);
    }
    return shouldSetEnrollmentState
        ? {}
        : {
            "assignedFields": assignedFields,
            "hiddenFields": hiddenFields,
            "hiddenInputFieldOptions": hiddenInputFieldOptions,
            "hiddenSections": hiddenSections,
          };
  }

  static assignPrimaryVulnerability(
    BuildContext context,
    Map dataObject,
    bool shouldSetEnrollmentState,
  ) {
    const String defaultVulnerability = 'Sibling';
    List<String> vulnerabilities = [
      'wmKqYZML8GA',
      'GMcljM7jbNG',
      'Gkjp5XZD70V',
      'ZKMhrjWoXnD',
      'br1xvwAQ6el',
      'UeF4OvjIIEK',
      'YR7Xxk14qoP'
    ];
    List<String> primaryVulnerabilitiesOptions = [
      'Child living with HIV',
      'HIV exposed infants',
      'Child exposed/experiencing violence and abuse (Survivors of Vac)',
      'Child of PLHIV',
      'Child of a sex worker (FSW)',
      'Orphan',
      'Child living with disability'
    ];
    for (var vulnerabilityKey in vulnerabilities) {
      if ('${dataObject[vulnerabilityKey]}' == 'true') {
        var vulnerabilityIndex = vulnerabilities.indexOf(vulnerabilityKey);
        String value = vulnerabilityIndex >= 0
            ? primaryVulnerabilitiesOptions[
                vulnerabilities.indexOf(vulnerabilityKey)]
            : defaultVulnerability;
        if (shouldSetEnrollmentState) {
          assignInputFieldValue(context,
              OvcEnrollmentChildConstant.primaryVulnerabilityKey, value);
        } else {
          assignedFields[OvcEnrollmentChildConstant.primaryVulnerabilityKey] =
              value;
        }
        break;
      } else {
        continue;
      }
    }
    if (vulnerabilities.every((element) =>
        (dataObject[element] == false || dataObject[element] == null))) {
      if (shouldSetEnrollmentState) {
        assignInputFieldValue(
            context,
            OvcEnrollmentChildConstant.primaryVulnerabilityKey,
            defaultVulnerability);
      } else {
        assignedFields[OvcEnrollmentChildConstant.primaryVulnerabilityKey] =
            defaultVulnerability;
      }
    }
  }

  static void setAssignedValues(BuildContext context, Map assignedValues) {
    assignedFields.forEach((key, value) {
      assignInputFieldValue(context, key, value);
    });
  }

  static resetValuesForHiddenFields(BuildContext context, inputFieldIds) {
    for (String inputFieldId in inputFieldIds) {
      if (hiddenFields[inputFieldId]) {
        assignInputFieldValue(context, inputFieldId, null);
      }
    }
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setHiddenFields(hiddenFields);
  }

  static resetValuesForHiddenSections(
    BuildContext context,
    List<FormSection> formSections,
  ) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setHiddenSections(hiddenSections);
  }

  static resetValuesForHiddenInputFieldOptions(
    BuildContext context,
    List<FormSection> formSections,
  ) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setHiddenInputFieldOptions(hiddenInputFieldOptions);
  }

  static assignInputFieldValue(
    BuildContext context,
    String inputFieldId,
    String? value,
  ) {
    Provider.of<EnrollmentFormState>(context, listen: false).setFormFieldState(
      inputFieldId,
      value,
      isChangesBasedOnSkipLogic: true,
    );
  }
}
