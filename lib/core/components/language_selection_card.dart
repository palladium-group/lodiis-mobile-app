import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lncmis_mobile_app/core/components/material_card.dart';
import 'package:lncmis_mobile_app/models/app_language.dart';

class LanguageSelectionCard extends StatelessWidget {
  const LanguageSelectionCard({
    Key? key,
    required this.size,
    required this.appLanguage,
    required this.currentLanguage,
    required this.selectionLanguage,
    required this.color,
  }) : super(key: key);

  final Size size;
  final String? currentLanguage;
  final AppLanguage appLanguage;
  final String? selectionLanguage;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: size.width * 0.06,
            backgroundColor: const Color(0xFFF3F3F3),
            backgroundImage: AssetImage(appLanguage.image!),
          ),
          Text(
              currentLanguage == 'lesotho' && appLanguage.translatedName != null
                  ? appLanguage.translatedName!
                  : appLanguage.name!),
          SvgPicture.asset(
            'assets/icons/tick-icon.svg',
            colorFilter: ColorFilter.mode(
              appLanguage.id == selectionLanguage ? color! : Colors.transparent,
              BlendMode.srcIn,
            ),
          )
        ],
      ),
    );
  }
}
