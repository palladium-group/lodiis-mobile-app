import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/ogac_intervention/constants/ogac_intervention_constant.dart';

class OgacInterventionFormSection {
  static List<String> getMandatoryField() {
    return [
      'location',
      'WTZ7GLTrE8Q',
      'rSP9c21JsfC',
      'qZP982qpSPS',
      'vIX4GTSCX4P',
      'RB8Wx75hGa4'
    ];
  }

  static List<FormSection> getStageFormSections() {
    return [
      FormSection(
        name: 'OGAC Module',
        color: const Color(0xFFF05A2A),
        inputFields: [
          InputField(
            id: 'TtZ7lDtc40r',
            name: 'OGAC Module Provided?',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'BelCZxo1ge9',
            name: 'Date of Service',
            translatedName: 'Letsatsi la Tshebeletso',
            valueType: 'DATE',
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'E5SBpSCOV7p',
            name: 'Referral to Comprehensive Services',
            translatedName: 'Phetisetso ho Litšebeletso tse Pharalletseng',
            valueType: 'TEXT',
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'OVC Comprehensive', name: 'OVC Comprehensive'),
              InputFieldOption(
                  code: 'DREAMS Comprehensive', name: 'DREAMS Comprehensive'),
            ],
          )
        ],
      )
    ];
  }

  static List<FormSection> getEnrollmentFormSections() {
    return [
      FormSection(
        name: 'Location details',
        translatedName: 'Lintlha tsa sebaka',
        color: const Color(0xFFF05A2A),
        inputFields: [
          InputField(
            id: 'location',
            name: 'Location',
            translatedName: 'Sebaka',
            valueType: 'ORGANISATION_UNIT',
            allowedSelectedLevels: [
              AppHierarchyReference.communityLevel,
              AppHierarchyReference.facilityLevel
            ],
            filteredPrograms: [OgacInterventionConstant.program],
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'RB8Wx75hGa4',
            name: 'Village',
            translatedName: 'Motse',
            valueType: 'TEXT',
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        name: 'Profile Details',
        translatedName: 'Lintlha tsa Profaele',
        color: const Color(0xFFF05A2A),
        inputFields: [
          InputField(
            id: 'WTZ7GLTrE8Q',
            name: 'First Name',
            translatedName: 'Lebitso la pele',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 's1HaiT6OllL',
            name: 'Middle Name',
            translatedName: 'Lebitso le mahareng',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'rSP9c21JsfC',
            name: 'Surname',
            translatedName: 'Le Fane',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'qZP982qpSPS',
              name: 'Date of Birth',
              translatedName: 'Letsatsi la tsoalo',
              valueType: 'DATE',
              inputColor: const Color(0xFFF05A2A),
              labelColor: const Color(0xFF737373),
              maxAgeInYear: 14,
              numberOfMonth: 11,
              minAgeInYear: 9,
              hint: "Beneficiary's age should be from 9 - 14 years",
              translatedHint: "Lilemo tsa setho li be pakeng tsa 9 le 14"),
          InputField(
            id: 'ls9hlz2tyol',
            name: 'Age',
            translatedName: 'Lilemo',
            isReadOnly: true,
            valueType: 'NUMBER',
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'vIX4GTSCX4P',
            name: 'Sex',
            translatedName: 'Boleng',
            valueType: 'TEXT',
            renderAsRadio: true,
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
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
            id: 'tNdoR0jYr7R',
            name: 'Phone number',
            translatedName: 'Nomoro ea mohala',
            valueType: 'PHONE_NUMBER',
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'EwZil0AnlYo',
            name: 'School name',
            translatedName: 'Lebitso la Sekolo',
            valueType: 'TEXT',
            inputColor: const Color(0xFFF05A2A),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
    ];
  }
}
