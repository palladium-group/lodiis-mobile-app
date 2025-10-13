import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

import '../../../../../core/constants/app_hierarchy_reference.dart';
import '../../../../../core/utils/form_util.dart';

class HouseholdServicesOngoingMonitoring {
  static List<String> getMandatoryFields() {
    return FormUtil.getAllFormSectionInpiutFields(
      getFormSections(

      ),
    );
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: 'DOMAIN HEALTH',
          id: 'domainhealth',
          translatedName: 'BOPHELO',
          color: const Color(0xFF4B9F46),
          borderColor: const Color(0xFF4B9F46),
          inputFields: [
            InputField(
              id: 'nSh4v0iBjKW',
              name: 'Are you currently pregnant?',
              translatedName: 'Na u mokhachane nakong ea joale?',
              valueType: 'TEXT',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
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
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),
            InputField(
              id: 'LHf5EZmkZ5q',
              name:
              'Which clinic/facility are you currently seeking ANC services?',
              translatedName:
              'U tsamaea tleleniking efe ho fumana litšebeletso tsa bokhachane?',
              valueType: 'ORGANISATION_UNIT',
              allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
              inputColor: const Color(0xFF4B9F46),
              showCountryLevelTree: true,
              labelColor: const Color(0xFF1A3518),
            ),

            InputField(
              id: 'dCIDHw3RrQ9',
              name: 'Are you Breastfeeding?',
              translatedName:
              "Na ua ants'a?",
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),

            InputField(
              id: 'BvNaiaoxc6w',
              name: 'Have you ever been tested for HIV',
              translatedName: 'U kile oa hlahlobela HIV?',
              description: 'If no refer for testing',
              translatedDescription:
              'Ha asa hlahloba  fetesitsa setsing sa tlhabollo',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
              //isReadOnly: true
            ),
            InputField(
                id: 'Uv26fX0HQvO',
                name: 'When?',
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
                ],
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'vNeOE9abQBB',
                name: 'What were the results of your last HIV test?',
                translatedName: 'Boemo ba hau ba HIV ke bofe?',
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
                      code: 'Unknown',
                      name: 'Unknown',
                      translatedName: 'Tse sa tsejoeng'),
                ]),

            InputField(
                id: 'EEclxMv9xXk',
              name: 'Has there been any possible exposure (e.g., unprotected sex, new partner, shared needles) that might put you at risk of HIV infection?',
              translatedName: 'Na ho bile le monyetla oa ho pepeseha (mohlala, thobalano e sa sireletsehang, molekane e mocha, ho arolelana nale) o ka u behang kotsing ea tšoaetso ea HIV?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

            InputField(
              id: 'Icgkv0xkUow',
              name: 'Are you currently taking ART to treat HIV?',
              translatedName: 'Na u tlasa kalafo ea lefu la HIV ha joale?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),
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
                ]),
            InputField(
                id: 'sLyfb45aLkl',
                name: 'Have you ever had a blood test called viral load?',
                translatedName: 'U kile oa etsa hlahlobo ea mali bakeng sa boemo ba t’soaetso bo maling (viral load)?',
                description: 'If taking ART for over six months and not tested refer to viral load test.',
                translatedDescription: 'Haeba a le litlhareng ho feta khoeli tse tseletseng eba ha a so hlahlobe mali, fetisetsa setsing bakeng sa tlahobo.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(code: '0', name: 'No', translatedName: 'Che'),
                  //  InputFieldOption(code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'aRNGDZcwWmS',
                name: 'What was the result of your viral load test?',
                translatedName: 'Sephetho sa tlhahlobo eo ea mali se ne se reng?',
                description: 'Note to Case Management Workers, they do not have to know exact numbers just whether it was high, low or undetectable.',
                translatedDescription: 'Tlhokomeliso ho Mosebeletsi oa morero, ha ba tlameha ho tseba palo tse nepahetseng empa hore na e holimo kapa e tlase.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'High (above 1,000 copies/ml)',
                      name: 'High (above 1,000 copies/ml)',
                      translatedName: 'E holimo'),
                  InputFieldOption(
                      code: 'Low (51-999 copies/ml)',
                      name: 'Low (51-999 copies/ml)',
                      translatedName: 'E tlase'),
                  InputFieldOption(
                      code: 'Undetectable (0-50 copies/ml)',
                      name: 'Undetectable (0-50 copies/ml)',
                      translatedName: 'Ha e bonahale'),
                  InputFieldOption(
                      code: 'Not documented',
                      name: 'Not documented',
                      translatedName: 'Ha a tsebe'),
                ]),

            InputField(
              id: 'P52dMXyK4eA',
              name: 'Have you received VL testing as per schedule?',
              translatedName: 'Na u ntse u fumana liphetho tsa liteko tsa VL ka nako e nepahetseng?',
              description: 'Normal: 6 months then annual; Pregnant every 3 months; Breastfeeding every 3 months',
              translatedDescription: 'Normal: 6 months then annual; Pregnant every 3 months; Breastfeeding every 3 months',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

            InputField(
              id: 'tYN12Es3707',
              name: 'Do you have CD4 results?',
              translatedName: 'U na le sephetho sa CD4 na?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

            InputField(
                id: 'o1GBFscjs4y',
                name: 'What are the CD4 results?',
                translatedName: 'Sephetho sa tlhahlobo eo ea CD4 se ne se reng?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                    code: 'Less than 200cells',
                    name: 'Less than 200cells',
                    /* translatedName: 'E holimo'*/),
                  InputFieldOption(
                    code: 'More than 200cells',
                    name: 'More than 200cells',
                    /* translatedName: 'E tlase'*/),
                  InputFieldOption(
                    code: 'Not documented',
                    name: 'Not documented',
                    /*translatedName: 'Ha a tsebe'*/),
                ]),


            InputField(
                id: 'BYZu8p33lzP',
                name: 'Have you disclosed your status to anyone?',
                translatedName:
                'Na ho na le motho eo u kileng oa mojoetsa boemo ba hau ba HIV?',
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
                ]),

            InputField(
                id: 'KFCBwn7ypws',
                name:
                'Do you feel like you are supported enough regarding your HIV status?',
                translatedName:
                'Na u utloa u tshehelitsoe mabapi le boemo ba hao ba HIV?',
                description:
                'If No, voluntarily offer family psychosocial support (Parenting tips)',
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
                ]),

            InputField(
                id: 'wRhamvRZj87',
                name: 'Would you like to receive information on Oral Health?',
                translatedName: 'U ka thabela ho fumana thuto ka bohloeki ba lehano?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),

            InputField(
                id: 'ImAyVEpwmNS',
                name:
                'Are you on TB treatment?',
                translatedName:
                'Na u noa lithlare tsa lefuba?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
          ]),
      FormSection(
          name: 'TB SECTION',
          id: 'tbsection',
          description: 'TB SCREENING',
          color: const Color(0xFF4B9F46),
          borderColor: const Color(0xFF4B9F46),
          inputFields: [

            InputField(
                id: 'tMvluCbiiUm',
                name:
                'Are you coughing?',
                translatedName:
                'Are you coughing?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'P9hiqrTjAdg',
                name: 'Have you lost weight (without trying)?',
                translatedName:
                'Have you lost weight (without trying)?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Y8Xzy7bEWsi',
                name: 'Do you have drenching/soaking sweats at night?',
                translatedName: 'Do you have drenching/soaking sweats at night?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'VETgonq6tFr',
                name: 'Do you have fevers?',
                translatedName: 'Do you have fevers?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),

          ]),
      FormSection(
          name: 'NUTRITION SECTION',
          id: 'ntsection',
          description: 'NUTRITION',
          color: const Color(0xFF4B9F46),
          borderColor: const Color(0xFF4B9F46),
          inputFields: [
            InputField(
                id: 'iqBsSAfCyJb',
                name: 'Which food groups do you regularly eat?',
                translatedName: 'Ke mefuta efe ea lijo eo u ejang khafetsa?',
                description: 'Energy foods, Body Building foods or Protective foods',
                translatedDescription: 'Limatlafatsi, Li haha mmele kapa lithibela mafu',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'One type of food group', translatedName: 'Mofuta ole mong'),
                  InputFieldOption(
                      code: '2', name: 'Two types of food groups', translatedName: 'Mefuta e mmeli'),
                  InputFieldOption(
                      code: '3', name: 'All types of food groups', translatedName: 'Mefuta eohle')
                ]),
          ]),
      FormSection(
          name: 'HIV SECTION',
          id: 'hivscreening',
          description: 'HIV SCREENING',
          color: const Color(0xFF4B9F46),
          borderColor: const Color(0xFF4B9F46),
          inputFields: [
            InputField(
              id: 'upkFeuyd1fX',
              name: 'Had sex with more than 1 sexual partner?',
              translatedName: 'Had sex with more than 1 sexual partner?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),
            InputField(
              id: 'R38Mm0YgXcx',
              name: 'In the past 12 months Have you had sex without a condom with someone living with HIV?',
              translatedName: 'In the past 12 months Have you had sex without a condom with someone living with HIV?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),
            InputField(
              id: 'qoKPxEkgfdh',
              name: 'In last 12 month have you had unprotected sexual intercourse with a partner of unknown HIV status?',
              translatedName: '7. In last 12 month have you had unprotected sexual intercourse with a partner of unknown HIV status?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),
            InputField(
              id: 'B46Zeuzafkg',
              name: 'In the past 12 months have you had/currently have genital sores or unusual leakage?',
              translatedName: 'In the past 12 months have you had/currently have genital sores or unusual leakage?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

          ])

    ];
  }
}
