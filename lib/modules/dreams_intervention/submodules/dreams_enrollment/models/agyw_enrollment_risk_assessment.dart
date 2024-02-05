import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class AgywEnrollmentRiskAssessment {
  static List<String> getMandatoryField() {
    return [
      'WTZ7GLTrE8Q',
      'rSP9c21JsfC',
      'qZP982qpSPS',
      'VJiWumvINR6',

      //Risk assessment
      'fSQY2z3L0lp',
      'UzQ533pOnvt',
      'GwVHeyOqTv2',
      'T3i6bQ3tCaA',
      'q8qPtzanSTU',
      'LNaNh7kvh4X',
      'wGFmu7DhNGV',
      'G1s75wng5DY',
      'fyIUCi5EUtp',
      'x9CWVcy9CZ2',
      'bkpG276xEk9',
      'afatGR9sy5Q',
      'yCmbCOTbH3R',
      'VomsiFza9mn',
      'Dclkscej6HW',
      'VsqV6prIfm9',
      'r0rKJA911ma',
      'S4yWgL2zp2I',
      'NhBs8uAiRPt',
      'fVJfCtBVjan',
      'IokYFEUtSuc',
      'lo645exmnYG',
      'DBFA8dHsErO',
      'MeKao21EPyi',
      'fVJfCtBVjan',
      'IokYFEUtSuc',
      'lo645exmnYG',
      'DBFA8dHsErO',
      'MeKao21EPyi',
      'rsi08hlOFm8',
      'yU4tNjFpQIq',
      'zsivYH5qkho',
      'rsi08hlOFm8',
      'yU4tNjFpQIq',
      'zsivYH5qkho',
      'qTZtbRWe1Hb',
      'TJ5KB6GfZX4',
      'OA1dR8a4UWu',
      'EQHcFozjbP0',
      'Z7PTcgqwCLu',
      'FuYyLjYxxkg',
      'ODBeRytTLHm',
      'OQS3C6pUiWH',
      'uBx2mRzZoRh',
      'aIJoCMWUqBs',
      'zowQOCZivv8',
      'RB8Wx75hGa4',
      'dQPw7EzqJP6',
      'fEHah8SvP35',
      'x6VFmJLsqgx',
      'OmOU8n78dg7',
      's1eRvsL2Ly4',
      'YQ9G0ww2cDN',
      'auPInwvDZjF',
      'dxp3qM2TgUc',
      'iS9mAp3jDaU'
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        name: 'Demographic Information',
        translatedName: 'Litaba tsa Boitsebiso ba motho',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'WTZ7GLTrE8Q',
            name: 'First Name',
            translatedName: 'Lebitso la pele',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 's1HaiT6OllL',
            name: 'Middle Name',
            translatedName: 'Lebitso le mahareng',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'rSP9c21JsfC',
            name: 'Surname',
            translatedName: 'Le Fane',
            regExpValidation: RegExp('^[A-Za-z]{0,}'),
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'qZP982qpSPS',
              name: 'Date of Birth',
              translatedName: 'Letsatsi la tsoalo',
              valueType: 'DATE',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              maxAgeInYear: 24,
              numberOfMonth: 11,
              minAgeInYear: 10,
              hint: "Beneficiary's age should be from 10 - 24 years",
              translatedHint: "Lilemo tsa setho li be pakeng tsa 10 le 24"),
          InputField(
            id: 'ls9hlz2tyol',
            name: 'Age',
            translatedName: 'Lilemo',
            isReadOnly: true,
            valueType: 'NUMBER',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'VJiWumvINR6',
            name: 'Sex',
            translatedName: 'Boleng',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
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
              InputFieldOption(
                  code: 'Transgender (male to female)',
                  name: 'Transgender (male to female)'),
              InputFieldOption(
                  code: 'Transgender (female to male)',
                  name: 'Transgender (female to male)'),
            ],
          ),
          InputField(
            id: 'tNdoR0jYr7R',
            name: 'Phone number of AGYW',
            translatedName:
                'Nomoro ea fono ea moroetsana/mosali ea mocha lilemong (haeba e le teng)',
            valueType: 'PHONE_NUMBER',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 's1eRvsL2Ly4',
            name: 'Marital Status.',
            translatedName: 'Boemo ba lenyalo.',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Married',
                  name: 'Married',
                  translatedName: 'Ka hara lenyalo'),
              InputFieldOption(
                  code: 'Single',
                  name: 'Single',
                  translatedName: 'Ha a nyaloa'),
              InputFieldOption(
                  code: 'Widowed',
                  name: 'Widowed',
                  translatedName: 'Molekane o hlokahetse'),
              InputFieldOption(
                  code: 'Divorced/separated',
                  name: 'Divorced/separated',
                  translatedName: 'Tlhalano/Karohano'),
              InputFieldOption(
                  code: 'Cohabiting',
                  name: 'Cohabiting',
                  translatedName: 'Ho lula hammoho (le molekane)')
            ],
          ),
          InputField(
            id: 'RB8Wx75hGa4',
            name: 'Village',
            translatedName: 'Motse',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'dQPw7EzqJP6',
            name: 'Land mark near residence',
            translatedName: 'Sebaka se tsejoang haufi',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: '',
              name: 'Have you been a member of',
              translatedName: 'Na u bile setho sa',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              renderAsRadio: true,
              options: [
                InputFieldOption(
                    code: 'dH0hCyp67mE',
                    name: 'Parenting DREAMS intervention?',
                    translatedName: 'Lelapa la Rethabile (Parenting)'),
                InputFieldOption(
                    code: 'auHaVN3ynaC',
                    name:
                        'Social Assessts building (Go Girls/Orgac/Aflateen/Aflatoun/PTS DREAMS intervention?',
                    translatedName:
                        'Social Assessts building (Go Girls/Orgac/Aflateen/Aflatoun/PTS'),
                InputFieldOption(
                    code: 'EJIDVrxGMUB',
                    name: 'SILC (Socio- Economic) DREAMS intervention?',
                    translatedName:
                        'Mokhatlo oa Lipoloko Le Likalimo (SILC Socio- Economic 18+)'),
                InputFieldOption(
                    code: 'LpSAlQaaU2x',
                    name:
                        'Savings Group (Socio-Economic 10-17) DREAMS intervention?',
                    translatedName:
                        'Mokhatlo oa bana oa lipoloko (Savings Group 10-17)'),
                InputFieldOption(
                    code: 'g5Vyffx2vQL',
                    name: 'Steeping Stone DREAMS intervention?',
                    translatedName: 'Stepping Stone'),
                InputFieldOption(
                    code: 'yNl9YGbd3ps',
                    name: 'Condom Promotion and Provision DREAMS intervention?',
                    translatedName:
                        'Khothaletso ea Tšebeliso ea Likhohlopo le Phano ea tsona'),
                InputFieldOption(
                    code: 'F7s1XFNiEEx',
                    name: 'Contraceptive Mix DREAMS intervention?',
                    translatedName: 'Mekhoa e Fapakaneng ea Lithibela-pelehi'),
                InputFieldOption(
                    code: 'etOufdeoXVG',
                    name:
                        'HIV and Violence Prevention (LBSE) DREAMS intervention?',
                    translatedName:
                        'Kokoana-hloko ea HIV le Thibelo ea Tlhekefetso (LBSE)'),
                InputFieldOption(
                    code: 'O6aTNTaFqHx',
                    name: 'HTS DREAMS intervention?',
                    translatedName: 'Litšebeletso tsa Tlhahlobo ea HIV '),
                InputFieldOption(
                    code: 'Q0BCuDsN52v',
                    name: 'PrEP DREAMS intervention?',
                    translatedName:
                        'Lipilisi tse Thibelang Tšoaetso ea HIV (PREP)'),
                InputFieldOption(
                    code: 'Ve9tcZoPoQk',
                    name: 'Post-Violence Care DREAMS intervention?',
                    translatedName: 'Tlhokomelo Kamora Tlhekefetso'),
                InputFieldOption(
                    code: 'IYhZVmA0ED1',
                    name: 'HIV Risk Assessment Messaging DREAMS intervention?',
                    translatedName:
                        'Melaetsa e Hlahlobang ho ba Kotsing ea Tšoaetso ea HIV'),
                InputFieldOption(
                    code: 'uzfQwO4ypIP',
                    name: 'ART DREAMS intervention?',
                    translatedName: 'Kalafo ea HIV ka Lipilisi '),
              ])
        ],
      ),
      FormSection(
        id: 'householdInformation',
        name: 'Household Information',
        translatedName: 'Boitsebiso ba lelapa',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'YQ9G0ww2cDN',
            name: '1. AGYW’s father given name',
            translatedName:
                '1. Lebitso la ntate oa moroetsana/mosali ea mocha lilemong (AGYW)',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'auPInwvDZjF',
            name: '2. AGYW’s mother given name',
            translatedName:
                '2. Lebitso la ’m’e oa moroetsana/mosali ea mocha lilemong',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'NrYoz8RewxV',
            name:
                '3. If the AGYW comes from child headed family,Name of the Sister/Brother',
            translatedName:
                '3. Haeba moroetsana/mosali ea mocha lilemong a tsoa lelapeng leo hloho ea lelapa e leng ngoana, fana ka lebitso la ngoana eo',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'dxp3qM2TgUc',
            name: '4. Name of parent/caregiver',
            translatedName: '4. Lebitso la motsoali/mohlokomeli',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'iS9mAp3jDaU',
            name: '5. Relationship to Caregiver',
            translatedName: '5. Kamano le mohlokomeli',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
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
                  translatedName: 'Ke Malome/Rangoane/Rakhali/’Mangoane'),
              InputFieldOption(
                  code: 'Sibling',
                  name: 'Sibling',
                  translatedName: 'Ke ngoaneso'),
              InputFieldOption(
                  code: 'Grandparent',
                  name: 'Grandparent',
                  translatedName: 'Ke Nkhono/Ntate-moholo'),
              InputFieldOption(
                  code: 'Spouse', name: 'Spouse', translatedName: 'Molekane'),
              InputFieldOption(
                  code: 'Other', name: 'Other', translatedName: 'Tse ling')
            ],
          ),
          InputField(
            id: 'nuka3TRVCnJ',
            name: 'Other relationship to caregiver',
            translatedName: 'Tse ling (hlalosa)',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'pvjIijxEJGp',
            name:
                '6. Phone number of parent/caregiver/heads of the family if available',
            translatedName:
                '6. Nomoro ea fono ea motsoali/mohlokomeli/hloho ea lelapa',
            valueType: 'PHONE_NUMBER',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        name: 'Risk Assessment',
        translatedName: 'Tlhahlobo ea kotsi',
        color: const Color(0xFF258DCC),
        inputFields: [],
        subSections: [
          FormSection(
            id: '1_E_H_S',
            name: '1. Ever had sex',
            translatedName: '1. O kile a etsa thobalano',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'fSQY2z3L0lp',
                name: 'a. Have you ever had sex?',
                translatedName: 'a. Na u kile ua etsa thobalano?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'UzQ533pOnvt',
                name:
                    'b. How old were you when you had sex for the first time?',
                translatedName:
                    'b. U ne u le lilemo tse kae ha u qala ho etsa thobalano?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: '9-14', name: '9-14'),
                  InputFieldOption(code: '15-19', name: '15-19'),
                  InputFieldOption(code: '20-24', name: '20-24'),
                ],
              ),
              InputField(
                id: 'GwVHeyOqTv2',
                name: 'c. Do you have any sexual partner?',
                translatedName:
                    'c. Na ho na le motho eo u etsang thobalano le eena?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'T3i6bQ3tCaA',
                name: 'd. Are you involved in any sexual activity?',
                translatedName: 'd. Na u etsa thobalano?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'q8qPtzanSTU',
                name:
                    'e. How many sexual partners have you had in the last 12 months?',
                translatedName:
                    'e. U entse thobalano le batho ba bakae ka palo likhoeling tse 12 tse fetileng?',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '1_M_S_P',
            name: '1. Multiple sexual patners (in the last year)',
            translatedName:
                '1.  Na u entse thobalano le batho ba fapaneng (selemong se fetileng)',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'fSQY2z3L0lp',
                name: 'a. Have you ever had sex?',
                translatedName: 'a. Na u kile ua etsa thobalano?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'UzQ533pOnvt',
                name:
                    'b. How old were you when you had sex for the first time?',
                translatedName:
                    'b. U ne u le lilemo tse kae ha u qala ho etsa thobalano?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: '9-14', name: '9-14'),
                  InputFieldOption(code: '15-19', name: '15-19'),
                  InputFieldOption(code: '20-24', name: '20-24'),
                ],
              ),
              InputField(
                id: 'GwVHeyOqTv2',
                name: 'c. Do you have any sexual partner?',
                translatedName:
                    'c. Na ho na le motho eo u etsang thobalano le eena?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'T3i6bQ3tCaA',
                name: 'd. Are you involved in any sexual activity?',
                translatedName: 'd. Na u etsa thobalano?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'q8qPtzanSTU',
                name:
                    'e. How many sexual partners have you had in the last 12 months?',
                translatedName:
                    'e. U entse thobalano le batho ba bakae ka palo likhoeling tse 12 tse fetileng?',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '2_H_O_P',
            name: '2. History of pregnancy',
            translatedName: '2. Nalane ea bokhachane',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'LNaNh7kvh4X',
                name: 'a. Have you ever been or are you currently pregnant?',
                translatedName:
                    'a. Na u kile oa ima nakong e fetileng kapa na u mokhachane nakong ea joale?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'wGFmu7DhNGV',
                name: 'b. Do you have any children?',
                translatedName: 'b. Na u na le bana?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'G1s75wng5DY',
                name: 'c. How many children do you have?',
                translatedName: 'c. Bana ba hao ba bakae ka palo?',
                valueType: 'NUMBER',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '3_STI',
            name: '3. STI (diagnosed or treated)',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'fyIUCi5EUtp',
                name: 'a. Have you ever been diagnosed with any STIs?',
                translatedName:
                    'a. Na u kile oa fumanoa u e-na le tšoaetso ea mafu a likobo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'x9CWVcy9CZ2',
                name: 'b. If yes, were they treated',
                translatedName:
                    'b. Haeba karabo e le “E”, na mafu ao a ile a alafuoa?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '4_N_O_I_C_U',
            name: '4. No or irregular condom use',
            translatedName:
                '4. Ho sebelise kapa tšebeliso e sa nepahalang ea likhohlopo',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'bkpG276xEk9',
                name: 'a. Do you use condoms regularly?',
                translatedName: 'a. Na u sebelisa likhohlopo khafetsa?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'afatGR9sy5Q',
                name: 'b. Do you know where to get condoms?',
                translatedName: 'b. Na u tseba moo u ka fumanang likhohlopo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'yCmbCOTbH3R',
                name:
                    'c. Did you use a condom during your last sexual activity?',
                translatedName:
                    'c. Na u ile ua sebelisa khohlopo lekhetlong la ho qetela ha u ne u etsa thobalano?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'VomsiFza9mn',
                name: 'd. Are you currently taking any contraceptives?',
                translatedName:
                    'd. Na, nakong ea joale, u sebelisa lithibela-pelehi?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '4_E_O_S_V',
            name: '4. Experience of sexual violence (lifetime)',
            translatedName: '4. Ho hlekefetsoa ka motabo (bophelo bohle)',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'Dclkscej6HW',
                name:
                    'a. Have you ever experienced sexual violence (lifetime)?',
                translatedName:
                    'a. Na u kile oa hlekefetsoa ka motabo bophelong ba hao?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'VsqV6prIfm9',
                name:
                    'b. Did you ever have someone touch you on your private parts without your concern?',
                translatedName:
                    'b. Na ho kile ha eba le motho ea u phopholetsang ka bothong ntle le tumello ea hao?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'r0rKJA911ma',
                name: 'c. Did you ever have forced sex?',
                translatedName:
                    'c. Na u kile ua etsa thobalano e qobeletsoeng?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'S4yWgL2zp2I',
                name:
                    'd. Did you ever have forced unprotected sex while you wanted protected sex?',
                translatedName:
                    'd. Na u kile ua qobelloa ho etsa thobalano e sa sireletsoang ha uena u ne u batla e sirelelitsoeng?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '5_T_S',
            name:
                '5. Transactional sex (including staying in a relationship for material or financial support)',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'NhBs8uAiRPt',
                name:
                    'a. Do you engage in sexual activities in exchange for money or any material things (including staying in a relationship for material or financial support)?',
                translatedName:
                    'a. Na u kena thobalanong u shebile menyetla ea chelete kapa lintho tse ling tse molemo (ho kenyeletsa ho ba le likamano ka lebaka la tsehetso ea lichelete kapa lintho tse ling)? ',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '5_E_O_P_E_V',
            name:
                '5. Experience of physical or emotional violence (Currently or within the past twelve months)',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'fVJfCtBVjan',
                name:
                    'a. Experience of physical or emotional violence (within the last year)?',
                translatedName:
                    'a. Na u kile oa hlekefetsoa ’meleng kapa maikutlong (selemong se fetileng)',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'IokYFEUtSuc',
                name: 'b. Has your partner ever hit or hurt you in any way?',
                translatedName:
                    'b. Na mohlankana/monna oa hao o kile a u otla kapa ho u utloisa bohloko maikutlong?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'lo645exmnYG',
                name: 'c. Has your partner ever threatened to hurt you?',
                translatedName:
                    'c. Na mohlankana/monna oa hao o kile a u tšosa ka hore o tla u ntša kotsi?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'DBFA8dHsErO',
                name:
                    'd. Do you generally feel unsafe in your current relationship with your partner?',
                translatedName:
                    'd. Na u ikutloa u sa sireletseha likamanong tsa hao le mohlankana/monna oa hao nakong ea joale?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                  id: 'MeKao21EPyi',
                  name:
                      'e. Do/did you feel afraid of your partner in any ways?',
                  translatedName:
                      'e. Na u utloa u e-na le tšabo kapa u kile oa utloa u e-na le tšabo ea mohlankana/monna oa hao?',
                  valueType: 'BOOLEAN',
                  inputColor: const Color(0xFF258DCC),
                  labelColor: const Color(0xFF737373))
            ],
          ),
          FormSection(
            id: '6_E_O_S_V',
            name: '6. Experience of sexual violence (lifetime)',
            translatedName: '6. Ho hlekefetsoa ka motabo (bophelo bohle)',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'Dclkscej6HW',
                name:
                    'a. Have you ever experienced sexual violence (lifetime)?',
                translatedName:
                    'a. Na u kile oa hlekefetsoa ka motabo bophelong ba hao?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'fVJfCtBVjan',
                name:
                    'b. Experience of physical or emotional violence (within the last year)?',
                translatedName:
                    'b. Na u kile oa hlekefetsoa ’meleng kapa maikutlong (selemong se fetileng)',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'IokYFEUtSuc',
                name: 'c. Has your partner ever hit or hurt you in any way?',
                translatedName:
                    'c. Na mohlankana/monna oa hao o kile a u otla kapa ho u utloisa bohloko maikutlong?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'lo645exmnYG',
                name: 'd. Has your partner ever threatened to hurt you?',
                translatedName:
                    'd. Na mohlankana/monna oa hao o kile a u tšosa ka hore o tla u ntša kotsi?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'DBFA8dHsErO',
                name:
                    'e. Do you generally feel unsafe in your current relationship with your partner?',
                translatedName:
                    'e. Na u ikutloa u sa sireletseha likamanong tsa hao le mohlankana/monna oa hao nakong ea joale?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                  id: 'MeKao21EPyi',
                  name:
                      'f. Do/did you feel afraid of your partner in any ways?',
                  translatedName:
                      'f. Na u utloa u e-na le tšabo kapa u kile oa utloa u e-na le tšabo ea mohlankana/monna oa hao?',
                  valueType: 'BOOLEAN',
                  inputColor: const Color(0xFF258DCC),
                  labelColor: const Color(0xFF737373))
            ],
          ),
          FormSection(
            id: '6_A_U',
            name: '6. Alcohol use',
            translatedName: '6. Tšebeliso ea joala',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'rsi08hlOFm8',
                name: 'a. Have you ever or are you currently using alcohol?',
                translatedName:
                    'a. Na u kile oa noa joala nakong e fetileng kapa u noa joala nakong ea joale?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'yU4tNjFpQIq',
                name:
                    'b. During the past three months, has your use of alcohol led to health, social, legal or financial problems?',
                translatedName:
                    'b. Likhoeling tse 3 tse fetileng, na ho noa joala ho u baketse mathata bophelong, likamanong le batho ba bang, litlolong tsa molao, kapa cheleteng?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'zsivYH5qkho',
                name:
                    'c. Do you ever forget things you did while using alcohol?',
                translatedName:
                    'c. Na u ke u iphumane u sa hopole lintho tseo u li entseng nakong eo u neng u noele joala?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '7_A_U',
            name: '7. Alcohol use',
            translatedName: '7. Tšebeliso ea joala',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'rsi08hlOFm8',
                name: 'a. Have you ever or are you currently using alcohol?',
                translatedName:
                    'a. Na u kile oa noa joala nakong e fetileng kapa u noa joala nakong ea joale?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'yU4tNjFpQIq',
                name:
                    'b. During the past three months, has your use of alcohol led to health, social, legal or financial problems?',
                translatedName:
                    'b. Likhoeling tse 3 tse fetileng, na ho noa joala ho u baketse mathata bophelong, likamanong le batho ba bang, litlolong tsa molao, kapa cheleteng?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'zsivYH5qkho',
                name:
                    'c. Do you ever forget things you did while using alcohol?',
                translatedName:
                    'c. Na u ke u iphumane u sa hopole lintho tseo u li entseng nakong eo u neng u noele joala?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '7_A_M',
            name: '7. Alcohol misuse',
            translatedName: '7. Tšebeliso e mpe ea joala',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'rsi08hlOFm8',
                name: 'a. Have you ever or are you currently using alcohol?',
                translatedName:
                    'a. Na u kile oa noa joala nakong e fetileng kapa u noa joala nakong ea joale?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'yU4tNjFpQIq',
                name:
                    'b. During the past three months, has your use of alcohol led to health, social, legal or financial problems?',
                translatedName:
                    'b. Likhoeling tse 3 tse fetileng, na ho noa joala ho u baketse mathata bophelong, likamanong le batho ba bang, litlolong tsa molao, kapa cheleteng?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'zsivYH5qkho',
                name:
                    'c. Do you ever forget things you did while using alcohol?',
                translatedName:
                    'c. Na u ke u iphumane u sa hopole lintho tseo u li entseng nakong eo u neng u noele joala?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '7_O_S',
            name: '7. Out of school',
            translatedName: '7. Ha kene sekolo',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'qTZtbRWe1Hb',
                name:
                    'a. Are you currently enrolled in school or a vocation program?',
                translatedName:
                    'a. Na u kena sekolo se tloaelehileng kapa sekolo sa mosebetsi oa matsoho?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'TJ5KB6GfZX4',
                name: 'b. Which one',
                translatedName: 'b. Haeba ho le joalo, sekolo seo ke sefe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                    code: 'School',
                    name: 'School',
                    translatedName: 'Sekolo se tloaelehileng',
                  ),
                  InputFieldOption(
                      code: 'Vocational',
                      name: 'Vocational',
                      translatedName: 'ekolo sa mosebetsi oa matsoho ,')
                ],
              ),
              InputField(
                id: 'OA1dR8a4UWu',
                name:
                    'c. Would you prefer re-enrolment in either school or vocational training?',
                translatedName:
                    'c. Haeba u sa kene sekolo, u ka thabela ho kena sekolo se tloaelehileng kapa sekolo sa mosebetsi oa matsoho?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'EQHcFozjbP0',
                name: 'd. Have you ever had to drop-out then been readmitted?',
                translatedName:
                    'd. Haeba u kena sekolo, na u kile oa se tlohela ka lehare ’me oa amoheloa bocha?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '8_O_O_S',
            name: '8. Out of school',
            translatedName: '8. Ha kene sekolo',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'qTZtbRWe1Hb',
                name:
                    'a. Are you currently enrolled in school or a vocation program?',
                translatedName:
                    'a. Na u kena sekolo se tloaelehileng kapa sekolo sa mosebetsi oa matsoho?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'TJ5KB6GfZX4',
                name: 'b. Which one',
                translatedName: 'b. Haeba ho le joalo, sekolo seo ke sefe?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'School',
                      name: 'School',
                      translatedName: 'Sekolo se tloaelehileng'),
                  InputFieldOption(
                      code: 'Vocational',
                      name: 'Vocational',
                      translatedName: 'ekolo sa mosebetsi oa matsoho ')
                ],
              ),
              InputField(
                id: 'OA1dR8a4UWu',
                name:
                    'c. Would you prefer re-enrolment in either school or vocational training?',
                translatedName:
                    'c. Haeba u sa kene sekolo, u ka thabela ho kena sekolo se tloaelehileng kapa sekolo sa mosebetsi oa matsoho?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'EQHcFozjbP0',
                name: 'd. Have you ever had to drop-out then been readmitted?',
                translatedName:
                    'd. Haeba u kena sekolo, na u kile oa se tlohela ka lehare ’me oa amoheloa bocha?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '8_O_H',
            name: '8. Orphanhood',
            translatedName: '8. Bokhutsana',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'Z7PTcgqwCLu',
                name: 'a. Are you an orphan?',
                translatedName: 'a. Na u khutsana?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'FuYyLjYxxkg',
                name: 'b. Are you single or double orphan?',
                translatedName:
                    'b. Haeba ho le joalo, u shoeletsoe ke motsoali a le mong kapa batsoali ba babeli?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                    code: 'Single Orphan(Mother)',
                    name: 'Single Orphan(Mother Died)',
                    translatedName: 'Khutsana Khulu (ntate le mme)',
                  ),
                  InputFieldOption(
                    code: 'Single Orphan(Father)',
                    name: 'Single Orphan(Father Died)',
                    translatedName: 'Khutsana ka Motsoali a le mong (ntate)',
                  ),
                  InputFieldOption(
                    code: 'Double Orphan',
                    name: 'Double Orphan (Father & Mother Died)',
                    translatedName: 'Khutsana Khulu (ntate le mme)',
                  ),
                ],
              ),
              InputField(
                id: 'ODBeRytTLHm',
                name: 'c. Are you living within a child-headed household?',
                translatedName:
                    'c. Na u phela lelapeng leo hloho ea lelapa e leng ngoana?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'OQS3C6pUiWH',
                name:
                    'd. In the past 6 months, has anyone in your household had consistent formal or informal Work that generated money for the household?',
                translatedName:
                    'd. Likhoeling tse 6 tse fetileng, na ho na le e mong oa lelapa ea neng a hiriloe mosebetsing kapa a sebetsa e le moitšokoli?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'uBx2mRzZoRh',
                name:
                    'e. In the past 4 weeks/30 days, was there ever no food to eat of any kind in your house because of lack of resources to get food?',
                translatedName:
                    'e. Libekeng tse 4 tse fetileng/matsatsing a 30 a fetileng, na u kile oa hloka lijo hobane ho ne ho se mokhoa oa ho li reka?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'aIJoCMWUqBs',
                name:
                    'f. In the past 4 weeks/30 days, did you or any household member go to sleep at night hungry because there was not enough food?',
                translatedName:
                    'f. Libekeng tse 4 tse fetileng/matsatsing a 30 a fetileng, na uena kapa e mong oa lelapa o kile a robala a sa ja e le hobane lijo li haella?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'zowQOCZivv8',
                name:
                    'g. In the past 4 weeks/30 days, did you or any household member go a whole day AND night without eating anything at all because there was not enough food?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: '9_O_H',
            name: '9. Orphanhood',
            translatedName: '9. Bokhutsana',
            color: const Color(0xFF258DCC),
            inputFields: [
              InputField(
                id: 'Z7PTcgqwCLu',
                name: 'a. Are you an orphan?',
                translatedName: 'a. Na u khutsana?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'FuYyLjYxxkg',
                name: 'b. Are you single or double orphan?',
                translatedName:
                    'b. Haeba ho le joalo, u shoeletsoe ke motsoali a le mong kapa batsoali ba babeli?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Single Orphan(Mother)',
                      name: 'Single Orphan(Mother Died)',
                      translatedName: 'Khutsana Khulu (ntate le mme)'),
                  InputFieldOption(
                      code: 'Single Orphan(Father)',
                      name: 'Single Orphan(Father Died)',
                      translatedName: 'Khutsana ka Motsoali a le mong (ntate)'),
                  InputFieldOption(
                      code: 'Double Orphan',
                      name: 'Double Orphan (Father & Mother Died)',
                      translatedName: 'Khutsana Khulu (ntate le mme)'),
                ],
              ),
              InputField(
                id: 'ODBeRytTLHm',
                name: 'c. Are you living within a child-headed household?',
                translatedName:
                    'c. Na u phela lelapeng leo hloho ea lelapa e leng ngoana?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'OQS3C6pUiWH',
                name:
                    'd. In the past 6 months, has anyone in your household had consistent formal or informal Work that generated money for the household?',
                translatedName:
                    'd. Likhoeling tse 6 tse fetileng, na ho na le e mong oa lelapa ea neng a hiriloe mosebetsing kapa a sebetsa e le moitšokoli?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'uBx2mRzZoRh',
                name:
                    'e. In the past 4 weeks/30 days, was there ever no food to eat of any kind in your house because of lack of resources to get food?',
                translatedName:
                    'e. Libekeng tse 4 tse fetileng/matsatsing a 30 a fetileng, na u kile oa hloka lijo hobane ho ne ho se mokhoa oa ho li reka?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'aIJoCMWUqBs',
                name:
                    'f. In the past 4 weeks/30 days, did you or any household member go to sleep at night hungry because there was not enough food?',
                translatedName:
                    'f. Libekeng tse 4 tse fetileng/matsatsing a 30 a fetileng, na uena kapa e mong oa lelapa o kile a robala a sa ja e le hobane lijo li haella?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'zowQOCZivv8',
                name:
                    'g. In the past 4 weeks/30 days, did you or any household member go a whole day AND night without eating anything at all because there was not enough food?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
        ],
      ),
      FormSection(
        name: 'Enrollment Criteria',
        translatedName: 'Mekhoa ea ho Ngolisa',
        id: 'E_O_C',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'B4ojlzKypUF',
            name: 'Is Orphanhood (AGYW 10-17 Yrs)',
            valueType: 'TRUE_ONLY',
            isReadOnly: true,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'HJIHPjOf5s1',
            name: 'Alcohol Use',
            translatedName: 'Tsebeliso ea tai',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF258DCC),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'bApA6X6TVvJ',
            name: 'Out of school/Never schooled education/Enrollment',
            translatedName: 'Boemo ba sekolo',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF258DCC),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'yc3BlUIEup3',
            name: 'Experience of violence',
            translatedName: 'Tlhekefetso',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF258DCC),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'p33MrrhsQRz',
            name: 'Transactional Sex',
            translatedName: 'Thobalano u shebile menyetla e itseng',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF258DCC),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'iY67qYnywgS',
            name: 'No or Irregular Condom use',
            translatedName: 'Tsebeliso ea likhohlopo',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF258DCC),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'rh881j2vfvT',
            name: 'Sexually Transmitted Infection (STI) - (past or present)',
            translatedName: 'Mafu a likobo',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF258DCC),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'AZCVLPzD0Vd',
            name: 'High number of sex partners',
            translatedName: 'Palo ea batho bao u etsang thobalano le bona',
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF258DCC),
            isReadOnly: true,
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'E_O_I',
        name: 'Enrollment Instructions',
        translatedName: 'Litaelo tsa ho Ngolisa',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
              id: 'fEHah8SvP35',
              name:
                  'Is she currently residing in a community council/ district you are implementing DREAMS?',
              translatedName:
                  'Na nakong ea joale o lula k’hanseleng/seterekeng seo le kentseng lenane la DREAMS?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'x6VFmJLsqgx',
              name:
                  'Has parent/guardian provided consent for the girl to be enrolled in DREAMS?',
              translatedName:
                  'Bakeng sa baroetsana ba lilemo tse 9 hoisa ho 12, na motsoali/mohlokomeli o fane ka tumello ea hore moroetsana a kene lenaneng la DREAMS?',
              valueType: 'BOOLEAN',
              description: 'Ensure you have documented consent in AGYW file.',
              translatedDescription:
                  'Netefatsa hore o ngotse tumello ea AGYW faeleng.',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'OmOU8n78dg7',
              name: 'Has the AGYW agreed to be enrolled in DREAMS?',
              translatedName:
                  'Na moroetsana/mosali ea mocha lilemong o lumetse ho kena lenaneng la DREAMS?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'L1Z7gkuKtbs',
              name: 'Comments/Notes',
              translatedName: 'Tlhakiso',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      )
    ];
  }
}
