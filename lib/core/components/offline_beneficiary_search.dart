import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_bursary_state.dart';
import 'package:kb_mobile_app/app_state/education_intervention_state/education_lbse_state.dart';
import 'package:kb_mobile_app/app_state/intervention_bottom_navigation_state/intervention_bottom_navigation_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ogac_intervention_list_state/ogac_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/input_fields/input_field_container.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/models/online_beneficiary_search_input.dart';
import 'package:kb_mobile_app/models/online_beneficiary_search_result.dart';
import 'package:provider/provider.dart';

class OfflineBeneficiarySearch extends StatefulWidget {
  const OfflineBeneficiarySearch({Key? key, required this.searchedAttributes})
      : super(key: key);
  final Map searchedAttributes;
  @override
  State<OfflineBeneficiarySearch> createState() =>
      _OfflineBeneficiarySearchState();
}

class _OfflineBeneficiarySearchState extends State<OfflineBeneficiarySearch> {
  Map offlineSearchDataObject = {};
  List<OnlineBeneficiarySearchResult> searchResults = [];

  String searchResultMessage = '';
  bool isSearching = false;
  List<BeneficiarySearchInput> searchInputs = [
    BeneficiarySearchInput(
        label: 'First Name',
        inputField: InputField(id: 'WTZ7GLTrE8Q', name: '', valueType: 'TEXT')),
    BeneficiarySearchInput(
        label: 'Surname',
        inputField: InputField(id: 'rSP9c21JsfC', name: '', valueType: 'TEXT')),
    BeneficiarySearchInput(
        label: 'Date of Birth',
        inputField: InputField(id: 'qZP982qpSPS', name: '', valueType: 'DATE')),
    BeneficiarySearchInput(
        label: 'Primary UIC',
        interventions: ['dreams', 'ovc'],
        inputField: InputField(id: 'fTSAY18LgCF', name: '', valueType: 'TEXT')),
    BeneficiarySearchInput(
        label: 'School Name',
        interventions: ['education'],
        inputField: InputField(id: 'EwZil0AnlYo', name: '', valueType: 'TEXT')),
  ];

  bool isItemSearched(BeneficiarySearchInput input) {
    var inputId = input.inputField.id;
    var value = offlineSearchDataObject[inputId];
    return value != null && value.isNotEmpty;
  }

  void searchInputChange(String id, String? value) {
    setState(() {
      offlineSearchDataObject[id] = value ?? '';
    });
  }

  void initializeSearchDataObject() {
    setState(() {
      offlineSearchDataObject = {
        ...offlineSearchDataObject,
        ...widget.searchedAttributes
      };
    });
  }

  void updateSearchState() {
    if (mounted) {
      setState(() {
        isSearching = !isSearching;
      });
    }
  }

  bool canSearch() {
    return searchInputs.any((input) => isItemSearched(input));
  }

  Widget makeFilterDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Future<void> onClearSearchFields(BuildContext context, String program) async {
    setState(() {
      offlineSearchDataObject.clear();
    });
    onBeneficiarySearch(context, program);
  }

