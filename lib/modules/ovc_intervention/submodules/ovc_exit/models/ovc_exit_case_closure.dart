import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcExitCaseClosure {
  static List<String> getMandatoryFields() {
    return [
      'eventDate',
      'D9boflKTCM4',
      'S6vcaNyPT5a',
      'Mgvli43II0y',
      'd1fuqooMhvZ',
      'HEqBwx1j03q',
      'P4jYGKdec2j',
      'P3UeZrhQ3n6',
      'UR6DHzGAh9V',
      'aVSqxKj3eUt',
      'z3oHGQMNcwr',
      'OXxcaFKJhaB',
      'F687EjSn2TW',
      'ZNeMsEdTA8s',
      'KR0HmxVQwnJ'
    ];
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      AppUtil.getServiceProvisionEventDateSection(
        inputColor: const Color(0xFF4A9F46),
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: const Color(0xFF0D3A16),
        formSectionLabel: 'Case Closure Date',
        inputFieldLabel: 'Case Closure On',
        firstDate: firstDate,
      ),
      FormSection(
          name: 'Case closure checklist',
          color: const Color(0xFF0D3A16),
          inputFields: [
            InputField(
                id: 'S6vcaNyPT5a',
                name: 'Date of Household Exited from the OVC Program',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF07AD40),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'D9boflKTCM4',
                name: 'What is a reason for case closure?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF07AD40),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'CasePlanAchievement',
                      name: 'Case Plan Achievement'),
                  InputFieldOption(code: 'Transfer', name: 'Transfer'),
                  InputFieldOption(code: 'Attrition', name: 'Attrition'),
                ]),
            InputField(
              id: 'Mgvli43II0y',
              name: 'Are case files completed per the protocol?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'd1fuqooMhvZ',
                name:
                    'Social worker has given phone number to household (Provide office number)?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF07AD40),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'HEqBwx1j03q',
                name:
                    'Head of household linked to a family, which has already graduated?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF07AD40),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'P4jYGKdec2j',
                name: 'Name of household head linked to',
                valueType: 'TEXT',
                inputColor: const Color(0xFF07AD40),
                labelColor: const Color(0xFF737373)),
            InputField(
              id: 'P3UeZrhQ3n6',
              name: 'Inform necessary service providers of graduation?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'UR6DHzGAh9V',
              name: 'Graduation recorded in database of partner?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'aVSqxKj3eUt',
              name:
                  'Files for case plan achievement stored in a safe place (locked cabinet)?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'z3oHGQMNcwr',
              name: 'Care Transfer Form completed per the protocol?',
              translatedName:
                  'Foromo ea Phetisetso ea Tlhokomelo e tlatsitsoe ho latela litataiso?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'OXxcaFKJhaB',
              name:
                  'Referring Social Worker established time and frequency for follow up with receiving organization?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'F687EjSn2TW',
              name: 'Inform necessary service providers of care transfer?',
              translatedName:
                  'Ho tsebisa bafani ba litšebeletso tse hlokahalang ka phetiso ea tlhokomelo?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'ZNeMsEdTA8s',
              name: 'Copy of family folder sent to receiving organization?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'KR0HmxVQwnJ',
              name:
                  'Files for case transfer stored in a safe place (locked cabinet)?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'rrAzBqK44OE',
              name: 'Reason for attrition documented in family folder',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'NAzhfDNlYIr',
              name:
                  'Files for attrition stored in a safe place (locked cabinet)',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF07AD40),
              labelColor: const Color(0xFF737373),
            ),
          ])
    ];
  }
}
