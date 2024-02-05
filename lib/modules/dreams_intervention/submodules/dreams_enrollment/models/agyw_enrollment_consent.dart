import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_enrollment_constant.dart';

class AgywEnrollmentConcent {
  static List<String> getMandatoryField() {
    return [
      'location',
      'z2YcxWJ0g35',
      'fPtxDcL7A3X',
      'n85SOIP68bN',
      'e13nmWOsicM',
      'EsrJ2dgIMHY'
    ];
  }

  static List<FormSection> getFormSections({
    List<int> allowedSelectedLevels = const [
      AppHierarchyReference.communityLevel,
      AppHierarchyReference.facilityLevel
    ],
  }) {
    return [
      FormSection(
          name: 'Consent',
          translatedName: 'Tumellano',
          color: const Color(0xFF258DCC),
          inputFields: [
            InputField(
                id: 'location',
                name: 'Location',
                translatedName: 'Sebaka',
                valueType: 'ORGANISATION_UNIT',
                allowedSelectedLevels: allowedSelectedLevels,
                filteredPrograms: [AgywDreamsEnrollmentConstant.program],
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'z2YcxWJ0g35',
                name: 'Would you allow me to talk to the AGYW in privacy?',
                translatedName:
                    'Na u lumela hore ke botse mocha lipotso lekunutung?',
                valueType: 'TEXT',
                renderAsRadio: true,
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'fPtxDcL7A3X',
                name: 'Do you agree to participate in this assessment?',
                translatedName:
                    'Na u lumela ho hloauoa ho kena lenaneng la DREAMS?',
                valueType: 'TEXT',
                renderAsRadio: true,
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373),
                options: [
                  InputFieldOption(code: '1', name: 'Yes', translatedName: 'E'),
                  InputFieldOption(
                      code: '0', name: 'No', translatedName: 'Che'),
                  InputFieldOption(
                      code: '0.000001', name: 'NA', translatedName: 'N/A')
                ]),
            InputField(
                id: 'n85SOIP68bN',
                name:
                    'I have read and I understand the provided information and have had the opportunity to ask questions.',
                translatedName:
                    'Ke balile le ho utloisisa litaba tseo ke li fuoeng mme ke bile le monyetla oa ho botsa lipotso.',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'e13nmWOsicM',
                name:
                    'I understand that my participation is voluntary and that I am free to withdraw at any time, without giving a reason and without cost.',
                translatedName:
                    'Kea utloisisa hore ho nka karolo hoaka ke boithaopo mme nka ikhula neng kapa neng ke sa fane le ka mabaka.',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'EsrJ2dgIMHY',
                name:
                    'I voluntarily agree to take part in the assessment and enrollment process.',
                translatedName:
                    'Ke lumela ka boithaopo ho nka karolo tsebetsong ena.',
                description: 'Ensure you have documented AGYW consent on file.',
                translatedDescription:
                    'Netefatsa hore o ngotse tumello ea AGYW faeleng.',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373))
          ]),
    ];
  }
}
