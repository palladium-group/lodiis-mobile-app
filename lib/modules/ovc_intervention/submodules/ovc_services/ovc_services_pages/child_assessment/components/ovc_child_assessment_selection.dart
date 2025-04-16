import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:provider/provider.dart';

class OvcChildAssessmentSelection extends StatefulWidget {
  const OvcChildAssessmentSelection({Key? key}) : super(key: key);

  @override
  State<OvcChildAssessmentSelection> createState() =>
      _OvcChildAssessmentSelectionState();
}

class _OvcChildAssessmentSelectionState
    extends State<OvcChildAssessmentSelection> {
  final List<String> assessmentTitles = ['Well-being'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: const Text(
              'SELECT ASSESSMENT',
              style: TextStyle(
                color: Color(0xFF4B9F46),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          Consumer<OvcHouseholdCurrentSelectionState>(
            builder: (context, ovcHouseholdCurrentSelectionState, child) {
              OvcHouseholdChild currentOvcHouseholdChild =
                  ovcHouseholdCurrentSelectionState.currentOvcHouseholdChild!;
              int age = int.parse(currentOvcHouseholdChild.age!);
              String? hivStatus = currentOvcHouseholdChild.hivStatus;
              if (age < 18) {
                assessmentTitles.add('TB');
              }

              if (age >= 18) {
                assessmentTitles.add('TB18');
              }
              if (age < 2) {
                assessmentTitles.add('Nutrition');
              }
              if (hivStatus != 'Positive' && age < 12) {
                assessmentTitles.add('HIV');
              }
              return Column(
                children: assessmentTitles.map((assessmentTitle) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const LineSeparator(
                        color: Color(0xFFE0E6E0),
                        height: 1.0,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    Navigator.pop(context, assessmentTitle),
                                child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Text(
                                      assessmentTitle,
                                      style: const TextStyle(
                                        color: Color(0xFF1A3518),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
