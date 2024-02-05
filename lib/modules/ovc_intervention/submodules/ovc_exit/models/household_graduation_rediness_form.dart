import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class HouseholdGraduationReadinessForm {
  static Map<String, String> getBenchMarkAchievementQuestions() {
    return {
      "jZHYkQntXh9": 'wE7and4EnCR',
      "lMG85SRv6nS": 'R71zksHtVNn',
      "wt4kydQK4OV": 'OcbE9kN8Dcp',
      "f410nsa35Jw": 'YdqDLYSE4qr',
      "Ol19OWE8uDF": 'obB7bvy6Nmh',
      "BA3VEvk4tLo": 'iu8k78dy9VP',
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
            name: 'Has Benchmark 2 been met? ',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'wt4kydQK4OV',
        name: 'Benchmark 3: Food Security and Nutrition',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'LxhULNWvXMw',
            name:
                '3.1 Have all the children in the household eaten at least two meals per day in the past six months?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'gYudLSw0eUU',
            name:
                '3.2  Are you able to provide your child with a range of nutritious (at least 2 food groups) foods on a regular basis, please describe?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'OcbE9kN8Dcp',
            name: 'Has Benchmark 3 been met?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          )
        ],
      ),
      FormSection(
        id: 'f410nsa35Jw',
        name: 'Benchmark 4: Financially stable',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'UwWV44GogSL',
            name:
                '4.1. Were you or another caregiver in the household able to pay school fees for the last school year for all children and adolescents in your household under the age of 18?',
            translatedName:
                '4.1. Na uena kapa mohlokomeli e mong ka lapeng le khonne ho lefa chelete ea sekolo selemong se fetileng sa bana bohle le bacha ba lelapeng la hau ba ka tlase ho lilemo tse 18?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'l4Xysq5ZfL9',
            name:
                '4.2. Were you able to pay these school fees without using a cash transfer, grant, or scholarship from [name of CBO or KB OVC project]? ',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'jRWqOcwnNkb',
            name:
                '4.3. Were you able to pay for these school fees without selling something used to generate income that you did not plan or want to sell, such as livestock, land for agriculture, tools, or equipment for a business?',
            translatedName:
                '4.3. A na u ile ua khona ho lefella chelete ee ea sekolo ntle le ho rekisa ntho eo u neng u sa e rera kapa ua batla ho e rekisa, joalo ka leruo, mobu oa temo, lisebelisoa, kapa thepa ea khoebo?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'C65Ca8Oel2w',
            name:
                '4.4. Were you or another caregiver in the household able to pay all medical costs in the past 6 months for all children and adolescents in your household under the age of 18? Medical costs include medicine, clinic fees, and transport to medical appointments.',
            translatedName:
                '4.4. Na uena kapa mohlokomeli e mong ka lapeng le khonne ho lefa litšenyehelo tsohle tsa bongaka likhoeling tse 6 tse fetileng bakeng sa bana bohle le bacha ba lelapeng la hau ba ka tlase ho lilemo tse 18? Litšenyehelo tsa bongaka li kenyelletsa meriana, litefiso tsa tleliniki, le lipalangoang ho ea ho lingaka',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            name:
                '4.5. Were you able to pay for these medical costs without using a cash transfer or grant from [name of CBO or OVC project]? ',
            id: 'WE3SRhYYZT5',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'OeqFCpXjRCm',
            name:
                '4.6. Were you able to pay for these medical costs without selling something used to generate income that you did not plan or want to sell, such as livestock, land for agriculture, tools, or equipment for a business?',
            translatedName:
                '4.6. Na u ile ua khona ho lefella litšenyehelo tsee tsa phekolo ntle le ho rekisa ntho e sebelisetsoang ho etsa chelete eo u sa kang ua e rera kapa ua batla ho e rekisa, e kang leruo, mobu oa temo, lisebelisoa, kapa thepa ea khoebo?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'YdqDLYSE4qr',
            name: 'Has Benchmark 4 been met?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          )
        ],
      ),
      FormSection(
        id: 'Ol19OWE8uDF',
        name: 'Benchmark 5: No violence reported',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'jJzwnW4XyMy',
            name:
                '5.1. In the past 6 months, have you been punched, kicked, choked or beaten by a spouse or partner, or any other adult?',
            translatedName:
                '5.1. Likhoeling tse 6 tse fetileng, na u kile ua otloa ka litebele, ua rahoa, ua khangoa kapa ua shapuoa ke molekane, kapa motho ofe kapa ofe e moholo?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'AyBcZfx7zLA',
            name:
                '5.2. In the past 6 months, are you aware of any child, adolescent, or youth in your household being punched, kicked, choked or beaten by an adult?',
            translatedName:
                '5.2. Likhoeling tse 6 tse fetileng, na u kile ua hlokomela ka ngoana kapa mocha ka lapeng la heno ea ileng a otloa ka litebele, a rahoa, a khangoa kapa a shapuoa ke motho e moholo?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'oPGYBk5RXif',
            name:
                '5.3. In the past 6 months, are you aware of any child, adolescent, or youth in your household being touched in a sexual way or forced to have sex against his or her will? Touching in a sexual way could include fondling, pinching, grabbing, or touching a child, adolescent, or youth on or around his or her sexual body parts',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'BV5IywMXKhe',
            name:
                '5.4. In the past 6 months, are you aware of any child, adolescent, or youth in your household being touched in a sexual way or forced to have sex against his or her will? Touching in a sexual way could include fondling, pinching, grabbing, or touching a child, adolescent, or youth on or around his or her sexual body parts',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'obB7bvy6Nmh',
            name: 'Has Benchmark 5 been met?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
        ],
      ),
      FormSection(
        id: 'BA3VEvk4tLo',
        name: 'Benchmark 6: Not in a child-headed household',
        color: const Color(0xFF4D9E49),
        borderColor: const Color(0xFF4D9E49),
        inputFields: [
          InputField(
            id: 'SdUYosM4meg',
            name:
                '6.1. During the past 12 months, have all children and adolescents in the household been under the care of a stable adult caregiver?',
            translatedName:
                '6.1. Likhoeling tse 12 tse fetileng, na bana bohle le bacha ba ka tlung ba bile tlasa tlhokomelo ea mohlokomeli ea tsitsitseng ea holileng?',
            valueType: 'BOOLEAN',
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          ),
          InputField(
            id: 'iu8k78dy9VP',
            name: 'Has Benchmark 6 been met?',
            valueType: 'BOOLEAN',
            isReadOnly: true,
            inputColor: const Color(0xFF4D9E49),
            labelColor: const Color(0xFF737373),
          )
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
            name: 'Have all applicable benchmarks been met? ',
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
