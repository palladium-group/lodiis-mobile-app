import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/intervention_bottom_navigation/intervention_bottom_navigation_bar_container.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/entry_forms/entry_form_container.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dreams_beneficiary_top_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/models/hts_consent.dart';
import 'package:kb_mobile_app/core/components/entry_form_save_button.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/constants/agyw_dreams_hts_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/pages/agyw_dreams_htc_client_decline_service.dart';
import 'package:provider/provider.dart';
import 'agyw_dreams_hts_client_information.dart';

class AgywDreamsHTSConsentForm extends StatefulWidget {
  const AgywDreamsHTSConsentForm({Key? key, this.isComingFromPrep})
      : super(key: key);

  final bool? isComingFromPrep;

  @override
  State<AgywDreamsHTSConsentForm> createState() =>
      _AgywDreamsHTSConsentFormState();
}

class _AgywDreamsHTSConsentFormState extends State<AgywDreamsHTSConsentForm> {
  final String label = 'HTS Consent';
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;
  bool? isComingFromPrep;
  List<String> consentFields = [
    'rguXA70zATn',
    'TcN49hQNZiG',
    'HZ4BrWoGNIO',
    'Gl7NGINbUAV',
    'yVYVJe26S4u',
    'B4xx1IVaAnI',
    'rY4ei8RNw6c'
  ];

  @override
  void initState() {
    super.initState();
    isComingFromPrep = widget.isComingFromPrep;
    formSections = HTSConsent.getFormSections();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isFormReady = true;
      });
    });
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setFormFieldState(id, value);
  }

  bool isConsentGiven(Map dataObject) {
    return !consentFields.every((field) =>
        '${dataObject[field]}' == 'false' || '${dataObject[field]}' == 'null');
  }

  void onSaveForm(BuildContext context, Map dataObject, AgywDream? agywDream) {
    Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
        .setCurrentAgywDream(agywDream);
    if (isConsentGiven(dataObject)) {
      //add no of sexual partners to dataObject
      dataObject[AgywDreamsHTSLongFormConstant.noOfPartnersAttributeKey] =
          getNoOfPartners(agywDream!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgywDreamsHTSClientInformation(
            isComingFromPrep: isComingFromPrep,
          ),
        ),
      );
    } else {
      if (consentFields.every((field) => '${dataObject[field]}' == 'false')) {
        dataObject[AgywDreamsHTSLongFormConstant.noOfPartnersAttributeKey] =
            getNoOfPartners(agywDream!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgywDreamsHTSClientServices(
              isComingFromPrep: isComingFromPrep,
            ),
          ),
        );
      } else {
        AppUtil.showToastMessage(
          message: 'Cannot proceed without consent',
          position: ToastGravity.TOP,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;
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
              body: Consumer<DreamsBeneficiarySelectionState>(
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
                                            : 'Save and Continue',
                                        labelColor: Colors.white,
                                        buttonColor: const Color(0xFF258DCC),
                                        fontSize: 15.0,
                                        onPressButton: () => onSaveForm(
                                          context,
                                          serviceFormState.formState,
                                          agywDream,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            bottomNavigationBar:
                const InterventionBottomNavigationBarContainer());
      },
    );
  }

  getNoOfPartners(AgywDream agywDream) {
    List attributes = agywDream.trackedEntityInstanceData!.attributes ?? [];
    var noOfPartners = attributes.singleWhere(
        (attribute) =>
            attribute['attribute'] ==
            AgywDreamsHTSLongFormConstant.noOfPartnersAttributeKey,
        orElse: () => null); //q8qPtzanSTU
    return noOfPartners != null ? noOfPartners['value'] : '';
  }
}
