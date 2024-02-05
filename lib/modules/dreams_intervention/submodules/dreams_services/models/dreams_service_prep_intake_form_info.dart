import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class DreamsServicePrepIntakeInfo {
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
    const excludedFields = [
      'UL0xa3Sz9ML',
      'de4zcWiZB5j',
      'XfB60ruQI3I',
      'W8LTmGz13QM',
      'Ihu2PjZMh8B'
    ];
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
          id: 'PeSfSRaE',
          name: '1. Facility Information',
          color: const Color(0xFF1F8ECE),
          inputFields: [
            InputField(
                id: 'BrcTtRhrxXp',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
                name: 'Facility Name',
                showCountryLevelTree: true,
                valueType: 'ORGANISATION_UNIT'),
            InputField(
                id: 'uHrSSJghmTS',
                name: 'Entry point /Reason for visiting facility',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT'),
            InputField(
              id: 'rprU5DII5Aw',
              allowFuturePeriod: true,
              name: 'Date of initial client visit',
              valueType: 'DATE',
              inputColor: const Color(0xFF1F8ECE),
              labelColor: const Color(0xFF737373),
            ),
          ]),
      FormSection(
          id: 'PeSfSRaE',
          name: '3. Client Demographics',
          color: const Color(0xFF1F8ECE),
          inputFields: [
            InputField(
                id: 'kK8Gt6LA8QM',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Current gender',
                options: [
                  InputFieldOption(
                      code: 'Male', name: 'Male', translatedName: 'Botona'),
                  InputFieldOption(
                      code: 'Female',
                      name: 'Female',
                      translatedName: "Bots'ehali"),
                  InputFieldOption(
                      code: 'Transgender (male to female)',
                      name: 'Transgender (male to female)'),
                  InputFieldOption(
                      code: 'Transgender (female to male)',
                      name: 'Transgender (female to male)'),
                  InputFieldOption(code: 'Other', name: 'Other')
                ],
                valueType: 'TEXT'),
            InputField(
                id: 'gufQ1ELVqcS',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Other current gender',
                valueType: 'TEXT'),
            InputField(
                id: 'gCvMVscBNfk',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Weight',
                suffixLabel: 'Kg',
                valueType: 'NUMBER'),
            InputField(
                id: 'WeaVsrFcWne',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Blood Pressure Systolic (mmHg)',
                suffixLabel: 'mmHg',
                valueType: 'NUMBER'),
            InputField(
                id: 'RqWMrqUcDqv',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Blood Pressure Diastolic (mmHg)',
                suffixLabel: 'mmHg',
                valueType: 'NUMBER'),
            InputField(
                id: 'd3zHELPzSaH',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Temperature',
                valueType: 'TEXT'),
          ]),
      FormSection(
          id: 'PeSfSRaE',
          name: '4. Recent Exposure to HIV. Ask, "In the last 30 days"...',
          color: const Color(0xFF1F8ECE),
          inputFields: [
            InputField(
                id: 'YQI32r1MQxA',
                description:
                    '*If ONLY reporting sex without a condom, consider post-exposure prophylaxis (PEP). Refer to ART guidelines for management.',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: "Don't Know",
                      name: "Don't Know",
                      translatedName: 'Ha ke tsebe'),
                ],
                name:
                    'Have you had sex without a condom with someone living with HIV who is not on treatment',
                valueType: 'TEXT'),
          ]),
      FormSection(
          id: 'PeSfSRaE',
          name: '5. Assessment for acute HIV syndrome',
          color: const Color(0xFF1F8ECE),
          inputFields: [
            InputField(
                id: 'pQaAQdJnE1w',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: "Don't Know",
                      name: "Don't Know",
                      translatedName: 'Ha ke tsebe'),
                ],
                name:
                    'Have you had condom-less sex or other high risk HIV exposure in the past 2  6 weeks',
                valueType: 'TEXT'),
            InputField(
                id: 'DobfAIMBOvy',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                description:
                    'If reporting sex without a condom in the past 2 to 6 weeks and  has flu-like symptoms, an acute HIV infection might be suspected and further investigation is required; \n DO NOT offer PrEP or PEP and conduct further HIV testingIf a more sensitive test e.g. \n DNA PCR is available with results available within 2 weeks conduct the more sensitive test.If more sensitive test e.g. \n DNA PCR is not available, ask the client to come back after 4 weeks for repeat rapid HIV test.',
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: "Don't Know",
                      name: "Don't Know",
                      translatedName: 'Ha ke tsebe'),
                ],
                name:
                    'Have you had a cold or flu, runny nose, fatigue, malaise, headache, sore throat, mouth sores, lymphadenopathy, skin rash, myalgia( muscle pain), arthralgia(joint pain)',
                valueType: 'TEXT'),
          ]),
      FormSection(
          id: 'PeSfSRaE',
          name:
              '6. Contraindications for PrEP. If any of the contraindications are present do not offer PrEP',
          color: const Color(0xFF1F8ECE),
          inputFields: [
            InputField(
                id: 'jpbLNWRjUJK',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name:
                    'Is the client currently taking nephrotoxic drugs. Refer to creatinine clearance job aid for list of nephrotoxic drugs. Consult doctor about alternative medication/management before initiating PrEP',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'bH9DpJOIutM',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Has creatinine clearance (eGFR) <60 ml/min',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'h0P6UfkUvLP',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Weight below 35kg',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'POaEWdS7Lw5',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name:
                    'Allergy or contraindication to any medicine in the PrEP regimen',
                valueType: 'BOOLEAN'),
          ]),
      FormSection(
          id: 'PeSfSRaE',
          name: '7. PrEP Eligibility',
          description: 'If all answers in this section are yes, offer PrEP.',
          color: const Color(0xFF1F8ECE),
          inputFields: [
            InputField(
                id: 'veoA322323t',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'HIV-negative',
                isReadOnly: true,
                valueType: 'BOOLEAN'),
            InputField(
                id: 'vMR9VtzuH3R',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Date tested',
                valueType: 'DATE'),
            InputField(
                id: 'qgNIIJBeMBT',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Type of test used',
                translatedName: 'Mofuta oa Tlhahlobo',
                options: [
                  InputFieldOption(code: 'Determine', name: 'Determine'),
                  InputFieldOption(code: 'Unigold', name: 'Unigold'),
                  InputFieldOption(code: 'Elisa', name: 'Elisa'),
                  InputFieldOption(code: 'Other', name: 'Other')
                ],
                valueType: 'TEXT'),
            InputField(
                id: 'gDlQ3IThgzH',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Other type of test used',
                valueType: 'TEXT'),
            InputField(
                id: 'AkuZ9MSPfZ4',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'At substantial risk of HIV',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'qibwngZ6fd5',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Has no signs/symptoms of acute HIV infection',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'JBmwR9pBO4I',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name:
                    'Has creatinine clearance (eGFR) >60 ml/min or patient has no risk factors for renal disease and the creatinine result is pending (see Creatinine clearance job aid for risk factors)',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'Ihu2PjZMh8B',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'eGFR Result',
                valueType: 'TEXT'),
            InputField(
                id: 'W8LTmGz13QM',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Creatinine clearance (calculated)',
                valueType: 'TEXT'),
            InputField(
                id: 'XfB60ruQI3I',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Date Creatinine clearance (calculated)',
                valueType: 'DATE'),
          ]),
      FormSection(
          id: 'PeSfSRaE',
          name: '8. Services Received by Client',
          color: const Color(0xFF1F8ECE),
          inputFields: [
            InputField(
                id: 'D0tq5I6jgLk',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'PrEP initiated',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'q9dpokR3G1q',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Initiated on PEP',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'rZov68n0pzv',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'To start PrEP after completing PEP',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'kqDlnMhTKTd',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name:
                    'PCR/HIV Ag test or follow-up HIV re-testing (if suspicion of acute HIV infection)',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'B8jihEQnoJG',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Client declined PrEP',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'ov7UEdiyjJA',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Referred for PrEP at another facility',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'dpfubDzhwhX',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                name: 'Name of facility PrEP referred',
                allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
                showCountryLevelTree: true,
                valueType: 'ORGANISATION_UNIT'),
          ]),
    ];
  }
}
