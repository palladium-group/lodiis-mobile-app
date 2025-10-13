
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/constants/program_status.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_child_count.dart';
import 'package:provider/provider.dart';

class OvcHouseholdCardBody extends StatelessWidget {
  const OvcHouseholdCardBody({
    Key? key,
    required this.ovcHousehold,
  }) : super(key: key);

  final OvcHousehold ovcHousehold;

  bool get _isChildHeaded {
    final ageStr = (ovcHousehold.age ?? '').toString().trim();
    final age = int.tryParse(ageStr) ?? 0;
    return age > 0 && age < 18;
  }

  Expanded _cell({
    required String text,
    required int flex,
    required Color color,
    TextOverflow overflow = TextOverflow.ellipsis,
    int maxLines = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          fontSize: 14.0,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Standard two-column row (1:2 flex) used everywhere
  Widget _kvRow({
    required String label,
    required Widget valueRight, // so we can inject badge next to name
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          _cell(text: label, flex: 1, color: const Color(0XFF536852)),
          Expanded(flex: 2, child: valueRight),
        ],
      ),
    );
  }

  /// CHH badge (same as before, compact)
  Widget _chhBadge() {
    return Tooltip(
      message: 'Child-headed household',
      preferBelow: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE29F), Color(0xFFFFF7D1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFF8C6A00).withOpacity(0.25)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.child_care_rounded, size: 14, color: Color(0xFF1A3518)),
            SizedBox(width: 6),
            Text(
              'CHH',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A3518),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusPill(String programStatus) {
    if (programStatus.isEmpty) return const SizedBox.shrink();

    final Color baseColor = programStatus == ProgramStatus.active
        ? const Color(0xFF4B9F46)
        : programStatus == ProgramStatus.transferred
        ? Colors.amberAccent
        : programStatus == ProgramStatus.exit
        ? Colors.redAccent
        : programStatus == ProgramStatus.graduated
        ? const Color(0xFF1F8DCE)
        : Colors.blueGrey;

    final Color textColor = programStatus == ProgramStatus.transferred
        ? Colors.amberAccent.shade700
        : baseColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.16),
        border: Border.all(color: baseColor),
        borderRadius: BorderRadius.circular(35.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Text(
        programStatus,
        style: TextStyle(color: textColor, fontSize: 12.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        final String? currentLanguage = languageTranslationState.currentLanguage;

        // Right-value widgets for each row (keeps consistent alignment)
        final caregiverRight = Row(
          children: [
            Expanded(
              child: Text(
                ovcHousehold.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Color(0XFF92A791),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (_isChildHeaded) const SizedBox(width: 8),
            if (_isChildHeaded) _chhBadge(),
          ],
        );

        final createdRight = Text(
          ovcHousehold.createdDate ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14.0,
            color: Color(0XFF92A791),
            fontWeight: FontWeight.w500,
          ),
        );

        final locationRight = Text(
          ovcHousehold.location ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14.0,
            color: Color(0XFF92A791),
            fontWeight: FontWeight.w500,
          ),
        );

        final statusRight = Align(
          alignment: Alignment.centerLeft,
          child: _statusPill(ovcHousehold.houseHoldStatus ?? ''),
        );

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
          child: Column(
            children: [
              _kvRow(
                label: currentLanguage == 'lesotho' ? 'Mohlokomeli' : 'Caregiver',
                valueRight: caregiverRight,
              ),
              _kvRow(label: 'Created', valueRight: createdRight),
              _kvRow(
                label: currentLanguage == 'lesotho' ? 'Sebaka' : 'Location',
                valueRight: locationRight,
              ),
              _kvRow(
                label: currentLanguage == 'lesotho' ? 'Boemo' : 'Status',
                valueRight: statusRight,
              ),
              OvcHouseholdChildCount(
                currentLanguage: currentLanguage,
                ovcHousehold: ovcHousehold,
              ),
            ],
          ),
        );
      },
    );
  }
}
