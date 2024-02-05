import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class NoneAgywEnrollmentPrepScreening {
  static List<String> getCheckboxInputFieldOptions(
      List<FormSection> formSections) {
    List<String> inputFieldOptions = [];
    for (FormSection section in formSections) {
      for (InputField field in section.inputFields!) {
        if (field.valueType == 'CHECK_BOX') {
          for (InputFieldOption option in field.options!) {
            inputFieldOptions.add(option.code);
          }
        }
      }
    }
    return inputFieldOptions;
  }

  static List<String> getMandatoryField() {
    const excludedFields = ['fchWv2MSmaS', 'heT7TrQQAA1', 'zGAjwEL0yL5'];
    List<String> inputFields = FormUtil.getFormFieldIds(getFormSections());
    List<String> optionalFields =
        getCheckboxInputFieldOptions(getFormSections());
    inputFields = inputFields
        .where((field) => !optionalFields.contains(field))
        .toList()
        .where((field) => !excludedFields.contains(field))
        .toList();
    return inputFields;
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: 'PrEP Screening for Substantial Risk and Eligibility',
          color: const Color(0xFF737373),
          subSections: [
            FormSection(
                name: 'Facility Information',
                color: const Color(0xFF258DCC),
                inputFields: [
                  InputField(
                      id: 'YDxOvZTdzAc',
                      name: 'Facility Name',
                      valueType: 'ORGANISATION_UNIT',
                      inputColor: const Color(0xFF258DCC),
                      allowedSelectedLevels: [
                        AppHierarchyReference.facilityLevel
                      ],
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'yuOiCMwlOlb',
                      name: 'Entry point /Reason for visiting facility',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'w16L3KidzUp',
                      allowFuturePeriod: true,
                      name: 'Date of initial client visit',
                      valueType: 'DATE',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                ]),
            FormSection(
                name: 'Recent Exposure to HIV.  Ask, “In the last 30 days',
                color: const Color(0xFF258DCC),
                inputFields: [
                  InputField(
                      id: 'HIsG7OjQfqo',
                      name:
                          'Have you had sex without a condom with someone living with HIV who is not on treatment',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code: 'Yes', name: 'Yes', translatedName: 'E'),
                        InputFieldOption(
                            code: 'No', name: 'No', translatedName: 'Che'),
                        InputFieldOption(
                            code: 'Don\'t Know', name: 'Don\'t Know')
                      ]),
                ]),
            FormSection(
                name: 'Assessment for acute HIV syndrome',
                color: const Color(0xFF258DCC),
                inputFields: [
                  InputField(
                      id: 'wg43kJ09Up5',
                      name:
                          'Have you had condom-less sex or other high risk HIV exposure in the past 2 – 6 weeks',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code: 'Yes', name: 'Yes', translatedName: 'E'),
                        InputFieldOption(
                            code: 'No', name: 'No', translatedName: 'Che'),
                        InputFieldOption(
                            code: 'Don\'t Know', name: 'Don\'t Know')
                      ]),
                  InputField(
                      id: 'DCXxIRxPse3',
                      name:
                          'Have you had a “cold” or “flu”, runny nose, fatigue, malaise, headache, sore throat, mouth sores, lymphadenopathy, skin rash, myalgia( muscle pain), arthralgia(joint pain)?',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code: 'Yes', name: 'Yes', translatedName: 'E'),
                        InputFieldOption(
                            code: 'No', name: 'No', translatedName: 'Che'),
                        InputFieldOption(
                            code: 'Don\'t Know', name: 'Don\'t Know')
                      ]),
                ]),
            FormSection(
                name: 'Contraindications for PrEP',
                description:
                    'If any of the contraindications are present do not offer PrEP',
                color: const Color(0xFF258DCC),
                inputFields: [
                  InputField(
                      id: 'Ufy2ZT9yphQ',
                      name:
                          'Is the client currently taking nephrotoxic drugs. Refer to creatinine clearance job aid for list of nephrotoxic drugs. Consult doctor about alternative medication/management before initiating PrEP?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'nLLHqOGTQK9',
                      name: 'Has creatinine clearance (eGFR) <60 ml/min',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'sa81lAvBb7Y',
                      name: 'Weight below 35kg',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'wJ0ctEtFyzS',
                      name:
                          'Allergy or contraindication to any medicine in the PrEP regimen',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                ]),
            FormSection(
                name: 'PrEP Eligibility',
                description:
                    'Clients are eligible if they fulfill ALL the criteria below:',
                color: const Color(0xFF258DCC),
                inputFields: [
                  InputField(
                      id: 'dQBja8nUr18',
                      name: 'HIV-negative',
                      valueType: 'BOOLEAN',
                      isReadOnly: true,
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'ACcf4Jyy30c',
                      name: 'At substantial risk of HIV',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'wNIvEyH95EU',
                      name: 'Has no signs/symptoms of acute HIV infection',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'z7eAqo0LMqi',
                      name:
                          'Has creatinine clearance (eGFR) >60 ml/min or patient has no risk factors for renal disease and the creatinine result is pending (see Creatinine clearance job aid for risk factors)',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                ]),
            FormSection(
                name: '',
                description: 'Question prompts for providers:',
                color: const Color(0xFF258DCC),
                inputFields: [
                  InputField(
                      id: 'oZPPEMZ0hXt',
                      name: 'Date tested',
                      valueType: 'DATE',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373),
                      isReadOnly: false),
                  InputField(
                      id: 'uBJeTLcoAKM',
                      name: 'Type of test used',
                      translatedName: 'Mofuta oa Tlhahlobo',
                      options: [
                        InputFieldOption(code: 'Determine', name: 'Determine'),
                        InputFieldOption(code: 'Unigold', name: 'Unigold'),
                        InputFieldOption(code: 'Elisa', name: 'Elisa'),
                        InputFieldOption(code: 'Other', name: 'Other')
                      ],
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'OLaa0ZiGMVu',
                      name: 'Other type of test used',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'zGAjwEL0yL5',
                      name: 'eGFR Result',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'fufd2D8sYc3',
                      name: 'Date of eGFR results',
                      valueType: 'DATE',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'fchWv2MSmaS',
                      name: 'Creatinine clearance (calculated)',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'heT7TrQQAA1',
                      name: 'Date Creatinine clearance (calculated)',
                      valueType: 'DATE',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373))
                ]),
            FormSection(
                name: 'Services Received by Client',
                color: const Color(0xFF258DCC),
                inputFields: [
                  InputField(
                      id: 'mdpVjiigyEe',
                      name: 'PrEP initiated',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'QTHDGaiEgMk',
                      name: 'Initiated on PEP',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'wSnrfl8u3Kw',
                      name: 'To start PrEP after completing PEP',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'pcS3AkmRGnq',
                      name:
                          'PCR/HIV Ag test or follow-up HIV re-testing (if suspicion of acute HIV infection)',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'ycrnvO8Am4c',
                      name: 'Client declined PrEP',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'eOy1XwiYC8H',
                      name: 'Referred for PrEP at another facility',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'X2m9v2E5WaI',
                      name: 'Name of facility PrEP referred',
                      allowedSelectedLevels: [
                        AppHierarchyReference.facilityLevel
                      ],
                      valueType: 'ORGANISATION_UNIT',
                      inputColor: const Color(0xFF258DCC),
                      labelColor: const Color(0xFF737373)),
                ]),
          ]),
    ];
  }
}
