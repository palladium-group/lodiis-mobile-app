import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/models/household_graduation_rediness_form.dart';
import 'package:provider/provider.dart';

class OvcHouseholdCasePlanAchievementSkipLogic {
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

    var hivStatus = dataObject['hivStatus'];

    // Hide sections based on HIV status
    if (hivStatus != 'Positive') {
      hiddenSections['lMG85SRv6nS'] = true;
    }

    inputFieldIds = inputFieldIds.toSet().toList();
    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';

      if (inputFieldId == 'naaNy5zLz3I' && value != 'false') {
        hiddenFields['FOimOq843Ly'] = true;
        hiddenFields['q8HfJgKMqrM'] = true;
      } else if (inputFieldId == 'UwWV44GogSL' && value != 'true') {
        hiddenFields['l4Xysq5ZfL9'] = true;
        hiddenFields['jRWqOcwnNkb'] = true;
      } else if (inputFieldId == 'C65Ca8Oel2w' && value != 'true') {
        hiddenFields['WE3SRhYYZT5'] = true;
        hiddenFields['OeqFCpXjRCm'] = true;
      }

      // Benchmark 1
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
      // Benchmark 3
      else if (inputFieldId == 'OcbE9kN8Dcp') {
        bool isBenchmarkMet = '${dataObject["gYudLSw0eUU"]}' == 'true' &&
            '${dataObject["LxhULNWvXMw"]}' == 'true';
        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
      } // Benchmark 4
      else if (inputFieldId == 'YdqDLYSE4qr') {
        bool isBenchmarkMet = '${dataObject["UwWV44GogSL"]}' == 'true' &&
            '${dataObject["l4Xysq5ZfL9"]}' == 'true' &&
            '${dataObject["jRWqOcwnNkb"]}' == 'true' &&
            '${dataObject["C65Ca8Oel2w"]}' == 'true' &&
            '${dataObject["WE3SRhYYZT5"]}' == 'true' &&
            '${dataObject["OeqFCpXjRCm"]}' == 'true';
        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
      } // Benchmark 5
      else if (inputFieldId == 'obB7bvy6Nmh') {
        bool isBenchmarkMet = '${dataObject["jJzwnW4XyMy"]}' == 'false' &&
            '${dataObject["AyBcZfx7zLA"]}' == 'false' &&
            '${dataObject["oPGYBk5RXif"]}' == 'false' &&
            '${dataObject["BV5IywMXKhe"]}' == 'false';
        '${dataObject["oPGYBk5RXif"]}' == 'false';
        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
      } // Benchmark 6
      else if (inputFieldId == 'iu8k78dy9VP') {
        bool isBenchmarkMet = '${dataObject["SdUYosM4meg"]}' == 'true';
        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
      } // Final Assessment
      else if (inputFieldId == 'S5bMqu2LyKJ') {
        Map<String, String> benchmarkQuestionsMapping =
            HouseholdGraduationReadinessForm.getBenchMarkAchievementQuestions();
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
