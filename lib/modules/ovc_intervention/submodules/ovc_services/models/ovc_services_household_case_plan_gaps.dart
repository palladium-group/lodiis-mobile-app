import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

import '../../../../../core/utils/form_util.dart';

class OvcHouseholdServicesCasePlanGaps {
  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      FormSection(
          id: 'Health',
          name: 'DOMAIN HEALTH',
          translatedName: 'BOPHELO BO BOTLE',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),
          subSections: [
            FormSection(id: 'knowledgeable_about_hiv_prevention',
              name: 'Knowledgeable about HIV Prevention',
              translatedName: 'Knowledgeable about HIV Prevention',
              color: const Color(0xFF4D9E49),
              borderColor: const Color(0xFF4D9E49),
              inputFields: [
                InputField(
                    id: 'bRv4ZZy5MDH',
                    name: 'Refer for TB Testing',
                    translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'mvDI6Jr40kI',
                    allowFuturePeriod: true,
                    name: '( TB Testing ) Projected date for completion',
                    translatedName: 'Letsatsi la tlhahlobo ea TB',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'cx4xBY4jZXM',
                    name: 'HIV Prevention,Care and Treatment Messaging',
                    translatedName: 'Tšebeletso ea HIV Prevention,Care and Treatment Messaging',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'SIEeRmPm0Q0',
                    allowFuturePeriod: true,
                    name: '(HIV Prevention,Care and Treatment Messaging) Projected date for completion',
                    translatedName: 'Letsatsi la HIV S&D le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'XoSPWmpWXCy',
                    name: 'Refer for HTS',
                    translatedName: 'Tšebeletso a HTS ',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'iFv7FJeG3V1',
                    allowFuturePeriod: true,
                    name: '(HTS) Projected date for completion',
                    translatedName: 'Letsatsi la HTS le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
              ],




            ),
            FormSection(id: 'adherent_Virally_suppressed',
              name: 'Adherent/Virally Suppressed',
              translatedName: 'Adherent/Virally Suppressed',
              color: const Color(0xFF4D9E49),
              borderColor: const Color(0xFF4D9E49),
              inputFields: [
                InputField(
                    id: 'HKCv7lkLexo',
                    name: 'Offer HIV adherence support',
                    translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'JzlLk2tW4xh',
                    allowFuturePeriod: true,
                    name: '( HIV ADHERANCE SUPPORT ) Projected date for completion',
                    translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'ylSjcj6cv42',
                    name: 'Refer for ART Initiation',
                    translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'qMrZcC7VvCV',
                    allowFuturePeriod: true,
                    name: 'Date for HIV Art initiation to be completed',
                    translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'bepi3n6Z4T0',
                    name: 'Refere for Viral Load Testing',
                    translatedName: 'Tšebeletso ea HIV Prevention,Care and Treatment Messaging',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'A8iJ8Al2F68',
                    allowFuturePeriod: true,
                    name: '(Viral Load Testing) Projected date for completion',
                    translatedName: 'Letsatsi la HIV S&D le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'SHWV7e088RT',
                    name: 'Refer for CD4 Testing Service',
                    translatedName: 'Tšebeletso ea HIV Prevention,Care and Treatment Messaging',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'gez23HygrJq',
                    allowFuturePeriod: true,
                    name: 'Date for CD4 testing to be completed',
                    translatedName: 'Letsatsi la HIV S&D le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'gff7hjjVoI6',
                    name: 'Provide Community ART adherence counseling ',
                    translatedName: 'Tšebeletso ea HIV ADHERANCE SUPPORT',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'YI1Ckbt8mRn',
                    allowFuturePeriod: true,
                    name: 'Date for Community ART adherence counseling  to be completed',
                    translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'XuZIbkwn5yi',
                    name: 'Offer Enhanced adherence counseling',
                    translatedName: 'Enhanced adherence counselingT',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'uwuAbOBtPHf',
                    allowFuturePeriod: true,
                    name: 'Date for enhanced adherence counseling to be completed',
                    translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'WiPTQhWLVU1',
                    name: 'Provide family psychosocial support service',
                    translatedName: 'Offer feeding session service',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'BpLk6ruSL7e',
                    allowFuturePeriod: true,
                    name: 'Date for family psychosocial support service to be completed',
                    translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'vqRohVpTK2G',
                    name: 'ART literacy',
                    translatedName: 'Tšebeletso a HTS ',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'vUMhUm3i0b0',
                    allowFuturePeriod: true,
                    name: 'Date for ART literacy to be completed',
                    translatedName: 'Letsatsi la HTS le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

              ],




            ),
            FormSection(id: 'nutrition',
              name: 'Nutrition',
              translatedName: 'Nutrition',
              color: const Color(0xFF4D9E49),
              borderColor: const Color(0xFF4D9E49),
              inputFields: [

                InputField(
                    id: 'zkbTGkrT6bH',
                    name: 'Provide feeding session service',
                    translatedName: 'Offer feeding session service',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'G4kPVSr7I8U',
                    allowFuturePeriod: true,
                    name: 'Date for feeding session service to be completed',
                    translatedName: 'Letsatsi la HIV ADHERANCE SUPPORT le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'ztDAwmkSwKf',
                    name: 'Provide Oral Health Hygiene Messaging',
                    translatedName: 'Tšebeletso a HTS ',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'bK18Ebt1cRa',
                    allowFuturePeriod: true,
                    name: 'Date for Hygiene Messaging to be completed',
                    translatedName: 'Letsatsi la HTS le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'CaAOIbC10yv',
                    name: 'Provide Nutrition Messaging',
                    translatedName: 'Tšebeletso ea  Nutrition Messaging ',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'v7GBKBoqJPr',
                    allowFuturePeriod: true,
                    name: '(Nutrition Messaging) Projected date for completion',
                    translatedName: 'Letsatsi la Nutrition Messaging le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'EaJTFrklMo5',
                    name: 'FOOD SUPPORT',
                    translatedName: 'Tšebeletso ea  FOOD SUPPORT',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'WAq2HJHXZYS',
                    allowFuturePeriod: true,
                    name: '(FOOD SUPPORT) Projected date for completion',
                    translatedName: 'Letsatsi la FOOD SUPPORT le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'uvJV4WGc5ct',
                    name: 'FOOD SUPPLIMENTS',
                    translatedName: 'Tšebeletso ea FOOD SUPPLIMENTS',
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'F2IOqOr4EuV',
                    allowFuturePeriod: true,
                    name: '(FOOD SUPPLIMENTS) Projected date for completion',
                    translatedName: 'Letsatsi la FOOD SUPPLIMENTS le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'x4yAqv4z2Xv',
                    name: 'Deworming medication, Vitamin A and Immunization',
                    translatedName: 'Tšebeletso a IMMUNIZATION',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),
                InputField(
                    id: 'eTDE6zroxBC',
                    allowFuturePeriod: true,
                    name: 'Deworming medication,Vitamin A and Immunization Projected date for completion',
                    translatedName: 'Letsatsi la IMMUNIZATION le tla phetheloa',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

              ],




            ),
            FormSection(id: 'increased_access_to_emtct_services',
              name: 'EMTCT/Increased access to EMTCT services',
              translatedName: 'EMTCT/Increased access to EMTCT services',
              color: const Color(0xFF4D9E49),
              borderColor: const Color(0xFF4D9E49),
              inputFields: [
                InputField(
                    id: 'vbUdFOsYrxP',
                    name: 'Refer for ANC services',
                    translatedName: 'Tšebeletso ea ANC',
                    valueType: 'TRUE_ONLY',
                    isReadOnly: true,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

                InputField(
                    id: 'nV5blRoSKnK',
                    allowFuturePeriod: true,
                    name: 'Date for ANC referral  to be completed',
                    translatedName: 'Letsatsi la tlhahlobo ea TB',
                    valueType: 'DATE',
                    firstDate: firstDate,
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373)),

              ],




            ),


          ],

      ),
    ];
  }
}
