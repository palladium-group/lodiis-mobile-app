import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/constants/app_hierarchy_reference.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:provider/provider.dart';

class BeneficiaryReferralFollowUpModal extends StatefulWidget {
  const BeneficiaryReferralFollowUpModal({
    Key? key,
    required this.themeColor,
    required this.isOvcIntervention,
    required this.enrollmentOuAccessible,
    required this.referralToFollowUpLinkage,
    required this.formSections,
    required this.beneficiary,
    required this.referralFollowUpStage,
    required this.referralProgram,
    required this.hiddenFields,
    required this.mandatoryFields,
  }) : super(key: key);

  final Color themeColor;
  final bool isOvcIntervention;
  final bool enrollmentOuAccessible;
  final String referralToFollowUpLinkage;
  final List<FormSection> formSections;
  final TrackedEntityInstance beneficiary;
  final String referralFollowUpStage;
  final String referralProgram;
  final List<String> hiddenFields;
  final List<String> mandatoryFields;

  @override
  State<BeneficiaryReferralFollowUpModal> createState() =>
      _BeneficiaryReferralFollowUpModalState();
}

class _BeneficiaryReferralFollowUpModalState
    extends State<BeneficiaryReferralFollowUpModal> {
  bool _isFormReady = false;
  bool _isSaving = false;
  final Map _mandatoryFieldsObject = {};
  List unFilledMandatoryFields = [];
  List<FormSection>? formSections;

  @override
  void initState() {
    super.initState();
    setEntryFormMetadata();
  }

  void setEntryFormMetadata() {
    _mandatoryFieldsObject.clear();
    if (!widget.enrollmentOuAccessible) {
      FormSection serviceProvisionForm =
          AppUtil.getServiceProvisionLocationSection(
        inputColor: widget.themeColor,
        allowedSelectedLevels: widget.isOvcIntervention
            ? [AppHierarchyReference.communityLevel]
            : [
                AppHierarchyReference.communityLevel,
                AppHierarchyReference.facilityLevel
              ],
        program: widget.referralProgram,
        labelColor: const Color(0xFF737373),
        sectionLabelColor: const Color(0xFF737373),
        formlabel: 'Referral following up Location',
      );
      formSections = [serviceProvisionForm, ...widget.formSections];
      for (String id in FormUtil.getFormFieldIds(
        [serviceProvisionForm],
        includeLocationId: true,
      )) {
        _mandatoryFieldsObject[id] = true;
      }
    } else {
      formSections = widget.formSections;
    }
    for (String id in widget.mandatoryFields) {
      _mandatoryFieldsObject[id] = true;
    }
    evaluateSkipLogics();
    Timer(const Duration(milliseconds: 200), () {
      _isFormReady = true;
      setState(() {});
    });
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    evaluateSkipLogics();
  }

  evaluateSkipLogics() {
    Timer(
      const Duration(milliseconds: 200),
      () {},
    );
  }

  void onSaveForm(
    BuildContext context,
    Map dataObject,
  ) async {
    unFilledMandatoryFields = [];
    setState(() {});
    List mandatoryFields = _mandatoryFieldsObject.keys.toList();
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
    if (isAllMandatoryFilled) {
      _isSaving = true;
      setState(() {});
      dataObject[widget.referralToFollowUpLinkage] =
          dataObject[widget.referralToFollowUpLinkage] ?? '';
      var orgUnit = dataObject['location'] ?? '';
      var eventId = dataObject['eventId'];
      var eventDate = dataObject['eventDate'] ?? dataObject['DPf5mUDoZMy'];
      await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
        widget.referralProgram,
        widget.referralFollowUpStage,
        orgUnit,
        formSections ?? [],
        dataObject,
        eventDate,
        widget.beneficiary.trackedEntityInstance,
        eventId,
        widget.hiddenFields,
        skippedFields: ['location'],
      );
      Provider.of<ServiceEventDataState>(context, listen: false)
          .resetServiceEventDataState(widget.beneficiary.trackedEntityInstance);
      Timer(const Duration(milliseconds: 200), () {
        setState(() {
          _isSaving = false;
          String? currentLanguage =
              Provider.of<LanguageTranslationState>(context, listen: false)
                  .currentLanguage;
          AppUtil.showToastMessage(
            message: currentLanguage == 'lesotho'
                ? 'Fomo e bolokeile'
                : 'Form has been saved successfully',
          );
          Navigator.pop(context);
        });
      });
    } else {
      setState(() {
        unFilledMandatoryFields = FormUtil.getUnFilledMandatoryFields(
          mandatoryFields,
          dataObject,
          hiddenFields: Provider.of<ServiceFormState>(context, listen: false)
              .hiddenFields,
          checkBoxInputFields: FormUtil.getInputFieldByValueType(
            valueType: 'CHECK_BOX',
            formSections: widget.formSections,
          ),
        );
      });
      AppUtil.showToastMessage(
        message: 'Please fill all mandatory fields',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 13.0,
      ),
      child: !_isFormReady
          ? const CircularProcessLoader(
              color: Colors.blueGrey,
            )
          : Container(
              margin: const EdgeInsets.symmetric(),
              child: Consumer<ServiceFormState>(
                builder: (context, serviceFormState, child) {
                  return Column(
                    children: [
                      EntryFormContainer(
                        hiddenSections: serviceFormState.hiddenSections,
                        hiddenFields: serviceFormState.hiddenFields,
                        elevation: 2.0,
                        formSections: formSections,
                        mandatoryFieldObject: _mandatoryFieldsObject,
                        unFilledMandatoryFields: unFilledMandatoryFields,
                        dataObject: serviceFormState.formState,
                        isEditableMode: serviceFormState.isEditableMode,
                        onInputValueChange: onInputValueChange,
                      ),
                      ClipRRect(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                          ),
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: widget.themeColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => _isSaving
                                      ? null
                                      : onSaveForm(
                                          context,
                                          serviceFormState.formState,
                                        ),
                                  child: Text(
                                    _isSaving
                                        ? 'SAVING FOLLOW UP ...'
                                        : 'SAVE FOLLOW UP',
                                    style: const TextStyle().copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFFAFAFA),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
    );
  }
}
