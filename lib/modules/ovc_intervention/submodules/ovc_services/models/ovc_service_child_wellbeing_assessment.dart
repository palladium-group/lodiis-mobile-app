import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcServicesChildWellbeingAssessment {
  static List<String> getMandatoryFields() {
    return FormUtil.getAllFormSectionInpiutFields(
      getFormSections(
        firstDate: '',
      ),
    );
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      AppUtil.getServiceProvisionEventDateSection(
        inputColor: const Color(0xFF4A9F46),
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: const Color(0xFF0D3A16),
        formSectionLabel: 'Assessment Date',
        inputFieldLabel: 'Assessment Date',
        firstDate: firstDate,
      ),
      FormSection(
          name: 'Role/Impact of a Child to the family',
          id:'roleimpact',
          translatedName: "Karolo/ts'usumetso ea ngoana ka hare ho lelapa",
          color: const Color(0xFF4B9F46),
          inputFields: [
            InputField(
                id: 'lt88RMPaBPg',
                name: '2. What is the child’s role in the family?',
                translatedName: '2. Mosebetsi oa hau ke ofe ka hara lelapa le?',
                translatedDescription:
                'Mohlala, na oa pheha, u etsa mesebetsi ea lelapa kapa u etsa lintho tse kang liaparo kapa lisebelisoa? Na u rekisa \'marakeng kapa u sebetsa ka ntle ho ntlo? Na u hlokomela litho tse ling tsa lelapa',
                description:
                'For example, do you cook, do housework or make items such as clothes or tools? Do you sell in the market or work outside of the household? Do you take care of other family members?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Wstcittf',
                name: '43. What is the child\'s impact to the family?',
                translatedName:
                '43. Boitsoaro ba ngoana bo ama lelapa lee joang?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'm2ghW6ZMUru',
                      name: 'A source of joy',
                      translatedName: 'Ke sesosa sa thabo'),
                  InputFieldOption(
                      code: 'Ue2Ntq2aGjw',
                      name: 'Household tasks',
                      translatedName: 'Ho thusa ka mesebetsi ea lelapa'),
                  InputFieldOption(
                      code: 'DXYwwkKCeWZ',
                      name: 'Take care of the other children',
                      translatedName: 'Ho hlokomela bana'),
                  InputFieldOption(
                      code: 'KiQnuLksmBp',
                      name: 'A source of worry',
                      translatedName: "Ke sesosa sa mats'oenyeho"),
                  InputFieldOption(
                      code: 'vCSvOI0d9M4',
                      name: 'Other',
                      translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'NAqMo0LwqZR',
                name: 'Specify other impacts',
                translatedName: 'Tse ling (Hlalosa)',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'HdtChyf',
                name: '44. How does the child help your family?',
                translatedDescription:
                'Mohlala, na o thusana ka mesebetsi ea lelapa kapa ho hlokomela liphoofolo?',
                translatedName: '44. o thusa lelapa le joang? ',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'yJKX39H7HBL',
                      name: 'Look after the children',
                      translatedName: 'Ho hlokomela bana'),
                  InputFieldOption(
                      code: 'XqG5ql9rK3T',
                      name: 'Help with house chores',
                      translatedName: 'Ho thusa ka mesebetsi ea lelapa'),
                  InputFieldOption(
                      code: 'ccjlPQcsLME',
                      name: 'Work on the farms',
                      translatedName: 'Ho sebetsa masimong'),
                  InputFieldOption(
                      code: 'ogY1PpnwIH9',
                      name: 'Collect water and/or wood',
                      translatedName: 'Ho kha metsi/ho roalla'),
                  InputFieldOption(
                      code: 'x8QFUzv5ZnD',
                      name: 'Take care of animals',
                      translatedName: 'Ho hlokomela liphoofolo'),
                  InputFieldOption(
                      code: 'MUuevTfdTqb',
                      name: 'Provide food & other household items',
                      translatedName: 'Ho reka lijo le thepa e ngoe ea lelapa'),
                  InputFieldOption(
                      code: 'hX5lO8etDXx',
                      name: 'Earn extra money',
                      translatedName: 'Ho fumana chelete engoe'),
                  InputFieldOption(
                      code: 'r0vhM9GCkxp', name: 'N/A', translatedName: 'N/A'),
                  InputFieldOption(
                      code: 'TH3xvl6NZhi',
                      name: 'Other',
                      translatedName: 'Tse ling (Hlalosa)')
                ]),
            InputField(
                id: 'wOlSzC2ovZN',
                name: 'Specify other activities',
                translatedName: 'Tse ling, Hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373))
          ]),
      FormSection(
          name: 'DOMAIN SCHOOLED',
          translatedName: 'TSA SEKOLO',
          id: 'domainschooltsasekolo',
          color: const Color(0xFF9B2BAE),
          borderColor: const Color(0xFF9B2BAE),
          inputFields: [
            InputField(
                id: 'DaVKi2U248S',
                name: '45. Is the child currently enrolled in school?',
                translatedName:
                '45. Na hona joale ngoana o ngolisitse sekolong?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'TWvKsmKyCSc',
                name:
                ' 3. Are you currently enrolled in school or a vocation program?',
                translatedName:
                '3. Na hona joale u kena sekolo sa lithuto kapa sa mosebetsi oa matsoho? ',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'emR9ocfi1Vm',
                name: '46. Has the OVC ever been enrolled in school?',
                translatedName: '46. Na ngoana o kile a ingolisa sekolong?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'DaVKi2U248S_checkbox',
                name: '47. Record why the child is not enrolled in school',
                translatedName:
                '47. Ngola na hobaneng ngoana a sa kene sekolo.',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227),
                options: [
                  InputFieldOption(
                      code: 'fcWZ0cctQlO',
                      name: 'Sick/Fever',
                      translatedName: 'Feberu'),
                  InputFieldOption(
                      code: 'nbLQCi1YrvU',
                      name: 'Exhaustion',
                      translatedName: 'Mokhathala'),
                  InputFieldOption(
                      code: 'JMGxn39tjoh',
                      name: 'Housework',
                      translatedName: 'Mosebetsi oa lapeng'),
                  InputFieldOption(
                      code: 'qPt9jvB5ACh',
                      name: 'Fear of the school or other children at school',
                      translatedName: 'Ho tšaba bana ba bang ba sekolo'),
                  InputFieldOption(
                      code: 'giEyqjovyAp',
                      name: 'Fear of the walk to school',
                      translatedName: 'Tšabo ea ho tsamaea ho ea sekolong'),
                  InputFieldOption(
                      code: 'Q5MH7cmdlhT',
                      name: 'Inability to pay school fees',
                      translatedName:
                      'Ho se khone ho lefa litefiso tsa sekolo'),
                  InputFieldOption(
                      code: 'WIrF2dIAkqD',
                      name: 'Inability to pay for school materials',
                      translatedName: 'Ho hloka lisebelisoa tsa sekolo'),
                  InputFieldOption(
                      code: 'kamr81y5WJs',
                      name: 'Other reason',
                      translatedName: 'Tse ling (ka kopo, Hlalosa)')
                ]),
            InputField(
                id: 'wZ6HnbTdfDg',
                name:
                'Specify other reason why the child is not enrolled in school',
                translatedName: 'Tse ling (Hlalosa)',
                valueType: 'TEXT',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'cv8RKCPOOAo',
                name: 'Which one you are enrolled in?',
                translatedName: 'O ngolisitse ho efe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227),
                options: [
                  InputFieldOption(
                      code: 'School', name: 'School', translatedName: 'Sekolo'),
                  InputFieldOption(
                      code: 'Vocational Training',
                      name: 'Vocational Training',
                      translatedName: 'Koetliso ea mosebetsi oa matsoho'),
                ]),
            InputField(
                id: 'xYdWjIv5eup',
                name: 'What level of education is the child in now?',
                translatedName: 'Hona joale ngoana o boemong bofe ba thuto?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227),
                options: [
                  InputFieldOption(
                      code: 'Primary',
                      name: 'Primary',
                      translatedName: 'Mathomo'),
                  InputFieldOption(code: 'Secondary', name: 'Secondary')
                ]),
            InputField(
                id: 'BvEsLzWsL3Z',
                name: '4. What level of education are you now?',
                translatedName: '4. Boemo ba hau ba thuto ke bofe hona joale?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227),
                options: [
                  InputFieldOption(
                      code: 'Primary',
                      name: 'Primary',
                      translatedName: 'Mathomo'),
                  InputFieldOption(
                      code: 'Secondary/High level',
                      name: 'Secondary/High level'),
                  InputFieldOption(
                      code: 'College',
                      name: 'College',
                      translatedName: 'Kholeche')
                ]),
            InputField(
                id: 'TRuxsvRahqm',
                name: '48. What grade?',
                translatedName: 'Sehlopheng sefe?',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'pczeYqyA3Bj',
                name: '48. What form?',
                translatedName: 'Ka foromo efe?',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'IUdOAhmhqj1',
                name: '48. What year?',
                translatedName: 'Selemong sefe?',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'M3AaNTqC9d6',
                name: '48. What level of education was the child last year?',
                translatedName:
                '48. Ngwana o ne a le maemong a makae selemong se fetileng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227),
                options: [
                  InputFieldOption(
                      code: 'Primary',
                      name: 'Primary',
                      translatedName: 'Mathomo'),
                  InputFieldOption(
                      code: 'Secondary/High level',
                      name: 'Secondary/High level'),
                  InputFieldOption(
                      code: 'College',
                      name: 'College',
                      translatedName: 'Kholeche')
                ]),
            InputField(
                id: 'KlbW2l1L1NC',
                name: '5. What level of education where you last year?',
                translatedName: '5. Ke boemo bofe ba thuto boo u bo fetileng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227),
                options: [
                  InputFieldOption(
                      code: 'Primary',
                      name: 'Primary',
                      translatedName: 'Mathomo'),
                  InputFieldOption(
                      code: 'Secondary/High level',
                      name: 'Secondary/High level'),
                  InputFieldOption(
                      code: 'College',
                      name: 'College',
                      translatedName: 'Kholeche')
                ]),
            InputField(
                id: 'xbAukRUBixJ',
                name: 'What grade was the child in last year?',
                translatedName: 'Sehlopheng sefe selemong se fetileng?',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'SGCjKsX1Mzl',
                name: '49. What form was the child in last year?',
                translatedName: '49. Foromo sefe selemong se fetileng?',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'dwJns2uXUcG',
                name: 'What program are you studying?',
                translatedName: 'O ithuta lenaneo lefe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'tnaSD0CNrHH',
                name: 'What is your graduation year?',
                translatedName: 'Selemo sa hau sa kabo ea mangolo ke eng?',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'mozNkqqfYRp',
                name: 'Was the child enrolled during the last month ?',
                translatedName: 'Na ngoana o ngolisitsoe khoeling e fetileng?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'YKuTfp8LIRr',
                name:
                '50. During the last month did you miss more than three days of school or vocational training?',
                translatedName:
                '50. Na ngoana o hlotsoe ke sekolo matsatsi a fetang a mararo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'YKuTfp8LIRr_checkboxes',
                name:
                '50. Did the child miss more than three days for any reason?',
                translatedName:
                '50. Na khoeling e fetileng e ngoana o la sitoa ho ea sekolong matsatsi a ka fetang mararo ka mabaka a itseng?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227),
                options: [
                  InputFieldOption(
                      code: 'tY54kDbZs3F',
                      name: 'Fear of the teacher',
                      translatedName: 'Ho t’saba tichere'),
                  InputFieldOption(
                      code: 'lelE0w4yZE0',
                      name: 'Fear of the other children',
                      translatedName: 'Ho tšaba bana ba bang ba sekolo'),
                  InputFieldOption(
                      code: 'bzfp3ELtR1x',
                      name: 'Lack of school materials',
                      translatedName: 'Ho hloka lisebelisoa tsa sekolo'),
                  InputFieldOption(
                      code: 'zKlVUGOqumX',
                      name: 'Illness',
                      translatedName: 'Bokulo'),
                  InputFieldOption(
                      code: 'OyloI2gUb2p',
                      name: 'Other reason',
                      translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'Ey6WeeJVCI7',
                name: 'Specify other reason',
                translatedName:
                'Hlalosa lebaka le leng la ho se ee sekolong nako e fetang matsatsi a mararo',
                valueType: 'TEXT',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'ot2CtK0hAHo',
                translatedName:
                '6. Nakong ea khoeli e fetileng, na u kile oa lofa sekolo kapa koetliso ea mosebetsi oa matsoho ho feta matsatsi a mararo ka lebaka lefe kapa lefe',
                name:
                '6. During the last month,did you miss more than three school/vocational training days?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'VMP6xJWkWHK',
                name:
                'Reasons for missing more than 3 days of school/vocational training',
                translatedName:
                'Hlalosa lebaka le leng la ho se ee sekolong nako e fetang matsatsi a mararo',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'vmvnozO37i7',
                name: '51. Does the child like to go to school?',
                translatedName: '51. Na ngoana o rata ho ea sekolong?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'mtZfZIAkVjt',
                name: '7. Do you like going to school or vocational training?',
                translatedName:
                '7. Na o rata ho ea sekolong kapa koetliso ea mosebetsi oa matsoho?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227)),
            InputField(
                id: 'mtZfZIAkVjt_checkbox',
                name: 'Reasons why a child does not like going to school',
                translatedName: 'Hobaneng ngoana a sa batle ho kena sekolo?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227),
                options: [
                  InputFieldOption(
                      code: 'qK6pCo37tWW',
                      name: 'Fear of the teacher',
                      translatedName: 'Ho t’saba tichere'),
                  InputFieldOption(
                      code: 'Tbga457Gs8B',
                      name: 'Fear of other children',
                      translatedName: 'Ho tšaba bana ba bang ba sekolo'),
                  InputFieldOption(
                      code: 'AYqiBBgPBsR',
                      name: 'Lack of school material',
                      translatedName: 'Ho hloka lisebelisoa tsa sekolo'),
                  InputFieldOption(
                      code: 'I42XGV43sC7',
                      name: 'Illness',
                      translatedName: 'Bokulo'),
                  InputFieldOption(
                      code: 'F8cC7TI5t9b',
                      name: 'Other reason',
                      translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'MNYYB8orI36',
                name: 'Specify other reason',
                translatedName: 'ka kopo, Hlalosa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF9B2BAE),
                labelColor: const Color(0xFF284227))
          ]),
      FormSection(
          name: 'DOMAIN HEALTH',
          translatedName: 'BOPHELO BO BOTLE',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [
            InputField(
                id: 'GN85Cf2mOmw',
                name: 'Is child have health card available?',
                translatedName: 'Is child have health card available?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'eDuHTPn7rhh',
                name:
                'Does the child attend under 5 clinic?',
                translatedName:
                'Does the child attend under 5 clinic?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),

            InputField(
                id: 'H84JX4fQWsK',
                name:
                'In the last month, has the child been too sick or too tired to participate in daily activities?',
                translatedName:
                'Na ngoana o kile a kula kapa a khathala haholo ho a setiloeng ho etsa mabaka a mehla khoeling e fetileng?',
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
                id: 'TQGFUJ7MTPu',
                name:
                'Is the child currently receiving treatment for the illness?',
                translatedName:
                'Na ngoana o fumana kalafo ea ho kula kapa ho holofala?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),


            InputField(
                id: 'MkoDGBOBo06',
                name:  'Where does the child access health services?',
                translatedName:
                "1.U fumana litsebeletso tsa bophelo hokae?",
                allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
                showCountryLevelTree: true,
                valueType: 'ORGANISATION_UNIT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)
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
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'c5TMWtM4VVJ',
                name: 'HIV Status',
                translatedName: '14. Na u nka mpolella sephetho sa hau?',
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
                      code: 'No disclosure',
                      name: 'No disclosure',
                      translatedName: 'Ha a bolele'),
                ]),

            /*InputField(
              id: 'blod3xZ2dPP',
              name: 'Is the child currently taking ART to treat HIV?',
              translatedName: 'Is the child currently taking ART to treat HIV?',
              description: 'If no, refer to HIV care and treatment services.',
              translatedDescription:
              'Ha ase tlasa kalafo fetisetsa setsing sa kalafo.',
              valueType: 'TEXT',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
              options: [
                InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                InputFieldOption(code: '0', name: 'No', translatedName: 'Che'),
              ],
            ),*/

            InputField(
              id: 'Icgkv0xkUow',
              name: 'Currently taking ART to treat HIV?',
              translatedName:
              'Na u tlasa kalafo ea lefu la HIV ha joale?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),
            InputField(
                id: 'wv3YAGLZlev',
                name: 'Which health facility do you visit for ART services?',
                translatedName: 'Which health facility do you visit for ART services?',
                valueType: 'ORGANISATION_UNIT',
                showCountryLevelTree: true,
                allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
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

            InputField(
                id: 'sLyfb45aLkl',
                name: 'Ever had a blood test called viral load?',
                translatedName:
                '9. U kile oa etsa hlahlobo ea mali bakeng sa boemo ba t’soaetso bo maling (viral load)?',
                translatedDescription:
                'Haeba a le litlhareng ho feta khoeli tse tseletseng eba ha a so hlahlobe mali, fetisetsa setsing bakeng sa tlahobo.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                ]),
            InputField(
                id: 'aRNGDZcwWmS',
                name: 'What was the result of your viral load test?',
                translatedName:
                'Sephetho sa tlhahlobo eo ea mali se ne se reng?',
                 translatedDescription:
                'Tlhokomeliso ho Mosebeletsi oa morero, ha ba tlameha ho tseba palo tse nepahetseng empa hore na e holimo kapa e tlase.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'High (above 1,000 copies/ml)',
                      name: 'High (above 1,000 copies/ml)',
                      translatedName: 'E holimo'),
                  InputFieldOption(
                      code: 'Low (less than 1,000 copies/ml)',
                      name: 'Low (less than 1,000 copies/ml)',
                      translatedName: 'E tlase '),
                  InputFieldOption(
                      code: 'Undetectable',
                      name: 'Undetectable (0-50 copies/ml)',
                      translatedName: 'Ha e bonahale'),
                  InputFieldOption(
                      code: 'Not documented',
                      name: 'Not documented',
                      translatedName: 'Ha a tsebe'),
                ]),


            InputField(
                id: 'tYN12Es3707',
                name:
                'Do you have CD4 results?',
                valueType: 'BOOLEAN',
                translatedName:
                'If virally unsuppressed, do you have CD4 results?',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518)),


            InputField(
                id: 'o1GBFscjs4y',
                name: 'What are the CD4 results?',
                translatedName:
                'What are the CD4 results?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Less than 200cells',
                      name: 'Less than 200cells',
                      translatedName: 'E holimo'),
                  InputFieldOption(
                      code: 'More than 200cells',
                      name: 'More than 200cells',
                      translatedName: 'E tlase '),
                  InputFieldOption(
                      code: 'Not documented',
                      name: 'Not documented',
                      translatedName: 'Ha e bonahale'),
                ]),
            /*InputField(
                id: 'ef1ixon3YBh',
                name: '5. OVC ever been tested for HIV?',
                translatedName: '5. Na ngoana o kile a hlahlobela HIV?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),*/


            InputField(
                id: 'hgQXrOd7iuH',
                name: 'Has the childs status been partially shared?',
                translatedName: 'Has the childs status been partially shared?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),

            InputField(
                id: 'Qisosyae92z',
                name: 'What was their response?',
                translatedName: 'What was their response?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'The child experienced denial, but is ok now',
                      name: 'The child experienced denial, but is ok now',
                      translatedName: 'The child experienced denial, but is ok now'),
                  InputFieldOption(
                      code: 'The child became angry, sad or depressed, but is ok now',
                      name: 'The child became angry, sad or depressed, but is ok now',
                      translatedName: 'The child became angry, sad or depressed, but is ok now'),
                  InputFieldOption(
                      code: 'The child is still dealing with denial, anger, sadness, or depression',
                      name: 'The child is still dealing with denial, anger, sadness, or depression',
                      translatedName: 'The child is still dealing with denial, anger, sadness, or depression'),
                ]),
            InputField(
                id: 'EYb2XmgHt58',
                name: 'why was the status not shared with the child?',
                translatedName: 'why was the status not shared with the child?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'They are too young',
                      name: 'They are too young',
                      translatedName: 'They are too young'),
                  InputFieldOption(
                      code: 'Worried about the child experiencing stigma',
                      name: 'Worried about the child experiencing stigma',
                      translatedName: 'Worried about the child experiencing stigma'),
                  InputFieldOption(
                      code: 'Worried about the child having a negative response',
                      name: 'Worried about the child having a negative response',
                      translatedName: 'Worried about the child having a negative response'),
                  InputFieldOption(
                      code: 'Worried about the parent/family experiencing stigma',
                      name: 'Worried about the parent/family experiencing stigma',
                      translatedName: 'Worried about the parent/family experiencing stigma'),
                ]),

            InputField(
                id: 'kcG670LJt3J',
                name: 'Has the childs status been disclosed to any family member?',
                translatedName: 'Has the childs status been disclosed to any family member?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),

            InputField(
                id: 'cEPYE0hDKtH',
                name: 'What was their response?', //Family Member's Response
                translatedName: 'What was their response?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Neutral/ no reaction',
                      name: 'Neutral/ no reaction',
                      translatedName: 'Neutral/ no reaction'),
                  InputFieldOption(
                      code: 'Rejected the child',
                      name: 'Rejected the child',
                      translatedName: 'Rejected the child'),
                ]),


            InputField(
                id: 'EDgB0kYWS3v',
                name:
                'Does the child have a long-term illness that you would like to share with me',
                translatedName:
                'Na oena kapa emong oa ba lelapa o na le bokulo ba nako e telele bo u ka lakatsang ho mpolella bona?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),


            InputField(
                id: 'ut8LqpHyZnR_checkbox',
                name: '5. What is the long-term illness?',
                translatedName:
                '5. Ke bokuli bo fe ba nako e telele?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'WYUkGeSWaZY',
                      name: 'Cancer',
                      translatedName: 'Kankere'),
                  InputFieldOption(
                      code: 'KA3l4V5NDWu',
                      name: 'Epilepsy',
                      translatedName: 'Lefu la Sethoathoa'),
                  InputFieldOption(
                      code: 'NpxDYjUFlKS',
                      name: 'Mental Illness',
                      translatedName: 'Lefu la hlooho'),
                  InputFieldOption(
                      code: 'sftyaTdwBKz',
                      name: 'Diabetes',
                      translatedName: 'Lefu la tsoekere'),
                  InputFieldOption(
                      code: 'bEXtDfYHP4B',
                      name: 'Hypertension',
                      translatedName: 'Phallo e phahamemeng ea mali'),
                  InputFieldOption(
                      code: 'KexFaUmJpt5',
                      name: 'None', translatedName: 'Ha bo eo'),
                  InputFieldOption(
                      code: 'gcW6652C8Bt',
                      name: 'Other',
                      translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'bmJjZctbkhX',
                name: 'Specify Other',
                translatedName: 'Hlalosa tse ling',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'dE3bwyB7guF',
                name: 'Are they receiving treatment for Cancer?',
                translatedName: 'Na o fumana kalafo ea lefu leo la Kankere?',
                description: 'If no, Refer to appropriate health service',
                translatedDescription: 'Fetisetsa litsebeletsong tsa bophel',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                  // InputFieldOption(
                  //     code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'w6xeZ47TwwI',
                name: 'If yes, how',
                translatedName: 'Haeba oa e fumana, u e fumana joang',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'DoctorOrClinics',
                      name: 'Doctor or Clinics',
                      translatedName: 'Setsing sa bophelo'),
                  InputFieldOption(
                      code: 'Traditional healer',
                      name: 'Traditional healer',
                      translatedName: 'Ngaka ea moetlo'),
                  InputFieldOption(
                      code: 'Spiritual healer',
                      name: 'Spiritual healer',
                      translatedName: 'Ngaka ea semoea'),
                  // InputFieldOption(
                  //     code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),

            InputField(
                id: 'NdvnM08tekD',
                name: 'Are they receiving treatment for Epilepsy?',
                translatedName: 'Na o fumana kalafo ea lefu leo la Sethoathoa?',
                description: 'If no, Refer to appropriate health service',
                translatedDescription: 'Fetisetsa litsebeletsong tsa bophel',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                  // InputFieldOption(
                  //     code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'sVpDAdtsGR6',
                name: 'If yes, how',
                translatedName: 'Haeba oa e fumana, u e fumana joang',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'DoctorOrClinics',
                      name: 'Doctor or Clinics',
                      translatedName: 'Setsing sa bophelo'),
                  InputFieldOption(
                      code: 'Traditional healer',
                      name: 'Traditional healer',
                      translatedName: 'Ngaka ea moetlo'),
                  InputFieldOption(
                      code: 'Spiritual healer',
                      name: 'Spiritual healer',
                      translatedName: 'Ngaka ea semoea'),
                  // InputFieldOption(
                  //     code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),

            InputField(
                id: 'eAVGC2zqUjP',
                name: 'Are they receiving treatment for Mental Illness?',
                translatedName: 'Na o fumana kalafo ea lefu leo la kelello?',
                description: 'If no, Refer to appropriate health service',
                translatedDescription: 'Fetisetsa litsebeletsong tsa bophel',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                  // InputFieldOption(
                  //     code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'ir5Pzw7MyIT',
                name: 'If yes, how',
                translatedName: 'Haeba oa e fumana, u e fumana joang',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'DoctorOrClinics',
                      name: 'Doctor or Clinics',
                      translatedName: 'Setsing sa bophelo'),
                  InputFieldOption(
                      code: 'Traditional healer',
                      name: 'Traditional healer',
                      translatedName: 'Ngaka ea moetlo'),
                  InputFieldOption(
                      code: 'Spiritual healer',
                      name: 'Spiritual healer',
                      translatedName: 'Ngaka ea semoea'),
                  // InputFieldOption(
                  //     code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),

            InputField(
                id: 'ehtYoYKxATO',
                name: 'Are they receiving treatment for Diabetes?',
                translatedName: 'Na o fumana kalafo ea lefu leo la tsoekere?',
                description: 'If no, Refer to appropriate health service',
                translatedDescription: 'Fetisetsa litsebeletsong tsa bophel',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                  // InputFieldOption(
                  //     code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'crEW7U1Tbqg',
                name: 'If yes, how',
                translatedName: 'Haeba oa e fumana, u e fumana joang',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'DoctorOrClinics',
                      name: 'Doctor or Clinics',
                      translatedName: 'Setsing sa bophelo'),
                  InputFieldOption(
                      code: 'Traditional healer',
                      name: 'Traditional healer',
                      translatedName: 'Ngaka ea moetlo'),
                  InputFieldOption(
                      code: 'Spiritual healer',
                      name: 'Spiritual healer',
                      translatedName: 'Ngaka ea semoea'),
                  // InputFieldOption(
                  //     code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),

            InputField(
                id: 'z9StVriYu0Q',
                name: 'Are they receiving treatment for Hypertension?',
                translatedName: 'Na o fumana kalafo ea lefu leo la phallo e phahameng ea mali',
                description: 'If no, Refer to appropriate health service',
                translatedDescription: 'Fetisetsa litsebeletsong tsa bophel',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                  // InputFieldOption(
                  //     code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'kn1dKAwP5wD',
                name: 'If yes, how',
                translatedName: 'Haeba oa e fumana, u e fumana joang',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'DoctorOrClinics',
                      name: 'Doctor or Clinics',
                      translatedName: 'Setsing sa bophelo'),
                  InputFieldOption(
                      code: 'Traditional healer',
                      name: 'Traditional healer',
                      translatedName: 'Ngaka ea moetlo'),
                  InputFieldOption(
                      code: 'Spiritual healer',
                      name: 'Spiritual healer',
                      translatedName: 'Ngaka ea semoea'),
                  // InputFieldOption(
                  //     code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),

            InputField(
                id: 'HQdMUzgaIXr',
                name: 'Are they receiving treatment for the other illness?',
                translatedName: 'Na o fumana kalafo ea lefu leo le leng?',
                description: 'If no, Refer to appropriate health service',
                translatedDescription: 'Fetisetsa litsebeletsong tsa bophel',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                  // InputFieldOption(
                  //     code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'mH9DgJoa0nT',
                name: 'If yes, how',
                translatedName: 'Haeba oa e fumana, u e fumana joang',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'DoctorOrClinics',
                      name: 'Doctor or Clinics',
                      translatedName: 'Setsing sa bophelo'),
                  InputFieldOption(
                      code: 'Traditional healer',
                      name: 'Traditional healer',
                      translatedName: 'Ngaka ea moetlo'),
                  InputFieldOption(
                      code: 'Spiritual healer',
                      name: 'Spiritual healer',
                      translatedName: 'Ngaka ea semoea'),
                  // InputFieldOption(
                  //     code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),


            /*InputField(
                id: 'eSJhbqT1NQb',
                name: '6. Latest HIV test result?',
                translatedName:
                '6. Liphetho tsa liteko tsa HIV tsa morao-rao?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
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
                      translatedName: 'Ha e tsejoe'),
                ]),*/




          ]),
      FormSection(
          name: 'TB Screening',
          id:'tbsection_child',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [

          ],
          subSections: [
            FormSection(
                name: '',
                color: const Color(0xFF4B9F46),
                inputFields: [
                  InputField(
                      id: 'C9cpFDvwOUJ',
                      name:
                      'Has the child been coughing?',
                      translatedName:
                      'Has the child been coughing?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'TpyePxydX6K',
                      name: 'Has the child had a fever?',
                      translatedName:
                      'Has the child had a fever?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'dlWawszpssl',
                      name: 'Failure to thrive/faltering growth or signs of severe malnutrition?',
                      translatedName: 'Failure to thrive/faltering growth or signs of severe malnutrition?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'GTIxkgzrJgS',
                      name: 'Has the child been in contact with someone with TB disease?',
                      translatedName: '4. Has the child been in contact with someone with TB disease?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),

                ])
          ]),
      FormSection(
          name: 'NUTRITION',
          id:'nutritionsection',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [

          ],
          subSections: [
            FormSection(
                name: 'Child Nutrition Screening',
                id: 'childnutrition',
                color: const Color(0xFF4B9F46),
                inputFields: [
                  InputField(
                      id: 'JnCFOeouVIy',
                      name: 'Check weight on the growth chart',
                      translatedName: 'Khetha boima ba ngoana bukaneng',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code:
                            'Normal',
                            name:
                            'Normal',
                            translatedName:
                            'Normal'),
                        InputFieldOption(
                            code: 'Flat',
                            name: 'Flat',
                            translatedName: 'Flat'),
                        InputFieldOption(
                            code: 'Falling',
                            name: 'Falling',
                            translatedName: 'Falling'),
                        InputFieldOption(
                            code: 'Above Normal',
                            name: 'Above Normal',
                            translatedName: 'Above Normal'),
                      ]),
                  InputField(
                      id: 'lbr7YOB6HJ1',
                      name: 'How would you describe feeding time with your baby? ',
                      translatedName: 'How would you describe feeding time with your baby? ',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code:
                            'Always Pleasant',
                            name:
                            'Always Pleasant',
                            translatedName:
                            'Always Pleasant'),
                        InputFieldOption(
                            code: 'Sometimes Pleasant',
                            name: 'Sometimes Pleasant',
                            translatedName: 'Sometimes pleasant'),
                        InputFieldOption(
                            code: 'Never Pleasant',
                            name: 'Never Pleasant',
                            translatedName: 'Never Pleasant'),

                      ]),
                  InputField(
                      id: 'child_milk_checkbox',
                      name: 'What type of milk do you feed your baby? ',
                      translatedName: 'What type of milk do you feed your baby?',
                      valueType: 'CHECK_BOX',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF1A3518),
                      options: [
                        InputFieldOption(
                            code: 'EOUH5w2VlIk',
                            name: 'Breast milk',
                            translatedName: 'Breast milk'),
                        InputFieldOption(
                            code: 'iq0qQmJEG8E',
                            name: 'Infant Formula',
                            translatedName: 'Infant Formula'),
                        InputFieldOption(
                            code: 'WciUhLXww99',
                            name: 'Cow Milk',
                            translatedName: 'Cow Milk'),
                        InputFieldOption(
                            code: 'W2cDbQTEky1',
                            name: 'Goat milk ',
                            translatedName: 'Goat milk'),
                        InputFieldOption(
                            code: 'nBoz16EWW4N',
                            name: 'Soy Milk',
                            translatedName: 'Soy Milk'),
                        InputFieldOption(
                            code: 'Oe9HgDtX5iW',
                            name: 'Fat free (Skim) milk',
                            translatedName: 'Fat free (Skim) milk'),
                      ]),
                  InputField(
                      id: 'ATWzSRHBmuF',
                      name:
                      'Has the child unintentionally lost weight?',
                      translatedName:
                      'Has the child unintentionally lost weight? ',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'uINNVU0OeRP',
                      name:
                      'Has the child had poor weight gain over the last few months? ',
                      translatedName:
                      'Has the child had poor weight gain over the last few months?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'bMNyAIWumx1',
                      name:
                      'Has the child been eating/feeding less in the last few weeks ',
                      translatedName:
                      'Has the child been eating/feeding less in the last few weeks',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'OUPk2e9DoMe',
                      name:
                      'Is the child obviously looking underweight? Thin, Ribs protruding from the body, etc.',
                      translatedName:
                      'Is the child obviously looking underweight? Thin, Ribs protruding from the body, etc.',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'eQM7VOlr5hG',
                      name:
                      '	Were there any days last month when your family didn’t have enough food to eat or enough money to buy food?',
                      translatedName:
                      'Were there any days last month when your family didn’t have enough food to eat or enough money to buy food?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'yVTsRM4eMHA',
                      name:
                      'Are there concerns about the general health of a child ',
                      translatedName:
                      'Are there concerns about the general health of a child ',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'OBugEkynJG0',
                      name: 'Are there any signs of malnutrition?',
                      translatedName: 'Are there any signs of malnutrition?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF455B44)),

                  InputField(
                      id: 'XLpBcDQ3p7I',
                      name: 'Child MUAC score',
                      translatedName: 'Child MUAC score',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF1A3518),
                      options: [
                        InputFieldOption(
                            code: '11.5 cm or less',
                            name: '11.5 cm or less(Red)',
                            translatedName: '11.5 cm or less'),
                        InputFieldOption(
                            code: '11.5-12.5cm ',
                            name: '11.5-12.5cm(Yellow) ',
                            translatedName: '11.5-12.5cm '),
                        InputFieldOption(
                            code: '12.5cm or more ',
                            name: '12.5cm or more(Green) ',
                            translatedName: '12.5cm or more '),
                      ]),

                  InputField(
                      id: 'R8SyKEnNi2q',
                      name: 'Does the child attend growth monitoring services?',
                      translatedName: 'Does the child attend growth monitoring services?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF455B44)),
                ]),
          ]),
    ];
  }
}
