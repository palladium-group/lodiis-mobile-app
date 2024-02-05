import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';

class OvcServicesOngoingMonitoring {
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
                id: 'GUwNhNgTfpY',
                name: 'CLHIV ART Card Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa CLHIV ART Card',
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
                id: 'A3aXfHkuywQ',
                name: 'CCFLS Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa CCFLS',
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
                id: 'qhTPL1R9OlY',
                name: 'CHILD STIMULATION Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa CHILD STIMULATION',
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
                id: 'FroSdO9AGHb',
                name: 'TB SCREENING Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa TB SCREENING',
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
                id: 'JINWcteYR7D',
                name: 'FOOD PREV Service progress',
                isReadOnly: true,
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
                isReadOnly: true,
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
                id: 'TaSyHHXKYhF',
                name: 'TIPPY TAP Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa TIPPY TAP',
                isReadOnly: true,
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
                id: 'W4UjM09aOEw',
                name: 'SOACKAGE PIT Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa SOACKAGE PIT',
                isReadOnly: true,
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
                isReadOnly: true,
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
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
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
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Kcy88uJjTQl',
                name: 'IMMUNIZATION Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa IMMUNIZATION',
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
                id: 'a7yFGFtZ3U9',
                name: 'MALNUTRITION Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa MALNUTRITION',
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
                id: 'lviiwATI5uv',
                name: 'TB REFFER Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa TB REFFER',
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
                id: 'oOWfgTZr6qL',
                name: 'FOOD SUPPLIMENTS Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa FOOD SUPPLIMENTS',
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
                id: 'gtXZARFG9Pa',
                name: 'FOOD SUPPORT progress',
                isReadOnly: true,
                translatedName: 'Tsoelo-pele ea litšebeletso tsa FOOD SUPPORT',
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
                isReadOnly: true,
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
                id: 'a7GDFMWz1qf',
                name: 'Savings Group Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa Savings Group',
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
            InputField(
                id: 'EG4MGO83vqG',
                name: 'OVCFUND Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa OVCFUND',
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
            InputField(
                id: 'QD77bNjavza',
                name: 'FINANCIAL EDUCATION  Service progress',
                isReadOnly: true,
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
            InputField(
                id: 'legjCg7fomo',
                name: 'K/TPLOTS  Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa K/TPLOTS',
                valueType: 'TEXT',
                isReadOnly: true,
                options: [
                  InputFieldOption(
                      code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                  InputFieldOption(
                      code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                  InputFieldOption(
                      code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
                ],
                inputColor: const Color(0xFF0000FF),
                labelColor: const Color(0xFF737373))
          ]),
      FormSection(
          id: 'Safe',
          name: 'DOMAIN SAFE',
          translatedName: 'TSIRELETSO',
          color: const Color(0xFF0F9587),
          borderColor: const Color(0xFF0F9587),
          inputFields: [
            InputField(
                id: 'KNRkkNs8IeP',
                name: 'SLION Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa SLION',
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
                isReadOnly: true,
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
                isReadOnly: true,
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
                id: 'zYjncKPdz9C',
                name: 'BIRTHCERT  Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa BIRTHCERT',
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
                id: 'HY12JH4WYIl',
                name: 'FCARE  Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa FCARE',
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
            InputField(
                id: 'ngjLjWJjPmN',
                name: 'ABUSE  Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa ABUSE',
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
                id: 'XPFvUiqedGQ',
                name: 'LEGAL PROTECTION  Service progress',
                translatedName: 'Tsoelo-pele ea litšebeletso tsa LEGAL PROTECTION ',
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
        id: 'Schooled',
        name: 'DOMAIN SCHOOLED',
        translatedName: 'TSA SEKOLO',
        color: const Color(0xFF9B2BAE),
        borderColor: const Color(0xFF9B2BAE),
        inputFields: [
          InputField(
              id: 'AKjlaqY2VFZ',
              name: 'Aflatoun/teen Service progress',
              translatedName: 'Tsoelo-pele ea litšebeletso tsa Aflatoun/teen',
              valueType: 'TEXT',
              options: [
                InputFieldOption(
                    code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                InputFieldOption(
                    code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                InputFieldOption(
                    code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
              ],
              inputColor: const Color(0xFF9B2BAE),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'I4vmREMJZug',
              name: 'HOMEWORK CLUB Service progress',
              translatedName: 'Tsoelo-pele ea litšebeletso tsa HWCLUB',
              valueType: 'TEXT',
              options: [
                InputFieldOption(
                    code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                InputFieldOption(
                    code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                InputFieldOption(
                    code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
              ],
              inputColor: const Color(0xFF9B2BAE),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'wJergsqzGLz',
              name: 'BURSARY Service progress',
              translatedName: 'Tsoelo-pele ea litšebeletso tsa BURSARY',
              valueType: 'TEXT',
              options: [
                InputFieldOption(
                    code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                InputFieldOption(
                    code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                InputFieldOption(
                    code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
              ],
              inputColor: const Color(0xFF9B2BAE),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'ks2bazFqWHo',
              name: 'SMATERIAL Service progress',
              translatedName: 'Tsoelo-pele ea litšebeletso tsa SMATERIAL',
              valueType: 'TEXT',
              options: [
                InputFieldOption(
                    code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                InputFieldOption(
                    code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                InputFieldOption(
                    code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
              ],
              inputColor: const Color(0xFF9B2BAE),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'T51fsJaITSM',
              name: 'REENROL Service progress',
              translatedName: 'Tsoelo-pele ea litšebeletso tsa REENROL',
              options: [
                InputFieldOption(
                    code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                InputFieldOption(
                    code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                InputFieldOption(
                    code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
              ],
              valueType: 'TEXT',
              inputColor: const Color(0xFF9B2BAE),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'V8IMX0zD0Of',
              name: 'SFEES Service progress',
              translatedName: 'Tsoelo-pele ea litšebeletso tsa SFEES',
              valueType: 'TEXT',
              options: [
                InputFieldOption(
                    code: 'Incomplete', name: 'Incomplete', translatedName: 'Ha ea phetheloa'),
                InputFieldOption(
                    code: 'Inprogress', name: 'Inprogress', translatedName: 'E mocheng'),
                InputFieldOption(
                    code: 'Completed', name: 'Completed', translatedName: 'E phethetsoe')
              ],
              inputColor: const Color(0xFF9B2BAE),
              labelColor: const Color(0xFF737373))
        ],
      ),
      FormSection(
        id: '',
        name: 'For those who were referred and changing HIV status',
        translatedName:
            'Bakeng sa ba fetiselitsoeng litsing tsa bophelo le bao boemo ba bona ba tšoaetso bo fetohileng',
        color: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
              id: 'gdbL3fKWwXn',
              name: 'Tested for HIV?',
              translatedName: 'Hlahlobile HIV?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373)),
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
          InputField(
              id: 'jiS3es770I1',
              name: 'Has the child been referred for ART?',
              translatedName: 'Has the child been referred for ART?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'ywYdzitJvSi',
              name: 'Was the referred child enrolled for ART services?',
              translatedName: 'Na ngoana o ile a fumana litšebeletso tsa kalafo?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'KgLtXquRot3',
              name: 'Health facility',
              translatedName: 'Setsi sa bophelo bo botle',
              valueType: 'ORGANISATION_UNIT',
              allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
              filteredPrograms: [OvcInterventionConstant.ovcProgramprogram],
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373)),
        ],
      ),
    ];
  }
}
