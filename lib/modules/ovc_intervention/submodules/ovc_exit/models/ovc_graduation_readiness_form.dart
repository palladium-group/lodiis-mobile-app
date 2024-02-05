import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class OvcGraduationReadinessForm {
  static Map<String, String> getBenchMarkAchievementQuestions() {
    return {
      "DXmPLZhKQVp": 'wE7and4EnCR',
      "R4OiU8dHKDe": 'R71zksHtVNn',
      "A5NBGrJWy1z": 'rPSpAEnnVS4',
      "ceYTaM00pTh": 'so1Hnb8K09j',
      "P90kJechZJT": 'XxioqueCXcn',
      "AScHzfI40br": 'wW0grvww5Iz',
    };
  }

  static List<InputFieldOption> getInputFieldOptions(
    String formSectionId,
    String inputFieldId,
  ) {
    return FormUtil.getFormFieldOptions(
      getFormSections(firstDate: ''),
      formSectionId,
      inputFieldId,
    );
  }

  static List<FormSection> getFormSections({
    required String firstDate,
  }) {
    return [
      AppUtil.getServiceProvisionEventDateSection(
        inputColor: const Color(0xFF4A9F46),
        labelColor: const Color(0xFF1A3518),
        sectionLabelColor: const Color(0xFF4A9F46),
        formSectionLabel: 'Case Plan Graduation Date',
        inputFieldLabel: 'Case Plan Graduation On',
        firstDate: firstDate,
      ),
      FormSection(
        id: "DXmPLZhKQVp",
        name: 'Benchmark 1: Known HIV status',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'WFjzAp3wQ8M',
            name:
                '1.1. Has each child, adolescent, and youth in the household been documented as “HIV status positive,” “HIV status negative,” or “test not required based on risk,” according to an HIV risk assessment?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'aoGIcQaTXjh',
            name:
                '1.2. Has each primary caregiver in the household been documented as “HIV status positive,” “HIV status negative,” or “test not required based on risk,” according to an HIV risk assessment?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'wE7and4EnCR',
            name: 'Has Benchmark 1 been met?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'R4OiU8dHKDe',
        name: 'Benchmark 2: Adherent / Virally suppressed',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'naaNy5zLz3I',
            name:
                '2.1 Has this beneficiary been documented as virally suppressed (<1,000 copies/mL) for the past 12 months',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'FOimOq843Ly',
            name:
                '2.2. In the past 12 months, has this beneficiary been regularly attending ART appointments and picking up ART pills on schedule? This means that the case file shows that at every monthly or quarterly visit in the past 12 months, the beneficiary was regularly attending ART appointments and picking up ART pills on schedule.',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'q8HfJgKMqrM',
            name:
                '2.3. In the past 12 months, has this beneficiary been taking antiretroviral therapy (ART) pills as prescribed? This means that the case file shows that at every monthly or quarterly visit in the past 12 months, the beneficiary was taking ART pills as prescribed',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'R71zksHtVNn',
            name: 'Has Benchmark 2 been met for this beneficiary? ',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'A5NBGrJWy1z',
        name: 'Benchmark 3: Knowledgeable about HIV prevention',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
              id: 'hiv_risks',
              name:
                  'Can you tell me how a young person your age living in your community might become infected with HIV?',
              translatedName:
                  'A na u ka mpolella hore na mocha oa lilemo tsa hau ea lulang motseng oa heno a ka tšoaetsoa HIV joang?',
              valueType: 'CHECK_BOX',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                    code: 'Yk4nznsVVME',
                    name: 'Early sex (starting sex young)',
                    translatedName:
                        'Thobalano ea kapele (ho qala thobalano le sa le banyenyane)'),
                InputFieldOption(
                    code: 'SgnvNELORR5',
                    name: 'Sex without a condom',
                    translatedName: 'Thobalano ntle le khohlopo'),
                InputFieldOption(
                  code: 'RfunopzHoeR',
                  name: 'Sex with an older partner',
                ),
                InputFieldOption(
                    code: 'jWYwiTRNvoF',
                    name: 'Being sexually abused or raped',
                    translatedName:
                        'Ho hlekefetsoa ka thobalano kapa ho betoa'),
                InputFieldOption(
                  code: 'z2COmFwfABt',
                  name: 'Sex with multiple partners',
                ),
                InputFieldOption(
                  code: 'SJAEzQgVP1U',
                  name:
                      'Sex for money or gifts (transactional sex, having a sugar daddy)',
                ),
              ]),
          InputField(
            id: 'hxLZDtNtn3p',
            name: '3.1 Has the adolescent identified at least two HIV risks?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'prevention_strategy',
            name:
                'Can you tell me any other ways a young person might help protect himself or herself against HIV?',
            valueType: 'CHECK_BOX',
            options: [
              InputFieldOption(
                code: 'c4vr8GntTrC',
                name: 'Having one sexual partner',
              ),
              InputFieldOption(
                code: 'McOkGzQ2uUN',
                name: 'Delaying sex or abstinence',
              ),
              InputFieldOption(
                code: 'L6VKKm5xtPz',
                name: 'Having a sexual partner',
              ),
              InputFieldOption(
                code: 'r4TVMVvmSCp',
                name: 'Using a condom during',
              ),
              InputFieldOption(
                code: 'rkaToQeb3M1',
                name: 'Having a partner who does not have other sexual partner',
              ),
              InputFieldOption(
                code: 'I1T85k6muns',
                name: 'Not having sex for money or gifts, or transactional sex',
              ),
            ],
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'ApextZUIUcC',
            name:
                '3.2 Has the adolescent identified at least one HIV prevention strategy?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'rPSpAEnnVS4',
            name: 'Has Benchmark 3 been met for this beneficiary?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'ceYTaM00pTh',
        name: 'Benchmark 4: Not malnourished',
        description:
            "Assess the child’s MUAC and bipedal edema if you have been trained in how to conduct these assessments. If you have not received this training, request that the MUAC be measured by a health worker or caseworker who has been trained in assessing the MUAC and bipedal edema.",
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'htotfutRcVF',
            name: '4.1. Is the child’s MUAC more than 12.5 cm?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'F7HWBfHN6tQ',
            name: '4.2. Is the child free of any signs of bipedal edema?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'so1Hnb8K09j',
            name: 'Has Benchmark 4 been met for this beneficiary? ',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'P90kJechZJT',
        name: 'Benchmark 5: Prevention of Mother To Child Transmission',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'zPggDcmT4zt',
            name:
                '5.1 Has the Pregnant adolescent or woman in the household been tested for HIV?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'UxPgBn3JRBQ',
            name:
                '5.2 Is the HIV positive pregnant woman currently attending ANC services?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'fffETOzhGsU',
            name:
                '5.3 Has the infant born from an HIV positive adolescent or woman in the household been tested for HIV?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
              id: 'LyCBmMgAW4P',
              name: '5.4 At what age was the infant tested?',
              valueType: 'TEXT',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: "six weeks",
                  name: "Six weeks",
                ),
                InputFieldOption(
                  code: "six months",
                  name: "Six months",
                ),
                InputFieldOption(
                  code: "eighteen months",
                  name: "Eighteen months",
                ),
              ]),
          InputField(
              id: 'wGeVdyVO5hE',
              name:
                  'If the infant has been tested for HIV, what is the Child HIV status?',
              valueType: 'TEXT',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
              options: [
                InputFieldOption(
                  code: 'Positive',
                  name: 'Positive',
                ),
                InputFieldOption(
                  code: 'Negative',
                  name: 'Negative',
                ),
              ]),
          InputField(
            id: 'XxioqueCXcn',
            name: 'Has Benchmark 5 been met for this household?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'AScHzfI40br',
        name: 'Benchmark 6: Children in school',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'PkvK39frchD',
            name:
                '6.1 Are all children and adolescents in the household ages 6–17* enrolled in school? ',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'RVGFbzbEGmY',
            name:
                '6.2 Have all children and adolescents in the household ages 6–17* attended school regularly over the past year (at least 4 days a week on average)?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'HzUAxTw1nZs',
            name:
                '6.3. Did all children and adolescents in the household ages 6–17* progress to the next level or grade, from last school year to this school year?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'wW0grvww5Iz',
            name: 'Has Benchmark 6 been met? ',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'YsPKdNobVFD',
        name: 'Graduation Benchmarks Assessment',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'S5bMqu2LyKJ',
            name: 'Have all applicable benchmarks been met?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
    ];
  }
}
