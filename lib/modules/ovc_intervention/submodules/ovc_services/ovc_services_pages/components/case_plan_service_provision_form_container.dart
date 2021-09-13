import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/household_service_provision.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_service_provision.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/child_case_plan/constants/ovc_child_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/constants/ovc_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/ovc_services_pages/household_case_plan/constants/ovc_household_case_plan_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/skip_logics/ovc_case_plan_service_provision_skip_logic.dart';
import 'package:provider/provider.dart';

class CasePlanServiceProvisionFormContainer extends StatefulWidget {
  const CasePlanServiceProvisionFormContainer({
    Key? key,
    required this.dataObject,
    required this.isCasePlanForHousehold,
    required this.domainId,
    required this.isEditableMode,
  }) : super(key: key);

  final Map dataObject;
  final bool isCasePlanForHousehold;
  final String? domainId;
  final bool isEditableMode;

  @override
  _CasePlanServiceProvisionFormContainerState createState() =>
      _CasePlanServiceProvisionFormContainerState();
}

class _CasePlanServiceProvisionFormContainerState
    extends State<CasePlanServiceProvisionFormContainer>
    with OvcCasePlanServiceProvisionSkipLogic {
  bool isFormReady = false;
  bool isSaving = false;
  List<FormSection>? formSections;
  Map? mandatoryFieldObject;
  Color? formSectionColor;
  Map? dataObject;

  @override
  void initState() {
    dataObject = widget.dataObject;
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        mandatoryFieldObject = Map();
        formSections = widget.isCasePlanForHousehold
            ? HouseholdServiceProvision.getFormSections()
            : OvcServicesChildServiceProvision.getFormSections();
        formSections = formSections!
            .where((formSection) => formSection.id == widget.domainId)
            .toList();
        formSectionColor = formSections!.length > 0
            ? formSections![0].borderColor
            : Colors.transparent;
        formSections = formSections!.map((formSection) {
          formSection.borderColor = Colors.transparent;
          return formSection;
        }).toList();
        isFormReady = true;
      });
      evaluateSkipLogics(context, formSections!, widget.dataObject);
      setState(() {});
    });
  }

  void onSaveGapForm(
    BuildContext context,
    Map? dataObject,
    OvcHousehold? currentOvcHousehold,
    OvcHouseholdChild? currentOvcHouseholdChild,
  ) async {
    if (widget.dataObject.keys.length > 1) {
      setState(() {
        isSaving = true;
      });
      String program = widget.isCasePlanForHousehold
          ? OvcHouseholdCasePlanConstant.program
          : OvcChildCasePlanConstant.program;
      String programStage = widget.isCasePlanForHousehold
          ? OvcHouseholdCasePlanConstant.casePlanGapServiceProvisionProgramStage
          : OvcChildCasePlanConstant.casePlanGapServiceProvisionProgramStage;
      String? orgUnit = widget.isCasePlanForHousehold
          ? currentOvcHousehold!.orgUnit
          : currentOvcHouseholdChild!.orgUnit;
      String? beneficiaryId = widget.isCasePlanForHousehold
          ? currentOvcHousehold!.id
          : currentOvcHouseholdChild!.id;
      String? eventDate = dataObject!['eventDate'];
      String? eventId = dataObject['eventId'];
      List<String> hiddenFields = [
        OvcCasePlanConstant.casePlanGapToFollowUpLinkage
      ];
      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
          program,
          programStage,
          orgUnit,
          formSections!,
          dataObject,
          eventDate,
          beneficiaryId,
          eventId,
          hiddenFields,
        );
        Timer(Duration(seconds: 1), () {
          setState(() {
            isSaving = false;
          });
          Provider.of<ServiceEventDataState>(context, listen: false)
              .resetServiceEventDataState(beneficiaryId);
          String? currentLanguage =
              Provider.of<LanguageTranslationState>(context, listen: false)
                  .currentLanguage;
          AppUtil.showToastMessage(
            message: currentLanguage == 'lesotho'
                ? 'Fomo e bolokeile'
                : 'Form has been saved successfully',
            position: ToastGravity.TOP,
          );
          Navigator.pop(context);
        });
      } catch (e) {
        Timer(Duration(seconds: 1), () {
          setState(() {
            isSaving = false;
            AppUtil.showToastMessage(
              message: e.toString(),
              position: ToastGravity.BOTTOM,
            );
            Navigator.pop(context);
          });
        });
      }
    } else {
      AppUtil.showToastMessage(
          message: 'Please fill at least one field',
          position: ToastGravity.TOP);
    }
  }

  void onInputValueChange(String id, dynamic value) {
    setState(() {
      widget.dataObject[id] = value;
    });
    evaluateSkipLogics(context, formSections!, widget.dataObject);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !isFormReady
          ? Container(
              child: CircularProcessLoader(
                color: Colors.blueGrey,
              ),
            )
          : Container(
              child: Column(
                children: [
                  EntryFormContainer(
                    hiddenFields: hiddenFields,
                    hiddenSections: hiddenSections,
                    elevation: 0.0,
                    formSections: formSections,
                    mandatoryFieldObject: mandatoryFieldObject,
                    dataObject: widget.dataObject,
                    isEditableMode: widget.isEditableMode,
                    onInputValueChange: onInputValueChange,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                    child: Visibility(
                      visible: widget.isEditableMode,
                      child: Row(
                        children: [
                          Expanded(
                            child: Consumer<OvcHouseholdCurrentSelectionState>(
                              builder: (
                                context,
                                ovcHouseholdCurrentSelectionState,
                                child,
                              ) {
                                OvcHousehold? currentOvcHousehold =
                                    ovcHouseholdCurrentSelectionState
                                        .currentOvcHousehold;
                                OvcHouseholdChild? currentOvcHouseholdChild =
                                    ovcHouseholdCurrentSelectionState
                                        .currentOvcHouseholdChild;
                                return TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: formSectionColor,
                                  ),
                                  onPressed: () => onSaveGapForm(
                                      context,
                                      dataObject,
                                      currentOvcHousehold,
                                      currentOvcHouseholdChild),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 22.0),
                                    child: Text(
                                      isSaving
                                          ? 'SAVING SERVICE ...'
                                          : 'SAVE SERVICE',
                                      style: TextStyle().copyWith(
                                        color: Color(0xFFFAFAFA),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
