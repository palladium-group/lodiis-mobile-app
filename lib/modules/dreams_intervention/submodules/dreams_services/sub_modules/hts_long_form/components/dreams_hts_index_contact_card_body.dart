import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/models/index_contact.dart';
import 'package:provider/provider.dart';

class DreamsHTSIndexContactCardBody extends StatelessWidget {
  const DreamsHTSIndexContactCardBody({
    Key? key,
    this.event,
  }) : super(key: key);

  final IndexContact? event;

  @override
  Widget build(BuildContext context) {
    Map eventData = event!.toDataMap();
    return Consumer<LanguageTranslationState>(
        builder: (context, languageTranslationState, child) {
      String currentLanguage = languageTranslationState.currentLanguage;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
        child: Column(
          children: [
            event == null
                ? Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: const Text('Index is not yet registered'))
                : Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Name',
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0xFF82898D),
                                      fontWeight: FontWeight.w500),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  eventData['name'],
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0XFF536852),
                                      fontWeight: FontWeight.w500),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Date of Birth',
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0xFF82898D),
                                      fontWeight: FontWeight.w500),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  eventData['dateOfBirth'],
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0XFF536852),
                                      fontWeight: FontWeight.w500),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  currentLanguage == 'lesotho'
                                      ? 'Lilemo'
                                      : 'Age',
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0xFF82898D),
                                      fontWeight: FontWeight.w500),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  eventData['age'],
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0XFF536852),
                                      fontWeight: FontWeight.w500),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  currentLanguage == 'lesotho'
                                      ? 'Boemo'
                                      : 'Status',
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0xFF82898D),
                                      fontWeight: FontWeight.w500),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  eventData['status'],
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0XFF536852),
                                      fontWeight: FontWeight.w500),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  currentLanguage == 'lesotho'
                                      ? 'Boleng'
                                      : 'Sex',
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0xFF82898D),
                                      fontWeight: FontWeight.w500),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  eventData['sex'],
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0XFF536852),
                                      fontWeight: FontWeight.w500),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Phone Number',
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0xFF82898D),
                                      fontWeight: FontWeight.w500),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  eventData['phoneNumber'],
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0XFF536852),
                                      fontWeight: FontWeight.w500),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      );
    });
  }
}
