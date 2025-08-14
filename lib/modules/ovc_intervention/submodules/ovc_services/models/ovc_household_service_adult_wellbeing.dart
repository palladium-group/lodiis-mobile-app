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
          translatedName: 'BOTSITSO',
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
                      name: 'After working hours(5 to 7pm)',
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
              id: 'PpghWNFLAF3',
              name: 'As a family, where do you access health services?',
              translatedName: 'Lele lelapa le fumana litsebeletso tsa bophelo hokae?',
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

            // InputField(
            //     id: 'BvNaiaoxc6w',
            //     name: 'Have you been tested for HIV?',
            //     translatedName: 'U kile oa hlahlobela HIV?',
            //     description: 'If no refer for testing',
            //     translatedDescription:
            //         'Ha asa hlahloba  fetesitsa setsing sa tlhabollo',
            //     valueType: 'BOOLEAN',
            //     inputColor: const Color(0xFF4B9F46),
            //     labelColor: const Color(0xFF1A3518),
            //     isReadOnly: true),
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
      /*            InputFieldOption(
                      code: 'more than one year',
                      name: 'more than one year'),
                  InputFieldOption(code: 'NA', name: 'NA') */
                ]),
     /*       InputField(
                id: 'Icb6vUJXVDX',
                name: '11. Do you take your treatments daily and on time?',
                translatedName:
                    '11. Na u noa litlhare tsa hau hantle (ka mehla ka nako)?',
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
                labelColor: const Color(0xFF1A3518)), */
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
              id: 'Have you received VL testing as per schedule?',
              name: 'Have you received VL testing as per schedule?',
              translatedName: 'Na u ntse u fumana liphetho tsa liteko tsa VL ka nako e nepahetseng?',
              description: 'Normal: 6 months then annual; Pregnant every 3 months; Breastfeeding every 3 months',
              translatedDescription: 'Normal: 6 months then annual; Pregnant every 3 months; Breastfeeding every 3 months',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

            InputField(
              id: 'If virally unsuppressed, do you have CD4 results?',
              name: 'If virally unsuppressed, do you have CD4 results?',
              translatedName: 'U na le sephetho sa CD4 na?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),

            InputField(
                id: 'What are the CD4 results?',
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
                  InputFieldOption(
                      code: 'No Response',
                      name: 'No Response',
                      translatedName: 'Ha hona Karabo'),
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
                id: 'idd',
                name:
                'Do you feel like you are supported enough regarding your HIV status?',
                translatedName:
                'Na u utloa u tshehelitsoe mabapi le boemo ba hao ba HIV?',
                description:
                'If yes, voluntarily offer family psychosocial support (Parenting tips)',
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
              id: 'Bokamoso offers different health education, such as; Oral health messaging and Prevention of child injuries and othersWould you like to be given information regarding them?',
              name: 'Bokamoso offers different health education, such as; Oral health messaging and Prevention of child injuries and othersWould you like to be given information regarding them?',
              translatedName: 'Bokamoso offers different health education, such as; Oral health messaging and Prevention of child injuries and othersWould you like to be given information regarding them?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),


            // InputField(
            //     id: 'jzmOXiyGGgw',
            //     name:
            //         'Do you feel like people treat you differently because you are HIV positive?',
            //     translatedName:
            //         'Na o nahana hore batho ba o khetholla hobane unale le tso’oaetso ea HIV?',
            //     description:
            //         'Refer to Village Health Workers or Social Workers or psychosocial support.',
            //     translatedDescription:
            //         'Fetisetsa ho mosebeletsi oa tsa bophelo Motseng kapa mosebeltsi oa sechaba kapa tlabollong ea maikutlo.',
            //     valueType: 'TEXT',
            //     inputColor: const Color(0xFF4B9F46),
            //     labelColor: const Color(0xFF1A3518),
            //     options: [
            //       InputFieldOption(
            //           code: 'Yes', name: 'Yes', translatedName: 'E'),
            //       InputFieldOption(
            //           code: 'No', name: 'No', translatedName: 'Che'),
            //       InputFieldOption(
            //           code: 'No Response',
            //           name: 'No Response',
            //           translatedName: 'Ha hona Karabo'),
            //       // InputFieldOption(
            //       //     code: 'NA', name: 'NA', translatedName: 'N/A')
            //     ]),



            // InputField(
            //     id: 'How-have-you-coped-with-HIV-related-stigma',
            //     name: '17. How have you coped with HIV-related stigma?',
            //     translatedName:
            //         '17. U atleha ho phela joang tlaasa maemo a ho nenoa kapa ho khetholla ka baka la boemo ba hau ba HIV?',
            //     valueType: 'CHECK_BOX',
            //     inputColor: const Color(0xFF4B9F46),
            //     labelColor: const Color(0xFF1A3518),
            //     options: [
            //       InputFieldOption(
            //           code: 'QPcCByPcMpz',
            //           name: 'I am part of a support group',
            //           translatedName: 'Ke karolo ea support group '),
            //       InputFieldOption(
            //           code: 'klE3cj35whZ',
            //           name:
            //               'I speak with people who I am close with or my family',
            //           translatedName:
            //               'Ke bua le batho ba haufi le nna kapa lelapa laka '),
            //       InputFieldOption(
            //           code: 'FitzDd4bmS6',
            //           name: 'I speak with my doctor',
            //           translatedName: 'Ke bua le ngaka eaka'),
            //       InputFieldOption(
            //           code: 'PXZm9X9pG01',
            //           name: 'I speak with my pastor or priest',
            //           translatedName: 'Ke bua le moruti oaka'),
            //       InputFieldOption(
            //           code: 'XPplaRA9hzd',
            //           name: 'I face it all',
            //           translatedName: 'Ke tobane le bothata bona ke le mong '),
            //       InputFieldOption(
            //           code: 'zNYrqDOIhGO',
            //           name:
            //               'I avoid thinking about it because it’s too difficult',
            //           translatedName:
            //               'Ke qoba ho nahana ka eona hobane e nkimetse.'),
            //       InputFieldOption(
            //           code: 'LGhJJz12mWP',
            //           name: 'I do not face stigma',
            //           translatedName: 'Ha ke so tobane le sekhobo'),
            //       InputFieldOption(
            //           code: 'loGTnsw9R9G',
            //           name: 'Other',
            //           translatedName: 'Tse ling'),
            //       InputFieldOption(
            //           code: 'YT79ydtEOZj', name: 'NA', translatedName: 'N/A')
            //     ]),
            // InputField(
            //     id: 'dfdeOt1y7me',
            //     name: 'Please specify',
            //     translatedName: 'Tse ling, hlakisa',
            //     valueType: 'TEXT',
            //     inputColor: const Color(0xFF4B9F46),
            //     labelColor: const Color(0xFF1A3518)),
            // InputField(
            //     id: 'JYPmeC1Zbwf',
            //     name:
            //         '28. If you have a child or children 10 or over, have you talked to them about how to protect themselves from HIV?',
            //     translatedName:
            //         '28. Haeba u na le ngoana kapa bana ba ka holimo ho lilemo li 10, u kile oa bua le bona ka ho itsireletsa khahlanong le tsoaetso ea HIV?',
            //     valueType: 'TEXT',
            //     inputColor: const Color(0xFF4B9F46),
            //     labelColor: const Color(0xFF1A3518),
            //     options: [
            //       InputFieldOption(
            //           code: 'Yes', name: 'Yes', translatedName: 'E'),
            //       InputFieldOption(
            //           code: 'No', name: 'No', translatedName: 'Che'),
            //       InputFieldOption(
            //           code: 'No Response',
            //           name: 'No Response',
            //           translatedName: 'Ha hona Karabo'),
            //       InputFieldOption(
            //           code: 'NA', name: 'NA', translatedName: 'N/A')
            //     ]),
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
          name: 'CASE PLAN ',
          id: 'healthcaseplangaps',
          description: 'Domain Health Gaps',
          color: const Color(0xFF4B9F46),
          borderColor: const Color(0xFF4B9F46),
          inputFields: [

            InputField(
                id: 'HKCv7lkLexo',
                name: 'HIV ADHERANCE SUPPORT',
                translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                valueType: 'TRUE_ONLY',
                isReadOnly: true,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'JzlLk2tW4xh',
                allowFuturePeriod: true,
                name: '( HIV ADHERANCE SUPPORT ) Projected date for completion',
                translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF4D9E49),
                labelColor: const Color(0xFF737373)),
          ]),
      FormSection(
          name: 'DOMAIN SAFE',
          translatedName: 'TSIRELETSO',
          id:'domainsafe',
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

          ]),
      FormSection(
          name: 'NUTRITION SECTION',
          id: 'ntsection',
          description: 'NUTRITION',
          color: const Color(0xFF4B9F46),
          borderColor: const Color(0xFF4B9F46),
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
          name: 'HIV ASSESSMENT',
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
