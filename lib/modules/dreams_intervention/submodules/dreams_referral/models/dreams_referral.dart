import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_common_constant.dart';

class DreamsReferral {
  static List<String> getMandatoryFields() {
    return ['qAed23reDPP', 'y0bvausyTyh', 'jOXN2iPhkxj', 'ubB83OWNWsv'];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: 'Service Referral',
          color: const Color(0xFF737373),
          subSections: [
            FormSection(
              name: 'Referral Service Delivery Mode',
              color: const Color(0xFF737373),
              inputFields: [
                InputField(
                    id: 'qAed23reDPP',
                    name: 'Services Referred for at',
                    valueType: 'TEXT',
                    inputColor: AgywDreamsCommonConstant.defaultColor,
                    labelColor: const Color(0xFF737373),
                    options: [
                      InputFieldOption(code: 'Facility', name: 'Facility'),
                      InputFieldOption(code: 'Community', name: 'Community'),
                    ]),
                InputField(
                    id: 'y0bvausyTyh',
                    name: 'Implementing partner',
                    translatedName: 'Basebetsi mmoho',
                    valueType: 'TEXT',
                    inputColor: AgywDreamsCommonConstant.defaultColor,
                    labelColor: const Color(0xFF737373),
                    options: [
                      InputFieldOption(
                        code: 'EGPAF',
                        name: 'EGPAF',
                      ),
                      InputFieldOption(
                        code: 'M2M',
                        name: 'M2M',
                      ),
                      InputFieldOption(
                        code: 'JHPIEGO',
                        name: 'JHPIEGO',
                      ),
                      InputFieldOption(
                        code: 'KB-AGYW/DREAMS',
                        name: 'KB-AGYW/DREAMS',
                      ),
                      InputFieldOption(
                        code: 'CoHIP SEC',
                        name: 'CoHIP SEC',
                      ),
                    ])
              ],
            ),
            FormSection(
                id: 'SeRefoCo',
                name: 'Service referred for at Community',
                color: const Color(0xFF737373),
                inputFields: [
                  InputField(
                      id: 'LLWTHwhnch0',
                      name: 'Service Category at community',
                      valueType: 'TEXT',
                      inputColor: AgywDreamsCommonConstant.defaultColor,
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code: 'Clinical Services',
                            name: 'Clinical Services'),
                        InputFieldOption(
                            code: 'GenderBasedViolence',
                            name: 'Gender Based Violence'),
                        InputFieldOption(
                            code: 'EconomicStrengtheningActivities',
                            name: 'Economic Strengthening Activities'),
                        InputFieldOption(
                            code: 'LifeSkillSocialAssetServices',
                            name: 'Life-skill & Social Asset Services'),
                      ]),
                  InputField(
                      id: 'rsh5Kvx6qAU',
                      name: 'Type of service at community',
                      valueType: 'TEXT',
                      inputColor: AgywDreamsCommonConstant.defaultColor,
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code: 'STI Screening', name: 'STI Screening'),
                        InputFieldOption(
                            code: 'STI Treatment', name: 'STI Treatment'),
                        InputFieldOption(
                            code: 'ARTInitiation', name: 'ART Initiation'),
                        InputFieldOption(
                            code: 'Cervical Cancer Screening',
                            name: 'Cervical Cancer Screening'),
                        InputFieldOption(
                            code: 'FamilyPlanningSRH',
                            name: 'Family planning/SRH',
                            translatedName: 'Thero ea malapa/SRH'),
                        InputFieldOption(
                            code: 'CondomEducationProvision',
                            name: 'Condom Education/Provision'),
                        InputFieldOption(
                            code: 'ViolencePreventionEducation',
                            name: 'Violence Prevention Education (GBV/VAC)',
                            translatedName:
                                'Thuto ea Thibelo ea tlhekefetso  (GBV/VAC)'),
                        InputFieldOption(
                            code: 'ComprehensiveEconomicStrengthening',
                            name: 'Comprehensive Economic Strengthening'),
                        InputFieldOption(
                            code: 'HIVPreventionEducation',
                            name: 'HIV Prevention Education',
                            translatedName: 'Thuto ea Thibelo ea HIV'),
                        InputFieldOption(
                            code: 'ParentingPregBreastfeeding',
                            name: 'Parenting (Preg & Breastfeeding)'),
                        InputFieldOption(
                            code: 'EducationSubsidiesSupport',
                            name: 'Education Subsidies/support'),
                        InputFieldOption(
                            code: 'TB screening', name: 'TB screening'),
                        InputFieldOption(code: 'HTS', name: 'HTS'),
                        InputFieldOption(code: 'ANC', name: 'ANC'),
                        InputFieldOption(code: 'PrEP', name: 'PrEP'),
                        InputFieldOption(code: 'EMTCT', name: 'EMTCT'),
                        InputFieldOption(
                            code: 'Treatment Support (TB/ARV)',
                            name: 'Treatment Support (TB/ARV)'),
                        InputFieldOption(
                            code: 'PostGBVServicesClinical',
                            name: 'Post GBV Services (clinical)'),
                        InputFieldOption(
                            code: 'PostGBVCareLegal',
                            name: 'Post GBV Care (legal)'),
                        InputFieldOption(
                            code: 'HIVRiskAssessment',
                            name: 'HIV Risk Assessment',
                            translatedName: 'Tlhahlobo ea Kotsi ea HIV'),
                        InputFieldOption(
                            code: 'Aflateen/toun', name: 'Aflateen/toun'),
                        InputFieldOption(code: 'Go Girls', name: 'Go Girls'),
                        InputFieldOption(code: 'SILC', name: 'SILC'),
                        InputFieldOption(code: 'LBSE', name: 'LBSE'),
                        InputFieldOption(
                            code: 'FinancialLiteracyEducation',
                            name: 'Financial Literacy (Education)'),
                        InputFieldOption(
                            code: 'SAVING GROUPS', name: 'SAVING GROUPS'),
                        InputFieldOption(code: 'PEP', name: 'PEP'),
                        InputFieldOption(
                          code: 'Parenting',
                          name: 'Parenting for caregivers',
                        ),
                      ]),
                  InputField(
                    id: 'ubB83OWNWsv',
                    name: 'Service Provider/Referred Organization at community',
                    valueType: 'ORGANISATION_UNIT',
                    showCountryLevelTree: true,
                    allowedSelectedLevels: [
                      AppHierarchyReference.communityLevel
                    ],
                    inputColor: AgywDreamsCommonConstant.defaultColor,
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                    id: 'WHktsYoFqat',
                    name: 'Comments on referral at community',
                    valueType: 'LONG_TEXT',
                    inputColor: AgywDreamsCommonConstant.defaultColor,
                    labelColor: const Color(0xFF737373),
                  ),
                ]),
            FormSection(
                id: 'SeRefoFa',
                name: 'Service referred for at Facility',
                color: const Color(0xFF737373),
                inputFields: [
                  InputField(
                      id: 'AuCryxQYmrk',
                      name: 'Service Category at facility',
                      valueType: 'TEXT',
                      inputColor: AgywDreamsCommonConstant.defaultColor,
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code: 'Clinical Services',
                            name: 'Clinical Services'),
                        InputFieldOption(
                            code: 'GenderBasedViolence',
                            name: 'Gender Based Violence'),
                        InputFieldOption(
                            code: 'EconomicStrengtheningActivities',
                            name: 'Economic Strengthening Activities'),
                        InputFieldOption(
                            code: 'LifeSkillSocialAssetServices',
                            name: 'Life-skill & Social Asset Services'),
                      ]),
                  InputField(
                      id: 'OrC9Bh2bcFz',
                      name: 'Type of service at facility',
                      valueType: 'TEXT',
                      inputColor: AgywDreamsCommonConstant.defaultColor,
                      labelColor: const Color(0xFF737373),
                      options: [
                        InputFieldOption(
                            code: 'STI Screening', name: 'STI Screening'),
                        InputFieldOption(
                            code: 'STI Treatment', name: 'STI Treatment'),
                        InputFieldOption(
                            code: 'ARTInitiation', name: 'ART Initiation'),
                        InputFieldOption(
                            code: 'Cervical Cancer Screening',
                            name: 'Cervical Cancer Screening'),
                        InputFieldOption(
                            code: 'FamilyPlanningSRH',
                            name: 'Family planning/SRH'),
                        InputFieldOption(
                            code: 'CondomEducationProvision',
                            name: 'Condom Education/Provision',
                            translatedName: 'Thuto/Phano ka Likhohlopo'),
                        InputFieldOption(
                          code: 'ViolencePreventionEducation',
                          name: 'Violence Prevention Education (GBV/VAC)',
                          translatedName:
                              'Thuto ea Thibelo ea tlhekefetso (GBV/VAC)',
                        ),
                        InputFieldOption(
                            code: 'ComprehensiveEconomicStrengthening',
                            name: 'Comprehensive Economic Strengthening'),
                        InputFieldOption(
                            code: 'HIVPreventionEducation',
                            name: 'HIV Prevention Education'),
                        InputFieldOption(
                            code: 'ParentingPregBreastfeeding',
                            name: 'Parenting (Preg & Breastfeeding)'),
                        InputFieldOption(
                            code: 'EducationSubsidiesSupport',
                            name: 'Education Subsidies/support'),
                        InputFieldOption(
                            code: 'TB screening', name: 'TB screening'),
                        InputFieldOption(code: 'HTS', name: 'HTS'),
                        InputFieldOption(code: 'ANC', name: 'ANC'),
                        InputFieldOption(code: 'PrEP', name: 'PrEP'),
                        InputFieldOption(code: 'EMTCT', name: 'EMTCT'),
                        InputFieldOption(
                            code: 'Treatment Support (TB/ARV)',
                            name: 'Treatment Support (TB/ARV)'),
                        InputFieldOption(
                            code: 'PostGBVServicesClinical',
                            name: 'Post GBV Services (clinical)'),
                        InputFieldOption(
                            code: 'PostGBVCareLegal',
                            name: 'Post GBV Care (legal)'),
                        InputFieldOption(
                            code: 'HIVRiskAssessment',
                            name: 'HIV Risk Assessment',
                            translatedName: 'Tlhahlobo ea Kotsi ea HIV'),
                        InputFieldOption(
                            code: 'Aflateen/toun', name: 'Aflateen/toun'),
                        InputFieldOption(code: 'Go Girls', name: 'Go Girls'),
                        InputFieldOption(code: 'SILC', name: 'SILC'),
                        InputFieldOption(code: 'LBSE', name: 'LBSE'),
                        InputFieldOption(
                            code: 'FinancialLiteracyEducation',
                            name: 'Financial Literacy (Education)'),
                        InputFieldOption(
                            code: 'SAVING GROUPS', name: 'SAVING GROUPS'),
                        InputFieldOption(code: 'PEP', name: 'PEP'),
                        InputFieldOption(
                          code: 'Parenting',
                          name: 'Parenting for caregivers',
                        ),
                      ]),
                  InputField(
                    id: 'jOXN2iPhkxj',
                    name: 'Service Provider/Referred Organization at facility',
                    valueType: 'ORGANISATION_UNIT',
                    showCountryLevelTree: true,
                    allowedSelectedLevels: [
                      AppHierarchyReference.facilityLevel
                    ],
                    inputColor: AgywDreamsCommonConstant.defaultColor,
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                    id: 'iifSkIcBZz2',
                    name: 'Comments on referral at facility',
                    valueType: 'LONG_TEXT',
                    inputColor: AgywDreamsCommonConstant.defaultColor,
                    labelColor: const Color(0xFF737373),
                  ),
                ]),
            FormSection(
                name: 'Completed by the Referring Organization',
                color: const Color(0xFF737373),
                inputFields: [
                  InputField(
                    id: 'tRvDAZxam3P',
                    name: 'Name of next of kin',
                    valueType: 'TEXT',
                    inputColor: AgywDreamsCommonConstant.defaultColor,
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                    id: 'qCu2f4kEfzW',
                    name: 'Phone Number of next of kin',
                    valueType: 'PHONE_NUMBER',
                    inputColor: AgywDreamsCommonConstant.defaultColor,
                    labelColor: const Color(0xFF737373),
                  ),
                ])
          ])
    ];
  }
}
