import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class EducationBursaryReferralOutcomeFollowUpForm {
  static List<String> getMandatoryField() {
    return ['DPf5mUDoZMy', 'VHe4ctA0bqU'];
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
        name: 'Bursary Referral Follow-up',
        color: const Color(0xFF009688),
        inputFields: [
          InputField(
            id: 'DPf5mUDoZMy',
            name: 'Follow-up date',
            translatedName: 'Latsatsi la tlhahlobo e latelang',
            valueType: 'DATE',
            firstDate: firstDate,
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'VHe4ctA0bqU',
            name: 'Follow-up Status',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Complete',
                name: 'Complete',
              ),
              InputFieldOption(
                code: 'Not complete',
                name: 'Not complete',
              ),
            ],
          ),
          InputField(
            id: 'BzkeBAxdEVT',
            name: 'Additional follow up required',
            translatedName: 'Ho hlokahala tlhahlobo hape',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'Yp3zlQ779fk',
            name: 'Additional Follow-up date',
            translatedName: 'Ho hlokahala tlhahlobo hape',
            allowFuturePeriod: true,
            disablePastPeriod: true,
            valueType: 'DATE',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'LcG4J82PM4Z',
            name: 'Comments or next steps',
            translatedName: 'Maikutlo kapa mehato e latelang',
            valueType: 'LONG_TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
    ];
  }
}
