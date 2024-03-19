import 'package:flutter/foundation.dart';
import 'package:kb_mobile_app/models/Intervention_bottom_navigation.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';

class InterventionBottomNavigationState with ChangeNotifier {
  // initial state
  int _currentInterventionBottomNavigationIndex = 0;
  String? _currentInterventionBottomNavigationId;

  // Reducers
  void setCurrentInterventionBottomNavigationStatus(int index, String? id) {
    _currentInterventionBottomNavigationIndex = index;
    _currentInterventionBottomNavigationId = id;
    notifyListeners();
  }

  void resetCurrentInterventionBottomNavigationIndex() {
    _currentInterventionBottomNavigationIndex = 0;
    _currentInterventionBottomNavigationId = null;
    notifyListeners();
  }

  // Selectors
  int get currentInterventionBottomNavigationIndex =>
      _currentInterventionBottomNavigationIndex;

  String? get currentInterventionBottomNavigationId =>
      _currentInterventionBottomNavigationId;

  InterventionBottomNavigation getCurrentInterventionBottomNavigation(
    InterventionCard activeInterventionProgram,
    String implementingPartner,
  ) {
    List<InterventionBottomNavigation> interventionBottomNavigations =
        InterventionBottomNavigation.getInterventionNavigationButtons(
      activeInterventionProgram,
    );
    if (['KB-Facility Based Social Worker', 'Paralegal']
        .contains(implementingPartner)) {
      interventionBottomNavigations = interventionBottomNavigations
          .where((interventionBottomNavigation) =>
              interventionBottomNavigation.id != 'enrollment')
          .toList();
    }
    InterventionBottomNavigation interventionBottomNavigation =
        interventionBottomNavigations.isNotEmpty
            ? interventionBottomNavigations.first
            : InterventionBottomNavigation(id: "", name: "");
    if (_currentInterventionBottomNavigationId != null) {
      var filteredList = interventionBottomNavigations
          .where((nav) => nav.id == _currentInterventionBottomNavigationId)
          .toList();
      interventionBottomNavigation = filteredList.isNotEmpty
          ? filteredList.first
          : interventionBottomNavigation;
    }
    return interventionBottomNavigation;
  }
}
