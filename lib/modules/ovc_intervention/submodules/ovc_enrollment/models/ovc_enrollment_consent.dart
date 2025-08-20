import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';

class OvcEnrollmentConsent {
  static List<String> getMandatoryField() {
    return [
      'location',
      'enrollmentDate',
      'sCGr0RTmvJ7'
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(name: '', color: const Color(0xFF737373), inputFields: [
        InputField(
          id: 'location',
          name: 'Location',
          translatedName: 'Sebaka',
          valueType: 'ORGANISATION_UNIT',
          allowedSelectedLevels: [
            AppHierarchyReference.communityLevel,
            AppHierarchyReference.facilityLevel
          ],
          filteredPrograms: [
            OvcInterventionConstant.ovcProgramprogram,
            OvcInterventionConstant.caregiverProgram,
          ],
          inputColor: const Color(0xFF4B9F46),
          labelColor: const Color(0xFF737373),
        ),
        InputField(
          id: 'enrollmentDate',
          isReadOnly: false,
          inputColor: const Color(0xFF4B9F46),
          labelColor: const Color(0xFF737373),
          name: 'Date of Enrollment to Program',
          translatedName: "Letsatsi leo lelapa le keneng ka hara morero",
          valueType: 'DATE',
          allowFuturePeriod: false,
        ),

      ]),
      FormSection(
        name: 'Consent Statement',
        color: const Color(0xFF737373),
        description: '''
I understand the goal of the Bokamoso OVC program as supporting healthy lives of families and its potential benefits to my household.

My household agrees to regularly meet with a case management worker to:
• Discuss issues we face
• Set goals for our future
• Plan how to achieve those goals

This process is referred to as “case management.”

I allow our information to be stored in the m2m case management system. This means m2m will keep records about our participation and progress during case management in a safe place. Only authorized individuals and those bound by shared confidentiality agreements, will access this information.

I consent to the sharing and discussion of my household’s and children’s information with service providers (organizations/groups) for case conferencing. This will only occur on a need-to-know basis and with respect for confidentiality to help us achieve our goals.

I understand:
• I may withdraw this consent at any time.
• In life-threatening or emergency situations, our information may be shared with authorities even without my consent (e.g., health service denial or refusal to adhere to essential health services).
''',
        translatedDescription: '''
Mosebeletsi oa morero o oa bala: “Thepa ke lintho tse molemo li bile li le bohlokoa ho oena. 
Mohlala e ka ba batho hobane motho ka mong o na le litsebo, mahlale le litalenta tse itseng.”
''',
        inputFields: [],
      ),

      FormSection(
        name: 'Consent Confirmation',
        color: const Color(0xFF737373),
        inputFields: [
          InputField(
            id: 'sCGr0RTmvJ7',
            name: 'I am willing to participate in this program, and I understand that my participation is voluntary. I may withdraw my consent at any time without affecting my access to other community services.',
            translatedName: 'Na u ikemiselitse ho ba e mong oa bajalefa ba lenaneo lee?',
            valueType: 'BOOLEAN',
            labelColor: const Color(0xFF737373),
            inputColor: const Color(0xFF737373),
          ),
        ],
      )

    ];
  }
}
