
import 'package:flutter/foundation.dart';
import 'package:lncmis_mobile_app/core/offline_db/enrollment_offline/enrollment_offline_provider.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';

/// MGYSD Case Management module list-state
/// - Mirrors patterns used by other intervention list-states
/// - Uses placeholder DHIS2 Program ID (replace later)
class MgysdCaseManagementListState with ChangeNotifier {
  bool _isLoading = true;
  int _numberOfMgysdCases = 0;

  // ✅ Replace later with real MGYSD DHIS2 program id
  static const String mgysdProgramId = 'MGYSD_PROGRAM_ID';

  bool get isLoading => _isLoading;
  int get numberOfMgysdCases => _numberOfMgysdCases;

  /// Refresh counts displayed on the intervention card
  Future<void> refreshMgysdCasesNumber() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Uses existing EnrollmentOfflineProvider (we are NOT changing it)
      final int count =
      await EnrollmentOfflineProvider().getEnrollmentsCount(mgysdProgramId);

      _numberOfMgysdCases = count;
    } catch (e) {
      // keep app stable
      _numberOfMgysdCases = 0;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Optional helper if you want to set count manually during testing
  void setMgysdCasesNumber(int value) {
    _numberOfMgysdCases = value;
    notifyListeners();
  }

  /// Optional: reset
  void reset() {
    _isLoading = true;
    _numberOfMgysdCases = 0;
    notifyListeners();
  }
}
