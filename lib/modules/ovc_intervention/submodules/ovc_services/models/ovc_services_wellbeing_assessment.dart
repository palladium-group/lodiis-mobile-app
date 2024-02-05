import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcServicesWellbeingAssessment {
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
        formSectionLabel: ' Well-being Assessment Date',
        inputFieldLabel: 'Assessment Date',
        firstDate: firstDate,
      ),
      FormSection(
          name: 'Role/Impact of a Child to the family',
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
          name: 'DOMAIN STABLE',
          translatedName: 'BOTSITSO',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [
            InputField(
                id: 'OBugEkynJG0',
                name: '52. Are there any signs of malnutrition?',
                translatedName: '52. Ngola mat’soao a ho haelloa ke phepo.',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF455B44)),
            InputField(
                id: 'OBugEkynJG0_checkbox',
                name: 'Signs of malnutrition',
                translatedName: 'Matšoao a khaello ea phepo e nepahetseng',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF455B44),
                options: [
                  InputFieldOption(
                      code: 'UHMtTnEP9Yh', name: 'Emaciated and dry skin'),
                  InputFieldOption(code: 'JuHzVswoDKw', name: 'Dry hair'),
                  InputFieldOption(code: 'G5EFtvf5qcF', name: 'Not playing'),
                  InputFieldOption(
                      code: 'g8j8aNxz7lh', name: 'Extremely thirsty'),
                  InputFieldOption(
                      code: 'W9bFXNhcWHN', name: 'Wounds not healing'),
                  InputFieldOption(
                      code: 'B7i1JLk1GIk', name: 'Swollen face and legs'),
                  InputFieldOption(
                      code: 'SSUQsWk0JiA', name: 'Red-orange colored hair'),
                  InputFieldOption(code: 'FmJ0mLOhMSd', name: 'Other signs')
                ]),
            InputField(
                id: 'xQjn7WKtJvm',
                name: 'Specify signs of malnutrition',
                translatedName:
                    'Hlalosa Matšoao a khaello ea phepo e nepahetseng',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF455B44)),
            InputField(
                id: 'aaERjQ9jSZn',
                name:
                    '53. In the past month have you ever gone a whole day or night without eating anything at all because there was not enough food?',
                translatedName:
                    '53. Na ngoana o kile a robala a sa ja khoeling e fetileng?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF455B44)),
            InputField(
                id: 'MEmFZrOhvb3',
                name:
                    '8. In the past month have you ever gone a whole day or night without eating anything at all because there was not enough food?',
                valueType: 'BOOLEAN',
                translatedName:
                    '8. Khoeling e fetileng u kile oa qeta letsatsi kapa bosiu kaofela u sa ja letho hobane ho ne ho se na lijo tse lekaneng?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF455B44)),
            InputField(
                id: 'cGJa4gfVPQ7',
                name: '54. How often would you say this happens?',
                translatedName: '54. u ka re se etsahetse hakae?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF455B44),
                options: [
                  InputFieldOption(
                      code: 'Every night',
                      name: 'Every night',
                      translatedName: 'Bosiu bo bong le bo bong'),
                  InputFieldOption(
                      code: 'A few nights per week',
                      name: 'A few nights per week',
                      translatedName: 'Matsatsi a \'maloa ka beke'),
                  InputFieldOption(
                      code: 'A few nights per month',
                      name: 'A few nights per month',
                      translatedName: 'Masiu a fokolang ka khoeli')
                ]),
            InputField(
                id: 'dTiDozleQuO',
                name:
                    '55. During the past month, did the child receive nutritional supplements?',
                translatedName:
                    '55. Na ngoana o kile a fumana limatlafatsi khoeling e fetileng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF455B44),
                options: [
                  InputFieldOption(
                      code: 'Yes', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: 'No', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: 'I don\'t know',
                      name: 'I don\'t know',
                      translatedName: 'Ha ke tsebe'),
                  InputFieldOption(
                      code: 'No response',
                      name: 'No response',
                      translatedName: 'Ha hona Karabo'),
                  InputFieldOption(
                      code: 'Refuse', name: 'Refuse', translatedName: 'Hana')
                ]),
            InputField(
                id: 'dTiDozleQuO_checkbox',
                name: '56. Nutritional supplements received',
                translatedName:
                    '56. Ngoana o fumane limatlafatsi tsa mofuta ofe?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF455B44),
                options: [
                  InputFieldOption(
                      code: 'sGmUf0A8OG3', name: 'Iron supplement'),
                  InputFieldOption(code: 'DUOFvJnn1R7', name: 'Vitamin A'),
                  InputFieldOption(code: 'gE1zlNMfA1r', name: 'Con Soya'),
                  InputFieldOption(
                      code: 'kqDD44PTEiq',
                      name: 'Therapeutic nutrition (Plumpy Nut)'),
                  InputFieldOption(code: 'Ca0n8YbBSeG', name: 'Food Packages.'),
                  InputFieldOption(
                      code: 'INGfPNUjHxP',
                      name: 'Other',
                      translatedName: 'Tse ling')
                ])
          ]),
      FormSection(
          name: 'DOMAIN HEALTH',
          translatedName: 'BOPHELO BO BOTLE',
          color: const Color(0xFF2895F0),
          borderColor: const Color(0xFF2895F0),
          inputFields: [
            InputField(
                id: 'H84JX4fQWsK',
                name:
                    '58. In the last month, has the child been too sick or too tired to participate in daily activities?',
                translatedName:
                    '58. Na ngoana o kile a kula kapa a khathala haholo ho a setiloeng ho etsa mabaka a mehla khoeling e fetileng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
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
                id: 'AcAWUuDae0A',
                name:
                    '9. In the last month, have you gone more than three days when you were too sick or too tired to participate in daily activities?',
                translatedName:
                    ' 9. Khoeling e fetileng, na u kile oa qeta matsatsi a fetang a mararo u kula haholo kapa u khathetse haholo oa ba oa sitoa ho oa nka karolo mesebetsing ea letsatsi le letsatsi?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'ETI9FukQuNo',
                name:
                    '10. The last time that you were sick, were you taken to the doctor or the hospital?',
                translatedName:
                    '10. Lekhetlo la ho qetela ha une u kula, na u ile oa lo bona ngaka kapa oa ea sepetlele?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'Vc7Q23oTNhu',
                name:
                    '59. Do you have a chronic illness that you would like to share with me?',
                translatedName:
                    '59. ngoana o na le bokuli kapa bokooa boo u ka ratang ho mpolella ka bona?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'qI9a8II1g54',
                name: 'List illness or disability',
                translatedName: 'Thathamisa ho kula kapa bokooa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'ToOqcUP9338',
                name: 'What kind of illness?',
                translatedName: 'Ke bokulo bofe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'TQGFUJ7MTPu',
                name:
                    '60. Is the OVC currently receiving treatment for the illness or disability?',
                translatedName:
                    '60. Na ngoana o fumana kalafo ea ho kula kapa ho holofala?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'lz56QGytZkD',
                name:
                    '61. What kind of services or treatment does the child receive?',
                translatedName:
                    '61. Ke litšebeletso tsa mofuta ofe kapa kalafo eo ngoana a e fumanang?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'lxF2SNfIGa0',
                name: 'From whom does the child receive these services?',
                translatedName: 'Ngoana o fumana litšebeletso tsee ho mang?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'YZ9ORZBKzHk',
                name: 'From whom do you receive treatment for your illness?',
                translatedName: 'O fumana kalafo ho mang ho kula ha hao?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'RC28ZyOhzUQ',
                name: '12. Do you have any disability?',
                translatedName: '12. Na u phela le bokooa? ',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'RC28ZyOhzUQ_checkbox',
                name: 'Which disability do you have?',
                translatedName: 'U na le bokooa bofe?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'rVAImAgvrYe',
                      name: 'Hearing disiability',
                      translatedName: 'Kutlo'),
                  InputFieldOption(
                      code: 'br8TVOKf1ZI',
                      name: 'Speech disability',
                      translatedName: 'Puo'),
                  InputFieldOption(
                      code: 'DExMWJ61fKp',
                      name: 'Physical disability',
                      translatedName: '’Meleng '),
                  InputFieldOption(
                      code: 'LJO2Ar9YytV',
                      name: 'Visual disability',
                      translatedName: 'Pono'),
                  InputFieldOption(
                      code: 'e1KcALoo1ZJ',
                      name: 'Intellectual disability',
                      translatedName: 'Kelello'),
                  InputFieldOption(
                      code: 'YRWFyAhfhRP',
                      name: 'Other',
                      translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'YQVQRnN30O6',
                name: 'Specify other disability',
                translatedName: 'Qaqisa bokooa bo bong',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'puLHlflNeg6',
                name: '62. Do you know child’s HIV status?',
                translatedName: '62. Na u tseba boemo ba ngoana ba HIV?',
                valueType: 'BOOLEAN',
                isReadOnly: true,
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'uMwExnG6Flk',
                name: '13. Have you ever heard talk of HIV?',
                translatedName: '13. Na u kile ua utloa puo ea HIV?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'wO2o2ZqG65D',
                name: 'Where did you hear about HIV?',
                translatedName: 'U utloile kae ka HIV?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'ef1ixon3YBh',
                name: '63. OVC ever been tested for HIV?',
                translatedName: '63. Na ngoana o kile a hlahlobela HIV?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'J4ozQS4koE8',
                name: 'When were you tested?',
                translatedName: 'U ile oa lekoa neng?',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'o2XWRHW5zwb',
                name: 'Do you know the results of your test?',
                translatedName: 'O tseba sephetho sa tlhahlobo eo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'eSJhbqT1NQb',
                name: '64. Latest HIV test result?',
                translatedName:
                    '64. Liphetho tsa liteko tsa HIV tsa morao-rao?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518),
                isReadOnly: true,
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
                  InputFieldOption(
                      code: 'No Response',
                      name: 'No Response',
                      translatedName: 'Ha ho karabo')
                ]),
            InputField(
                id: 'c5TMWtM4VVJ',
                name: '14. Could you share the results of the test with me?',
                translatedName: '14. Na u nka mpolella sephetho sa hau?',
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
                      code: 'No disclosure',
                      name: 'No disclosure',
                      translatedName: 'Ha a bolele'),
                ]),
            InputField(
                id: 'bgJkdPrTnbg',
                name: '15. How did you find out about your HIV status?',
                translatedName: '15. U tsebile joang ka boemo ba hau ba HIV?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Service Provider',
                      name: 'Service Provider',
                      translatedName: 'Mofani oa Tšebeletso'),
                  InputFieldOption(
                      code: 'Mother/Father',
                      name: 'Mother/Father',
                      translatedName: 'Mè / Ntate'),
                  InputFieldOption(
                      code: 'Other adult in the family',
                      name: 'Other adult in the family',
                      translatedName: 'Batho ba bang ba baholo ka lapeng'),
                  InputFieldOption(
                      code: 'Sibling',
                      name: 'Sibling',
                      translatedName: 'Ngoaneso'),
                  InputFieldOption(
                      code: 'Friend',
                      name: 'Friend',
                      translatedName: 'Motsoalle'),
                  InputFieldOption(
                      code: 'Neighbors',
                      name: 'Neighbors',
                      translatedName: 'Baahelani'),
                  InputFieldOption(
                      code: 'Teacher',
                      name: 'Teacher',
                      translatedName: 'Mosuoe'),
                  InputFieldOption(
                      code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'Z51O61hlZMR',
                translatedName: 'Tse ling, hlakisa hlalosa',
                name: 'Specify other ways you found out about your HIV status',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'kqQ3MMTTO2t',
                name: 'How old were you the first time you heard this news?',
                translatedName:
                    'U ne u le lilemo li kae ha u utloa litaba tsee?',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'pU5ywj3cjSA',
                name: '16. Do you take medication for HIV?',
                translatedName: '16. Na u noa litlhare bakeng sa HIV?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'HXk5d3kxy37',
                name: 'Do you have problems taking your treatment?',
                translatedName: 'Na u na le mathata a ho noa litlhare?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'ndK4JCMORL0',
                name: 'How do you cope with those challenges?',
                translatedName: 'U sebetsana joang le mathata ao?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'wv3YAGLZlev',
                name: '17. Which health facility do you visit?',
                translatedName: '17.U nka litlhare setsing sefe sa bophelo?',
                valueType: 'ORGANISATION_UNIT',
                showCountryLevelTree: true,
                allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'Tr5lrn4ctTN',
                name:
                    '18. Who in your household or your life knows about your HIV status?',
                translatedName:
                    '18. Ke bo-mang ka lapeng la hao kapa bophelong ba hao ba tsebang boemo ba hao ba HIV?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
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
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'wi6Iq4yVdXV',
                name: '19. What is their attitude towards you?',
                translatedName: '19. maikutlo a hae ke afe ka oena?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
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
                id: 'gPSf6k0BcWE',
                name:
                    '20. Do you know anyone that is living with HIV in your household?',
                translatedName:
                    '20. Na u tseba motho ea phelang le HIV ka lapeng leno?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'sHUjPZTqpy2',
                name: '65. Is the child currently on ART?',
                translatedName: '65. Na hona joale ngoana o sebelisa li-ART?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF2895F0),
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
                  InputFieldOption(
                      code: 'No response',
                      name: 'No response',
                      translatedName: 'Ha hona Karabo'),
                  InputFieldOption(
                      code: 'Refuse', name: 'Refuse', translatedName: 'Hana')
                ]),
            InputField(
                id: 'VFLlpMdPCTX',
                name: '66. Which health clinic do you take the child?',
                translatedName:
                    '66. U mo isa setsing sefe sa bophelo bakeng sa litlharo?',
                valueType: 'ORGANISATION_UNIT',
                showCountryLevelTree: true,
                allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'VFLlpMdPCTX_checkboxes',
                name: '67. Why do you take the child in that health facility?',
                translatedName:
                    '67. Hobaneng ngoana a ea setsing seo sa bophelo',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'FeL9c9Grwlx',
                      name:
                          'It’s the only place where child treatment is offered',
                      translatedName:
                          'Ke sona fela setsi se fanang ka kalafo bakeng sa bana'),
                  InputFieldOption(
                      code: 'rh90PSJE7fD',
                      name: 'It’s the same place where I go for services',
                      translatedName:
                          'Ke setsi seo ke se sebelisang le nna bakeng sa litsebeletso'),
                  InputFieldOption(
                      code: 'CkbKlcJCkLE',
                      name: 'There’s a good doctor at this clinic',
                      translatedName:
                          'Hona le ngaka e sebetsang hantle setsing sena'),
                  InputFieldOption(
                      code: 'zcKvVCd6d0c',
                      name:
                          'I’m afraid that my family will learn the status of my child',
                      translatedName:
                          ' Ke t’saba hore lelapa le tla tseba boemo ba ngoana oaka'),
                  InputFieldOption(
                      code: 'sdQt641yVBS',
                      name:
                          'I’m afraid that my neighbors will learn the status of my child',
                      translatedName:
                          'Ke t’saba hore baahisane batla tseba boemo ba ngoana oa ka.'),
                  InputFieldOption(
                      code: 'sbgsFW299ND',
                      name:
                          'The doctor at the clinic near us doesn’t treat us well',
                      translatedName:
                          'Ngaka e setsing se haufinyane ha e re sebeletse hantle.'),
                  InputFieldOption(
                      code: 'PErwPNVDZl1',
                      name: 'Other',
                      translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'aRrET00WEbz',
                name: 'Other, Specify',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT'),
            InputField(
                id: 'iZGQ4iWkWNu',
                name: '68. Has the child’s status been shared with the child?',
                translatedName:
                    '68. Na ngoana o ile a bolelloa ka boemo ba hae?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF2895F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'f2GIuwu1LGh',
                name: '69. What was their response?',
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
          name: 'GOALS',
          translatedName: 'SEPHEO',
          description:
              'Caseworker reads: “Now I’m going to ask you some questions about how you would like to grow and improve over the next year.”',
          translatedDescription:
              'Mosebeletsi oa morero: “Joale ke tla u botsa lipotso tse mabapi le kamoo u ka ratang ho hōla le ho ntlafala kateng selemong se hlahlamang."',
          color: const Color(0xFF1B3519),
          inputFields: [
            InputField(
                id: 'ADc3clrQRl4',
                name: 'Goal 1',
                translatedName: 'Sepheo 1',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'WmnbKX3Vj05',
                allowFuturePeriod: true,
                name: 'Timeline for goal 1',
                translatedName:
                    "Nako eo Sepheo 1 se reretsoeng ho phetheloa ka eona",
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'rEIhH5N4z0e',
                name: 'Actions need to take place to accomplish goal 1',
                translatedName: 'Likhato tsa sepheo 1',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'efNgDIqhlNs',
                name: 'Goal 2',
                translatedName: 'Sepheo 2',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'cbxJhkrHUtk',
                allowFuturePeriod: true,
                name: 'Timeline for goal 2',
                translatedName:
                    "Nako eo Sepheo 2 se reretsoeng ho phetheloa ka eona",
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'iDkUpkg6vO6',
                name: 'Actions need to take place to accomplish goal 2',
                translatedName: 'Likhato tsa sepheo 2',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373))
          ]),
    ];
  }
}
