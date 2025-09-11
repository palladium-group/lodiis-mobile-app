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
      'JTNxMQPT134',
      'EwZil0AnlYo',
      'cFDqjIXQucQ',
      'i6Y27IFBR9b',
      'oioDyk1WK1j',
      'oSKX8fFQdWc',
      'l7op0btSqSc',
      'iBws3HMjiUT',
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
      'NqhUKijE4hB',
      'FYjxxvyugEt',


      /*'Sa0KVprHUr7',
      'wtrZQadTkOL',
      'Mc3k3bSwXNe',
      'CePNVGSnj00',*/
      'tHbPB5hrbOc',
      'ZGH70UbL2O1',

      'ZKMhrjWoXnD',


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
                id: 'RB8Wx75hGa4',
                name: 'Village',
                translatedName: 'Motse',
                valueType: 'TEXT',
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
                    name: 'Secondary/High School  Level',
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
                id: 'cFDqjIXQucQ',
                name: 'What grade are you currently enrolled?',
                translatedName: 'Nakong ea joale, u boemong bofe ba sekolo',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                    code: 'Grade 1',
                    name: 'Grade 1',
                    translatedName: 'Grade 1',
                  ),
                  InputFieldOption(
                    code: 'Grade 2',
                    name: 'Grade 2',
                    translatedName: 'Grade 2',
                  ),
                  InputFieldOption(
                    code: 'Grade 3',
                    name: 'Grade 3',
                    translatedName: 'Grade 3',
                  ),
                  InputFieldOption(
                    code: 'Grade 4',
                    name: 'Grade 4',
                    translatedName: 'Grade 4',
                  ),
                  InputFieldOption(
                    code: 'Grade 5',
                    name: 'Grade 5',
                    translatedName: 'Grade 5',
                  ),
                  InputFieldOption(
                    code: 'Grade 6',
                    name: 'Grade 6',
                    translatedName: 'Grade 5',
                  ),
                  InputFieldOption(
                    code: 'Grade 7',
                    name: 'Grade 7',
                    translatedName: 'Grade 5',
                  ),
                ],
              ),

              InputField(
                id: 'i6Y27IFBR9b',
                name: 'What grade are you currently enrolled?',
                translatedName: 'Nakong ea joale, u boemong bofe ba sekolo',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                    code: 'Grade 8',
                    name: 'Grade 8',
                    translatedName: 'Grade 8',
                  ),
                  InputFieldOption(
                    code: 'Grade 9',
                    name: 'Grade 9',
                    translatedName: 'Grade 9',
                  ),
                  InputFieldOption(
                    code: 'Grade 10',
                    name: 'Grade 10',
                    translatedName: 'Grade 10',
                  ),
                  InputFieldOption(
                    code: 'Grade 11',
                    name: 'Grade 11',
                    translatedName: 'Grade 11',
                  ),
                ],
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
                id: 'WAlaenCYazT',
                name: 'Have you been tested for HIV?',
                translatedName: 'U kile oa hlahlobela HIV?',
                description: 'If no refer for testing',
                translatedDescription:
                'Ha asa hlahloba  fetesitsa setsing sa tlhabollo',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
              ),
              InputField(
                id: 'IQX90Pjcrdh',
                name: 'Child tested as per HEI testing algorithm?',
                translatedName: 'Child tested as per HEI testing algorithm?',
                description: 'If no refer for testing',
                translatedDescription:
                'Ha asa hlahloba  fetesitsa setsing sa tlhabollo',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
              ),

              //////// i am here


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
                  // InputFieldOption(
                  //     code: 'No Response',
                  //     name: 'No Response',
                  //     translatedName: 'Ha ho Karabo'),
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
              id: 'psMvy1sqWwf',
              name: 'Has your mensuration cycle started?',
              translatedName: 'Has your mensuration cycle started?',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
              valueType: 'BOOLEAN'),


              InputField(
                id: 'mrODVshHUli',
                name: 'Last menstruation date? ',
                translatedName:
                'Last menstruation date?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                valueType: 'DATE',
              ),


              InputField(
                id: 'XYPRtYgQUF8',
                name: 'Are you pregnant?',
                translatedName: 'Do you suspect that you are pregnant?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              options: [
              InputFieldOption(code: 'Yes', name: 'Yes', translatedName: 'E'),
              InputFieldOption(code: 'No', name: 'No', translatedName: 'Che'),
              InputFieldOption(
                  code: 'Don\'t Know',
                  name: 'Don\'t Know',
                  translatedName: 'Ha ke tsebe')
            ],
              ),
              InputField(
                  id: 'xSd3LPUf8Tf',
                  name: 'Did you confirm with a pregnancy test? ',
                  translatedName: 'Did you confirm with a pregnancy test? ',
                  inputColor: const Color(0xFF4B9F46),
                  labelColor: const Color(0xFF737373),
                  valueType: 'BOOLEAN'),

              InputField(
                  id: 'wGFmu7DhNGV',
                  name: 'Do you have a child?',
                  translatedName: 'Do you have a child?',
                  inputColor: const Color(0xFF4B9F46),
                  labelColor: const Color(0xFF737373),
                  valueType: 'BOOLEAN'),
              InputField(
                id: 'd9E1aPQ4MKa',
                name: 'How old is your child?',
                valueType: 'INTEGER_ZERO_OR_POSITIVE',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                  id: 'ZGH70UbL2O1',
                  name: 'Are you still breastfeeding? ',
                  translatedName: 'Do you have a child?',
                  inputColor: const Color(0xFF4B9F46),
                  labelColor: const Color(0xFF737373),
                  valueType: 'BOOLEAN'),



              InputField(
                  id: 'OcY02VcD7fm',
                  name: 'Child Health Card available?',
                  translatedName: 'Child Health Card available?',
                  inputColor: const Color(0xFF4B9F46),
                  labelColor: const Color(0xFF737373),
                  valueType: 'BOOLEAN'),

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
            name: "Middle name",
            translatedName: 'Lebitso la pele lea ntate oa ngoana',
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
            minAgeInYear: 10,
            hint: "Beneficiary's age should be 10 years and above",
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
            name: '1. Child/Adolescent living with HIV?',
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
            id: 'ZKMhrjWoXnD',
            name: '3. Child of people living with HIV (PLHIV)?',
            translatedName:
                "3. Na ke ngoana ea phelang le batho nang le HIV? (CPLHIV)?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'tHbPB5hrbOc',
            name: '4. Adolescent Girl who is Pregnant',
            translatedName: "4. Na ngoana/moroetsana o imme?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'ZGH70UbL2O1',
            name: '5. Adolescent Girl who is a young mother',
            translatedName: "5. Na ngoana ke motsoetse a anyesang?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'FYjxxvyugEt',
            name: '6. Child of Adolescent Girl who is Breastfeeding',
            translatedName: "6. Na ngoana ke motsoetse a anyesang?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'NqhUKijE4hB',
            name: '7.  Sibling of CALHIV ',
            translatedName: "7. Na ngoana ke oabo ea phela le ts'oaetso ea HIV?",
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'mTv9eZZq0Nz',
            name: 'Which is the primary vulnerability?',
            translatedName: 'Tlokotsi ea mantlha ea ngoana ke e fe?',
            isReadOnly: true,
            inputColor: const Color(0xFFB0C7EA),
            labelColor: const Color(0xFF737373),
            valueType: 'TEXT',
            options:[

              InputFieldOption(
                code: 'Child living with HIV',
                name: 'Child living with HIV',
                translatedName: 'Ngoana ea phelang le HIV',
              ),

              InputFieldOption(
                code: 'HIV exposed infants',
                name: 'HIV exposed infants',
                translatedName: 'HIV e pepesa masea',
              ),
              InputFieldOption(
                code: 'Child of PLHIV',
                name: 'Child of PLHIV',
                translatedName:
                    "Na ke ngoana a phelang le batho banang le HIV (CPLHIV)?",
              ),

              InputFieldOption(
                code: 'Sibling ',
                name: 'Sibling',
              ),
              InputFieldOption(
                code: 'Child of Adolescent Girl who is Breastfeeding',
                name: 'Child of Adolescent Girl who is Breastfeeding',
              ),
              InputFieldOption(
                code: 'Sibling for CALHIV',
                name: 'Sibling for CALHIV',
              ),
              InputFieldOption(
                code: 'Adolescent Girl who is Pregnant',
                name: 'Adolescent Girl who is Pregnant',
              ),
              InputFieldOption(
                code: 'Adolescent Girl who is a young mother',
                name: 'Adolescent Girl who is a young mother',
              ),


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
