import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class HTSConsent {
  static List<FormSection> getFormSections() {
    return [
      FormSection(
          name: 'HTS Consent',
          color: const Color(0xFF737373),
          inputFields: [
            InputField(
              id: 'rguXA70zATn',
              name:
                  'Do you confirm that you have been informed about the nature, conduct, benefits, risks and implications involved in undertaking an HIV test?',
              translatedName:
                  'Na u netefatsa hore u tsebisitsoe ka mofuta, boitšoaro, melemo, likotsi le litlamorao tse amehang ha u etsa tlhahlobo ea HIV?',
              valueType: 'BOOLEAN',
              inputColor: const Color(0xFF258DCC),
              labelColor: const Color(0xFF737373),
            ),
            InputField(
                id: 'TcN49hQNZiG',
                name:
                    'Have you also received and understood all the relevant information concerning the proposed test?',
                translatedName:
                    'A na u boetse u amohetse le ho utloisisa lintlha tsohle tse amehang mabapi le tlhahlobo e reriloeng?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'HZ4BrWoGNIO',
                name:
                    'Have you had sufficient opportunity to ask questions and to consider whether you want to proceed with the test?',
                translatedName:
                    'Na u bile le monyetla o lekaneng oa ho botsa lipotso le ho nahana hore na u batla ho tsoela pele ka tlhahlobo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'Gl7NGINbUAV',
                name:
                    'Do you freely and voluntarily agree to the HIV test being performed, which includes taking a blood sample and testing that sample?',
                translatedName:
                    'A na u lumela ka bolokolohi le ka boithatelo hore tlhahlobo ea HIV e etsoe, e kenyeletsang ho nka  mali le ho hlahloba mali ao?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'yVYVJe26S4u',
                name:
                    'Do you agree counselor will inform you of the test results in person?',
                translatedName:
                    'Na u lumela hore moeletsi o tla u tsebisa ka sephetho sa liteko ka seqo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'B4xx1IVaAnI',
                name:
                    'Do you agree that the results of the test may be anonymously used for purposes of research and data collection purposes, provided that such information is de-identified to ensure safeguards as to confidentiality?',
                translatedName:
                    "Na u lumela hore liphetho tsa tlhahlobo li ka 'na tsa sebelisoa ntle ho lebitso molemong oa lipatlisiso le merero ea pokello ea lintlha, ha feela tlhahisoleseling e joalo e sa tsejoe ho netefatsa ts'ireletso mabapi le lekunutu?",
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
            InputField(
                id: 'rY4ei8RNw6c',
                name:
                    'Do you know that at any stage prior to the performance of the test, you are free to withdraw your consent to undergo the test?',
                translatedName:
                    'Na ua tseba hore nakong efe kapa efe pele ho tlhahlobo, u lokolohile ho hula tumello ea hau ea ho etsa tlhahlobo?',
                valueType: 'BOOLEAN',
                inputColor: const Color(0xFF258DCC),
                labelColor: const Color(0xFF737373)),
          ]),
    ];
  }
}
