import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

import '../../../../../core/utils/form_util.dart';

class OvcHouseholdServicesCasePlanGaps {
  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
          id: 'Health',
          name: 'DOMAIN HEALTH',
          translatedName: 'BOPHELO BO BOTLE',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [
            InputField(
                id: 'HKCv7lkLexo',
                name: 'Offer HIV adherence support',
                translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                valueType: 'TRUE_ONLY',
                isReadOnly: true,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'JzlLk2tW4xh',
                allowFuturePeriod: true,
                name: '( HIV ADHERANCE SUPPORT ) Projected date for completion',
                translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'bRv4ZZy5MDH',
                name: 'Refer for TB Testing',
                translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                valueType: 'TRUE_ONLY',
                isReadOnly: true,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'mvDI6Jr40kI',
                allowFuturePeriod: true,
                name: '( TB Treatment ) Projected date for completion',
                translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'ylSjcj6cv42',
                name: 'Refer for ART Initiation',
                translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                valueType: 'TRUE_ONLY',
                isReadOnly: true,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'qMrZcC7VvCV',
                allowFuturePeriod: true,
                name: 'Date for HIV Art initiation to be completed',
                translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'cx4xBY4jZXM',
                name: 'Provide HIV Messaging',
                translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                valueType: 'TRUE_ONLY',
                isReadOnly: true,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'SIEeRmPm0Q0',
                allowFuturePeriod: true,
                name: 'Date for HIV Messaging to be completed',
                translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'gff7hjjVoI6',
                name: 'Provide Community ART adherence counseling ',
                translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                valueType: 'TRUE_ONLY',
                isReadOnly: true,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'YI1Ckbt8mRn',
                allowFuturePeriod: true,
                name: 'Date for Community ART adherence counseling  to be completed',
                translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'XoSPWmpWXCy',
                name: 'Refer for HTS',
                translatedName: 'Tšebeletso a HTS ',
                valueType: 'TRUE_ONLY',
                isReadOnly: true,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'iFv7FJeG3V1',
                allowFuturePeriod: true,
                name: '(HTS) Projected date for completion',
                translatedName: 'Letsatsi la HTS le tla phetheloa',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'ztDAwmkSwKf',
                name: 'Provide Oral Health Hygiene Messaging',
                translatedName: 'Tšebeletso a HTS ',
                valueType: 'TRUE_ONLY',
                isReadOnly: true,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'bK18Ebt1cRa',
                allowFuturePeriod: true,
                name: 'Date for Hygiene Messaging to be completed',
                translatedName: 'Letsatsi la HTS le tla phetheloa',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'vqRohVpTK2G',
                name: 'ART literacy',
                translatedName: 'Tšebeletso a HTS ',
                valueType: 'TRUE_ONLY',
                isReadOnly: true,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'vUMhUm3i0b0',
                allowFuturePeriod: true,
                name: 'Date for ART literacy to be completed',
                translatedName: 'Letsatsi la HTS le tla phetheloa',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
        ],
      ),
    ];
  }

  static List<String> getMandatoryFields() {
    return FormUtil.getAllFormSectionInpiutFields(
      getFormSections(
        firstDate: '',
      ),
    );
  }
}
