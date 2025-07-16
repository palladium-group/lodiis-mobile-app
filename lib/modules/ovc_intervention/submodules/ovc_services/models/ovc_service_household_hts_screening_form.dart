import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcHouseholdServiceHtsScreening {
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
        formSectionLabel: 'HTS Assessment Date',
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
                id: 'BvNaiaoxc6w',
                name: '1. Have you been tested for HIV?',
                translatedName: '15. U kile oa hlahlobela HIV?',
                description: 'If no refer for testing',
                translatedDescription:
                'Ha asa hlahloba  fetesitsa setsing sa tlhabollo',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                ),
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
                '2. Would you be willing to share your HIV test result with me?',
                translatedName:
                '2. Na u ka ba le bolokolohile ba ho mpolella sephetho sa tlhahlobo eo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                ),
            InputField(
                id: 'vNeOE9abQBB',
                name: 'What is your HIV Status?',
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
                  InputFieldOption(
                      code: 'No Response',
                      name: 'No Response',
                      translatedName: 'Ha ho Karabo')
                ]),
            InputField(
              id: 'blod3xZ2dPP',
              name: '3. Are you currently taking ART to treat HIV?',
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
              ],
            ),
            InputField(
                id: 'ubin7MjQ5OI',
                name: '4.How long have you been on ART?',
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
              id: 'upkFeuyd1fX',
              name: '5.Had sex with more than 1 sexual partner?',
              translatedName: '5.Had sex with more than 1 sexual partner?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),
            InputField(
              id: 'R38Mm0YgXcx',
              name: '6.In the past 12 months Have you had sex without a condom with someone living with HIV?',
              translatedName: '6. In the past 12 months Have you had sex without a condom with someone living with HIV?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),
            InputField(
              id: 'qoKPxEkgfdh',
              name: '7. In last 12 month have you had unprotected sexual intercourse with a partner of unknown HIV status?',
              translatedName: '7. In last 12 month have you had unprotected sexual intercourse with a partner of unknown HIV status?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),
            InputField(
              id: 'B46Zeuzafkg',
              name: '8. In the past 12 months have you had/currently have genital sores or unusual leakage?',
              translatedName: '8. In the past 12 months have you had/currently have genital sores or unusual leakage?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

          ]),

    ];
  }
}
