import 'dart:ui';

import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class DreamsReferralFollowUp {
  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: 'Referral Follow Up',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
              id: 'DPf5mUDoZMy',
              name: 'Follow-up date',
              valueType: 'DATE',
              inputColor: const Color(0xFF1F8ECE),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'VHe4ctA0bqU',
                name: 'Follow-up Status',
                valueType: 'TEXT',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'Complete', name: 'Complete'),
                  InputFieldOption(code: 'Not complete', name: 'Not complete'),
                ]),
            InputField(
              id: 'BzkeBAxdEVT',
              name: 'Additional follow up required',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF1F8ECE),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'LcG4J82PM4Z',
              name: 'Comments or next steps',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF1F8ECE),
              labelColor: const Color(0xFF737373),
            ),
          ])
    ];
  }
}
