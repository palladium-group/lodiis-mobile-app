import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:lncmis_mobile_app/models/intervention_card.dart';
import 'package:provider/provider.dart';

class InputSearchClearIcon extends StatelessWidget {
  const InputSearchClearIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InterventionCardState>(
        builder: (context, interventionCardState, child) {
      InterventionCard activeInterventionProgram =
          interventionCardState.currentInterventionProgram;
      return Container(
        height: 20.0,
        margin: const EdgeInsets.only(
          left: 10,
        ),
        child: Icon(
          Icons.search_off,
          color: activeInterventionProgram.countLabelColor,
        ),
      );
    });
  }
}
