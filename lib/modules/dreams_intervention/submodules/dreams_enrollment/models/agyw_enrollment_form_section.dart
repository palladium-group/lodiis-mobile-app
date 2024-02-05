import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class AgywEnrollmentFormSection {
  static List<String> getMandatoryField() {
    return [
      'location',
      'H2Az2c3MeAy',
      'ZcfLYz7JlVo',
      'NP7LbypO3li',
      'bBVCUqsdfL3',
      'CU4HyDp6XO0',
      'WwTI82dbYIc',
      'RO2RIidPOqK',
      'mvPAYFoFQcW',
      'GdsRvY5lHCU',
      'NOJbkKuHccD',
      'iLX2uQ4ZXM0',
      'Zmt7PefVzk4',
      'OZqIvrzGBFK',
      'KNqzbD65UrN',
      'gY0nOLnR3eh',
      'NgIDtgfZMVH',
      'ClDEtAAqDPI',
      'i32OwNqUYRn',
      'i32OwNqUYRn',
      'ClDEtAAqDPI',
      'NgIDtgfZMVH',
      'gY0nOLnR3eh',
      'KNqzbD65UrN',
      'OZqIvrzGBFK',
      'Zmt7PefVzk4',
      'iLX2uQ4ZXM0',
      'NOJbkKuHccD',
      'GdsRvY5lHCU',
      'RO2RIidPOqK',
      'WwTI82dbYIc',
      'CU4HyDp6XO0',
      'bBVCUqsdfL3',
      'NP7LbypO3li',
      'ZcfLYz7JlVo',
      'H2Az2c3MeAy',
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        name: 'Enrollment Instructions',
        translatedName: 'Litaelo tsa ho Ngolisa',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
              id: 'cifBFSTHgv5',
              name: 'Is the AGYW aged 9-24 years old',
              translatedName:
                  'Na moroetsana/mosali ea mocha lilemong o lipakeng tsa lilemo tse 9 le 24?',
              valueType: 'BOOLEAN',
              isReadOnly: true,
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'oEbOkfQY3NP',
            name: 'What was used for verification',
            translatedName:
                'Ha karabo e le “E”, ho sebelisitsoe eng ho e netefatsa?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Birth Certificate',
                  name: 'Birth Certificate',
                  translatedName: 'Lengolo la tlhaho'),
              InputFieldOption(
                  code: 'National ID',
                  name: 'National ID',
                  translatedName: 'Lengolo la boitsebiso (ID)'),
              InputFieldOption(
                  code: 'National ID waiting for the card',
                  name: 'National ID waiting for the card',
                  translatedName: 'Lengolo la hore o emetse ID'),
              InputFieldOption(
                  code: 'Other', name: 'Other', translatedName: 'E meng')
            ],
          ),
          InputField(
              id: 'ODMyZc2F7uc',
              name: 'Other age verification document used',
              translatedName: 'E meng (hlalosa)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'uSxDP43mFEG',
              name: 'Which community council and district?',
              translatedName:
                  'Ha karabo e le “E”, ke k’hanseleng/seterekeng sefe?',
              valueType: 'ORGANISATION_UNIT',
              allowedSelectedLevels: [AppHierarchyReference.communityLevel],
              showCountryLevelTree: true,
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
        name: 'Enrollment Module 1:  Individual and Household Information',
        translatedName: 'KAROLO EA 1: Lintlha tsa motho ka mong le lelapa labo',
        description:
            'INTERVIEWER SAY:  This section of the enrolment form asks for details about your household in general.  After this we will move on to other topics.',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE: Karolo ena, e botsa ka lelapa leno. Kamora mona re tla fetela lintlheng tse ling.',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'O7FZEfXR1Ge',
            name: '101. Who is the head of your household?',
            translatedName: '101. Hloho ea lelapa leno/la hao ke mang?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Self', name: 'Self', translatedName: 'Ke ’na'),
              InputFieldOption(
                  code: 'Father', name: 'Father', translatedName: 'Ke Ntate'),
              InputFieldOption(
                  code: 'Mother', name: 'Mother', translatedName: 'Ke ’M’e'),
              InputFieldOption(
                  code: 'Sibling',
                  name: 'Sibling',
                  translatedName: 'Ke ngoaneso'),
              InputFieldOption(
                  code: 'Uncle or Aunt',
                  name: 'Uncle or Aunt',
                  translatedName: 'Ke Malome/Rangoane/Rakhali/’Mangoane'),
              InputFieldOption(
                  code: 'Grand Parent',
                  name: 'Grand Parent',
                  translatedName: 'Ke Nkhono/Ntate-moholo'),
              InputFieldOption(
                  code: 'Husband/Partner',
                  name: 'Husband/Partner',
                  translatedName: 'Ke Monna/Mohlankana oa ka'),
              InputFieldOption(
                  code: 'Other', name: 'Other', translatedName: 'E mong')
            ],
          ),
          InputField(
              id: 'FehkgSKYkaQ',
              name: '102. How old is the head of the household?',
              translatedName: '102. Hloho ea lelapa o lilemo li kae?',
              valueType: 'NUMBER',
              regExpValidation: RegExp('^([1-9]|[1-9][0-9]|100)\$'),
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'cJl00w5DjIL',
            name: '103. Is your father alive?',
            translatedName: '103. Na ntate oa hao o ntse a phela?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
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
            id: 'R9e8v9r3lMM',
            name: '104. Is your mother alive?',
            translatedName: '104. Na ’m’e oa hao o ntse a phela?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
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
            id: 'eWbL7tHhp2f',
            name:
                '105. Are any of your parents/guardians chronically ill (including HIV)?',
            translatedName:
                '105. Na batsoali/bahlokomeli ba hao ke batho ba kulang (ho kenyeletsa le tšoaetso ea HIV)?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
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
            id: 'JmiNCIwfZvh',
            name: '106. What is the main material on the floor of your house?',
            translatedName: '106. Ka lapeng ka heno, ho aliloe eng fatše?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Earth or Mud or Dung or Sand',
                  name: 'Earth or Mud or Dung or Sand',
                  translatedName: 'Mobu'),
              InputFieldOption(
                  code: 'Ceramic tiles',
                  name: 'Ceramic tiles',
                  translatedName: 'Lithaele'),
              InputFieldOption(
                  code: 'Cement', name: 'Cement', translatedName: 'Samente'),
              InputFieldOption(
                  code: 'Other', name: 'Other', translatedName: 'Tse ling')
            ],
          ),
          InputField(
              id: 'HuGpuXtz673',
              name: 'Specify other type of floor material',
              translatedName: 'Tse ling (hlalosa)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'VWtI5ROqFzd',
            name: '107. What is the main material on the roof of your house?',
            translatedName: '107. Ntlo eno e ruletsoe ka eng?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Grass', name: 'Grass', translatedName: 'Joang'),
              InputFieldOption(
                  code: 'Corrugated iron sheet',
                  name: 'Corrugated iron sheet',
                  translatedName: 'Masenke'),
              InputFieldOption(
                  code: 'Asbestos sheets',
                  name: 'Asbestos sheets',
                  translatedName: 'Lithaele'),
              InputFieldOption(
                  code: 'Concrete',
                  name: 'Concrete',
                  translatedName: 'Samente'),
              InputFieldOption(
                  code: 'Other', name: 'Other', translatedName: 'Tse ling')
            ],
          ),
          InputField(
              id: 'Qiuxkrvq5mH',
              name: 'Specify other type of roof material',
              translatedName: 'Tse ling (hlalosa)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'xNx00hrCdWj',
            name: '108. What is the main material on the walls of your house?',
            translatedName: '108. Mabota a ntlo eno a entsoe ka eng?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'No Walls',
                  name: 'No Walls',
                  translatedName: 'Ha ho mabota'),
              InputFieldOption(
                  code: 'Dung or Mud',
                  name: 'Dung or Mud',
                  translatedName: 'Mobu'),
              InputFieldOption(
                  code: 'Stone with mud',
                  name: 'Stone with mud',
                  translatedName: 'Mobu le majoe'),
              InputFieldOption(
                  code: 'Plywood or Cardboard',
                  name: 'Plywood or Cardboard',
                  translatedName: 'Lik’hateboto'),
              InputFieldOption(
                  code: 'Carton',
                  name: 'Carton',
                  translatedName: 'Lipolasitiki'),
              InputFieldOption(
                  code: 'Wood', name: 'Wood', translatedName: 'Mapolanka'),
              InputFieldOption(
                  code: 'Stone or Brick or Cement',
                  name: 'Stone or Brick or Cement',
                  translatedName: 'Majoe/Setene/Samente'),
              InputFieldOption(
                  code: 'Other', name: 'Other', translatedName: 'Tse ling')
            ],
          ),
          InputField(
              id: 'B1lYiAi3AQE',
              name: 'Specify other walls materials of your house',
              translatedName: 'Tse ling (hlalosa)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'ghkM8TrpEHr',
            name:
                '109. What is the main source of drinking water for members of your household?',
            translatedName: '109. Le sebelisa metsi a tsoang kae?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Piped water',
                  name: 'Piped water',
                  translatedName: 'Lipompong tsa metsi'),
              InputFieldOption(
                  code: 'Open well',
                  name: 'Open well',
                  translatedName: 'Selibeng se chekiloeng fatše'),
              InputFieldOption(
                  code: 'Covered well or borehole',
                  name: 'Covered well or borehole',
                  translatedName: 'Selibeng se koahetsoeng'),
              InputFieldOption(
                  code: 'Surface water (river, spring, lake)',
                  name: 'Surface water (river, spring, lake)',
                  translatedName:
                      'Metsi a mathang (a noka/seliba se kollang/ letša, letamo'),
              InputFieldOption(
                  code: 'Rain water',
                  name: 'Rain water',
                  translatedName: 'Metsi a phallang a pula'),
              InputFieldOption(
                  code: 'Other', name: 'Other', translatedName: 'Tse ling')
            ],
          ),
          InputField(
              id: 'BwlYnY5isNK',
              name: 'Specify other source of drinking water',
              translatedName: 'Tse ling (hlalosa)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'iIdrEpTkpsk',
              name:
                  '110. In the past 4 weeks, was there any day that you went without food in your household for a full day because of lack of resources?',
              translatedName:
                  '110. Libekeng tse 4 tse fetileng, na u kile oa robala ka tlala hobane ho se na mokhoa oa ho reka lijo?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'ovd3lF6epue',
            name: '111. For how many days did this happen in the last 4 weeks?',
            translatedName:
                '111. See se etsahetse makhetlo a makae libekeng tse 4 tse fetileng?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Rarely',
                  name: 'Rarely (1-2 days)',
                  translatedName: 'Ha se hangata (letsatsi kapa a 2)'),
              InputFieldOption(
                  code: 'Sometimes',
                  name: 'Sometimes (3-10 days)',
                  translatedName:
                      'Ka linako tse ling (matsatsi a 3 hoisa ho a 10)'),
              InputFieldOption(
                  code: 'Often',
                  name: 'Often (more than 10 days)',
                  translatedName: 'Hangata (ho feta matsatsi a 10)')
            ],
          ),
          InputField(
              id: 'GGZMeIWhXU9',
              name: '112. Do you have any form of disability?',
              translatedName: '112. Na u phela le bokooa?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'gyQS55npBZ8',
            name: '113. State disability type',
            translatedName: '113. Hlalosa mofuta oa bokooa ba hao',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Hearing impairment',
                  name: 'Hearing impairment',
                  translatedName: 'Bokooa ba kutlo litsebeng'),
              InputFieldOption(
                  code: 'Speech impairment',
                  name: 'Speech impairment',
                  translatedName: 'Bokooa ba puo'),
              InputFieldOption(
                  code: 'Visual impairment',
                  name: 'Visual impairment',
                  translatedName: 'Bokooa ba pono'),
              InputFieldOption(
                  code: 'Mental impairment',
                  name: 'Mental impairment',
                  translatedName: 'Bokooa ba kelello'),
              InputFieldOption(
                  code: 'Physical impairment',
                  name: 'Physical impairment',
                  translatedName: 'Bokooa ba masapo'),
              InputFieldOption(
                  code: 'Other',
                  name: 'Other',
                  translatedName: 'Bokooa bo bong')
            ],
          ),
          InputField(
              id: 'A3pHHLPwpyq',
              name: 'Specify other type of disabilities',
              translatedName: 'Bokooa bo bong (hlalosa)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'BXUNH6LXeGA',
              name:
                  '114a. Female children below 18 years of age currently living in household',
              translatedName:
                  '114a. Palo ea banana ba lilelemo li ka tlase ho 18 ba phelang ka hara lelapa',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              regExpValidation: RegExp('^([0-1]{0,1}[1-9]|20)\$'),
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'kQehaqmaygZ',
              name:
                  '114b. Male children below 18 years of age currently living in household',
              translatedName:
                  '114b. Palo ea bashanyana ba lilelemo li ka tlase ho 18 ba phelang ka hara lelapa',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              regExpValidation: RegExp('^([0-1]{0,1}[1-9]|20)\$'),
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'rGAQnszNGVN',
              name:
                  '114c. Female aged 18 years and above currently living in household',
              translatedName:
                  '114c. Palo ea basali ba lilelemo li ka holimo ho 18 ba phelang ka hara lelapa',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              regExpValidation: RegExp('^([0-1]{0,1}[1-9]|20)\$'),
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'l9tcZ2TNgx6',
              name:
                  '114d. Male aged 18 years and above currently living in household',
              translatedName:
                  '114d. Palo ea banna ba lilelemo li ka holimo ho 18 ba phelang ka hara lelapa',
              valueType: 'INTEGER_ZERO_OR_POSITIVE',
              regExpValidation: RegExp('^([0-1]{0,1}[1-9]|20)\$'),
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'eraVEI3PUF1',
            name: '115. Have you ever been enrolled in a cash transfer program',
            translatedName:
                '115. Na u kile oa kena lenaneng la batho ba thusoang/phalleloang ka lichelete?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
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
            id: 'GG0gYqd3Rdt',
            name:
                '116. Are you currently enrolled in any cash transfer programs?',
            translatedName:
                '116. Na nakong ea joale u lenaneng la batho ba thusoang/phalleloang ka lichelete?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
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
              id: 'w780PZTlVhS',
              name:
                  '117. Which cash transfer programs are you currently enrolled in?',
              translatedName:
                  '117. Nakong ea joale u lenaneng lefe la batho ba thusoang/phalleloang ka lichelete?',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
        name: 'Enrollment Module 2:  Education & Employment',
        translatedName: 'KAROLO EA 2: Thuto le Mosebetsi',
        description:
            'INTERVIEWER SAY:  This section of the enrolment asks about education and employment information of the AGYW.',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE: Karolo ena e botsa ka thuto le khiro tsa moroetsana/mosali ea mocha lilemong.',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
              id: 'JTNxMQPT134',
              name: '201. Do you currently go to school?',
              isReadOnly: true,
              translatedName: '201. Na nakong ea joale u kena sekolo?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'iQdwzVfZdml',
            name: 'Type of school',
            translatedName: 'Mofutoa oa Sekolo',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Formal',
                  name: 'Formal',
                  translatedName: 'Se ngolisitsoeng'),
              InputFieldOption(
                  code: 'Informal',
                  name: 'Informal',
                  translatedName: 'Se sa ngolisoang')
            ],
          ),
          InputField(
              id: 'J6OTM0c1WCV',
              name: '202. What is the name of the school?',
              translatedName: '202. Lebitso la sekolo seo ke mang?',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'aPNGd6RCsY9',
            name: '203. What level of school are you currently in?',
            translatedName: '203. Nakong ea joale, u boemong bofe ba sekolo?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Primary level',
                  name: 'Primary level',
                  translatedName: 'Sekolo sa mathomo'),
              InputFieldOption(
                  code: 'Secondary level',
                  name: 'Secondary level',
                  translatedName: 'Sekolo se mahareng'),
              InputFieldOption(
                  code: 'Tertiary level',
                  name: 'Tertiary level',
                  translatedName: 'Sekolo se phahameng (college/university) '),
              InputFieldOption(
                  code: 'Vocational level',
                  name: 'Vocational level',
                  translatedName: 'Sekolo sa mosebetsi oa matsoho'),
              InputFieldOption(
                  code: 'Other',
                  name: 'Other',
                  translatedName: 'Sekolo se seng')
            ],
          ),
          InputField(
              id: 'T56nYogWRYq',
              name: 'Specify other school level',
              translatedName: 'Sekolo se seng (hlalosa)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'h1HeZ2eEkGn',
              name: 'Which class are you currently enrolled in?',
              translatedName: 'Sehlopha',
              valueType: 'NUMBER',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'NGVFqUVSHiU',
              name: 'Which form are you currently enrolled in?',
              translatedName: 'Sehlopha',
              valueType: 'NUMBER',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'JTNxMQPT134_checkboxes_2',
            name:
                '204. Other than from your parent(s)/guardian(s), are you also getting support towards your current education from another source? (Tick all that apply)',
            translatedName:
                '204. Ntle le batsoali/bahlokomeli ba hao, na ho na le lithuso tseo u li fumanang mehloling e meng bakeng sa thuto? (Tšoaea tsohle tseo a li boletseng)',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'omcO1NZi372',
                  name: 'Government bursary',
                  translatedName: 'Litlhapiso tsa ’Muso'),
              InputFieldOption(
                  code: 'H1eanHofoq8',
                  name: 'NGO',
                  translatedName: 'Mekhatlo e ikemetseng'),
              InputFieldOption(
                  code: 'AbgTDPl08pL',
                  name: 'Faith-based institutions (Church, Mosque etc.)',
                  translatedName: 'Mekhatlo ea likereke'),
              InputFieldOption(
                  code: 'xmdJPtEgGOf',
                  name: 'Relatives (excludes parent/guardian)',
                  translatedName:
                      'Batho bao u amanang le bona (ntle le motsoali/mohlokomeli)'),
              InputFieldOption(
                  code: 'cr4RA9GGMyf',
                  name: 'Other sources',
                  translatedName: 'Lithuso tse ling')
            ],
          ),
          InputField(
            id: 'vpmRiwVyKn2',
            name:
                '205. What is the main reason why you are not going to school?',
            translatedName:
                '205. Lebaka la mantlha le etsang hore u se kene sekolo ke lefe?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Completed secondary School',
                  name: 'Completed secondary School',
                  translatedName: 'Ke qetile sekolo se mahareng'),
              InputFieldOption(
                  code: 'Lack of school fees',
                  name: 'Lack of school fees',
                  translatedName: 'Ke haelloa ke school fees'),
              InputFieldOption(
                  code: 'Pregnancy',
                  name: 'Pregnancy',
                  translatedName: 'Boimana'),
              InputFieldOption(
                  code: 'Peer pressure',
                  name: 'Peer pressure',
                  translatedName: 'Ke tšusumetso ea lithaka tsa ka'),
              InputFieldOption(
                  code: 'Not interested',
                  name: 'Not interested',
                  translatedName: 'Ha ke Thahaselle'),
              InputFieldOption(
                  code: 'Awaiting to join secondary',
                  name: 'Awaiting to join secondary',
                  translatedName: 'Ke emetse ho ea sekolong se mahareng'),
              InputFieldOption(
                  code: 'Got married',
                  name: 'Got married',
                  translatedName: 'Ke ile ka nyaloa'),
              InputFieldOption(
                  code: 'Other', name: 'Other', translatedName: 'Mabaka a mang')
            ],
          ),
          InputField(
              id: 'JDFx7WfZ0Qi',
              name: 'Specify other reasons not going to school',
              translatedName: 'Mabaka a mang (a hlalose)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'nhI53DrKB7u',
            name: '206. When was the last time you went to school?',
            translatedName: '206. U qetetse ho kena sekolo neng?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Less than 6 Months ago',
                  name: 'Less than 6 Months ago',
                  translatedName: 'Likhoeli tse katlase ho 6'),
              InputFieldOption(
                  code: '6 to 12 months ago',
                  name: '6 to 12 months ago',
                  translatedName: 'Likhoeli tse 6 hoisa ho tse 12'),
              InputFieldOption(
                  code: '1 to 2 years ago',
                  name: '1 to 2 years ago',
                  translatedName: 'Selemo hoisa ho tse 2'),
              InputFieldOption(
                  code: 'More than 2 years ago',
                  name: 'More than 2 years ago',
                  translatedName: 'Ho feta lilemo tse 2'),
              InputFieldOption(
                  code: 'Never attended to school',
                  name: 'Never attended to school',
                  translatedName: 'Ha ke e-so kene sekolo')
            ],
          ),
          InputField(
              id: 'BoQ3kawURfW',
              name: '207. In what class/ form did you stop schooling?',
              translatedName:
                  '207. U khaolitse ho kena sekolo ha u le sehlopheng sefe?',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'JTNxMQPT134_checkboxes',
            name:
                '208. Given a chance, what would you wish to do with your life?',
            translatedName:
                '208. Ha u ka fuoa monyetla, u ka lakatsa ho etsa eng ka bophelo ba hao?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'aJuhtxvbLUn',
                  name: 'Pursue a course',
                  translatedName: 'Ho kena sekolo'),
              InputFieldOption(
                  code: 'CXwRMbOl4s8',
                  name: 'Start a business',
                  translatedName: 'Ho qala khoebo'),
              InputFieldOption(
                  code: 'b1kQ78GvzNv',
                  name: 'Go back to school',
                  translatedName: 'Ho khutlela sekolong'),
              InputFieldOption(
                  code: 'WmneCKqL6hV',
                  name: 'Get married',
                  translatedName: 'Ho nyaloa')
            ],
          ),
          InputField(
              id: 'T0PGSSQXFtV',
              name: 'Other things you would do?',
              translatedName: 'Tse ling (hlalosa)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'IH4Ly0VPRtL',
            name: '209. What is your current main source of income?',
            translatedName: '209. U fumana chelete ea hao mehloling efe?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Formally employed',
                  name: 'Formally employed',
                  translatedName: 'Ke hiriloe'),
              InputFieldOption(
                  code: 'Business person',
                  name: 'Business person',
                  translatedName: 'Ke na le khoebo'),
              InputFieldOption(
                  code: 'Casual labour',
                  name: 'Casual labour',
                  translatedName: 'Ke etsa mesebetsi ea li-piece-job'),
              InputFieldOption(
                  code: 'Petty trade (hawker etc.)',
                  name: 'Petty trade (hawker etc.)',
                  translatedName: 'Ke moitšokoli'),
              InputFieldOption(code: 'Farmer', name: 'Farmer'),
              InputFieldOption(
                  code: 'None (I have no source of income)',
                  name: 'None (I have no source of income)',
                  translatedName: 'Ke sehoai'),
              InputFieldOption(
                  code: 'Other', name: 'Other', translatedName: 'E meng')
            ],
          ),
          InputField(
              id: 'KFgOeRoncRb',
              name: 'Other source of income',
              translatedName: 'E meng (hlalosa)',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'TK4WYUEG5UK',
              name: '210. Do you have any savings?',
              translatedName: '210. Na u na le chelete e polokelong?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'RiSceJCKIzH',
            name: '211. Where do you keep your savings?',
            translatedName: '211. U boloka chelete ea hao kae?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'At home', name: 'At home', translatedName: 'Lapeng'),
              InputFieldOption(
                  code: 'Saving groups or Stokfel',
                  name: 'Saving groups or Stokfel',
                  translatedName: 'Mekhatlong/Stokfel'),
              InputFieldOption(
                  code: 'In the bank',
                  name: 'In the bank',
                  translatedName: 'Bankeng'),
              InputFieldOption(
                  code: 'Mobile Money',
                  name: 'Mobile Money',
                  translatedName: 'EcoCash/Mpesa'),
              InputFieldOption(
                  code: 'Other',
                  name: 'Other',
                  translatedName: 'Libakeng tse ling')
            ],
          ),
          InputField(
              id: 'Gzuxkl4zjrI',
              name: 'Specify where you keep your savings',
              translatedName: 'Libakeng tse ling (hlalosa)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
        name: 'Enrollment Module 3: HIV Testing',
        translatedName: 'KAROLO EA 3: Tlhahlobo ea HIV',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
              id: 'agg0eUd8Wwo',
              name: '301. Have you ever been tested for HIV?',
              translatedName: '301. Na u kile oa hlahloba HIV?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'jT72rsATBtu',
            name: '302. When/how long ago was your last HIV test?',
            translatedName: '302. Ke neng ha u qetela ho hlahloba HIVt?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Less than 3 months ago',
                  name: 'Less than 3 months ago',
                  translatedName: 'Katlase ho likhoeli tse 3'),
              InputFieldOption(
                  code: '3 to 5 months ago',
                  name: '3 to 5 months ago',
                  translatedName: 'Lipakeng tsa likhoeli tse 3 hoisa ho tse 5'),
              InputFieldOption(
                  code: '6 to 12 months ago',
                  name: '6 to 12 months ago',
                  translatedName:
                      'Lipakeng tsa likhoeli tse 6 hoisa ho tse 12'),
              InputFieldOption(
                  code: 'More than a year ago',
                  name: 'More than a year ago',
                  translatedName: 'Ho feta selemo')
            ],
          ),
          InputField(
            id: 'muAZsONb53n',
            name:
                '303. If you don’t mind telling me, what were the results of your last HIV test?',
            translatedName:
                '303. Haeba ha u na bothata ba ho mpolella, sephetho sa hao sa tlhahlobo ea ho qetela se ne se reng?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Positive',
                  name: 'Positive',
                  translatedName: 'Tšoaetso e teng'),
              InputFieldOption(
                  code: 'Negative',
                  name: 'Negative',
                  translatedName: 'Tšoaetso ha e eo'),
              InputFieldOption(
                  code: 'Don\'t Know',
                  name: 'Don\'t Know',
                  translatedName: 'Ha ke tsebe'),
              InputFieldOption(
                  code: 'Declined to disclose',
                  name: 'Declined to disclose',
                  translatedName: 'O ikhethetse ho se phatlalatse sephetho')
            ],
          ),
          InputField(
              id: 'bK3G4mIj2wL',
              name:
                  '304. Are you currently going to clinic/facility to seek HIV care?',
              translatedName:
                  '304. Haeba u na le tšoaetso ea HIV, na u ntse u etela tleleniking ho fumana litšebeletso tsa HIV?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'hmtIvw2mKGc',
              name:
                  '305. At which facility are you currently seeking HIV care?',
              translatedName:
                  '305. Nakong ea joale ke tleleniki efe moo u fumanang litšebeletso tsa HIV?',
              valueType: 'ORGANISATION_UNIT',
              allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
              showCountryLevelTree: true,
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'aQdK3NzB4Xq',
            name:
                '306. What is the main reason why you are not going to a clinic to seek HIV care?',
            translatedName:
                '306. Lebaka la hao la mantlha ke lefe le etsang hore u se ke oa batla litšebeletso tsa HIV?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Facility is too far away',
                  name: 'Facility is too far away',
                  translatedName: 'Tleleniki e hole haholo'),
              InputFieldOption(
                  code: "I don't know where clinic is",
                  name: "I don't know where clinic is",
                  translatedName: 'Ha ke tsebe moo tleleniki e leng teng'),
              InputFieldOption(
                  code: "I can't afford it",
                  name: "I can't afford it",
                  translatedName: 'Ha ke na chelete'),
              InputFieldOption(
                  code: 'I feel healthy/not sick',
                  name: 'I feel healthy/not sick',
                  translatedName:
                      'Ke ikutloa ke ntse ke phetse hantle/ha ke kule'),
              InputFieldOption(
                  code: 'Fear people will know',
                  name: 'Fear people will know',
                  translatedName:
                      'Ke tšaba hore batho ba tla tseba hore ke na le tšoaetso ea HIV ha ke ea tleleniking'),
              InputFieldOption(
                  code: 'Will be discriminated',
                  name: 'Will be discriminated',
                  translatedName:
                      'Ke utloa eka basebeletsi ba tleleniking ba tla nkhesa'),
              InputFieldOption(
                  code: 'Providers at facility are unfriendly',
                  name: 'Providers at facility are unfriendly',
                  translatedName:
                      'Basebeletsi ba tleleniking ha ba sebeletse batho hantle'),
              InputFieldOption(
                  code: 'Taking alternative medicine',
                  name: 'Taking alternative medicine',
                  translatedName:
                      'Ke noa meriana/lipilisi tse sieo tleleniking'),
              InputFieldOption(
                  code: "I'm too busy to go",
                  name: "I'm too busy to go",
                  translatedName: 'Ha ke na nako ea ho ea tleleniking'),
              InputFieldOption(
                  code: 'Other',
                  name: 'Other',
                  translatedName: 'Mabaka a mang'),
            ],
          ),
          InputField(
              id: 'NVhWo52VJaZ',
              name: 'Specify other reasons not going to clinic',
              translatedName: 'Mabaka a mang (a hlalose)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'agg0eUd8Wwo_checkbox',
            name: '307. Never been tested for HIV because',
            translatedName: '307. Ke hobaneng u e-so etse tlhahlobo ea HIV?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'ErH33FSpFcQ',
                  name: 'No knowledge about HIV tests',
                  translatedName: 'Ha ke tsebe letho ka litlhahlobo tsa HIV'),
              InputFieldOption(
                  code: 'fyDiWTn63jY',
                  name: 'Don’t know where to get one',
                  translatedName: 'Ha ke tsebe moo nka hlahlobang HIV'),
              InputFieldOption(
                  code: 'eHUHUbqwtmc',
                  name: 'Can’t afford it',
                  translatedName: 'Ha ke na chelete'),
              InputFieldOption(
                  code: 'Obxp92Sd0Eo',
                  name: 'Transport costs to the site are too much',
                  translatedName: 'Litjeo tsa ho ea tlhahlobong li boima'),
              InputFieldOption(
                  code: 'xN6adtem2UD',
                  name: 'Testing facility is too far away',
                  translatedName: 'Setsi sa tlhahlobo se hole haholo'),
              InputFieldOption(
                  code: 'Vk8oBO8z3yD',
                  name: 'Afraid others will know about the test/ test results',
                  translatedName:
                      'Ke tšaba hore batho ba tla tseba ka tlhahlobo ea ka/sephetho sa ka'),
              InputFieldOption(
                  code: 'hOmGc8b4FRA',
                  name: 'Don’t need to test/ low risk',
                  translatedName:
                      'Ha ke hloke ho hlahloba/monyetla oa hore nka fumana tšoaetso o fokola haholo'),
              InputFieldOption(
                  code: 'XWVu7LTxAJZ',
                  name: 'Afraid to know if I have HIV',
                  translatedName:
                      'Ke tšaba ho tseba hore ke na le tšoaetso ea HIV'),
              InputFieldOption(
                  code: 'csebqOXyZZe',
                  name: 'Too busy to go',
                  translatedName: 'Ha ke na nako ea ho ea tlhahlobong ea HIV')
            ],
          ),
          InputField(
              id: 'Bf8Wp7c3dJF',
              name: 'Other reason',
              translatedName: 'Mabaka a mang (a hlalose)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'sTbepI08QYq',
              name:
                  '308. Do you know of a place(s) where people can get tested for HIV?',
              translatedName:
                  '308. Na u tseba sebaka kapa libaka tseo batho ba ka hlahlobang HIV ho tsona?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
        id: 'E_M_4_S_A',
        name: 'Enrollment Module 4: Sexual Activity',
        translatedName: 'KAROLO EA 4: Thobalano',
        description:
            'INTERVIEWER SAY: Now I will ask you some questions about your sexual activity in order to gain a better understanding of some life issues.  Let me reassure you that your answers are completely confidential. If you are uncomfortable with any questions, please let me know. Remember, there is no right or wrong answer.',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE: Joale ke tla u botsa lipotso ka litaba tsa hao tsa thobalano, e le ho fumana kutloisiso e batsi ka lintlha tsa bohlokoa bophelong ba hao. Ke u tiisetsa hore likarabo tsa hao li tla boloka e le lekunutu. Haeba lipotso tsa ka li u beha tsietsing, mpolelle. Hopola hore ha ho karabo e nepahetseng kapa a fosahetseng.',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'lASgoPYJFDc',
            name:
                'Was your last sexual partner same age, younger or older than you?',
            translatedName:
                'Motho oa ho qetela eo u bileng le likamano tsa thobalano le ena u ne a le moholo, a le monyane kapa le ne lele lithaka?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Same Age',
                  name: 'Same Age',
                  translatedName: 'Thaka ea ka'),
              InputFieldOption(
                  code: 'Younger',
                  name: 'Younger',
                  translatedName: 'monyenyane ho ’na'),
              InputFieldOption(
                  code: 'Older', name: 'Older', translatedName: 'moholo ho ’na')
            ],
          ),
          InputField(
            id: 'aiXLkPRWtYb',
            name: 'Was your last sexual partner circumcised?',
            translatedName:
                'Na motho oa ho qetela eo u bileng le likamano tsa thobalano le eena o ne a rotse katiba (circumcised)?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
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
              id: 'cVoH1CAuMTb',
              name: 'Do you know your last sexual partner HIV status?',
              translatedName:
                  'Na u tseba boemo ba tsoaetso ba motho oa ho qetela eo u bileng le likamano tsa thobalano le eena?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'jnO7z2XOLKv',
            name: 'How often did/do you use a condom with last partner?',
            translatedName:
                'Ke hangata ha kae u neng u sebelisa likhohlopo le motho oa ho qetela eo u bileng le likamano tsa thobalano le eena?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Always',
                  name: 'Always',
                  translatedName: 'Ka linako tsohle'),
              InputFieldOption(
                  code: 'Sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka linako tse ling'),
              InputFieldOption(
                  code: "Never",
                  name: "Never",
                  translatedName: 'Ha ke e-so e sebelise')
            ],
          ),
          InputField(
            id: 'QvjdlvdDG7B',
            name:
                'Was your second to last sexual partner same age, younger or older than you?',
            translatedName:
                'Motho oa bobeli oa ho qetela eo u bileng le likamano tsa thobalano le ena u ne a le moholo, a le monyane kapa le ne lele lithaka?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Same Age',
                  name: 'Same Age',
                  translatedName: 'Thaka ea ka'),
              InputFieldOption(
                  code: 'Younger',
                  name: 'Younger',
                  translatedName: 'monyenyane ho ’na'),
              InputFieldOption(
                  code: 'Older', name: 'Older', translatedName: 'moholo ho ’na')
            ],
          ),
          InputField(
            id: 'ZJ1O2mAvqwE',
            name: 'Was your second to last sexual partner circumcised?',
            translatedName:
                'Na motho oa bobeli oa ho qetela eo u bileng le likamano tsa thobalano le eena o ne a rotse katiba (circumcised)?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
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
              id: 'vaDqnt0gK9y',
              name:
                  'Do you know your second to last sexual partner HIV status?',
              translatedName:
                  'Na u tseba boemo ba tsoaetso ba motho oa ho qetela eo u bileng le likamano tsa thobalano le eena?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'Ec5OLY5STtW',
            name:
                'How often did/do you use a condom with second to last partner?',
            translatedName:
                'Ke hangata ha kae u neng u sebelisa likhohlopo le motho oa  bobeli oa ho qetela eo u bileng le likamano tsa thobalano le eena?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Always',
                  name: 'Always',
                  translatedName: 'Ka linako tsohle'),
              InputFieldOption(
                  code: 'Sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka linako tse ling'),
              InputFieldOption(
                  code: "Never",
                  name: "Never",
                  translatedName: 'Ha ke e-so e sebelise')
            ],
          ),
          InputField(
            id: 'jbKpQbrAoDh',
            name:
                'Was your third last sexual partner same age, younger or older than you?',
            translatedName:
                'Motho oa boraro oa ho qetela eo u bileng le likamano tsa thobalano le ena u ne a le moholo, a le monyane kapa le ne lele lithaka?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Same Age',
                  name: 'Same Age',
                  translatedName: 'Thaka ea ka'),
              InputFieldOption(
                  code: 'Younger',
                  name: 'Younger',
                  translatedName: 'monyenyane ho ’na'),
              InputFieldOption(
                  code: "Older", name: "Older", translatedName: 'moholo ho ’na')
            ],
          ),
          InputField(
            id: 'tO8VP3yEJHq',
            name: 'Was your third to last sexual partner circumcised?',
            translatedName:
                'Na motho oa boraro oa ho qetela eo u bileng le likamano tsa thobalano le eena o ne a rotse katiba (circumcised)?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
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
              id: 'caGPbXZ8ATS',
              name: 'Do you know your third to last sexual partner HIV status?',
              translatedName:
                  'Na u tseba boemo ba tsoaetso ba motho oa boraro oa ho qetela eo u bileng le likamano tsa thobalano le eena?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'bhH17wShRcN',
            name:
                'How often did/do you use a condom with third to last partner?',
            translatedName:
                'Ke hangata ha kae u neng u sebelisa likhohlopo le motho oa  boraro oa ho qetela eo u bileng le likamano tsa thobalano le eena?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Always',
                  name: 'Always',
                  translatedName: 'Ka linako tsohle'),
              InputFieldOption(
                  code: 'Sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka linako tse ling'),
              InputFieldOption(
                  code: "Never",
                  name: "Never",
                  translatedName: 'Ha ke e-so e sebelise')
            ],
          ),
          InputField(
              id: 'VaPh0Wesrnh',
              name:
                  'In the last 12 months have you received money, gifts or favours in exchange for sex?',
              translatedName:
                  'Likhoeling tse 12 tse fetileng, na u kile oa fuoa chelete kapa limpho ho etsa thobalano?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
        name: 'Enrollment Module 5: Reproductive Health',
        translatedName: 'KAROLO EA 5: Bophelo bo botle litabeng tsa thari',
        description:
            'INTERVIEWER SAY: Now I would like us to move on to some questions on your reproductive health. ',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE: Joale ke kopa ho u botsa lipotso mabapi le bophelo bo botle litabeng tsa thari.',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
              id: 'AHbtSNH0i7C',
              name: '501. Do you have biological children?',
              translatedName: '501. Na u na le bana ba tsoetsoeng ke uena?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'RW9VeyKDvjj',
              name: '502. How many biological children do you have?',
              translatedName: '502. U tsoetse bana ba bakae ka palo?',
              valueType: 'NUMBER',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'XYPRtYgQUF8',
            name: '503. Are you currently pregnant?',
            translatedName: '503. Na u mokhachane nakong ea joale?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
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
              id: 'SuB4oeLyzZ0',
              name: '504. Are you attending an ANC clinic for this pregnancy?',
              translatedName:
                  '504. Na u tsamaea tleleniking ea bakhachane nakong ea joale?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'GDrEW22l54i',
              name:
                  '505. Which clinic/facility are you currently seeking ANC services?',
              translatedName:
                  '505. U tsamaea tleleniking efe ho fumana litšebeletso tsa bokhachane?',
              valueType: 'ORGANISATION_UNIT',
              allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
              inputColor: const Color(0xFF258DCC),
              showCountryLevelTree: true,
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'Gs4ArB4ToX5',
              name: '506. Are you aware of any family planning methods?',
              translatedName:
                  '506. Na u tseba letho ka mefuta ea lithibela-pelehi?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'Gs4ArB4ToX5_checkbox',
            name: '507. What family planning methods do you know?',
            translatedName:
                '507. Ke mefuta efe ea lithibela-pelehi eo u e tsebang?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'jIlNVicSnqS',
                  name: 'Pills',
                  translatedName: 'Lipilisi'),
              InputFieldOption(
                  code: 'L4qhaxocyu4',
                  name: 'Injections',
                  translatedName: 'Liente'),
              InputFieldOption(
                  code: 'PJHUhZt3YC7',
                  name: 'Implants',
                  translatedName: 'Lithutsoana'),
              InputFieldOption(
                  code: 'iYyKrzKvF9i',
                  name: 'IUCD (Coil)',
                  translatedName: 'Sekhoqetsane'),
              InputFieldOption(
                  code: 'u4PdP8HWVrs',
                  name: 'Condom',
                  translatedName: 'Likhohlopo'),
              InputFieldOption(
                  code: 'XR1QhO62Zm9',
                  name: 'Permanent (Tubal Ligation)',
                  translatedName: 'Ho koaloa'),
            ],
          ),
          InputField(
              id: 'qjFPwTWaHhx',
              name: 'Other family planning method you know',
              translatedName: 'Tse ling (li hlalose)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'sNLZwEeOdZe',
              name:
                  '508. Are you currently using any modern family planning method?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'FamilyPlanningOptions',
              name: '509. Which family planning methods do you use?',
              translatedName:
                  '509. Na nakong ea joale u sebelisa lithibela-pelehi?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                    code: 'NjAdtVA5MCl',
                    name: 'Pills',
                    translatedName: 'Lipilisi'),
                InputFieldOption(
                    code: 'qdK24nEkW3f',
                    name: 'Injections',
                    translatedName: 'Liente'),
                InputFieldOption(
                    code: 'kRBlMI2RlqO',
                    name: 'Implants',
                    translatedName: 'Lithutsoana'),
                InputFieldOption(
                    code: 'sKIywDycbit',
                    name: 'IUCD (Coil)',
                    translatedName: 'Sekhoqetsane'),
                InputFieldOption(
                    code: 'vsfOugPeOqm',
                    name: 'Condoms',
                    translatedName: 'Likhohlopo'),
                InputFieldOption(
                    code: 'yButAy4UMTY',
                    name: 'Permanent (Tubal Ligation)',
                    translatedName: 'Ho koaloa'),
              ]),
          InputField(
              id: 'EuH6l8V4sXm',
              name: 'Other family planning methods currently using',
              translatedName: 'Tse ling (li hlalose)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'HyT7FrFWRyH',
              name:
                  '510. What’s the main reason for not using any family planning method?',
              translatedName:
                  '510. Lebaka la hao la mantlha la ho se sebelise lithibela-pelehi ke lefe?',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                    code: 'Not sexually active',
                    name: 'Not sexually active',
                    translatedName: 'Ha ke etse thobalano'),
                InputFieldOption(
                    code: 'Religious reasons',
                    name: 'Religious reasons',
                    translatedName: 'Mabaka a tumelo/kereke'),
                InputFieldOption(
                    code: 'Cannot afford',
                    name: 'Cannot afford',
                    translatedName: 'Ha ke na chelete'),
                InputFieldOption(
                    code: 'Do not know where to get',
                    name: 'Do not know where to get',
                    translatedName: 'Ha ke tsebe moo li fumanoang teng'),
                InputFieldOption(
                    code: 'Currently pregnant',
                    name: 'Currently pregnant',
                    translatedName: 'Ke mokhachane nakong ea joale'),
                InputFieldOption(
                    code: 'Other', name: 'Other', translatedName: 'A mang'),
              ]),
          InputField(
              id: 'pq5LEMAI1EX',
              name:
                  'Specify other reasons for not using family planning methods',
              translatedName: 'A mang (hlalosa)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
        name: 'Enrollment Module 6:  Gender-based Violence',
        translatedName: 'Karolo ea 6: Tlhekefetso ea basali GBV',
        description:
            'INTERVIEWER SAY:  The next section goes over a few questions about your experiences with violence.  Now I will ask you some questions about your sexual activity in order to gain a better understanding of some life issues. Let me reassure you that your answers are completely confidential. If you are uncomfortable with any questions, please let me know. Remember, there is no right or wrong answer. \nHas the following happend to you with any man (e.g boyfriend/spouse/family member/neighbour etc?) \nEver and if Yes, has it happend in the past 3 months?',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE:  Karolo ena e latelang ea lipotso e holima seo u se tsebang ka tlhekefetso. Ke tla u botsa lipotso ka litaba tsa hao tse amanang le thobalano e le ho utloisisa lintlha tse ling tse amanang le bophelo. Ke batla ho u tiisetsa hore likarabo tsa hao li tla bolokoa e le lekunutu. Haeba u utloa lipotso tsa ka li u beha tsietsing, u mpolelle. Hopola hore ha ho karabo e nepahetseng kapa a fosahetseng. \nNa liketsahalo tse latelang li kile tsa etsoa ho uena ke motho oa monna (mohlala: mohlankana/monna/ oa hao, setho sa lelapa, kapa mohaisane joalo-joalo?)',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
              id: 'i32OwNqUYRn',
              name:
                  '601. Has any man ever said or did something to humiliate you in front of others?',
              translatedName:
                  '601. Na o kile a bua kapa a etsa ntho e u nyenyefatsang mahlong a batho ba bang?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'ClDEtAAqDPI',
            name:
                'Last three months any man said or did something to humiliate you in front of other?',
            translatedName:
                'Likhoeling tse 3 tse fetileng na o kile a bua kapa a etsa ntho e u nyenyefatsang mahlong a batho ba bang?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Often', name: 'Often', translatedName: 'Hangata'),
              InputFieldOption(
                  code: 'sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka nako e ’ngoe'),
              InputFieldOption(
                  code: 'Not in the last 3 months',
                  name: 'Not in the last 3 months',
                  translatedName: 'Eseng likhoeling tse 3 tse fetileng')
            ],
          ),
          InputField(
              id: 'NgIDtgfZMVH',
              name:
                  '602. Has any man threatened to hurt or harm you or someone you care about?',
              translatedName:
                  '602. Na o kile a u tšosa ka hore o tla u ntša kotsi kapa a ntše motho e mong eo u mo ratang kotsi?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'gY0nOLnR3eh',
            name:
                'Last three months any man threatened to hurt or harm you or someone you care about?',
            translatedName:
                'Likhoeling tse 3 tse fetileng na o kile a u tšosa ka hore o tla u ntša kotsi kapa a ntše motho e mong eo u mo ratang kotsi?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Often', name: 'Often', translatedName: 'Hangata'),
              InputFieldOption(
                  code: 'sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka nako e ’ngoe'),
              InputFieldOption(
                  code: 'Not in the last 3 months',
                  name: 'Not in the last 3 months',
                  translatedName: 'Eseng likhoeling tse 3 tse fetileng')
            ],
          ),
          InputField(
              id: 'KNqzbD65UrN',
              name:
                  '603. Any man insulted or made you feel bad about yourself?',
              translatedName:
                  '603. Na o kile a u rohaka kapa ho etsa hore u ikutloe u le motho ea mobe?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'OZqIvrzGBFK',
            name:
                'Last three months any man insulted or made you feel bad about yourself?',
            translatedName:
                'Likhoeling tse 3 tse fetileng na o kile a u rohaka kapa ho etsa hore u ikutloe u le motho ea mobe?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Often', name: 'Often', translatedName: 'Hangata'),
              InputFieldOption(
                  code: 'sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka nako e ’ngoe'),
              InputFieldOption(
                  code: 'Not in the last 3 months',
                  name: 'Not in the last 3 months',
                  translatedName: 'Eseng likhoeling tse 3 tse fetileng')
            ],
          ),
          InputField(
              id: 'Zmt7PefVzk4',
              name:
                  '604. Any man threatened to take away your economic livelihood?',
              translatedName:
                  '604. Na o kile a u tšosa ka hore o tla u amoha mokhoa oa ho iphelisa?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'iLX2uQ4ZXM0',
            name:
                'Last three months any man threatened to take away your economic livelihood?',
            translatedName:
                'Likhoeling tse 3 tse fetileng na o kile a u tšosa ka hore o tla u amoha mokhoa oa ho iphelisa?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Often', name: 'Often', translatedName: 'Hangata'),
              InputFieldOption(
                  code: 'sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka nako e ’ngoe'),
              InputFieldOption(
                  code: 'Not in the last 3 months',
                  name: 'Not in the last 3 months',
                  translatedName: 'Eseng likhoeling tse 3 tse fetileng')
            ],
          ),
          InputField(
              id: 'NOJbkKuHccD',
              name:
                  '605. Any man push you, shake you, slap/punch/beat you, hit you with something, try to choke you or throw something at you that could hurt you?',
              translatedName:
                  '605. Na o kile a u suthumetsa, a u tlelapa, a u otla ka feisi, a u otla ka ntho e ’ngoe, a leka ho u khama, kapa a u betsa ka ntho e ka u ntšang kotsi?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'GdsRvY5lHCU',
            name:
                'Last three months any man push you, shake you, slap/punch/beat you, hit you with something, try to choke you or throw something at you that could hurt you?',
            translatedName:
                'Likhoeling tse 3 tse fetileng na o kile a u suthumetsa, a u tlelapa, a u otla ka feisi, a u otla ka ntho e ’ngoe, a leka ho u khama, kapa a u betsa ka ntho e ka u ntšang kotsi?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Often', name: 'Often', translatedName: 'Hangata'),
              InputFieldOption(
                  code: 'sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka nako e ’ngoe'),
              InputFieldOption(
                  code: 'Not in the last 3 months',
                  name: 'Not in the last 3 months',
                  translatedName: 'Eseng likhoeling tse 3 tse fetileng')
            ],
          ),
          InputField(
              id: 'mvPAYFoFQcW',
              name:
                  '606. Any man physically forced you to have sexual intercourse with him when you did not want to?',
              translatedName:
                  '606. Na o kile a u qobella ho etsa thobalano le eena ha uena u ne u sa batle ho etsa joalo?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'RO2RIidPOqK',
            name:
                'Last three months any man physically forced you to have sexual intercourse with him when you did not want to?',
            translatedName:
                'Likhoeling tse 3 tse fetileng na o kile a u qobella ho etsa thobalano le eena ha uena u ne u sa batle ho etsa joalo?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Often', name: 'Often', translatedName: 'Hangata'),
              InputFieldOption(
                  code: 'sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka nako e ’ngoe'),
              InputFieldOption(
                  code: 'Not in the last 3 months',
                  name: 'Not in the last 3 months',
                  translatedName: 'Eseng likhoeling tse 3 tse fetileng')
            ],
          ),
          InputField(
              id: 'WwTI82dbYIc',
              name:
                  '607. Any man physically forced you to perform any other sexual acts you did not want to?',
              translatedName:
                  '607. Na o kile a u qobella ho etsa liketso tse ling tsa thobalano tseo u sa li batleng?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'CU4HyDp6XO0',
            name:
                'Last three months any man physically forced you to perform any other sexual acts you did not want to?',
            translatedName:
                'Likhoeling tse 3 tse fetileng na o kile a u qobella ho etsa liketso tse ling tsa thobalano tseo u sa li batleng?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Often', name: 'Often', translatedName: 'Hangata'),
              InputFieldOption(
                  code: 'sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka nako e ’ngoe'),
              InputFieldOption(
                  code: 'Not in the last 3 months',
                  name: 'Not in the last 3 months',
                  translatedName: 'Eseng likhoeling tse 3 tse fetileng')
            ],
          ),
          InputField(
              id: 'bBVCUqsdfL3',
              name:
                  '608. Any man force you with threats or in any other way to perform sexual acts you did not want to?',
              translatedName:
                  '608. Na o kile a u qobella le ho u tšosa hore u etse liketso kapa mefuta e meng ea thobalano eo u sa e batleng?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'NP7LbypO3li',
            name:
                'Last three months any man force you with threats or in any other way to perform sexual acts you did not want to?',
            translatedName:
                'Likhoeling tse 3 tse fetileng na o kile a u qobella le ho u tšosa hore u etse liketso kapa mefuta e meng ea thobalano eo u sa e batleng?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Often', name: 'Often', translatedName: 'Hangata'),
              InputFieldOption(
                  code: 'sometimes',
                  name: 'Sometimes',
                  translatedName: 'Ka nako e ’ngoe'),
              InputFieldOption(
                  code: 'Not in the last 3 months',
                  name: 'Not in the last 3 months',
                  translatedName: 'Eseng likhoeling tse 3 tse fetileng')
            ],
          ),
          InputField(
              id: 'ZcfLYz7JlVo',
              name:
                  '609. Did you seek help after experiencing the different things we have discussed?',
              translatedName:
                  '609. Na u kile oa kopa thuso kamora liketsahalo tseo u li hlalositseng?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'ZcfLYz7JlVo_checkbox',
            name: '610. Where did you seek help from?',
            translatedName: '610. U ile oa kopa thuso ho mang kapa kae?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'prTJovIPAKu',
                  name: 'My family',
                  translatedName: 'Lelapa leso'),
              InputFieldOption(
                  code: 'ABZxvJiwxzk',
                  name: 'Husband/Partner/Boyfriend’s family',
                  translatedName:
                      'Monna oa ka/mohlankana oa ka/lelapa la bo mohlankana oa ka'),
              InputFieldOption(
                  code: 'bSV7DYAysFT',
                  name: 'Friend',
                  translatedName: 'Motsoalle'),
              InputFieldOption(
                  code: 'DzQ8pTNwsoA',
                  name: 'Neighbour',
                  translatedName: 'Mohaisane'),
              InputFieldOption(
                  code: 'ydSybWoOk93',
                  name: 'Religious leader',
                  translatedName: 'Moruti oa kereke'),
              InputFieldOption(
                  code: 'U5MaBVRWZTu',
                  name: 'Doctor/Medical personnel',
                  translatedName: 'Ngaka/Mosebeletsi oa bophelo'),
              InputFieldOption(
                  code: 'fq9YW2mfHhx',
                  name: 'Chief or village elder',
                  translatedName: 'Morena kapa motho e moholo motseng'),
              InputFieldOption(
                  code: 'NOZhaj68naE',
                  name: 'Police',
                  translatedName: 'Sepolesa'),
              InputFieldOption(
                  code: 'YaP6i0e5ksq',
                  name: 'Justice system',
                  translatedName: 'Makhotla a toka'),
              InputFieldOption(
                  code: 'OnrjChs6Pzg',
                  name: 'NGO/CBO',
                  translatedName: 'Mekhatlo e ikemetseng/Mokhatlo oa kereke')
            ],
          ),
          InputField(
              id: 'H2Az2c3MeAy',
              name:
                  '611. Do you know where to seek help if you experience the different things that we discussed?',
              translatedName:
                  '611. Na u tseba moo u ka batlang thuso ha u kopana le mathata ao re qetang ho buisana ka ona?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'H2Az2c3MeAy_checkbox',
            name:
                '612. If experienced the different things that we discussed,where would you seek help from?',
            translatedName:
                '612. U ka batla thuso kae ha u kopana le mathata ao re qetang ho buisana ka ona?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'GUOZrOkgtxO',
                  name: 'Family',
                  translatedName: 'Lelapa leso'),
              InputFieldOption(
                  code: 'dXKzcRop0YS',
                  name: 'Husband/Partner/Boyfriend’s family',
                  translatedName:
                      'Monna oa ka/mohlankana oa ka/lelapa la bo mohlankana oa ka'),
              InputFieldOption(
                  code: 'K5NF7rk4RYa',
                  name: 'Friend',
                  translatedName: 'Motsoalle'),
              InputFieldOption(
                  code: 'u3IjpFje21i',
                  name: 'Neighbour',
                  translatedName: 'Mohaisane'),
              InputFieldOption(
                  code: 'JWuFSdMrZXy',
                  name: 'Religious leader',
                  translatedName: 'Moruti oa kereke'),
              InputFieldOption(
                  code: 'oWcT4kzD78y',
                  name: 'Doctor/Medical personnel',
                  translatedName: 'Ngaka/Mosebeletsi oa bophelo'),
              InputFieldOption(
                  code: 'zhumM3lBA8J',
                  name: 'Chief or Village elder',
                  translatedName: 'Morena kapa motho e moholo motseng'),
              InputFieldOption(
                  code: 'k53fDCE7BHI',
                  name: 'Police',
                  translatedName: 'Sepolesa'),
              InputFieldOption(
                  code: 'COJIywvGzco',
                  name: 'Justice',
                  translatedName: 'Makhotla a toka'),
              InputFieldOption(
                  code: 'fJzsO0ADn85',
                  name: 'NGO/CBO',
                  translatedName: 'Mekhatlo e ikemetseng/Mokhatlo oa kereke')
            ],
          ),
          InputField(
              id: 'OFJD1RNGEZu',
              name: 'Specify other you will seek help from',
              translatedName: 'Ba bang (ba hlalose)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
        name: 'Enrollment Module 7:  Non-Prescription Drug Use',
        translatedName:
            'KAROLO EA 7: Tšebeliso ea lithethefatsi tse sa fanoang ke lingaka',
        description:
            'INTERVIEWER SAY: I would like to ask you some questions about drugs or substances that you may have taken that were not prescribed by your doctor.  Now I will ask you some questions about your sexual activity in order to gain a better understanding of some life issues.  Let me reassure you that your answers are completely confidential. If you are uncomfortable with any questions, please let me know. Remember, there is no right or wrong answer.',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE:  Ke tla u botsa lipotso ka litaba tsa hao tse amanang le lithethefatsi tseo u kileng oa li sebelisa empa u sa li fuoa ke ngaka. Ke tla u botsa lipotso ka litaba tsa hao tse amanang le thobalano e le ho utloisisa lintlha tse ling tse amanang le bophelo. Ke batla ho u tiisetsa hore likarabo tsa hao li tla bolokoa e le lekunutu. Haeba u utloa lipotso tsa ka li u beha tsietsing, u mpolelle. Hopola hore ha ho karabo e nepahetseng kapa a fosahetseng.',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
              id: 'QaIUtFdgdIa',
              name: '701. Have you used alcohol in the last 12 months?',
              translatedName:
                  '701. Likhoeling tse 12 tse fetileng, na u kile oa noa joala?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'JSBixuSLIC5',
            name:
                '702. In the past 12 months, how often did you have a drink containing alcohol?',
            translatedName:
                '702. Likhoeling tse 12 tse fetileng, u noele joala ka makhetlo a makae?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Everyday',
                  name: 'Everyday',
                  translatedName: 'Letsatsi le leng le le leng'),
              InputFieldOption(
                  code: '5 to 6 times a week',
                  name: '5 to 6 times a week',
                  translatedName: 'Makhetlo a 5 hoisa ho 6 ka beke'),
              InputFieldOption(
                  code: '3 to 4 times a week',
                  name: '3 to 4 times a week',
                  translatedName: 'Makhetlo a 3 hoisa ho 4 ka beke'),
              InputFieldOption(
                  code: 'Once a week',
                  name: 'Once a week',
                  translatedName: 'Hang ka beke'),
              InputFieldOption(
                  code: '2 to 3 times a month',
                  name: '2 to 3 times a month',
                  translatedName: 'Makhetlo a 2 hoisa 3 ka khoeli'),
              InputFieldOption(
                  code: 'Once a month',
                  name: 'Once a month',
                  translatedName: 'Hang ka khoeli'),
              InputFieldOption(
                  code: '3 to 11 times in the past year',
                  name: '3 to 11 times in the past year',
                  translatedName: 'Makhetlo a 3 hoisa 11 selemong se fetileng'),
              InputFieldOption(
                  code: '1 or 2 times in the past year',
                  name: '1 or 2 times in the past year',
                  translatedName: 'Hang kapa makhetlo a 2 selemong se fetileng')
            ],
          ),
          InputField(
              id: 'o9tReELSzRN',
              name:
                  '703. Have you used drugs of abuse or addiction in the last 12 months?',
              translatedName:
                  '703. Na likhoeling tse 12 tse fetileng u kile oa sebelisa lithethefatsi?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'ypeOfDrugUsed',
            name:
                '704. Which type of drugs of abuse/addiction have you used in the last 12 months?',
            translatedName:
                '704. Likhoeling tse 12 tse fetileng, u kile oa sebelisa mefuta efe ea lithethefatsi?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'LUfX3TMLmvl',
                  name: 'Marijoana or Matekoane',
                  translatedName: 'Matekoane'),
              InputFieldOption(
                  code: 'oNMUWj5OmDr',
                  name: 'Glue or Petrol or Gundi',
                  translatedName: 'Glue/Petrol'),
              InputFieldOption(
                  code: 'unqP2uT3uD9',
                  name: 'Cocaine',
                  translatedName: 'Cocaine'),
              InputFieldOption(
                  code: 'aGrDT7Cuiag',
                  name: 'Heroin',
                  translatedName: 'Heroin'),
              InputFieldOption(
                  code: 'psrnUniyPWZ',
                  name: 'Mandrax',
                  translatedName: 'Mandrax'),
              InputFieldOption(
                  code: 'qQ4DKYTCtnb',
                  name: 'Cigarettes or Tobacco',
                  translatedName: 'Lisakarete/Koae'),
              InputFieldOption(
                  code: 'L65TAJtipUT',
                  name: 'Other',
                  translatedName: 'Tse ling')
            ],
          ),
          InputField(
            id: 'yZtuWQz9RG8',
            name: 'Specify other type of drugs abuse/addiction used 12 months',
            translatedName: 'Tse ling (li hlalose)',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'YSAyCyGWCaK',
              name:
                  '705. In the last 12 months have you engaged in brewing or selling alcohol and/or drugs of abuse or addiction?',
              translatedName:
                  '705. Likhoeling tse 12 tse fetileng na u kile oa ritela kapa oa rekisa joala le lithethefatsi?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
        name: 'Enrollment Module 8:  Participation in HIV Prevention Programme',
        translatedName:
            'KAROLO EA 8: Ho kena mananehong a thibelo ea tšoaetso ea HIV',
        description:
            'INTERVIEWER SAY: I would like to ask you a final question about your participation in any of the below programs or interventions.',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE: Ke kopa ho u botsa potso ea ho qetela. Na u kile oa kena mananehong a latelang:',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
              id: '',
              name:
                  '801. Have you ever participated or been trained in any of these programmes?',
              translatedName:
                  '801. Na u kile oa kena lithupelong kapa mananehong a latelang?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: 'Hn0P1sGIKe1',
                  name: 'Go Girls: Sepheo Adopted Curriculum: Married Women',
                ),
                InputFieldOption(
                  code: 'SaAW6b6glDZ',
                  name:
                      'Singing to the Lions: A Facilitator\'s Guide to Overcoming Fear and Violence in Our Lives',
                ),
                InputFieldOption(
                  code: 'hGzsAgaBPSY',
                  name: 'Aflatoun Non Formal Education',
                ),
                InputFieldOption(
                  code: 'iFFZOpnvyDp',
                  name: 'Financial Education',
                ),
                InputFieldOption(
                  code: 'Ue7KBKNtUzO',
                  name: 'Savings and Internal Lending Communities (SILC)',
                ),
                InputFieldOption(
                  code: 'uEl5YpDbqnb',
                  name: 'Condom Social Marketing CSM Toolkit (Pusha love)',
                ),
              ]),
          InputField(
              id: 'w4GPtcJq2x9',
              name: 'Comments',
              translatedName: 'Maikutlo',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
    ];
  }
}
