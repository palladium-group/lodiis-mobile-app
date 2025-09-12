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
        formSectionLabel: 'Assessment Date',
        inputFieldLabel: 'Assessed on',
        firstDate: firstDate,
      ),
      FormSection(
          name: 'DOMAIN HEALTH',
          id: 'domainhealth',
          translatedName: 'BOPHELO',
          color: const Color(0xFF4B9F46),
          borderColor: const Color(0xFF4B9F46),
          inputFields: [
            InputField(
                id: 'income_source',
                translatedName: 'U fumana chelete joang?',
                name: 'What is your source of income?',
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
                id: 'time_for_visit',
                translatedName: 'Nako e nepahetseng hore re etele lelapa?',
                name: 'Appropriate time for us to visit your home?',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'OPm74th0406',
                      name: 'Daily',
                      translatedName: 'Ka mehla'),
                  InputFieldOption(
                      code: 'aBXitFn5YUF',
                      name: 'Weekends',
                      translatedName: 'Mafelong a beke'),
                  InputFieldOption(
                      code: 'bnAsZ7GoJtl',
                      name: 'After working hours',
                      translatedName: 'Ka mora lihora tsa mosebetsi(5 to 7pm)'),
                  InputFieldOption(
                      code: 'cqusz74t5OH',
                      name: 'Other',
                      translatedName: 'Tse ling'),
                ]),
            InputField(
                id: 'ZuCnNb9G6EM',
                name: 'Other, Specify',
                translatedName: 'Tse ling, hlakisa',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)
            ),


            InputField(
              id: 'MkoDGBOBo06',
              name: 'As a family, which facility do you access health services at?',
              translatedName: 'Lele lelapa le fumana litsebeletso tsa bophelo setsing sefe?',
              allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
              showCountryLevelTree: true,
              valueType: 'ORGANISATION_UNIT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)
            ),

            InputField(
                id: 'ut8LqpHyZnR',
                name:
                    'Do you or anyone have a long-term illness that you would like to share with me',
                translatedName:
                    'Na oena kapa emong oa ba lelapa o na le bokulo ba nako e telele bo u ka lakatsang ho mpolella bona?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                ),
            InputField(
                id: 'TeVmOZEH9ww',
                name: 'If Yes, Who?',
                translatedName: 'Ha bo le teng, Ke mang',
                valueType: 'CHECK_BOX',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Y9rLt3Sok46',
                      name: 'Me',
                      translatedName: 'Nna'),
                  InputFieldOption(
                      code: 'JBFnEc7nhZM',
                      name: 'My Child',
                      translatedName: 'Ngoanaka'),
                  InputFieldOption(
                      code: 'Ci6QkahYAcS',
                      name: 'My Spouse',
                      translatedName: 'Molekane'),
                  InputFieldOption(
                      code: 's3JAXcIKeZ3',
                      name: 'Member of the family',
                      translatedName: 'Setho se seng sa lelapa'),
                ]),

            InputField(
                id: 'ut8LqpHyZnR_checkbox',
                name: 'What is the long-term illness?',
                translatedName:
                    'Ke bokuli bo fe ba nako e telele?',
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
                  // InputFieldOption(
                  //     code: 'KexFaUmJpt5',
                  //     name: 'None', translatedName: 'Ha bo eo'),
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
                name: 'Have you ever been tested for HIV?',
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
      /*    InputField(
                id: 'T4grVrCVDkk',
                name:
                    '8. Would you be willing to share your HIV test result with me?',
                translatedName:
                    '8. Na u ka ba le bolokolohile ba ho mpolella sephetho sa tlhahlobo eo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                isReadOnly: true), */
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
      /*            InputFieldOption(
                      code: 'No Response',
                      name: 'No Response',
                      translatedName: 'Ha ho Karabo') */
                ]),

            InputField(
              id: 'EEclxMv9xXk',
              name: 'Has there been any possible exposure (e.g., unprotected sex, new partner, shared needles) that might put you at risk of HIV infection?',
              translatedName: 'Na ho bile le monyetla oa ho pepeseha (mohlala, thobalano e sa sireletsehang, molekane e mocha, ho arolelana nale) o ka u behang kotsing ea tšoaetso ea HIV?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

            /*InputField(
              id: 'blod3xZ2dPP',
              name: '9. Are you currently taking ART to treat HIV?',
              translatedName: '9. Na u tlasa kalafo ea lefu la HIV ha joale?',
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
            ),*/


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
            /*    InputFieldOption(
                      code: 'Don? know',
                      name: 'Don? know',
                      translatedName: 'Ha a tsebe'),
                  InputFieldOption(
                      code: 'NA', name: 'NA', translatedName: 'N/A') */
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
                  // InputFieldOption(
                  //     code: 'No Response',
                  //     name: 'No Response',
                  //     translatedName: 'Ha hona Karabo'),
                  // InputFieldOption(
                  //     code: 'NA', name: 'NA', translatedName: 'N/A')
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
          name: 'Other Household details',
          id:'otherdetails',
          color: const Color(0xFF5B94F0),
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
