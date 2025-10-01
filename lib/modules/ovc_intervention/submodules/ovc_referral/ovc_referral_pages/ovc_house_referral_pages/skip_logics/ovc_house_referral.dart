import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:provider/provider.dart';

class OvcHouseholdReferralSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};
  static Map hiddenInputFieldOptions = {};

  static Future evaluateSkipLogics(
    BuildContext context,
    List<FormSection> formSections,
    Map dataObject,
  ) async {
    hiddenFields.clear();
    hiddenSections.clear();
    hiddenInputFieldOptions.clear();
    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }
    inputFieldIds = inputFieldIds.toSet().toList();
    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';
      if (inputFieldId == 'qAed23reDPP' && value != 'Community') {
        hiddenSections['SeRefoCo'] = true;
      }
      if (inputFieldId == 'qAed23reDPP' && value != 'Facility') {
        hiddenSections['SeRefoFa'] = true;
      }
      if (inputFieldId == 'LLWTHwhnch0' && value != 'null') {
        Map hiddenOptions = {};
        if (value == 'Clinical Services') {
          hiddenOptions['Youth friendly services'] = true;
          hiddenOptions['Gender Based Violence'] = true;
          hiddenOptions['Domestic Violence Support group'] = true;
          hiddenOptions['Income generating activity'] = true;
          hiddenOptions['Orphan Care & Support'] = true;
          hiddenOptions['Psycho-social Support'] = true;
          hiddenOptions['PLHIV support group'] = true;
          hiddenOptions['Referral to post abuse care services'] = true;
          hiddenOptions['Violence Against Children'] = true;
          hiddenOptions['CAG'] = true;
          hiddenOptions['Home based care visits'] = true;
          hiddenOptions['Educational and vocational support'] = true;
          hiddenOptions['Social grants'] = true;
        } else if (value == 'Post abuse case management') {
          hiddenOptions['Youth friendly services'] = true;
          hiddenOptions['Income generating activity'] = true;
          hiddenOptions['Orphan Care & Support'] = true;
          hiddenOptions['Psycho-social Support'] = true;
          hiddenOptions['PLHIV support group'] = true;
          hiddenOptions['CAG'] = true;
          hiddenOptions['Home based care visits'] = true;
          hiddenOptions['Educational and vocational support'] = true;
          hiddenOptions['STI Screening'] = true;
          hiddenOptions['STI Treatment'] = true;
          hiddenOptions['HIV Testing and counselling'] = true;
          hiddenOptions['Evaluation for ARVs/HAART'] = true;
          hiddenOptions['ART and Adherence'] = true;
          hiddenOptions['PMTCT Services'] = true;
          hiddenOptions['FamilyPlanningSRH'] = true;
          hiddenOptions['Condom supply'] = true;
          hiddenOptions['TB screening'] = true;
          hiddenOptions['TB treatment'] = true;
          hiddenOptions['Nutrition'] = true;
          hiddenOptions['VMMC'] = true;
          hiddenOptions['Cervical Cancer Screening'] = true;
          hiddenOptions['ECD'] = true;
          hiddenOptions['HTS'] = true;
          hiddenOptions['ANC'] = true;
          hiddenOptions['EID Testing'] = true;
          hiddenOptions['PrEP/PEP'] = true;
          hiddenOptions['PMTCT'] = true;
          hiddenOptions['Social grants'] = true;
        } else if (value == 'Social Services') {
          hiddenOptions['Referral to post abuse care services'] = true;
          hiddenOptions['STI Screening'] = true;
          hiddenOptions['STI Treatment'] = true;
          hiddenOptions['HIV Testing and counselling'] = true;
          hiddenOptions['Evaluation for ARVs/HAART'] = true;
          hiddenOptions['ART and Adherence'] = true;
          hiddenOptions['PMTCT Services'] = true;
          hiddenOptions['FamilyPlanningSRH'] = true;
          hiddenOptions['Condom supply'] = true;
          hiddenOptions['TB screening'] = true;
          hiddenOptions['TB treatment'] = true;
          hiddenOptions['Nutrition'] = true;
          hiddenOptions['VMMC'] = true;
          hiddenOptions['Cervical Cancer Screening'] = true;
          hiddenOptions['ECD'] = true;
          hiddenOptions['HTS'] = true;
          hiddenOptions['ANC'] = true;
          hiddenOptions['EID Testing'] = true;
          hiddenOptions['PrEP/PEP'] = true;
          hiddenOptions['PMTCT'] = true;
          hiddenOptions['Gender Based Violence'] = true;
          hiddenOptions['Domestic Violence Support group'] = true;
          hiddenOptions['Violence Against Children'] = true;
        }
        hiddenInputFieldOptions['rsh5Kvx6qAU'] = hiddenOptions;
      }
      if (inputFieldId == 'AuCryxQYmrk' && value != 'null') {
        Map hiddenOptions = {};
        if (value == 'Clinical Services') {
          hiddenOptions['Youth friendly services'] = true;
          hiddenOptions['Gender Based Violence'] = true;
          hiddenOptions['Domestic Violence Support group'] = true;
          hiddenOptions['Income generating activity'] = true;
          hiddenOptions['Orphan Care & Support'] = true;
          hiddenOptions['Psycho-social Support'] = true;
          hiddenOptions['PLHIV support group'] = true;
          hiddenOptions['Referral to post abuse care services'] = true;
          hiddenOptions['Violence Against Children'] = true;
          hiddenOptions['CAG'] = true;
          hiddenOptions['Home based care visits'] = true;
          hiddenOptions['Educational and vocational support'] = true;
          hiddenOptions['Social grants'] = true;
        } else if (value == 'Post abuse case management') {
          hiddenOptions['Youth friendly services'] = true;
          hiddenOptions['Income generating activity'] = true;
          hiddenOptions['Orphan Care & Support'] = true;
          hiddenOptions['Psycho-social Support'] = true;
          hiddenOptions['PLHIV support group'] = true;
          hiddenOptions['CAG'] = true;
          hiddenOptions['Home based care visits'] = true;
          hiddenOptions['Educational and vocational support'] = true;
          hiddenOptions['STI Screening'] = true;
          hiddenOptions['STI Treatment'] = true;
          hiddenOptions['HIV Testing and counselling'] = true;
          hiddenOptions['Evaluation for ARVs/HAART'] = true;
          hiddenOptions['ART and Adherence'] = true;
          hiddenOptions['PMTCT Services'] = true;
          hiddenOptions['FamilyPlanningSRH'] = true;
          hiddenOptions['Condom supply'] = true;
          hiddenOptions['TB screening'] = true;
          hiddenOptions['TB treatment'] = true;
          hiddenOptions['Nutrition'] = true;
          hiddenOptions['VMMC'] = true;
          hiddenOptions['Cervical Cancer Screening'] = true;
          hiddenOptions['ECD'] = true;
          hiddenOptions['HTS'] = true;
          hiddenOptions['ANC'] = true;
          hiddenOptions['EID Testing'] = true;
          hiddenOptions['PrEP/PEP'] = true;
          hiddenOptions['PMTCT'] = true;
          hiddenOptions['Social grants'] = true;
        } else if (value == 'Social Services') {
          hiddenOptions['Referral to post abuse care services'] = true;
          hiddenOptions['STI Screening'] = true;
          hiddenOptions['STI Treatment'] = true;
          hiddenOptions['HIV Testing and counselling'] = true;
          hiddenOptions['Evaluation for ARVs/HAART'] = true;
          hiddenOptions['ART and Adherence'] = true;
          hiddenOptions['PMTCT Services'] = true;
          hiddenOptions['FamilyPlanningSRH'] = true;
          hiddenOptions['Condom supply'] = true;
          hiddenOptions['TB screening'] = true;
          hiddenOptions['TB treatment'] = true;
          hiddenOptions['Nutrition'] = true;
          hiddenOptions['VMMC'] = true;
          hiddenOptions['Cervical Cancer Screening'] = true;
          hiddenOptions['ECD'] = true;
          hiddenOptions['HTS'] = true;
          hiddenOptions['ANC'] = true;
          hiddenOptions['EID Testing'] = true;
          hiddenOptions['PrEP/PEP'] = true;
          hiddenOptions['PMTCT'] = true;
          hiddenOptions['Gender Based Violence'] = true;
          hiddenOptions['Domestic Violence Support group'] = true;
          hiddenOptions['Violence Against Children'] = true;
        }
        hiddenInputFieldOptions['OrC9Bh2bcFz'] = hiddenOptions;
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
    resetValuesForHiddenInputFieldOptions(context);
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

  static resetValuesForHiddenInputFieldOptions(BuildContext context) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenInputFieldOptions(hiddenInputFieldOptions);
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
