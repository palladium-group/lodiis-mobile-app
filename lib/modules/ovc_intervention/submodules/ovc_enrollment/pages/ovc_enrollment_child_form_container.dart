import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/components/enrolled_children_list.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/models/ovc_enrollment_child.dart';
import 'package:provider/provider.dart';

class OvcEnrollmentChildFormContainer extends StatefulWidget {
  const OvcEnrollmentChildFormContainer({Key? key}) : super(key: key);

  @override
  State<OvcEnrollmentChildFormContainer> createState() =>
      _OvcEnrollmentChildFormContainerState();
}

class _OvcEnrollmentChildFormContainerState
    extends State<OvcEnrollmentChildFormContainer> {
  List<FormSection> formSections = [];
  final List<Map> childrenMapObjects = [];
  bool _isFormready = false;
  final List<String> mandatoryFields = OvcEnrollmentChild.getMandatoryField();
  final Map mandatoryFieldObject = {};

  @override
  void initState() {
    super.initState();
    _assignChildrenOnAutoSaving();
    //TODO support yp reset child map object
    _setFormState();
  }

  _setFormState() {
    for (String id in mandatoryFields) {
      mandatoryFieldObject[id] = true;
    }
    formSections = OvcEnrollmentChild.getFormSections();
    _isFormready = true;
    setState(() {});
  }

  void _assignChildrenOnAutoSaving() {
    try {
      Map dataObject =
          Provider.of<EnrollmentFormState>(context, listen: false).formState;
      for (Map chilMapObject in dataObject["children"]) {
        childrenMapObjects.add(chilMapObject);
      }
    } catch (e) {
      //
    }
  }

  void onInputValueChange(String id, dynamic value) {
    //TODO implement logics on change value
    debugPrint('on value change $id => $value');
  }

  void onSaveAndContinue(BuildContext context) async {
    //TODO handling save and continues
    debugPrint('on saving form');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(65.0),
            child: Consumer<InterventionCardState>(
              builder: (context, interventionCardState, child) {
                InterventionCard activeInterventionProgram =
                    interventionCardState.currentInterventionProgram;
                return SubPageAppBar(
                  label: languageTranslationState.isSesothoLanguage
                      ? 'Foromo ea ngoliso ea ngoana'
                      : 'Child Registration form',
                  activeInterventionProgram: activeInterventionProgram,
                );
              },
            ),
          ),
          body: SubPageBody(
            body: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 13.0,
              ),
              child: !_isFormready
                  ? const Center(
                      child: CircularProcessLoader(color: Colors.blueGrey),
                    )
                  : Column(
                      children: [
                        childrenMapObjects.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 12.0,
                                ),
                                child: EnrolledChildrenList(
                                  childrenList: childrenMapObjects
                                      .map<String?>(
                                          (child) => child['fullName'])
                                      .toList(),
                                ),
                              )
                            : Container(),
                        EntryFormContainer(
                          formSections: formSections,
                          hiddenFields: const {},
                          hiddenSections: const {},
                          hiddenInputFieldOptions: const {},
                          mandatoryFieldObject: mandatoryFieldObject,
                          dataObject: const {},
                          onInputValueChange: onInputValueChange,
                          unFilledMandatoryFields: const [],
                        ),
                        EntryFormSaveButton(
                          label: languageTranslationState.isSesothoLanguage
                              ? 'Boloka ebe u fetela pele'
                              : 'Save and Continue',
                          labelColor: Colors.white,
                          buttonColor: const Color(0xFF4B9F46),
                          fontSize: 15.0,
                          onPressButton: () => onSaveAndContinue(context),
                        ),
                      ],
                    ),
            ),
          ),
          bottomNavigationBar: const InterventionBottomNavigationBarContainer(),
        );
      },
    ));
  }
}
