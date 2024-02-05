import 'dart:ui';

import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_common_constant.dart';

class DreamsReferralFollowUp {
  static List<String> getMandatoryFields() {
    return ['DPf5mUDoZMy', 'VHe4ctA0bqU'];
  }

  static List<FormSection> getFormSections({required String firstDate}) {
    return [
      FormSection(
          name: 'Referral Follow Up',
          translatedName: 'Ho latela phetiso',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
              id: 'DPf5mUDoZMy',
              name: 'Follow-up date',
              translatedName: 'Latsatsi la tlhahlobo e latelang',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'VHe4ctA0bqU',
                name: 'Follow-up Status',
                valueType: 'TEXT',
                inputColor: AgywDreamsCommonConstant.defaultColor,
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'Complete', name: 'Complete'),
                  InputFieldOption(code: 'Not complete', name: 'Not complete'),
                ]),
            InputField(
              id: 'BzkeBAxdEVT',
              name: 'Additional follow up required',
              translatedName: 'Tlhahiso e eketsehileng ea hlokahala',
              valueType: 'BOOLEAN',
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'LcG4J82PM4Z',
              name: 'Comments or next steps',
              translatedName: 'Maikutlo kapa mehato e latelang',
              valueType: 'LONG_TEXT',
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
          ])
    ];
  }
}
