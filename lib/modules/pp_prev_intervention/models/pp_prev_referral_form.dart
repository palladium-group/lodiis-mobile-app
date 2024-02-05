import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class PpPrevReferralForm {
  static List<String> getMandatoryField() {
    return [
      'k3nt1Qkxat0',
      'IEdBgx4vn1J',
      'h4PRnqfEOCL',
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        name: "Referral form",
        translatedName: 'Foromo ea phetisetso',
        color: const Color(0xFF9B2BAE),
        inputFields: [
          InputField(
            id: 'IEdBgx4vn1J',
            name: 'Referral Services',
            translatedName: 'Phetisetso ea Lits’ebeletso',
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'HTS',
                name: 'HTS',
              ),
              InputFieldOption(
                code: 'PrEP',
                name: 'PrEP',
              ),
              InputFieldOption(
                code: 'FP_SRH',
                name: 'FP/SRH',
              ),
              InputFieldOption(
                code: 'PostViolenceCare',
                name: 'Post Violence Care',
              ),
              InputFieldOption(
                code: 'STIScreening',
                name: 'STI Screening',
              ),
              InputFieldOption(
                code: 'VMMC',
                name: 'VMMC',
              ),
            ],
          ),
          InputField(
            id: 'OIUDljKyNgy',
            name: 'Date of referral',
            translatedName: 'Letsatsi la Phetisetso',
            valueType: 'DATE',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'h4PRnqfEOCL',
            name: 'Referral Point',
            translatedName: 'Sebaka sa phetisetso',
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'EGPAF',
                name: 'EGPAF',
              ),
              InputFieldOption(
                code: 'JHPIEGO',
                name: 'JHPIEGO',
              ),
              InputFieldOption(
                code: 'CoHIP SEC',
                name: 'CoHIP SEC',
              ),
              InputFieldOption(
                code: 'Other',
                name: 'Other',
              ),
            ],
          ),
          InputField(
            id: 'ud6oZeP3SKv',
            name: 'Specify other',
            translatedName: 'Hlalosa tse ling',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            valueType: 'TEXT',
          ),
          InputField(
            id: 'k3nt1Qkxat0',
            name: 'Location',
            translatedName: 'Setsi kapa council ea phetisetso',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            valueType: 'ORGANISATION_UNIT',
            showCountryLevelTree: true,
            allowedSelectedLevels: [
              AppHierarchyReference.communityLevel,
              AppHierarchyReference.facilityLevel
            ],
          ),
        ],
      ),
    ];
  }
}
