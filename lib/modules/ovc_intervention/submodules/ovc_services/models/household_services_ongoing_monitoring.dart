import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class HouseholdServicesOngoingMonitoring {
  static List<FormSection> getFormSections() {
    return [
      FormSection(
          id: '',
          name: 'For those who were referred and changing HIV status',
          translatedName: 'Sebakeng sa ba fetisitsoeng le ba fetotseng sephetho sa tsoaetso ea HIV',
          color: const Color(0xFF4D9E49),
          inputFields: [

            InputField(
              id: 'BvNaiaoxc6w',
              name: 'Has the caregiver ever been tested for HIV?',
              translatedName: 'Mohlokomeli o kile a hlahlobela HIV?',
              description: 'If no refer for testing',
              translatedDescription: 'Ha asa hlahloba  fetesitsa setsing sa tlhabollo',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
             isReadOnly: true
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
                ],
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)
            ),
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
              name: 'If virally unsuppressed, do you have CD4 results?',
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
                id: 'ToWhhydys',
                name: 'To whom have you disclosed your status?',
                translatedName:
                'Ke mang eo u mo joetsitseng ka boemo a hao a HIV?',
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
                  InputFieldOption(
                      code: 'Wfu966TC3M5',
                      name: 'Member of the family',
                      translatedName: 'Moruti'),
                  InputFieldOption(
                      code: 'J5hjKDmiE6a',
                      name: 'Pastor or priest',
                      translatedName: 'Moruti kapa moprista'),
                  InputFieldOption(
                      code: 'HLPSkYfLYlS',
                      name: 'Other',
                      translatedName: 'Tse ling'),
                  // InputFieldOption(
                  //     code: 'mSc4D4Ij3KN', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'I3hI2UTkKyx',
                name: 'Other, Specify (disclosed HIV status to)',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),

            InputField(
              id: 'pJ1UrnLU9mh',
              name: 'Is the caregiver Preganant?',
              translatedName:
              "Na mohlokomeli o mmeleng?",
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),

            InputField(
              id: 'dCIDHw3RrQ9',
              name: 'Is the caregiver Breastfeeding?',
              translatedName:
              "Na mohlokomeli oa ants'a?",
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),

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
                  // InputFieldOption(
                  //     code: 'NA', name: 'NA', translatedName: 'N/A')
                ]),

            InputField(
              id: 'wRhamvRZj87',
              name: 'Bokamoso offers different health education, such as; Oral health messaging and Prevention of child injuries and others Would you like to be given information regarding them?',
              translatedName: 'Bokamoso offers different health education, such as; Oral health messaging and Prevention of child injuries and othersWould you like to be given information regarding them?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

            //     ]),
          ]),

    ];
  }
}
