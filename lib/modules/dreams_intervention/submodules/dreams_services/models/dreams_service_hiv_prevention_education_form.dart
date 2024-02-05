import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class DreamsServiceHIVPreventionEducationForm {
  static List<String> getMandatoryField() {
    return FormUtil.getAllFormSectionInpiutFields(
      getFormSections(
        firstDate: '',
      ),
    );
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
        name: 'HIV Prevention Education',
        translatedName: 'Thuto ea Thibelo ea HIV',
        color: const Color(0xFF1F8ECE),
        inputFields: [
          InputField(
            id: 'ytVTXe4RVUJ',
            name: 'HIV Prevention Education provided',
            inputColor: const Color(0xFF1F8ECE),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'lvT9gfpHIlT',
            name: 'Date service was provided',
            translatedName: "Letsatsi leo ts'ebeletso e fanoeng ka lona",
            firstDate: firstDate,
            inputColor: const Color(0xFF1F8ECE),
            labelColor: const Color(0xFF737373),
            valueType: 'DATE',
          ),
          InputField(
              id: 'gEjigBuBTmh',
              name: 'Reasons for rejecting/declining service(s) offered',
              translatedName: 'Mabaka a ho hana litšebeletso tse fanoang',
              inputColor: const Color(0xFF1F8ECE),
              labelColor: const Color(0xFF737373),
              valueType: 'BOOLEAN',
              options: [
                InputFieldOption(
                    code: 'Religion/Culture',
                    name: 'Religion/Culture',
                    translatedName: 'Bolumeli/Setso'),
                InputFieldOption(
                    code: 'Service already provided',
                    name: 'Service already provided (by other provider)',
                    translatedName:
                        "Ts'ebeletso e se e fanoe (ke mofani e mong)"),
                InputFieldOption(
                  code: 'NotReady',
                  name: 'Not Ready',
                ),
                InputFieldOption(
                    code: 'HealthConcerns',
                    name: 'Health Concerns',
                    translatedName: 'Matšoenyeho a Bophelo bo Botle'),
                InputFieldOption(
                  code: 'AccessIssues',
                  name: 'Access Issues (resources, time)',
                ),
                InputFieldOption(
                    code: 'NotInterested',
                    name: 'Not Interested',
                    translatedName: 'Ha ke Thahaselle'),
                InputFieldOption(
                  code: 'Other(s)',
                  name: 'Other(s)',
                  translatedName: 'Tse ling',
                ),
              ]),
          InputField(
            id: 'oTTL6vEpKok',
            name: 'Specify other reasons for service declining',
            translatedName:
                'Hlalosa mabaka a mang a ho fokotseha ha litšebeletso',
            inputColor: const Color(0xFF1F8ECE),
            labelColor: const Color(0xFF737373),
            firstDate: firstDate,
            valueType: 'LONG_TEXT',
          ),
        ],
      ),
    ];
  }
}
