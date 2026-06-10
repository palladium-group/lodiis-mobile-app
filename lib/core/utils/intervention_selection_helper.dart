import 'package:lncmis_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:lncmis_mobile_app/models/intervention_card.dart';

class InterventionSelectionHelper {
  static List<InterventionCard> getInterventionSelections(
    List<InterventionCard> interventionProgramList,
    CurrentUserState currentUserState,
  ) {
    if (!currentUserState.canManageMgysd) return <InterventionCard>[];
    return interventionProgramList
        .where((interventionProgram) => interventionProgram.id == 'mgysd')
        .toList();
  }
}
