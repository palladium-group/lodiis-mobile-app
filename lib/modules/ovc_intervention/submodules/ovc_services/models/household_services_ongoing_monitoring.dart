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
          name: 'Other activities',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [
            InputField(
              id: 'C06k1O4qrjw',
              name: 'Other activities progress',
              valueType: 'TEXT',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                    code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                InputFieldOption(
                    code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                InputFieldOption(
                    code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe'),
              ],
            )
          ]),
      FormSection(
        id: '',
        name: 'Household ongoing monitoring',
        translatedName: "Tlhokomelo e tsoelang pele ea lelapa",
        color: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
              id: 'kEa51XegbF1',
              name:
                  'Since our last visit, has there been any major positive and/ or negative changes within your family which has affected you?',
              translatedName:
                  'Ho tloha lekhetlong la ho qetela la ketelo ea rona, na ho na le liphethoto tse kholo tse ntle kapa tse mpe tse le ammeng le le lelapa',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'whQroZXYFXl',
              name: 'Positive Changes',
              translatedName: 'Liphetoho tse ntle',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'u7CdxVqH9Cv',
              name: 'Challenges hindering progress',
              translatedName: 'Liqholotso tse sitisang tsoelopele',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'pgjVoHQ4rr7',
              name: 'Has the size of your family changed since our last visit',
              translatedName:
                  'Na palo ea litho tsa lelapa la hau e fetohile ho tloha lekhetlong la ho qetela la ketelo ea rona?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'lHfHlWRFF7C',
              name: 'how?',
              translatedName: 'ho joalo',
              description:
                  'Please note if any child or adult has either joined or left the household',
              translatedDescription:
                  'ka kopo, ela hloko haeba ho na le ngoana kapa motho e moholo ea seng a lula kapa a tsoileng lelapeng leno',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'hf7JylP0eB2',
              name:
                  'Since our last visit, is there other information you would like to share (any changes in the Case Plan that need to be made)?',
              translatedName:
                  'Ho tloha lekhetlong la ho qetela la ketelo ea rona, na ho na le tlhahisoleseling eo o ka ratang ho fana ka eona (na ho na le liphetoho tse hlokang ho etsoa ka hara Case Plan)',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
          id: '',
          name: 'For those who were referred and changing HIV status',
          translatedName: 'Sebakeng sa ba fetisitsoeng le ba fetotseng sephetho sa tsoaetso ea HIV',
          color: const Color(0xFF4D9E49),
          inputFields: [
            InputField(
                id: 'uRsImCXXDXe',
                name: 'HIV status',
                translatedName: 'Sephetho sa tsoaetso ea HIV',
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Positive', name: 'Positive', translatedName: 'T’soaetso e teng'),
                  InputFieldOption(
                      code: 'Negative', name: 'Negative', translatedName: 'T’soaetso haeo'),
                  InputFieldOption(
                      code: 'No Response', name: 'No Response', translatedName: 'Ha ho Karabo'),
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
          ]),
    ];
  }
}
