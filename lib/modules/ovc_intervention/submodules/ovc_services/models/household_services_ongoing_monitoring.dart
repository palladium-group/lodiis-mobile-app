import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class HouseholdServicesOngoingMonitoring {
  static List<FormSection> getFormSections() {
    return [
      FormSection(
          id: 'Health',
          name: 'DOMAIN HEALTH',
          translatedName: 'BOPHELO BO BOTLE',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [
            InputField(
                id: 'PcLhqLEjKGw',
                name: 'HIVS&D Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa HIVS&D',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'DC4B9EIMZN9',
                name: 'HTS Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa HTS',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'TACaGIXmXMs',
                name: 'HIV ADHERANCE SUPPORT Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa HIV ADHERANCE SUPPORT',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'yOoWkd9dHsJ',
                name: 'HIVTREAT Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa HIVTREAT',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'QvFFo0xqZCy',
                name: 'SAIDS Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa SAIDS',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'gtXZARFG9Pa',
                name: 'FOOD SUPPORT Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa FOOD SUPPORT',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'HKNayBlUGII',
                name: 'Nutrition Messaging Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa Nutrition Messaging',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'JINWcteYR7D',
                name: 'FOOD PREV Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa FOOD PREV',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'BLuel6eSkV3',
                name: 'FOOD PREP Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa FOOD PREP',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'qezhtOHXgaK',
                name: 'WASH MESSAGING Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa WASH MESSAGING',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'W4UjM09aOEw',
                name: 'SOACKAGE PIT Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa SOACKAGE PIT',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'TaSyHHXKYhF',
                name: 'TIPPY TAP Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa TIPPY TAP',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'kWyCcWCVJjv',
                name: 'PRG&L Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa PRG&L',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'fySDvo8AXNy',
                name: 'ANY HEALTH RELATED Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa ANY HEALTH RELATED',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373))
          ]),
      FormSection(
          id: 'Stable',
          name: 'DOMAIN STABLE',
          translatedName: 'BOTSITSO',
          color: const Color(0xFF0000FF),
          borderColor: const Color(0xFF0000FF),
          inputFields: [
            InputField(
                id: 'wNUBfCAg3Fq',
                name: 'SILC Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa SILC',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF0000FF),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'legjCg7fomo',
                name: 'K/TPLOTS Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa K/TPLOTS ',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF0000FF),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'QD77bNjavza',
                name: 'FINANCIAL EDUCATION  Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa FINANCIAL EDUCATION ',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF0000FF),
                labelColor: const Color(0xFF737373)),
          ]),
      FormSection(
          id: 'Safe',
          name: 'DOMAIN SAFE',
          translatedName: 'TSIRELETSO',
          color: const Color(0xFF0F9587),
          borderColor: const Color(0xFF0F9587),
          inputFields: [
            InputField(
                id: 'XPFvUiqedGQ',
                name: 'LEGALPROT Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa LEGALPROT',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF0F9587),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'zYjncKPdz9C',
                name: 'BIRTHCERT Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa BIRTHCERT',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
                ],
                inputColor: const Color(0xFF0F9587),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'es23GNgSa7N',
                name: 'VAC/VAC Messaging Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa VAC/VAC Messaging',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF0F9587),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'x3FxC6Bw139',
                name: 'VAC Legal Messaging progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa VAC Legal Messaging',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF0F9587),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'J5Tw8gd59Aq',
                name: 'COUNSELLING  Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa COUNSELLING',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF0F9587),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'UqQEuWwhwBd',
                name: 'RTEEN/Parenting Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa RTEEN/Parenting',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF0F9587),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'JgokYFY6IWK',
                name: 'P&FC Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa P&FC',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF0F9587),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'ouQhwyHxW0W',
                name: 'SHELTER  Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa SHELTER',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF0F9587),
                labelColor: const Color(0xFF737373)),
          ]),

      FormSection(
          id: '',
          name: 'For those who were referred and changing HIV status',
          translatedName: 'Sebakeng sa ba fetisitsoeng le ba fetotseng sephetho sa tsoaetso ea HIV',
          color: const Color(0xFF4D9E49),
          inputFields: [

            InputField(
              id: 'BvNaiaoxc6w',
              name: 'Has the caregiver ever been tested for HIV?',
              translatedName: 'Mohlokomeli o kile a hlahlobela HIV?',
              description: 'If no refer for testing',
              translatedDescription: 'Ha asa hlahloba  fetesitsa setsing sa tlhabollo',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
              //    isReadOnly: true
            ),

            InputField(
                id: 'Uv26fX0HQvO',
                name: 'If ever tested, when?',
                translatedName: 'Haeba Karabo le “E”, neng',
                description:
                'If over six months (or their window period) refer for testing ',
                translatedDescription:
                'Ha sephetho se feta khoeli tse 6 fetesitsa setsing sa tlhabollo',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                    code: 'Less than 3 months',
                    name: 'Less than 3 months',
                    translatedName: 'Ka tlasa likhoeli tse 3',
                  ),
                  InputFieldOption(
                    code: 'Three months to twelve months',
                    name: 'Three months to twelve months',
                    translatedName: 'Likhoeling tse 3 ho isa ho tse 12',
                  ),
                  InputFieldOption(
                    code: 'More than 1 year',
                    name: 'More than 1 year',
                    translatedName: 'Ho feta selemo',
                  ),
                  /*        InputFieldOption(
                      code: 'Above 12 months ago',
                      name: 'Above 12 months ago',
                      translatedName:
                          'Ka holimo ho likhoeli tse 12 tse fetileng'), */
                ],
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)
            ),
            /*    InputField(
                id: 'T4grVrCVDkk',
                name:
                    '8. Would you be willing to share your HIV test result with me?',
                translatedName:
                    '8. Na u ka ba le bolokolohile ba ho mpolella sephetho sa tlhahlobo eo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                isReadOnly: true), */
            InputField(
                id: 'vNeOE9abQBB',
                name: 'What were the results of your last HIV test?',
                translatedName: 'Boemo ba hau ba HIV ke bofe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),

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
                  /*            InputFieldOption(
                      code: 'No Response',
                      name: 'No Response',
                      translatedName: 'Ha ho Karabo') */
                ]),
            /*InputField(
              id: 'blod3xZ2dPP',
              name: '9. Are you currently taking ART to treat HIV?',
              translatedName: '9. Na u tlasa kalafo ea lefu la HIV ha joale?',
              description: 'If no, refer to HIV care and treatment services.',
              translatedDescription:
                  'Ha ase tlasa kalafo fetisetsa setsing sa kalafo.',
              valueType: 'TEXT',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
              options: [
                InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                InputFieldOption(code: '0', name: 'No', translatedName: 'Che'),
                InputFieldOption(
                    code: '0.000001', name: 'NA', translatedName: 'N/A')
              ],
            ),*/


            InputField(
              id: 'Icgkv0xkUow',
              name: 'Are you currently taking ART to treat HIV?',
              translatedName: 'Na u tlasa kalafo ea lefu la HIV ha joale?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),


            InputField(
                id: 'ubin7MjQ5OI',
                name: 'How long have you been on ART?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'less than six months',
                      name: 'less than six months'),
                  InputFieldOption(
                      code: 'more than six months',
                      name: 'more than six months'),
                  /*            InputFieldOption(
                      code: 'more than one year',
                      name: 'more than one year'),
                  InputFieldOption(code: 'NA', name: 'NA') */
                ]),
            /*      InputField(
                id: 'Icb6vUJXVDX',
                name: '11. Do you take your treatments daily and on time?',
                translatedName:
                    '11. Na u noa litlhare tsa hau hantle (ka mehla ka nako)?',
                description:
                    'If no or not regularly, refer to HIV care and treatment.',
                translatedDescription:
                    'Ha ese ka mehla fetisetsa setsing sa kalafo.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Too many side effects',
                      name: 'No, too many side effects',
                      translatedName:
                          'Che, mat’soao a mangata a khahlanong le tsona'),
                  InputFieldOption(
                      code: 'Treatment not regularly available',
                      name: 'No, treatment is not regularly available',
                      translatedName: 'Che, kalafo ha e fumanehe nako eohle.'),
                  InputFieldOption(
                      code: 'Someone will find out',
                      name:
                          'No, scared that someone will find out that I? living with HIV',
                      translatedName:
                          'Che, ke t’saba hore hona le motho a tla tseba hore ke phela le HIV'),
                  InputFieldOption(
                      code: 'No, it? hard to remember',
                      name: 'No, it? hard to remember',
                      translatedName: 'Che, kea lebala '),
                  InputFieldOption(
                      code: 'I take it on time and regularly',
                      name: 'Yes, I take it on time and regularly',
                      translatedName: 'E, ke li nka ka nako, ka mehla '),
                  InputFieldOption(
                      code: 'Yes, but not regularly',
                      name: 'Yes, but not regularly',
                      translatedName: 'E, fela eseng mehlaena'),
                  InputFieldOption(
                      code: 'Other', name: 'Other', translatedName: 'Tse ling'),
                  InputFieldOption(
                      code: 'NA', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'IiKxc53TdqL',
                name: 'Other, Specify (treatment taking)',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)), */
            InputField(
                id: 'sLyfb45aLkl',
                name: 'Have you ever had a blood test called viral load?',
                translatedName: 'U kile oa etsa hlahlobo ea mali bakeng sa boemo ba t’soaetso bo maling (viral load)?',
                description: 'If taking ART for over six months and not tested refer to viral load test.',
                translatedDescription: 'Haeba a le litlhareng ho feta khoeli tse tseletseng eba ha a so hlahlobe mali, fetisetsa setsing bakeng sa tlahobo.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(code: '0', name: 'No', translatedName: 'Che'),
                  //  InputFieldOption(code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'aRNGDZcwWmS',
                name: 'What was the result of your viral load test?',
                translatedName: 'Sephetho sa tlhahlobo eo ea mali se ne se reng?',
                description: 'Note to Case Management Workers, they do not have to know exact numbers just whether it was high, low or undetectable.',
                translatedDescription: 'Tlhokomeliso ho Mosebeletsi oa morero, ha ba tlameha ho tseba palo tse nepahetseng empa hore na e holimo kapa e tlase.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'High (above 1,000 copies/ml)',
                      name: 'High (above 1,000 copies/ml)',
                      translatedName: 'E holimo'),
                  InputFieldOption(
                      code: 'Low (51-999 copies/ml)',
                      name: 'Low (51-999 copies/ml)',
                      translatedName: 'E tlase'),
                  InputFieldOption(
                      code: 'Undetectable (0-50 copies/ml)',
                      name: 'Undetectable (0-50 copies/ml)',
                      translatedName: 'Ha e bonahale'),
                  InputFieldOption(
                      code: 'Not documented',
                      name: 'Not documented',
                      translatedName: 'Ha a tsebe'),
                  /*    InputFieldOption(
                      code: 'Don? know',
                      name: 'Don? know',
                      translatedName: 'Ha a tsebe'),
                  InputFieldOption(
                      code: 'NA', name: 'NA', translatedName: 'N/A') */
                ]),

            InputField(
              id: 'P52dMXyK4eA',
              name: 'Have you received VL testing as per schedule?',
              translatedName: 'Na u ntse u fumana liphetho tsa liteko tsa VL ka nako e nepahetseng?',
              description: 'Normal: 6 months then annual; Pregnant every 3 months; Breastfeeding every 3 months',
              translatedDescription: 'Normal: 6 months then annual; Pregnant every 3 months; Breastfeeding every 3 months',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

            InputField(
              id: 'tYN12Es3707',
              name: 'If virally unsuppressed, do you have CD4 results?',
              translatedName: 'U na le sephetho sa CD4 na?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

            InputField(
                id: 'o1GBFscjs4y',
                name: 'What are the CD4 results?',
                translatedName: 'Sephetho sa tlhahlobo eo ea CD4 se ne se reng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                    code: 'Less than 200cells',
                    name: 'Less than 200cells',
                    /* translatedName: 'E holimo'*/),
                  InputFieldOption(
                    code: 'More than 200cells',
                    name: 'More than 200cells',
                    /* translatedName: 'E tlase'*/),
                  InputFieldOption(
                    code: 'Not documented',
                    name: 'Not documented',
                    /*translatedName: 'Ha a tsebe'*/),
                ]),


            InputField(
                id: 'BYZu8p33lzP',
                name: 'Have you disclosed your status to anyone?',
                translatedName:
                'Na ho na le motho eo u kileng oa mojoetsa boemo ba hau ba HIV?',
                description: 'Refer to HIV support services if no',
                translatedDescription:
                'Fetisetsa setsing bakeng sa litsebeletso tsa t’sehetso ea HIV ha karabo ele che.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),

                ]),
            InputField(
                id: 'ToWhhydys',
                name: 'To whom have you disclosed your status?',
                translatedName:
                'Ke mang eo u mo joetsitseng ka boemo a hao a HIV?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Dl3tIlQxsrd',
                      name: 'My child',
                      translatedName: 'Ngoana oaka'),
                  InputFieldOption(
                      code: 'CHuwbETwj8o',
                      name: 'My spouse',
                      translatedName: 'Molekane oaka'),
                  InputFieldOption(
                      code: 'MJGmlQevBsM',
                      name: 'A friend/neighbor',
                      translatedName: 'Motsoalle/Moahisane '),
                  InputFieldOption(
                      code: 'pCHKaQptcwn',
                      name: 'Boyfriend/ girlfriend',
                      translatedName: 'Mohlankana oaka/Kharebe eaka'),
                  InputFieldOption(
                      code: 'Wfu966TC3M5',
                      name: 'Member of the family',
                      translatedName: 'Moruti'),
                  InputFieldOption(
                      code: 'J5hjKDmiE6a',
                      name: 'Pastor or priest',
                      translatedName: 'Moruti kapa moprista'),
                  InputFieldOption(
                      code: 'HLPSkYfLYlS',
                      name: 'Other',
                      translatedName: 'Tse ling'),
                  // InputFieldOption(
                  //     code: 'mSc4D4Ij3KN', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'I3hI2UTkKyx',
                name: 'Other, Specify (disclosed HIV status to)',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),

            InputField(
              id: 'pJ1UrnLU9mh',
              name: 'Is the caregiver Preganant?',
              translatedName:
              "Na mohlokomeli o mmeleng?",
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),

            InputField(
              id: 'dCIDHw3RrQ9',
              name: 'Is the caregiver Breastfeeding?',
              translatedName:
              "Na mohlokomeli oa ants'a?",
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),

            InputField(
                id: 'KFCBwn7ypws',
                name:
                'Do you feel like you are supported enough regarding your HIV status?',
                translatedName:
                'Na u utloa u tshehelitsoe mabapi le boemo ba hao ba HIV?',
                description:
                'If No, voluntarily offer family psychosocial support (Parenting tips)',
                translatedDescription:
                'Fetisetsa ho mosebeletsi oa tsa bophelo Motseng kapa mosebeltsi oa sechaba kapa tlabollong ea maikutlo.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'No Response',
                      name: 'No Response',
                      translatedName: 'Ha hona Karabo'),
                  // InputFieldOption(
                  //     code: 'NA', name: 'NA', translatedName: 'N/A')
                ]),

            InputField(
              id: 'wRhamvRZj87',
              name: 'Bokamoso offers different health education, such as; Oral health messaging and Prevention of child injuries and others Would you like to be given information regarding them?',
              translatedName: 'Bokamoso offers different health education, such as; Oral health messaging and Prevention of child injuries and othersWould you like to be given information regarding them?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

            // InputField(
            //     id: 'jzmOXiyGGgw',
            //     name:
            //         'Do you feel like people treat you differently because you are HIV positive?',
            //     translatedName:
            //         'Na o nahana hore batho ba o khetholla hobane unale le tso’oaetso ea HIV?',
            //     description:
            //         'Refer to Village Health Workers or Social Workers or psychosocial support.',
            //     translatedDescription:
            //         'Fetisetsa ho mosebeletsi oa tsa bophelo Motseng kapa mosebeltsi oa sechaba kapa tlabollong ea maikutlo.',
            //     valueType: 'TEXT',
            //     inputColor: const Color(0xFF4B9F46),
            //     labelColor: const Color(0xFF1A3518),
            //     options: [
            //       InputFieldOption(
            //           code: 'Yes', name: 'Yes', translatedName: 'E'),
            //       InputFieldOption(
            //           code: 'No', name: 'No', translatedName: 'Che'),
            //       InputFieldOption(
            //           code: 'No Response',
            //           name: 'No Response',
            //           translatedName: 'Ha hona Karabo'),
            //       // InputFieldOption(
            //       //     code: 'NA', name: 'NA', translatedName: 'N/A')
            //     ]),



            // InputField(
            //     id: 'How-have-you-coped-with-HIV-related-stigma',
            //     name: '17. How have you coped with HIV-related stigma?',
            //     translatedName:
            //         '17. U atleha ho phela joang tlaasa maemo a ho nenoa kapa ho khetholla ka baka la boemo ba hau ba HIV?',
            //     valueType: 'CHECK_BOX',
            //     inputColor: const Color(0xFF4B9F46),
            //     labelColor: const Color(0xFF1A3518),
            //     options: [
            //       InputFieldOption(
            //           code: 'QPcCByPcMpz',
            //           name: 'I am part of a support group',
            //           translatedName: 'Ke karolo ea support group '),
            //       InputFieldOption(
            //           code: 'klE3cj35whZ',
            //           name:
            //               'I speak with people who I am close with or my family',
            //           translatedName:
            //               'Ke bua le batho ba haufi le nna kapa lelapa laka '),
            //       InputFieldOption(
            //           code: 'FitzDd4bmS6',
            //           name: 'I speak with my doctor',
            //           translatedName: 'Ke bua le ngaka eaka'),
            //       InputFieldOption(
            //           code: 'PXZm9X9pG01',
            //           name: 'I speak with my pastor or priest',
            //           translatedName: 'Ke bua le moruti oaka'),
            //       InputFieldOption(
            //           code: 'XPplaRA9hzd',
            //           name: 'I face it all',
            //           translatedName: 'Ke tobane le bothata bona ke le mong '),
            //       InputFieldOption(
            //           code: 'zNYrqDOIhGO',
            //           name:
            //               'I avoid thinking about it because it’s too difficult',
            //           translatedName:
            //               'Ke qoba ho nahana ka eona hobane e nkimetse.'),
            //       InputFieldOption(
            //           code: 'LGhJJz12mWP',
            //           name: 'I do not face stigma',
            //           translatedName: 'Ha ke so tobane le sekhobo'),
            //       InputFieldOption(
            //           code: 'loGTnsw9R9G',
            //           name: 'Other',
            //           translatedName: 'Tse ling'),
            //       InputFieldOption(
            //           code: 'YT79ydtEOZj', name: 'NA', translatedName: 'N/A')
            //     ]),
            // InputField(
            //     id: 'dfdeOt1y7me',
            //     name: 'Please specify',
            //     translatedName: 'Tse ling, hlakisa',
            //     valueType: 'TEXT',
            //     inputColor: const Color(0xFF4B9F46),
            //     labelColor: const Color(0xFF1A3518)),
            // InputField(
            //     id: 'JYPmeC1Zbwf',
            //     name:
            //         '28. If you have a child or children 10 or over, have you talked to them about how to protect themselves from HIV?',
            //     translatedName:
            //         '28. Haeba u na le ngoana kapa bana ba ka holimo ho lilemo li 10, u kile oa bua le bona ka ho itsireletsa khahlanong le tsoaetso ea HIV?',
            //     valueType: 'TEXT',
            //     inputColor: const Color(0xFF4B9F46),
            //     labelColor: const Color(0xFF1A3518),
            //     options: [
            //       InputFieldOption(
            //           code: 'Yes', name: 'Yes', translatedName: 'E'),
            //       InputFieldOption(
            //           code: 'No', name: 'No', translatedName: 'Che'),
            //       InputFieldOption(
            //           code: 'No Response',
            //           name: 'No Response',
            //           translatedName: 'Ha hona Karabo'),
            //       InputFieldOption(
            //           code: 'NA', name: 'NA', translatedName: 'N/A')
            //     ]),
          ]),

    ];
  }
}
