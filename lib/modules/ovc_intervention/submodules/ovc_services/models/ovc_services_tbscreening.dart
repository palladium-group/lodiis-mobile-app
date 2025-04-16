import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcServicesTbscreening {
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
        formSectionLabel: 'TB Screening Date',
        inputFieldLabel: 'Assessment Date',
        firstDate: firstDate,
      ),
      FormSection(
          name: 'TB Screening',
          color: const Color(0xFF4B9F46),
          inputFields: [

          ],
          subSections: [
            FormSection(
                name: '',
                color: const Color(0xFF4B9F46),
             inputFields: [
                  InputField(
                      id: 'ugywQJdff4g',
                      name:
                          '1.	Has the child been coughing?',
                      translatedName:
                          '1.	Has the child been coughing?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'xRV1LwtS5iy',
                      name: '2.	Has the child had a fever?',
                      translatedName:
                          '2.	Has the child had a fever?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'Vxhh2rikoQz',
                      name: '3.	Failure to thrive/faltering growth or signs of severe malnutrition?',
                      translatedName: '3.	Failure to thrive/faltering growth or signs of severe malnutrition?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'RpsU0xjYhuh',
                      name: '4.	Has the child been in contact with someone with TB disease?',
                      translatedName: '4. Has the child been in contact with someone with TB disease?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),

                ])
          ])
    ];
  }
}
