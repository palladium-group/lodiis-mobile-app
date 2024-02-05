import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcEnrollmentChild {
  static List<String> getMandatoryField() {
    return [
      'enrollmentDate',
      'iS9mAp3jDaU',
      'WTZ7GLTrE8Q',
      'rSP9c21JsfC',
      'vIX4GTSCX4P',
      'qZP982qpSPS',
      'pJ5NAEmwnDq',
      'JPNe5w7zeki',
      'JTNxMQPT134',
      'EwZil0AnlYo',
      'f7WkgoF9uib',
      'h1HeZ2eEkGn',
      'NGVFqUVSHiU',
      'oioDyk1WK1j',
      'oSKX8fFQdWc',
      'l7op0btSqSc',
      'iBws3HMjiUT',
      'RDobagXItZ6',
      'KO5NC4pfBmv',
      'cJl00w5DjIL',
      'ZPf4iCd2aw3',
      'JMwIgMSUnlu',
      'wKEQZfKU2jX',
      'R9e8v9r3lMM',
      'd3HviODv676',
      'FBdCMyESsdg',
      'voFec8nlKRX',
      'wmKqYZML8GA',
      'GMcljM7jbNG',
      'Gkjp5XZD70V',
      'Sa0KVprHUr7',
      'wtrZQadTkOL',
      'Mc3k3bSwXNe',
      'CePNVGSnj00',
      'ZKMhrjWoXnD',
      'br1xvwAQ6el',
      'UeF4OvjIIEK',
      'nOgf8LKXS4k',
      'YR7Xxk14qoP',
      'mTv9eZZq0Nz'
    ];
  }

  static List<FormSection> getFormSections({
    required bool isEnrolmentDateEditable,
    required String enrollmentDate,
  }) {
    return [
      FormSection(
        name: '',
        color: const Color(0xFF737373),
        borderColor: const Color(0xFF4B9F46),
        subSections: [
          FormSection(
            name: 'A. Child Personal Information',
            translatedName: 'A. Lintlha tsa boitsebiso ba ngoana',
            color: const Color(0xFF4B9F46),
            inputFields: [
              InputField(
                id: 'enrollmentDate',
                isReadOnly: !isEnrolmentDateEditable,
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                name: 'Date of Enrollment to Program',
                translatedName: "Letsatsi leo lelapa le keneng ka hara morero",
                valueType: 'DATE',
              ),
              InputField(
                id: 'iS9mAp3jDaU',
                name: 'Relationship to Caregiver',
                translatedName: 'Kamano ea ngoana le mohlokomeli',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                      code: 'Biological mother',
                      name: 'Biological mother',
                      translatedName: 'Mè ea u tsoalang'),
                  InputFieldOption(
                      code: 'Biological father',
                      name: 'Biological father',
                      translatedName: 'Ntate ea u tsoalang'),
                  InputFieldOption(
                    code: 'Aunt/Uncle',
                    name: 'Aunt/Uncle',
                    translatedName: 'Ke Malome/Rangoane/Rakhali/’Mangoane',
                  ),
                  InputFieldOption(
                    code: 'Sibling',
                    name: 'Sibling',
                    translatedName: 'Ke ngoaneso',
                  ),
                  InputFieldOption(
                    code: 'Grandparent',
                    name: 'Grandparent',
                    translatedName: 'Ke Nkhono/Ntate-moholo',
                  ),
                  InputFieldOption(
                    code: 'Other',
                    name: 'Other',
                    translatedName: 'E mong',
                  )
                ],
              ),
              InputField(
                id: 'WTZ7GLTrE8Q',
                name: 'First Name',
                translatedName: 'Lebitso la pele',
                regExpValidation: RegExp('^[A-Za-z]{0,}'),
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 's1HaiT6OllL',
                name: 'Middle Name',
                translatedName: 'Lebitso le mahareng',
                regExpValidation: RegExp('^[A-Za-z]{0,}'),
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'rSP9c21JsfC',
                name: 'Surname',
                translatedName: 'Le Fane',
                regExpValidation: RegExp('^[A-Za-z]{0,}'),
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'vIX4GTSCX4P',
                name: 'Sex',
                translatedName: 'Boleng',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                renderAsRadio: true,
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
                id: 'tNdoR0jYr7R',
                name: 'Phone Number',
                translatedName: 'Nomoro ea mohala',
                valueType: 'PHONE_NUMBER',
                isReadOnly: true,
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'qZP982qpSPS',
                name: 'Date of Birth',
                translatedName: 'Letsatsi la tsoalo ',
                valueType: 'DATE',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                lastDate: enrollmentDate,
                maxAgeInYear: 17,
                numberOfMonth: 11,
                minAgeInYear: 0,
                hint: "Beneficiary's age should be from 0 - 17 years",
                translatedHint: "Lilemo tsa setho li be pakeng tsa 0 le 17",
              ),
              InputField(
                id: 'ls9hlz2tyol',
                translatedName: 'Lilemo',
                name: 'Age',
                isReadOnly: true,
                valueType: 'NUMBER',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'pJ5NAEmwnDq',
                translatedName: 'Ngoana ona le lengolo la tsoalo',
                name: 'Child has birth certificate ',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'JPNe5w7zeki',
                translatedName: 'Nomoro ea lengolo la tsoalo',
                name: 'Birth certificate No',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            name: 'B. Child Education Details',
            translatedName: 'B. Litaba tsa thuto ea ngoana',
            color: const Color(0xFF4B9F46),
            inputFields: [
              InputField(
                id: 'JTNxMQPT134',
                name: 'Child in School',
                translatedName: 'Ngoana o kena sekolo',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'iQdwzVfZdml',
                name: 'Type of school',
                translatedName: 'Mofutoa oa Sekolo',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                renderAsRadio: true,
                options: [
                  InputFieldOption(
                    code: 'Formal',
                    name: 'Formal',
                    translatedName: 'Se ngolisitsoeng',
                  ),
                  InputFieldOption(
                    code: 'Informal',
                    name: 'Informal',
                    translatedName: 'Se sa ngolisoang',
                  ),
                ],
              ),
              InputField(
                id: 'EwZil0AnlYo',
                name: 'Name of school',
                translatedName: 'Lebitso la sekolo ke mang',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'f7WkgoF9uib',
                name: 'What level of school are you in?',
                translatedName: 'Nakong ea joale, u boemong bofe ba sekolo',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                    code: 'Preschool',
                    name: 'Pre-School',
                    translatedName: 'Sekolo sa mathomo',
                  ),
                  InputFieldOption(
                    code: 'PrimaryLevel',
                    name: 'Primary Level',
                    translatedName: 'Sekolo se mahareng',
                  ),
                  InputFieldOption(
                    code: 'SecondaryLevel',
                    name: 'Secondary Level',
                    translatedName: 'Sekolo se phahameng (college/university)',
                  ),
                  InputFieldOption(
                    code: 'TertiaryLevel',
                    name: 'Tertiary Level',
                    translatedName: 'Sekolo sa mosebetsi oa matsoho',
                  ),
                  InputFieldOption(
                    code: 'VocationalLevel',
                    name: 'Vocational Level',
                    translatedName: 'Sekolo se seng',
                  ),
                ],
              ),
              InputField(
                id: 'h1HeZ2eEkGn',
                name: 'Which class are you currently enrolled?',
                translatedName: 'Sehlopha',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'NGVFqUVSHiU',
                name: 'Which form are you currently enrolled?',
                translatedName: 'Foromo',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'oioDyk1WK1j',
                name: 'Boarding status?',
                translatedName: 'U lula sekolong kapa o orohela hae?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                renderAsRadio: true,
                options: [
                  InputFieldOption(code: 'Boarding', name: 'Boarding'),
                  InputFieldOption(code: 'DayScholar', name: 'Day Scholar'),
                ],
              ),
            ],
          ),
          FormSection(
            name: 'C. Child Health Details',
            translatedName: 'C. Litaba tsa bophelo ba ngoana',
            color: const Color(0xFF4B9F46),
            inputFields: [
              InputField(
                id: 'oSKX8fFQdWc',
                name: "Child's HIV status",
                translatedName:
                    'Sephetho sa ngoana sa tlhahlobo ea ho qetela sa HIV sene se reng?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT',
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
                      translatedName: 'Ha ho Karabo'),
                ],
              ),
              InputField(
                id: 'l7op0btSqSc',
                name: 'Is child on ART?',
                translatedName: 'ngoana o litlhareng tsa ART?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                valueType: 'BOOLEAN',
              ),
              InputField(
                id: 'iBws3HMjiUT',
                name: 'Facility obtaining ART',
                showCountryLevelTree: true,
                translatedName:
                    'Setsi seo ngoana a fumanang litlhare ART ke se fe?',
                allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                valueType: 'ORGANISATION_UNIT',
              ),
              InputField(
                id: 'aX0niP9AH6t',
                name: 'ART No.',
                translatedName: 'Nomoro ea ART.',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT',
              ),
              InputField(
                id: 'EIMgHQW61kx',
                name: 'Date of initiation',
                translatedName:
                    'Letsatsi leo ngoana a qalileng litlare tsa ART ka lona?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                valueType: 'DATE',
              ),
              InputField(
                id: 'isPgJvbU8tT',
                name: 'Child age-appropriate immunization Status (0-5yrs)',
                translatedName:
                    'Naa ngoana o entile li ente tsohle tse lokelang?  (0-5yrs)',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT',
                options: [
                  InputFieldOption(
                    code: 'FullyImmunized',
                    name: 'Fully Immunized',
                    translatedName: 'O qetile li ente',
                  ),
                  InputFieldOption(
                    code: 'NotCompleted',
                    name: 'Not Completed',
                    translatedName: 'Ha a qeta li ente',
                  ),
                  InputFieldOption(
                    code: 'NotImmunized',
                    name: 'Not Immunized',
                    translatedName: 'Ha aso ente',
                  ),
                  InputFieldOption(
                    code: 'NotKnown',
                    name: 'Not Known',
                    translatedName: 'Ha ke tsebe',
                  ),
                ],
              ),
              InputField(
                id: 'RDobagXItZ6',
                name: 'Type of beneficiary',
                translatedName: 'Mofuta oa ngoliso ea ngoana',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                renderAsRadio: true,
                options: [
                  InputFieldOption(code: 'New', name: 'New'),
                  InputFieldOption(
                      code: 'Re-enrolled',
                      name: 'Re-enrolled',
                      translatedName: 'Ngoliso phetho')
                ],
              ),
              InputField(
                id: 'KO5NC4pfBmv',
                name: 'Is this a primary child?',
                translatedName:
                    'Na ngoana ke ena oa mantlha eo morero o keneng ka ena ka lapeng?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                valueType: 'BOOLEAN',
              ),
            ],
          ),
        ],
      ),
      FormSection(
        name: 'D. Child Biological Parents Details',
        translatedName: 'D. Lintlha tsa batsoali ba ngoana',
        color: const Color(0xFF737373),
        borderColor: const Color(0xFFFE7503),
        inputFields: [
          InputField(
              id: 'cJl00w5DjIL',
              name: 'Is father alive?',
              translatedName: "Naa ntate oa ngoana o ntse a phela?",
              valueType: 'TEXT',
              inputColor: const Color(0xFFFE7503),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(code: 'Yes', name: 'Yes', translatedName: 'E'),
                InputFieldOption(code: 'No', name: 'No', translatedName: 'Che'),
                InputFieldOption(
                    code: "Don't Know",
                    name: "Don't Know",
                    translatedName: 'Ha ke tsebe'),
              ]),
          InputField(
            id: 'ZPf4iCd2aw3',
            name: "Father's name",
            translatedName: 'Lebitso la pele lea ntate oa ngoana',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'zKKeQ5pTCAd',
            name: 'Middle Name',
            translatedName: 'Lebitso le bohareng la ntate oa ngoana',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'JMwIgMSUnlu',
            name: 'Surname',
            translatedName: 'Fane ea ntate oa ngoana',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'PvLva3TSY9N',
            name: 'Date of birth',
            translatedName: 'Letsatsi la tsoalo la ntate',
            valueType: 'DATE',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
            minAgeInYear: 18,
            hint: "Beneficiary's age should be 18 years and above",
            translatedHint: "Lilemo tsa setho li be 18+",
          ),
          InputField(
            id: 'NzeeDnWJsNU',
            name: 'Phone number',
            translatedName: 'Nomoro ea mohala ea ntate',
            valueType: 'PHONE_NUMBER',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'tbpqNLJotOi',
            name: 'HIV status',
            translatedName:
                'Sephetho sa ntate sa tlhatlhobo ea ho qetela sa HIV se reng?',
            valueType: 'TEXT',
            inputColor: const Color(0xFFFE7503),
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
                  translatedName: 'Ha ho Karabo'),
            ],
          ),
          InputField(
            id: 'xJfScNlfNS2',
            name: 'Is father on ART',
            translatedName: 'Naa ntate o noa litlhare tsa ART?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'IWFLOoEtisa',
            name: 'Facility obtaining ART',
            translatedName:
                'Setsi sa bophelo moo ntate a fumanang litlhare tsa ART ke se fe?',
            valueType: 'ORGANISATION_UNIT',
            allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
            showCountryLevelTree: true,
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'wKEQZfKU2jX',
            name: 'Cause of death',
            translatedName: 'Sesosa sa lefu la ntate ene ele se fe? ',
            valueType: 'TEXT',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'HIVRelated',
                name: 'HIV Related',
                translatedName: 'Mafu a amahanngoang le HIV',
              ),
              InputFieldOption(
                  code: 'DoNotKnow',
                  name: 'Do Not Know',
                  translatedName: 'Ha ke tsebe'),
              InputFieldOption(
                code: 'OtherCauses',
                name: 'Other Causes',
                translatedName: 'Mafu a mang',
              ),
            ],
          ),
          InputField(
              id: 'R9e8v9r3lMM',
              name: 'Is mother alive?',
              translatedName: "Naa 'M'e oa ngoana o ntse a phela?",
              valueType: 'TEXT',
              inputColor: const Color(0xFFFE7503),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(code: 'Yes', name: 'Yes', translatedName: 'E'),
                InputFieldOption(code: 'No', name: 'No', translatedName: 'Che'),
                InputFieldOption(
                    code: "Don't Know",
                    name: "Don't Know",
                    translatedName: 'Ha ke tsebe'),
              ]),
          InputField(
            id: 'd3HviODv676',
            name: "Mother's name",
            translatedName: "Lebitso la pele la 'm'e oa ngoana",
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'Zv8FOfjPZzm',
            name: 'Middle Name',
            translatedName: "Lebitso le bohareng la 'm'e oa ngoana",
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'FBdCMyESsdg',
            name: 'Surname',
            translatedName: "Fane ea 'm'e oa ngoana",
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'or2YNqJqVqZ',
            name: 'Date of birth',
            translatedName: "Letsatsi la tsoalo la 'm'e",
            valueType: 'DATE',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
            minAgeInYear: 18,
            hint: "Beneficiary's age should be 18 years and above",
            translatedHint: "Lilemo tsa setho li be 18+",
          ),
          InputField(
            id: 'rP7oCRukLkq',
            name: 'Phone number',
            translatedName: "Nomoro ea mohala ea 'm'e",
            valueType: 'PHONE_NUMBER',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'nO38lKlKHYi',
            name: 'HIV status',
            translatedName:
                "Sephetho sa 'm'e sa tlhatlhobo ea ho qetela sa HIV se reng?",
            valueType: 'TEXT',
            inputColor: const Color(0xFFFE7503),
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
                  translatedName: 'Ha ho Karabo'),
            ],
          ),
          InputField(
            id: 'PAv1sKQn2hO',
            name: 'Is mother on ART',
            translatedName: "Naa 'm'e o noa litlhare tsa ART?",
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'fa0BSFwqQGQ',
            name: 'Facility obtaining ART',
            translatedName:
                "Setsi sa bophelo moo 'm'e a fumanang litlhare tsa ART ke se fe?",
            valueType: 'ORGANISATION_UNIT',
            allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
            showCountryLevelTree: true,
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'voFec8nlKRX',
            name: 'Cause of death',
            translatedName: "Sesosa sa lefu la 'm'e ene ele se fe?",
            valueType: 'TEXT',
            inputColor: const Color(0xFFFE7503),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'HIVRelated',
                name: 'HIV Related',
                translatedName: 'Mafu a amahanngoang le HIV',
              ),
              InputFieldOption(
                  code: 'DoNotKnow',
                  name: 'Do Not Know',
                  translatedName: 'Ha ke tsebe'),
              InputFieldOption(
                code: 'OtherCauses',
                name: 'Other Causes',
                translatedName: 'Mafu a mang',
              ),
            ],
          ),
        ],
      ),
      FormSection(
        name: 'E. Child Vulnerability',
        color: const Color(0xFF737373),
        borderColor: const Color(0xFFB0C7EA),
        inputFields: [
          InputField(
            id: 'wmKqYZML8GA',
            name: '1. Child living with HIV?',
            translatedName: "1. Na ngoana o phela le ts'oaetso ea HIV?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'GMcljM7jbNG',
            name: '2. HIV exposed infants (HEI)?',
            translatedName:
                "2. Na ke ngoana ea tsoetsoeng ke 'm'e ea phelang le ts'oaetso ea HIV (HEI)?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'Gkjp5XZD70V',
            name: '3. Child Exposed/Experiencing Violence and Abuse (CEVA)?',
            translatedName:
                "3. Na ke ngoana ea tobaneng/phelang ka hara pefo le tlhekefetso (CEVA)?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'Sa0KVprHUr7',
            name: 'When did the violence or abuse happen?',
            translatedName: "Pefo/tlhekefetso e etsahetse neng?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'TEXT',
            options: [
              InputFieldOption(
                code: '0-3 months ago',
                name: '0-3 months ago',
                translatedName: '0-3 likhoeli tse fetileng',
              ),
              InputFieldOption(
                code: '4-6 months ago',
                name: '4-6 months ago',
                translatedName: '4-6 likhoeli tse fetileng',
              ),
              InputFieldOption(
                code: '7-12 months ago',
                name: '7-12 months ago',
                translatedName: '7-12 likhoeli tse fetileng',
              ),
            ],
          ),
          InputField(
            id: 'wtrZQadTkOL',
            name: 'What type of violence /abuse did child experience?',
            translatedName:
                "Ke mofuta o fe oa pefo / tlhekefetso oo ngoana a kileng a tobala le oona?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'CHECK_BOX',
            options: [
              InputFieldOption(
                  code: 'm26lCJGANwu',
                  name: 'Sexual',
                  translatedName: 'Tlhekefetso ka Motabo'),
              InputFieldOption(
                  code: 'BGJgzqszT0H',
                  name: 'Economic/Neglect',
                  translatedName: 'Tlhekefetso moruong'),
              InputFieldOption(
                  code: 'WAjYVtFWI2n',
                  name: 'Physical',
                  translatedName: 'Tlhekefetso Mmeleng'),
              InputFieldOption(
                  code: 'lm4BA6iOdlI',
                  name: 'Emotional',
                  translatedName: 'Tlhekefetso maikutlong'),
            ],
          ),
          InputField(
            id: 'Mc3k3bSwXNe',
            name: 'Action taken?',
            translatedName:
                "Na ho na le bohato bo ileng ea nkoa ka mora tlhekefetso?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'CePNVGSnj00',
            name: 'What type of action was taken?',
            translatedName: "Ke bohato ba mofuta o fe bo ileng ba nkoa?*",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'CHECK_BOX',
            options: [
              InputFieldOption(
                  code: 'yI8xKOrRN9a',
                  name: 'Health Facility',
                  translatedName: 'Setsi sa bophelo'),
              InputFieldOption(
                  code: 'ftRPTznAqUn',
                  name: 'Police - CGPU',
                  translatedName: 'Mapoleseng'),
              InputFieldOption(
                  code: 'FVBsqRoLGYW', name: 'Chief', translatedName: 'Morena'),
              InputFieldOption(
                  code: 'PoQuVkWjI4K',
                  name: 'Councilor',
                  translatedName: 'Mocouncilor'),
              InputFieldOption(
                  code: 'mM0mGp695z4',
                  name: 'Social Worker',
                  translatedName: 'Mohlabolli'),
              InputFieldOption(
                  code: 'Yu4SpTnnAqb',
                  name: 'Other',
                  translatedName: 'Tse ling'),
            ],
          ),
          InputField(
            id: 'GM2mJDlGZin',
            name: 'Specify other type of action taken',
            translatedName: "Hlalosa mofuta o mong oa ts'ebetso e entsoeng",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'TEXT',
          ),
          InputField(
            id: 'ZKMhrjWoXnD',
            name: '4. Child of People Living with HIV (CPLHIV)?',
            translatedName:
                "4. Na ke ngoana oa batsoali ba phelang le ts'oaetso ea HIV (CPLHIV)?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'br1xvwAQ6el',
            name: '5. Child of a sex worker (CFSW)?',
            translatedName:
                "5. Na ke ngoana oa 'm'e ea hoebang ka 'mele (CFSW)?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'UeF4OvjIIEK',
            name: '6. Is the child an orphan?',
            translatedName: '6. Na ngoana ke khutsana?',
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'nOgf8LKXS4k',
            name: 'Orphan status?',
            translatedName: 'Boemo ba likhutsana?',
            valueType: 'TEXT',
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Single Orphan(Mother)',
                  name: 'Single Orphan(Mother Died)',
                  translatedName: 'Khutsana ka Motsoali a le mong(mme)'),
              InputFieldOption(
                  code: 'Single Orphan(Father)',
                  name: 'Single Orphan(Father Died)',
                  translatedName: 'Khutsana ka Motsoali a le mong (ntate)'),
              InputFieldOption(
                  code: 'Double Orphan',
                  name: 'Double Orphan (Father & Mother Died)',
                  translatedName: 'Khutsana Khulu (ntate le mme)')
            ],
          ),
          InputField(
            id: 'YR7Xxk14qoP',
            name: '7. Is the Child Living with Disabilities (CLD)?',
            translatedName: '7. Na ngoana o phela le bokooa (CLD)?',
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'YR7Xxk14qoP_checkbox',
            name: 'What type of disabilities?',
            translatedName: 'Ke mofuta o fe oa bokooa?',
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'CHECK_BOX',
            options: [
              InputFieldOption(
                  code: 'dufGxx0KVg0',
                  name: 'acquired brain injury',
                  translatedName: 'lemetseng bokong'),
              InputFieldOption(
                  code: 'nfp9NHLf25K',
                  name: 'autism spectrum disorder',
                  translatedName: 'bothata ba autism spectrum'),
              InputFieldOption(
                  code: 'tbLVGG4zDrJ',
                  name: 'deaf or hard hearing',
                  translatedName: 'setholo kapa kutlo e thata'),
              InputFieldOption(
                  code: 'ULr0tYkjTTB',
                  name: 'intellectual disability',
                  translatedName: 'bokooa ba kelello'),
              InputFieldOption(
                  code: 'BfbiOanp9Pi',
                  name: 'mental health conditions',
                  translatedName: 'maemo a bophelo bo botle ba kelello'),
              InputFieldOption(
                  code: 'X3MQhmVA1Jt',
                  name: 'physical disability',
                  translatedName: 'ho holofala mmeleng'),
              InputFieldOption(
                  code: 'TPRVr4ua9f9',
                  name: 'vision impairment',
                  translatedName: 'ho senyeha ha pono'),
            ],
          ),
          InputField(
            id: 'mTv9eZZq0Nz',
            name: 'Which is the primary vulnerability?',
            translatedName: 'Tlokotsi ea mantlha ea ngoana ke e fe?',
            isReadOnly: true,
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'TEXT',
            options: [
              InputFieldOption(
                code: 'Orphan',
                name: 'Orphan',
                translatedName: 'Khutsana',
              ),
              InputFieldOption(
                code: 'Child living with disability',
                name: 'Child living with disability (CLD)',
                translatedName: 'Ngoana ea phelang ka bokooa (CLD)',
              ),
              InputFieldOption(
                code: 'Child living with HIV',
                name: 'Child living with HIV',
                translatedName: 'Ngoana ea phelang le HIV',
              ),
              InputFieldOption(
                code: 'Child of PLHIV',
                name: 'Child of People Living with HIV (CPLHIV)?',
                translatedName:
                    "Na ke ngoana oa batsoali ba phelang le ts'oaetso ea HIV (CPLHIV)?",
              ),
              InputFieldOption(
                code: 'HIV exposed infants',
                name: 'HIV exposed infants',
                translatedName: 'HIV e pepesa masea',
              ),
              InputFieldOption(
                code: 'Child of a sex worker (FSW)',
                name: 'Child of a sex worker (CFSW)',
                translatedName:
                    "Na ke ngoana oa 'm'e ea hoebang ka 'mele (CFSW)",
              ),
              InputFieldOption(
                code:
                    'Child exposed/experiencing violence and abuse (Survivors of Vac)',
                name: 'Child Exposed/Experiencing Violence and Abuse (CEVA)',
                translatedName:
                    'Na ke ngoana ea tobaneng/phelang ka hara pefo le tlhekefetso (CEVA)',
              ),
              InputFieldOption(
                code: 'Sibling',
                name: 'Sibling',
              )
            ],
          ),
          InputField(
              id: 'omUPOnb4JVp',
              name:
                  'Are there other vulnerabilities? (Beyond the identified seven)',
              translatedName:
                  'Na ngoana o na le litlokotsi tse ling? (ka thoko ho tse ka holimo tse supileng)',
              inputColor: const Color(0xFFB0C7EA),
              labelColor: const Color(0xFF737373),
              valueType: 'BOOLEAN'),
          InputField(
            id: 'WsmWkkFBiT6',
            name: 'Other vulnerability (Beyond the identified seven)',
            translatedName:
                'Tlokotsi e nngoe (ka thoko ho tse supileng tse ka holimo)',
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'TEXT',
          ),
        ],
      ),
    ];
  }
}
