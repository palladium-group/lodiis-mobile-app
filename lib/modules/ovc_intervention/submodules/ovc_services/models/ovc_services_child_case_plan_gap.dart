import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

// single, group house =< caregiver
class OvcServicesChildCasePlanGap {
  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    //Date for HIVS&D to be completed
    return [
      FormSection(
          name: 'DOMAIN HEALTH',
          translatedName: 'BOPHELO BO BOTLE',
          id: 'Health',
          color: const Color(0xFF4D9E49),
          borderColor: const Color(0xFF4D9E49),

          subSections: [
            FormSection(
                name: 'Knowledgeable about HIV Prevention',
              translatedName: 'Knowledgeable about HIV Prevention',
              id: 'knowledgeable_about_hiv_prevention',
              color: const Color(0xFF4D9E49),
              borderColor: const Color(0xFF4D9E49),
                inputFields: [
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
                      name: 'HTS',
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

                  InputField(
                      id: 'bRv4ZZy5MDH',
                      name: 'TB Testing',
                      translatedName: 'Tšebeletso a TBTREAT',
                      valueType: 'TRUE_ONLY',
                      isReadOnly: true,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'mvDI6Jr40kI',
                      allowFuturePeriod: true,
                      name: '(TB Testng) Projected date for completion',
                      translatedName: 'Letsatsi la TBTREAT le tla phetheloa',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                ]


            ),
            FormSection(
                name: 'Adherent/Virally Suppressed',
                translatedName: 'Adherent/Virally Suppressed',
                id: 'adherent_Virally_suppressed',
                color: const Color(0xFF4D9E49),
                borderColor: const Color(0xFF4D9E49),
                inputFields: [
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
                  InputField(
                      id: 'eQTJrTcKzVK',
                      name: 'Offer Disclosure Support service',
                      translatedName: 'Tšebeletso a HTS ',
                      valueType: 'TRUE_ONLY',
                      isReadOnly: true,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'taejdmpbsoG',
                      allowFuturePeriod: true,
                      name: 'Date for Disclosure Support service to be completed',
                      translatedName: 'Letsatsi la HTS le tla phetheloa',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'HKCv7lkLexo',
                      name: 'HIV ADHERANCE SUPPORT',
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
                      translatedName: 'Tšebeletso a ART',
                      valueType: 'TRUE_ONLY',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'qMrZcC7VvCV',
                      allowFuturePeriod: true,
                      name: '(ART Initiation) Projected date for completion',
                      translatedName: 'Letsatsi la TBTREAT le tla phetheloa',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'XuZIbkwn5yi',
                      name: 'Enhanced adherence counseling',
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
                      isReadOnly: true,
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
                ]


            ),
            FormSection(
                name: 'Nutrition',
                translatedName: 'Nutrition',
                id: 'nutrition',
                color: const Color(0xFF4D9E49),
                borderColor: const Color(0xFF4D9E49),
                inputFields: [
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
                      id: 'dTFLFtUUeEK',
                      name: 'Refere for Vitamin A',
                      translatedName: 'Tšebeletso a SAIDS',
                      valueType: 'TRUE_ONLY',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'jlu7TDN7khJ',
                      allowFuturePeriod: true,
                      name: 'Vitamin A date for completion',
                      translatedName: 'Letsatsi la SAIDS le tla phetheloa',
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
                  InputField(
                      id: 'uvJV4WGc5ct',
                      name: 'FOOD SUPPLIMENTS',
                      translatedName: 'Tšebeletso ea FOOD SUPPLIMENTS',
                      valueType: 'TRUE_ONLY',
                      isReadOnly: true,
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
                      isReadOnly: true,
                      name: '(FOOD SUPPORT) Projected date for completion',
                      translatedName: 'Letsatsi la FOOD SUPPORT le tla phetheloa',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'CaAOIbC10yv',
                      name: 'Nutrition Messaging',
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
                ]


            ),
            FormSection(
                name: 'EMTCT/Increased access to EMTCT services',
                translatedName: 'EMTCT/Increased access to EMTCT services',
                id: 'increased_access_to_emtct_services',
                color: const Color(0xFF4D9E49),
                borderColor: const Color(0xFF4D9E49),
                inputFields: [

                ]


            ),


          ],
          ),



    ];
  }
}
