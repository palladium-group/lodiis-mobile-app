import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/constants/bursary_intervention_constant.dart';

class EducationBursaryEnrollmentForm {
  static List<String> getMandatoryField() {
    return [
      'location',
      'WTZ7GLTrE8Q',
      'rSP9c21JsfC',
      'qZP982qpSPS',
      'vIX4GTSCX4P',
      'EwZil0AnlYo',
      'RB8Wx75hGa4'
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        name: 'Student Information',
        color: const Color(0xFF009688),
        inputFields: [
          InputField(
            id: 'location',
            name: 'Location',
            translatedName: 'Sebaka',
            valueType: 'ORGANISATION_UNIT',
            allowedSelectedLevels:
                BursaryInterventionConstant.allowedSelectedLevels,
            filteredPrograms: [BursaryInterventionConstant.program],
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'WTZ7GLTrE8Q',
            name: 'First Name',
            translatedName: 'Lebitso la pele',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 's1HaiT6OllL',
            name: 'Middle Name',
            translatedName: 'Lebitso le mahareng',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'rSP9c21JsfC',
            name: 'Surname',
            translatedName: 'Le Fane',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'qZP982qpSPS',
            name: 'Date of Birth',
            translatedName: 'Letsatsi la tsoalo',
            isReadOnly: true,
            valueType: 'DATE',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ls9hlz2tyol',
            name: 'Age',
            translatedName: 'Lilemo',
            isReadOnly: true,
            valueType: 'NUMBER',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'vIX4GTSCX4P',
            name: 'Sex',
            translatedName: 'Boleng',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
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
          InputField(
            id: 'RB8Wx75hGa4',
            name: 'Village',
            translatedName: 'Motse',
            isReadOnly: true,
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'c1AYkJztLVA',
            name: 'Type of enrollment',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'New',
                name: 'New',
              ),
              InputFieldOption(
                code: 'Replacement',
                name: 'Replacement',
              )
            ],
          ),
          // Nearby School
          InputField(
            id: 'EwZil0AnlYo',
            name: 'School',
            translatedName: 'Sekolo se tloaelehileng',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'tbzi0t27D8l',
            name: 'Grade to be attended',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Grade 8',
                  name: 'Grade 8',
                  translatedName: 'Sehlopha sa 8'),
              InputFieldOption(
                  code: 'Grade 9',
                  name: 'Grade 9',
                  translatedName: 'Sehlopha sa 9'),
              InputFieldOption(
                  code: 'Grade 10',
                  name: 'Grade 10',
                  translatedName: 'Sehlopha sa 10'),
              InputFieldOption(
                  code: 'Grade 11',
                  name: 'Grade 11',
                  translatedName: 'Sehlopha sa 11'),
            ],
          ),
        ],
      )
    ];
  }
}
