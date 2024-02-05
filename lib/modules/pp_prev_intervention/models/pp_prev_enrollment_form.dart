import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/constants/pp_prev_intervention_constant.dart';

class PpPrevEnrollmentForm {
  static List<String> getMandatoryField() {
    return [
      "location",
      "WTZ7GLTrE8Q",
      "rSP9c21JsfC",
      "qZP982qpSPS",
      "vIX4GTSCX4P",
      "RB8Wx75hGa4",
      "agg0eUd8Wwo",
      "ZxXscC5W9qb",
      'muAZsONb53n',
      'fSQY2z3L0lp',
      'qCEK4EQvSbL',
      'hZxlBQQlYLP',
      'F2OyvIDdUFG',
      'rAFWYJuAxTS',
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        name: "Enrollment Form",
        translatedName: 'Foromo ea ngoliso',
        color: const Color(0xFF9B2BAE),
        inputFields: [
          InputField(
            id: 'location',
            name: 'Location',
            translatedName: 'Sebaka',
            valueType: 'ORGANISATION_UNIT',
            allowedSelectedLevels: [AppHierarchyReference.communityLevel],
            filteredPrograms: [PpPrevInterventionConstant.program],
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'WTZ7GLTrE8Q',
            name: 'First Name',
            translatedName: 'Lebitso la pele',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'rSP9c21JsfC',
            name: 'Surname',
            translatedName: 'Le Fane',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'qZP982qpSPS',
            name: 'Date of Birth',
            minAgeInYear: 15,
            translatedName: 'Letsatsi la tsoalo',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'DATE',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ls9hlz2tyol',
            name: 'Age',
            translatedName: 'Lilemo',
            isReadOnly: true,
            valueType: 'NUMBER',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'RB8Wx75hGa4',
            name: 'Village',
            translatedName: 'Motse',
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'vIX4GTSCX4P',
            name: 'Sex',
            translatedName: 'Boleng',
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            renderAsRadio: true,
            options: [
              InputFieldOption(
                code: "Male",
                name: "Male",
                translatedName: 'Botona',
              ),
              InputFieldOption(
                code: "Female",
                name: "Female",
                translatedName: 'Botsehali',
              ),
            ],
          ),
          InputField(
            id: 'tNdoR0jYr7R',
            name: 'Phone number',
            translatedName: 'Nomoro ea mohala',
            valueType: 'PHONE_NUMBER',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        name: "HIV Screening Questions",
        translatedName: 'Lipotso tsa Tlhahlobo ea HIV',
        color: const Color(0xFF9B2BAE),
        inputFields: [
          InputField(
            id: 'agg0eUd8Wwo',
            name: 'Have you ever been tested for HIV?',
            translatedName: 'U kile oa hlahlobela HIV?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ZxXscC5W9qb',
            name: 'When was the last test?',
            translatedName: 'Teko ea ho qetela e ne e le neng',
            valueType: 'DATE',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'muAZsONb53n',
            name:
                'If you don’t mind telling me, what were the results of your last HIV test?',
            translatedName: 'Na u ka mpolella sephetho sa hau?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Positive',
                name: 'HIV Positive',
                translatedName: 'Tsoaetso e teng',
              ),
              InputFieldOption(
                code: 'Negative',
                name: 'HIV Negative',
                translatedName: 'Tsoaetso ha e eo',
              ),
              InputFieldOption(
                code: 'Declined to disclose',
                name: 'Did not disclose',
                translatedName: 'Ha a bolele',
              )
            ],
          ),
          InputField(
            id: 'fSQY2z3L0lp',
            name: 'Have you ever had sex?',
            translatedName: 'U kile oa etsa thoabalano?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'qCEK4EQvSbL',
            name:
                'In the past 12 months, Have you ever had sex with more than one person?',
            translatedName:
                'Likohoeling tse 12 tse fetileng, ukile oa etsa thobalano le bath oba fetang bonngoe?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'hZxlBQQlYLP',
            name: 'Have you ever had sex with someone who is HIV+?',
            translatedName: 'U kile oa etsa thobalano le motho ea HIV+?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'F2OyvIDdUFG',
            name:
                'Have you ever had sex with someone that you didn\'t know their HIV status?',
            translatedName:
                'U kile oa etsa thobalano le motho eo u sa tsebeng boemo ba hae ba HIV?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'rAFWYJuAxTS',
            name:
                'Have you ever had sores or unusual discharge on your genitals?',
            translatedName:
                'U kile oa ba le liso kapa u na le liso bothong ba hao kapa lero le sa tloaelehang?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
    ];
  }
}
