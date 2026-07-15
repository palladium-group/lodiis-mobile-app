
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';

class InterventionSelectionHelper {
  static List<InterventionCard> getInterventionSelections(
      List<InterventionCard> interventionProgramList,
      CurrentUserState currentUserState,
      ) {
    List<InterventionCard> interventionPrograms = [];

    if (currentUserState.canManageOvc) {
      interventionPrograms.addAll(interventionProgramList
          .where((interventionProgram) => interventionProgram.id == 'ovc')
          .toList());
    }

    if (currentUserState.canManageDreams) {
      interventionPrograms.addAll(interventionProgramList
          .where((interventionProgram) => interventionProgram.id == 'dreams')
          .toList());
    }

    if (currentUserState.canManageOGAC) {
      interventionPrograms.addAll(interventionProgramList
          .where((interventionProgram) => interventionProgram.id == 'ogac')
          .toList());
    }

    if (currentUserState.canManageEducation) {
      interventionPrograms.addAll(interventionProgramList
          .where((interventionProgram) => interventionProgram.id == 'education')
          .toList());
    }

    if (currentUserState.canManagePpPrev) {
      String subImplementingPartner =
          currentUserState.currentUser?.subImplementingPartner ?? '';
      if (subImplementingPartner == 'PP_PREV') {
        interventionPrograms.addAll(interventionProgramList
            .where((interventionProgram) => interventionProgram.id == 'pp_prev')
            .toList());
      }
    }


    return interventionPrograms;
  }
}
