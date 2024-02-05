import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class EducationBursaryAttendanceForm {
  static const String bursaryClubAttendanceToReferralCheck = 'CQ3GZFbzv5N';
  static List<String> getMandatoryField() {
    return ['eventDate', 'WvYI4dliZyk'];
  }

  static List<FormSection> getReferralCheckFormSections() {
    return [
      FormSection(
        name: '',
        color: const Color(0xFF009688),
        inputFields: [
          InputField(
            id: bursaryClubAttendanceToReferralCheck,
            name: 'Referral offered?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
    ];
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
        name: 'Attendance',
        translatedName: 'Ho ba teng',
        color: const Color(0xFF009688),
        inputFields: [
          InputField(
            id: 'eventDate',
            name: 'Date',
            translatedName: 'Letsatsi',
            valueType: 'DATE',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'WvYI4dliZyk',
            name: 'Attended',
            translatedName: 'O bile teng',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'GKBZYfIj2s1',
              name: 'Mode of monitoring',
              translatedName: 'Mokhoa oa ho hlahloba',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                    code: 'Face to face',
                    name: 'Face to face',
                    translatedName: 'Sefahleho sefahleho'),
                InputFieldOption(
                    code: 'Virtual',
                    name: 'Virtual',
                    translatedName: 'Ka marangrang'),
              ]),
          InputField(
            id: 'EokvDGvXkOk',
            name: 'Reasons for non attendance',
            translatedName: 'Mabaka a ho lofa',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(code: 'self health ', name: 'Self health '),
              InputFieldOption(
                  code: 'Caregiver health', name: 'Caregiver health'),
              InputFieldOption(code: 'sibling health', name: 'Sibling health'),
              InputFieldOption(code: 'cultural', name: 'Cultural'),
              InputFieldOption(
                  code: 'sexual violence', name: 'Sexual violence'),
              InputFieldOption(
                  code: 'Physical violence', name: 'Physical violence'),
              InputFieldOption(
                  code: 'emotional violence', name: 'Emotional violence'),
              InputFieldOption(
                  code: 'economic vilence', name: 'Economic violence'),
              InputFieldOption(code: 'neglect', name: 'Neglect'),
              InputFieldOption(
                  code: 'school sexual harrassment',
                  name: 'School sexual harassment'),
              InputFieldOption(code: 'lost interest', name: 'Lost interest'),
              InputFieldOption(
                  code: 'weather conditions', name: 'Weather conditions'),
              InputFieldOption(code: 'CB', name: 'Cyber bullying'),
              InputFieldOption(code: 'PB', name: 'Physical bullying'),
              InputFieldOption(code: 'VB', name: 'Verbal bullying'),
              InputFieldOption(code: 'SC', name: 'School clothing'),
              InputFieldOption(
                  code: 'Stationery not provided in school',
                  name: 'Stationery not provided in school'),
              InputFieldOption(
                  code: 'Other school costs (not in KB Package)',
                  name: 'Other school costs (not in KB Package)'),
            ],
          ),
        ],
      )
    ];
  }
}
