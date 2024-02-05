import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

import 'package:kb_mobile_app/core/components/language_selection_card.dart';
import 'package:kb_mobile_app/models/app_language.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:provider/provider.dart';

class LanguageSelectionContainer extends StatefulWidget {
  const LanguageSelectionContainer({
    Key? key,
    required this.selectionLanguageCode,
    required this.currentLanguage,
    required this.showLanguageSettingAppBar,
    this.onSetSelectedLanguage,
  }) : super(key: key);

  final String selectionLanguageCode;
  final String? currentLanguage;
  final bool showLanguageSettingAppBar;
  final Function? onSetSelectedLanguage;

  @override
  State<LanguageSelectionContainer> createState() =>
      _LanguageSelectionContainerState();
}

class _LanguageSelectionContainerState
    extends State<LanguageSelectionContainer> {
  List<AppLanguage> supportedLanguages = AppLanguage.getSupportedLanguage();
  String? _selectionLanguageCode = '';

  void onSelectLanguageCard(
    AppLanguage selectionLanguage,
  ) {
    _selectionLanguageCode = selectionLanguage.id;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant LanguageSelectionContainer oldWidget) {
    super.didUpdateWidget(widget);
    if (oldWidget.selectionLanguageCode != widget.selectionLanguageCode) {
      _selectionLanguageCode = widget.selectionLanguageCode;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) =>
          Consumer<InterventionCardState>(
        builder: (context, interventionCardState, child) {
          InterventionCard currentInterventionProgram =
              interventionCardState.currentInterventionProgram;
          Color? color = currentInterventionProgram.id == null
              ? const Color(0xFF4B9F46)
              : currentInterventionProgram.primaryColor;
          return Stack(
            fit: StackFit.passthrough,
            children: [
              Container(
                color: const Color(0xFFF3F3F3),
                height: size.height,
                width: size.width,
                padding: EdgeInsets.only(top: size.height * 0.1),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          languageState.currentLanguage == 'lesotho'
                              ? 'Khetha Puo'
                              : 'Choose language',
                          style: const TextStyle().copyWith(
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                      Text(
                        languageState.currentLanguage == 'lesotho'
                            ? 'Khetha Puo'
                            : 'Choose language',
                        style: const TextStyle().copyWith(
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.5),
                color: color,
                height: size.height * 0.5,
              ),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                  child: Container(
                    margin: EdgeInsets.only(top: size.height * 0.44),
                    height: size.height * 0.35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          primary: false,
                          mainAxisSpacing: 30.0,
                          crossAxisSpacing: 30.0,
                          shrinkWrap: true,
                          children: supportedLanguages
                              .map((AppLanguage supportedLanguage) =>
                                  GestureDetector(
                                    onTap: () => onSelectLanguageCard(
                                      supportedLanguage,
                                    ),
                                    child: LanguageSelectionCard(
                                      size: size,
                                      color: color,
                                      currentLanguage: widget.currentLanguage,
                                      appLanguage: supportedLanguage,
                                      selectionLanguage: _selectionLanguageCode,
                                    ),
                                  ))
                              .toList(),
                        ),
                        TextButton(
                          onPressed: _selectionLanguageCode == ''
                              ? null
                              : () => widget.onSetSelectedLanguage!(
                                    _selectionLanguageCode,
                                  ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: _selectionLanguageCode != ''
                                    ? const Color(0xFFFAFAFA)
                                    : const Color(0xFF7FBA7C),
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                          ),
                          child: Text(
                            widget.showLanguageSettingAppBar
                                ? widget.currentLanguage == 'lesotho'
                                    ? 'Boloka'
                                    : 'Save'
                                : 'Agree',
                            style: TextStyle(
                              color: _selectionLanguageCode != ''
                                  ? const Color(0xFFFAFAFA)
                                  : const Color(0xFF7FBA7C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
