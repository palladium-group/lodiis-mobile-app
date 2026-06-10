import 'package:lncmis_mobile_app/core/services/preference_provider.dart';

class LanguageSelectionService {
  static const String preferenceKey = 'current_language';

  static Future<String?> getCurrentLanguageSelection() async {
    return await PreferenceProvider.getPreferenceValue(preferenceKey);
  }

  static Future setCurrentLanguageSelection(String value) async {
    await PreferenceProvider.setPreferenceValue(preferenceKey, value);
  }
}
