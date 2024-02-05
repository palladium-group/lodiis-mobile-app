import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcExitInformation {
  static List<String> getMandatoryFields() {
    return FormUtil.getAllFormSectionInpiutFields(
      getFormSections(
        firstDate: '',
      ),
    );
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      AppUtil.getServiceProvisionEventDateSection(
        inputColor: const Color(0xFF4A9F46),
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: const Color(0xFF0D3A16),
        formSectionLabel: 'Case Exit Date',
        inputFieldLabel: 'Case Exit On',
        firstDate: firstDate,
      ),
      FormSection(
          name: 'Exit information',
          color: const Color(0xFF0D3A16),
          inputFields: [
            InputField(
                id: 'iaVO2v6TsWa',
                name: 'What is a reason for exit?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF07AD40),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'Was Referred', name: 'Was Referred'),
                  InputFieldOption(
                      code: 'Was Disengaged', name: 'Was Disengaged'),
                  InputFieldOption(
                      code: 'Exit without graduation',
                      name: 'Exit without graduation'),
                  InputFieldOption(code: 'Left at will', name: 'Left at will'),
                  InputFieldOption(code: 'Dropped Out', name: 'Dropped Out'),
                  InputFieldOption(code: 'Died', name: 'Died'),
                  InputFieldOption(
                      code: 'Other reasons', name: 'Other reasons'),
                ]),
            InputField(
                id: 'zUU33n41Soa',
                name: 'Specify other reason for exit',
                valueType: 'TEXT',
                inputColor: const Color(0xFF07AD40),
                labelColor: const Color(0xFF737373)),
            InputField(
              id: 'vey0snuAsLj',
              name: 'Is referral required?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'jOXN2iPhkxj',
                name:
                    'What is a service provider/referred organization at facility?',
                valueType: 'ORGANISATION_UNIT',
                showCountryLevelTree: true,
                allowedSelectedLevels: [
                  AppHierarchyReference.communityLevel,
                  AppHierarchyReference.facilityLevel
                ],
                inputColor: const Color(0xFF07AD40),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'RtAQJcTqUGF',
                name: 'What is a reason for disengaged?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF07AD40),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Family Reintegration/Separation',
                      name: 'Family Reintegration/Separation'),
                  InputFieldOption(code: 'Adoption', name: 'Adoption'),
                  InputFieldOption(code: 'Ineligible', name: 'Ineligible'),
                  InputFieldOption(
                      code: 'Family Reconciliation',
                      name: 'Family Reconciliation'),
                  InputFieldOption(
                      code: 'Self Employed', name: 'Self Employed'),
                  InputFieldOption(code: 'Relocation', name: 'Relocation'),
                  InputFieldOption(code: 'Fostering', name: 'Fostering'),
                  InputFieldOption(
                      code: 'Over 18-20 years and out of school',
                      name: 'Over 18-20 years and out of school'),
                  InputFieldOption(code: 'Duplicated', name: 'Duplicated'),
                  InputFieldOption(
                      code: 'Other', name: 'Other', translatedName: 'Tse ling'),
                ]),
            InputField(
                id: 'q3mJ2FfV3oR',
                name: 'Specify other reason for disengaged',
                valueType: 'TEXT',
                inputColor: const Color(0xFF07AD40),
                labelColor: const Color(0xFF737373)),
          ])
    ];
  }
}
