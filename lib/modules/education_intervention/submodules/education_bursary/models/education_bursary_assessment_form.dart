import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/education_intervention/submodules/education_bursary/constants/bursary_intervention_constant.dart';

class EducationBursaryAssessment {
  static List<String> getMandatoryField() {
    return [
      "location",
      "RB8Wx75hGa4",
      'WTZ7GLTrE8Q',
      'rSP9c21JsfC',
      'qZP982qpSPS',
      'vIX4GTSCX4P',
      "fEPLlRZiwve",
      "pJ5NAEmwnDq",
      "WXhb5L2Zisd",
      "OL0bjS9XQsh",
      "why_not_schooling",
      "tbzi0t27D8l",
      "Ze2W9vkrfrL",
      "type_of_disability",
      "dxp3qM2TgUc",
      "C524HuWqRyt",
      "KGjZfijhdiR",
      "FxGSw7Yueyc",
      "t4DbaeAK16P",
      "IVjlzXHizyT",
      "nXvf0gcppF5",
      "occupation",
      "vQ7hj9nTgo7",
      "KiTvHDkvi8J",
      "not_enrolled_reason",
      "forms_of_assistance",
      "guardian_contribution",
      "x7HZOLCazVg",
      "PyAH5nY83o3",
      "om8s3kpQnjI",
      "ZhNIc0pp5IC",
      "illness",
      "used_for_cooking",
      "oaVHpFUuIOw",
      "type_of_toilet",
      "household_items",
      "z4z7ow7yriM",
      "BnYxw1cOirn",
      "l9thzEZzGrK",
      "rzeyShjMVHO",
      "FMLuCvm2yTI",
      "ziBNi3VfdQU",
      "o4Bi74oylwo",
      "Z0XaEgRPvkM",
      "household_animals",
      "yKUVT2msSLT",
      "QBxpDou3jlE",
      "pkVU7LVIO9W",
      "WoSdTNgH4Mz",
      "LtyzmIBWl7w",
      "VQbVQea2s7n",
      "household_properties",
      "ykg7pxiVcSc",
      "BjIO7hTeor3",
      "OgtRbjHVRsL",
      "source_of_food"
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        id: 'geographical_info',
        name: "SECTION A: GEOGRAPHICAL INFORMATION",
        color: const Color(0xFF009688),
        inputFields: [
          InputField(
            id: 'location',
            name: '1. Location',
            translatedName: '1. Sebaka',
            valueType: 'ORGANISATION_UNIT',
            allowedSelectedLevels: [
              AppHierarchyReference.communityLevel,
            ],
            filteredPrograms: [BursaryInterventionConstant.program],
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'RB8Wx75hGa4',
            name: '2. Village',
            translatedName: '2. Motse',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'fEPLlRZiwve',
            name: '3. Nearby available schools for the child',
            translatedName: 'Likolo tse haufi tse fumanehang bakeng sa ngoana',
            valueType: 'LONG_TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
          id: 'child_demographics',
          name: "SECTION B: CHILD DEMOGRAPHIC AND INFORMATION",
          color: const Color(0xFF009688),
          inputFields: [
            InputField(
              id: 'WTZ7GLTrE8Q',
              name: 'First Name',
              translatedName: 'Lebitso la pele',
              regExpValidation: RegExp('^[A-Za-z]{0,}'),
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 's1HaiT6OllL',
              name: 'Middle Name',
              translatedName: 'Lebitso le mahareng',
              regExpValidation: RegExp('^[A-Za-z]{0,}'),
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'rSP9c21JsfC',
              name: 'Surname',
              translatedName: 'Le Fane',
              regExpValidation: RegExp('^[A-Za-z]{0,}'),
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'pJ5NAEmwnDq',
              name: '2. Birth certificate available',
              translatedName: '2. Lengolo la tlhaho le teng',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'cYn1nmlwBdW',
              name: 'Reason why birth certificate is not available',
              translatedName:
                  'Lebaka le etsang hore lengolo la tlhaho le sa fumanehe',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'WXhb5L2Zisd',
              name: '3. Identification card available',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'qWXojsKR6VU',
              name: 'Reasong why Identification card is not available',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'qZP982qpSPS',
              name: '4. Date of Birth',
              translatedName: 'Letsatsi la tsoalo',
              valueType: 'DATE',
              maxAgeInYear: 24,
              minAgeInYear: 12,
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'ls9hlz2tyol',
              name: 'Age',
              translatedName: 'Lilemo',
              isReadOnly: true,
              valueType: 'NUMBER',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'vIX4GTSCX4P',
              name: '5. Sex',
              translatedName: 'Boleng',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              renderAsRadio: true,
              options: [
                InputFieldOption(
                  code: "Male",
                  name: "Male",
                  translatedName: 'Botona',
                ),
                InputFieldOption(
                  code: "Female",
                  name: "Female",
                  translatedName: 'Botsehali',
                ),
              ],
            ),
            InputField(
              id: 'OL0bjS9XQsh',
              name: '6. Schooling',
              translatedName: '6. O kena sekolo',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'why_not_schooling',
              name: '7. Why out of school?',
              translatedName: '7. Ke hobaneng a sa kene sekolo?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: "o6hMHAcDejV",
                  name: "Cost of fee",
                ),
                InputFieldOption(
                  code: "zQPns75P1XA",
                  name: "Disabled",
                ),
                InputFieldOption(
                  code: "Ne8BaB6rCZX",
                  name: "Caregiver can't afford necessity",
                ),
                InputFieldOption(
                    code: "Az3Rtp5Mtey",
                    name: "Not important",
                    translatedName: 'Ha e bohlokoa'),
                InputFieldOption(
                    code: "eOOYt94C8G7",
                    name: "Not interested",
                    translatedName: 'Ha ke Thahaselle'),
                InputFieldOption(
                    code: "oIGWbCQTZ8w",
                    name: "Pregnancy",
                    translatedName: "Boimana"),
                InputFieldOption(
                  code: "yK3ovFC1uGO",
                  name: "School too far",
                ),
                InputFieldOption(
                  code: "h2LrMC9ep8E",
                  name: "Other",
                ),
              ],
            ),
            InputField(
                id: 'Ha1E9m1x3Nn',
                name: 'Specify other',
                translatedName: 'Hlalosa tse ling',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT'),
            InputField(
              id: 'tbzi0t27D8l',
              name: '8. Grade to be attended',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                    code: "Grade 8",
                    name: "Grade 8",
                    translatedName: 'Sehlopha sa 8'),
                InputFieldOption(
                    code: "Grade 9",
                    name: "Grade 9",
                    translatedName: 'Sehlopha sa 9'),
                InputFieldOption(
                    code: "Grade 10",
                    name: "Grade 10",
                    translatedName: 'Sehlopha sa 10'),
                InputFieldOption(
                    code: "Grade 11",
                    name: "Grade 11",
                    translatedName: 'Sehlopha sa 11'),
              ],
            ),
            InputField(
              id: 'Ze2W9vkrfrL',
              name:
                  '9. If given an opportunity would you like to go back to school',
              translatedName:
                  '9. Ha o ka fuwa monyetla o ka rata ho khutlela sekolong',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'zLn55LntBLP',
              name: 'If not, please state the reasons',
              translatedName: 'Haeba ho se joalo, ka kopo bolela mabaka',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: '',
              name:
                  '10. What do you think can be done to support you as a student to succeed or thrive in school?',
              translatedName:
                  '10. U nahana hore ho ka etsoa’ng ho u tšehetsa joaloka moithuti hore u tsoele pele kapa u atlehe sekolong?',
              valueType: 'TEXT',
              hasLabelOnly: true,
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'Ll5R0e0IBzC',
              name: 'a)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'KI8toyKBwWj',
              name: 'b)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'rtvNfM9KPvH',
              name: 'c)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'type_of_disability',
              name: '11. Do you or any of your sibling have a disability?',
              translatedName: "11. Na uena kapa ngoan'eno le na le bokooa?",
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                    code: "TPRVr4ua9f9",
                    name: "Vision",
                    translatedName: 'Pono'),
                InputFieldOption(
                    code: "tbLVGG4zDrJ",
                    name: "Hearing",
                    translatedName: 'Ho utloa'),
                InputFieldOption(
                    code: "X3MQhmVA1Jt",
                    name: "Physical",
                    translatedName: 'Mmeleng'),
                InputFieldOption(
                    code: "KPsuBw6mn81", name: "Speech", translatedName: 'Puo'),
                InputFieldOption(
                    code: "BfbiOanp9Pi",
                    name: "Mental",
                    translatedName: 'Kelellong'),
                InputFieldOption(
                    code: "ZAgwp8OV3Az",
                    name: "Multiple disability",
                    translatedName: 'Bokooa ba mefuta e fapaneng'),
                InputFieldOption(
                  code: "dWKnZE5xkfk",
                  name: "Other",
                ),
              ],
            ),
            InputField(
                id: 'JsNImCkS1gh',
                name: 'Specify other',
                translatedName: 'Hlalosa tse ling',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT')
          ]),
      FormSection(
          id: 'caregiver_info',
          name: "SECTION C. CAREGIVER INFORMATION",
          translatedName: 'KAROLO EA C: LINTLHA TSA MOHLOKOMELI',
          color: const Color(0xFF009688),
          inputFields: [
            InputField(
              id: 'dxp3qM2TgUc',
              name: '1. Name of the caregiver',
              translatedName: 'Lebitso la mohlokomeli',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'C524HuWqRyt',
                name: '2. Relationship with the child',
                translatedName: 'Kamano le ngoana',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Daughter',
                      name: 'Daughter',
                      translatedName: 'Morali'),
                  InputFieldOption(
                      code: 'Son', name: 'Son', translatedName: 'Mora'),
                  InputFieldOption(
                      code: 'Grandson',
                      name: 'Grandson',
                      translatedName: 'Setloholo sa moshanyana'),
                  InputFieldOption(
                      code: 'Granddaughter',
                      name: 'Granddaughter',
                      translatedName: 'Setloholo sa ngoanana'),
                  InputFieldOption(
                      code: 'NotRelated',
                      name: 'Not related',
                      translatedName: 'Ha ba amane'),
                  InputFieldOption(code: 'Other', name: 'Other'),
                ]),
            InputField(
              id: 'FCS9lp9uaTW',
              name: 'Specify other relationship with the child',
              translatedName: 'Hlalosa likamano tse ling le ngoana',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'KGjZfijhdiR',
              name: '3. Contact details',
              translatedName: '3. Lintlha tsa mabitso le linomoro tsa mohala',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'FxGSw7Yueyc',
                name: '4. How many other children are in this household?',
                translatedName: '4. Ke bana ba bakae ba bang ka tlung ena',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: '1-3', name: '1-3'),
                  InputFieldOption(code: '3-5', name: '3-5'),
                  InputFieldOption(code: '5+', name: '5+'),
                ]),
            InputField(
                id: 't4DbaeAK16P',
                name: '5. Highest level of education completed',
                translatedName:
                    '5. Boemo bo phahameng ka ho fetisisa ba thuto bo phethiloeng',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'PrePrimary',
                      name: 'Pre-Primary',
                      translatedName: 'Pele ho mathomo'),
                  InputFieldOption(
                      code: 'Primary',
                      name: 'Primary',
                      translatedName: 'Mathomo'),
                  InputFieldOption(
                      code: 'JuniorSecondary', name: 'Junior Secondary'),
                  InputFieldOption(
                      code: 'SeniorSecondary', name: 'Senior Secondary'),
                  InputFieldOption(
                      code: 'College',
                      name: 'College',
                      translatedName: 'Kholeche'),
                  InputFieldOption(code: 'University', name: 'University'),
                  InputFieldOption(
                      code: 'Vocational',
                      name: 'Vocational',
                      translatedName: 'Mosebetsi oa matsoho'),
                ]),
            InputField(
                id: 'IVjlzXHizyT',
                name: '6. Child is currently under the care of',
                translatedName: 'Ngoana hajoale o tlasa tlhokomelo ea',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'Only mother', name: 'Only mother'),
                  InputFieldOption(code: 'Only father', name: 'Only father'),
                  InputFieldOption(code: 'Both parents', name: 'Both parents'),
                  InputFieldOption(
                      code: 'Care facility', name: 'Care facility'),
                  InputFieldOption(code: 'Other', name: 'Other'),
                ]),
            InputField(
              id: 'rHXVmf70LCM',
              name: 'Specify other',
              translatedName: 'Hlalosa tse ling',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'nXvf0gcppF5',
                name: '7. Child parents’ status',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'Both alive', name: 'Both alive'),
                  InputFieldOption(code: 'Father alive', name: 'Father alive'),
                  InputFieldOption(code: 'Mother alive', name: 'Mother alive'),
                  InputFieldOption(
                      code: 'Neither alive', name: 'Neither alive'),
                  InputFieldOption(
                      code: 'Parent(s) sick', name: 'Parent(s) sick'),
                ]),
            InputField(
              id: 'occupation',
              name: '8. Your main occupation in the last 6 months',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: "VPfBDxFH6Gs",
                  name: "Employed with salary",
                ),
                InputFieldOption(
                  code: "hV2Dli6l9z3",
                  name: "Employed without salary",
                ),
                InputFieldOption(
                  code: "ZVsaQjgV0TM",
                  name: "Unemployed",
                ),
                InputFieldOption(
                  code: "uKQsjyliUZs",
                  name: "Header",
                ),
                InputFieldOption(
                  code: "G050yLYK7Dk",
                  name: "Domestic Worker",
                ),
                InputFieldOption(
                  code: "vU3H2pTHjZM",
                  name: "Self employed",
                ),
                InputFieldOption(
                  code: "JW3YHXh0oVQ",
                  name: "Other",
                ),
              ],
            ),
            InputField(
                id: 'fSWNHF4MmTl',
                name: 'Specify other',
                translatedName: 'Hlalosa tse ling',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT'),
            InputField(
                id: 'vQ7hj9nTgo7',
                name: '9. Child current status at school',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Never enrolled', name: 'Never enrolled'),
                  InputFieldOption(code: 'Enrolled', name: 'Enrolled'),
                  InputFieldOption(
                      code: 'Dropped out plan to return',
                      name: 'Dropped out plan to return'),
                  InputFieldOption(
                      code: 'Dropped out no plan to return',
                      name: 'Dropped out no plan to return'),
                  InputFieldOption(
                      code: 'Enrolled but not attending',
                      name: 'Enrolled but not attending'),
                ]),
            InputField(
                id: 'KiTvHDkvi8J',
                name: '10. Is the child enrolled in',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Primary',
                      name: 'Primary',
                      translatedName: 'Mathomo'),
                  InputFieldOption(code: 'Secondary', name: 'Secondary'),
                  InputFieldOption(
                      code: 'Vocational',
                      name: 'Vocational',
                      translatedName: 'Mosebetsi oa matsoho'),
                  InputFieldOption(
                      code: 'Tertiary level', name: 'College / university'),
                ]),
            InputField(
                id: 'not_enrolled_reason',
                name: '11. If not enrolled what is the main reason',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'obGgp7J7e6t',
                      name: 'Cost of fee',
                      translatedName: "Lits'enyehelo tsa tefo"),
                  InputFieldOption(
                    code: 'QMuGRN1LdPT',
                    name: 'School too far',
                  ),
                  InputFieldOption(code: 'js6IkL40t05', name: 'Domestic work'),
                  InputFieldOption(
                      code: 'keGUqPqV1xm',
                      name: 'Not important',
                      translatedName: 'Ha e bohlokoa'),
                  InputFieldOption(
                      code: 'nohGnfprTKZ', name: 'Chronically (Caregiver)'),
                  InputFieldOption(
                      code: 'Exks3euVyvA',
                      name: 'Disabled',
                      translatedName: 'O holofetse'),
                  InputFieldOption(
                      code: 'oObzvgasBoK',
                      name: 'Cannot afford other necessity'),
                  InputFieldOption(
                      code: 'hxWJ7bGS2Lh',
                      name: 'Other (specify)',
                      translatedName: 'Tse ling(hlalosa)'),
                ]),
            InputField(
                id: 'TwKzPVRTdR1',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                name: 'Specify other',
                translatedName: 'Hlalosa tse ling',
                valueType: 'TEXT'),
            InputField(
                id: 'forms_of_assistance',
                name:
                    '12. Do you or your child receive any of the following forms of assistance?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'kGy2iC1LJuy', name: 'Child grants'),
                  InputFieldOption(
                      code: 'vV1CKMs6mPT', name: 'OVC school bursaries'),
                  InputFieldOption(code: 'HSb9fQKQmgV', name: 'School uniform'),
                  InputFieldOption(code: 'loM6wymz0Qf', name: 'School feeding'),
                  InputFieldOption(
                      code: 'lf7iwYX0ZvE', name: 'Old age pension'),
                  InputFieldOption(code: 'UVdJ0idZ0OK', name: "None")
                ]),
            InputField(
                id: 'guardian_contribution',
                name:
                    '13. As the guardian of the child please indicate what contributions you will make to the student while at school',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'LcSdpGjrH0F', name: 'School fee'),
                  InputFieldOption(code: 'dgP4R6kehU7', name: 'Boarding fee'),
                  InputFieldOption(code: 'hLSOY7Kvxju', name: 'Book fee'),
                  InputFieldOption(code: 'oXMbE5wva3c', name: 'Feeding fee'),
                  InputFieldOption(code: 'fQU8Sbfg3IR', name: 'Toiletries'),
                  InputFieldOption(code: 'zOw1Snf9km9', name: 'Transport'),
                  InputFieldOption(code: 'ZyluNy1MaQU', name: 'Uniform'),
                  InputFieldOption(code: 'fJppyjpfDBd', name: 'None'),
                ]),
          ]),
      FormSection(
          id: 'Vulnerability',
          name: 'SECTION D. VULNERABILITY',
          color: const Color(0xFF009688),
          inputFields: [
            InputField(
                id: 'x7HZOLCazVg',
                name: '1. How many times a day does the household eat?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: "More than 4 times", name: "More than 4 times"),
                  InputFieldOption(code: "3 to 4 times", name: "3 to 4 times"),
                  InputFieldOption(code: "1 to 2 times", name: "1 to 2 times"),
                  InputFieldOption(code: "Often 0", name: "Often 0"),
                ]),
            InputField(
                id: 'PyAH5nY83o3',
                name:
                    '2. Does the household experience hunger that it cannot address on regular basis?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: "Always", name: "Always"),
                  InputFieldOption(code: "Often", name: "Often"),
                  InputFieldOption(code: "Sometimes", name: "Sometimes"),
                  InputFieldOption(code: "Never", name: "Never"),
                ]),
            InputField(
                id: 'om8s3kpQnjI',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                name:
                    '3. Is any member of the household unable to perform their daily activities due to a physical or mental disability?',
                valueType: 'BOOLEAN'),
            InputField(
                id: 'ZhNIc0pp5IC',
                name:
                    '4. If you responded yes to question 3 who is his/her primary caregiver?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Myself (caregiver)', name: 'Myself (caregiver)'),
                  InputFieldOption(
                    code: 'Sibling',
                    name: 'Sibling',
                    translatedName: 'Ke ngoaneso',
                  ),
                  InputFieldOption(
                      code: 'Another household member',
                      name: 'Another household member'),
                ]),
            InputField(
                id: 'illness',
                name:
                    'Does anyone in the household suffer from one of the following chronic/terminal illness?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'ZYHhJzDEROg', name: 'HIV'),
                  InputFieldOption(code: 'x3fV8DsCs1V', name: 'Cancer'),
                  InputFieldOption(code: 'SEmpuVncKMP', name: 'TB'),
                  InputFieldOption(
                      code: 'FYQGgPhYQcy', name: 'Both TB and HIV'),
                  InputFieldOption(code: 'w3mmK0ZhKHm', name: 'Other'),
                ]),
            InputField(
                id: 'gNn6fGxFBvu',
                name: 'Specify other',
                translatedName: 'Hlalosa tse ling',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT')
          ]),
      FormSection(
          id: 'household_assets',
          name: 'SECTION E. HOUSEHOLD ASSETS',
          color: const Color(0xFF009688),
          inputFields: [
            InputField(
              id: 'used_for_cooking',
              name: '1. What does the household use for cooking?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: "VVBK2avJNZs",
                  name: "Electricity",
                ),
                InputFieldOption(
                  code: "I0LqIykLhNZ",
                  name: "Gas",
                ),
                InputFieldOption(
                  code: "fUz3oIxfLlY",
                  name: "Paraffin",
                ),
                InputFieldOption(
                  code: "hXqewB8sEue",
                  name: "Coal",
                ),
                InputFieldOption(
                  code: "fEclXXfVbwS",
                  name: "Wood",
                ),
                InputFieldOption(
                  code: "H34Fc2ql4Zz",
                  name: "Cow dung",
                ),
                InputFieldOption(
                  code: "qNpe49Zq0lU",
                  name: "Crop waste",
                ),
                InputFieldOption(
                  code: "YkVyjaNi5Bp",
                  name: "Other",
                )
              ],
            ),
            InputField(
                id: 'EQIf299WMiS',
                name: 'Specify other',
                translatedName: 'Hlalosa tse ling',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT'),
            InputField(
              id: 'oaVHpFUuIOw',
              name: '2. How many rooms does the house have?',
              hint: 'Including kitchen, bathroom and stand-alone rooms',
              valueType: 'TEXT',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: "1",
                  name: "1",
                ),
                InputFieldOption(
                  code: "2",
                  name: "2",
                ),
                InputFieldOption(
                  code: "3",
                  name: "3",
                ),
                InputFieldOption(
                  code: "4",
                  name: "4",
                ),
                InputFieldOption(
                  code: "5",
                  name: "5",
                ),
                InputFieldOption(
                  code: "More than 5",
                  name: "More than 5",
                ),
              ],
            ),
            InputField(
              id: 'type_of_toilet',
              name: '3. What type of toilet is frequently used?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: "qBeV7jzipvB",
                  name: "No toilet",
                ),
                InputFieldOption(
                  code: "vjoVa4479x4",
                  name: "Sewage system",
                ),
                InputFieldOption(
                  code: "AytlmusjhtZ",
                  name: "Own pit latrine",
                ),
                InputFieldOption(
                  code: "zlgGfI8AihO",
                  name: "Own VIP",
                ),
                InputFieldOption(
                  code: "je853GIHTtK",
                  name: "Bucket",
                ),
                InputFieldOption(
                  code: "mDJ1QUxMLsR",
                  name: "Public or shared toilet",
                ),
                InputFieldOption(
                  code: "hE4PMNfJxTW",
                  name: "Other",
                ),
              ],
            ),
            InputField(
                id: 'H5glFCPsa9n',
                name: 'Specify Other',
                translatedName: 'Hlalosa tse ling',
                inputColor: const Color(0xFF009688),
                labelColor: const Color(0xFF737373),
                valueType: 'TEXT'),
            InputField(
              id: 'household_items',
              name: '4. Does the household have the following items?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: "RIhVna2gMyU",
                  name: "Electric or gas stove",
                ),
                InputFieldOption(
                  code: "AI5HI4sMmH9",
                  name: "Refrigerator/Freezer ",
                ),
                InputFieldOption(
                  code: "SBulXSQB2yA",
                  name: "Television",
                ),
                InputFieldOption(
                  code: "n60llwHJIc2",
                  name: "Radio/Audio Equipment",
                ),
                InputFieldOption(
                  code: "eQs6QgpZFFl",
                  name: "Cell phone",
                ),
                InputFieldOption(
                  code: "X0oEMbsnbRp",
                  name: "Land line",
                ),
                InputFieldOption(
                  code: "e9JhEYUkO4V",
                  name: "Sewing or knitting machine",
                ),
                InputFieldOption(
                  code: "DZWBn9lpEVu",
                  name: "Motorised vehicle",
                ),
                InputFieldOption(
                  code: "szK8gsQVXfZ",
                  name: "None",
                )
              ],
            ),
            InputField(
              id: 'z4z7ow7yriM',
              name: 'Number of Electric or gas stove',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'BnYxw1cOirn',
              name: 'Number of Refrigerator/Freezer',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'l9thzEZzGrK',
              name: 'Number of Television',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'rzeyShjMVHO',
              name: 'Number of Radio/Audio Equipment',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'FMLuCvm2yTI',
              name: 'Number of Cell phone',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'ziBNi3VfdQU',
              name: 'Number of Land line',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'o4Bi74oylwo',
              name: 'Number of Sewing or knitting machine',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'Z0XaEgRPvkM',
              name: 'Number of Motorised vehicle',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'household_animals',
              name:
                  '5. Is the household in possession of one or more of the following?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: "CM64InhpVVd",
                  name: "Horse",
                ),
                InputFieldOption(
                  code: "vzuGxvADAQ1",
                  name: "Cattle",
                ),
                InputFieldOption(
                  code: "YTfNinzrOGA",
                  name: "Sheep",
                ),
                InputFieldOption(
                  code: "LSJjze7HV3w",
                  name: "Goat",
                ),
                InputFieldOption(
                  code: "juGeWTcD9LL",
                  name: "Poultry",
                ),
                InputFieldOption(
                  code: "o67RKCxvNCy",
                  name: "Donkey",
                ),
                InputFieldOption(
                  code: "W5FItGM8Ceq",
                  name: "None",
                )
              ],
            ),
            InputField(
              id: 'yKUVT2msSLT',
              name: 'Number of Horse',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'QBxpDou3jlE',
              name: 'Number of Cattle',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'pkVU7LVIO9W',
              name: 'Number of Sheep',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'WoSdTNgH4Mz',
              name: 'Number of Goat',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'LtyzmIBWl7w',
              name: 'Number of Poultry',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'VQbVQea2s7n',
              name: 'Number of Donkey',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'household_properties',
              name:
                  '6. Does the household own any of the following properties?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: "OeEHpwWkzgf",
                  name: "Rental Houses",
                ),
                InputFieldOption(
                  code: "dUwwS3Gp7OU",
                  name: "Residential House",
                ),
                InputFieldOption(
                  code: "FbVD6cQzc9V",
                  name: "None",
                )
              ],
            ),
            InputField(
              id: 'ykg7pxiVcSc',
              name: 'Number of Rental Houses',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'BjIO7hTeor3',
              name: 'Number of Residential House',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'OgtRbjHVRsL',
              name: '7. Does the family have any source of food?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'source_of_food',
              name: '8. Where does the family get the food?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF009688),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: "ZXh2TONkbpg",
                  name: "Home gardens",
                ),
                InputFieldOption(
                  code: "Cl7FM19srOJ",
                  name: "Fields",
                ),
                InputFieldOption(
                  code: "iwDJ7qX8FIH",
                  name: "Keyhole gardening",
                ),
                InputFieldOption(
                  code: "YKU1ZAeRlVc",
                  name: "Store-bought",
                ),
              ],
            ),
          ]),
      FormSection(
        id: 'vulnerability_criteria',
        color: const Color(0xFF009688),
        name: 'Vulnerability Criteria',
        inputFields: [
          InputField(
            id: 'JfPUDRFSM2z',
            name: 'Needy double orphan',
            valueType: 'TRUE_ONLY',
            isReadOnly: true,
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'bgIhCSdcf3S',
            name: 'Needy single orphan',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF009688),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ScwpdvuKFhg',
            name: 'Needy children with both parents',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF009688),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'FbYzrCTLoHz',
            name: 'Abandoned children',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF009688),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ap2txsDKTLL',
            name: 'Needy children with disability',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF009688),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'S1fa4zCDYEC',
            name: 'Aged 13-17 boys and girls',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF009688),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'tL9duNsv8BE',
            name: 'In post primary',
            translatedName: 'Mafu a likobo',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF009688),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
        ],
      )
    ];
  }
}
