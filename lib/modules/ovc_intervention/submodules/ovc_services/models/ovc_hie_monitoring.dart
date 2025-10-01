import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcHeiMonitoring {
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
                id: 'cTk9mxZZ2b6',
                name: 'Do you have current VL results for biological mother?',
                translatedName: 'Do you have current VL results for biological mother?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
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


          ])
    ];
  }
}
