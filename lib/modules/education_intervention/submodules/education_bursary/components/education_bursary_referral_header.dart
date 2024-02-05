import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:provider/provider.dart';

class EducationBursaryReferralHeader extends StatelessWidget {
  const EducationBursaryReferralHeader({
    Key? key,
    required this.referralIndex,
    required this.canEdit,
    this.onView,
    this.onEdit,
  }) : super(key: key);
  final int referralIndex;
  final bool canEdit;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final Color valueColor = const Color(0xFF82898D);

  InkWell _getActionButton({
    required String svgIcon,
    required VoidCallback? onTap,
  }) {
    double iconHeight = 20.0;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: iconHeight,
        width: iconHeight,
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 5.0,
        ),
        child: SvgPicture.asset(
          svgIcon,
          colorFilter: const ColorFilter.mode(
            Color(0xFF009688),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    languageState.currentLanguage == 'lesotho'
                        ? 'Phetisetso $referralIndex'
                        : 'Referral $referralIndex',
                    style: const TextStyle().copyWith(
                      color: valueColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  child: _getActionButton(
                    svgIcon: 'assets/icons/expand_icon.svg',
                    onTap: onView,
                  ),
                ),
                Visibility(
                  visible: canEdit,
                  child: _getActionButton(
                    svgIcon: 'assets/icons/edit-icon.svg',
                    onTap: onEdit,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
