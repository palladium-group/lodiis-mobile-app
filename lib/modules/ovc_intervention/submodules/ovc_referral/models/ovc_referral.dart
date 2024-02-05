import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcReferral {
  static List<String> getMandatoryFields() {
    return [
      "eventDate",
      "qAed23reDPP",
      "LLWTHwhnch0",
      "rsh5Kvx6qAU",
      "AuCryxQYmrk",
      "OrC9Bh2bcFz"
    ];
  }

  static List<FormSection> getFormSections({
    required String enrollmentDate,
  }) {
    return [
      FormSection(
        name: 'Service Referral',
        color: const Color(0xFF1B3519),
        subSections: [
          AppUtil.getServiceProvisionEventDateSection(
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF737373),
            sectionLabelColor: const Color(0xFF737373),
            inputFieldLabel: 'Referral Service On',
            formSectionLabel: 'Referral Service Date',
            firstDate: enrollmentDate,
          ),
          FormSection(
            name: 'Referral Service Delivery Mode',
            color: const Color(0xFF737373),
            inputFields: [
              InputField(
                id: 'qAed23reDPP',
                name: 'Services Referred for at',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: 'Facility', name: 'Facility'),
                  InputFieldOption(code: 'Community', name: 'Community'),
                ],
              )
            ],
          ),
          FormSection(
            id: 'SeRefoCo',
            name: 'Service referred for at Community',
            color: const Color(0xFF1B3519),
            inputFields: [
              InputField(
                  id: 'LLWTHwhnch0',
                  name: 'Service Category at community',
                  valueType: 'TEXT',
                  inputColor: const Color(0xFF4B9F46),
                  labelColor: const Color(0xFF737373),
                  options: [
                    InputFieldOption(
                        code: 'Clinical Services', name: 'Clinical Services'),
                    InputFieldOption(
                        code: 'Post abuse case management',
                        name: 'Post abuse case management'),
                    InputFieldOption(
                        code: 'Social Services', name: 'Social Services'),
                  ]),
              InputField(
                id: 'rsh5Kvx6qAU',
                name: 'Type of service at community',
                translatedName: 'Litšebeletso tseo a fetisetsoang ho tsona',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'STI Screening',
                      name: 'STI Screening',
                      translatedName: 'Tlhahlobo ea mafu a likobo'),
                  InputFieldOption(
                      code: 'STI Treatment',
                      name: 'STI Treatment',
                      translatedName: 'Kalafo ea  mafu a likobo'),
                  InputFieldOption(
                      code: 'HIV Testing and counselling',
                      name: 'HIV Testing and counselling',
                      translatedName: 'Tlhahlobo le tlhabollo ea HIV'),
                  InputFieldOption(
                      code: 'Evaluation for ARVs/HAART',
                      name: 'Evaluation for ARVs/HAART',
                      translatedName: 'Tlhahlobo ea ho qala Li-ARV '),
                  InputFieldOption(
                      code: 'Post abuse case management',
                      name: 'Post abuse case management'),
                  InputFieldOption(
                      code: 'ART and Adherence',
                      name: 'ART and Adherence',
                      translatedName:
                          'Kalafo le tiisetso ea li-ARV batho ba phelang le HIV'),
                  InputFieldOption(
                      code: 'PMTCT Services',
                      name: 'PMTCT Services',
                      translatedName:
                          'Thibelo ea phetisetso ea tšoaetso ho tloha ho ’ma ho ea leseeng'),
                  InputFieldOption(
                      code: 'Cervical Cancer Screening',
                      name: 'Cervical Cancer Screening'),
                  InputFieldOption(code: 'ECD', name: 'ECD'),
                  InputFieldOption(
                      code: 'FamilyPlanningSRH',
                      name: 'Family planning/SRH',
                      translatedName: 'Thero ea malapa/SRH'),
                  InputFieldOption(
                      code: 'Condom supply',
                      name: 'Condom supply',
                      translatedName: 'Phano ea likhohlopo'),
                  InputFieldOption(
                      code: 'TB screening',
                      name: 'TB screening',
                      translatedName: 'Tlhahlobo ea lefuba '),
                  InputFieldOption(
                      code: 'TB treatment',
                      name: 'TB treatment',
                      translatedName: 'Kalafo ea lefuba'),
                  InputFieldOption(
                      code: 'Nutrition',
                      name: 'Nutrition',
                      translatedName: 'Phepo e nepahetseng'),
                  InputFieldOption(code: 'HTS', name: 'HTS'),
                  InputFieldOption(code: 'ANC', name: 'ANC'),
                  InputFieldOption(
                      code: 'VMMC',
                      name: 'VMMC',
                      translatedName:
                          'Ho tlosoa ha karoloana ea letlalo la botona ka boithaopo'),
                  InputFieldOption(code: 'EID Testing', name: 'EID Testing'),
                  InputFieldOption(code: 'PrEP/PEP', name: 'PrEP/PEP'),
                  InputFieldOption(code: 'PMTCT', name: 'PMTCT'),
                  InputFieldOption(
                      code: 'Treatment Support (TB/ARV)',
                      name: 'Treatment Support (TB/ARV)'),
                  InputFieldOption(
                      code: 'Youth friendly services',
                      name: 'Youth friendly services',
                      translatedName: 'Litšebeletsong tsa bacha '),
                  InputFieldOption(
                      code: 'Gender Based Violence',
                      name: 'Gender Based Violence'),
                  InputFieldOption(
                      code: 'Domestic Violence Support group',
                      name: 'Domestic Violence Support group',
                      translatedName:
                          'Sehlopha sa tšehetso ea ba hlekefetsoang ka malapeng'),
                  InputFieldOption(
                      code: 'Income generating activity',
                      name: 'Income generating activity',
                      translatedName: 'Mekhoa ea boipheliso'),
                  InputFieldOption(
                      code: 'Orphan Care & Support',
                      name: 'Orphan Care & Support',
                      translatedName: 'Tlhokomelo le tšehetso ea likhutsana'),
                  InputFieldOption(
                      code: 'Psycho-social Support',
                      name: 'Psycho-social Support',
                      translatedName: 'Tšehetso maikutlong'),
                  InputFieldOption(
                      code: 'PLHIV support group',
                      name: 'PLHIV support group',
                      translatedName: 'Sehlopha sa tšehetso ea '),
                  InputFieldOption(
                      code: 'Referral to post abuse care services',
                      name: 'Referral to post abuse care services'),
                  InputFieldOption(
                      code: 'Violence Against Children',
                      name: 'Violence Against Children'),
                  InputFieldOption(code: 'CAG', name: 'CAG'),
                  InputFieldOption(
                      code: 'Home based care visits',
                      name: 'Home based care visits',
                      translatedName:
                          'Tlhokomelo/ts’ebeletso e fanoang malapeng'),
                  InputFieldOption(
                      code: 'Educational and vocational support',
                      name: 'Educational and vocational support'),
                  InputFieldOption(
                      code: 'Social grants', name: 'Social grants'),
                ],
              ),
              InputField(
                id: 'ubB83OWNWsv',
                name: 'Service Provider/Referred Organization at community',
                valueType: 'ORGANISATION_UNIT',
                showCountryLevelTree: true,
                allowedSelectedLevels: [
                  AppHierarchyReference.communityLevel,
                  AppHierarchyReference.facilityLevel
                ],
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'WHktsYoFqat',
                name: 'Comments on referral at community',
                translatedName: 'Lebitso la setsi seo a fetisetsoang ho sona',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: 'SeRefoFa',
            name: 'Service referred for at Facility',
            translatedName: 'Tsebeletso e fetiselitsoeng setsing',
            color: const Color(0xFF1B3519),
            inputFields: [
              InputField(
                id: 'AuCryxQYmrk',
                name: 'Service Category at facility',
                translatedName: 'Mokhahlelo oa litsebeletso setsing sa bophelo',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'Clinical Services', name: 'Clinical Services'),
                  InputFieldOption(
                      code: 'Post abuse case management',
                      name: 'Post abuse case management'),
                  InputFieldOption(
                      code: 'Social Services', name: 'Social Services'),
                ],
              ),
              InputField(
                id: 'OrC9Bh2bcFz',
                name: 'Type of service at facility',
                translatedName: 'Litšebeletso tseo a fetisetsoang ho tsona',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(
                      code: 'STI Screening',
                      name: 'STI Screening',
                      translatedName: 'Tlhahlobo ea mafu a likobo'),
                  InputFieldOption(
                      code: 'STI Treatment',
                      name: 'STI Treatment',
                      translatedName: 'Kalafo ea  mafu a likobo'),
                  InputFieldOption(
                      code: 'HIV Testing and counselling',
                      name: 'HIV Testing and counselling',
                      translatedName: 'Tlhahlobo le tlhabollo ea HIV'),
                  InputFieldOption(
                      code: 'Evaluation for ARVs/HAART',
                      name: 'Evaluation for ARVs/HAART',
                      translatedName: 'Tlhahlobo ea ho qala Li-ARV '),
                  InputFieldOption(
                      code: 'Post abuse case management',
                      name: 'Post abuse case management'),
                  InputFieldOption(
                      code: 'ART and Adherence',
                      name: 'ART and Adherence',
                      translatedName:
                          'Kalafo le tiisetso ea li-ARV batho ba phelang le HIV'),
                  InputFieldOption(
                      code: 'PMTCT Services',
                      name: 'PMTCT Services',
                      translatedName:
                          'Thibelo ea phetisetso ea tšoaetso ho tloha ho ’ma ho ea leseeng'),
                  InputFieldOption(
                      code: 'Cervical Cancer Screening',
                      name: 'Cervical Cancer Screening'),
                  InputFieldOption(code: 'ECD', name: 'ECD'),
                  InputFieldOption(
                      code: 'FamilyPlanningSRH',
                      name: 'Family planning/SRH',
                      translatedName: 'Thero ea malapa '),
                  InputFieldOption(
                      code: 'Condom supply',
                      name: 'Condom supply',
                      translatedName: 'Phano ea likhohlopo'),
                  InputFieldOption(
                      code: 'TB screening',
                      name: 'TB screening',
                      translatedName: 'Tlhahlobo ea lefuba '),
                  InputFieldOption(
                      code: 'TB treatment',
                      name: 'TB treatment',
                      translatedName: 'Kalafo ea lefuba'),
                  InputFieldOption(
                      code: 'Nutrition',
                      name: 'Nutrition',
                      translatedName: 'Phepo e nepahetseng'),
                  InputFieldOption(code: 'HTS', name: 'HTS'),
                  InputFieldOption(code: 'ANC', name: 'ANC'),
                  InputFieldOption(
                      code: 'VMMC',
                      name: 'VMMC',
                      translatedName:
                          'Ho tlosoa ha karoloana ea letlalo la botona ka boithaopo'),
                  InputFieldOption(code: 'EID Testing', name: 'EID Testing'),
                  InputFieldOption(code: 'PrEP/PEP', name: 'PrEP/PEP'),
                  InputFieldOption(code: 'PMTCT', name: 'PMTCT'),
                  InputFieldOption(
                      code: 'Treatment Support (TB/ARV)',
                      name: 'Treatment Support (TB/ARV)'),
                  InputFieldOption(
                      code: 'Youth friendly services',
                      name: 'Youth friendly services',
                      translatedName: 'Litšebeletsong tsa bacha '),
                  InputFieldOption(
                      code: 'Gender Based Violence',
                      name: 'Gender Based Violence'),
                  InputFieldOption(
                      code: 'Domestic Violence Support group',
                      name: 'Domestic Violence Support group',
                      translatedName:
                          'Sehlopha sa tšehetso ea ba hlekefetsoang ka malapeng'),
                  InputFieldOption(
                      code: 'Income generating activity',
                      name: 'Income generating activity',
                      translatedName: 'Mekhoa ea boipheliso'),
                  InputFieldOption(
                      code: 'Orphan Care & Support',
                      name: 'Orphan Care & Support',
                      translatedName: 'Tlhokomelo le tšehetso ea likhutsana'),
                  InputFieldOption(
                      code: 'Psycho-social Support',
                      name: 'Psycho-social Support',
                      translatedName: 'Tšehetso maikutlong'),
                  InputFieldOption(
                      code: 'PLHIV support group',
                      name: 'PLHIV support group',
                      translatedName: 'Sehlopha sa tšehetso ea '),
                  InputFieldOption(
                      code: 'Referral to post abuse care services',
                      name: 'Referral to post abuse care services'),
                  InputFieldOption(
                      code: 'Violence Against Children',
                      name: 'Violence Against Children'),
                  InputFieldOption(code: 'CAG', name: 'CAG'),
                  InputFieldOption(
                      code: 'Home based care visits',
                      name: 'Home based care visits',
                      translatedName:
                          'Tlhokomelo/ts’ebeletso e fanoang malapeng'),
                  InputFieldOption(
                      code: 'Educational and vocational support',
                      name: 'Educational and vocational support'),
                  InputFieldOption(
                      code: 'Social grants', name: 'Social grants'),
                ],
              ),
              InputField(
                id: 'jOXN2iPhkxj',
                name: 'Service Provider/Referred Organization at facility',
                translatedName: 'Lebitso la setsi seo a fetisetsoang ho sona',
                valueType: 'ORGANISATION_UNIT',
                showCountryLevelTree: true,
                allowedSelectedLevels: [
                  AppHierarchyReference.communityLevel,
                  AppHierarchyReference.facilityLevel
                ],
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'iifSkIcBZz2',
                name: 'Comments on referral at facility',
                translatedName: 'Maikutlo ka phetisetso setsing sa bophelo',
                valueType: 'LONG_TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
            ],
          ),
          FormSection(
            id: 'CoReOr',
            name: 'Completed by the Referring Organization',
            translatedName: 'E tlatsoa ke mokhatlo o fetisang',
            color: const Color(0xFF1B3519),
            inputFields: [
              InputField(
                id: 'tRvDAZxam3P',
                name: 'Name of next of kin',
                translatedName:
                    'Lebitso la motho eo mosebeletsuoa a ikarabellang/fumanang tshehetso ho eena',
                valueType: 'TEXT',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
              InputField(
                id: 'qCu2f4kEfzW',
                name: 'Phone Number of next of kin',
                translatedName:
                    'Fono ea motho eo mosebeletsuoa a ikarabellang/fumanang tshehetso ho eena',
                valueType: 'PHONE_NUMBER',
                inputColor: const Color(0xFF4B9F46),
                labelColor: const Color(0xFF737373),
              ),
            ],
          )
        ],
      )
    ];
  }
}
