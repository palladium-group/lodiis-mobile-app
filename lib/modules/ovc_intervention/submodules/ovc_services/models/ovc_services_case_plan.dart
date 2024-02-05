import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

class OvcServicesCasePlan {
  static List<String> getMandatoryField() {
    return [
      OvcCasePlanConstant.houseHoldCategorizationDataElement,
      "eventDate"
    ];
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      AppUtil.getServiceProvisionEventDateSection(
        id: OvcCasePlanConstant.casePlanEventDateSectionId,
        inputColor: const Color(0xFF4A9F46),
        labelColor: const Color(0xFF737373),
        sectionLabelColor: const Color(0xFF4D9E49),
        firstDate: firstDate,
        formSectionLabel: 'Case Plan Date',
        inputFieldLabel: 'Case Plan on',
      ),
      FormSection(
        name: 'Household Categorization',
        color: const Color(0xFF4D9E49),
        id: OvcCasePlanConstant.householdCategorizationSection,
        inputFields: [
          InputField(
            id: OvcCasePlanConstant.houseHoldCategorizationDataElement,
            name: 'Household categorization/prioritization',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4A9F46),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Red: HH visited/monitored regularly',
                name: 'Red: HH visited/monitored regularly',
              ),
              InputFieldOption(
                code: 'Yellow: HH visited/monitored monthly',
                name: 'Yellow: HH visited/monitored monthly',
              ),
              InputFieldOption(
                code: 'Green: HH visited/monitored quarterly',
                name: 'Green: HH visited/monitored quarterly',
              ),
            ],
          )
        ],
      ),
      FormSection(
        name: 'DOMAIN HEALTH',
        translatedName: 'BOPHELO BO BOTLE',
        id: 'Health',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'ADc3clrQRl4',
            name: 'Goal 1',
            translatedName: 'Sepheo 1',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4A9F46),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'KnowledgeableAboutHIVEducation',
                name: 'Knowledgeable about HIV education',
                translatedName: 'Tsebo ka thuto ea HIV',
              ),
              InputFieldOption(
                code: 'To adhere to ART',
                name: 'To adhere to ART',
              ),
              InputFieldOption(
                code: 'Proper nutrition for my children',
                name: 'Proper nutrition for my children',
                translatedName: 'Phepo e nepahetseng bakeng sa bana ba ka',
              ),
              InputFieldOption(
                code: 'Access to PMTCT services',
                name: 'Access to PMTCT services',
                translatedName: 'Ho fihlella litšebeletso tsa PMTCT',
              ),
            ],
          ),
          InputField(
            id: 'efNgDIqhlNs',
            name: 'Goal 2',
            translatedName: 'Sepheo 2',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4A9F46),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'KnowledgeableAboutHIVEducation',
                name: 'Knowledgeable about HIV education',
                translatedName: 'Tsebo ka thuto ea HIV',
              ),
              InputFieldOption(
                code: 'To adhere to ART',
                name: 'To adhere to ART',
              ),
              InputFieldOption(
                code: 'Proper nutrition for my children',
                name: 'Proper nutrition for my children',
                translatedName: 'Phepo e nepahetseng bakeng sa bana ba ka',
              ),
              InputFieldOption(
                code: 'Access to PMTCT services',
                name: 'Access to PMTCT services',
                translatedName: 'Ho fihlella litšebeletso tsa PMTCT',
              ),
            ],
          ),
        ],
      ),
      FormSection(
        id: 'Stable',
        name: 'DOMAIN STABLE',
        translatedName: 'BOTSITSO',
        color: const Color(0xFF0000FF),
        borderColor: const Color(0xFF0000FF),
        inputFields: [
          InputField(
            id: 'ADc3clrQRl4',
            name: 'Goal 1',
            translatedName: 'Sepheo 1',
            valueType: 'TEXT',
            inputColor: const Color(0xFF0000FF),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Knowledgeable about food security',
                name: 'Knowledgeable about food security',
                translatedName: 'Tsebo ka tshireletso le paballo ea lijo',
              ),
              InputFieldOption(
                code: 'Learn about food production and preservation',
                name: 'Learn about food production and preservation',
                translatedName: 'Ithute ka tshireletso le paballo ea lijo',
              ),
              InputFieldOption(
                code: 'To improve my family financial status',
                name: 'To improve my family financial status',
                translatedName:
                    'Ho ntlafatsa boema ba lichelete lelapeng la ka.',
              ),
            ],
          ),
          InputField(
            id: 'efNgDIqhlNs',
            name: 'Goal 2',
            translatedName: 'Sepheo 2',
            valueType: 'TEXT',
            inputColor: const Color(0xFF0000FF),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Knowledgeable about food security',
                name: 'Knowledgeable about food security',
                translatedName: 'Tsebo ka tshireletso le paballo ea lijo',
              ),
              InputFieldOption(
                code: 'Learn about food production and preservation',
                name: 'Learn about food production and preservation',
                translatedName: 'Ithute ka tshireletso le paballo ea lijo',
              ),
              InputFieldOption(
                code: 'To improve my family financial status',
                name: 'To improve my family financial status',
                translatedName:
                    'Ho ntlafatsa boema ba lichelete lelapeng la ka.',
              ),
            ],
          ),
        ],
      ),
      FormSection(
        id: 'Safe',
        name: 'DOMAIN SAFE',
        translatedName: 'TSIRELETSO',
        color: const Color(0xFF0F9587),
        borderColor: const Color(0xFF0F9587),
        inputFields: [
          InputField(
            id: 'ADc3clrQRl4',
            name: 'Goal 1',
            translatedName: 'Sepheo 1',
            valueType: 'TEXT',
            inputColor: const Color(0xFF0F9587),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Knowledgeable about VAC',
                name: 'Knowledgeable about VAC',
                translatedName: 'Tsebo ka VAC',
              ),
              InputFieldOption(
                code: 'Knowledgeable about child protection',
                name: 'Knowledgeable about child protection',
                translatedName: 'Tsebo ka tlhokomelo ea bana',
              ),
            ],
          ),
          InputField(
            id: 'efNgDIqhlNs',
            name: 'Goal 2',
            translatedName: 'Sepheo 2',
            valueType: 'TEXT',
            inputColor: const Color(0xFF0F9587),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Knowledgeable about VAC',
                name: 'Knowledgeable about VAC',
                translatedName: 'Tsebo ka VAC',
              ),
              InputFieldOption(
                code: 'Knowledgeable about child protection',
                name: 'Knowledgeable about child protection',
                translatedName: 'Tsebo ka tlhokomelo ea bana',
              ),
            ],
          ),
        ],
      ),
      FormSection(
        id: 'Schooled',
        name: 'DOMAIN SCHOOLED',
        translatedName: 'TSA SEKOLO',
        color: const Color(0xFF9B2BAE),
        borderColor: const Color(0xFF9B2BAE),
        inputFields: [
          InputField(
            id: 'ADc3clrQRl4',
            name: 'Goal 1',
            translatedName: 'Sepheo 1',
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Better school attendance and performance',
                name: 'Better school attendance and performance',
                translatedName: 'Ho kena sekol le ho sebetsa hantle',
              ),
              InputFieldOption(
                code: 'Equipped with social assets for better living',
                name: 'Equipped with social assets for better living',
                translatedName:
                    'Tsebo ka thepa ea sechaba bakeng sa bophelo bo betere.',
              ),
            ],
          ),
          InputField(
            id: 'efNgDIqhlNs',
            name: 'Goal 2',
            translatedName: 'Sepheo 2',
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Better school attendance and performance',
                name: 'Better school attendance and performance',
                translatedName: 'Ho kena sekol le ho sebetsa hantle',
              ),
              InputFieldOption(
                code: 'Equipped with social assets for better living',
                name: 'Equipped with social assets for better living',
                translatedName:
                    'Tsebo ka thepa ea sechaba bakeng sa bophelo bo betere.',
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
