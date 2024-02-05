import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/input_fields/input_field_container.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/online_beneficiary_search_result_card.dart';
import 'package:kb_mobile_app/core/constants/intervention_program_mapper.dart';
import 'package:kb_mobile_app/core/services/tracked_entity_instance_service.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/models/online_beneficiary_search_input.dart';
import 'package:kb_mobile_app/models/online_beneficiary_search_result.dart';
import 'package:provider/provider.dart';

class OnlineBeneficiarySearch extends StatefulWidget {
  const OnlineBeneficiarySearch({Key? key}) : super(key: key);

  @override
  State<OnlineBeneficiarySearch> createState() =>
      _OnlineBeneficiarySearchState();
}

class _OnlineBeneficiarySearchState extends State<OnlineBeneficiarySearch> {
  Map<String, String> onlineSearchDataObject = {};
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
    var value = onlineSearchDataObject[inputId];
    return value != null && value.isNotEmpty;
  }

  void searchInputChange(String id, String? value) {
    setState(() {
      onlineSearchDataObject[id] = value ?? '';
    });
  }

  void updateSearchState() {
    if (mounted) {
      setState(() {
        isSearching = !isSearching;
      });
    }
  }

  void updateSearchResultMessage(String message) {
    if (mounted) {
      setState(() {
        searchResultMessage = message;
      });
    }
  }

  void updateSearchResults(
      {List<OnlineBeneficiarySearchResult> results = const []}) {
    if (mounted) {
      setState(() {
        searchResults = results;
      });
      updateSearchState();
      if (results.isEmpty) {
        updateSearchResultMessage('No results found');
      } else {
        updateSearchResultMessage('');
      }
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

  String getApiFilterString() {
    // remove empty values
    onlineSearchDataObject.removeWhere((String key, String value) {
      return value.isEmpty;
    });

    List<String> apiFilters = [];
    onlineSearchDataObject.forEach((key, value) {
      apiFilters.add('$key:like:$value');
    });

    return apiFilters.join('&filter=');
  }

  Future<void> onBeneficiarySearch(BuildContext context, String program) async {
    String currentLanguage =
        Provider.of<LanguageTranslationState>(context, listen: false)
            .currentLanguage;
    FocusScope.of(context).requestFocus(FocusNode());
    List<OnlineBeneficiarySearchResult> searchedTeis = [];
    updateSearchResults();
    updateSearchResultMessage('');

    String searchFilterUrl = getApiFilterString();

    try {
      List<String> searchablePrograms =
          getSearchableProgramsByUserAccess(context, program);
      if (searchablePrograms.isEmpty) {
        updateSearchResultMessage(currentLanguage == 'lesotho'
            ? "Ha u na tokelo ea ho batla lits'ebeletsong tsena"
            : 'You do not have searching access to this intervention');
        return;
      }

      List<dynamic> results = await TrackedEntityInstanceService()
          .discoveringBeneficiaryByFilters(searchablePrograms, searchFilterUrl);
      searchedTeis = results
          .map((result) => OnlineBeneficiarySearchResult().fromJson(result))
          .toList();
    } catch (error) {
      //
    }
    updateSearchResults(results: searchedTeis);
  }

  List<String> getSearchableProgramsByUserAccess(
      BuildContext context, String intervention) {
    Map<String, List<String>> programMapper =
        InterventionProgramMapper.programs;

    List<String> interventionPrograms = programMapper[intervention] ?? [];
    List userPrograms = Provider.of<CurrentUserState>(context, listen: false)
            .currentUser!
            .programs ??
        [];

    return interventionPrograms
        .where((program) => userPrograms.contains(program))
        .toList();
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
                                        ? 'Batla ngoana ka hare ho marang-rang'
                                        : 'Online Beneficiary Search',
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
                                                onBeneficiarySearch(
                                                    context, program)
                                              }
                                          },
                                          child: Text(
                                            languageTranslationState
                                                        .currentLanguage ==
                                                    'lesotho'
                                                ? "Batla"
                                                : "Search",
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
                                                  onlineSearchDataObject,
                                              onInputValueChange: (String id,
                                                      dynamic value) =>
                                                  searchInputChange(id, value))
                                        ],
                                      ),
                                    ));
                              }).toList(),
                              Visibility(
                                  visible: searchResults.isNotEmpty ||
                                      searchResultMessage.isNotEmpty,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            margin: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: const Text(
                                              'Search Results',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0),
                                            )),
                                      ],
                                    ),
                                  )),
                              Visibility(
                                  visible: searchResultMessage.isNotEmpty,
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin:
                                          const EdgeInsets.only(bottom: 15.0),
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(searchResultMessage))),
                              ...searchResults.map((result) {
                                return OnlineBeneficiarySearchResultCard(
                                  searchResult: result,
                                  primaryColor: primaryColor,
                                  lineColor: lineColor,
                                );
                              }),
                            ])),
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
