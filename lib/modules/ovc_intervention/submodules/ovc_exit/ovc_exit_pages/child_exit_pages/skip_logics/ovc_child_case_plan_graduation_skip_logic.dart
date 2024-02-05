import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/models/ovc_graduation_readiness_form.dart';
import 'package:provider/provider.dart';

class OvcChildCasePlanGraduationSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};

  static Future evaluateSkipLogics(
    BuildContext context,
    List<FormSection> formSections,
    Map dataObject,
  ) async {
    hiddenFields.clear();
    hiddenSections.clear();
    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }

    var age = int.parse("${dataObject['age']}");
    var hivStatus = dataObject['hivStatus'];

    // Hidden sections by age
    if (age < 10 || age > 17) {
      hiddenSections['A5NBGrJWy1z'] = true;
    }
    if (age < 6 || age > 17) {
      hiddenSections['ceYTaM00pTh'] = true;
      hiddenSections['P90kJechZJT'] = true;
    }
    if (age < 0 || age > 4) {
      hiddenSections['AScHzfI40br'] = true;
    }

    // Hidden sections by HIV status
    if (hivStatus != 'Positive') {
      hiddenSections['R4OiU8dHKDe'] = true;
    }

    inputFieldIds = inputFieldIds.toSet().toList();
    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';

      if (inputFieldId == 'naaNy5zLz3I' && value != 'false') {
        hiddenFields['FOimOq843Ly'] = true;
        hiddenFields['q8HfJgKMqrM'] = true;
      } else if (inputFieldId == 'zPggDcmT4zt' && value != 'true') {
        hiddenFields['UxPgBn3JRBQ'] = true;
      } else if (inputFieldId == 'fffETOzhGsU' && value != 'true') {
        hiddenFields['LyCBmMgAW4P'] = true;
        hiddenFields['wGeVdyVO5hE'] = true;
      } else if (inputFieldId == 'hiv_risks') {
        var options = OvcGraduationReadinessForm.getInputFieldOptions(
          'A5NBGrJWy1z',
          inputFieldId,
        );
        var selectedOptions =
            options.where((option) => '${dataObject[option.code]}' == 'true');
        assignInputFieldValue(
          context,
          'hxLZDtNtn3p',
          '${selectedOptions.length >= 2}',
        );
      } else if (inputFieldId == 'prevention_strategy') {
        var options = OvcGraduationReadinessForm.getInputFieldOptions(
          'A5NBGrJWy1z',
          inputFieldId,
        );
        var selectedOptions =
            options.where((option) => '${dataObject[option.code]}' == 'true');
        assignInputFieldValue(
          context,
          'ApextZUIUcC',
          '${selectedOptions.isNotEmpty}',
        );
      }

      // Benchmarks skip logics
      // for Benchmark 1
      if (inputFieldId == 'wE7and4EnCR') {
        bool isBenchmarkMet = '${dataObject["WFjzAp3wQ8M"]}' == 'true' &&
            '${dataObject["aoGIcQaTXjh"]}' == 'true';
        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
      }
      // Benchmark 2
      else if (inputFieldId == 'R71zksHtVNn') {
        bool isBenchmarkMet = '${dataObject["naaNy5zLz3I"]}' == 'true' ||
            ('${dataObject["FOimOq843Ly"]}' == 'true' &&
                '${dataObject["q8HfJgKMqrM"]}' == 'true');
        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
      }
      // for Benchmark 3
      else if (inputFieldId == 'rPSpAEnnVS4') {
        // TODO needs closer look
        bool isBenchmarkMet = '${dataObject["hxLZDtNtn3p"]}' == 'true' &&
            '${dataObject["ApextZUIUcC"]}' == 'true';
        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
      } else if (inputFieldId == 'hxLZDtNtn3p') {
      } else if (inputFieldId == 'ApextZUIUcC') {
      }
      // for Benchmark 4
      else if (inputFieldId == 'so1Hnb8K09j') {
        bool isBenchmarkMet = '${dataObject["htotfutRcVF"]}' == 'true' &&
            '${dataObject["F7HWBfHN6tQ"]}' == 'true';
        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
      } // for Benchmark 5
      else if (inputFieldId == 'XxioqueCXcn') {
        bool isBenchmarkMet = ('${dataObject["zPggDcmT4zt"]}' == 'true' &&
                '${dataObject["UxPgBn3JRBQ"]}' == 'true') ||
            ('${dataObject["fffETOzhGsU"]}' == 'true' &&
                '${dataObject["wGeVdyVO5hE"]}' == 'Negative');
        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
      } // for Benchmark 6
      else if (inputFieldId == 'wW0grvww5Iz') {
        bool isBenchmarkMet = '${dataObject["PkvK39frchD"]}' == 'true' &&
            '${dataObject["RVGFbzbEGmY"]}' == 'true' &&
            '${dataObject["HzUAxTw1nZs"]}' == 'true';
        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
      }
      // for overall assessment
      else if (inputFieldId == 'S5bMqu2LyKJ') {
        Map<String, String> benchmarkQuestionsMapping =
            OvcGraduationReadinessForm.getBenchMarkAchievementQuestions();
        bool areAllBenchmarksMet = benchmarkQuestionsMapping.keys
            .where((benchmarkSession) =>
                !hiddenSections.containsKey(benchmarkSession))
            .every((benchmarkSession) =>
                '${dataObject[benchmarkQuestionsMapping[benchmarkSession]]}' ==
                'true');
        assignInputFieldValue(context, inputFieldId, '$areAllBenchmarksMet');
      }
    }
    for (String sectionId in hiddenSections.keys) {
      List<FormSection> allFormSections =
          FormUtil.getFlattenFormSections(formSections);
      List<String> hiddenSectionInputFieldIds = FormUtil.getFormFieldIds(
          allFormSections
              .where((formSection) => formSection.id == sectionId)
              .toList());
      for (String inputFieldId in hiddenSectionInputFieldIds) {
        hiddenFields[inputFieldId] = true;
      }
    }
    resetValuesForHiddenFields(context, hiddenFields.keys);
    resetValuesForHiddenSections(context, formSections);
  }

  static resetValuesForHiddenFields(BuildContext context, inputFieldIds) {
    for (String inputFieldId in inputFieldIds) {
      if (hiddenFields[inputFieldId]) {
        assignInputFieldValue(context, inputFieldId, null);
      }
    }
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenFields(hiddenFields);
  }

  static resetValuesForHiddenSections(
    BuildContext context,
    List<FormSection> formSections,
  ) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenSections(hiddenSections);
  }

  static assignInputFieldValue(
    BuildContext context,
    String inputFieldId,
    String? value,
  ) {
    Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
      inputFieldId,
      value,
      isChangesBasedOnSkipLogic: true,
    );
  }
}
