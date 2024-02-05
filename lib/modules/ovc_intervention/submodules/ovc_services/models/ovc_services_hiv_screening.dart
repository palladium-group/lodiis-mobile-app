import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcServicesHivScreening {
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
        formSectionLabel: 'HIV Risk Assessment Date',
        inputFieldLabel: 'Assessment Date',
        firstDate: firstDate,
      ),
      FormSection(
          name: 'HIV Risk Assessment',
          translatedName: 'Hlahlobo ea hoba tlokotsing ea HIV',
          color: const Color(0xFF4B9F46),
          inputFields: [
            InputField(
                id: 'kL4IhnhdKZv',
                name: 'Assessment enrollment criteria',
                translatedName: 'Lebaka la tlhahlobo ea boemo ba kotsi ea HIV',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      translatedName: 'Boemo ba HIV bo sa tsebahaleng',
                      code: 'Unknown status',
                      name: 'Unknown status'),
                  InputFieldOption(
                      translatedName: 'Boemo ba HIV bo sa boleloang.',
                      code: 'Undisclosed',
                      name: 'Undisclosed'),
                  InputFieldOption(
                      translatedName:
                          'O hlahlahlobile likhoeling tse 6 a fungoanoe a sena tsoaetso ea HIV',
                      code: 'Negative > 6mths',
                      name: 'Negative > 6mths'),
                  InputFieldOption(
                      translatedName: 'Ba kotsing ea ho ba le tsoetso ea HIV',
                      code: 'At risk older OVC/adolescent',
                      name: 'At risk older OVC/adolescent'),
                ]),
            InputField(
                id: 'Fz89mIraWIl',
                name:
                    '01. Is the biological father or mother of this child living or lived with HIV?',
                valueType: 'TEXT',
                translatedName:
                    '01. Na Ntate kapa ‘M’e oa ngoana o phela kapa o ne a phela le tsoaetso ea HIV?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'Don\'t Know',
                      name: 'Don\'t Know',
                      translatedName: 'Ha ke tsebe')
                ]),
            InputField(
                id: 'mIcseDgrIlJ',
                name:
                    '02. Is at least one sibling of the child living or has lived with HIV?',
                valueType: 'TEXT',
                translatedName:
                    '02.Na e mong oa bana  ba bo ngoana eo o phela kapa o ne a phela le tsoaetso HIV?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'Don\'t Know',
                      name: 'Don\'t Know',
                      translatedName: 'Ha ke tsebe')
                ]),
            InputField(
                id: 'Hi9fp222l2D',
                name:
                    '03. Has this child lost one or both biological parents due to a chronic or undiagnosed illness?',
                valueType: 'TEXT',
                translatedName:
                    '03. Na ho na le emong oa batsoali ba ngoana eo ea hlokahetseng ka lebaka la bokuli bo sa phekoleheng kapa bo sa boleloang?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'Don\'t Know',
                      name: 'Don\'t Know',
                      translatedName: 'Ha ke tsebe')
                ]),
            InputField(
                id: 'r13f1emAyvw',
                name:
                    '04. Has this child lost a sibling due to a chronic or undiagnosed illness?',
                valueType: 'TEXT',
                translatedName:
                    '04. Na e mong oa bana  ba bo ngoana eo o hlokahetse ka lebaka la bokuli bo sa phekoleheng kapa bo sa boleloang?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'Don\'t Know',
                      name: 'Don\'t Know',
                      translatedName: 'Ha ke tsebe')
                ]),
            InputField(
                id: 'YAugNMbMe2c',
                name:
                    '05. Has the child ever been hospitalized or has been malnourished in the past 12 months?',
                valueType: 'TEXT',
                translatedName:
                    '05.Na ngoana o kile a kena sepetlele kapa a bontsa mats’oao a phepo e sa nepahalang likhoeling tse 12 tse fetileng?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'Don\'t Know',
                      name: 'Don\'t Know',
                      translatedName: 'Ha ke tsebe')
                ]),
            InputField(
                id: 'niqNMJrfFDs',
                name:
                    '06. Does the child have recurring skin problems, and oral fungus or persistent cough and fever?',
                valueType: 'TEXT',
                translatedName:
                    '06. Na ngoana eo o na le bothata ba letlalo kapa liso tsa lehano kapa ho khohlela ho sa eng meriting?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'Don\'t Know',
                      name: 'Don\'t Know',
                      translatedName: 'Ha ke tsebe')
                ]),
            InputField(
                id: 'NhjnHO0IyqY',
                name:
                    '07. Has this child been frequently sick in the last three months?',
                valueType: 'TEXT',
                translatedName:
                    '07. Na ngoana eo o kile a khathatsoa ke bokuli likhoeling tse tharo tse fetileng?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'Don\'t Know',
                      name: 'Don\'t Know',
                      translatedName: 'Ha ke tsebe')
                ]),
            InputField(
                id: 'LA4G0A6fkNF',
                name:
                    '08. Is there anyone in the family who had TB in last 6 months',
                valueType: 'TEXT',
                translatedName:
                    '08.Na ho na le e mong oa lelapa ea bileng le lefuba (TB) likhoeling tse 6 tse fetileng?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'Don\'t Know',
                      name: 'Don\'t Know',
                      translatedName: 'Ha ke tsebe')
                ]),
            InputField(
                id: 'dL8ts5GQcMI',
                name:
                    '09. Is the child/ adolescent exposed to sexual violence?',
                valueType: 'TEXT',
                translatedName:
                    '09. Na ngoana eo o kile a ba maemong a mmehang tlokotsing ea tlhekefetso ea motabo?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'Don\'t Know',
                      name: 'Don\'t Know',
                      translatedName: 'Ha ke tsebe')
                ]),
            InputField(
                id: 'W64q5maeL6o',
                translatedName:
                    '10. Na ngoana o sa bonahala e ka o sa kene litabeng tsa  thobalanong?',
                name: '10. Is the adolescent sexually active?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'VJh6KDlBkfb',
                translatedName:
                    '11. Ho latela likarabo tse fanoeng na ngoana eo o lokela ho hlahlobela HIV?',
                name: '11. Is this child/adolescent eligible for an HIV test?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'SDPCwdDB9yX',
                translatedName:
                    '12. Na mohlokomeli/ ngoana ea lilemo li  ka holimo ho 12  o llumela ho halahobela HIV?',
                name:
                    '12. Has the caregiver/OVC >12 years accepted to have the child tested?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'v0ArPi4Rk4o',
                translatedName:
                    '13. Bao boemo ba HIV bo sa boleloang, mme ba le kotsing ea HIV, ba fetisetsoe ho Social Worker ea morero.',
                name: '13. Refer to Social Worker?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'hivriskres',
                name: 'HIV RISK ASSESSMENT RESULTS',
                translatedName: "SEPHETHO SA TLHAHLOBO EA KOTSI EA HIV",
                valueType: 'TEXT',
                renderAsRadio: true,
                options: [
                  InputFieldOption(
                      code: 'High risk',
                      name: 'High risk',
                      translatedName: "Kotsi e phahameng"),
                  InputFieldOption(
                      code: 'Low risk',
                      name: 'Low risk',
                      translatedName: "Kotsi e tlase")
                ],
                isReadOnly: true,
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373))
          ])
    ];
  }
}
