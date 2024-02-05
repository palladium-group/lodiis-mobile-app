import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class DreamsServiceTBScreeningInfo {
  static List<FormSection> getFormSections() {
    return [
      FormSection(name: '', color: Colors.transparent, inputFields: [
        InputField(
            id: 'YlP3TG4JYKR',
            inputColor: const Color(0xFF1F8ECE),
            labelColor: const Color(0xFF737373),
            name: 'Pregnant',
            valueType: 'BOOLEAN'),
        InputField(
            id: 'yIZY0baE8JP',
            name: 'Gestational age',
            inputColor: const Color(0xFF1F8ECE),
            labelColor: const Color(0xFF737373),
            valueType: 'NUMBER'),
        InputField(
          id: 'uRsImCXXDXe',
          name: 'HIV Status',
          translatedName: 'Boemo ba HIV',
          valueType: 'TEXT',
          inputColor: const Color(0xFF1F8ECE),
          labelColor: const Color(0xFF737373),
          isReadOnly: true,
          options: [
            InputFieldOption(
                code: 'Positive',
                name: 'Positive',
                translatedName: 'T’soaetso e teng'),
            InputFieldOption(
                code: 'Negative',
                name: 'Negative',
                translatedName: 'T’soaetso haeo'),
            InputFieldOption(code: 'Indeterminate', name: 'Indeterminate')
          ],
        ),
        InputField(
            id: 'tMvluCbiiUm',
            inputColor: const Color(0xFF1F8ECE),
            labelColor: const Color(0xFF737373),
            name: 'Are you coughing',
            valueType: 'BOOLEAN'),
        InputField(
            id: 'P9hiqrTjAdg',
            inputColor: const Color(0xFF1F8ECE),
            labelColor: const Color(0xFF737373),
            name: 'Have you lost weight (without trying)',
            valueType: 'BOOLEAN'),
        InputField(
            id: 'Y8Xzy7bEWsi',
            inputColor: const Color(0xFF1F8ECE),
            labelColor: const Color(0xFF737373),
            name: 'Do you have drenching or soaking sweats at night',
            valueType: 'BOOLEAN'),
        InputField(
            id: 'VETgonq6tFr',
            inputColor: const Color(0xFF1F8ECE),
            labelColor: const Color(0xFF737373),
            name: 'Do you have fever',
            valueType: 'BOOLEAN'),
      ])
    ];
  }
}
