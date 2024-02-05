import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

class BeneficiaryReferralCardButton extends StatelessWidget {
  const BeneficiaryReferralCardButton({
    Key? key,
    required this.themeColor,
    required this.onManage,
    required this.onView,
  }) : super(key: key);

  final Color themeColor;
  final VoidCallback onView;
  final VoidCallback onManage;

  Expanded _getButtonContainer({
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle().copyWith(
            fontSize: 12.0,
            color: themeColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Container(
        margin: const EdgeInsets.symmetric(),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.08),
            ),
            child: Row(
              children: [
                _getButtonContainer(
                  label: languageState.currentLanguage == 'lesotho'
                      ? 'SHEBA'
                      : 'VIEW',
                  onTap: onView,
                ),
                Container(
                  height: 20.0,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: themeColor.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                _getButtonContainer(
                  label: languageState.currentLanguage == 'lesotho'
                      ? 'LAOLA'
                      : 'MANAGE',
                  onTap: onManage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
