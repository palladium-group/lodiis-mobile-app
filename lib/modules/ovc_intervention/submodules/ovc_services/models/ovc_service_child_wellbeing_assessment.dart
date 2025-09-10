import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcServicesChildWellbeingAssessment {
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
        inputFieldLabel: 'Assessment Date',
        firstDate: firstDate,
      ),
      FormSection(
          name: 'DOMAIN HEALTH',
          translatedName: 'BOPHELO BO BOTLE',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [
            InputField(
                id: 'GN85Cf2mOmw',
                name: 'Is the child health card available?',
                translatedName: 'Is child have health card available?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'eDuHTPn7rhh',
                name:
                'Does the child attend under 5 clinic?',
                translatedName:
                'Does the child attend under 5 clinic?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),

            InputField(
                id: 'H84JX4fQWsK',
                name:
                'In the last month, has the child been too sick or too tired to participate in daily activities?',
                translatedName:
                'Na ngoana o kile a kula kapa a khathala haholo ho a setiloeng ho etsa mabaka a mehla khoeling e fetileng?',
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
                id: 'TQGFUJ7MTPu',
                name:
                'Is the child currently receiving treatment for the illness?',
                translatedName:
                'Na ngoana o fumana kalafo ea ho kula kapa ho holofala?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),


            InputField(
                id: 'MkoDGBOBo06',
                name:  'Where does the child access health services?',
                translatedName:
                " U fumana litsebeletso tsa bophelo hokae?",
                allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
                showCountryLevelTree: true,
                valueType: 'ORGANISATION_UNIT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)
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
                labelColor: const Color(0xFF1A3518)),
            InputField(
                id: 'c5TMWtM4VVJ',
                name: 'HIV Status',
                isReadOnly: true,
                translatedName: '14. Na u nka mpolella sephetho sa hau?',
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
                      code: 'No disclosure',
                      name: 'No disclosure',
                      translatedName: 'Ha a bolele'),
                ]),

            InputField(
              id: 'Exposure',
              name: 'Has there been any possible exposure (e.g. shared needles) that might put you at risk of HIV infection?',
              translatedName: 'Na ho bile le monyetla oa ho pepeseha (mohlala, thobalano e sa sireletsehang, molekane e mocha, ho arolelana nale) o ka u behang kotsing ea tšoaetso ea HIV?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),


            InputField(
              id: 'Icgkv0xkUow',
              name: 'Currently taking ART to treat HIV?',
              translatedName:
              'Na u tlasa kalafo ea lefu la HIV ha joale?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518),
            ),
            InputField(
                id: 'wv3YAGLZlev',
                name: 'Which health facility do you visit for ART services?',
                translatedName: 'Which health facility do you visit for ART services?',
                valueType: 'ORGANISATION_UNIT',
                showCountryLevelTree: true,
                allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),
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
                name: 'Ever had a blood test called viral load?',
                translatedName:
                '9. U kile oa etsa hlahlobo ea mali bakeng sa boemo ba t’soaetso bo maling (viral load)?',
                translatedDescription:
                'Haeba a le litlhareng ho feta khoeli tse tseletseng eba ha a so hlahlobe mali, fetisetsa setsing bakeng sa tlahobo.',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                ]),
            InputField(
                id: 'aRNGDZcwWmS',
                name: 'What was the result of your viral load test?',
                translatedName:
                'Sephetho sa tlhahlobo eo ea mali se ne se reng?',
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
                      name: 'Undetectable (0-50 copies/ml)',
                      translatedName: 'Ha e bonahale'),
                  InputFieldOption(
                      code: 'Not documented',
                      name: 'Not documented',
                      translatedName: 'Ha a tsebe'),
                ]),


            InputField(
                id: 'tYN12Es3707',
                name:
                'Do you have CD4 results?',
                valueType: 'BOOLEAN',
                translatedName:
                'If virally unsuppressed, do you have CD4 results?',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF1A3518)),


            InputField(
                id: 'o1GBFscjs4y',
                name: 'What are the CD4 results?',
                translatedName:
                'What are the CD4 results?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Less than 200cells',
                      name: 'Less than 200cells',
                      translatedName: 'E holimo'),
                  InputFieldOption(
                      code: 'More than 200cells',
                      name: 'More than 200cells',
                      translatedName: 'E tlase '),
                  InputFieldOption(
                      code: 'Not documented',
                      name: 'Not documented',
                      translatedName: 'Ha e bonahale'),
                ]),


            InputField(
                id: 'hgQXrOd7iuH',
                name: 'Has the childs status been partially shared?',
                translatedName: 'Has the childs status been partially shared?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),

            InputField(
                id: 'Qisosyae92z',
                name: 'What was their response?',
                translatedName: 'What was their response?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'The child experienced denial, but is ok now',
                      name: 'The child experienced denial, but is ok now',
                      translatedName: 'The child experienced denial, but is ok now'),
                  InputFieldOption(
                      code: 'The child became angry, sad or depressed, but is ok now',
                      name: 'The child became angry, sad or depressed, but is ok now',
                      translatedName: 'The child became angry, sad or depressed, but is ok now'),
                  InputFieldOption(
                      code: 'The child is still dealing with denial, anger, sadness, or depression',
                      name: 'The child is still dealing with denial, anger, sadness, or depression',
                      translatedName: 'The child is still dealing with denial, anger, sadness, or depression'),
                ]),
            InputField(
                id: 'EYb2XmgHt58',
                name: 'why was the status not shared with the child?',
                translatedName: 'why was the status not shared with the child?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'They are too young',
                      name: 'They are too young',
                      translatedName: 'They are too young'),
                  InputFieldOption(
                      code: 'Worried about the child experiencing stigma',
                      name: 'Worried about the child experiencing stigma',
                      translatedName: 'Worried about the child experiencing stigma'),
                  InputFieldOption(
                      code: 'Worried about the child having a negative response',
                      name: 'Worried about the child having a negative response',
                      translatedName: 'Worried about the child having a negative response'),
                  InputFieldOption(
                      code: 'Worried about the parent/family experiencing stigma',
                      name: 'Worried about the parent/family experiencing stigma',
                      translatedName: 'Worried about the parent/family experiencing stigma'),
                ]),

            InputField(
                id: 'kcG670LJt3J',
                name: 'Has the childs status been disclosed to any family member?',
                translatedName: 'Has the childs status been disclosed to any family member?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518)),

            InputField(
                id: 'cEPYE0hDKtH',
                name: 'What was their response?', //Family Member's Response
                translatedName: 'What was their response?',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF1A3518),
                options: [
                  InputFieldOption(
                      code: 'Neutral/ no reaction',
                      name: 'Neutral/ no reaction',
                      translatedName: 'Neutral/ no reaction'),
                  InputFieldOption(
                      code: 'Rejected the child',
                      name: 'Rejected the child',
                      translatedName: 'Rejected the child'),
                ]),

            InputField(
                id: 'ImAyVEpwmNS',
                name:
                'Is the child on TB treatment?',
                translatedName:
                'Na u noa lithlare tsa lefuba?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
          ]),


      FormSection(
          name: 'HIV Risk Assessment',
          id: 'hivriskassessment',
          translatedName: 'Hlahlobo ea hoba tlokotsing ea HIV',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [
            InputField(
                id: 'kL4IhnhdKZv',
                name: 'Assessment enrollment criteria',
                translatedName: 'Lebaka la tlhahlobo ea boemo ba kotsi ea HIV',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      translatedName: 'Boemo ba HIV bo sa tsebahaleng',
                      code: 'Unknown status',
                      name: 'Unknown status'),
                  InputFieldOption(
                      translatedName: 'Boemo ba HIV bo sa boleloang.',
                      code: 'Undisclosed',
                      name: 'Undisclosed'),
                  InputFieldOption(
                      translatedName:
                      'O hlahlahlobile likhoeling tse 6 a fungoanoe a sena tsoaetso ea HIV',
                      code: 'Negative > 6mths',
                      name: 'Negative > 6mths'),
                  InputFieldOption(
                      translatedName: 'Ba kotsing ea ho ba le tsoetso ea HIV',
                      code: 'At risk older OVC/adolescent',
                      name: 'At risk older OVC/adolescent'),
                ]),
            InputField(
                id: 'Fz89mIraWIl',
                name:
                'Is the biological father or mother of this child living or lived with HIV?',
                valueType: 'BOOLEAN',
                translatedName:
                'Na Ntate kapa ‘M’e oa ngoana o phela kapa o ne a phela le tsoaetso ea HIV?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),),
            InputField(
                id: 'mIcseDgrIlJ',
                name:
                'Is at least one sibling of the child living or has lived with HIV?',
                valueType: 'BOOLEAN',
                translatedName:
                'Na e mong oa bana  ba bo ngoana eo o phela kapa o ne a phela le tsoaetso HIV?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Hi9fp222l2D',
                name:
                'Has this child lost one or both biological parents due to a chronic or undiagnosed illness?',
                valueType: 'BOOLEAN',
                translatedName:
                'Na ho na le emong oa batsoali ba ngoana eo ea hlokahetseng ka lebaka la bokuli bo sa phekoleheng kapa bo sa boleloang?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'r13f1emAyvw',
                name:
                'Has this child lost a sibling due to a chronic or undiagnosed illness?',
                valueType: 'BOOLEAN',
                translatedName:
                'Na e mong oa bana  ba bo ngoana eo o hlokahetse ka lebaka la bokuli bo sa phekoleheng kapa bo sa boleloang?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'YAugNMbMe2c',
                name:
                'Has the child ever been hospitalized or has been malnourished in the past 12 months?',
                valueType: 'BOOLEAN',
                translatedName:
                'Na ngoana o kile a kena sepetlele kapa a bontsa mats’oao a phepo e sa nepahalang likhoeling tse 12 tse fetileng?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'niqNMJrfFDs',
                name:
                'Does the child have recurring skin problems, and oral fungus or persistent cough and fever?',
                valueType: 'BOOLEAN',
                translatedName:
                'Na ngoana eo o na le bothata ba letlalo kapa liso tsa lehano kapa ho khohlela ho sa eng meriting?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'NhjnHO0IyqY',
                name:
                'Has this child been frequently sick in the last three months?',
                valueType: 'BOOLEAN',
                translatedName:
                'Na ngoana eo o kile a khathatsoa ke bokuli likhoeling tse tharo tse fetileng?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'LA4G0A6fkNF',
                name:
                'Is there anyone in the family who had TB in last 6 months',
                valueType: 'BOOLEAN',
                translatedName:
                'Na ho na le e mong oa lelapa ea bileng le lefuba (TB) likhoeling tse 6 tse fetileng?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'dL8ts5GQcMI',
                name:
                'Is the child/ adolescent exposed to sexual violence?',
                valueType: 'BOOLEAN',
                translatedName:
                'Na ngoana eo o kile a ba maemong a mmehang tlokotsing ea tlhekefetso ea motabo?',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'W64q5maeL6o',
                translatedName:
                'Na ngoana o sa bonahala e ka o sa kene litabeng tsa  thobalanong?',
                name: 'Is the adolescent sexually active?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'VJh6KDlBkfb',
                translatedName:
                'Ho latela likarabo tse fanoeng na ngoana eo o lokela ho hlahlobela HIV?',
                name: 'Is this child/adolescent eligible for an HIV test?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'SDPCwdDB9yX',
                translatedName:
                'Na mohlokomeli/ ngoana ea lilemo li  ka holimo ho 12  o llumela ho halahobela HIV?',
                name:
                'Has the caregiver/OVC >12 years accepted to have the child tested?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'v0ArPi4Rk4o',
                translatedName:
                'Bao boemo ba HIV bo sa boleloang, mme ba le kotsing ea HIV, ba fetisetsoe ho Social Worker ea morero.',
                name: 'Refer to Social Worker?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'hivriskres',
                name: 'HIV RISK ASSESSMENT RESULTS',
                translatedName: "SEPHETHO SA TLHAHLOBO EA KOTSI EA HIV",
                valueType: 'TEXT',
                renderAsRadio: true,
                options: [
                  InputFieldOption(
                      code: 'High risk',
                      name: 'High risk',
                      translatedName: "Kotsi e phahameng"),
                  InputFieldOption(
                      code: 'Low risk',
                      name: 'Low risk',
                      translatedName: "Kotsi e tlase")
                ],
                isReadOnly: true,
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373))
          ]),
      FormSection(
          name: 'TB Screening',
          id:'tbsection_child',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [

          ],
          subSections: [
            FormSection(
                name: '',
                color: const Color(0xFF4B9F46),
                inputFields: [
                  InputField(
                      id: 'C9cpFDvwOUJ',
                      name:
                      'Has the child been coughing?',
                      translatedName:
                      'Has the child been coughing?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'TpyePxydX6K',
                      name: 'Has the child had a fever?',
                      translatedName:
                      'Has the child had a fever?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'dlWawszpssl',
                      name: 'Failure to thrive/faltering growth or signs of severe malnutrition?',
                      translatedName: 'Failure to thrive/faltering growth or signs of severe malnutrition?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'GTIxkgzrJgS',
                      name: 'Has the child been in contact with someone with TB disease?',
                      translatedName: '4. Has the child been in contact with someone with TB disease?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),

                ])
          ]),
      FormSection(
          name: 'NUTRITION',
          id:'nutritionsection',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          inputFields: [

          ],
          subSections: [
            FormSection(
                name: 'Child Nutrition Screening',
                id: 'childnutrition',
                color: const Color(0xFF4B9F46),
                inputFields: [
                  InputField(
                      id: 'JnCFOeouVIy',
                      name: 'Check weight on the growth chart',
                      translatedName: 'Khetha boima ba ngoana bukaneng',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code:
                            'Normal',
                            name:
                            'Normal',
                            translatedName:
                            'Normal'),
                        InputFieldOption(
                            code: 'Flat',
                            name: 'Flat',
                            translatedName: 'Flat'),
                        InputFieldOption(
                            code: 'Falling',
                            name: 'Falling',
                            translatedName: 'Falling'),
                        InputFieldOption(
                            code: 'Above Normal',
                            name: 'Above Normal',
                            translatedName: 'Above Normal'),
                      ]),
                  InputField(
                      id: 'lbr7YOB6HJ1',
                      name: 'How would you describe feeding time with your baby? ',
                      translatedName: 'How would you describe feeding time with your baby? ',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code:
                            'Always Pleasant',
                            name:
                            'Always Pleasant',
                            translatedName:
                            'Always Pleasant'),
                        InputFieldOption(
                            code: 'Sometimes Pleasant',
                            name: 'Sometimes Pleasant',
                            translatedName: 'Sometimes pleasant'),
                        InputFieldOption(
                            code: 'Never Pleasant',
                            name: 'Never Pleasant',
                            translatedName: 'Never Pleasant'),

                      ]),
                  InputField(
                      id: 'child_milk_checkbox',
                      name: 'What type of milk do you feed your baby? ',
                      translatedName: 'What type of milk do you feed your baby?',
                      valueType: 'CHECK_BOX',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF1A3518),
                      options: [
                        InputFieldOption(
                            code: 'EOUH5w2VlIk',
                            name: 'Breast milk',
                            translatedName: 'Breast milk'),
                        InputFieldOption(
                            code: 'iq0qQmJEG8E',
                            name: 'Infant Formula',
                            translatedName: 'Infant Formula'),
                        InputFieldOption(
                            code: 'WciUhLXww99',
                            name: 'Cow Milk',
                            translatedName: 'Cow Milk'),
                        InputFieldOption(
                            code: 'W2cDbQTEky1',
                            name: 'Goat milk ',
                            translatedName: 'Goat milk'),
                        InputFieldOption(
                            code: 'nBoz16EWW4N',
                            name: 'Soy Milk',
                            translatedName: 'Soy Milk'),
                        InputFieldOption(
                            code: 'Oe9HgDtX5iW',
                            name: 'Fat free (Skim) milk',
                            translatedName: 'Fat free (Skim) milk'),
                      ]),
                  InputField(
                      id: 'ATWzSRHBmuF',
                      name:
                      'Has the child unintentionally lost weight?',
                      translatedName:
                      'Has the child unintentionally lost weight? ',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'uINNVU0OeRP',
                      name:
                      'Has the child had poor weight gain over the last few months? ',
                      translatedName:
                      'Has the child had poor weight gain over the last few months?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'bMNyAIWumx1',
                      name:
                      'Has the child been eating/feeding less in the last few weeks ',
                      translatedName:
                      'Has the child been eating/feeding less in the last few weeks',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'OUPk2e9DoMe',
                      name:
                      'Is the child obviously looking underweight? Thin, Ribs protruding from the body, etc.',
                      translatedName:
                      'Is the child obviously looking underweight? Thin, Ribs protruding from the body, etc.',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'eQM7VOlr5hG',
                      name:
                      '	Were there any days last month when your family didn’t have enough food to eat or enough money to buy food?',
                      translatedName:
                      'Were there any days last month when your family didn’t have enough food to eat or enough money to buy food?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'yVTsRM4eMHA',
                      name:
                      'Are there concerns about the general health of a child ',
                      translatedName:
                      'Are there concerns about the general health of a child ',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'OBugEkynJG0',
                      name: 'Are there any signs of malnutrition?',
                      translatedName: 'Are there any signs of malnutrition?',
                      valueType: 'BOOLEAN',

                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF455B44)),

                  InputField(
                      id: 'XLpBcDQ3p7I',
                      name: 'Child MUAC score',
                      translatedName: 'Child MUAC score',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF1A3518),
                      options: [
                        InputFieldOption(
                            code: '11.5 cm or less',
                            name: '11.5 cm or less(Red)',
                            translatedName: '11.5 cm or less'),
                        InputFieldOption(
                            code: '11.5-12.5cm ',
                            name: '11.5-12.5cm(Yellow) ',
                            translatedName: '11.5-12.5cm '),
                        InputFieldOption(
                            code: '12.5cm or more ',
                            name: '12.5cm or more(Green) ',
                            translatedName: '12.5cm or more '),
                      ]),

                  InputField(
                      id: 'R8SyKEnNi2q',
                      name: 'Does the child attend growth monitoring services?',
                      translatedName: 'Does the child attend growth monitoring services?',
                      valueType: 'BOOLEAN',
                      inputColor: const Color(0xFF4B9F46),
                      labelColor: const Color(0xFF455B44)),
                ]),
          ]),
    ];
  }
}
