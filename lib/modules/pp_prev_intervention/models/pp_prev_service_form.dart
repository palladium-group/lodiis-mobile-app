import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class PpPrevServiceForm {
  static List<String> getMandatoryField() {
    return [
      'Nr7UJVA1CZE',
      'mFxyT39XSE4',
      'type_of_violence',
      'pY4J9Z90qhb',
      'action_taken',
      'HwGBP9iNl1g',
    ];
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
        name: "Service provision",
        translatedName: "Phano ea lits'ebeletso",
        color: const Color(0xFF9B2BAE),
        inputFields: [
          InputField(
            id: 'vHAWEdM8mfw',
            name: 'HIV Prevention Messaging',
            translatedName: 'Melaetsa ea thibelo ea HIV',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'XBekI82ixNm',
            name: 'Condom Messaging',
            translatedName: 'Khothaletso le phano ea likhohlopo',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'Eg2WRoWLNA3',
            name: 'GBV Messaging',
            translatedName: 'Melaetsa ea tlhekefetso',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
          name: "Condom Distribution",
          translatedName: 'Phano ea likhohlopo',
          color: const Color(0xFF9B2BAE),
          inputFields: [
            InputField(
              id: 'JjX25d72ume',
              name: 'Number of Male condoms distributed',
              translatedName: 'Palo ea likhohlopo tsa banna e fanoeng',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF9B2BAE),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'FoLeDcnocv4',
              name: 'Number of Female condoms distributed',
              translatedName: 'Palo ea likhohlopo tsa basali e fanoeng',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF9B2BAE),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'qxO13pu8vAk',
              name: 'Number of lubricants distributed',
              translatedName: 'Palo ea lingobetsi tse fanoeng',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF9B2BAE),
              labelColor: const Color(0xFF737373),
            ),
          ]),
      FormSection(
        name: "Post GBV Screening",
        color: const Color(0xFF9B2BAE),
        inputFields: [
          InputField(
            id: 'Nr7UJVA1CZE',
            name: 'Have you ever experienced any form of violence or abuse?',
            translatedName: 'Na u kile oa hlekefetsoa?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'mFxyT39XSE4',
            name: 'When did the violence or abuse happen?',
            translatedName: 'Tlhekefetso e etsahetse neng?',
            valueType: 'TEXT',
            options: [
              InputFieldOption(
                code: '0-3 months ago',
                name: '0-3 months ago',
                translatedName: '0-3 likhoeli tse fetileng',
              ),
              InputFieldOption(
                code: '4-6 months ago',
                name: '4-6 months ago',
                translatedName: '4-6 likhoeli tse fetileng',
              ),
              InputFieldOption(
                code: '7-12 months ago',
                name: '7-12 months ago',
                translatedName: '4-6 likhoeli tse fetileng',
              ),
              InputFieldOption(
                  code: 'Above 12 months ago',
                  name: 'Above 12 months ago',
                  translatedName: 'Ka holimo ho likhoeli tse 12 tse fetileng'),
            ],
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'type_of_violence',
            name: 'What type of violence/abuse did you experience?',
            translatedName: 'Ke mofuta ofeng oa tlhekefetso o u bileng le eona',
            valueType: 'CHECK_BOX',
            options: [
              InputFieldOption(
                code: 'mTejEL5fS6X',
                name: 'Sexual',
                translatedName: 'Tlhekefetso ea motabo',
              ),
              InputFieldOption(
                code: 'Ib0BqMrYPkV',
                name: 'Economic/Neglect',
                translatedName: 'Tlhekefetso ea moruo',
              ),
              InputFieldOption(
                code: 'xuoKLKbNVj9',
                name: 'Physical',
                translatedName: 'Tlhekefetso ea mmele',
              ),
              InputFieldOption(
                code: 'bYGq2fsmsao',
                name: 'Emotional',
                translatedName: 'Tlhekefetso ea maikutlo',
              ),
            ],
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'pY4J9Z90qhb',
            name: 'Action taken?',
            translatedName: 'Na ho nkiloe likhato?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'action_taken',
            name: 'What types of action was taken?',
            translatedName: 'Ke mofuta ofeng oa likhato tse nkiloeng?',
            valueType: 'CHECK_BOX',
            options: [
              InputFieldOption(
                code: 'VHQc0WdwTSY',
                name: 'Health Facility',
                translatedName: 'Setsi sa bophelo',
              ),
              InputFieldOption(
                code: 'PfT6tJ25Po2',
                name: 'Police-CGPU',
                translatedName: 'Sepolesa sa likamano',
              ),
              InputFieldOption(
                code: 'v7PSGUHZoVT',
                name: 'Chief',
                translatedName: 'Morena',
              ),
              InputFieldOption(
                code: 'SioekRoBWYR',
                name: 'Councilor',
                translatedName: 'Mokhanselara',
              ),
              InputFieldOption(
                code: 'jGMTVVtFgTW',
                name: 'Social Worker',
                translatedName: 'Mosebeletsi oa sechaba',
              ),
              InputFieldOption(
                code: 'Ma0avVN9N2C',
                name: 'Other',
                translatedName: 'Tse ling',
              ),
            ],
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'HwGBP9iNl1g',
            name: 'Specify other type of action taken',
            translatedName: "Hlalosa mofuta o mong oa ts'ebetso e entsoeng",
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
        ],
      )
    ];
  }
}
