import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class HouseholdGraduationReadinessForm {
  static Map<String, String> getBenchMarkAchievementQuestions() {
    return {
      "jZHYkQntXh9": 'wE7and4EnCR',
      "lMG85SRv6nS": 'R71zksHtVNn',

      // TODO: Replace with new DHIS2 section ID and benchmark achievement data element ID.
      "NEW_ID_BENCHMARK_3_SECTION": 'NEW_ID_BENCHMARK_3_MET',

      // TODO: Replace with new DHIS2 section ID and benchmark achievement data element ID.
      "NEW_ID_BENCHMARK_4_SECTION": 'NEW_ID_BENCHMARK_4_MET',

      // TODO: Replace with new DHIS2 section ID and benchmark achievement data element ID.
      "NEW_ID_BENCHMARK_5_SECTION": 'NEW_ID_BENCHMARK_5_MET',

      "wt4kydQK4OV": 'OcbE9kN8Dcp',
      "f410nsa35Jw": 'YdqDLYSE4qr',
      "Ol19OWE8uDF": 'obB7bvy6Nmh',
      "BA3VEvk4tLo": 'iu8k78dy9VP',

      // TODO: Replace with new DHIS2 section ID and benchmark achievement data element ID.
      "NEW_ID_BENCHMARK_10_SECTION": 'NEW_ID_BENCHMARK_10_MET',
    };
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
        id: "jZHYkQntXh9",
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
        // TODO: Replace this placeholder with the new DHIS2 section ID for Benchmark 3.
        id: 'NEW_ID_BENCHMARK_3_SECTION',
        name: 'Benchmark 3: Knowledgeable about HIV prevention',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B3_ADOLESCENT_ID',
            name: 'Adolescent’s ID',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B3_Q_3_1',
            name: '3.1. Has the adolescent identified at least two HIV risks?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B3_Q_3_2',
            name: '3.2. Has the adolescent identified at least one HIV prevention strategy?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_BENCHMARK_3_MET',
            name: 'Has Benchmark 3 been met?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        // TODO: Replace this placeholder with the new DHIS2 section ID for Benchmark 4.
        id: 'NEW_ID_BENCHMARK_4_SECTION',
        name: 'Benchmark 4: Not undernourished',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B4_CHILD_ID',
            name: 'Child’s ID',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B4_Q_4_1',
            name: '4.1. Is the child’s MUAC more than 12.5 cm?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B4_Q_4_2',
            name: '4.2. Is the child free of any signs of bipedal edema?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_BENCHMARK_4_MET',
            name: 'Has Benchmark 4 been met?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        // TODO: Replace this placeholder with the new DHIS2 section ID for Benchmark 5.
        id: 'NEW_ID_BENCHMARK_5_SECTION',
        name: 'Benchmark 5: Prevention of Mother To Child Transmission',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B5_BENEFICIARY_ID',
            name: 'Beneficiary’s ID',
            valueType: 'TEXT',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B5_Q_5_1',
            name: '5.1. Has the pregnant adolescent or woman in the household been tested for HIV?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B5_Q_5_2',
            name: '5.2. Is the HIV positive pregnant woman or adolescent currently attending ANC services?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B5_Q_5_3',
            name: '5.3. Has the infant born from an HIV positive adolescent or woman in the household been tested for HIV at the appropriate age?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_B5_Q_5_4',
            name: '5.4. If the infant has been tested for HIV, is the child HIV negative?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            // TODO: Replace this placeholder with the new DHIS2 data element ID.
            id: 'NEW_ID_BENCHMARK_5_MET',
            name: 'Has Benchmark 5 been met?',
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
            'Have all applicable benchmarks been met? (Benchmarks 1–10 ticked Yes or N/A)',
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
