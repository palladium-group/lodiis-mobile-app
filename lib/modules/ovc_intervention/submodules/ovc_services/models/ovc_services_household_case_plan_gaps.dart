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
                name: 'HIV ADHERANCE SUPPORT',
                translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                valueType: 'TRUE_ONLY',
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
