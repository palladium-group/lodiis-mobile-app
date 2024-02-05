import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class PpPrevReferralOutcomeForm {
  static List<String> getMandatoryField() {
    return [
      'hXyqgOWZ17b',
    ];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        name: "Referral outcome form",
        translatedName: 'Foromo ea sephetho sa phetiso',
        color: const Color(0xFF9B2BAE),
        inputFields: [
          InputField(
            id: 'hXyqgOWZ17b',
            name: 'Referral service provided?',
            translatedName: 'Ho fanoe ka litšebeletso tsa phetisetso?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'lvT9gfpHIlT',
            name: 'Date service was provided',
            translatedName: "Letsatsi leo ts'ebeletso e fanoeng ka lona",
            valueType: 'DATE',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'gEjigBuBTmh',
            name: 'Reasons for rejecting/declining service(s) offered',
            translatedName: 'Mabaka a ho hana litšebeletso tse fanoang',
            valueType: 'TEXT',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                  code: 'Religion/Culture',
                  name: 'Religion/Culture',
                  translatedName: 'Bolumeli/Setso'),
              InputFieldOption(
                  code: 'Service already provided',
                  name: 'Service already provided (by other provider)',
                  translatedName:
                      "Ts'ebeletso e se e fanoe (ke mofani e mong)"),
              InputFieldOption(
                code: 'NotReady',
                name: 'Not Ready',
              ),
              InputFieldOption(
                  code: 'HealthConcerns',
                  name: 'Health Concerns',
                  translatedName: 'Matšoenyeho a Bophelo bo Botle'),
              InputFieldOption(
                code: 'AccessIssues',
                name: 'Access Issues (resources, time)',
              ),
              InputFieldOption(
                  code: 'NotInterested',
                  name: 'Not Interested',
                  translatedName: 'Ha ke Thahaselle'),
              InputFieldOption(
                code: 'Other(s)',
                name: 'Other(s)',
                translatedName: 'Tse ling',
              ),
            ],
          ),
          InputField(
            id: 'oTTL6vEpKok',
            name: 'Specify other',
            translatedName: 'Hlalosa tse ling',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            valueType: 'LONG_TEXT',
          ),
          InputField(
            id: 'Ep3atnNQGTY',
            name: 'Follow-up required',
            translatedName: "Ho hlokahala ts'alo morao",
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            valueType: 'BOOLEAN',
          ),
          InputField(
            id: 'DPf5mUDoZMy',
            name: 'Follow-up date',
            translatedName: 'Latsatsi la tlhahlobo e latelang',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            valueType: 'DATE',
            disablePastPeriod: true,
            allowFuturePeriod: true,
          ),
          InputField(
            id: 'LcG4J82PM4Z',
            name: 'Comments or next steps',
            translatedName: 'Maikutlo kapa mehato e latelang',
            inputColor: const Color(0xFF9B2BAE),
            labelColor: const Color(0xFF737373),
            valueType: 'LONG_TEXT',
          ),
        ],
      ),
    ];
  }
}
