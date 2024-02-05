import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:provider/provider.dart';

class EducationBursarySchoolTopBarSelection extends StatelessWidget {
  final VoidCallback selectSchoolPerformance;
  final VoidCallback selectSchoolAttendance;
  final bool isSchoolPerformanceSelected;

  const EducationBursarySchoolTopBarSelection({
    Key? key,
    required this.selectSchoolPerformance,
    required this.selectSchoolAttendance,
    required this.isSchoolPerformanceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? currentLanguage =
        Provider.of<LanguageTranslationState>(context, listen: false)
            .currentLanguage;
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.only(),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: Container(
          decoration: const BoxDecoration(color: Colors.black12),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: !isSchoolPerformanceSelected
                        ? const Color(0xFF009688)
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 5.0,
                    ),
                  ),
                  onPressed: selectSchoolAttendance,
                  child: Text(
                    currentLanguage == 'lesotho' ? 'Ho ba teng' : 'Attendance',
                    style: const TextStyle().copyWith(
                      fontSize: 14.0,
                      color: !isSchoolPerformanceSelected
                          ? Colors.white
                          : const Color(0xFF737373),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: isSchoolPerformanceSelected
                        ? const Color(0xFF009688)
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 5.0,
                    ),
                  ),
                  onPressed: selectSchoolPerformance,
                  child: Text(
                    currentLanguage == 'lesotho' ? "Ts'ebetso" : 'Performance',
                    style: const TextStyle().copyWith(
                      fontSize: 14.0,
                      color: isSchoolPerformanceSelected
                          ? Colors.white
                          : const Color(0xFF737373),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
