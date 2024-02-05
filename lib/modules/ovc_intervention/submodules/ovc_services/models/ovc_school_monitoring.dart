import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcSchoolMonitoring {
  static List<FormSection> getFormSections({
    required String enrollmentDate,
  }) {
    return [
      AppUtil.getServiceProvisionEventDateSection(
        inputColor: const Color(0xFF4A9F46),
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: const Color(0xFF4A9F46),
        formSectionLabel: 'School Monitoring Date',
        inputFieldLabel: 'School Monitoring On',
        firstDate: enrollmentDate,
      ),
      FormSection(
          name: 'DOMAIN SCHOOLED',
          translatedName: 'TSA SEKOLO',
          color: const Color(0xFF4A9F46),
          borderColor: const Color(0xFF4A9F46),
          inputFields: [
            InputField(
                id: 'Uw2Z1XNFgXI',
                name: '1. Is the child/OVC still in school?',
                translatedName: '1. Na ngoana o kena sekolo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 't6kN1SwgMSs',
                name: '2. School name?',
                translatedName: '2. Lebitso la Sekolo?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'yYuNppDTRji',
                name: 'Grade?',
                translatedName: 'Sehlopha',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'vigylZN5Wjz',
                name: '3. Why is the child/OVC not in school?',
                translatedName: '3. Ha Karabo e le Che, Fana ka Mabaka',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'vci20we0Ypg',
                name:
                    '4. Has the child/OVC missed school for 10 or more consecutive days?',
                translatedName:
                    '4. Na ngoana/OVC o kile a lofa sekolo nako ea matsatsi a 10 kapa ho feta a latellaneng?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'O8VSN74kSJx',
                name:
                    '5. Did the child/OVC have any challenges related to school that could have led to low/bad/poor performance?',
                translatedName:
                    '5. Na ngoana/OVC o kile a ba le liqholotso tse amanang le sekolo tse neng li ka susumetsa hore a sebetse hampe sekolong?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'na5YEZYwY0l',
                name:
                    'What were the challenges the child had related to school that could have led to low/bad performance?',
                translatedName: 'Ha Karabo e le E, Fana ka Mabaka',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'sCR0ebG3UWX',
                name:
                    '6. Does the caregiver play any role to boost the child school performance?',
                translatedName:
                    '6. Na mohlokomeli o nka karolo ho thusa ngoana ho akofisa tsebetso ea hae mosebetsing oa sekolo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'IWxxfSkEplj',
                name:
                    'Explain how caregiver boost the child school performance',
                translatedName:
                    'Hlalosa Karabo ea hauHlalosa ka moo mohlokomeli a thusang ngoana ho akofisa tsebetso ea hae mosebetsing oa sekolo',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'fZEQ0wIyB5h',
                name:
                    '8. Comparing the last quarter to the current quarter performance; how has the child performed?',
                translatedName:
                    '8. Ha o bapisa tsebetso ea kotara e fetileng le ea ha joale, ngoana o sebelitse joang?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Better', name: 'Better', translatedName: 'Betere'),
                  InputFieldOption(
                      code: 'Same',
                      name: 'Same',
                      translatedName: "E ts'oanang"),
                  InputFieldOption(
                      code: 'Worse',
                      name: 'Worse',
                      translatedName: 'E mpe le ho feta')
                ]),
            InputField(
                id: 'iBanzhFYlRN',
                name:
                    '9. What are the Caregiver’s comments about child attendance and performance',
                translatedName:
                    '9. Maikutlo a mohlokomeli ka makhetlo a ho ea sekolong le tsebetso ea ngoana ea sekolo ke a fe?',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4A9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'uEeaGfuxHyV',
                name: 'End of Quarter/year Result',
                translatedName: 'Sephetho sa mafelo a kotara/selemo',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Passed',
                      name: 'Passed',
                      translatedName: 'O pasitse'),
                  InputFieldOption(
                    code: 'Failed',
                    name: 'Failed',
                    translatedName: 'Ha atleha',
                  ),
                  InputFieldOption(
                      code: 'Did not write exams',
                      name: 'Did not write exams',
                      translatedName: 'Ha a ngola litlhahlobo')
                ]),
            InputField(
                id: 'zpykd7zvLsC',
                name: 'End of year result',
                translatedName: 'Sephetho sa mafelo a selemo',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Progressing to next grade',
                      translatedName: 'O ea sehlopheng se seng ',
                      name: 'Progressing to next grade'),
                  InputFieldOption(
                      code: 'Repeating same grade',
                      translatedName: 'O pheta sehlopha',
                      name: 'Repeating same grade'),
                  InputFieldOption(
                      code: 'Dropped-out',
                      translatedName: 'O tlohela sekola',
                      name: 'Dropped-out')
                ]),
          ])
    ];
  }
}
