import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class OvcExitCaseTransfer {
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
        formSectionLabel: 'Case Transfer Info',
        inputFieldLabel: 'Case Transfer On',
        firstDate: firstDate,
      ),
      FormSection(
        name: '',
        color: const Color(0xFF1B3519),
        inputFields: [
          InputField(
            id: 'Uou4yDFVQcH',
            allowFuturePeriod: true,
            name: 'Case Transfer Location',
            allowedSelectedLevels: [
              AppHierarchyReference.communityLevel,
              AppHierarchyReference.facilityLevel
            ],
            valueType: 'ORGANISATION_UNIT',
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
          name: 'Case Transfer Plan',
          color: const Color(0xFF1B3519),
          inputFields: [
            InputField(
                id: 'WDIkYamF6kL',
                allowFuturePeriod: true,
                name: 'Planned date of transfer',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'sdGKgJDFT4Z',
                name: 'Reason for transfer',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'crjoWZ2IV7q',
                name: 'Organization transferring case',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'DwAAgBlK1GX',
                name:
                    'Contact information for transferring Case Manager/Case Management worker',
                valueType: 'PHONE_NUMBER',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Ef9R8Wk6soU',
                name: 'Organization receiving the transfer',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'vfmEe7lWUu6',
                name: 'Household strengths and assets',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'pJdppBm5qkO',
                name: 'Ongoing household needs',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'jSn5YKYPGG0',
                name: 'Services that will be provided by the new organization',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'jEQkVul9Gnv',
                name: 'Final assistance to be provided by transferring program',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'XEJYZzJJ5b6',
                allowFuturePeriod: true,
                name: 'Date of next follow up',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
          ])
    ];
  }
}