  Future<void> onBeneficiarySearch(BuildContext context, String program) async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      InterventionCard activeInterventionProgram =
          Provider.of<InterventionCardState>(context, listen: false)
              .currentInterventionProgram;
      String? currentInterventionBottomNavigationId =
          Provider.of<InterventionBottomNavigationState>(context, listen: false)
              .currentInterventionBottomNavigationId;
      if (activeInterventionProgram.id == 'ogac') {
        Provider.of<OgacInterventionListState>(context, listen: false)
            .searchOgacList(offlineSearchDataObject);
      } else if (activeInterventionProgram.id == 'dreams') {
        if (currentInterventionBottomNavigationId == 'records') {
          Provider.of<DreamsInterventionListState>(context, listen: false)
              .searchAllAgywDreamsLists(offlineSearchDataObject);
        } else if (currentInterventionBottomNavigationId ==
            'incomingReferral') {
          Provider.of<DreamsInterventionListState>(context, listen: false)
              .searchIncomingReferralList(offlineSearchDataObject);
        } else if (currentInterventionBottomNavigationId == 'noneAgyw') {
          Provider.of<DreamsInterventionListState>(context, listen: false)
              .searchNonAgywList(offlineSearchDataObject);
        } else {
          Provider.of<DreamsInterventionListState>(context, listen: false)
              .searchAgywDreamsList(offlineSearchDataObject);
        }
      } else if (activeInterventionProgram.id == 'ovc') {
        if (currentInterventionBottomNavigationId == 'records') {
          Provider.of<OvcInterventionListState>(context, listen: false)
              .searchAllOvcList(offlineSearchDataObject);
        } else {
          Provider.of<OvcInterventionListState>(context, listen: false)
              .searchHousehold(offlineSearchDataObject);
        }
      } else if (activeInterventionProgram.id == 'pp_prev') {
        Provider.of<PpPrevInterventionState>(context, listen: false)
            .searchPpPrevList(offlineSearchDataObject);
      } else if (activeInterventionProgram.id == 'education') {
        if (currentInterventionBottomNavigationId == 'records') {
          Provider.of<EducationLbseInterventionState>(context, listen: false)
              .searchEducationLbseList(offlineSearchDataObject);
          Provider.of<EducationBursaryInterventionState>(context, listen: false)
              .searchAllEducationBursaryLists(offlineSearchDataObject);
        } else if (currentInterventionBottomNavigationId == "lbse") {
          Provider.of<EducationLbseInterventionState>(context, listen: false)
              .searchEducationLbseList(offlineSearchDataObject);
        } else if (currentInterventionBottomNavigationId == "bursary") {
          Provider.of<EducationBursaryInterventionState>(context, listen: false)
              .searchEducationBursaryList(offlineSearchDataObject);
        }
      }
      Navigator.pop(context);
    } catch (error) {
      //
    }
  }

  @override
  void initState() {
    initializeSearchDataObject();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return makeFilterDismissible(
        child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.25,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Consumer<LanguageTranslationState>(
                  builder: (context, languageTranslationState, child) {
                String? currentLanguage =
                    languageTranslationState.currentLanguage;
                return Consumer<InterventionCardState>(
                    builder: (context, interventionCardState, child) {
                  String program =
                      interventionCardState.currentInterventionProgram.id!;
                  var primaryColor = interventionCardState
                      .currentInterventionProgram.primaryColor;
                  var lineColor = interventionCardState
                      .currentInterventionProgram.countLabelColor;
                  var backgroundColor = interventionCardState
                      .currentInterventionProgram.background;

                  String currentIntervention =
                      interventionCardState.currentInterventionProgram.id ?? '';
                  List<BeneficiarySearchInput> filteredSearchInputs =
                      searchInputs
                          .where((input) =>
                              input.interventions!.isEmpty ||
                              input.interventions!
                                  .contains(currentIntervention))
                          .toList();
                  return Container(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        color: Color.alphaBlend(
                            backgroundColor ?? Colors.white, Colors.white)),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    languageTranslationState.currentLanguage ==
                                            'lesotho'
                                        ? ' Batla ngoana kantle ho Marang-rang'
                                        : 'Offline Beneficiary Search',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: isSearching

                                      // Add a cross button to stop the search
                                      ? CircularProcessLoader(
                                          color: primaryColor,
                                          height: 19.0,
                                          width: 19.0,
                                          size: 2,
                                        )
                                      : InkWell(
                                          onTap: () => {
                                            if (canSearch())
                                              {
                                                onClearSearchFields(
                                                    context, program)
                                              }
                                          },
                                          child: Text(
                                            currentLanguage == 'lesotho'
                                                ? 'Hlakola Tsohle'
                                                : 'clear All',
                                            style: TextStyle(
                                                color: canSearch()
                                                    ? primaryColor
                                                    : primaryColor!
                                                        .withOpacity(0.3)),
                                          ),
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                        LineSeparator(color: lineColor!),
                        Flexible(
                            child: ListView(
                                controller: scrollController,
                                children: [
                              ...filteredSearchInputs
                                  .map((BeneficiarySearchInput input) {
                                InputField inputField = input.inputField;
                                inputField.inputColor = primaryColor;
                                return Container(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        childrenPadding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                        ),
                                        title: Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              input.label,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: isItemSearched(input)
                                                      ? primaryColor
                                                      : null,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                          ],
                                        ),
                                        iconColor: primaryColor,
                                        textColor: primaryColor,
                                        children: [
                                          InputFieldContainer(
                                              currentUserCountryLevelReferences: const [],
                                              hiddenFields: const {},
                                              inputField: inputField,
                                              hiddenInputFieldOptions: const {},
                                              currentLanguage:
                                                  languageTranslationState
                                                      .currentLanguage,
                                              isEditableMode: true,
                                              showClearIcon: true,
                                              mandatoryFieldObject: const {},
                                              dataObject:
                                                  offlineSearchDataObject,
                                              onInputValueChange: (String id,
                                                      dynamic value) =>
                                                  searchInputChange(id, value))
                                        ],
                                      ),
                                    ));
                              }).toList(),
                            ])),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            color: interventionCardState
                                .currentInterventionProgram.primaryColor,
                          ),
                          padding: const EdgeInsets.only(
                            right: 5.0,
                          ),
                          child: TextButton(
                            onPressed: () => canSearch()
                                ? {onBeneficiarySearch(context, program)}
                                : null,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                            ),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Text(
                                languageTranslationState.currentLanguage ==
                                        'lesotho'
                                    ? "Batla"
                                    : "Search",
                                style: const TextStyle(
                                  color: Color(0xFFFAFAFA),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom))
                      ],
                    ),
                  );
                });
              });
            }));
  }
}
