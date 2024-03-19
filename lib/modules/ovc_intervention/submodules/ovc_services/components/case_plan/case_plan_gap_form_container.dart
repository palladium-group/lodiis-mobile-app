import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/skip_logics/ovc_case_plan_gap_skip_logic.dart';
import 'package:provider/provider.dart';

class CasePlanGapFormContainer extends StatefulWidget {
  const CasePlanGapFormContainer({
    Key? key,
    required this.formSections,
    required this.isEditableMode,
    required this.formSectionColor,
    required this.dataObject,
  }) : super(key: key);

  final List<FormSection> formSections;
  final bool isEditableMode;
  final Color formSectionColor;
  final Map dataObject;

  @override
  State<CasePlanGapFormContainer> createState() =>
      _CasePlanGapFormContainerState();
}

class _CasePlanGapFormContainerState extends State<CasePlanGapFormContainer>
    with OvcCasePlanGapSkipLogic {
  Map mandatoryFieldObject = {};
  List mandatoryFields = [];
  List unFilledMandatoryFields = [];
  Map dataObject = {};

  @override
  void initState() {
    super.initState();
    _setFormMetadata();
  }

  void _setFormMetadata() {
    dataObject = widget.dataObject;
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
    }
    _evaluateSkipLogics();
    setState(() {});
  }

  void _evaluateSkipLogics() {
    OvcHouseholdChild? currentHouseholdChild =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild;
    CurrentUser? currentUser =
        Provider.of<CurrentUserState>(context, listen: false).currentUser;
    dataObject = {
      ...dataObject,
      "implementingPartner": currentUser!.implementingPartner ?? ""
    };
    evaluateSkipLogics(context, widget.formSections, dataObject,
        currentHouseholdChild: currentHouseholdChild);
  }

  void onInputValueChange(String id, dynamic value) {
    dataObject[id] = value;
    setState(() {});
    _evaluateSkipLogics();
    setState(() {});
  }

  void setMandatoryFieldForVacLegalMessage() {
    List vacLegalMessagingMandatoryFields = [
      "TizNGPP6e1d",
      "Q7GxvZD6h99",
      "A4xYu8BYOg7"
    ];
    bool isVacMessageSelected = "${dataObject['aPmPhwm8Zln']}" == "true";
    bool isVacLegalMessageSelected = "${dataObject['AaqeRcyjbyS']}" == "true";
    if (isVacMessageSelected && !isVacLegalMessageSelected) {
      dataObject['AaqeRcyjbyS'] = true;
    } else if (!isVacMessageSelected) {
      dataObject['AaqeRcyjbyS'] = '';
      for (String id in vacLegalMessagingMandatoryFields) {
        dataObject[id] = '';
      }
    }
    isVacLegalMessageSelected = "${dataObject['AaqeRcyjbyS']}" == "true";
    mandatoryFields = [];
    unFilledMandatoryFields = [];
    for (String id in vacLegalMessagingMandatoryFields) {
      if (isVacLegalMessageSelected && isVacMessageSelected) {
        mandatoryFieldObject[id] = true;
        mandatoryFields.add(id);
      }
    }
    _evaluateSkipLogics();
    setState(() {});
  }

  onSaveGapForm(BuildContext context) {
    bool isAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields:
          Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: widget.formSections,
      ),
    );
    unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
      mandatoryFields,
      dataObject,
      hiddenFields:
          Provider.of<ServiceFormState>(context, listen: false).hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: widget.formSections,
      ),
    );
    setState(() {});
    if (isAllMandatoryFilled) {
      bool hasAtLeastOnFieldFilled = FormUtil.hasAtLeastOnFieldFilled(
        hiddenFields: hiddenFields,
        formSections: widget.formSections,
        dataObject: dataObject,
      );
      if (hasAtLeastOnFieldFilled) {
        Navigator.pop(context, dataObject);
      } else {
        AppUtil.showToastMessage(
          message: 'Please fill at least one field',
        );
      }
    } else {
      AppUtil.showToastMessage(
        message: 'Please fill  all mandatory fields',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      child: Column(
        children: [
          EntryFormContainer(
            elevation: 0.0,
            formSections: widget.formSections,
            hiddenFields: hiddenFields,
            hiddenSections: hiddenSections,
            mandatoryFieldObject: mandatoryFieldObject,
            dataObject: dataObject,
            isEditableMode: widget.isEditableMode,
            onInputValueChange: onInputValueChange,
            unFilledMandatoryFields: unFilledMandatoryFields,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 13.0,
            ),
            child: Visibility(
              visible: widget.isEditableMode,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: widget.formSectionColor,
                      ),
                      onPressed: () => onSaveGapForm(context),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          vertical: 22.0,
                        ),
                        child: Consumer<LanguageTranslationState>(
                          builder: (context, languageTranslationState, child) =>
                              Text(
                            languageTranslationState.isSesothoLanguage
                                ? "Eketsa sekheo"
                                : 'ADD GAP',
                            style: const TextStyle().copyWith(
                              color: const Color(0xFFFAFAFA),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
