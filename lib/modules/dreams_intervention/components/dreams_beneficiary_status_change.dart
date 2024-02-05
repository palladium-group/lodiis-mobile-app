import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/constants/program_status.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/services/agyw_dreams_enrollment_service.dart';
import 'package:provider/provider.dart';

class DreamsBeneficiaryStatusChange extends StatefulWidget {
  const DreamsBeneficiaryStatusChange({
    Key? key,
    required this.agywDream,
  }) : super(key: key);

  final AgywDream agywDream;

  @override
  State<DreamsBeneficiaryStatusChange> createState() =>
      _DreamsBeneficiaryStatusChangeState();
}

class _DreamsBeneficiaryStatusChangeState
    extends State<DreamsBeneficiaryStatusChange> {
  TrackedEntityInstance? _trackedEntityInstance;
  bool isSaving = false;
  final String programStatusId = 'PN92g65TkVI';
  final String reasonToDropOutID = '';
  Map dataObject = {};
  Map hiddenFields = {};
  List<String> mandatoryFields = [];
  List unFilledMandatoryFields = [];
  Map mandatoryFieldObject = {};
  late List<FormSection> dreamsStatusChangeForm = [];

  @override
  void initState() {
    super.initState();
    setFormSections();
  }

  void updateFormSavingState(bool savingState) {
    setState(() {
      isSaving = savingState;
    });
  }

  void onSaveForm(BuildContext context) async {
    updateFormSavingState(true);
    dataObject.removeWhere(((key, value) => value == null || value == ''));
    setMandatoryFields(dataObject);
    bool hadAllMandatoryFilled = FormUtil.hasAllMandatoryFieldsFilled(
      mandatoryFields,
      dataObject,
      hiddenFields: hiddenFields,
      checkBoxInputFields: FormUtil.getInputFieldByValueType(
        valueType: 'CHECK_BOX',
        formSections: dreamsStatusChangeForm,
      ),
    );
    if (hadAllMandatoryFilled) {
      if (FormUtil.geFormFilledStatus(dataObject, dreamsStatusChangeForm)) {
        var trackedEntityInstance =
            _trackedEntityInstance?.trackedEntityInstance;
        var orgUnit = _trackedEntityInstance?.orgUnit;
        List<String> hiddenFieldsIds = [];
        hiddenFields.forEach((key, value) {
          if (value == true && key != '') {
            hiddenFieldsIds.add(key);
          }
        });
        await AgywDreamsEnrollmentService().updateAgywBeneficiaryStatus(
            dataObject, trackedEntityInstance, orgUnit, hiddenFieldsIds,
            formSections: dreamsStatusChangeForm);
        Provider.of<DreamsInterventionListState>(context, listen: false)
            .refreshAllDreamsLists();
        AppUtil.showToastMessage(
          message:
              "${widget.agywDream.firstname} ${widget.agywDream.surname}'s status was updated.",
          position: ToastGravity.BOTTOM,
        );
        Navigator.pop(context);
      } else {
        AppUtil.showToastMessage(
          message: 'Please fill all mandatory fields!',
          position: ToastGravity.BOTTOM,
        );
      }
    } else {
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields!',
        position: ToastGravity.BOTTOM,
      );
    }

    updateFormSavingState(false);
  }

  void onValueChanged(String id, dynamic value) {
    setState(() {
      dataObject[id] = value;
    });
    evaluateSkipLogic();
  }

  void hideFields({
    required String id,
    bool hidden = true,
  }) {
    setState(() {
      if (hidden) {
        hiddenFields[id] = hidden;
      } else if (hiddenFields.containsKey(id)) {
        hiddenFields.remove(id);
      }
    });
  }

  evaluateSkipLogic() {
    final bool hideReason =
        dataObject[programStatusId] != ProgramStatus.dropOut;
    hideFields(id: reasonToDropOutID, hidden: hideReason);
    setState(() {
      if (hideReason) {
        dataObject[reasonToDropOutID] = '';
      }
    });
  }

  void setMandatoryFields(Map<dynamic, dynamic> dataObject) {
    setState(() {
      unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
        mandatoryFields,
        dataObject,
        hiddenFields: hiddenFields,
        checkBoxInputFields: FormUtil.getInputFieldByValueType(
          valueType: 'CHECK_BOX',
          formSections: dreamsStatusChangeForm,
        ),
      );
    });
  }

  void setFormSections() {
    setState(() {
      mandatoryFields = [
        // reasonToDropOutID,
        programStatusId,
      ];
      for (String fieldId in mandatoryFields) {
        mandatoryFieldObject[fieldId] = true;
      }
      dreamsStatusChangeForm.add(FormSection(
        name: 'Beneficiary Status Form',
        color: const Color(0xFF737373),
        inputFields: [
          InputField(
            id: programStatusId,
            name: 'Beneficiary Status',
            translatedName: 'Boemo ba mojalefa ka hara morero',
            valueType: 'TEXT',
            isReadOnly:
                widget.agywDream.programStatus != ProgramStatus.inActive,
            inputColor: const Color(0xFF258DCC),
            labelColor: const Color(0xFF737373),
            options: [
              InputFieldOption(
                code: ProgramStatus.active,
                name: ProgramStatus.active,
              ),
              InputFieldOption(
                code: ProgramStatus.dropOut,
                name: ProgramStatus.dropOut,
              ),
              InputFieldOption(
                code: ProgramStatus.inActive,
                name: ProgramStatus.inActive,
              ),
            ],
          ),
        ],
      ));
      _trackedEntityInstance = widget.agywDream.trackedEntityInstanceData;
      dataObject[programStatusId] = widget.agywDream.programStatus;
      dataObject[reasonToDropOutID] = '';
      evaluateSkipLogic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
      String currentLanguage = languageTranslationState.currentLanguage;
      return Column(children: [
        Container(
          margin: const EdgeInsets.only(
            top: 10.0,
            left: 13.0,
            right: 13.0,
          ),
          child: EntryFormContainer(
            hiddenFields: hiddenFields,
            hiddenSections: const {},
            formSections: dreamsStatusChangeForm,
            mandatoryFieldObject: mandatoryFieldObject,
            unFilledMandatoryFields: unFilledMandatoryFields,
            isEditableMode: true,
            dataObject: dataObject,
            onInputValueChange: onValueChanged,
          ),
        ),
        EntryFormSaveButton(
          label: isSaving
              ? currentLanguage == 'lesotho'
                  ? 'E ntse e boloka ...'
                  : 'Saving ...'
              : 'Save',
          labelColor: Colors.white,
          buttonColor: const Color(0xFF258DCC),
          fontSize: 15.0,
          onPressButton: () => onSaveForm(
            context,
          ),
        )
      ]);
    });
  }
}
