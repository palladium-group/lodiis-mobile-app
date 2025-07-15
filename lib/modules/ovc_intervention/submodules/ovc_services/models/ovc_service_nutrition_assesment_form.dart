import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcServicesNutritionscreening {
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
        formSectionLabel: 'Nutrition Screening Date',
        inputFieldLabel: 'Assessment Date',
        firstDate: firstDate,
      ),
      FormSection(
          name: 'Nutrition Screening',
          color: const Color(0xFF4B9F46),
          inputFields: [
            InputField(
                id: 'JnCFOeouVIy',
                name: '1. Check weight on the growth chart',
                translatedName: '1. Khetha boima ba ngoana bukaneng',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code:
                      'Normal',
                      name:
                      'Normal',
                      translatedName:
                      'Normal'),
                  InputFieldOption(
                      code: 'Flat',
                      name: 'Flat',
                      translatedName: 'Flat'),
                  InputFieldOption(
                      code: 'Falling',
                      name: 'Falling',
                      translatedName: 'Falling'),
                  InputFieldOption(
                      code: 'Above Normal',
                      name: 'Above Normal',
                      translatedName: 'Above Normal'),
                ]),
            InputField(
                id: 'lbr7YOB6HJ1',
                name: '2. How would you describe feeding time with your baby? ',
                translatedName: '2. How would you describe feeding time with your baby? ',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code:
                      'Always Pleasant',
                      name:
                      'Always Pleasant',
                      translatedName:
                      'Always Pleasant'),
                  InputFieldOption(
                      code: 'Sometimes Pleasant',
                      name: 'Sometimes Pleasant',
                      translatedName: 'Sometimes pleasant'),
                  InputFieldOption(
                      code: 'Never Pleasant',
                      name: 'Never Pleasant',
                      translatedName: 'Never Pleasant'),

                ]),
                InputField(
                    id: 'ATWzSRHBmuF',
                    name:
                    '3. Has the child unintentionally lost weight?',
                    translatedName:
                    '3.	Has the child unintentionally lost weight? ',
                    valueType: 'BOOLEAN',
                    inputColor: const Color(0xFF4B9F46),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'uINNVU0OeRP',
                    name:
                    '4.	Has the child had poor weight gain over the last few months? ',
                    translatedName:
                    '4. Has the child had poor weight gain over the last few months?',
                    valueType: 'BOOLEAN',
                    inputColor: const Color(0xFF4B9F46),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'bMNyAIWumx1',
                    name:
                    '5.	Has the child been eating/feeding less in the last few weeks ',
                    translatedName:
                    '5. Has the child been eating/feeding less in the last few weeks',
                    valueType: 'BOOLEAN',
                    inputColor: const Color(0xFF4B9F46),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'OUPk2e9DoMe',
                    name:
                    '6. Is the child obviously looking underweight? Thin, Ribs protruding from the body, etc.',
                    translatedName:
                    '6. Is the child obviously looking underweight? Thin, Ribs protruding from the body, etc.',
                    valueType: 'BOOLEAN',
                    inputColor: const Color(0xFF4B9F46),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'eQM7VOlr5hG',
                    name:
                    '7.	Were there any days last month when your family didn’t have enough food to eat or enough money to buy food?',
                    translatedName:
                    '7. Were there any days last month when your family didn’t have enough food to eat or enough money to buy food?',
                    valueType: 'BOOLEAN',
                    inputColor: const Color(0xFF4B9F46),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'yVTsRM4eMHA',
                    name:
                    '8.	Are there concerns about the general health of a child ',
                    translatedName:
                    '8.	Are there concerns about the general health of a child ',
                    valueType: 'BOOLEAN',
                    inputColor: const Color(0xFF4B9F46),
                    labelColor: const Color(0xFF737373)),

          ],

          /*subSections: [
            FormSection(
                name: '',
                color: const Color(0xFF4B9F46),
                description:
                'Have the child experienced any of the following in the past 6 months?',
                translatedDescription:
                'Na ngoana o kile a ba le e nngoe eat see likhoeling tse fetileng tse tsheletseng?',
                inputFields: [
                  InputField(
                      id: 'aKUSNl3nEHA',
                      name:
                      '1. Prolonged or difficulty in breathing cough of > 2 weeks?',
                      translatedName:
                      '1.  Ho ohlola ho feta nako ea libeke tse 2?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'cAVna5BDOM8',
                      name: '2. Night sweats for no known reason of > 2 weeks?',
                      translatedName:
                      '2. Na ngoana o fufuleloa hore liphahlo libe metsi nako e fetang beke tse 2?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'usdZsovNmsU',
                      name: '3. Persistent fever for > 2 weeks?',
                      translatedName: '3. Mocheso Nakong e fetang beke tse 2?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'Vxhh2rikoQz',
                      name: '4. Failure to thrive and/or poor?',
                      translatedName: '4. Ho se hole hantle?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'ItMRTuAI5EK',
                      name:
                      '5. Swelling in the neck, armpit or groin for more than 2 weeks?',
                      translatedName:
                      '5. Ho ruruha molala, ka mahafing le lithalooane nako e fetang beke tse 2?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                ])
          ]*/)
    ];
  }
}
