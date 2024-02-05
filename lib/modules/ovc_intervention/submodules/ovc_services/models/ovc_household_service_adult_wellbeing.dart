import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcHouseholdServiceAdultWellbeing {
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
        formSectionLabel: 'HouseHold Assessment Date',
        inputFieldLabel: 'Assessment Date',
        firstDate: firstDate,
      ),
      FormSection(
          name: 'DOMAIN STABLE',
          translatedName: 'BOTSITSO',
          color: const Color(0xFF4B9F46),
          description:
              'Case Management Worker reads: “Assets are things that are useful and valuable to you. For example, they can be people because each person has knowledge, skills, and talents.”',
          translatedDescription:
              'Mosebeletsi oa morero o oa bala: “Thepa ke lintho tse molemo li bile li le bohlokoa ho oena. Mohlala e ka ba batho hobane motho ka mong o na le litsebo, mahlale le litalenta tse itseng.”',
          borderColor: const Color(0xFF4B9F46),
          inputFields: [
            InputField(
                id: 'How-do-you-help-your-family',
                name: '1. How do you help your family?',
                translatedName: '1. U thusa lelapa la hau joang?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'CjAlp228JXu',
                      name: 'Providing money',
                      translatedName: 'Ho fana ka chelete'),
                  InputFieldOption(
                      code: 'O4i1IMcrjNP',
                      name: 'Looking after the children',
                      translatedName: 'Ho hlokomela bana'),
                  InputFieldOption(
                      code: 'dGQN8qr47k5',
                      name: 'House chores',
                      translatedName: 'Ho thusa ka mesebetsi ea lelapa'),
                  InputFieldOption(
                      code: 'rSOF0xwHBfp',
                      name: 'Collecting water and/ or wood',
                      translatedName: 'Ho kha metsi le ho roalla'),
                  InputFieldOption(
                      code: 'UZVG6KG5Rtm',
                      name: 'Taking care of animals',
                      translatedName: 'Ho sebetsa masimong'),
                  InputFieldOption(
                      code: 'eD5eOF5nYGS',
                      name: 'Providing food & other household items',
                      translatedName: 'Ho reka lijo le thepa engoe ea lelapa'),
                  InputFieldOption(
                      code: 'PiXi6AtLqiQ',
                      name: 'Other',
                      translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'zUU33n41Soa',
                name: 'Other: Please specify',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF1A3518),
                labelColor: const Color(0xFF4A9F46)),
            InputField(
                id:
                    'How-do-other-adults-in-your-household-and-those-not-living-with-you-help-you',
                name:
                    '2. How do other adults in your household and those not living with you help you?',
                translatedName:
                    '2. Batho ba bang ba baholo bao u lulang le bona le ba u sa luleng le bona ba u thusa joang? ',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'cIvR9TgW8Bx',
                      name: 'Not applicable (no other adults)'),
                  InputFieldOption(
                      code: 'd5Z8bqGYGha',
                      name: 'Provide money',
                      translatedName: 'Ho fana ka chelete'),
                  InputFieldOption(
                      code: 'OPZgRaCoCix',
                      name: 'Help you look after the children',
                      translatedName: 'Ho hlokomela bana'),
                  InputFieldOption(
                      code: 'HIhJEBccb4s',
                      name: 'Help you with house Chores',
                      translatedName: 'Ho thusa ka mesebetsi ea lelapa'),
                  InputFieldOption(
                      code: 'rBoJRVqlWpD',
                      name: 'Work on the farms',
                      translatedName: 'Ho sebetsa masimong'),
                  InputFieldOption(
                      code: 'z2Pq08hpx51',
                      name: 'Collecting water and/ or wood',
                      translatedName: 'Ho kha metsi le ho roalla'),
                  InputFieldOption(
                      code: 'zk0W0bDbTls',
                      name: 'Taking care of animals',
                      translatedName: 'Ho hlokomela liphoofolo'),
                  InputFieldOption(
                      code: 'iSE037kVfFJ',
                      name: 'Provide food & other household items',
                      translatedName: 'Ho reka lijo le thepa engoe ea lelapa'),
                  InputFieldOption(
                      code: 'oD8mSMj2cjD',
                      name: 'Earn extra money',
                      translatedName: 'ho fumana chelete engoe'),
                  InputFieldOption(
                      code: 'yqwX3XCGAUN',
                      name: 'Other',
                      translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'BKDRNiyoMgV',
                name: 'Other, Specify (Other adults)',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'income_source',
                translatedName: '3. U fumana chelete joang?',
                name: '3. What is your source of income?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'ClMA0dgfvIh',
                      name: 'Employed',
                      translatedName: 'Mosebetsi'),
                  InputFieldOption(
                      code: 'WzSkHuD5iRt',
                      name: 'Casual Laborer',
                      translatedName: 'Mosebetsi oa nako e khutsoane '),
                  InputFieldOption(
                      code: 'JGDnvDvmHGT',
                      name: 'Small business',
                      translatedName: 'Khoebo e nyane'),
                  InputFieldOption(
                      code: 'LGrG9fGZfXP',
                      name: 'Unemployed',
                      translatedName: 'Ha ke sebetse'),
                  InputFieldOption(
                      code: 'Js9auywpL0O',
                      name: 'Other',
                      translatedName: 'Tse ling'),
                ]),
            InputField(
                id: 'SQUodtvxYLs',
                name: 'Other, Specify',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'ZuaV20IvVV2',
                name: '4. Is your work regular or irregular?',
                translatedName:
                    '4. Mosebetsi oa hau ke oa ka mehla kapa ke oa nakoana?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Regular',
                      name: 'Regular',
                      translatedName: 'Ka mehla'),
                  InputFieldOption(
                      code: 'Irregular',
                      name: 'Irregular',
                      translatedName: 'Ke oa nakoana'),
                ]),
            InputField(
                id: 'kCuxe1Psh8E',
                name: 'Select frequency',
                translatedName: 'khetha linako',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Daily',
                      name: 'Daily',
                      translatedName: 'Oa matsatsi'),
                  InputFieldOption(
                      code: 'Sometimes a month',
                      name: 'Sometimes a month',
                      translatedName: 'Oa nako tseling tsa khoeli'),
                  InputFieldOption(
                      code: 'Fulltime',
                      name: 'Fulltime',
                      translatedName: 'Oa nako eohle	'),
                  InputFieldOption(
                      code: 'Once a week',
                      name: 'Once a week',
                      translatedName: 'Hang ka khoeli'),
                  InputFieldOption(
                      code: 'During some seasons',
                      name: 'During some seasons',
                      translatedName: 'Linako tse ling tsa selemo'),
                  InputFieldOption(
                      code: 'Other', name: 'Other', translatedName: 'Tse ling'),
                ]),
            InputField(
                id: 'lnFXCB5NcYk',
                name: 'Other, Specify (work frequecny)',
                translatedName: 'Tse ling, Hlalosa',
                valueType: 'TEXT'),
            InputField(
                id: 'p8htbyJHydl',
                name:
                    '5. Are you able to regularly meet the needs of your children (school fees, medication, clothes, housing)?',
                translatedName:
                    '5. Na u khona ho phetha tlhoko tsa bana ba hao ka mehla (tefiso tsa sekolo, taba tsa bongaka, liaparo, moaho)?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'p8htbyJHydl_checkbox',
                name: 'If yes, indicate how',
                translatedName: 'Ha Karabo e le “E”, hlakisa joang ',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'kFRCZNQIF51',
                      name: 'Savings',
                      translatedName: 'Lipoloko'),
                  InputFieldOption(
                      code: 'Pe3CHmZicqT',
                      name: 'Grants',
                      translatedName: 'Lithuso tsa lichelete tsa ‘muso'),
                  InputFieldOption(
                      code: 'DgzwMbXo0ZK',
                      name: 'Salary/Wages',
                      translatedName: 'Mokholo'),
                  InputFieldOption(
                      code: 'GC6eZ5TOt9z',
                      name: 'Pension',
                      translatedName: 'Penchele'),
                  InputFieldOption(
                      code: 'bKkHP4C1WzO',
                      name: 'Selling of assests',
                      translatedName: 'Ho rekisa thepa'),
                  InputFieldOption(
                      code: 'gmVjuNTq31c',
                      name: 'Borrowing',
                      translatedName: 'Ho kalima'),
                  InputFieldOption(
                      code: 'roCpGtUYOhp',
                      name: 'Self-employed (business/farming/fishing)',
                      translatedName: 'Ho it’sebetsa (khoebo/temo)'),
                  InputFieldOption(
                      code: 'mXBvp9ahws3',
                      name: 'Support of well-wishers',
                      translatedName:
                          'T’sehetso ea ka ba lelapa kapa metsoalle'),
                  InputFieldOption(
                      code: 'jtCijspeacL',
                      name: 'Other programs/bursaries',
                      translatedName:
                          'mafapha a mang/lit’sehetso ea lichelete bakeng sa sekolo')
                ]),
            InputField(
                id: 'Vur0hsmfhQ5',
                name: 'Others',
                translatedName: 'Tse ling',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id:
                    'If-today-you-had-an-unplanned-expense-for-the-family,-how-would-you-respond-in-meeting-this-need',
                name:
                    '6. If today you had an unplanned expense for the family, how would you respond in meeting this need?',
                translatedName:
                    '6. Haeba u ne u kaba le tlhoko e sa reroang tsatsing lee bakeng sa lelapa, u ne u ka arabela tlhoko e joalo joang? ',
                description:
                    'Unplanned expenses include: food, schooling, healthcare, natural calamities such as funeral, fire, floods, drought.',
                translatedDescription:
                    'Tlhoko tse sa reroang tsa lelapa li kenyeletsa: lijo, sekolo, bokuli, mokhohlane, likhohola mollo, komello ',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'sg0Xb00g4Cm',
                      name: 'My salary',
                      translatedName: 'Mokholo'),
                  InputFieldOption(
                      code: 'WsmCWZnrldc',
                      name: 'My savings',
                      translatedName: 'Lipoloko'),
                  InputFieldOption(
                      code: 'VYyrkhWsf3e',
                      name: 'A loan from family or friend',
                      translatedName:
                          'Mokoloto ho tsoa ho emong oa lelapa kapa motsoalle'),
                  InputFieldOption(
                      code: 'EK531jw3C8s',
                      name: 'A loan from Micro-finance group',
                      translatedName: 'Mokoloto ho tsoa mokhatlong '),
                  InputFieldOption(
                      code: 'lUtqQEPBJsc',
                      name: 'A loan from a money lender',
                      translatedName: 'Mokoloto ho tsoa ho machonisa'),
                  InputFieldOption(
                      code: 'Inkzrxg621l',
                      name: 'Hawking/market vending',
                      translatedName: 'Rekisa ntho tse nyanyane'),
                  InputFieldOption(
                      code: 'MvM4Kl6bvLd',
                      name: 'Sell off family assests',
                      translatedName: 'Rekisa thepa ea lelapa'),
                  InputFieldOption(
                      code: 'yfE4U124drd',
                      name: 'Sell/exchange food',
                      translatedName: 'Rekisa kapa chenchisana ka lijo'),
                  InputFieldOption(
                      code: 'VLlIBeTWT2r',
                      name: 'Unable to meet unplanned needs/expenses',
                      translatedName:
                          'Ha ke khone ho fihlela litlhoko tse sa reroang')
                ]),
            InputField(
                id: 'kuRUBMvgjZy',
                name: '7. Are you a member of a savings group?',
                translatedName: '7. Na u setho sa mokhatlo oa lipoloko?',
                description:
                    'If no, connect/refer them to SILC, VSL or microcredit.',
                translatedDescription:
                    'Ha ese setho mo fetisetse mokhatlong oa mokhatlo oa li poloko le likalimo (SILC).',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'Do-you-know-of-any-of-the-following-programs',
                name: '8. Do you know of any of the following programs?',
                translatedName:
                    '8. Na u oa tseba ka manane tsebetso a latelang?',
                description:
                    'If necessary, link the household to the services they are not accessing.',
                translatedDescription:
                    'Ha ho hlokahala hokahanya lelapa le litsebeletso tseo ba sa li fumaneng. ',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'DcDA1A6YdYZ',
                      name: 'Child grant',
                      translatedName: 'Thuso ea chelete ea bana'),
                  InputFieldOption(
                      code: 'TpNCQQeaPtF',
                      name: 'Public assistance in cash',
                      translatedName: 'Thuso ea chelete ea sechaba'),
                  InputFieldOption(
                      code: 'j5dpw68MH8L',
                      name: 'Old age pension',
                      translatedName: 'Penchele ea maqheku/maqhekoana'),
                  InputFieldOption(
                      code: 'wtyPIIc4I4q',
                      name: 'Food',
                      translatedName: 'Lithuso tsa lijo'),
                  InputFieldOption(
                      code: 'aPgHmhjvpOq',
                      name: 'School bursaries',
                      translatedName: 'Lithuso tsa sekolo'),
                  InputFieldOption(
                      code: 'igsx50T6JZ8',
                      name: 'Farm Supplies',
                      translatedName: ' Thuso ea thepa ea masimo'),
                  InputFieldOption(
                      code: 'doJJzw4NX8m',
                      name: 'No',
                      translatedName: 'Ha ke tsebe')
                ]),
            InputField(
                id: 'doJJzw4NX8m_checkbox',
                name:
                    'If yes, do you participate in any of the following programs? ',
                translatedName:
                    'Ha karobo le “E”; na u karolo ea manane tsebetso a latelang? ',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'lBQzVBwO3q0',
                      name: 'Child grant',
                      translatedName: 'Thuso ea chelete ea bana'),
                  InputFieldOption(
                      code: 'hLl7wKXZMBc',
                      name: 'Public assistance in cash',
                      translatedName: 'Thuso ea chelete ea sechaba'),
                  InputFieldOption(
                      code: 'f0gSCFVtGiy',
                      name: 'Old age pension',
                      translatedName: 'Penchele ea maqheku/maqhekoana'),
                  InputFieldOption(
                      code: 'vfah83KH19V',
                      name: 'Food',
                      translatedName: 'Thuso tsa lijo'),
                  InputFieldOption(
                      code: 'i6JeeDn3pXR',
                      name: 'School bursaries',
                      translatedName: 'Thuso tsa sekolo'),
                  InputFieldOption(
                      code: 'j4OVpjDF1Sp',
                      name: 'Farm Supplies',
                      translatedName: 'Thuso ea thepa ea masimo '),
                  InputFieldOption(
                      code: 'JojbPlav7NK', name: 'No', translatedName: 'Che')
                ]),
            InputField(
                id: 'iqBsSAfCyJb',
                name:
                    '9. Which food groups do you regularly serve to your family?',
                translatedName:
                    '9. Ke sehlopha sefeng sa lijo seo le se jang ka mehla?',
                description:
                    '1. Energy foods: Papa, potatoes, bananas, oil, sorghum, rice, Bread\n 2. Body building foods: beans, meat, peas, milk, eggs, fish\n3. Protective foods: peaches, pineapples, mangos, pawpaw, oranges, tomatoes, avocado, guavas, bananas, vegetables.',
                translatedDescription:
                    '1. limatlafatsi: Papa, litapole, libanana, oli, mabele, rice, bohobe\n2. lihahammele: linaoa, nama, lierekisi, lebese, mahe, tlhapi\n3. lithibela mafu: liperekisi, pineapple, mango, linamuni, tamati, meroho.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'One type of food group',
                      name: 'One type of food group',
                      translatedName: 'Mofuta o le mong oa sehlopha sa lijo'),
                  InputFieldOption(
                      code: 'Two types of food groups',
                      name: 'Two types of food groups',
                      translatedName: 'Mefuta e mmeli ea lihlopha tsa lijo '),
                  InputFieldOption(
                      code: 'All types of food groups',
                      name: 'All types of food groups',
                      translatedName: 'Mefuta eohle ea lihlopha tsa lijo ')
                ]),
            InputField(
                id:
                    'Over-the-past-one-month,-where-did-you-get-the-food-that-your-family-ate',
                name:
                    '10. Over the past one month, where did you get the food that your family ate?',
                translatedName:
                    '10. Khoeling e fetileng, lijo tse le li jeleng lapeng la hau le ne le li fumana joang?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'wmLRH6610AU',
                      name: 'Bought from the market',
                      translatedName: 'Li rekiloe mmarakeng'),
                  InputFieldOption(
                      code: 'jKDvieE2uqt',
                      name: 'Home grown',
                      translatedName: 'Li lengoe hae'),
                  InputFieldOption(
                      code: 'U1CMdc0LPcC',
                      name: 'Given as payment',
                      translatedName: 'Li fanoe ele patala'),
                  InputFieldOption(
                      code: 'NxZ4e9lRTQN',
                      name: 'Donation',
                      translatedName: 'Limpho')
                ]),
            InputField(
                id: 'What-type-of-disability-do-you-have',
                name: '11. What type of disability do you have?',
                translatedName:
                    '11. Ke mofuta ofe oa bokooa bo u nang le bona?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'iXf2St64o0a',
                      name: 'No disability',
                      translatedName: 'Ha hona bokooa '),
                  InputFieldOption(
                      code: 'tCWY79n1TVX',
                      name: 'Hearing',
                      translatedName: 'Kutlo'),
                  InputFieldOption(
                      code: 'MKjurF1bdM5',
                      name: 'Physical',
                      translatedName: 'Mmele'),
                  InputFieldOption(
                      code: 'vVDAi6u92Vg',
                      name: 'Intellectual',
                      translatedName: 'Kelello'),
                  InputFieldOption(
                      code: 'q1EdZ0EjKTQ',
                      name: 'Speech',
                      translatedName: 'Puo'),
                  InputFieldOption(
                      code: 'e2RII5ZewNg',
                      name: 'Visual',
                      translatedName: 'Pono'),
                  InputFieldOption(
                      code: 'W3N2e2SaBCp',
                      name: 'Other',
                      translatedName: 'Bo bong')
                ]),
            InputField(
                id: 'jvbE4vFHjA6',
                name: 'Other Specify',
                translatedName: 'Bo bong (hlakisa)',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'JcaEaDrtOFj',
                name:
                    '12. Is the person with disability receiving services for the disability?',
                translatedName:
                    '12. Na motho ea nang le bokooa o fumana litsebeletso tsa bokooa boo?',
                description: 'If no, refer to health or disability services.',
                translatedDescription:
                    'Ha asa fumane litsebeletso fetisetsa moo ho fanoang ka tsebeletso tsa bophelo kapa tsa bokooa.',
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
                id: 'ut8LqpHyZnR',
                name:
                    '13. Do you or anyone have a long-term illness that you would like to share with me',
                translatedName:
                    '13. Na oena kapa emong oa ba lelapa o na le bokulo ba nako e telele bo u ka lakatsang ho mpolella bona?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'TeVmOZEH9ww',
                name: 'If Yes, Who?',
                translatedName: 'Ha bo le teng, Ke mang',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'ut8LqpHyZnR_checkbox',
                name: 'What is the long-term illness that you have?',
                translatedName:
                    'Ke bokuli bo fe ba nako e telele boo u nang le bona?',
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
                      name: 'Mental',
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
                      code: 'KexFaUmJpt5', name: 'N/A', translatedName: 'N/A'),
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
                id: 'AccHyrWqhI0',
                name: '14. Are you receiving treatment for this illness?',
                translatedName: '14. Na u fumana kalafo ea lefu leo?',
                description: 'If no, Refer to appropriate health service',
                translatedDescription: 'Fetisetsa litsebeletsong tsa bophel',
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
                  InputFieldOption(
                      code: 'Other', name: 'Other', translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'BvNaiaoxc6w',
                name: '15. Have you been tested for HIV?',
                translatedName: '15. U kile oa hlahlobela HIV?',
                description: 'If no refer for testing',
                translatedDescription:
                    'Ha asa hlahloba  fetesitsa setsing sa tlhabollo',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                isReadOnly: true),
            InputField(
                id: 'Uv26fX0HQvO',
                name: 'If Yes when?',
                translatedName: 'Haeba Karabo le “E”, neng',
                description:
                    'If over six months (or their window period) refer for testing ',
                translatedDescription:
                    'Ha sephetho se feta khoeli tse 6 fetesitsa setsing sa tlhabollo',
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
                    translatedName: '4-6 likhoeli tse fetileng',
                  ),
                  InputFieldOption(
                      code: 'Above 12 months ago',
                      name: 'Above 12 months ago',
                      translatedName:
                          'Ka holimo ho likhoeli tse 12 tse fetileng'),
                ],
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'T4grVrCVDkk',
                name:
                    '16. Would you be willing to share your HIV test result with me?',
                translatedName:
                    '16. Na u ka ba le bolokolohile ba ho mpolella sephetho sa tlhahlobo eo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                isReadOnly: true),
            InputField(
                id: 'vNeOE9abQBB',
                name: 'What is your HIV Status?',
                translatedName: 'Boemo ba hau ba HIV ke bofe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
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
                      translatedName: 'Tse sa tsejoeng'),
                  InputFieldOption(
                      code: 'No Response',
                      name: 'No Response',
                      translatedName: 'Ha ho Karabo')
                ]),
            InputField(
              id: 'blod3xZ2dPP',
              name: '17. Are you currently taking ART to treat HIV?',
              translatedName: '17. Na u tlasa kalafo ea lefu la HIV ha joale?',
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
            ),
            InputField(
                id: 'ubin7MjQ5OI',
                name: '18. If Yes, How long have you been on ART?',
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
                  InputFieldOption(
                      code: 'more than one year', name: 'more than one year'),
                  InputFieldOption(code: 'NA', name: 'NA')
                ]),
            InputField(
                id: 'Icb6vUJXVDX',
                name: '19. Do you take your treatments daily and on time?',
                translatedName:
                    '19. Na u noa litlhare tsa hau hantle (ka mehla ka nako)?',
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
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'sLyfb45aLkl',
                name: '20. Have you ever had a blood test called viral load?',
                translatedName:
                    '20. U kile oa etsa hlahlobo ea mali bakeng sa boemo ba t’soaetso bo maling (viral load)?',
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
                name: '21. What was the result of your viral load test?',
                translatedName:
                    '21. Sephetho sa tlhahlobo eo ea mali se ne se reng?',
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
                id: 'KgLtXquRot3',
                name: '22. What is the name of the health facility you visit?',
                translatedName: '22. U nka litlare setsing sefe sa bophelo?',
                valueType: 'ORGANISATION_UNIT',
                showCountryLevelTree: true,
                allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'why_choose_this_facility',
                name: '23. Why did you choose this health facility?',
                translatedName: '23. Hobaneng u khethile setsi seo?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'WKT65kLT9AT',
                      name: 'It’s the only place I can get treatment',
                      translatedName:
                          'Ke sona fela baka se nka fumanang litlhare ho sona.'),
                  InputFieldOption(
                      code: 'QgWzwLkRjul',
                      name: ' It’s easy to access',
                      translatedName: 'Se fihleleha ha bobebe'),
                  InputFieldOption(
                      code: 'I4M6NLNMbG3',
                      name: 'I’m afraid my family will learn my status',
                      translatedName:
                          'Ke t’saba hore lelapa le tla tseba ka boemo baka.'),
                  InputFieldOption(
                      code: 'FqLADURlSw6',
                      name:
                          'I’m afraid that my neighbors will discover my status',
                      translatedName:
                          'Ke t’saba hore baahisane batla tseba ka boemo baka.'),
                  InputFieldOption(
                      code: 'NlWEhu1onQW',
                      name:
                          'The doctor at the health facility closest to me doesn’t treat me well',
                      translatedName:
                          'Ngaka e setsing se haufinyane ha e nt’sbeletse hantle.'),
                  InputFieldOption(
                      code: 'aUZ2HTFvI4A',
                      name: 'The facility I go to is a good health center',
                      translatedName:
                          'Setsi sa bophelo se ke eang ho sona se nt’sebeletsa hantle.'),
                  InputFieldOption(
                      code: 'WUwcEkmhaan', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'beztnfLGhxi',
                name: 'Other reasons for choosing this facility',
                translatedName: 'Tse ling hlalosa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'BYZu8p33lzP',
                name: '24. Have you disclosed your status to anyone?',
                translatedName:
                    '24. Na ho na le motho eo u kileng oa mojoetsa boemo ba hau ba HIV?',
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
                name: '25. To whom have you disclosed your status?',
                translatedName:
                    '25. Ke mang eo u mo joetsitseng ka boemo a hao a HIV?',
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
                id: 'I3hI2UTkKyx',
                name: 'Other, Specify (disclosed HIV status to)',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'jzmOXiyGGgw',
                name:
                    '26. Do you feel like people treat you differently because you are HIV positive?',
                translatedName:
                    '26. Na o nahana hore batho ba o khetholla hobane unale le tso’oaetso ea HIV?',
                description:
                    'Refer to Village Health Workers or Social Workers or psychosocial support.',
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
                  InputFieldOption(
                      code: 'NA', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'How-have-you-coped-with-HIV-related-stigma',
                name: '27. How have you coped with HIV-related stigma?',
                translatedName:
                    '27. O atleha ho phela joang tlaasa maemo a ho nenoa kapa ho khetholla ka baka la boemo ba hau ba HIV?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'QPcCByPcMpz',
                      name: 'I am part of a support group',
                      translatedName: 'Ke karolo ea support group '),
                  InputFieldOption(
                      code: 'klE3cj35whZ',
                      name:
                          'I speak with people who I am close with or my family',
                      translatedName:
                          'Ke bua le batho ba haufi le nna kapa lelapa laka '),
                  InputFieldOption(
                      code: 'FitzDd4bmS6',
                      name: 'I speak with my doctor',
                      translatedName: 'Ke bua le ngaka eaka'),
                  InputFieldOption(
                      code: 'PXZm9X9pG01',
                      name: 'I speak with my pastor or priest',
                      translatedName: 'Ke bua le moruti oaka'),
                  InputFieldOption(
                      code: 'XPplaRA9hzd',
                      name: 'I face it all',
                      translatedName: 'Ke tobane le bothata bona ke le mong '),
                  InputFieldOption(
                      code: 'zNYrqDOIhGO',
                      name:
                          'I avoid thinking about it because it’s too difficult',
                      translatedName:
                          'Ke qoba ho nahana ka eona hobane e nkimetse.'),
                  InputFieldOption(
                      code: 'LGhJJz12mWP',
                      name: 'I do not face stigma',
                      translatedName: 'Ha ke so tobane le sekhobo'),
                  InputFieldOption(
                      code: 'loGTnsw9R9G',
                      name: 'Other',
                      translatedName: 'Tse ling'),
                  InputFieldOption(
                      code: 'YT79ydtEOZj', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'dfdeOt1y7me',
                name: 'Please specify',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'JYPmeC1Zbwf',
                name:
                    '28. If you have a child or children 10 or over, have you talked to them about how to protect themselves from HIV?',
                translatedName:
                    '28. Haeba u na le ngoana kapa bana ba ka holimo ho lilemo li 10, u kile oa bua le bona ka ho itsireletsa khahlanong le tsoaetso ea HIV?',
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
          ]),
      FormSection(
          name: 'Other Household details',
          color: const Color(0xFF5B94F0),
          description:
              'Case Management Workers reads: “Assets can also be social. This is because people need connections, support, and relationships in order to be well.”',
          borderColor: const Color(0xFF5B94F0),
          inputFields: [
            InputField(
                id: 'Eg1fUXWnFU4',
                name: 'How many people in total make up your household?',
                translatedName: 'U phela le batho ba bakae lapeng lee?',
                valueType: 'INTEGER_ZERO_OR_POSITIVE',
                inputColor: const Color(0xFF5B94F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'X094f7yANdc',
                name:
                    'Are there any adults who live in this household other than you',
                translatedName:
                    'Ho na le batho ba baholo ba phelang ka hara lelapa lee ntle le oena?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF5B94F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'J8gzZEMnQLX',
                name:
                    'If yes, how many male adult (other than you) live in your household?',
                translatedName:
                    'Ha ba le teng ke banna  ba bakae ba phelang ka hara lelapa lee (ntle le oena)?',
                valueType: 'INTEGER_ZERO_OR_POSITIVE',
                inputColor: const Color(0xFF5B94F0),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'uznwDGvHcie',
                name:
                    'If yes, how many female adult (other than you) live in your household?',
                translatedName:
                    'Ha ba le teng ke  basali ba bakae ba phelang ka hara lelapa lee (ntle le oena)?',
                valueType: 'INTEGER_ZERO_OR_POSITIVE',
                inputColor: const Color(0xFF5B94F0),
                labelColor: const Color(0xFF1A3518)),
          ]),
      FormSection(
          name: 'DOMAIN SAFE',
          translatedName: 'TSIRELETSO',
          color: const Color(0xFF549388),
          description:
              'Case Management Workers reads: “Assets can also be social. This is because people need connections, support, and relationships in order to be well.”',
          translatedDescription:
              'Mosebeletsi oa morero oa bala: “Thepa le eona e ka amahangoa le botho. Ke hobane batho ba hloka likamano, t’sehetso le likamano hore ba phele hantle.”',
          borderColor: const Color(0xFF549388),
          inputFields: [
            InputField(
                id: 'pLbNeD3Ibqo',
                name:
                    '29. Is there someone or a group of people in your community that you trust and feel that you can talk to about any problems that you may face?',
                translatedName:
                    '29. Na ho na le motho kapa batho sechabeng se u phelang le sona bao u ba t’sepang ebile u utloang hore u ka bua le bona ka mathata ao u nang le ona?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF549388),
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
                id: 'RfFxx08F8V0',
                name:
                    '30. If you had to leave your house for a few hours, is there someone that you could ask to watch your children?',
                translatedName:
                    '30. Haeba u tlameha ho siea ntlo ea hau lihora tse fokolang, na ho na le motho eo u ka kopang hore a u salle le bana?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF549388),
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
                id: 'JmLdZM3XYfY',
                name:
                    '31. In the last six months have you received information on parenting/ child care and development through training, counseling, mentoring, or home visits?',
                translatedName:
                    '31. Khoeling tse tseletseng tse fetileng u kile oa fumana thuto/tlhahiso-leseling ka sehlopha sa likamano tsa bana le baholisi (rethabile), tlhokomelo le kholo ea ngoana ka thupelo, tlhabollo kapa ka ho eteloa lapeng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF549388),
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
                id: 'JmLdZM3XYfY_checkbox',
                name:
                    '32. How did you receive information about parenting and child care?',
                translatedName:
                    '32. U fumane tlhahiso leseling ea rethabile le tlhokomelo ea ngoana joang?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF549388),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'imTAGRReVhB',
                      name: 'Radio',
                      translatedName: 'Sealemoea'),
                  InputFieldOption(
                      code: 'kbDUIii7RI9',
                      name: 'Counselling',
                      translatedName: 'Tlhabollo'),
                  InputFieldOption(
                      code: 'LsqmrPHSyPb',
                      name: 'Mentoring from Case Management Workers',
                      translatedName: 'Tataiso ho tsoa Mosebeletsi oa morero'),
                  InputFieldOption(
                      code: 'qWU0DW6nlz4',
                      name: 'Care group',
                      translatedName: 'Sehlopha sa tlhabollo'),
                  InputFieldOption(
                      code: 'ImXVDwLnvlO',
                      name: 'Training',
                      translatedName: 'Koetliso'),
                  InputFieldOption(
                      code: 'SLmCmjszo6f',
                      name: 'Community Meeting',
                      translatedName: 'kopanong ea sechaba'),
                  InputFieldOption(
                      code: 'BERmsstjZyQ',
                      name: 'Health care facility/ Under five clinic',
                      translatedName:
                          'Setsi sa bophelo/tliliniki ea bana ba ka tlase ho lilemo li 5'),
                  InputFieldOption(
                      code: 'J1rNgYhLoCS',
                      name: 'Schools',
                      translatedName: 'Sekolong'),
                  InputFieldOption(
                      code: 'ajrDVp6cI2k',
                      name: 'Other',
                      translatedName: 'Tse ling')
                ]),
            InputField(
                id: 'hiRnasaeK9H',
                name: 'Other:',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF549388),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'SLajij5j1KI',
                name:
                    '33. Has anyone in the household experienced any form of violence and abuse in the last 6 months?',
                translatedName:
                    '33. Na ka lapeng lee ho na le motho a kileng a hlekefetsoa kapa a loant’soa khoeling tse tseletseng tse fetileng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF549388),
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
                id: 'RxvDeJX3b3k',
                name: 'Did you report this violence?',
                translatedDescription:
                    'Na u ile oa tlaleha tlhekefetso kapa ho loantsoa hoo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF549388),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'E4UFvIBBEDk',
                name: '34. What kind of support did you receive (if any)?',
                translatedName: '34. U ile oa fumana t’sehetso ea mofuta ofe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF549388),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Legal Assistance',
                      name: 'Legal Assistance',
                      translatedName: 'Ts’ehetso ea tsa Molao'),
                  InputFieldOption(
                      code: 'Psychosocial Support',
                      name: 'Psychosocial Support',
                      translatedName: 'Tsehetso ea maikutlo '),
                  InputFieldOption(
                      code: 'Medical services',
                      name: 'Medical services',
                      translatedName: 'Litsebeletso tsa bongaka '),
                  InputFieldOption(
                      code: 'Others',
                      name: 'Others',
                      translatedName: 'Tse ling'),
                  InputFieldOption(
                      code: 'NA', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'RWcOcPqBnFj',
                name: 'Other, Specify (kind of support received)',
                translatedName: 'Tse ling, Hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF549388),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'zWpm4lCpRxb',
                name: 'Whom did you receive support from?',
                translatedName: 'Ho tsoa ho mang?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF549388),
                labelColor: const Color(0xFF1A3518)),
          ]),
    ];
  }
}
