import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class HouseholdGraduationReadinessForm {
  static const String bm3SectionId = 'Bmk3Sec0001';
  static const String bm3InstructionId = 'Bmk3Ins0001';
  static const String bm3AdolescentId = 'Bmk3Ado0001';
  static const String bm3RiskPromptId = 'Bmk3Rsk0001';
  static const String bm3Question31Id = 'Bmk3Q310001';
  static const String bm3PreventionPromptId = 'Bmk3Prv0001';
  static const String bm3Question32Id = 'Bmk3Q320001';
  static const String bm3JudgementInstructionId = 'Bmk3Jdg0001';
  static const String bm3MetId = 'Bmk3Met0001';

  static const String bm4SectionId = 'Bmk4Sec0001';
  static const String bm4InstructionId = 'Bmk4Ins0001';
  static const String bm4ChildUnderSixMonthsInstructionId = 'Bmk4Inf0001';
  static const String bm4ChildId = 'Bmk4Chd0001';
  static const String bm4MuacInstructionId = 'Bmk4Mua0001';
  static const String bm4Question41Id = 'Bmk4Q410001';
  static const String bm4Question42Id = 'Bmk4Q420001';
  static const String bm4MetId = 'Bmk4Met0001';

  static const String bm5SectionId = 'Bmk5Sec0001';
  static const String bm5InstructionId = 'Bmk5Ins0001';
  static const String bm5BeneficiaryId = 'Bmk5Ben0001';
  static const String bm5Question51Id = 'Bmk5Q510001';
  static const String bm5HivNegativeInstructionId = 'Bmk5Neg0001';
  static const String bm5Question52Id = 'Bmk5Q520001';
  static const String bm5DeliveredInstructionId = 'Bmk5Del0001';
  static const String bm5Question53Id = 'Bmk5Q530001';
  static const String bm5Question54Id = 'Bmk5Q540001';
  static const String bm5NoteId = 'Bmk5Not0001';
  static const String bm5MetId = 'Bmk5Met0001';

  static const String cparaHasAdolescentAged10To17 =
      'CPARA_HAS_ADOLESCENT_AGED_10_TO_17';
  static const String cparaHasChildUnder5 = 'CPARA_HAS_CHILD_UNDER_5';
  static const String cparaHasPmtctTarget = 'CPARA_HAS_PMTCT_TARGET';
  static const String cparaSkipPmtctHivTestQuestion =
      'CPARA_SKIP_PMTCT_HIV_TEST_QUESTION';

  static InputField _instructionField({
    required String id,
    required String name,
  }) {
    return InputField(
      id: id,
      name: name,
      valueType: 'TEXT',
      isReadOnly: true,
      hasLabelOnly: true,
      inputColor: const Color(0xFF4D9E49),
      labelColor: const Color(0xFF737373),
    );
  }

  static Map<String, String> getBenchMarkAchievementQuestions() {
    return {
      'jZHYkQntXh9': 'wE7and4EnCR',
      'lMG85SRv6nS': 'R71zksHtVNn',
      bm3SectionId: bm3MetId,
      bm4SectionId: bm4MetId,
      bm5SectionId: bm5MetId,
    };
  }

  static List<FormSection> getFormSections({
    required String firstDate,
    bool hasAdolescentAged10To17 = true,
    bool hasChildUnder5 = true,
    bool hasPmtctTarget = true,
    bool shouldSkipPmtctHivTestQuestion = true,
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
        id: 'jZHYkQntXh9',
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
        id: 'lMG85SRv6nS',
        name: 'Benchmark 2: Virally suppressed',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'naaNy5zLz3I',
            name:
            '2.1. Has this beneficiary been documented as virally suppressed (<1,000 copies/mL) for the past 12 months?',
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
            '2.3. In the past 12 months, has this beneficiary been taking antiretroviral therapy (ART) pills as prescribed? This means that the case file shows that at every monthly or quarterly visit in the past 12 months, the beneficiary was taking ART pills as prescribed.',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'R71zksHtVNn',
            name: 'Has Benchmark 2 been met?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: bm3SectionId,
        name: 'Benchmark 3: Knowledgeable about HIV prevention',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          _instructionField(
            id: bm3InstructionId,
            name: hasAdolescentAged10To17
                ? 'Instruction: Ask the following questions of each adolescent aged 10–17 in the household. Each adolescent should be interviewed separately in a private location where no one else can hear. If the adolescent’s statements are not clear, request more information using probes such as, “I am not sure I understand. Can you tell me more about that?” Do not read the list of HIV risks or prevention strategies to the adolescent. Responses should be unprompted.'
                : 'Instruction: There is no adolescent aged 10–17 in this household. This section is skipped and Benchmark 3 will automatically be marked Yes.',
          ),
          if (hasAdolescentAged10To17) ...[
            InputField(
              id: 'PYOCrvbzCQQ',
              name: 'Adolescent’s ID',
              valueType: 'TEXT',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
            ),
            _instructionField(
              id: bm3RiskPromptId,
              name:
              'Ask the adolescent: Can you tell me how a young person your age living in your community might become infected with HIV? The adolescent must describe two risks to meet Benchmark 3. If only one HIV risk is described, ask: “Can you tell me any other ways a young person in your community might become infected with HIV?” Examples include early sex, sex without a condom, sex with an older partner, being sexually abused or raped, sex with multiple partners, and sex for money or gifts/transactional sex/having a “sugar daddy”.',
            ),
            InputField(
              id: 'iGKhiceO4IZ',
              name:
              '3.1. Has the adolescent identified at least two HIV risks?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
            ),
            _instructionField(
              id: bm3PreventionPromptId,
              name:
              'Ask the adolescent: Can you tell me how a young person your age living in your community might help protect himself or herself from becoming infected with HIV? The adolescent must describe one prevention strategy to meet Benchmark 3. If no strategy is described, ask: “Can you tell me any other ways a young person might help protect himself or herself against HIV?” Examples include having one sexual partner, delaying sex or abstinence, using a condom, having a partner who does not have other sexual partners, and not having sex for money or gifts/transactional sex.',
            ),
            InputField(
              id: 'SyOgxus83Ux',
              name:
              '3.2. Has the adolescent identified at least one HIV prevention strategy?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
            ),
            _instructionField(
              id: bm3JudgementInstructionId,
              name:
              'This section involves open-ended questions that require the case worker to make a judgment. The criterion is that the adolescent demonstrates an understanding of HIV risk and prevention, not that the adolescent gives an answer matching the questionnaire word for word.',
            ),
          ],
          InputField(
            id: 'RgIqd4fvT1C',
            name: hasAdolescentAged10To17
                ? 'Has Benchmark 3 been met for this beneficiary?'
                : '',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: bm4SectionId,
        name: 'Benchmark 4: Not undernourished',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          _instructionField(
            id: bm4InstructionId,
            name: hasChildUnder5
                ? 'Instruction: Assess this benchmark for each child under 5 years of age in the household. If there are no children under 5 years of age in the household, this section is skipped and Benchmark 4 will automatically be marked Yes.'
                : 'Instruction: There is no child under 5 years of age in this household. This section is skipped and Benchmark 4 will automatically be marked Yes.',
          ),
          if (hasChildUnder5) ...[
            _instructionField(
              id: bm4ChildUnderSixMonthsInstructionId,
              name:
              'For a child under the age of 6 months, do not assess MUAC and bipedal edema. Visually assess any child under the age of 6 months. If the child looks undernourished according to your judgment, the child has not met Benchmark 4. The following assessment should be done for each child aged 6–59 months. Use additional pages if necessary.',
            ),
            InputField(
              id: bm4ChildId,
              name: 'Child’s ID',
              valueType: 'TEXT',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
            ),
            _instructionField(
              id: bm4MuacInstructionId,
              name:
              'Assess the child’s MUAC and bipedal edema if you have been trained in how to conduct these assessments. If you have not received this training, request that MUAC be measured by a health worker or case management worker trained in assessing MUAC and bipedal edema.',
            ),
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
          ],
          InputField(
            id: 'IdZyZAJ6GH2',
            name: hasChildUnder5
                ? 'Has Benchmark 4 been met for this beneficiary?'
                : '',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: bm5SectionId,
        name: 'Benchmark 5: Prevention of Mother To Child Transmission',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          _instructionField(
            id: bm5InstructionId,
            name: hasPmtctTarget
                ? 'Instruction: The HIV status of the pregnant adolescent or woman is already known, so Question 5.1 is skipped. Continue with the applicable PMTCT questions below.'
                : 'Instruction: There is no pregnant adolescent, pregnant woman, or HEI in this household. This section is skipped and Benchmark 5 will automatically be marked Yes.',
          ),
          if (hasPmtctTarget) ...[
            InputField(
              id: 'Yx7plSKvybh',
              name: 'Beneficiary’s ID',
              valueType: 'TEXT',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
            ),
            _instructionField(
              id: bm5HivNegativeInstructionId,
              name:
              'Instruction: Question 5.1 is skipped because the HIV status of the pregnant adolescent or woman is already known. Continue with the applicable PMTCT questions and allow the benchmark status to auto-populate.',
            ),
            InputField(
              id: 'X1bXtYz9jRC',
              name:
              '5.2. Is the HIV positive pregnant woman or adolescent currently attending ANC services?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
            ),
            _instructionField(
              id: bm5DeliveredInstructionId,
              name:
              'If the woman/adolescent has already delivered, ask the infant testing questions below.',
            ),
            InputField(
              id:'sENV9jT7sWc',
              name:
              '5.3. Has the infant born from an HIV positive adolescent or woman in the household been tested for HIV at the appropriate age? Consider six weeks, six months, and eighteen months.',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
              id: bm5Question54Id,
              name:
              '5.4. If the infant has been tested for HIV, is the child HIV negative?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF4D9E49),
              labelColor: const Color(0xFF737373),
            ),
            _instructionField(
              id: bm5NoteId,
              name:
              'Note: The household of a pregnant adolescent or woman who tests positive for HIV should not be graduated. They should be monitored until delivery, and monitoring should continue until the HIV exposed infant outcome is determined. If the HEI is confirmed HIV positive, the child status should change to CLHIV and the household should continue benefitting from the KB Bokamoso OVC Project. If the child test is negative, the benchmark can be marked Yes.',
            ),
          ],
          InputField(
            id: 'aPcPm4f7Tt',
            name: hasPmtctTarget ? 'Benchmark 5 outcome' : '',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'BITMHHBQDM7',
        name: 'Graduation Benchmarks Assessment',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'S5bMqu2LyKJ',
            name:
            'Have all applicable benchmarks been met? (Benchmarks 1–5 marked Yes or N/A)',
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