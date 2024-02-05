import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class PpPrevGenderNormsForm {
  static List<String> getMandatoryField() {
    return [
      "W79837fEI3C",
      "O7sjTjxUmEa",
      "FoLeDcnocv4",
      "JjX25d72ume",
      "qxO13pu8vAk",
      "JGgGQZPZH4n",
      "O7sjTjxUmEa",
      "vL6NpUA0rIU",
      "IOW7iC5ZuRQ"
    ];
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
        name: 'Gender Norms',
        translatedName: 'Melao/litloahelo tsa tekano ea boleng',
        color: const Color(0xFF9B2BAE),
        inputFields: [
          InputField(
            id: 'W79837fEI3C',
            name: 'Name of Youth Mentor/Paralegal',
            translatedName: 'Lebitso la moafani oa litshebeletso',
            valueType: 'TEXT',
            isReadOnly: true,
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'IOW7iC5ZuRQ',
              name: 'Type of Intervention',
              translatedName: 'Mofuta oa Tsebeletso',
              valueType: 'TEXT',
             inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: 'Stepping Stones',
                  name: 'Stepping Stones',
                ),
                InputFieldOption(
                  code: 'Condom Promotion and Provision',
                  name: 'Condom Promotion and Provision',
                ),
              ],
            ),
          InputField(
            id: 'O7sjTjxUmEa',
            name: 'Session Date',
            translatedName: 'Letsatsi la kopano/leo litsebeletso li fanoeng',
            valueType: 'DATE',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'vL6NpUA0rIU',
            name: 'Number of session',
            translatedName: 'Nomoro ea lenane thuto',
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'FoLeDcnocv4',
            name: 'Number of Female condoms distributed',
            translatedName: 'Palo ea likhohlopo tsa basali tse fanoeng',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'JjX25d72ume',
            name: 'Number of Male condoms distributed',
            translatedName: 'Palo ea likhohlopo tsa banna tse fanoeng',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'qxO13pu8vAk',
            name: 'Number of lubricants distributed',
            translatedName: 'Palo ea lingobetsi e fanoeng',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'JGgGQZPZH4n',
            name: 'IEC Material Distributed',
            translatedName: 'Palo ea lithusa thuto tse fanoeng',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
        ],
      )
    ];
  }
}
