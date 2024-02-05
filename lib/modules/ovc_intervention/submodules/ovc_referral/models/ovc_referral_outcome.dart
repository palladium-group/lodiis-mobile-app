import 'dart:ui';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class OvcReferralOutCome {
  static List<String> getMandatoryFields() {
    return ['p7saxV2libq'];
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
          name: 'Referral Outcome',
          translatedName: 'Sephetho sa phetisetso',
          color: const Color(0xFF1B3519),
          inputFields: [
            InputField(
              id: 'p7saxV2libq',
              name: 'Date client reached the referral station',
              translatedName:
                  'Letsatsi, khoeli le selemo se mosebeletsuoa a fumanang ts’ebeletso',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'lvT9gfpHIlT',
              name: 'Date service was provided',
              translatedName: 'Ho fanoe ka tšebeletso ea letsatsi',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'Ep3atnNQGTY',
              name: 'Follow up required',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'DPf5mUDoZMy',
              allowFuturePeriod: true,
              disablePastPeriod: true,
              name: 'Follow-up date',
              translatedName: 'Latsatsi la tlhahlobo e latelang',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'JyEhKJXJiTp',
              name: 'Referring Organisation/Officer contacted for Feedback',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'yGf4w48y1Jt',
              name: 'Date Contacted for Feedback',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: 'LcG4J82PM4Z',
              name: 'Comments or next steps',
              translatedName: 'Maikutlo kapa mehato e latelang',
              valueType: 'LONG_TEXT',
              inputColor: const Color(0xFF4B9F46),
              labelColor: const Color(0xFF737373),
            ),
          ])
    ];
  }
}
