import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/models/bio_data_index_contacts.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/constants/agyw_dreams_hts_index_constant.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:provider/provider.dart';

class AgywDreamsIndexContact extends StatefulWidget {
  const AgywDreamsIndexContact({Key? key}) : super(key: key);

  @override
  State<AgywDreamsIndexContact> createState() => _AgywDreamsIndexContactState();
}

class _AgywDreamsIndexContactState extends State<AgywDreamsIndexContact> {
  final String label = 'HTS Index contact';
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      formSections = BioDataIndexContacts.getFormSections();
      setState(() {
        isFormReady = true;
      });
    });
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
    autoFillInputFields(id, value);
  }

  void autoFillInputFields(String id, dynamic value) {
    if (id == 'Y0QGNDBCEbz') {
      int age = AppUtil.getAgeInYear(value);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('cYoXGqzLXLr', age.toString());
    }
  }

  void onSaveForm(
      BuildContext context, Map dataObject, AgywDream? agywDream) async {
    if (FormUtil.geFormFilledStatus(dataObject, formSections)) {
      setState(() {
        isSaving = true;
      });
      String? eventDate = dataObject['eventDate'];
      String? eventId = dataObject['eventId'];
      dataObject[AgywDreamsHTSIndexConstant
          .indexContactToElicitedSexualPartnerLinkage] = dataObject[
              AgywDreamsHTSIndexConstant
                  .indexContactToElicitedSexualPartnerLinkage] ??
          AppUtil.getUid();
      List<String> hiddenFields = [
        AgywDreamsHTSIndexConstant.indexInfoToIndexContactLinkage,
        AgywDreamsHTSIndexConstant.indexContactToElicitedSexualPartnerLinkage
      ];
      try {
        await TrackedEntityInstanceUtil.savingTrackedEntityInstanceEventData(
            AgywDreamsHTSIndexConstant.program,
            AgywDreamsHTSIndexConstant.programStage,
            agywDream!.orgUnit,
            formSections!,
            dataObject,
            eventDate,
            agywDream.id,
            eventId,
            hiddenFields);
        Provider.of<ServiceEventDataState>(context, listen: false)
            .resetServiceEventDataState(agywDream.id);
        Timer(const Duration(seconds: 1), () {
          setState(() {
            isSaving = false;
          });
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
        Timer(const Duration(seconds: 1), () {
          setState(() {
            AppUtil.showToastMessage(
                message: e.toString(), position: ToastGravity.BOTTOM);
          });
        });
      }
    } else {
      AppUtil.showToastMessage(
          message: 'Please fill at least one form field',
          position: ToastGravity.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65.0),
          child: Consumer<InterventionCardState>(
            builder: (context, interventionCardState, child) {
              InterventionCard activeInterventionProgram =
                  interventionCardState.currentInterventionProgram;
              return SubPageAppBar(
                label: label,
                activeInterventionProgram: activeInterventionProgram,
              );
            },
          ),
        ),
        body: SubPageBody(
          body: Consumer<LanguageTranslationState>(
            builder: (context, languageTranslationState, child) {
              String? currentLanguage =
                  languageTranslationState.currentLanguage;
              return Consumer<DreamsBeneficiarySelectionState>(
                builder: (context, nonAgywState, child) {
                  AgywDream? agywDream = nonAgywState.currentAgywDream;
                  return Consumer<ServiceFormState>(
                    builder: (context, serviceFormState, child) {
                      return Column(
                        children: [
                          DreamsBeneficiaryTopHeader(
                            agywDream: agywDream,
                          ),
                          !isFormReady
                              ? const CircularProcessLoader(
                                  color: Colors.blueGrey,
                                )
                              : Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        top: 10.0,
                                        left: 13.0,
                                        right: 13.0,
                                      ),
                                      child: EntryFormContainer(
                                        formSections: formSections,
                                        mandatoryFieldObject: const {},
                                        isEditableMode:
                                            serviceFormState.isEditableMode,
                                        dataObject: serviceFormState.formState,
                                        onInputValueChange: onInputValueChange,
                                      ),
                                    ),
                                    Visibility(
                                      visible: serviceFormState.isEditableMode,
                                      child: EntryFormSaveButton(
                                        label: isSaving
                                            ? currentLanguage == 'lesotho'
                                                ? 'E ntse e boloka...'
                                                : 'Saving ...'
                                            : currentLanguage == 'lesotho'
                                                ? 'Boloka'
                                                : 'Save',
                                        labelColor: Colors.white,
                                        buttonColor: const Color(0xFF258DCC),
                                        fontSize: 15.0,
                                        onPressButton: () => onSaveForm(
                                            context,
                                            serviceFormState.formState,
                                            agywDream),
                                      ),
                                    )
                                  ],
                                )
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: const InterventionBottomNavigationBarContainer());
  }
}
