import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class AgywReAssessment {
  static List<String> getMandatoryFields() {
    List<FormSection> mandatorySections = getFormSections()
        .where((FormSection formSection) => [
              'KMFmafOtRev',
              'iBBkSG3VKtu',
              'xqPsOZw0UAI',
              'dORx8fA0CcT',
              'hKEoD0Gg0Jj',
              'OfGOoEeSIP6',
              'jaSu6ravuz1',
              'ypHSdTlJvW4',
              'lMnQEQjzKJu',
              'uZQD4Hwp3j0',
            ].contains(formSection.id))
        .toList();
    return [
      ...FormUtil.getFormFieldIds(mandatorySections),
      'zO2wRePjGvO',
      'pVEjKAzj7mA',
      'FMT17u0pJ7o',
      'QxYCweHXR8r',
      'BaG3QTzCdrm',
      'Tl8yAujLY2T',
      'GXb0yN9WSvZ',
      'rfwvxFDyLnN',
      'jeb1PlPmJHD',
      'dAlwALiZxnT',
      'V8ziLwhPA05',
      'K0r3yA6oi3F',
      'dvT9e6eeNsE',
      'mZXrTDoaBqp',
      'B1hsntcuB5q',
      'FGiKknNPkbh',
      'pDKOAGB7LKD',
      'WMjfK2Fl7d6'
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        id: 'dxIpJ7vavw9',
        name: 'Demographic Information',
        translatedName: 'Litaba tsa Boitsebiso ba motho',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'memberOf',
            name: 'Have you Been a member of',
            translatedName: 'Na u bile setho sa',
            valueType: 'CHECK_BOX',
            options: [
              InputFieldOption(
                  code: 'q1jZgkwYAM9',
                  name: 'DREAMS intervention',
                  translatedName: "Lits'ebeletso tsa DREAMS"),
              InputFieldOption(
                code: 'mIUXayg4hsq',
                name: 'Social Assets building Intervention',
              ),
              InputFieldOption(
                code: 'XI4W7oEEo14',
                name: 'SILC DREAMS intervention',
              ),
              InputFieldOption(
                code: 'rPAJryvtskO',
                name: 'Condom promotion and provision DREAMS intervention',
              ),
              InputFieldOption(
                code: 'Dwgz4LQloGE',
                name: 'Savings Group DREAMS intervention',
              ),
              InputFieldOption(
                code: 'iBeBiNpPjC3',
                name: 'Steeping Stone DREAMS intervention',
              ),
              InputFieldOption(
                code: 'a1Acoavv0vj',
                name: 'Contraceptive Mix DREAMS intervention',
              ),
              InputFieldOption(
                code: 'qnFJEmtIg6e',
                name: 'HIV and Violence Prevention (LBSE) DREAMS intervention',
              ),
              InputFieldOption(
                code: 'SEXfnyg7gcM',
                name: 'HTS DREAMS intervention',
              ),
              InputFieldOption(
                code: 'Lnq1x7QkSTJ',
                name: 'PrEP DREAMS intervention',
              ),
              InputFieldOption(
                code: 'HJZQ3D0uKLX',
                name: 'Post-Violence Care DREAMS intervention',
              ),
              InputFieldOption(
                code: 'jCWdvWGacDP',
                name: 'HIV Risk Assessment Messaging DREAMS intervention',
              ),
              InputFieldOption(
                code: 'oVHVJe527OC',
                name: 'VMMC DREAMS intervention',
              ),
              InputFieldOption(
                code: 'bM8W0vcRtbK',
                name: 'ART DREAMS intervention',
              ),
            ],
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'dFTGCWSQDd2',
        name: 'Household Information',
        translatedName: 'Boitsebiso ba lelapa',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'Tt8LW1HTLlC',
            name: 'Name of parent/caregiver',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'GRrIU47nuiR',
            name:
                'If the AGYW comes from child headed family, name of Sister/Brother',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'xEfuZ53tYsA',
            name:
                'Phone number of parent/caregiver/heads of the family if available',
            valueType: 'PHONE_NUMBER',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'KLsHjJp9pxo',
            name: 'Relationship to caregiver',
            translatedName: 'Kamano ea ngoana le mohlokomeli',
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
                code: 'Spouse',
                name: 'Spouse',
                translatedName: 'Molekane',
              ),
              InputFieldOption(
                code: 'Other',
                name: 'Other',
                translatedName: 'E mong',
              ),
            ],
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'KMFmafOtRev',
        name: 'Multiple sexual partners (in the last year)',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'XEZ1waTp18L',
            name: 'Have you ever had sex?',
            translatedName: 'Na u kile ua etsa thobalano?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'c9CzrUtn7dh',
            name: 'How old were you when you had sex for the first time?',
            translatedName:
                'U ne u le lilemo tse kae ha u qala ho etsa thobalano?',
            valueType: 'TEXT',
            options: [
              InputFieldOption(
                code: '9-14',
                name: '9-14',
              ),
              InputFieldOption(
                code: '15-19',
                name: '15-19',
              ),
              InputFieldOption(
                code: '20-24',
                name: '20-24',
              ),
            ],
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'm1pw5a6ptnD',
            name: 'Do you have any sexual partner?',
            translatedName: 'Na ho na le motho eo u etsang thobalano le eena?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'O9ZQS4PVdEO',
            name: 'Are you involved in any sexual activity?',
            translatedName: 'Na u etsa thobalano?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'cLtX7aavyWx',
            name:
                'How many sexual partners have you had in the last 12 months?',
            translatedName:
                'U entse thobalano le batho ba bakae ka palo likhoeling tse 12 tse fetileng?',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'iBBkSG3VKtu',
        name: 'History of pregnancy',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'e59e3DpsrfO',
            name: 'Have you ever been or are you currently pregnant?',
            translatedName:
                'Na u kile oa ima nakong e fetileng kapa na u mokhachane nakong ea joale?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'w6aNdM4gwi3',
            name: 'Do you have any children?',
            translatedName: 'Na u na le bana?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'q5CGrIpgap8',
            name: 'How many children do you have?',
            translatedName: 'Bana ba hao ba bakae ka palo?',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'xqPsOZw0UAI',
        name: 'STI (diagnosed or treated)',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'WHRJJvbbJV2',
            name: 'Have you ever been diagnosed with any STIs?',
            translatedName:
                'Na u kile oa fumanoa u e-na le tšoaetso ea mafu a likobo?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'TW5FP6ua1MY',
            name: 'If yes, were they treated',
            translatedName:
                'Haeba karabo e le “E”, na mafu ao a ile a alafuoa?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'dORx8fA0CcT',
        name: 'No or Irregular condom use',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'MrxmSdFauSY',
            name: 'Do you use condom regularly?',
            translatedName: 'Na u sebelisa likhohlopo khafetsa?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'X0xtgjkUJaK',
            name: 'Do you know where to get condoms?',
            translatedName: 'Na u tseba moo u ka fumanang likhohlopo?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'BnzM3YGOQRC',
            name: 'Did you use a condom during your last sexual activity?',
            translatedName:
                ' Na u ile ua sebelisa khohlopo lekhetlong la ho qetela ha u ne u etsa thobalano?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ILSjS6lDvGx',
            name: 'Are you currently taking any contraceptives?',
            translatedName: 'Na, nakong ea joale, u sebelisa lithibela-pelehi?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'hKEoD0Gg0Jj',
        name: 'Experience of sexual Violence (lifetime)',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'MyWzaD8N5Mw',
            name: 'Have you ever experienced sexual violence (lifetime)?',
            translatedName:
                'Na u kile oa hlekefetsoa ka motabo bophelong ba hao?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'FEFdUzvNhgt',
            name:
                'Did you ever have someone touch you on your private parts without your concern?',
            translatedName:
                'Na ho kile ha eba le motho ea u phopholetsang ka bothong ntle le tumello ea hao?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'z8xvZbc9VcE',
            name: 'Did you ever have forced sex?',
            translatedName: 'Na u kile ua etsa thobalano e qobeletsoeng?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ViUk8fZVrVG',
            name:
                'Did you ever have forced unprotected sex while you wanted protected sex?',
            translatedName:
                'Na u kile ua qobelloa ho etsa thobalano e sa sireletsoang ha uena u ne u batla e sirelelitsoeng?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'OfGOoEeSIP6',
        name: 'Experience of physical or emotional violence',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'L8pjmifYu5v',
            name:
                'Experience of physical or emotional violence (within the last year)',
            translatedName:
                'Na u kile oa hlekefetsoa ’meleng kapa maikutlong (selemong se fetileng)',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'YTYxoL4uvd2',
            name: 'Has your partner ever hit or hurt you in any way?',
            translatedName:
                'Na mohlankana/monna oa hao o kile a u otla kapa ho u utloisa bohloko maikutlong',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'XThk8GV71oH',
            name: 'Has your partner ever threatened to hurt you?',
            translatedName:
                'Na mohlankana/monna oa hao o kile a u tšosa ka hore o tla u ntša kotsi?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ldEyTeF48Bn',
            name:
                'Do you generally feel unsafe in your current relationship with your partner?',
            translatedName:
                'Na u ikutloa u sa sireletseha likamanong tsa hao le mohlankana/monna oa hao nakong ea joale?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'NMdPGZbGdrJ',
            name: 'Do/did you feel afraid of your partner in any ways',
            translatedName:
                'Na u utloa u e-na le tšabo kapa u kile oa utloa u e-na le tšabo ea mohlankana/monna oa hao?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
          id: 'jaSu6ravuz1',
          name:
              'Transactional sex (including staying in a relationship for material or financial support)',
          color: const Color(0xFF258DCC),
          inputFields: [
            InputField(
              id: 'gN37trYWyOh',
              name:
                  'Do you engage in sexual activities in exchange for money or any material things (including staying in a relationship for material or financial support)',
              translatedName:
                  'Na u kena thobalanong u shebile menyetla ea chelete kapa lintho tse ling tse molemo (ho kenyeletsa ho ba le likamano ka lebaka la tsehetso ea lichelete kapa lintho tse ling)?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
          ]),
      FormSection(
          id: 'ypHSdTlJvW4',
          name: 'Alcohol Use',
          color: const Color(0xFF258DCC),
          inputFields: [
            InputField(
              id: 'a1pS345KP53',
              name: 'have you ever or are you currently using alcohol?',
              translatedName:
                  'Na u kile oa noa joala nakong e fetileng kapa u noa joala nakong ea joale?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'EniWU07LqXa',
              name:
                  'During the past three months, has your use of alcohol led to health, social, legal or financial problems?',
              translatedName:
                  'Likhoeling tse 3 tse fetileng, na ho noa joala ho u baketse mathata bophelong, likamanong le batho ba bang, litlolong tsa molao, kapa cheleteng?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'DkstiOjXlSh',
              name: 'Do you ever forget things you did while using alcohol?',
              translatedName:
                  'Na u ke u iphumane u sa hopole lintho tseo u li entseng nakong eo u neng u noele joala?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
          ]),
      FormSection(
        id: 'lMnQEQjzKJu',
        name: 'Out of School',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'TWvKsmKyCSc',
            name: 'Are you currently enrolled in school or a vocation program?',
            translatedName:
                'Na u kena sekolo se tloaelehileng kapa sekolo sa mosebetsi oa matsoho?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'cv8RKCPOOAo',
            name: 'Which one you are enrolled in?',
            translatedName: 'O ngolisitse ho efe?',
            valueType: 'TEXT',
            options: [
              InputFieldOption(
                code: 'School',
                name: 'School',
                translatedName: 'Sekolo se tloaelehileng',
              ),
              InputFieldOption(
                  code: 'Vocational Training',
                  name: 'Vocational Training',
                  translatedName: 'Koetliso ea mosebetsi oa matsoho'),
            ],
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'xj9NOs6FeZw',
            name:
                'If not enrolled in either, would you prefer re-enrolment in either school or vocational training?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'LPahlcvriGs',
            name:
                'If you are in school, have you ever had to drop-out then been readmitted?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'uZQD4Hwp3j0',
        name: 'Orphanhood',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'G1FpSgvl1kK',
            name: 'Are you an orphan?',
            translatedName: 'Na u khutsana?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'Qxb7zzJ98HI',
            name: 'If yes are you single or double orphan?',
            valueType: 'TEXT',
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
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'iPFrMuPeKHK',
            name: 'Are you living within a child-headed household?',
            translatedName:
                'Na u phela lelapeng leo hloho ea lelapa e leng ngoana?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'GYA7lKjoPKC',
            name:
                'In the past 6 months, has anyone in your household had consistent formal or informal Work that generated money for the household?',
            translatedName:
                'Likhoeling tse 6 tse fetileng, na ho na le e mong oa lelapa ea neng a hiriloe mosebetsing kapa a sebetsa e le moitšokoli?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'yFZPXKzaf9t',
            name:
                'In the past 4 weeks/30 days, was there ever no food to eat of any kind in your house because of lack of resources to get food?',
            translatedName:
                'Libekeng tse 4 tse fetileng/matsatsing a 30 a fetileng, na u kile oa hloka lijo hobane ho ne ho se mokhoa oa ho li reka?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'gUvTWkffP99',
            name:
                'In the past 4 weeks/30 days, did you or any household member go to sleep at night hungry because there was not enough food?',
            translatedName:
                'Libekeng tse 4 tse fetileng/matsatsing a 30 a fetileng, na uena kapa e mong oa lelapa o kile a robala a sa ja e le hobane lijo li haella?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'GqOBk3DGpby',
            name:
                'In the past 4 weeks/30 days, did you or any household member go a whole day AND night without eating anything at all because there was not enough food?',
            translatedName:
                'In the past 4 weeks/30 days, did you or any household member go a whole day AND night without eating anything at all because there was not enough food?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'VXNq6q3vHH8',
        name: 'Enrollment Criteria',
        translatedName: 'Mekhoa ea ho Ngolisa',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'D977px8ADd8',
            name: 'Orphanhood (AGYW 10-17 Yrs)',
            valueType: 'TRUE_ONLY',
            isReadOnly: true,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'RPqwCtEFza8',
            name: 'Alcohol Use',
            translatedName: 'Tsebeliso ea tai',
            valueType: 'TRUE_ONLY',
            isReadOnly: true,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'K9nfVNC9wQo',
            name: 'Out of school/Never schooled education/Enrollment',
            translatedName: 'Boemo ba sekolo',
            valueType: 'TRUE_ONLY',
            isReadOnly: true,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'Xij6JPqNHgw',
            name: 'Experience of violence',
            translatedName: 'Tlhekefetso',
            valueType: 'TRUE_ONLY',
            isReadOnly: true,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'pEZU4tCPJ7m',
            name: 'Transactional Sex',
            translatedName: 'Thobalano u shebile menyetla e itseng',
            valueType: 'TRUE_ONLY',
            isReadOnly: true,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'O0rgyBGiBpW',
            name: 'No or Irregular Condom use',
            translatedName: 'Tsebeliso ea likhohlopo',
            valueType: 'TRUE_ONLY',
            isReadOnly: true,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'LmAeo9S1BFX',
            name: 'Sexually Transmitted Infection (STI) - (past or present)',
            translatedName: 'Mafu a likobo',
            valueType: 'TRUE_ONLY',
            isReadOnly: true,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'xqMDWAQ0aST',
            name: 'High number of sex partners',
            translatedName: 'Palo ea batho bao u etsang thobalano le bona',
            valueType: 'TRUE_ONLY',
            isReadOnly: true,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'RqpY6SQhRs2',
        name: 'Enrollment Instructions',
        translatedName: 'Litaelo tsa ho Ngolisa',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'n0w2Bh54Dci',
            name:
                'Is she currently residing in a community council/ district you are implementing DREAMS',
            translatedName:
                'Na nakong ea joale o lula k’hanseleng/seterekeng seo le kentseng lenane la DREAMS?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'hXRLho0OJCR',
            name: 'Has the AGYW agreed to be enrolled in DREAMS',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'CJI1lhAmgyd',
            name: 'Comments',
            translatedName: 'Tlhakiso',
            valueType: 'LONG_TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'JD1OLCJ8FMU',
        name: 'Enrollment Instructions - Enrollment Form',
        translatedName: 'Litaelo tsa ho Ngolisa - Foromo ea ngoliso',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'pVlQ4UoW16M',
            name: 'Is the AGYW aged 9-24 years old',
            translatedName:
                'Na moroetsana/mosali ea mocha lilemong o lipakeng tsa lilemo tse 9 le 24?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'vg7BIorWZ90',
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
            id: 'PnAde2Zsx8w',
            name: 'Other age verification document used',
            translatedName: 'E meng (hlalosa)',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'UT0q0nqXFKJ',
            name: 'Which community council and district',
            translatedName:
                'Ha karabo e le “E”, ke k’hanseleng/seterekeng sefe?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'K6Ghmv3XrAS',
        name: 'Enrollment Module 1: Individual and Household Information',
        translatedName: 'KAROLO EA 1: Lintlha tsa motho ka mong le lelapa labo',
        description:
            'INTERVIEWER SAY:  This section of the enrolment form asks for details about your household in general.  After this we will move on to other topics.',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE: Karolo ena, e botsa ka lelapa leno. Kamora mona re tla fetela lintlheng tse ling.',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'O6bAxsVCn8d',
            name: 'Who is the head of your household?',
            translatedName: 'Hloho ea lelapa leno/la hao ke mang?',
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
            id: 'uUOx5MjUSYJ',
            name: 'How old is the head of the household?',
            translatedName: 'Hloho ea lelapa o lilemo li kae?',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ac0uJduZGTC',
            name: 'Is your father alive?',
            translatedName: 'Na ntate oa hao o ntse a phela?',
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
            id: 'OK56Mru7Hwp',
            name: 'Is your mother alive?',
            translatedName: 'Na ’m’e oa hao o ntse a phela?',
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
            id: 'uYB9RSDWHyL',
            name:
                'Are any of your parents/guardians chronically ill (including HIV)?',
            translatedName:
                'Na batsoali/bahlokomeli ba hao ke batho ba kulang (ho kenyeletsa le tšoaetso ea HIV)?',
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
            id: 'f5wg01V2wY4',
            name: 'What is the main material on the floor of your house?',
            translatedName: 'Ka lapeng ka heno, ho aliloe eng fatše?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Earth or Mud or Dung or Sand',
                  name: 'Earth or Mud or Dung or Sand',
                  translatedName: 'Mobu'),
              InputFieldOption(
                  code: 'Corrugated iron sheet',
                  name: 'Corrugated iron sheet',
                  translatedName: 'Lesenke'),
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
            id: 'SozA4kZ9ugu',
            name: 'What is the main material on the roof of your house?',
            translatedName: 'Ntlo eno e ruletsoe ka eng?',
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
            id: 'OZYqRt89QMt',
            name: 'What is the main material on the walls of your house?',
            translatedName: 'Mabota a ntlo eno a entsoe ka eng?',
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
            id: 'vWBfxLzrJ2u',
            name:
                'What is the main source of drinking water for members of your household?',
            translatedName: 'Le sebelisa metsi a tsoang kae?',
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
              id: 'JRnOh92xlFB',
              name:
                  'In the past 4 weeks, was there any day that you went without food in your household for a full day because of lack of resources?',
              translatedName:
                  'Libekeng tse 4 tse fetileng, na u kile oa robala ka tlala hobane ho se na mokhoa oa ho reka lijo?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'w5d5ThKRBC6',
            name: 'For how many days did this happen in the last 4 weeks?',
            translatedName:
                'See se etsahetse makhetlo a makae libekeng tse 4 tse fetileng?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Rarely',
                name: 'Rarely (1-2 days)',
                translatedName: 'Ha se hangata (letsatsi kapa a 2)',
              ),
              InputFieldOption(
                code: 'Sometimes',
                name: 'Sometimes (3-10 days)',
                translatedName:
                    'Ka linako tse ling (matsatsi a 3 hoisa ho a 10)',
              ),
              InputFieldOption(
                code: 'Often',
                name: 'Often (more than 10 days)',
                translatedName: 'Hangata (ho feta matsatsi a 10)',
              )
            ],
          ),
          InputField(
            id: 'IH2D6jn62eY',
            name: 'Do you have any form of disability?',
            translatedName: 'Na u phela le bokooa?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'RrKSLZXhIJJ',
            name: 'State disability type',
            translatedName: 'Hlalosa mofuta oa bokooa ba hao',
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
            id: 'nQc2oojGlPQ',
            name:
                'Female children below 18 years of age currently living in household',
            translatedName:
                'Palo ea banana ba lilelemo li ka tlase ho 18 ba phelang ka hara lelapa',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'P5m6qvXCUP7',
            name:
                'Male children below 18 years of age currently living in household',
            translatedName:
                'Palo ea bashanyana ba lilelemo li ka tlase ho 18 ba phelang ka hara lelapa',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'FyvMYV4WZH0',
            name:
                'Female aged 18 years and above currently living in household',
            translatedName:
                'Palo ea basali ba lilelemo li ka holimo ho 18 ba phelang ka hara lelapa',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'Ya1HJPZ5n38',
            name: 'Male aged 18 years and above currently living in household',
            translatedName:
                'Palo ea banna ba lilelemo li ka holimo ho 18 ba phelang ka hara lelapa',
            valueType: 'INTEGER_ZERO_OR_POSITIVE',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ohUySrvz9JD',
            name: 'Have you ever been enrolled in a cash transfer program',
            translatedName:
                'Na u kile oa kena lenaneng la batho ba thusoang/phalleloang ka lichelete?',
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
            id: 'nQrhKlq91sr',
            name: 'Are you currently enrolled in any cash transfer programs?',
            translatedName:
                'Na nakong ea joale u lenaneng la batho ba thusoang/phalleloang ka lichelete?',
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
        ],
      ),
      FormSection(
        id: 'p7qOOKqVLYY',
        name: 'Enrollment Module 2: Education & Employment',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'jO5PbtUYCue',
            name: 'Do you currently go to school?',
            isReadOnly: true,
            translatedName: 'Na nakong ea joale u kena sekolo?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'gk71zb8ha9r',
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
            id: 'xoL98idcYr3',
            name: 'What is the name of the school?',
            translatedName: 'Lebitso la sekolo seo ke mang?',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'uuQMZpqNURW',
            name: 'What level of school are you currently in?',
            translatedName: 'Nakong ea joale, u boemong bofe ba sekolo?',
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
            id: 'k9bRQv9sF8j',
            name: 'Specify other school level',
            translatedName: 'Sekolo se seng (hlalosa)',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'SYoIimrc8A9',
            name: 'Which class are you currently enrolled in?',
            translatedName: 'Sehlopha',
            valueType: 'NUMBER',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'VJitBCt6qZ3',
            name: 'Which form are you currently enrolled in?',
            translatedName: 'Sehlopha',
            valueType: 'NUMBER',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'support_options',
            name:
                'Other than from your parent(s)/guardian(s), are you also getting support towards your current education from another source? (Tick all that apply)',
            translatedName:
                'Ntle le batsoali/bahlokomeli ba hao, na ho na le lithuso tseo u li fumanang mehloling e meng bakeng sa thuto? (Tšoaea tsohle tseo a li boletseng)',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'YFzwKihyOJj',
                  name: 'Government bursary',
                  translatedName: 'Litlhapiso tsa ’Muso'),
              InputFieldOption(
                  code: 'ny0gQLwJpUR',
                  name: 'NGO',
                  translatedName: 'Mekhatlo e ikemetseng'),
              InputFieldOption(
                  code: 'dgQuCpH07BZ',
                  name: 'Faith-based institutions (Church, Mosque etc.)',
                  translatedName: 'Mekhatlo ea likereke'),
              InputFieldOption(
                  code: 'Q7M9UPF99Gg',
                  name: 'Relatives (excludes parent/guardian)',
                  translatedName:
                      'Batho bao u amanang le bona (ntle le motsoali/mohlokomeli)'),
              InputFieldOption(
                  code: 'uT3Br4Q6RTv',
                  name: 'None (no additional support)',
                  translatedName: 'Ha ho lithuso tse ling'),
              InputFieldOption(
                  code: 'hG7Us56lmeI',
                  name: 'Other sources',
                  translatedName: 'Lithuso tse ling')
            ],
          ),
          InputField(
            id: 'BDz4rlupffk',
            name: 'Do you have any savings?',
            translatedName: 'Na u na le chelete e polokelong?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'eyNmhYeAipl',
            name: 'Where do you keep your savings?',
            translatedName: 'U boloka chelete ea hao kae?',
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
                  code: 'Other',
                  name: 'Other',
                  translatedName: 'Libakeng tse ling')
            ],
          ),
          InputField(
            id: 'wish_checkbox',
            name: 'Given a chance, what would you wish to do with your life?',
            translatedName:
                'Ha u ka fuoa monyetla, u ka lakatsa ho etsa eng ka bophelo ba hao?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'aFZkr03xq2k',
                  name: 'Pursue a course',
                  translatedName: 'Ho kena sekolo'),
              InputFieldOption(
                  code: 'yj9FzSiDOeS',
                  name: 'Start a business',
                  translatedName: 'Ho qala khoebo'),
              InputFieldOption(
                  code: 'IE9XxSl8NKb',
                  name: 'Go back to school',
                  translatedName: 'Ho khutlela sekolong'),
              InputFieldOption(
                  code: 'E39kRi6d1aY',
                  name: 'Get married',
                  translatedName: 'Ho nyaloa')
            ],
          ),
          InputField(
            id: 'u9lJfbuMkoo',
            name: 'Other things you would do?',
            translatedName: 'Tse ling (hlalosa)',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'pmI8L6lIqZ8',
            name: 'What is the main reason why you are not going to school?',
            translatedName:
                'Lebaka la mantlha le etsang hore u se kene sekolo ke lefe?',
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
            id: 'DPizVxMnxgZ',
            name: 'What is your current main source of income?',
            translatedName: 'U fumana chelete ea hao mehloling efe?',
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
            id: 'TWRWhT74Isb',
            name: 'When was the last time you went to school?',
            translatedName: 'U qetetse ho kena sekolo neng?',
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
        ],
      ),
      FormSection(
        id: 'KWECITQpelI',
        name: 'Enrollment Module 3: HIV Testing',
        translatedName: 'KAROLO EA 3: Tlhahlobo ea HIV',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'vsusuuCpGYV',
            name: 'Have you ever been tested for HIV?',
            translatedName: 'Na u kile oa hlahloba HIV?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'xmuhHqgQyLN',
            name: 'When/how long ago was your last HIV test?',
            translatedName: 'Ke neng ha u qetela ho hlahloba HIVt?',
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
            id: 'UJX6rtdju0j',
            name:
                'If you don’t mind telling me, what were the results of your last HIV test?',
            translatedName:
                'Haeba ha u na bothata ba ho mpolella, sephetho sa hao sa tlhahlobo ea ho qetela se ne se reng?',
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
              id: 'k1tvxyFJxQH',
              name:
                  'Are you currently going to clinic/facility to seek HIV care?',
              translatedName:
                  'Haeba u na le tšoaetso ea HIV, na u ntse u etela tleleniking ho fumana litšebeletso tsa HIV?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'L0CebuGBmGC',
            name: 'At which facility are you currently seeking HIV care?',
            translatedName:
                'Nakong ea joale ke tleleniki efe moo u fumanang litšebeletso tsa HIV?',
            valueType: 'ORGANISATION_UNIT',
            allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
            showCountryLevelTree: true,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'IX5DPgzAmaG',
            name:
                'What is the main reason why you are not going to a clinic to seek HIV care?',
            translatedName:
                'Lebaka la hao la mantlha ke lefe le etsang hore u se ke oa batla litšebeletso tsa HIV?',
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
            id: 'never_tested_hiv',
            name: 'Never been tested for HIV because',
            translatedName: 'Ke hobaneng u e-so etse tlhahlobo ea HIV?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'B8PRxprZkaR',
                  name: 'No knowledge about HIV tests',
                  translatedName: 'Ha ke tsebe letho ka litlhahlobo tsa HIV'),
              InputFieldOption(
                  code: 'TJd7YYN1jeH',
                  name: 'Don’t know where to get one',
                  translatedName: 'Ha ke tsebe moo nka hlahlobang HIV'),
              InputFieldOption(
                  code: 'IzfGgfP8lNH',
                  name: 'Can’t afford it',
                  translatedName: 'Ha ke na chelete'),
              InputFieldOption(
                  code: 'UUEeO12S3Q5',
                  name: 'Transport costs to the site are too much',
                  translatedName: 'Litjeo tsa ho ea tlhahlobong li boima'),
              InputFieldOption(
                  code: 'sQ5q1EmZq4V',
                  name: 'Testing facility is too far away',
                  translatedName: 'Setsi sa tlhahlobo se hole haholo'),
              InputFieldOption(
                  code: 'z5Rcs0hwM3f',
                  name: 'Afraid others will know about the test/ test results',
                  translatedName:
                      'Ke tšaba hore batho ba tla tseba ka tlhahlobo ea ka/sephetho sa ka'),
              InputFieldOption(
                  code: 'GyqA4M4s9Jy',
                  name: 'Don’t need to test/ low risk',
                  translatedName:
                      'Ha ke hloke ho hlahloba/monyetla oa hore nka fumana tšoaetso o fokola haholo'),
              InputFieldOption(
                  code: 'I27rCOmCnlM',
                  name: 'Afraid to know if I have HIV',
                  translatedName:
                      'Ke tšaba ho tseba hore ke na le tšoaetso ea HIV'),
              InputFieldOption(
                  code: 'LkAVZJku1bf',
                  name: 'Too busy to go',
                  translatedName: 'Ha ke na nako ea ho ea tlhahlobong ea HIV')
            ],
          ),
          InputField(
            id: 'W9n87DM5ZKh',
            name: 'Other reason',
            translatedName: 'Mabaka a mang (a hlalose)',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'qMElkxF1Xog',
            name:
                '308. Do you know of a place(s) where people can get tested for HIV?',
            translatedName:
                '308. Na u tseba sebaka kapa libaka tseo batho ba ka hlahlobang HIV ho tsona?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'MlNbBruL17G',
        name: 'Enrollment Module 4: Sexual Activity',
        translatedName: 'KAROLO EA 4: Thobalano',
        description:
            'INTERVIEWER SAY: Now I will ask you some questions about your sexual activity in order to gain a better understanding of some life issues.  Let me reassure you that your answers are completely confidential. If you are uncomfortable with any questions, please let me know. Remember, there is no right or wrong answer.',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE: Joale ke tla u botsa lipotso ka litaba tsa hao tsa thobalano, e le ho fumana kutloisiso e batsi ka lintlha tsa bohlokoa bophelong ba hao. Ke u tiisetsa hore likarabo tsa hao li tla boloka e le lekunutu. Haeba lipotso tsa ka li u beha tsietsing, mpolelle. Hopola hore ha ho karabo e nepahetseng kapa a fosahetseng.',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'Wqgkof0jNzH',
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
            id: 'fG59JaLFHNQ',
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
              id: 'AHn104dXclJ',
              name: 'Do you know your last sexual partner HIV status?',
              translatedName:
                  'Na u tseba boemo ba tsoaetso ba motho oa ho qetela eo u bileng le likamano tsa thobalano le eena?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'ZkjT5pJEiyH',
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
            id: 'KAIJaPO9LfY',
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
            id: 'WEOuXrGNGxp',
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
            id: 'kALqgxKrQX9',
            name: 'Do you know your second to last sexual partner HIV status?',
            translatedName:
                'Na u tseba boemo ba tsoaetso ba motho oa ho qetela eo u bileng le likamano tsa thobalano le eena?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'tgmprwWTsx9',
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
            id: 'l4PwsWSgA9F',
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
            id: 'tFxXnETOJp2',
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
            id: 'x1zkFb7y9WF',
            name: 'Do you know your third to last sexual partner HIV status?',
            translatedName:
                'Na u tseba boemo ba tsoaetso ba motho oa boraro oa ho qetela eo u bileng le likamano tsa thobalano le eena?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'Fi4TMaR41o0',
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
              id: 'lEOCRUCFCc2',
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
        id: 'gFFR7MS35z6',
        name: 'Enrollment Module 5: Reproductive Health',
        translatedName: 'KAROLO EA 5: Bophelo bo botle litabeng tsa thari',
        description:
            'INTERVIEWER SAY: Now I would like us to move on to some questions on your reproductive health. ',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE: Joale ke kopa ho u botsa lipotso mabapi le bophelo bo botle litabeng tsa thari.',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'edK6Y5C1VHN',
            name: 'Do you have biological children?',
            translatedName: 'Na u na le bana ba tsoetsoeng ke uena?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'iNDDGvgNHwb',
            name: 'How many biological children do you have?',
            translatedName: 'U tsoetse bana ba bakae ka palo?',
            valueType: 'NUMBER',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'nSh4v0iBjKW',
            name: 'Are you currently pregnant?',
            translatedName: 'Na u mokhachane nakong ea joale?',
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
            id: 'fINHdGnfAMA',
            name: 'Are you attending an ANC clinic for this pregnancy?',
            translatedName:
                'Na u tsamaea tleleniking ea bakhachane nakong ea joale?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'LHf5EZmkZ5q',
            name:
                'Which clinic/facility are you currently seeking ANC services?',
            translatedName:
                'U tsamaea tleleniking efe ho fumana litšebeletso tsa bokhachane?',
            valueType: 'ORGANISATION_UNIT',
            allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
            inputColor: const Color(0xFF258DCC),
            showCountryLevelTree: true,
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'VTCiGG3UqI0',
              name: 'Are you aware of any family planning methods?',
              translatedName: 'Na u tseba letho ka mefuta ea lithibela-pelehi?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'known_family_planning',
            name: 'What family planning methods do you know?',
            translatedName: 'Ke mefuta efe ea lithibela-pelehi eo u e tsebang?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'CZcaiGJsBiZ',
                  name: 'Pills',
                  translatedName: 'Lipilisi'),
              InputFieldOption(
                  code: 'BbAer5joCHv',
                  name: 'Injections',
                  translatedName: 'Liente'),
              InputFieldOption(
                  code: 'S3y6E3zHKOI',
                  name: 'Implants',
                  translatedName: 'Lithutsoana'),
              InputFieldOption(
                  code: 'liDqlsV4OmD',
                  name: 'IUCD (Coil)',
                  translatedName: 'Sekhoqetsane'),
              InputFieldOption(
                  code: 'ePkOvv6DUq9',
                  name: 'Condom',
                  translatedName: 'Likhohlopo'),
              InputFieldOption(
                  code: 'smu54AunmQw',
                  name: 'Permanent (Tubal Ligation)',
                  translatedName: 'Ho koaloa'),
            ],
          ),
          InputField(
            id: 'RvLNRYLMdLL',
            name: 'Other family planning method you know',
            translatedName: 'Tse ling (li hlalose)',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'csZyQAY9BNH',
            name: 'Are you currently using any modern family planning method?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'used_family_planning',
              name: 'Which family planning methods do you use?',
              translatedName: 'Na nakong ea joale u sebelisa lithibela-pelehi?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                    code: 'qliQfYk36Qe',
                    name: 'Pills',
                    translatedName: 'Lipilisi'),
                InputFieldOption(
                    code: 'OHMTDYj2AsD',
                    name: 'Injections',
                    translatedName: 'Liente'),
                InputFieldOption(
                    code: 'ZsKGtSMwYqb',
                    name: 'Implants',
                    translatedName: 'Lithutsoana'),
                InputFieldOption(
                    code: 'dnyQhtEZluG',
                    name: 'IUCD (Coil)',
                    translatedName: 'Sekhoqetsane'),
                InputFieldOption(
                    code: 'MFVj9vKwKAe',
                    name: 'Condoms',
                    translatedName: 'Likhohlopo'),
                InputFieldOption(
                    code: 'bcLRyBt45xX',
                    name: 'Permanent (Tubal Ligation)',
                    translatedName: 'Ho koaloa'),
              ]),
          InputField(
            id: 'gFotAVdHTNU',
            name: 'Other family planning methods currently using',
            translatedName: 'Tse ling (li hlalose)',
            valueType: 'TEXT',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'v6xma7NoXJf',
              name:
                  'What’s the main reason for not using any family planning method?',
              translatedName:
                  'Lebaka la hao la mantlha la ho se sebelise lithibela-pelehi ke lefe?',
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
        ],
      ),
      FormSection(
        id: 'YeGKmvgU8gQ',
        name: 'Enrollment Module 6: Gender-based Violence',
        translatedName: 'Karolo ea 6: Tlhekefetso ea basali GBV',
        description:
            'INTERVIEWER SAY:  The next section goes over a few questions about your experiences with violence.  Now I will ask you some questions about your sexual activity in order to gain a better understanding of some life issues. Let me reassure you that your answers are completely confidential. If you are uncomfortable with any questions, please let me know. Remember, there is no right or wrong answer. \nHas the following happend to you with any man (e.g boyfriend/spouse/family member/neighbour etc?) \nEver and if Yes, has it happend in the past 3 months?',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE:  Karolo ena e latelang ea lipotso e holima seo u se tsebang ka tlhekefetso. Ke tla u botsa lipotso ka litaba tsa hao tse amanang le thobalano e le ho utloisisa lintlha tse ling tse amanang le bophelo. Ke batla ho u tiisetsa hore likarabo tsa hao li tla bolokoa e le lekunutu. Haeba u utloa lipotso tsa ka li u beha tsietsing, u mpolelle. Hopola hore ha ho karabo e nepahetseng kapa a fosahetseng. \nNa liketsahalo tse latelang li kile tsa etsoa ho uena ke motho oa monna (mohlala: mohlankana/monna/ oa hao, setho sa lelapa, kapa mohaisane joalo-joalo?)',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'zO2wRePjGvO',
            name:
                'Has any man ever said or did something to humiliate you in front of others?',
            translatedName:
                'Na o kile a bua kapa a etsa ntho e u nyenyefatsang mahlong a batho ba bang?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'pVEjKAzj7mA',
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
              id: 'FMT17u0pJ7o',
              name:
                  'Has any man threatened to hurt or harm you or someone you care about?',
              translatedName:
                  'Na o kile a u tšosa ka hore o tla u ntša kotsi kapa a ntše motho e mong eo u mo ratang kotsi?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'QxYCweHXR8r',
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
            id: 'BaG3QTzCdrm',
            name: 'Any man insulted or made you feel bad about yourself?',
            translatedName:
                'Na o kile a u rohaka kapa ho etsa hore u ikutloe u le motho ea mobe?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'Tl8yAujLY2T',
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
            id: 'jeb1PlPmJHD',
            name: 'Any man threatened to take away your economic livelihood?',
            translatedName:
                'Na o kile a u tšosa ka hore o tla u amoha mokhoa oa ho iphelisa?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'dAlwALiZxnT',
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
            id: 'V8ziLwhPA05',
            name:
                'Any man push you, shake you, slap/punch/beat you, hit you with something, try to choke you or throw something at you that could hurt you?',
            translatedName:
                'Na o kile a u suthumetsa, a u tlelapa, a u otla ka feisi, a u otla ka ntho e ’ngoe, a leka ho u khama, kapa a u betsa ka ntho e ka u ntšang kotsi?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'GXb0yN9WSvZ',
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
              id: 'rfwvxFDyLnN',
              name:
                  'Any man physically forced you to have sexual intercourse with him when you did not want to?',
              translatedName:
                  'Na o kile a u qobella ho etsa thobalano le eena ha uena u ne u sa batle ho etsa joalo?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'K0r3yA6oi3F',
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
            id: 'dvT9e6eeNsE',
            name:
                'Any man physically forced you to perform any other sexual acts you did not want to?',
            translatedName:
                'Na o kile a u qobella ho etsa liketso tse ling tsa thobalano tseo u sa li batleng?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'B1hsntcuB5q',
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
            id: 'mZXrTDoaBqp',
            name:
                'Any man force you with threats or in any other way to perform sexual acts you did not want to?',
            translatedName:
                'Na o kile a u qobella le ho u tšosa hore u etse liketso kapa mefuta e meng ea thobalano eo u sa e batleng?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'FGiKknNPkbh',
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
            id: 'pDKOAGB7LKD',
            name:
                'Did you seek help after experiencing the different things we have discussed?',
            translatedName:
                'Na u kile oa kopa thuso kamora liketsahalo tseo u li hlalositseng?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'seek_help',
            name: 'Where did you seek help from?',
            translatedName: 'U ile oa kopa thuso ho mang kapa kae?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'A6QAU54w2wy',
                  name: 'My family',
                  translatedName: 'Lelapa leso'),
              InputFieldOption(
                  code: 'uU3uryQGK63',
                  name: 'Husband/Partner/Boyfriend’s family',
                  translatedName:
                      'Monna oa ka/mohlankana oa ka/lelapa la bo mohlankana oa ka'),
              InputFieldOption(
                  code: 'YTIdNMhrIbT',
                  name: 'Friend',
                  translatedName: 'Motsoalle'),
              InputFieldOption(
                  code: 'PaxU4ausAxY',
                  name: 'Neighbour',
                  translatedName: 'Mohaisane'),
              InputFieldOption(
                  code: 'AmlsrMQC5e0',
                  name: 'Religious leader',
                  translatedName: 'Moruti oa kereke'),
              InputFieldOption(
                  code: 'SbH8RKHMdcZ',
                  name: 'Doctor/Medical personnel',
                  translatedName: 'Ngaka/Mosebeletsi oa bophelo'),
              InputFieldOption(
                  code: 'LMWLaAgs1Vh',
                  name: 'Chief or village elder',
                  translatedName: 'Morena kapa motho e moholo motseng'),
              InputFieldOption(
                  code: 'EoxY8HfFYL6',
                  name: 'Police',
                  translatedName: 'Sepolesa'),
              InputFieldOption(
                  code: 'vz0mifjJR9z',
                  name: 'Justice system',
                  translatedName: 'Makhotla a toka'),
              InputFieldOption(
                  code: 'YMfWJFnF0qW',
                  name: 'NGO/CBO',
                  translatedName: 'Mekhatlo e ikemetseng/Mokhatlo oa kereke')
            ],
          ),
          InputField(
              id: 'WMjfK2Fl7d6',
              name:
                  'Do you know where to seek help if you experience the different things that we discussed?',
              translatedName:
                  'Na u tseba moo u ka batlang thuso ha u kopana le mathata ao re qetang ho buisana ka ona?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'H2Az2c3MeAy_checkbox',
            name:
                'If experienced the different things that we discussed,where would you seek help from?',
            translatedName:
                'U ka batla thuso kae ha u kopana le mathata ao re qetang ho buisana ka ona?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'ZX7jaEWS5Tu',
                  name: 'Family',
                  translatedName: 'Lelapa leso'),
              InputFieldOption(
                  code: 'ozZOGSNP0ZL',
                  name: 'Husband/Partner/Boyfriend’s family',
                  translatedName:
                      'Monna oa ka/mohlankana oa ka/lelapa la bo mohlankana oa ka'),
              InputFieldOption(
                  code: 'VgaY6FIuggs',
                  name: 'Friend',
                  translatedName: 'Motsoalle'),
              InputFieldOption(
                  code: 'pkc3tHTirOj',
                  name: 'Neighbour',
                  translatedName: 'Mohaisane'),
              InputFieldOption(
                  code: 'VdnWjzKyMkj',
                  name: 'Religious leader',
                  translatedName: 'Moruti oa kereke'),
              InputFieldOption(
                  code: 'ZQ48ocoJoZD',
                  name: 'Doctor/Medical personnel',
                  translatedName: 'Ngaka/Mosebeletsi oa bophelo'),
              InputFieldOption(
                  code: 'W8ChrDLO18b',
                  name: 'Chief or Village elder',
                  translatedName: 'Morena kapa motho e moholo motseng'),
              InputFieldOption(
                  code: 'OUOVMpCkOOr',
                  name: 'Police',
                  translatedName: 'Sepolesa'),
              InputFieldOption(
                  code: 'aSCE8aW4BKK',
                  name: 'Justice',
                  translatedName: 'Makhotla a toka'),
              InputFieldOption(
                  code: 'UtTKoXNvsnt',
                  name: 'NGO/CBO',
                  translatedName: 'Mekhatlo e ikemetseng/Mokhatlo oa kereke')
            ],
          ),
          InputField(
              id: 'SeAKGquzcZs',
              name: 'Specify other you will seek help from',
              translatedName: 'Ba bang (ba hlalose)',
              valueType: 'TEXT',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373)),
        ],
      ),
      FormSection(
        id: 'L1sMryibo4T',
        name: 'Enrollment Module 7: Non-Prescription Drug Use',
        translatedName:
            'KAROLO EA 7: Tšebeliso ea lithethefatsi tse sa fanoang ke lingaka',
        description:
            'INTERVIEWER SAY: I would like to ask you some questions about drugs or substances that you may have taken that were not prescribed by your doctor.  Now I will ask you some questions about your sexual activity in order to gain a better understanding of some life issues.  Let me reassure you that your answers are completely confidential. If you are uncomfortable with any questions, please let me know. Remember, there is no right or wrong answer.',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE:  Ke tla u botsa lipotso ka litaba tsa hao tse amanang le lithethefatsi tseo u kileng oa li sebelisa empa u sa li fuoa ke ngaka. Ke tla u botsa lipotso ka litaba tsa hao tse amanang le thobalano e le ho utloisisa lintlha tse ling tse amanang le bophelo. Ke batla ho u tiisetsa hore likarabo tsa hao li tla bolokoa e le lekunutu. Haeba u utloa lipotso tsa ka li u beha tsietsing, u mpolelle. Hopola hore ha ho karabo e nepahetseng kapa a fosahetseng.',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
            id: 'ICt3HySVpyI',
            name: 'Have you used alcohol in the last 12 months?',
            translatedName:
                'Likhoeling tse 12 tse fetileng, na u kile oa noa joala?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'gwxgoK1SiG7',
            name:
                'In the past 12 months, how often did you have a drink containing alcohol?',
            translatedName:
                'Likhoeling tse 12 tse fetileng, u noele joala ka makhetlo a makae?',
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
            id: 'flG4KJIt01K',
            name:
                'Have you used drugs of abuse or addiction in the last 12 months?',
            translatedName:
                'Na likhoeling tse 12 tse fetileng u kile oa sebelisa lithethefatsi?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'typeOfDrugUsed',
            name:
                'Which type of drugs of abuse/addiction have you used in the last 12 months?',
            translatedName:
                'Likhoeling tse 12 tse fetileng, u kile oa sebelisa mefuta efe ea lithethefatsi?',
            valueType: 'CHECK_BOX',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Qw4If3g2ZTk',
                  name: 'Marijoana or Matekoane',
                  translatedName: 'Matekoane'),
              InputFieldOption(
                  code: 'DYlMEu5l6qL',
                  name: 'Glue or Petrol or Gundi',
                  translatedName: 'Glue/Petrol'),
              InputFieldOption(
                  code: 'HchL5WVGByq',
                  name: 'Cocaine',
                  translatedName: 'Cocaine'),
              InputFieldOption(
                  code: 'z6R0L8rrp37',
                  name: 'Heroin',
                  translatedName: 'Heroin'),
              InputFieldOption(
                  code: 'nTWvhUFVpA9',
                  name: 'Mandrax',
                  translatedName: 'Mandrax'),
              InputFieldOption(
                  code: 'PPdHrhOS0py',
                  name: 'Cigarettes or Tobacco',
                  translatedName: 'Lisakarete/Koae'),
              InputFieldOption(
                  code: 'tUM0QoCh8qb',
                  name: 'Other',
                  translatedName: 'Tse ling')
            ],
          ),
          InputField(
            id: 'cBhCGU5VnmI',
            name:
                'In the last 12 months have you engaged in brewing or selling alcohol and/or drugs of abuse or addiction?',
            translatedName:
                'Likhoeling tse 12 tse fetileng na u kile oa ritela kapa oa rekisa joala le lithethefatsi?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'yRrFmxEMQbS',
        name: 'Enrollment Module 8: Participation in HIV Prevention Programme',
        translatedName:
            'KAROLO EA 8: Ho kena mananehong a thibelo ea tšoaetso ea HIV',
        description:
            'INTERVIEWER SAY: I would like to ask you a final question about your participation in any of the below programs or interventions.',
        translatedDescription:
            'MOTHO EA BOTSANG LIPOTSO A RE: Ke kopa ho u botsa potso ea ho qetela. Na u kile oa kena mananehong a latelang:',
        color: const Color(0xFF258DCC),
        inputFields: [
          InputField(
              id: 'trainedPrograms',
              name:
                  'Have you ever participated or been trained in any of these programmes?',
              translatedName:
                  'Na u kile oa kena lithupelong kapa mananehong a latelang?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: 'zq24EQYpsGV',
                  name: 'Go Girls: Sepheo Adopted Curriculum: Married Women',
                ),
                InputFieldOption(
                  code: 'qClMmewbJzu',
                  name:
                      'Singing to the Lions: A Facilitator\'s Guide to Overcoming Fear and Violence in Our Lives',
                ),
                InputFieldOption(
                  code: 'oVK1Lq0qif1',
                  name: 'Aflatoun Non Formal Education',
                  translatedName: 'Aflatoun Non Formal Education',
                ),
                InputFieldOption(
                  code: 'u8ij6OqwVtl',
                  name: 'Financial Education',
                ),
                InputFieldOption(
                  code: 'RHsrPq4uV2s',
                  name: 'Savings and Internal Lending Communities (SILC)',
                ),
                InputFieldOption(
                  code: 'ZjZGAUghgNj',
                  name: 'Condom Social Marketing CSM Toolkit (Pusha love)',
                ),
              ]),
          InputField(
              id: 'cTXlwMDf7K0',
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
