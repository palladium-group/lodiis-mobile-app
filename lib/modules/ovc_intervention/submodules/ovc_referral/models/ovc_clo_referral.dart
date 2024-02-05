import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcCLOReferral {
  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: "CLO Referrals",
          color: const Color(0xFF1B3519),
          subSections: [
            FormSection(name: "", color: Colors.transparent, inputFields: [
              InputField(
                  id: 'NbQGlx6QZpK_clo_type',
                  name: 'Type of CLO Referral',
                  translatedName: 'Mofuta oa CLO referral',
                  valueType: 'TEXT',
                  inputColor: const Color(0xFF4B9F46),
                  labelColor: const Color(0xFF737373),
                  options: [
                    InputFieldOption(
                        code: 'NbQGlx6QZpK_OnGoing',
                        name: 'CLO Outgoing Referrals'),
                    InputFieldOption(
                        code: 'NbQGlx6QZpK_Received',
                        name: 'CLO Incoming Referrals'),
                  ]),
            ]),
            FormSection(
                name: 'CLO Incoming Referrals',
                color: const Color(0xFF1B3519),
                id: "OIUDljKyNgy_clo_received",
                inputFields: [
                  InputField(
                    id: 'OIUDljKyNgy',
                    name: 'Date of referral',
                    valueType: 'DATE',
                    inputColor: const Color(0xFF4B9F46),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'BelCZxo1ge9',
                      name: 'Date of Service',
                      translatedName: 'Letsatsi la Tshebeletso',
                      valueType: 'DATE',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'NbQGlx6QZpK',
                      name: 'Referred by',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(code: 'CMW', name: 'CMW'),
                        InputFieldOption(code: 'YM', name: 'YM'),
                        InputFieldOption(code: 'PE', name: 'PE'),
                        InputFieldOption(code: 'SCMW', name: 'SCMW'),
                        InputFieldOption(
                            code: 'Paralegals', name: 'Paralegals'),
                        InputFieldOption(code: 'CLO', name: 'CLO'),
                      ]),
                  InputField(
                      id: 'RiNop7mvTRW',
                      name: 'Community Partner',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(code: 'LENEPHWA', name: 'LENEPHWA'),
                        InputFieldOption(code: 'WLSA', name: 'WLSA'),
                        InputFieldOption(code: 'CBA', name: 'CBA'),
                        InputFieldOption(code: 'CIL', name: 'CIL'),
                        InputFieldOption(code: 'LIRAC', name: 'LIRAC'),
                        InputFieldOption(code: 'SENTEBALE', name: 'SENTEBALE'),
                        InputFieldOption(code: 'SWAALES', name: 'SWAALES'),
                      ]),
                  InputField(
                      id: 'rWIw1JHPiTo',
                      name: 'Referred for',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(code: 'HTS', name: 'HTS'),
                        InputFieldOption(code: 'ART', name: 'ART'),
                        InputFieldOption(code: 'SAB', name: 'SAB'),
                        InputFieldOption(code: 'Parenting', name: 'Parenting'),
                        InputFieldOption(
                            code: 'Stepping Stone', name: 'Stepping Stone'),
                        InputFieldOption(code: 'VAC', name: 'VAC'),
                        InputFieldOption(
                            code: 'Singing to the Lion',
                            name: 'Singing to the Lion'),
                        InputFieldOption(code: 'Other', name: 'Other')
                      ]),
                  InputField(
                      id: 'pdUklLmaauR',
                      name: 'Outcome Status',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(code: 'Complete', name: 'Complete'),
                        InputFieldOption(
                            code: 'Not complete', name: 'Not complete')
                      ])
                ]),
            FormSection(
                name: 'CLO Outgoing Referrals',
                color: const Color(0xFF1B3519),
                id: "g6J1vZ2kDXB_clo_outgoing",
                inputFields: [
                  InputField(
                    id: 'g6J1vZ2kDXB',
                    name: 'Viral Load Results (for CLHIV)',
                    translatedName: 'Sephetho sa Viral Load (bakeng sa CLHIV)',
                    valueType: 'TEXT',
                    inputColor: const Color(0xFF4B9F46),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'Cwg16RorxzK',
                      name: 'Multi-Month Despensing (MMD)',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'vEeBBzeQrQU',
                      name: 'Referred to (Name and Surname of Community Cadre)',
                      translatedName:
                          'O fetiselitsoe ho (Lebitso le fane tsa Mosebeletsi)',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'RiNop7mvTRW',
                      name: 'Community Partner',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(code: 'LENEPHWA', name: 'LENEPHWA'),
                        InputFieldOption(code: 'WLSA', name: 'WLSA'),
                        InputFieldOption(code: 'CBA', name: 'CBA'),
                        InputFieldOption(code: 'CIL', name: 'CIL'),
                        InputFieldOption(code: 'LIRAC', name: 'LIRAC'),
                        InputFieldOption(code: 'SENTEBALE', name: 'SENTEBALE'),
                        InputFieldOption(code: 'SWAALES', name: 'SWAALES'),
                      ]),
                  InputField(
                      id: 'OIUDljKyNgy',
                      name: 'Date of referral',
                      valueType: 'DATE',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'pdUklLmaauR',
                      name: 'Outcome Status',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(code: 'Complete', name: 'Complete'),
                        InputFieldOption(
                            code: 'Not complete', name: 'Not complete')
                      ]),
                ])
          ])
    ];
  }
}
