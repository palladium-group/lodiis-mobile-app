import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class NonAgywHTSClientInformation {
  static List<String> getMandatoryField() {
    return [
      'sJ35hsF6Lf9',
      'location',
      'WTZ7GLTrE8Q',
      'rSP9c21JsfC',
      'qZP982qpSPS',
      'vIX4GTSCX4P',
      'vkd6o91n1IC',
      'RB8Wx75hGa4'
    ];
  }

  static List<String> getIndicationsForPrep() {
    return [
      'KmD2Y6Vogjm',
      'rSv8udBKoCv',
      'ZYhkYueaOxC',
      'uvkZ4vHUzxv',
      'j2HVnUQYMMf',
      'GsWKcz37Unm',
      'T3mqcWNaymY',
      'Se87hpRzGGB',
      'NftUCxEqj1W',
      'q3JCqCyX4aI',
      'NOQI0FLNx9W',
      'rBktFvgfp52'
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: 'Client Profile',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'location',
                name: 'Location',
                translatedName: 'Sebaka',
                valueType: 'ORGANISATION_UNIT',
                allowedSelectedLevels: [
                  AppHierarchyReference.communityLevel,
                  AppHierarchyReference.facilityLevel
                ],
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'RB8Wx75hGa4',
                name: 'Village',
                translatedName: 'Motse',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'WTZ7GLTrE8Q',
                name: 'First Name',
                translatedName: 'Lebitso la pele',
                regExpValidation: RegExp('^[A-Za-z]{0,}'),
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 's1HaiT6OllL',
                name: 'Middle Name',
                translatedName: 'Lebitso le mahareng',
                regExpValidation: RegExp('^[A-Za-z]{0,}'),
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'rSP9c21JsfC',
                name: 'Surname',
                translatedName: 'Le Fane',
                regExpValidation: RegExp('^[A-Za-z]{0,}'),
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
              id: 'vIX4GTSCX4P',
              name: 'Sex',
              translatedName: 'Boleng',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: 'Male',
                  name: 'Male',
                  translatedName: 'Botona',
                ),
                InputFieldOption(
                  code: 'Female',
                  name: 'Female',
                  translatedName: 'Botsehali',
                ),
              ],
            ),
            InputField(
              id: 'qZP982qpSPS',
              name: 'Date of Birth',
              translatedName: 'Letsatsi la tsoalo ',
              valueType: 'DATE',
              minAgeInYear: 15,
              numberOfMonth: 11,
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'ls9hlz2tyol',
                name: 'Age',
                translatedName: 'Lilemo',
                isReadOnly: true,
                valueType: 'NUMBER',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'vkd6o91n1IC',
                name: 'PrEP beneficiary type',
                isReadOnly: true,
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'AGYW', name: 'AGYW'),
                  InputFieldOption(code: 'NON-AGYW', name: 'NON-AGYW')
                ]),
          ]),
      FormSection(
          name: 'Client Information',
          translatedName: 'Boitsebiso',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'Dza1078Z0JG',
                name: 'Key Population',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'FSW', name: 'FSW'),
                  InputFieldOption(code: 'MSM SW', name: 'MSM SW'),
                  InputFieldOption(code: 'MSM NonSW', name: 'MSM NonSW'),
                  InputFieldOption(code: 'TG SW', name: 'TG SW'),
                  InputFieldOption(code: 'TG NonSW', name: 'TG NonSW'),
                  InputFieldOption(code: 'PWID', name: 'PWID'),
                  InputFieldOption(code: 'AGYWs', name: 'AGYWs'),
                  InputFieldOption(
                      code: 'Prisoner or enclosed',
                      name: 'Prisoner or enclosed')
                ]),
            InputField(
                id: 'pOujxELq1bi',
                name: 'Priority Pop: OVC 1',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Gp0YYKE11ZJ',
                name: 'Priority Pop: OVC 2',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'eQw2xk7kfn0',
                name: 'Priority Pop: Factory/exworker',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'ZAnZZ6m1BV6',
                name: 'Priority Pop: Mobile',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 't9F59DEE2KY',
                name: 'Priority Pop: Military',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Bei7INXU4Ih',
                name: 'Priority Pop: Miner/ex worker',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'xzxPpvkwVwB',
                name: 'Priority Pop: AGYWs',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'rUEnqWa5ftH',
                name: 'Priority Pop: FSWs',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'MW6q4xASzoN',
                name: 'Priority Pop: MSMs',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
          ]),
      FormSection(
          name: 'Previous HIV test history',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'qvXYyTK9h2m',
                name: 'Have you ever had an HIV test before',
                translatedName: 'Na u kile ua etsa tlhahlobo ea HIV pele',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'ZxXscC5W9qb',
                name: 'When was the last test',
                translatedName: 'Teko ea ho qetela e ne e le neng',
                valueType: 'DATE',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'ECSlqcSEB9D',
                name: 'Type of final test',
                translatedName: 'Mofuta oa teko ea ho qetela',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'Provider', name: 'Provider'),
                  InputFieldOption(code: 'HIVST', name: 'HIVST')
                ]),
            InputField(
                id: 'z50tGzpCAow',
                name: 'Results of the last test were',
                translatedName: 'Liphetho tsa tlhahlobo ea ho qetela li bile',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Negative',
                      name: 'Negative',
                      translatedName: 'T’soaetso haeo'),
                  InputFieldOption(
                      code: 'Positive on ART', name: 'Positive on ART'),
                  InputFieldOption(
                      code: 'Positve not on ART', name: 'Positve not on ART'),
                  InputFieldOption(code: 'Indeterminate', name: 'Indeterminate')
                ]),
          ]),
      FormSection(
          name: 'Risk assessment',
          translatedName: 'Tlhahlobo ea kotsi',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'vUjbFXNoYhE',
                name: 'Pregnant/breastfeeding (clients or partner)',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'RXS4fNXVKMl',
                name: 'Do you know your partners HIV status',
                translatedName:
                    'Na u tseba boemo ba molekane oa hau ba hau ba HIV',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'LZFhD0N9Zj5',
                name: "What's your partner HIV status",
                translatedName: 'Boemo ba molekane oa hau ba HIV ke bofe',
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
            InputField(
                id: 'VlLCik7OLHI',
                name: 'Are you?',
                translatedName: 'Na u?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Circumsized',
                      name: 'Circumsized',
                      translatedName: 'tlositse letlalo la botona'),
                  InputFieldOption(
                      code: 'Genital sores or discharge',
                      name: 'Genital sores or discharge',
                      translatedName: 'Seso kapa matheba a setho sa botona')
                ]),
            InputField(
                id: 'BCg2ITfVDXl',
                name: 'Number of sexual partners in last 12  months',
                translatedName:
                    "Palo ea balekane ba thobalano likhoeling tse 12 tse fetileng",
                valueType: 'INTEGER_ZERO_OR_POSITIVE',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
          ]),
      FormSection(
          name: 'Indications for PrEP',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'indication4PrEP',
                name: 'Indications for PrEP',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF1F8ECE),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'KmD2Y6Vogjm',
                      name:
                          'Sexual partner with HIV who is not virally suppressed'),
                  InputFieldOption(
                      code: 'rSv8udBKoCv',
                      name: 'Sexual partner with HIV is not ART'),
                  InputFieldOption(
                      code: 'ZYhkYueaOxC',
                      name:
                          'Sexual partner who has been on ART for less than 6 months'),
                  InputFieldOption(
                      code: 'uvkZ4vHUzxv',
                      name:
                          'Sexual partner who has been on ART for more than 6 months but is not virally suppressed'),
                  InputFieldOption(
                      code: 'j2HVnUQYMMf', name: 'Women who want to conceive'),
                  InputFieldOption(
                      code: 'GsWKcz37Unm',
                      name: 'Sexual partner with HIV, even if suppressed'),
                  InputFieldOption(
                      code: 'T3mqcWNaymY',
                      name: 'Sexual partner with unknown HIV status'),
                  InputFieldOption(
                      code: 'Se87hpRzGGB',
                      name:
                          'Vaginal or anal sexual intercourse without condoms with more than one partner in the past six months'),
                  InputFieldOption(
                      code: 'NftUCxEqj1W',
                      name:
                          'A sexual partner with one or more HIV risk factors in the past six months'),
                  InputFieldOption(
                      code: 'q3JCqCyX4aI',
                      name:
                          'A history of a sexually transmitted infection(STI) by lab testing or self-report or syndromic STI syndromic management in the past six months'),
                  InputFieldOption(
                      code: 'NOQI0FLNx9W',
                      name:
                          'Injecting drug user sharing needles and other injecting equipment'),
                  InputFieldOption(
                      code: 'rBktFvgfp52', name: 'Requesting PrEP'),
                ]),
          ]),
      FormSection(
          name: 'Vulnerabilities',
          translatedName: 'Bofokoli',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'AZCVLPzD0Vd',
                name: 'Multiple sex partners (>1)',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                isReadOnly: false,
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'rh881j2vfvT',
                name: 'STIs (Past or Present)',
                translatedName: 'Mafu a likobo',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                isReadOnly: false,
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'aBtb3bWMhBS',
                name: 'Regular Condom Use',
                translatedName: 'Tšebeliso ea Likhohlopo Kamehla',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                isReadOnly: false,
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'p33MrrhsQRz',
                name: 'Transactional Sex',
                translatedName: 'Thobalano u shebile menyetla e itseng',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                isReadOnly: false,
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'knAy1wGOtDY',
                name: 'Experiences of Intimate',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                isReadOnly: false,
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'QZ8jZZH16N5',
                name: 'Partner Violence',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                isReadOnly: false,
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'yc3BlUIEup3',
                name: 'Experience of Violence',
                translatedName: 'Tlhekefetso',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                isReadOnly: false,
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'ejq7vM0ae71',
                name: 'School enrollment',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                isReadOnly: false,
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'HJIHPjOf5s1',
                name: 'Alcohol Use',
                translatedName: 'Tsebeliso ea tai',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                isReadOnly: false,
                labelColor: const Color(0xFF737373)),
          ]),
      FormSection(
        name: "Today's HIV test",
        description:
            'Date: ${AppUtil.formattedDateTimeIntoString(DateTime.now())}',
        color: const Color(0xFF737373),
        inputFields: [
          InputField(
              id: 'sJ35hsF6Lf9',
              name: 'Client Type',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(code: 'Individual', name: 'Individual'),
                InputFieldOption(code: 'Couple', name: 'Couple')
              ]),
          InputField(
              id: 'XjHuTmtsXsz',
              name: 'Couple UIC',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'Lam6bSq1Zgk',
              name: 'Testing channel',
              valueType: 'TEXT',
              options: [
                InputFieldOption(code: 'Index', name: 'Index'),
                InputFieldOption(
                    code: 'New Start clinic', name: 'New Start clinic'),
                InputFieldOption(code: 'VCT', name: 'VCT'),
                InputFieldOption(
                    code: 'Mobile testing', name: 'Mobile testing'),
                InputFieldOption(code: 'Home-based', name: 'Home-based'),
                InputFieldOption(
                    code: 'Community PrEP', name: 'Community PrEP'),
                InputFieldOption(code: 'Other', name: 'Other'),
              ],
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'w6kNR0e4G6V',
            name: 'Other community platforms',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'J53jgfHiufC',
              name: 'Layering',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                    code: 'Assist/ Sentebale', name: 'Assist/ Sentebale'),
                InputFieldOption(code: 'IPC', name: 'IPC'),
                InputFieldOption(code: 'M2M', name: 'M2M'),
                InputFieldOption(code: 'CRS or Caritas', name: 'CRS or KB'),
                InputFieldOption(code: 'Promo', name: 'Promo'),
                InputFieldOption(code: 'WVI', name: 'WVI'),
                InputFieldOption(
                    code: 'Care for Lesotho', name: 'Care for Lesotho'),
                InputFieldOption(code: 'Other', name: 'Other'),
              ]),
          InputField(
              id: 'ybq5BQOdMG6',
              name: 'Other layering',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'uQLJ4S06kfR',
              name: 'How far did you go to school',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(code: 'None', name: 'None'),
                InputFieldOption(
                    code: 'Primary',
                    name: 'Primary',
                    translatedName: 'Mathomo'),
                InputFieldOption(
                    code: 'Secondary school', name: 'Secondary school'),
                InputFieldOption(code: 'High school', name: 'High school'),
                InputFieldOption(code: 'Tertiary', name: 'Tertiary'),
              ]),
          InputField(
              id: 'UXHDCoIaOsH',
              name: 'Your work',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                    code: 'Employment or Self employmed',
                    name: 'Employment or Self employed'),
                InputFieldOption(code: 'Student', name: 'Student'),
                InputFieldOption(code: 'Unemployed', name: 'Unemployed')
              ]),
          InputField(
              id: 'G86T8BY1eVL',
              name: 'What made you decide to get tested for HIV today',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(code: 'Index', name: 'Index'),
                InputFieldOption(
                    code: 'Other health worker', name: 'Other health worker'),
                InputFieldOption(
                    code: 'Self motivated', name: 'Self motivated'),
                InputFieldOption(code: 'Radio or TV', name: 'Radio or TV'),
                InputFieldOption(
                    code: 'Positive self-test', name: 'Positive self-test'),
                InputFieldOption(
                    code: 'KB Field staff', name: 'KB Field staff'),
                InputFieldOption(
                    code: 'PSI field or New Start staff',
                    name: 'PSI field or New Start staff'),
                InputFieldOption(
                    code: 'Billboard or Poster', name: 'Billboard or Poster'),
                InputFieldOption(
                    code: 'Partner notification', name: 'Partner notification'),
                InputFieldOption(
                    code: 'Other friends or relatives',
                    name: 'Other friends or relatives'),
                InputFieldOption(code: 'Other', name: 'Other'),
              ]),
          InputField(
              id: 'YzPuEq2nAIh',
              name: 'Other reasons why decided to get tested',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
          name: 'HIV test',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'sI1XSjzvOBd',
                name: 'T1: Result',
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
                ]),
            InputField(
                id: 'gNp7fK7mFen',
                name: 'T2: Result',
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
                ]),
            InputField(
                id: 'scYHe712W08',
                name: 'T3: Parallel 1/2',
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
                ]),
            InputField(
                id: 'nkHSb9XNR2W',
                name: 'T3: Parallel 2/2',
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
                ]),
            InputField(
                id: 'BjcJiQkXgUj',
                name: 'T4: SD Bioline',
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
                  InputFieldOption(code: 'Out of stock', name: 'Out of stock')
                ]),
            InputField(
                id: 'dLuVK70JxwY',
                name: 'T5: DNA PCR',
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
                ]),
            InputField(
                id: 'mA1IUgJSWf8',
                name: 'Final results',
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
                  InputFieldOption(code: 'Indeterminate', name: 'Indeterminate')
                ]),
            InputField(
                id: 'kaVGZBEOT5u',
                name: 'Test results given',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'a03ORtNeh7V',
                name: 'If HIV+, did client have knowledge of HIV+ status',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'ssNVBKMSv5T',
                name: 'Extra products used: Determine strips',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'cOXJOpBUyHo',
                name: 'Extra products used: Capillary tubes',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'ygpzOy6JGgM',
                name: 'Extra products used: Alcohol swabs',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'K1thlJQvIjA',
                name: 'Extra products used: Unigold strips',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'paBfUAvjNdI',
                name: 'Extra products used: Exam gloves',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'LVcAj2cW778',
                name: 'TB Screening conducted',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'J9ZNRq2xGb2',
                name: 'TB Suspected',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'mmK9CT0n9BV',
                name: 'Referral offered',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'i0U8S4F3rTa',
                name: 'ART referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'HD5YrKZXzQl',
                name: 'DNA PCR referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'dOUKOAUsIgD',
                name: 'Fp referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'WZYXR6Azijc',
                name: 'PReP (HIV-) referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'XAHL4Ldyv3P',
                name: 'STI Dx/TX referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'eBHVZQ8jWOm',
                name: 'TB Dx/Tx referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'odSWc26b9P6',
                name: 'VMMC referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'ZZBWYb9jzHE',
                name: 'Name of referral DNA PCR or ART facility',
                valueType: 'ORGANISATION_UNIT',
                allowedSelectedLevels: [
                  AppHierarchyReference.communityLevel,
                  AppHierarchyReference.facilityLevel
                ],
                showCountryLevelTree: true,
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'N590WFsWH6I',
                name: 'Female condoms distributed',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Uxv4TUy4oWR',
                name: 'Male condoms distributed',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'NKZPXCJ4aG6',
                name: 'Lube condoms distributed',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'cucGYuueADX',
                name: 'Senior counselor/Team Leader name',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
          ]),
    ];
  }
}
