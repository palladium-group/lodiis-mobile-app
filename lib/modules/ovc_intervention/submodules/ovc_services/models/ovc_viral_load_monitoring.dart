import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

import '../../../../../core/utils/app_util.dart';

class OvcViralLoadMonitoring {

  static List<String> getMandatoryFields() {

    return [
      'Yu00G1uhiYN',
      'RIpmBgYc0ZN',
      'uVmlqLmHYpD',
      'JgNSiXuArwl',
      'wEKBn2SdrmA',
      'FLI5NLYCqH9',
      'QkoJ1afnMMK',
      'IwM9O0a78QD',
      'WKdeD28Oyn7',
      'LaeDyUWYcoN',
      'YxJQ58njlLM',
    ];
  }

  static List<FormSection> getFormSections({
    required String enrollmentDate,
  }) {
    return [

      AppUtil.getServiceProvisionEventDateSection(
        inputColor: const Color(0xFF4A9F46),
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: const Color(0xFF4A9F46),
        formSectionLabel: 'VL Monitoring Date',
        inputFieldLabel: 'VL Monitoring On',
        firstDate: enrollmentDate,
      ),
      FormSection(
        name: 'Viral Load Monitoring Form',
        color: const Color(0xFF4B9F46),
        borderColor: const Color(0xFF4B9F46),
        inputFields: [
          InputField(
            id: 'Yu00G1uhiYN',
            name: 'Name of FBSW',
            translatedName: 'Lebetso la mosebeletsi oa sechaba',
            isReadOnly: true,
            valueType: 'TEXT',
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),

          ),
          InputField(
            id: 'QInz3UAj6zC',
            name: 'ART CARD: Date of ART Initiation',
            valueType: 'DATE',
            allowFuturePeriod: true,
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),
          ),
          InputField(
            id: 'JgNSiXuArwl',
            name: 'ART CARD ART Number',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),
          ),
          InputField(
            id: 'wEKBn2SdrmA',
            name: 'ART CARD Facility Obtaining ART',
            valueType: 'ORGANISATION_UNIT',
            showCountryLevelTree: true,
            allowedSelectedLevels: [AppHierarchyReference.facilityLevel],
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),
          ),

          InputField(
            id: 'FLI5NLYCqH9',
            name: 'ART CARD Eligible for VL?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),
          ),
          InputField(
            id: 'QkoJ1afnMMK',
            name: 'ART CARD: Reason for VL Non-Eligibility',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),
          ),
          InputField(
            id: 'IwM9O0a78QD',
            name: 'ART CARD: VL Results',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),
            sortOptions: false,
            options: [
              InputFieldOption(
                code: '<50 Copies',
                name: '<50 Copies (suppressed and undetectable)',
              ),
              InputFieldOption(
                code: '51 - 999 Copies',
                name: '51 - 999 Copies (suppressed and detectable) ',
              ),
              InputFieldOption(
                code: '>=1000 Copies',
                name: '≥1000 Copies (unsuppressed and detectable)',
              ),
              InputFieldOption(
                code: 'Pending',
                name: 'Pending',
              ),
            ],
          ),
          InputField(
            id: 'WKdeD28Oyn7',
            name: 'ART CARD: Date of VL',
            valueType: 'DATE',
            allowFuturePeriod: true,
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),
          ),

          InputField(
            id: 'LaeDyUWYcoN',
            name: 'MMD',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),
            sortOptions: false,
            options: [
              InputFieldOption(
                  code: '<3 Months',
                  name: '<3 Months',
                  translatedName: 'Likhoeli tse 3'),
              InputFieldOption(
                code: '3-5 Months',
                name: '3-5 Months',
              ),
              InputFieldOption(
                  code: '>=6 Months',
                  name: '≥6 Months',
                  translatedName: 'Likhoeli tse 6'),
            ],
          ),
          InputField(
            id: 'yWE2jEJxMdB',
            name: 'Reason not on MMD',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),
          ),
          InputField(
            id: 'YxJQ58njlLM',
            name: 'Specify Other',
            translatedName: 'Hlalosa tse ling',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4B9F46),
            labelColor: const Color(0xFF1A3518),
          ),
        ],
      )
    ];
  }
}
