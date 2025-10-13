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
                id: 'cTk9mxZZ2b6',
                name: 'Do you have current VL results for biological mother?',
                translatedName: 'Do you have current VL results for biological mother?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF1A3518)
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
                id: 'fuiWaufIUTs',
                name: 'Feeding Options',
                translatedName: 'Boemo ba hau ba HIV ke bofe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'exclusive breastfeeding',
                      name: 'Exclusive breastfeeding',
                      translatedName: 'Exclusive breastfeeding'),
                  InputFieldOption(
                      code: 'exclusive replacement feeding',
                      name: 'Exclusive replacement feeding',
                      translatedName: 'Exclusive replacement feeding'),
                  InputFieldOption(
                      code: 'mixed feeding',
                      name: 'Mixed feeding',
                      translatedName: 'Mixed feeding'),
                ]),

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
                id: 'cJHVdETPtB1',
                name: 'Date stopped breastfeeding',
                translatedName: 'Letsatsi leo o emisitseng kanyeso',
                valueType: 'DATE',
                firstDate: enrollmentDate,
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518)),
          ])
    ];
  }
}
