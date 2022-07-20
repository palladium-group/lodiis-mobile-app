import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class DreamsPostGBVInfo {
  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
          name: 'Post GBV',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
              id: 'lvT9gfpHIlT',
              name: 'Date service was provided',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'mnYT2rZyGgJ',
              name: 'Post GBV',
              valueType: 'TRUE_ONLY',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
          ])
    ];
  }
}
