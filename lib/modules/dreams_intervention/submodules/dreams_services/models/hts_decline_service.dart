import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class HTSConsentDeclineService {
  static List<String> mandatoryField = ['gEjigBuBTmh'];
  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: 'Reason for Decline service',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
              id: 'gEjigBuBTmh',
              name: 'Reasons for rejecting/declining service(s) offered',
              translatedName: 'Mabaka a ho hana litšebeletso tse fanoang',
              valueType: 'TEXT',
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
                InputFieldOption(code: 'NotReady', name: 'Not Ready'),
                InputFieldOption(
                    code: 'HealthConcerns',
                    name: 'Health Concerns',
                    translatedName: 'Matšoenyeho a Bophelo bo Botle'),
                InputFieldOption(
                    code: 'AccessIssues',
                    name: 'Access Issues (resources, time)'),
                InputFieldOption(
                    code: 'NotInterested',
                    name: 'Not Interested',
                    translatedName: 'Ha ke Thahaselle'),
                InputFieldOption(
                  code: 'Other(s)',
                  name: 'Other(s)',
                  translatedName: 'Tse ling',
                )
              ],
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'oTTL6vEpKok',
              name: 'Specify other reasons for service declining',
              translatedName:
                  'Hlalosa mabaka a mang a ho fokotseha ha litšebeletso',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
          ]),
    ];
  }
}
