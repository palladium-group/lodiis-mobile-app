import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class AgywEnrollmentNoneParticipation {
  static List<String> getMandatoryField() {
    return [
      'JhOvli80Qbx',
      'jjZWuJfVStp',
      'jVSwC6Ln95H',
      'an7w8LYPZ7y',
      'FHn0nJPumhO'
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        name: 'AGYW/DREAMS None Participation',
        translatedName: 'E eseng karolo ea AGYW/DREAMS',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'JhOvli80Qbx',
            name: 'First Name',
            translatedName: 'Lebitso la pele',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'UUsPnBtuItN',
            name: 'Middle Name',
            translatedName: 'Lebitso le mahareng',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'jjZWuJfVStp',
            name: 'Surname',
            translatedName: 'Le Fane',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'xEfuZ53tYsA',
            name: 'Phone number of parent/caregiver/heads of family',
            translatedName:
                'Nomoro ea fono ea motsoali/mohlokomeli/hloho ea lelapa',
            valueType: 'PHONE_NUMBER',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ox6mydZjgC3',
            name: 'Phone Number',
            translatedName: 'Nomoro ea mohala',
            valueType: 'PHONE_NUMBER',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'jVSwC6Ln95H',
            name: 'Date of Birth',
            translatedName: 'Letsatsi la tsoalo ',
            valueType: 'DATE',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            maxAgeInYear: 24,
            numberOfMonth: 11,
            minAgeInYear: 9,
          ),
          InputField(
            id: 'mZs1YsN56cR',
            translatedName: 'Lilemo',
            name: 'Age',
            isReadOnly: true,
            valueType: 'NUMBER',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'an7w8LYPZ7y',
              name: 'Sex',
              translatedName: 'Boleng',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              renderAsRadio: true,
              options: [
                InputFieldOption(
                    code: 'Male', name: 'Male', translatedName: 'Botona'),
                InputFieldOption(
                    code: 'Female',
                    name: 'Female',
                    translatedName: 'Botsehali'),
              ]),
          InputField(
              id: 'FHn0nJPumhO',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              name:
                  'Reason why the participant can not be part of the programme',
              translatedName:
                  'Mabaka a etsang hore motho a seke a nka karolo ka hara morero',
              valueType: 'LONG_TEXT')
        ],
      )
    ];
  }
}
