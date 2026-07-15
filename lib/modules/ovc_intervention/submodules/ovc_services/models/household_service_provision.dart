import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class HouseholdServiceProvision {
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
            FormSection(
                name: 'Knowledgeable about HIV Prevention',
                translatedName: 'Knowledgeable about HIV Prevention',
                id: 'knowledgeable_about_hiv_prevention',
                color: const Color(0xFF4D9E49),
                borderColor: const Color(0xFF4D9E49),
                inputFields: [

                  InputField(
                    id: 'HzI5X2yHef6',
                    name: 'HIV Prevention,Care and Treatment Messaging Service provided',
                    translatedName: "Lits'ebeletso tsa HIVS&D li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'GyG2HcLsVka',
                      name: 'HIV Prevention,Care and Treatment Messaging Service Provision Date',
                      translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa HIVS&D',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'y8ToqnbVz1o',
                      name: 'HIV Prevention,Care and Treatment Messaging Comment',
                      translatedName: 'Tlhaloso ea HIVS&D',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),



                  InputField(
                    id: 'JnqldNamliR',
                    name: 'HTS Service provided',
                    valueType: 'TRUE_ONLY',
                    translatedName: 'Litsebeletso tsa HTS li fanoe',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'CNnzifTDF5a',
                      name: 'HTS Service Provision Date',
                      translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa HTS',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'sxlVgySosg3',
                      name: 'HTS Comment',
                      translatedName: 'Tlhaloso ea HTS',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                    id: 'dJO2m3CXfM5',
                    name: 'TB Testing referral completed',
                    valueType: 'TRUE_ONLY',
                    translatedName: 'Litsebeletso tsa TBTREAT li fanoe',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'YEebsaVMH19',
                      name: 'TB Testing referral completed Date',
                      translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa TBTREAT',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'eB10uAfk1El',
                      name: 'TB Testing referral Comment',
                      translatedName: 'Tlhaloso ea TBTREAT',
                      valueType: 'TEXT',
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
                    id: 'GImA3HB9YK5',
                    name: 'Family psychosocial support  Service provided',
                    translatedName: "Lits'ebeletso tsa RTEEN/Parenting  li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF0F9587),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'fFuabYbLUjz',
                      name: 'Family psychosocial support Service Provision Date',
                      translatedName:
                      'Letsatsi la Kabo ea Litšebeletso tsa RTEEN/Parenting',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF0F9587),
                      labelColor: const Color(0xFF737373)),

                  InputField(
                      id: 'IFggJCXLYPD',
                      name: 'Family psychosocial support Comment',
                      translatedName: 'Tlhaloso ea RTEEN/Parenting',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF0F9587),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                    id: 'FHvpd3Z5PAo',
                    name: 'Disclosure Support Service Provided',
                    translatedName: "Lits'ebeletso tsa Disclosure Support li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'xpSfl4fCE5B',
                      name: 'Disclosure Support Service Provision Date',
                      translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa Disclosure',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'r8oyCTs6Fd3',
                      name: 'Disclosure Support Comment',
                      translatedName: 'Tlhaloso ea Disclosure',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                    id: 'yQkDGd2gLw2',
                    name: 'ART literacy Service Provided',
                    valueType: 'TRUE_ONLY',
                    translatedName: 'Litsebeletso tsa HIVTREAT li fanoe',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'lL8XiDgD8ZI',
                      name: 'ART literacy Service Provision Date',
                      translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa HIVTREAT',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'HfO5NXau7f2',
                      name: 'ART literacy  Comment',
                      translatedName: 'Tlhaloso ea HIVTREAT',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),



                  InputField(
                    id: 'YFgrURiwirq',
                    name: 'ART Initiation Service provided',
                    valueType: 'TRUE_ONLY',
                    translatedName: 'Litsebeletso tsa HIVTREAT li fanoe',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'LtiZFxXw0Wc',
                      name: 'ART Initiation Service Provision Date',
                      translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa HIVTREAT',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'i9icxSZ8HCf',
                      name: 'ART Initiation Comment',
                      translatedName: 'Tlhaloso ea HIVTREAT',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),

                  InputField(
                    id: 'E21r5xeRgBg',
                    name: 'Community ART Adherance counseling Service Provided',
                    translatedName: "Lits'ebeletso tsa Nutrition Messaging li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'LcEBYlqwCij',
                      name: 'Community ART Adherance Service Provision Date',
                      translatedName:
                      'Letsatsi la Kabo ea Litšebeletso tsa Nutrition Messaging',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'zhSR0uBSq3f',
                      name: 'Community ART Adherance counseling Description',
                      translatedName: 'Tlhaloso ea FOOD SUPPORT',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),

                  InputField(
                    id: 'eGkOJf7odKm',
                    name: 'Enhanced adherence counseling service provided',
                    translatedName: "Lits'ebeletso tsa EAC li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'W6GgMkwmVuf',
                      name: 'EAC Service Provision Date',
                      translatedName:
                      'Letsatsi la Kabo ea Litšebeletso tsa EAC',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'D8G720HroqU',
                      name: 'Enhanced Adherance counseling Description',
                      translatedName: 'Tlhaloso ea Enhanced Adherance counseling',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),





                  InputField(
                    id: 'otd2tndsE4Z',
                    name: 'ADHERANCE SUPPORT Service provided',
                    translatedName:
                    "Lits'ebeletso tsa ADHERANCE SUPPORT li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'ruZFn94Hcyw',
                      name: 'ADHERANCE SUPPORT Service Provision Date',
                      translatedName:
                      'Letsatsi la Kabo ea Litšebeletso tsa ADHERANCE SUPPORT',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'dwhnvU5m667',
                      name: 'ADHERANCE SUPPORT Comment',
                      translatedName: 'Tlhaloso ea ADHERANCE SUPPORT',
                      valueType: 'TEXT',
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
                    id: 'U0zYyliGuQo',
                    name: 'Oral Health Service provided',
                    translatedName: "Lits'ebeletso tsa Oral Health li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'PXo8jxReklh',
                      name: 'Oral Health Service Provision Date',
                      translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa Oral Health',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'OoODkEfZ4hq',
                      name: 'Oral Health Comment',
                      translatedName: 'Tlhaloso ea Oral Health',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                    id: 'UKczyQWCB0L',
                    name: 'IMMUNIZATION Service provided',
                    translatedName: "Lits'ebeletso tsa IMMUNIZATION li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'jsEr16lnber',
                      name: 'IMMUNIZATION Service Provision Date',
                      translatedName:
                      'Letsatsi la Kabo ea Litšebeletso tsa IMMUNIZATION',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'wZLjymsKsuj',
                      name: 'IMMUNIZATION Comment',
                      translatedName: 'Tlhaloso ea IMMUNIZATION',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),

                  InputField(
                    id: 'QnFYeBNZlbf',
                    name: 'FOOD SUPPORT Service provided',
                    translatedName: "Lits'ebeletso tsa FOOD SUPPORT li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'EnrZPBFxZuX',
                      name: 'FOOD SUPPORT Service Provision Date',
                      translatedName:
                      'Letsatsi la Kabo ea Litšebeletso tsa FOOD SUPPORT',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),

                  InputField(
                      id: 'xdI5atw8DC4',
                      name: 'FOOD SUPPORT Comment',
                      translatedName: 'Tlhaloso ea FOOD SUPPORT',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),

                  InputField(
                    id: 'CRVDu0WUOFm',
                    name: 'Nutrition Messaging Service provided',
                    translatedName: "Lits'ebeletso tsa Nutrition Messaging li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'cyEa4fwKL7O',
                      name: 'Nutrition Messaging Service Provision Date',
                      translatedName:
                      'Letsatsi la Kabo ea Litšebeletso tsa Nutrition Messaging',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'OypZVFbZ1r0',
                      name: 'Nutrition Messaging Comment',
                      translatedName: 'Tlhaloso ea FOOD SUPPORT',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),

                  InputField(
                    id: 'BWqkxqDJJEP',
                    name: 'Feeding Sessions Service provided',
                    translatedName: "Lits'ebeletso tsa Nutrition Messaging li fanoe",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'E8Bi7BwHEXM',
                      name: 'Feeding Sessions Service Provision Date',
                      translatedName:
                      'Letsatsi la Kabo ea Litšebeletso tsa Nutrition Messaging',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'SGLSQWgUi8R',
                      name: 'Feeding Sessions Description',
                      translatedName: 'Tlhaloso ea FOOD SUPPORT',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),



                  InputField(
                    id: 'J2VVqKMlJX0',
                    name: 'Food Demonstration Service Provided',
                    translatedName: "Lits'ebeletso tsa Food Demonstration",
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'c3CO4fvK7ZQ',
                      name: 'Food Demonstration Service Provision Date',
                      translatedName:
                      'Letsatsi la Kabo ea Litšebeletso Food Demonstration',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'B95FIqPFBjY',
                      name: 'Food Demonstration Description',
                      translatedName: 'Tlhaloso ea Food Demonstration',
                      valueType: 'TEXT',
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
                  InputField(
                    id: 'eqhzeRBMftZ',
                    name: 'ANY HEALTH RELATED Service provided',
                    translatedName: 'Litsebeletso tsa ANY HEALTH RELATED tse fanoe',
                    valueType: 'TRUE_ONLY',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'F8x8QAoFQBO',
                      name: 'ANY HEALTH RELATED Service Provision Date',
                      translatedName:
                      'Letsatsi la Kabo ea Litšebeletso tsa ANY HEALTH RELATED',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'AStxMCkJhi5',
                      name: 'ANY HEALTH RELATED Comment',
                      translatedName: 'Tlhaloso ea ANY HEALTH RELATED',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                    id: 'kzN0Pylj9m4',
                    name: 'ANC service Provided',
                    valueType: 'TRUE_ONLY',
                    translatedName: 'Litsebeletso tsa TBTREAT li fanoe',
                    inputColor: const Color(0xFF4D9E49),
                    labelColor: const Color(0xFF737373),
                  ),
                  InputField(
                      id: 'NLNwk2zH4pp',
                      name: 'ANC Service Provision Date',
                      translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa TBTREAT',
                      valueType: 'DATE',
                      firstDate: firstDate,
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                  InputField(
                      id: 'taavmnOAOJ4',
                      name: 'ANC Service Comment',
                      translatedName: 'Tlhaloso ea ANC',
                      valueType: 'TEXT',
                      inputColor: const Color(0xFF4D9E49),
                      labelColor: const Color(0xFF737373)),
                ]
            )
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
              id: 'xTO562B5g53',
              name: 'SILC Service provided',
              translatedName: "Lits'ebeletso tsa SILC li fanoe",
              valueType: 'TRUE_ONLY',
              inputColor: const Color(0xFF0000FF),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'uOMr56xoKDh',
                name: 'SILC Service Provision Date',
                translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa SILC',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF0000FF),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'hMdC0CMKSGn',
                name: 'SILC Comment',
                translatedName: 'Tlhaloso ea SILC',
                valueType: 'TEXT',
                inputColor: const Color(0xFF0000FF),
                labelColor: const Color(0xFF737373)),
            InputField(
              id: 'lEkrLOFmLrH',
              name: 'K/TPLOTS Service provided',
              translatedName: "Lits'ebeletso tsa K/TPLOTS li fanoe",
              valueType: 'TRUE_ONLY',
              inputColor: const Color(0xFF0000FF),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'F8ALMOcc6C1',
                name: 'K/TPLOTS Service Provision Date',
                translatedName: "Lits'ebeletso tsa K/TPLOTS li fanoe",
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF0000FF),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'p77CBdxxtHI',
                name: 'K/TPLOTS Comment',
                translatedName: 'Tlhaloso ea K/TPLOTS',
                valueType: 'TEXT',
                inputColor: const Color(0xFF0000FF),
                labelColor: const Color(0xFF737373)),
            InputField(
              id: 'lpTVK3t1Ahk',
              name: 'FINANCIAL EDUCATION  Service provided',
              translatedName: "Lits'ebeletso tsa FINANCIAL EDUCATION li fanoe",
              valueType: 'TRUE_ONLY',
              inputColor: const Color(0xFF0000FF),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'j1yzHzO0w6w',
                name: 'FINANCIAL EDUCATION  Service Provision Date',
                translatedName:
                    'Letsatsi la Kabo ea Litšebeletso tsa FINANCIAL EDUCATION ',
                valueType: 'DATE',
                firstDate: firstDate,
                inputColor: const Color(0xFF0000FF),
                labelColor: const Color(0xFF737373)),

            InputField(
                id: 'HGpA4kx5jLQ',
                name: 'FINANCIAL EDUCATION  Comment',
                translatedName: 'Tlhaloso ea FINANCIAL EDUCATION ',
                valueType: 'TEXT',
                inputColor: const Color(0xFF0000FF),
                labelColor: const Color(0xFF737373)),
          ]),
      FormSection(
        id: 'Safe',
        name: 'DOMAIN SAFE',
        translatedName: 'TSIRELETSO',
        color: const Color(0xFF0F9587),
        borderColor: const Color(0xFF0F9587),
        inputFields: [
          InputField(
            id: 'gfKsz88uxtg',
            name: 'LEGAL PROTECTION Service provided',
            translatedName: "Lits'ebeletso tsa LEGAL PROTECTION li fanoe",
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF0F9587),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'P06od0qmlSR',
              name: 'LEGAL PROTECTION Service Provision Date',
              translatedName:
                  'Letsatsi la Kabo ea Litšebeletso tsa LEGAL PROTECTION',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),

          InputField(
              id: 'iz4CvIFovsF',
              name: 'LEGAL PROTECTION Comment',
              translatedName: 'Tlhaloso ea LEGAL PROTECTION',
              valueType: 'TEXT',
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'aGChpBlIzcd',
            name: 'BIRTHCERT Service provided',
            translatedName: "Lits'ebeletso tsa BIRTHCERT li fanoe",
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF0F9587),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'AXLxNo9pz8c',
              name: 'BIRTHCERT Service Provision Date',
              translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa BIRTHCERT',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),

          InputField(
              id: 'cb773khL7XB',
              name: 'BIRTHCERT Comment',
              translatedName: 'Tlhaloso ea BIRTHCERT',
              valueType: 'TEXT',
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'rMtSykWZ4HB',
            name: 'VAC MESSAGING Service provided',
            translatedName: "Lits'ebeletso tsa moalaetsa oa VAC li fanoe",
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF0F9587),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'qwnfgBG2web',
              name: 'VAC MESSAGING Service Provision Date',
              translatedName:
                  'Letsatsi la Kabo ea Litšebeletso tsa VAC MESSAGING',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),

          InputField(
              id: 'OMhFxj6SYhM',
              name: 'VAC MESSAGING Comment',
              translatedName: 'Tlhaloso ea VAC MESSAGING',
              valueType: 'TEXT',
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'QDFZ03HbjGj',
            name: 'VAC Legal Messaging Service provided',
            translatedName: "Litsebeletso tsa molaetsa oa molao li fanoe",
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF0F9587),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'Dw1xLXILErU',
              name: 'VAC Legal Messaging Provision Date',
              translatedName:
                  'Letsatsi la Kabo ea Litšebeletso tsa VAC Legal Messaging',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),

          InputField(
              id: 'KWk8waoLO7N',
              name: 'VAC Legal Messaging Comment',
              translatedName: 'Tlhaloso ea VAC Legal Messaging',
              valueType: 'TEXT',
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'ysDSdiL7wNx',
            name: 'COUNSELLING Service provided',
            translatedName: "Litsebeletso tsa boeletsi bp fanoe",
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF0F9587),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'pBVmFpsSGN7',
              name: 'COUNSELLING Service Provision Date',
              translatedName:
                  'Letsatsi la Kabo ea Litšebeletso tsa COUNSELLING',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),

          InputField(
              id: 'XUoqvbk0uVH',
              name: 'COUNSEL Comment',
              translatedName: 'Tlhaloso ea COUNSELLING',
              valueType: 'TEXT',
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),

          InputField(
            id: 'gwwUOs6yt6C',
            name: 'P&FC Service provided',
            translatedName: "Lits'ebeletso tsa P&FC li fanoe",
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF0F9587),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'w2HlBCfHbZR',
              name: 'P&FC Service Provision Date',
              translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa P&FC',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'aG42nUguLLW',
              name: 'P&FC Comment',
              translatedName: 'Tlhaloso ea P&FC',
              valueType: 'TEXT',
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),
          InputField(
            id: 'JlRnllAlSk0',
            name: 'SHELTER Service provided',
            translatedName: "Lits'ebeletso tsa SHELTER li fanoe",
            valueType: 'TRUE_ONLY',
            inputColor: const Color(0xFF0F9587),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'VlOw6vrLsp5',
              name: 'SHELTER Service Provision Date',
              translatedName: 'Letsatsi la Kabo ea Litšebeletso tsa SHELTER',
              valueType: 'DATE',
              firstDate: firstDate,
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),
          InputField(
              id: 'ONC3bpjq525',
              name: 'SHELTER Comment',
              translatedName: 'Tlhaloso ea SHELTER',
              valueType: 'TEXT',
              inputColor: const Color(0xFF0F9587),
              labelColor: const Color(0xFF737373)),
        ],
      ),
    ];
  }
}
