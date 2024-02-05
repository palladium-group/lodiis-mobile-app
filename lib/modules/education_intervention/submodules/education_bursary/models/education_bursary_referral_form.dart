import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class EducationBursaryReferralForm {
  static List<String> getMandatoryField() {
    return ['KzIw7RMGZ9c', 'hpuu3TCZkKx', 'OIUDljKyNgy'];
  }

  static List<FormSection> getFormSections() {
    return [
      FormSection(
        id: 'bursary_club_referral',
        name: 'Bursary Referral',
        color: const Color(0xFF009688),
        inputFields: [
          InputField(
            id: 'KzIw7RMGZ9c',
            name: 'Referral',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'health services',
                name: 'Health services',
              ),
              InputFieldOption(
                code: 'Legal service',
                name: 'Legal service',
              ),
              InputFieldOption(
                code: 'Safety and sercurity (police)',
                name: 'Safety and sercurity (police)',
              ),
              InputFieldOption(
                code: 'Psycho social',
                name: 'Psycho social',
              ),
              InputFieldOption(
                code: 'Social Assistance services',
                name: 'Social Assistance services',
              ),
              InputFieldOption(
                  code: 'LICPEH',
                  name:
                      'Legal if the cultural practice is exploitative or harmful'),
              InputFieldOption(
                code: 'Social clubs in the community',
                name: 'Social clubs in the community',
              ),
              InputFieldOption(
                code: 'MGYSR Youth centres',
                name: 'MGYSR Youth centres',
              ),
            ],
          ),
          InputField(
            id: 'hpuu3TCZkKx',
            name: 'Referred to',
            translatedName: 'Phetisetso ho',
            valueType: 'TEXT',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: 'Health faccility',
                name: 'Health faccility',
              ),
              InputFieldOption(
                code: 'WLSA',
                name: 'WLSA',
              ),
              InputFieldOption(
                code: 'Police',
                name: 'Police',
              ),
              InputFieldOption(
                code: 'MGYSR',
                name: 'MGYSR',
              ),
              InputFieldOption(
                code: 'MOSD',
                name: 'MOSD',
              ),
              InputFieldOption(
                code: 'KB',
                name: 'KB',
              ),
              InputFieldOption(
                code: 'EGPAF',
                name: 'EGPAF',
              ),
            ],
          ),
          InputField(
            id: 'OIUDljKyNgy',
            name: 'Date of referral',
            valueType: 'DATE',
            inputColor: const Color(0xFF009688),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
    ];
  }
}
