import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class AgywWithoutEnrollmentCriteria {
  static List<String> getMandatoryField() {
    return [
      'JhOvli80Qbx',
      'jjZWuJfVStp',
      'jVSwC6Ln95H',
      'mZs1YsN56cR',
      'an7w8LYPZ7y'
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        name: 'Demographic Information',
        translatedName: 'Litaba tsa Boitsebiso ba motho',
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
              id: 'jVSwC6Ln95H',
              name: 'Date of Birth',
              translatedName: 'Letsatsi la tsoalo ',
              valueType: 'DATE',
              isReadOnly: true,
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              maxAgeInYear: 24,
              numberOfMonth: 11,
              minAgeInYear: 10,
              hint: "Beneficiary's age should be from 10 - 24 years",
              translatedHint: "Lilemo tsa setho li be pakeng tsa 10 le 24"),
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
                code: 'Male',
                name: 'Male',
                translatedName: 'Botona',
              ),
              InputFieldOption(
                code: 'Female',
                name: 'Female',
                translatedName: 'Botsehali',
              ),
            ],
          ),
        ],
      )
    ];
  }
}
