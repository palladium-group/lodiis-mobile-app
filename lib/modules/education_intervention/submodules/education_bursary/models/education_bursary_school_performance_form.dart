import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class EducationBursarySchoolPerformanceForm {
  static List<String> getMandatoryFields() {
    return [
      "Uw2Z1XNFgXI",
      "vigylZN5Wjz",
      "t6kN1SwgMSs",
      "yYuNppDTRji",
      "vci20we0Ypg",
      "O8VSN74kSJx",
      "na5YEZYwY0l",
      "sCR0ebG3UWX",
      "AGBBacBaorC",
      "fZEQ0wIyB5h",
      "iBanzhFYlRN",
      "asG0ls9Qfp2",
      "uEeaGfuxHyV",
      "lwLEpwalIlG",
      "zpykd7zvLsC"
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: 'Student performance tracking',
          translatedName: "Ts'alomorao ea ts'ebetso ea sekolo",
          color: const Color(0xFF009688),
          inputFields: [
            InputField(
              id: 'Uw2Z1XNFgXI',
              name: '1. Is the child still in school?',
              translatedName: '1. Na ngoana o ntse a kena sekolo?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'vigylZN5Wjz',
              name: '2. If no, give reasons',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 't6kN1SwgMSs',
              name: 'School name',
              translatedName: 'Lebitso la sekolo',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'yYuNppDTRji',
              name: 'Grade',
              translatedName: 'Sehlopha',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'vci20we0Ypg',
              name:
                  '3. Has the child/OVC missed school for 10 or more consecutive days?',
              translatedName:
                  '3. Na ngoana/OVC o kile a lofa sekolo matsatsi a 10 kapa ho feta a latellaneng?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'O8VSN74kSJx',
              name:
                  '4. Did the child/OVC have any challenges related to school that could have led to low/bad/poor performance?',
              translatedName:
                  '4. Na ngoana/OVC ena le liqholotso tse amang mosebetsi oa hae oa sekolo hampe?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'na5YEZYwY0l',
              name:
                  'What were the challenges the child had related to school that could have led to low/bad performance',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'sCR0ebG3UWX',
              name:
                  '5. Does the caregiver play any role to boost the child school performance?',
              translatedName:
                  '5. Na mohlokomeli o bapala karolo ho ntlafatsa ts’ebetso ea ngoana ea sekolo?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'AGBBacBaorC',
              name: '6. Is the child happy about performance?',
              translatedName: '6. Na ngoana o khotsofalletse ts’ebetso ea hae?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'fZEQ0wIyB5h',
                name:
                    '7. Comparing the last quarter to the current quarter performance; how has the child performed?',
                translatedName:
                    '7. Papisong le kotareng e fetileng, ts’ebetso ea ngoana e joang kotareng ee?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
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
                      translatedName: 'E mpe le ho feta'),
                ]),
            InputField(
              id: 'iBanzhFYlRN',
              name:
                  '8. What are the Caregiver’s comments about child attendance and performance',
              translatedName:
                  '8. Maikutlo a mohlokomeli mabapi le ho kena sekolo hoa ngoana  le ts’ebetso ea hae sekolong ke afe',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'asG0ls9Qfp2',
              name:
                  '9. What is the quarter resolution to better the performance?',
              translatedName:
                  '9. Ke liqeto lifeng tse tla nkoa kotareng ee ho ntlafatsa tsebetso ea ngoana ea sekolo?',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'uEeaGfuxHyV',
                name: 'End of Quarter/year Result',
                translatedName: 'Sephetho sa mafelo a kotara/selemo',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Passed',
                      name: 'Passed',
                      translatedName: 'O pasitse'),
                  InputFieldOption(
                      code: 'Failed',
                      name: 'Failed',
                      translatedName: 'Ha atleha'),
                  InputFieldOption(
                      code: 'Did not write exams',
                      name: 'Did not write exams',
                      translatedName: 'Ha a ngola litlhahlobo'),
                ]),
            InputField(
              id: 'lwLEpwalIlG',
              name: 'Is this end of year result',
              translatedName: 'Ke sephetho sa mafelo a selemo',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'zpykd7zvLsC',
                name: 'End of year result (Outcome)',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                    code: 'Progressing to next grade',
                    name: 'Progressing to next grade',
                  ),
                  InputFieldOption(
                    code: 'Repeating same grade',
                    name: 'Repeating same grade',
                  ),
                  InputFieldOption(
                    code: 'Dropped-out',
                    name: 'Dropped-out',
                  ),
                ]),
          ])
    ];
  }
}
