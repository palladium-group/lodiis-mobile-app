import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class BioDataIndexContacts {
  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: 'BIO DATA: Index contacts',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'CEKq8l9b8DG',
                name: 'Type of partner',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code:
                          'Girlfriend/boyfriend/cohabiting partner/Wife/ Husband',
                      name:
                          'Girlfriend/boyfriend/cohabiting partner/Wife/ Husb'),
                  InputFieldOption(
                      code: 'Biological children below 15 yrs',
                      name: 'Biological children below 15 yrs'),
                  InputFieldOption(code: 'Associates', name: 'Associates'),
                  InputFieldOption(
                      code: 'Family members', name: 'Family members')
                ]),
            InputField(
                id: 'p9AA21uFn2n',
                name: "Partner's name",
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Y0QGNDBCEbz',
                name: "Partner's date of birth",
                valueType: 'DATE',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'cYoXGqzLXLr',
                name: "Partner's age",
                valueType: 'NUMBER',
                isReadOnly: true,
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'mUN2hEf7R57',
                name: "Partner's sex",
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Male', name: 'Male', translatedName: 'Botona'),
                  InputFieldOption(
                      code: 'Female',
                      name: 'Female',
                      translatedName: "Bots'ehali")
                ]),
            InputField(
              id: 'mkyHnxwr6QL',
              name: "Partner's contact",
              valueType: 'PHONE_NUMBER',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'xTD6pePFLIW',
                name: "Partner's Status",
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Positive',
                      name: 'Positive',
                      translatedName: 'T’soaetso e teng'),
                  InputFieldOption(
                      code: 'Negative',
                      name: 'Negative',
                      translatedName: 'T’soaetso haeo'),
                  InputFieldOption(
                      code: 'Unknown',
                      name: 'Unknown',
                      translatedName: 'Tse sa tsejoeng'),
                  InputFieldOption(
                      code: 'No Response',
                      name: 'No Response',
                      translatedName: 'Ha ho Karabo')
                ]),
          ]),
    ];
  }
}
