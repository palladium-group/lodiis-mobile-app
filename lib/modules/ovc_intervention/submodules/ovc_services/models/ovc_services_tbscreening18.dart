import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcServicesTb18screening {
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
                      id: 'tMvluCbiiUm',
                      name:
                      '1.	Are you coughing?',
                      translatedName:
                      '1.	Are you coughing?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'P9hiqrTjAdg',
                      name: '2.	Have you lost weight (without trying)?',
                      translatedName:
                      '2.	Have you lost weight (without trying)?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'Y8Xzy7bEWsi',
                      name: '3.	Do you have drenching/soaking sweats at night?',
                      translatedName: '3.	Do you have drenching/soaking sweats at night?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'VETgonq6tFr',
                      name: '4.	Do you have fevers?',
                      translatedName: '4.	Do you have fevers?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),

                ])
          ])
    ];
  }
}
