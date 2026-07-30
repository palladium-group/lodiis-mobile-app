import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/models/household_graduation_rediness_form.dart';
import 'package:provider/provider.dart';

class OvcHouseholdCasePlanAchievementSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};

  static bool _isTrueValue(
      dynamic value, {
        bool defaultValue = false,
      }) {
    if (value == null) return defaultValue;

    final raw = '$value'.trim().toLowerCase();

    if (raw.isEmpty || raw == 'null') return defaultValue;

    return raw == 'true' || raw == 'yes' || raw == '1';
  }

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

    if (hivStatus != 'Positive') {
      hiddenSections['lMG85SRv6nS'] = true;
    }

    final hasAdolescentAged10To17 = _isTrueValue(
      dataObject[HouseholdGraduationReadinessForm.cparaHasAdolescentAged10To17],
      defaultValue: true,
    );

    final hasChildUnder5 = _isTrueValue(
      dataObject[HouseholdGraduationReadinessForm.cparaHasChildUnder5],
      defaultValue: true,
    );

    final hasPmtctTarget = _isTrueValue(
      dataObject[HouseholdGraduationReadinessForm.cparaHasPmtctTarget],
      defaultValue: true,
    );

    final shouldSkipPmtctHivTestQuestion = _isTrueValue(
      dataObject[
      HouseholdGraduationReadinessForm.cparaSkipPmtctHivTestQuestion],
      defaultValue: false,
    );

    inputFieldIds = inputFieldIds.toSet().toList();

    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';

      if (inputFieldId == 'naaNy5zLz3I' && value != 'false') {
        hiddenFields['FOimOq843Ly'] = true;
        hiddenFields['q8HfJgKMqrM'] = true;
      }

      if (inputFieldId == 'wE7and4EnCR') {
        bool isBenchmarkMet = '${dataObject["WFjzAp3wQ8M"]}' == 'true' &&
            '${dataObject["aoGIcQaTXjh"]}' == 'true';

        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
        dataObject[inputFieldId] = '$isBenchmarkMet';
      } else if (inputFieldId == 'R71zksHtVNn') {
        bool isBenchmarkMet = '${dataObject["naaNy5zLz3I"]}' == 'true' ||
            ('${dataObject["FOimOq843Ly"]}' == 'true' &&
                '${dataObject["q8HfJgKMqrM"]}' == 'true');

        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
        dataObject[inputFieldId] = '$isBenchmarkMet';
      } else if (inputFieldId ==
          HouseholdGraduationReadinessForm.bm3MetId) {
        bool isBenchmarkMet = !hasAdolescentAged10To17 ||
            ('${dataObject[HouseholdGraduationReadinessForm.bm3Question31Id]}' ==
                'true' &&
                '${dataObject[HouseholdGraduationReadinessForm.bm3Question32Id]}' ==
                    'true');

        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
        dataObject[inputFieldId] = '$isBenchmarkMet';
      } else if (inputFieldId ==
          HouseholdGraduationReadinessForm.bm4MetId) {
        bool isBenchmarkMet = !hasChildUnder5 ||
            ('${dataObject[HouseholdGraduationReadinessForm.bm4Question41Id]}' ==
                'true' &&
                '${dataObject[HouseholdGraduationReadinessForm.bm4Question42Id]}' ==
                    'true');

        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
        dataObject[inputFieldId] = '$isBenchmarkMet';
      } else if (inputFieldId ==
          HouseholdGraduationReadinessForm.bm5MetId) {
        bool isBenchmarkMet = !hasPmtctTarget ||
            ((shouldSkipPmtctHivTestQuestion ||
                '${dataObject[HouseholdGraduationReadinessForm.bm5Question51Id]}' ==
                    'true') &&
                '${dataObject[HouseholdGraduationReadinessForm.bm5Question52Id]}' ==
                    'true' &&
                '${dataObject[HouseholdGraduationReadinessForm.bm5Question53Id]}' ==
                    'true' &&
                '${dataObject[HouseholdGraduationReadinessForm.bm5Question54Id]}' ==
                    'true');

        assignInputFieldValue(context, inputFieldId, '$isBenchmarkMet');
        dataObject[inputFieldId] = '$isBenchmarkMet';
      } else if (inputFieldId == 'S5bMqu2LyKJ') {
        Map<String, String> benchmarkQuestionsMapping =
        HouseholdGraduationReadinessForm.getBenchMarkAchievementQuestions();

        final latestDataObject =
            Provider.of<ServiceFormState>(context, listen: false).formState;

        bool areAllBenchmarksMet = benchmarkQuestionsMapping.keys
            .where((benchmarkSession) =>
        !hiddenSections.containsKey(benchmarkSession))
            .every((benchmarkSession) {
          final achievementQuestionId =
          benchmarkQuestionsMapping[benchmarkSession];

          return _isTrueValue(
            latestDataObject[achievementQuestionId] ??
                dataObject[achievementQuestionId],
          );
        });

        assignInputFieldValue(context, inputFieldId, '$areAllBenchmarksMet');
        dataObject[inputFieldId] = '$areAllBenchmarksMet';
      }
    }

    for (String sectionId in hiddenSections.keys) {
      List<FormSection> allFormSections =
      FormUtil.getFlattenFormSections(formSections);

      List<String> hiddenSectionInputFieldIds = FormUtil.getFormFieldIds(
        allFormSections
            .where((formSection) => formSection.id == sectionId)
            .toList(),
      );

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
