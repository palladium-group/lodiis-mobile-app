import 'dart:ui';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/agyw_dreams_common_constant.dart';

class DreamsReferralOutCome {
  static List<String> getMandatoryFields() {
    return ['p7saxV2libq', 'hXyqgOWZ17b'];
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
          name: 'Referral Outcome',
          translatedName: 'Sephetho sa phetisetso',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
              id: 'p7saxV2libq',
              name: 'Date client reached the referral station',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'hXyqgOWZ17b',
              name: 'Referral service provided?',
              translatedName: 'Ho fanoe ka litšebeletso tsa phetisetso?',
              valueType: 'BOOLEAN',
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'lvT9gfpHIlT',
              name: 'Date service was provided',
              translatedName: "Letsatsi leo ts'ebeletso e fanoeng ka lona",
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'gEjigBuBTmh',
              name: 'Reasons for rejecting/declining service(s) offered',
              translatedName: 'Mabaka a ho hana litšebeletso tse fanoang',
              valueType: 'TEXT',
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
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'oTTL6vEpKok',
              name: 'Specify other reasons for service declining',
              translatedName:
                  'Hlalosa mabaka a mang a ho fokotseha ha litšebeletso',
              valueType: 'LONG_TEXT',
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'Ep3atnNQGTY',
              name: 'Follow up required',
              valueType: 'BOOLEAN',
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'DPf5mUDoZMy',
              name: 'Follow-up date',
              translatedName: 'Latsatsi la tlhahlobo e latelang',
              allowFuturePeriod: true,
              disablePastPeriod: true,
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'JyEhKJXJiTp',
              name: 'Referring Organisation/Officer contacted for Feedback',
              valueType: 'BOOLEAN',
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'yGf4w48y1Jt',
              name: 'Date Contacted for Feedback',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'LcG4J82PM4Z',
              name: 'Comments or next steps',
              translatedName: 'Maikutlo kapa mehato e latelang',
              valueType: 'LONG_TEXT',
              inputColor: AgywDreamsCommonConstant.defaultColor,
              labelColor: const Color(0xFF737373),
            ),
          ])
    ];
  }
}
