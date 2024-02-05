import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class ClientInformation {
  static List<String> getIndicationsForPrep() {
    return [
      'kv4FAx1Reck',
      'TRE8eTo7tWl',
      'zNz3aCntxv4',
      'RLoCiIvo12e',
      'yOplJCXAuiK',
      'i46K5YYAxJu',
      'fOAOOFLzuJJ',
      'OXmIVzKnnfX',
      'FHFDusOkEf7',
      'gB1KMAsfA1H',
      'mWO7YHLzyu4',
      'hjKFMOVQ3Kt'
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: 'Client Information',
          translatedName: 'Boitsebiso',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'Dlri7xJ6u0a',
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
                id: 'hh5iJYHnEAr',
                name: 'Priority Pop: OVC 1',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'HWf49rygbTG',
                name: 'Priority Pop: OVC 2',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'BULkcZp7VrF',
                name: 'Priority Pop: Factory/exworker',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'PtoIbExJ2RE',
                name: 'Priority Pop: Mobile',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'OlKIVlexb1I',
                name: 'Priority Pop: Military',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'HthZdwsEkt5',
                name: 'Priority Pop: Miner/ex worker',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'jetCbHYLuZc',
                name: 'Priority Pop: AGYWs',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'IRLf0cgX1Vb',
                name: 'Priority Pop: FSWs',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'FLzk3trHs3w',
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
                id: 'HXUTJfK4T6V',
                name: 'Have you ever had an HIV test before',
                translatedName: 'Na u kile ua etsa tlhahlobo ea HIV pele',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'f8irSIFCXDF',
                name: 'When was the last test',
                translatedName: 'Teko ea ho qetela e ne e le neng',
                valueType: 'DATE',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'JL1rGyJaDnw',
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
                id: 'j2qNW9NsNBv',
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
                id: 'SNGOfhanJia',
                name: 'Pregnant/breastfeeding (clients or partner)',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'CR5xUFmPHVy',
                name: 'Do you know your partners HIV status',
                translatedName:
                    'Na u tseba boemo ba molekane oa hau ba hau ba HIV',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'ODv7ghspcbG',
                name: "what's your partner HIV status",
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
                id: 'DzRsmX6O9V6',
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
                id: 'qS3VY5i86ZB',
                name: 'Number of sexual partners in last 12  months',
                translatedName:
                    "Palo ea balekane ba thobalano likhoeling tse 12 tse fetileng",
                isReadOnly: true,
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
                      code: 'kv4FAx1Reck',
                      name:
                          'Sexual partner with HIV who is not virally suppressed'),
                  InputFieldOption(
                      code: 'TRE8eTo7tWl',
                      name: 'Sexual partner with HIV is not ART'),
                  InputFieldOption(
                      code: 'zNz3aCntxv4',
                      name:
                          'Sexual partner who has been on ART for less than 6 months'),
                  InputFieldOption(
                      code: 'RLoCiIvo12e',
                      name:
                          'Sexual partner who has been on ART for more than 6 months but is not virally suppressed'),
                  InputFieldOption(
                      code: 'yOplJCXAuiK', name: 'Women who want to conceive'),
                  InputFieldOption(
                      code: 'i46K5YYAxJu',
                      name: 'Sexual partner with HIV, even if suppressed'),
                  InputFieldOption(
                      code: 'fOAOOFLzuJJ',
                      name: 'Sexual partner with unknown HIV status'),
                  InputFieldOption(
                      code: 'OXmIVzKnnfX',
                      name:
                          'Vaginal or anal sexual intercourse without condoms with more than one partner in the past six months'),
                  InputFieldOption(
                      code: 'FHFDusOkEf7',
                      name:
                          'A sexual partner with one or more HIV risk factors in the past six months'),
                  InputFieldOption(
                      code: 'gB1KMAsfA1H',
                      name:
                          'A history of a sexually transmitted infection(STI) by lab testing or self-report or syndromic STI syndromic management in the past six months'),
                  InputFieldOption(
                      code: 'mWO7YHLzyu4',
                      name:
                          'Injecting drug user sharing needles and other injecting equipment'),
                  InputFieldOption(
                      code: 'hjKFMOVQ3Kt', name: 'Requesting PrEP'),
                ]),
          ]),
      FormSection(
          name: "Today's HIV test",
          description:
              'Date: ${AppUtil.formattedDateTimeIntoString(DateTime.now())}',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'UlombfpCloG',
                name: 'Client Type',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'Individual', name: 'Individual'),
                  InputFieldOption(code: 'Couple', name: 'Couple')
                ]),
            InputField(
                id: 'hWdE0MXmeuP',
                name: 'Couple UIC',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'GSLu0wyCCsP',
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
              id: 'aoWp3tKXOqa',
              name: 'Other community platforms',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'p2r7Gf6Yqye',
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
                id: 'RXHjnbJAMkz',
                name: 'Other layering',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'FclxLnBHILO',
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
                id: 'D8jPUK4QDxD',
                name: 'Your work',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Employment or Self employmed',
                      name: 'Employment or Self employmed'),
                  InputFieldOption(code: 'Student', name: 'Student'),
                  InputFieldOption(code: 'Unemployed', name: 'Unemployed')
                ]),
            InputField(
                id: 'EHhaJRS2gqc',
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
                      code: 'Partner notification',
                      name: 'Partner notification'),
                  InputFieldOption(
                      code: 'Other friends or relatives',
                      name: 'Other friends or relatives'),
                  InputFieldOption(code: 'Other', name: 'Other'),
                ]),
            InputField(
                id: 'OJfuwI9k15B',
                name: 'Other reasons why decided to get tested',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
          ]),
      FormSection(
          name: 'HIV test',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
                id: 'sPdC9NxNEME',
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
                id: 'ZZcv0xCUXLP',
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
                id: 'nleqA1tu4Gs',
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
                id: 'FweZ4RT9EUI',
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
                id: 'EPNufgY5Q4j',
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
                id: 'U0vFGj8vVzt',
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
                id: 'mhZeM9CuGQn',
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
                id: 'IcJ9QmUV2Mw',
                name: 'Test results given',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'vu6kABBg23g',
                name: 'If HIV+, did client have knowledge of HIV+ status',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'OLM5yg5kW6R',
                name: 'Extra products used: Determine strips',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'MoA0SBuczaP',
                name: 'Extra products used: Capillary tubes',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'j4j5ppqBTDd',
                name: 'Extra products used: Alcohol swabs',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'VKPaCtAS9vg',
                name: 'Extra products used: Unigold strips',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'dnCcoQIVZ1I',
                name: 'Extra products used: Exam gloves',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'GO6QIfHE7Vc',
                name: 'TB Screening conducted',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'WWL1XKS3Hg8',
                name: 'TB Suspected',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'NpGma0GzvBk',
                name: 'Referral offered',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Mcoc57TzQwX',
                name: 'ART referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'O2IpQLJ64pU',
                name: 'DNA PCR referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'MIda6PYnDe3',
                name: 'Fp referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'fPzwReDDMya',
                name: 'PReP (HIV-) referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'YstOYReVQSu',
                name: 'STI Dx/TX referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'HPzl16DToJQ',
                name: 'TB Dx/Tx referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'DGxRatLifox',
                name: 'VMMC referral given to client',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'rvanxUEglQu',
                name: 'Name of referral DNA PCR or ART facility',
                valueType: 'ORGANISATION_UNIT',
                showCountryLevelTree: true,
                allowedSelectedLevels: [
                  AppHierarchyReference.communityLevel,
                  AppHierarchyReference.facilityLevel
                ],
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'tfqVBXrWxyZ',
                name: 'Female condoms distributed',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'uRHUjuCgaJU',
                name: 'Male condoms distributed',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'nUp9TLkqont',
                name: 'Lube condoms distributed',
                valueType: 'TRUE_ONLY',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'qtXzz8JEyFg',
                name: 'Senior counselor/Team Leader name',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
          ]),
    ];
  }
}
