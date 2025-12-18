import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

import '../../../../../core/constants/app_hierarchy_reference.dart';
import '../../../../../core/utils/form_util.dart';

class OvcHeiMonitoring {
  static List<String> getMandatoryFields() {
    return FormUtil.getAllFormSectionInpiutFields(
      getFormSections(
          enrollmentDate:''
      ),
    );
  }

  static List<FormSection> getFormSections({
    required String enrollmentDate,
  }) {
    return [
      AppUtil.getServiceProvisionEventDateSection(
        inputColor: const Color(0xFF4A9F46),
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: const Color(0xFF4A9F46),
        formSectionLabel: 'HEI Monitoring Date',
        inputFieldLabel: 'HEI Monitoring On',
        firstDate: enrollmentDate,
      ),
      FormSection(
          name: 'CHILD HEI CARD',
          translatedName: 'TSA SEKOLO',
          color: const Color(0xFF4A9F46),
          borderColor: const Color(0xFF4A9F46),
          inputFields: [
            InputField(
              id: 'BrcTtRhrxXp',
              name:
              'Facility Name',
              translatedName:
              'U tsamaea tleleniking efe ho fumana litšebeletso tsa bokhachane?',
              valueType: 'ORGANISATION_UNIT',
              allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
              inputColor: const Color(0xFF4B9F46),
              showCountryLevelTree: true,
              labelColor: const Color(0xFF1A3518),
            ),

            InputField(
                id: 'sV0jiFD5JQm',
                name: 'Current VL results of Biological Mother',
                translatedName: 'Sephetho sa tlhahlobo eo ea mali se ne se reng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'High (above 1,000 copies/ml)',
                      name: 'High (above 1,000 copies/ml)',
                      translatedName: 'E holimo'),
                  InputFieldOption(
                      code: 'Low (51-999 copies/ml)',
                      name: 'Low (51-999 copies/ml)',
                      translatedName: 'E tlase'),
                  InputFieldOption(
                      code: 'Undetectable (0-50 copies/ml)',
                      name: 'Undetectable (0-50 copies/ml)',
                      translatedName: 'Ha e bonahale'),
                  InputFieldOption(
                      code: 'Not documented',
                      name: 'Not documented',
                      translatedName: 'Ha a tsebe'),
                ]),
            InputField(
                id: 'tTvZnqi89WL',
                name: 'Risk stratification',
                translatedName: 'Risk stratification',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'High',
                      name: 'High',
                      translatedName: 'High'),
                  InputFieldOption(
                      code: 'Low',
                      name: 'Low',
                      translatedName: 'Low'),
                ]),

            InputField(
                id: 'bOqcf7qGjXC',
                name: 'Prophylaxis given at birth',
                translatedName: 'Boemo ba hau ba HIV ke bofe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'AZT/NVP',
                      name: 'AZT/NVP',
                      translatedName: 'AZT/NVP'),
                  InputFieldOption(
                      code: 'NVP only',
                      name: 'NVP only',
                      translatedName: 'NVP only'),
                ]),

            InputField(
                id: 'YO4SQLWsD9M',
                name: 'EID Test at referral',
                translatedName: 'Boemo ba hau ba HIV ke bofe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'birth test',
                      name: 'birth test',
                      translatedName: 'birth test'),
                  InputFieldOption(
                      code: '6 weeks',
                      name: '6 weeks',
                      translatedName: '6 weeks'),
                  InputFieldOption(
                      code: '10 weeks',
                      name: '10 weeks',
                      translatedName: '10 weeks'),
                  InputFieldOption(
                      code: '9 months',
                      name: '9 months',
                      translatedName: '9 months'),
                  InputFieldOption(
                      code: '18 months',
                      name: '18 months',
                      translatedName: '18 months'),
                ]),

            InputField(
                id: 'BNWLmvSXCb2',
                name: 'EID Test Results',
                translatedName: 'Boemo ba hau ba HIV ke bofe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Positive',
                      name: 'Positive',
                      translatedName: 'Positive'),
                  InputFieldOption(
                      code: 'Negative',
                      name: 'Negative',
                      translatedName: 'Negative'),
                ]),
            InputField(
                id: 'aAEAbcD1mpC',
                name: 'Birth Test Done?',
                translatedName: 'Birth Test Done?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF1A3518)
            ),
            InputField(
                id: 'zhTX6aih7w0',
                name: 'Appointments',
                translatedName: 'Boemo ba hau ba HIV ke bofe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'birth test',
                      name: 'birth test',
                      translatedName: 'birth test'),
                  InputFieldOption(
                      code: '6 weeks',
                      name: '6 weeks',
                      translatedName: '6 weeks'),
                  InputFieldOption(
                      code: '10 weeks',
                      name: '10 weeks',
                      translatedName: '10 weeks'),
                  InputFieldOption(
                      code: '9 months',
                      name: '9 months',
                      translatedName: '9 months'),
                  InputFieldOption(
                      code: '18 months',
                      name: '18 months',
                      translatedName: '18 months'),
                ]),

            InputField(
                id: 'VzNqtfinj3B',
                name: 'Final Outcome (18 months) Test Done',
                translatedName: 'Boemo ba hau ba HIV ke bofe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: '1',
                      name: 'Yes',
                      translatedName: 'E'),
                  InputFieldOption(
                      code: '0',
                      name: 'No',
                      translatedName: 'Che'),
                  InputFieldOption(
                      code: '0.000001',
                      name: 'NA',
                      translatedName: 'NA'),

                ]),

          ])
    ];
  }
}
