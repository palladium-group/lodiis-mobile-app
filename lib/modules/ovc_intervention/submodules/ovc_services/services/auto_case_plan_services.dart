
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';

import '../ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';

class AutoCasePlanService {
  static Future<void> generateCasePlanGaps({
    required BuildContext context,
    required Map assessmentData,
    required String orgUnit,
    required String teiId,
    firstDate,
  }) async {
    try {
      final List<FormSection> formSections =
      OvcHouseholdServicesCasePlanGaps.getFormSections(firstDate: DateTime.now().toIso8601String());

      Map<String, dynamic> dataObject = {
        'eventDate': DateTime.now().toIso8601String(),
      };

      // === Mapping logic from Assessment to Case Plan Gaps ===
      if (assessmentData['blod3xZ2dPP'] == '1') {
        dataObject['HKCv7lkLexo'] = 'true'; // use string 'true' or 'false' if expected
      }

      if (assessmentData['jzmOXiyGGgw'] == 'Yes') {
        dataObject['AccHyrWqhI0'] = 'true';
      }

      // You can add more mapping rules here...

      // Remove any null values from dataObject before saving
      dataObject.removeWhere((key, value) => key == null || value == null);

      // Log full data object before saving
      print('📤 Submitting Case Plan Data: $dataObject');
      print('Form field IDs: ${formSections.expand((s) => s.inputFields!.map((f) => f.id)).toList()}');
      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        OvcHouseholdCasePlanConstant.program,
        OvcHouseholdCasePlanConstant.casePlanGapProgramStage,
        orgUnit,
        formSections,
        dataObject,
        dataObject['eventDate'],
        teiId,
        '', // empty means create a new event
        null,
        skippedFields: [],
      );

      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        OvcHouseholdCasePlanConstant.program,
        OvcHouseholdCasePlanConstant.casePlanProgramStage,
        orgUnit,
        formSections,
        dataObject,
        dataObject['eventDate'],
        teiId,
        '', // empty means create a new event
        null,
        skippedFields: [],
      );
      AppUtil.showToastMessage(
        message: '✅ Case Plan Gaps auto-generated',
        position: ToastGravity.TOP,
      );
    } catch (e, stack) {
      print('❌ Error generating case plan gaps: $e');
      print(stack);
      AppUtil.showToastMessage(
        message: '❌ Failed to generate case plan',
        position: ToastGravity.TOP,
      );
    }
  }
}
