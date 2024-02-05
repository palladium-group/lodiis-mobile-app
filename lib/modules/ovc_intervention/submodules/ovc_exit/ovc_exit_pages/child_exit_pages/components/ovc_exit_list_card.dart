import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:provider/provider.dart';

class OvcExitListCard extends StatelessWidget {
  const OvcExitListCard({
    Key? key,
    required this.eventData,
    required this.programStageMap,
    this.onViewExit,
    this.onEditExit,
    this.canEditExit = true,
  }) : super(key: key);

  final Events eventData;
  final Map programStageMap;
  final Function? onViewExit;
  final Function? onEditExit;
  final bool canEditExit;

  @override
  Widget build(BuildContext context) {
    double iconHeight = 20;
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) {
        var defaultLabel =
            languageState.currentLanguage == 'lesotho' ? 'Etsoa ' : 'Exit';
        return Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 17.0,
          ),
          child: MaterialCard(
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '${eventData.eventDate}   ',
                            style: const TextStyle().copyWith(
                              color: const Color(0xFF92A791),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                text: programStageMap[
                                        eventData.programStage ?? ''] ??
                                    defaultLabel,
                                style: const TextStyle().copyWith(
                                  color: const Color(0xFF1A3518),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: InkWell(
                            onTap: onViewExit as void Function()?,
                            child: Container(
                              height: iconHeight,
                              width: iconHeight,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: SvgPicture.asset(
                                'assets/icons/expand_icon.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF4B9F46),
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                      ),
                      Visibility(
                        visible:
                            eventData.enrollmentOuAccessible! & canEditExit,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: InkWell(
                              onTap: onEditExit as void Function()?,
                              child: Container(
                                height: iconHeight,
                                width: iconHeight,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: SvgPicture.asset(
                                  'assets/icons/edit-icon.svg',
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF4B9F46),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
