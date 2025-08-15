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
                name:
                'Child have health card?',
                translatedName:
                'Child have health card?',
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
                  InputFieldOption(
                      code: 'I don\'t know',
                      name: 'I don\'t know',
                      translatedName: 'Ha ke tsebe'),
                ]),
            InputField(
                id: 'BQYp4iDUqzN',
                name:
                'Child received support from the clinic?',
                translatedName:'Child received support from the clinic?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'I don\'t know',
                      name: 'I don\'t know',
                      translatedName: 'Ha ke tsebe'),
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
                id: 'zqVpkaulH2m',
                name:
                'Has the child tested as per HEI testing algorithm?',
                translatedName:
                'Has the child tested as per HEI testing algorithm?',
                valueType: 'BOOLEAN',
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

            InputField(
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
                id: 'EDgB0kYWS3v',
                name:
                '2. Do you have a long-term illness that you would like to share with me',
                translatedName:
                '2. Na oena kapa emong oa ba lelapa o na le bokulo ba nako e telele bo u ka lakatsang ho mpolella bona?',
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
                name: '6. Are they receiving treatment for Cancer?',
                translatedName: '6. Na o fumana kalafo ea lefu leo la Kankere?',
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
                name: '6. Are they receiving treatment for Epilepsy?',
                translatedName: '6. Na o fumana kalafo ea lefu leo la Sethoathoa?',
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
                name: '6. Are they receiving treatment for Mental Illness?',
                translatedName: '6. Na o fumana kalafo ea lefu leo la kelello?',
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
                name: '6. Are they receiving treatment for Diabetes?',
                translatedName: '6. Na o fumana kalafo ea lefu leo la tsoekere?',
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
                name: '6. Are they receiving treatment for Hypertension?',
                translatedName: '6. Na o fumana kalafo ea lefu leo la phallo e phahameng ea mali',
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
                name: '6. Are they receiving treatment for the other illness?',
                translatedName: '6. Na o fumana kalafo ea lefu leo le leng?',
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

            InputField(
                id: 'BYZu8p33lzP',
                name: '11. Ever disclosed your status to anyone?',
                translatedName:
                '11. Na ho na le motho eo u kileng oa mojoetsa boemo ba hau ba HIV?',
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
                  InputFieldOption(
                      code: 'No Response',
                      name: 'No Response',
                      translatedName: 'Ha hona Karabo'),
                  InputFieldOption(
                      code: 'NA', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'ToWhhydys',
                name: '12. Who knows about your HIV status?',
                translatedName:
                '12. Ke mang eo u mo joetsitseng ka boemo a hao a HIV?',
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
                  // InputFieldOption(
                  //     code: 'Wfu966TC3M5',
                  //     name: 'Member of the family',
                  //     translatedName: 'Moruti'),
                  InputFieldOption(
                      code: 'J5hjKDmiE6a',
                      name: 'Pastor or priest',
                      translatedName: 'Moruti kapa moprista'),
                  InputFieldOption(
                      code: 'HLPSkYfLYlS',
                      name: 'Other',
                      translatedName: 'Tse ling'),
                  InputFieldOption(
                      code: 'mSc4D4Ij3KN', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'sLyfb45aLkl',
                name: 'Ever had a blood test called viral load?',
                translatedName:
                '9. U kile oa etsa hlahlobo ea mali bakeng sa boemo ba t’soaetso bo maling (viral load)?',
                description:
                'If taking ART for over six months and not tested refer to viral load test.',
                translatedDescription:
                'Haeba a le litlhareng ho feta khoeli tse tseletseng eba ha a so hlahlobe mali, fetisetsa setsing bakeng sa tlahobo.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'aRNGDZcwWmS',
                name: '10. What was the result of your viral load test?',
                translatedName:
                '10. Sephetho sa tlhahlobo eo ea mali se ne se reng?',
                description:
                'Note to Case Management Workers, they do not have to know exact numbers just whether it was high, low or undetectable.',
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
                      name: 'Undetectable',
                      translatedName: 'Ha e bonahale'),
                  InputFieldOption(
                      code: 'Don? know',
                      name: 'Don? know',
                      translatedName: 'Ha a tsebe'),
                  InputFieldOption(
                      code: 'NA', name: 'NA', translatedName: 'N/A')
                ]),



            InputField(
                id: 'Vc7Q23oTNhu',
                name:
                '59. Do you have a chronic illness that you would like to share with me?',
                translatedName:
                '59. ngoana o na le bokuli kapa bokooa boo u ka ratang ho mpolella ka bona?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),

            InputField(
                id: 'puLHlflNeg6',
                name: '62. Do you know child’s HIV status?',
                translatedName: '62. Na u tseba boemo ba ngoana ba HIV?',
                valueType: 'BOOLEAN',
                isReadOnly: true,
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            /*InputField(
                id: 'ef1ixon3YBh',
                name: '5. OVC ever been tested for HIV?',
                translatedName: '5. Na ngoana o kile a hlahlobela HIV?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),*/

            InputField(
                id: 'Tr5lrn4ctTN',
                name:
                'Who in your household or your life knows about your HIV status?',
                translatedName:
                'Ke bo-mang ka lapeng la hao kapa bophelong ba hao ba tsebang boemo ba hao ba HIV?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Mother', name: 'Mother', translatedName: 'Mè'),
                  InputFieldOption(
                      code: 'Father', name: 'Father', translatedName: 'Ntate'),
                  InputFieldOption(
                      code: 'Other caregiver',
                      name: 'Other caregiver',
                      translatedName: 'Mohlokomeli e mong'),
                  InputFieldOption(
                      code: 'Sibling',
                      name: 'Sibling',
                      translatedName: 'Ngoana e mong ka lapeng'),
                  InputFieldOption(
                      code: 'Teacher',
                      name: 'Teacher',
                      translatedName: 'Mosuoe'),
                  InputFieldOption(
                      code: 'Friend',
                      name: 'Friend',
                      translatedName: 'Mohaisane'),
                  InputFieldOption(
                      code: 'Neighbor',
                      name: 'Neighbor',
                      translatedName: 'Baahelani'),
                  InputFieldOption(
                      code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'YTa10rE1vtd',
                name: 'Specify other people know about your HIV status',
                translatedName: 'hlalosa.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'wi6Iq4yVdXV',
                name: 'What is their attitude towards you?',
                translatedName: '19. maikutlo a hae ke afe ka oena?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Discriminates',
                      name: 'Discriminates',
                      translatedName: 'Ho khetholla'),
                  InputFieldOption(
                      code: 'Stigmatizes',
                      name: 'Stigmatizes',
                      translatedName: 'Ho nyelisa'),
                  InputFieldOption(
                      code: 'Encouraging',
                      name: 'Encouraging',
                      translatedName: 'Ho khothatsa'),
                  InputFieldOption(
                      code: 'Supporting',
                      name: 'Supporting',
                      translatedName: 'Ho tšehetsa')
                ]),
            InputField(
                id: 'aRrET00WEbz',
                name: 'Other, Specify',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT'),
            InputField(
                id: 'f2GIuwu1LGh',
                name: 'What was their response?',
                translatedName: '69. Ha a bolelletsoe, o ile a reng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Positive/neutral reaction',
                      name: 'Positive/neutral reaction',
                      translatedName:
                      'Ngoana o na khothetse a sa bontse ho thaba kapa ho koata; '),
                  InputFieldOption(
                      code: 'Experienced denial,but is ok now',
                      name: 'Experienced denial,but is ok now',
                      translatedName:
                      'Ngoana o ne a sa kholoe/lumele, fela o hantle hona joale;'),
                  InputFieldOption(
                      code: 'Angry, sad or depressed,but is ok now',
                      name: 'Angry, sad or depressed,but is ok now',
                      translatedName:
                      'Ngoana o ile a koata aba le khatello ea maikutlo;'),
                  InputFieldOption(
                      code:
                      'Still dealing with denial,anger,sadness/depression',
                      name:
                      'Still dealing with denial,anger,sadness/depression',
                      translatedName:
                      'Ngoana o ntsa sa lumele, o koatile, o na le khatello ea maikutlo;'),
                  InputFieldOption(
                      code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'DrPdwo3pKfN',
                translatedName: 'Tse ling, hlakisa.',
                name: 'Specify other response',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'EYb2XmgHt58',
                name: '70. Why was the status not shared with the child?',
                translatedName:
                '70. hobaneng ngoana a sa bolelloa ka boemo ba hae?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'They are too young',
                      name: 'They are too young',
                      translatedName: 'O monyane haholo'),
                  InputFieldOption(
                      code: 'Worried about child experiencing stigma',
                      name: 'Worried about child experiencing stigma',
                      translatedName:
                      'Ke tsoengoa ke hore ngoana o tla tojoa ke sekhobo'),
                  InputFieldOption(
                      code: 'Worried about child having a -ve response',
                      name: 'Worried about child having a -ve response',
                      translatedName:
                      'Ke tsoengoa ke hore ngoana ha atlo thabela sephetho'),
                  InputFieldOption(
                      code: 'Worried about parent/family experiencing stigma',
                      name: 'Worried about parent/family experiencing stigma',
                      translatedName:
                      'Ke tsoengoa ke hore motsoali kapa lelapa le le tla tojoa sekhobo;'),
                  InputFieldOption(
                      code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'RAlqa0C6PN7',
                name: 'Specify other response',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'kcG670LJt3J',
                name:
                '71. Has the status of the child been disclosed to any family members?',
                valueType: 'BOOLEAN',
                translatedName:
                '71. Na boemo ba ngoana bo ile ba bolelloa litho tse ling tsa lelapa?',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'gAzb8e8cLga',
                name:
                '72. Family response to child HIV status disclosure to them',
                translatedName: '72. ba ile ba reng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Neutral/ no reaction',
                      name: 'Neutral/ no reaction',
                      translatedName: 'Ha ba re letho'),
                  InputFieldOption(
                      code: 'Rejected the child',
                      name: 'Rejected the child',
                      translatedName: 'Ba nena ngoana'),
                  InputFieldOption(
                      code: 'Other, specify',
                      name: 'Other',
                      translatedName: 'Tse ling'),
                ]),
            InputField(
                id: 'oJVaLuSykXO',
                name: 'Specify other response',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
          ]),
      FormSection(
          name: 'DOMAIN SAFE',
          translatedName: 'TSIRELETSO',
          id:'domainsafe',
          color: const Color(0xFFEE6E21),
          borderColor: const Color(0xFFEE6E21),
          inputFields: [
            InputField(
                id: 'zjjAVMVuvxe',
                name: '73. Has the child ever experienced violence?',
                translatedName: '73. Na ngoana o kile a ba le pefo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'wP7nZkrJIlp',
                name:
                '74. Did the child receive or is currently receiving services to help with the abuse problem?',
                translatedName:
                '74. Na ngoana o fumane kapa o ntsa fumana litsebeletso ho mo thusa ka toantso/tlhekefetso eo?',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'I don\'t know',
                      name: 'I don\t know',
                      translatedName: 'Ha ke tsebe'),
                  InputFieldOption(
                      code: 'No response',
                      name: 'No response',
                      translatedName: 'Ha hona Karabo')
                ]),
            InputField(
                id: 'jxOMACHmXXO',
                name: 'From whom?',
                translatedName: 'Ho tsoa ho mang?',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'M0lo7wANrwN',
                name:
                '75. Does the child feel that the abuse problem has been resolved?',
                translatedName:
                '75. Na ngoana o utloa eka bothata ba tlhekefetso bo felile?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'D1ebTZQurSL',
                name:
                '76. How often do you engage with the child by talking, telling stories, singing, playing, assisting with school work?',
                valueType: 'TEXT',
                translatedName:
                '76. Ke ha ngata hakae u qoqang kapa u qoqelang, u binang, u bapalang kapa u thusang ngoana ka mosebetsi oa sekolo',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'All the time',
                      name: 'All the time',
                      translatedName: 'Nako eohle'),
                  InputFieldOption(
                      code: 'Often', name: 'Often', translatedName: 'Ha ngata'),
                  InputFieldOption(
                      code: 'Sometimes',
                      name: 'Sometimes',
                      translatedName: 'Ka nako tse ling'),
                  InputFieldOption(
                      code: 'Rarely',
                      name: 'Rarely',
                      translatedName: 'Ka thata'),
                  InputFieldOption(
                      code: 'Never', name: 'Never', translatedName: 'Hohang')
                ]),
            InputField(
                id: 'hidZMdXFxvR',
                name: '77. Who else would you say the child is close to?',
                translatedName:
                '77. Ho latela bohlokoa ba likamano le likhokahanyo ke mang eo u ka reng ngoano o mo tloaetse haholo?',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Grandfather',
                      name: 'Grandfather',
                      translatedName: 'Ntate moholo'),
                  InputFieldOption(
                      code: 'Grandmother',
                      name: 'Grandmother',
                      translatedName: 'Nkhono'),
                  InputFieldOption(
                      code: 'Uncle',
                      name: 'Uncle',
                      translatedName: 'Malome/Rangoane'),
                  InputFieldOption(
                      code: 'Aunt',
                      name: 'Aunt',
                      translatedName: 'Rakhali/Mangoane'),
                  InputFieldOption(
                      code: 'Sibling',
                      name: 'Sibling',
                      translatedName: 'Ngoana oa bo'),
                  InputFieldOption(
                      code: 'Other', name: 'Other', translatedName: 'Ba bang')
                ]),
            InputField(
                id: 'p82MlDNDGxs',
                name: 'Specify other person close to the child',
                translatedName: 'Tse ling, hlakisa.',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'XG1a90T7iBF',
                name: '78. Does the child have a birth certificate?',
                translatedName: '78. Na ngoana o na le lengolo la tlhaho?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'iQcx8GPINN0',
                name:
                '79. How often does this child play with other friends and family members?',
                translatedName:
                '79. Ke ha ngata hakae ngoana eo a bapalang le metsoalle ea hae kapa ba lelapa?',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'All the time',
                      name: 'All the time',
                      translatedName: 'Nako eohle'),
                  InputFieldOption(
                      code: 'Often', name: 'Often', translatedName: 'Ha ngata'),
                  InputFieldOption(
                      code: 'Sometimes',
                      name: 'Sometimes',
                      translatedName: 'Ka nako tse ling'),
                  InputFieldOption(
                      code: 'Rarely',
                      name: 'Rarely',
                      translatedName: 'Ka thata'),
                  InputFieldOption(
                      code: 'Never', name: 'Never', translatedName: 'Hohang')
                ]),
            InputField(
                id: 'RykOGTu3wcd',
                name:
                '80. Has anyone ever beaten/slapped/spanked or hit the child with a belt, a stick or something hard?',
                translatedName:
                '80. Na ho na le motho ea kileng a otla kapa a otla ngoana ka lebanta, molamu kapa ntho e \'ngoe e thata?',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'No response',
                      name: 'No response',
                      translatedName: 'Ha hona Karabo')
                ]),
            InputField(
                id: 'iUO02DiUftg',
                name:
                '81. How often has someone beaten/slapped/spanked the child, or hit them with a belt, a stick or something hard?',
                valueType: 'TEXT',
                translatedName:
                '81. Ke hangata hakae motho a otlang kapa a otlang ngoana ka lebanta, thupa kapa ntho e \'ngoe e thata? U ka re ho joalo',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Almost everyday',
                      name: 'Almost everyday',
                      translatedName: 'Nako eohle'),
                  InputFieldOption(
                      code: 'Once in a while',
                      name: 'Once in a while',
                      translatedName: 'Hangata'),
                  InputFieldOption(
                      code: 'Long time ago',
                      name: 'Long time ago',
                      translatedName: 'Ka linako tse ling'),
                  InputFieldOption(
                      code: 'No response',
                      name: 'No response',
                      translatedName: 'Ha ho Karabo')
                ]),
            InputField(
                id: 'HqNP6ovZw3p',
                name:
                '82. Was the child ever left with bruises, burns, broken bones or teeth, or other injury?',
                translatedName:
                '82. na ngoana ola sala ale metopa, eka o chele kapa a robehile masapo kapa meno, kapa maqeba a mang?',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'No response',
                      name: 'No response',
                      translatedName: 'Ha hona Karabo')
                ]),
            InputField(
                id: 'fe0pgVexVbx',
                name:
                '83. Did the child receive or is currently receiving services to help with this problem?',
                translatedName:
                '83. na ngoana o ntsa fumana litsebeletso bakeng sa bothata bo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'kslj60leTJf',
                name:
                '84. Is there someone in the household /neighbourhood who is or has behaved inappropriately with the child?',
                translatedName:
                '84. hona le motho ka hara lelapa kapa baahisane a kileng a itsoara ka tsela e sa tloaelehang ka pela ngoana eo? ',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'LjhWZuKCIJu',
                name: 'Who has behaved inappropriately with the child?',
                translatedName: 'Ke mang ea itšoereng hampe ka ngoana?',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'gdooctJzx2o',
                name:
                '23. Would you say that your caregiver listens when you talk to him/her?',
                translatedName:
                '23. Na u ka re mohlokomeli oa hao oa mamela ha u bua le eena?',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'All the time',
                      name: 'All the time',
                      translatedName: 'Nako eohle'),
                  InputFieldOption(
                      code: 'Often',
                      name: 'Often',
                      translatedName: 'Hangata'),
                  InputFieldOption(
                      code: 'Sometimes',
                      name: 'Sometimes',
                      translatedName: 'Ka linako tse ling'),
                  InputFieldOption(
                      code: 'Rarely',
                      name: 'Rarely',
                      translatedName: 'Hase ka mehla'),
                  InputFieldOption(
                      code: 'Never',
                      name: 'Never',
                      translatedName: 'Hohang')
                ]),
            InputField(
                id: 't1VRnFuBb7I',
                name:
                '22. Are you receiving any child or social protection support?',
                translatedName:
                '22. Na ho nale ts’ehetso/thuso eo u e fumanang ea sechaba?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 't1VRnFuBb7I_checkbox',
                name: 'Child or social protection support received',
                valueType: 'CHECK_BOX',
                translatedName:
                'Ts\'ehetso ea ts\'ireletso ea bana kapa ea sechaba e amohetse',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'seiWBkesnnc',
                      name: 'Social Grant',
                      translatedName: 'Thuso ea lichelete'),
                  InputFieldOption(
                      code: 'pQ4cUirRxqK',
                      name: 'Public Assistance',
                      translatedName: 'Thuso ea Sechaba'),
                  InputFieldOption(
                      code: 'GI0cqcBMSUV', name: 'School Bursaries'),
                  InputFieldOption(
                      code: 'MMOeHPgpVj5',
                      name: 'Food Packages',
                      translatedName: 'Lijo'),
                  InputFieldOption(
                      code: 'CmJLjd2HxD7',
                      name: 'Other',
                      translatedName: 'Tse ling'),
                ]),
            InputField(
                id: 'nLoEbs7cRIu',
                name: 'Specify which public Assistance',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'LU0OIdYmV7K',
                name: 'Specify other child or social supports',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'ahAIJZ9IkCV',
                name:
                '23. Are you comfortable to seek help and advice with problems (emotional) and he/she will help to solve them?',
                valueType: 'TEXT',
                translatedName:
                '24.  Na u phutholohile ho batla thuso le likeletso ka mathata (maikutlo) mme o fumane thuso ea ho rarolla mathata a hau?',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'All the time',
                      name: 'All the time',
                      translatedName: 'Nako eohle'),
                  InputFieldOption(
                      code: 'Often',
                      name: 'Often',
                      translatedName: 'Hangata'),
                  InputFieldOption(
                      code: 'Sometimes',
                      name: 'Sometimes',
                      translatedName: 'Ka linako tse ling'),
                  InputFieldOption(
                      code: 'Rarely',
                      name: 'Rarely',
                      translatedName: 'Hase ka mehla'),
                  InputFieldOption(
                      code: 'Never',
                      name: 'Never',
                      translatedName: 'Hohang')
                ]),
            InputField(
                id: 'MxioydJaOgX',
                name:
                '24. Do you feel like your opinion is heard about you and your life?',
                translatedName:
                '25. Na u ikutloa eka maikutlo a hao a utloahala ka oena le ka bophelo ba hao?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'ebeAKSCVsYo',
                name: '25. Can you cope in difficult situations?',
                translatedName: '26. Na u ka sebetsana le maemo a thata?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'XXHMvERCGLn',
                name: 'Why can\'t you cope in difficult situations?',
                translatedName:
                'Hobaneng o sa khone ho sebetsana le maemo a thata?',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'MlcK6DAGoCx',
                name:
                '26. Do you have friends that are older than you who buy or give you gifts?',
                valueType: 'BOOLEAN',
                translatedName:
                '27. Na u na le metsoalle e ka holimo ho oena ka lilemo e u rekelang kapa e u fang limpho?',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'W91GgtMqWnl',
                name:
                'Do you feel pressure to do anything in exchange for the gifts?',
                translatedName:
                'Na u ikutloa u hatelloa ho etsa ntho efe kapa efe e le phapanyetsano bakeng sa limpho?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'sM8amXv7Nck',
                name: 'Who helped with child abuse problem?',
                translatedName:
                'Ke mang ea thusitseng ka bothata ba tlhekefetso ea bana?',
                valueType: 'TEXT',
                inputColor: const Color(0xFFEE6E22),
                labelColor: const Color(0xFF1A3518))
          ]),
      FormSection(
          name: 'TB Screening',
          id:'tbsection_adolescent',

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
                      id: 'tMvluCbiiUm',
                      name:
                      '1.	Are you coughing?',
                      translatedName:
                      '1.	Are you coughing?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'P9hiqrTjAdg',
                      name: '2.	Have you lost weight (without trying)?',
                      translatedName:
                      '2.	Have you lost weight (without trying)?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'Y8Xzy7bEWsi',
                      name: '3.	Do you have drenching/soaking sweats at night?',
                      translatedName: '3.	Do you have drenching/soaking sweats at night?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'VETgonq6tFr',
                      name: '4.	Do you have fevers?',
                      translatedName: '4.	Do you have fevers?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),

                ])
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
                      '1.	Has the child been coughing?',
                      translatedName:
                      '1.	Has the child been coughing?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'TpyePxydX6K',
                      name: '2.	Has the child had a fever?',
                      translatedName:
                      '2.	Has the child had a fever?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'dlWawszpssl',
                      name: '3.	Failure to thrive/faltering growth or signs of severe malnutrition?',
                      translatedName: '3.	Failure to thrive/faltering growth or signs of severe malnutrition?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'GTIxkgzrJgS',
                      name: '4.	Has the child been in contact with someone with TB disease?',
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
                name: 'Nutrition Section',
                id: 'generalnutrition',
                color: const Color(0xFF4B9F46),
                inputFields: [
                  InputField(
                      id: 'UDyg5PFj12b',
                      name: 'Which food groups do you regularly eat?',
                      translatedName: 'Which food groups do you regularly eat?',
                      description: 'Energy foods,Body BUiding foods or Protective foods',
                      translatedDescription: 'Energy foods,Body BUiding foods or Protective foods',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF1A3518),
                      options: [
                        InputFieldOption(code: '1', name: 'One type of food group', translatedName: 'One types of food groups'),
                        InputFieldOption(
                            code: '2', name: 'Two types of food groups', translatedName: 'Two types of food groups'),
                        InputFieldOption(
                            code: '3', name: 'All types of food groups', translatedName: 'All types of food groups')
                      ]),
                ]),
            FormSection(
                name: 'Child Nutrion Screening',
                id: 'childnutrition',
                color: const Color(0xFF4B9F46),
                inputFields: [
                  InputField(
                      id: 'JnCFOeouVIy',
                      name: '1. Check weight on the growth chart',
                      translatedName: '1. Khetha boima ba ngoana bukaneng',
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
                      name: '2. How would you describe feeding time with your baby? ',
                      translatedName: '2. How would you describe feeding time with your baby? ',
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
                      id: 'ATWzSRHBmuF',
                      name:
                      '3. Has the child unintentionally lost weight?',
                      translatedName:
                      '3.	Has the child unintentionally lost weight? ',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'uINNVU0OeRP',
                      name:
                      '4.	Has the child had poor weight gain over the last few months? ',
                      translatedName:
                      '4. Has the child had poor weight gain over the last few months?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'bMNyAIWumx1',
                      name:
                      '5.	Has the child been eating/feeding less in the last few weeks ',
                      translatedName:
                      '5. Has the child been eating/feeding less in the last few weeks',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'OUPk2e9DoMe',
                      name:
                      '6. Is the child obviously looking underweight? Thin, Ribs protruding from the body, etc.',
                      translatedName:
                      '6. Is the child obviously looking underweight? Thin, Ribs protruding from the body, etc.',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'eQM7VOlr5hG',
                      name:
                      '7.	Were there any days last month when your family didn’t have enough food to eat or enough money to buy food?',
                      translatedName:
                      '7. Were there any days last month when your family didn’t have enough food to eat or enough money to buy food?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'yVTsRM4eMHA',
                      name:
                      '8.	Are there concerns about the general health of a child ',
                      translatedName:
                      '8.	Are there concerns about the general health of a child ',
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
                ]),
          ]),
    ];
  }
}
