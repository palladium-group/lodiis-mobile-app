import 'dart:ui';

import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcReferralFollowUp {
  static List<String> getMandatoryFields() {
    return ['DPf5mUDoZMy', 'VHe4ctA0bqU'];
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
          name: 'Referral Follow Up',
          color: const Color(0xFF1B3519),
          inputFields: [
            InputField(
              id: 'DPf5mUDoZMy',
              name: 'Follow-up date',
              translatedName: 'Latsatsi la tlhahlobo e latelang',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'VHe4ctA0bqU',
                name: 'Follow-up Status',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'Complete', name: 'Complete'),
                  InputFieldOption(code: 'Not complete', name: 'Not complete'),
                ]),
            InputField(
              id: 'BzkeBAxdEVT',
              name: 'Additional follow up required',
              translatedName: 'Ho hlokahala tlhahlobo hape',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'LcG4J82PM4Z',
              name: 'Comments or next steps',
              translatedName: 'Maikutlo kapa mehato e latelang',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),
          ])
    ];
  }
}
