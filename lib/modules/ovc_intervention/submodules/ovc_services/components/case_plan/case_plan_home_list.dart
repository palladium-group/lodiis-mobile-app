import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/utils/ovc_case_plan_util.dart';
import 'package:provider/provider.dart';

class CasePlanHomeList extends StatelessWidget {
  const CasePlanHomeList({
    Key? key,
    required this.casePlanByDates,
    required this.onEditCasePlan,
    required this.onViewCasePlan,
    required this.isOnCasePlanServiceProvision,
    required this.isOnCasePlanServiceMonitoring,
    this.hasBeneficiaryExitedProgram = false,
  }) : super(key: key);
  final Map<String, List<Events>> casePlanByDates;
  final bool isOnCasePlanServiceProvision;
  final bool isOnCasePlanServiceMonitoring;
  final bool hasBeneficiaryExitedProgram;
  final Function onEditCasePlan;
  final Function onViewCasePlan;

  final double iconHeight = 20.0;
  final double borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    int casePlanIndex = casePlanByDates.keys.length;
    var latestCasePlan = casePlanByDates.keys.first;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 17.0,
      ),
      child: Column(
        children: casePlanByDates.keys.toList().map(
          (String casePlanDate) {
            var index = casePlanIndex - 1;
            casePlanIndex--;
            bool hasEditAccessToCasePlan = OvcCasePlanUtil.hasAccessToEdit(
                    casePlanByDates[casePlanDate]!) &&
                latestCasePlan == casePlanDate;
            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 7.0,
              ),
              child: MaterialCard(
                body: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Color(0xFF4B9F46),
                          width: 10.0,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Consumer<LanguageTranslationState>(
                            builder:
                                (context, languageTranslationState, child) {
                              String? currentLanguage =
                                  languageTranslationState.currentLanguage;
                              return RichText(
                                text: TextSpan(
                                  text: '$casePlanDate   ',
                                  style: const TextStyle().copyWith(
                                    color: const Color(0xFF92A791),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: isOnCasePlanServiceProvision
                                          ? currentLanguage == 'lesotho'
                                              ? 'Phano ea Litsebeletso (moralo oa lintlafatso tsa lelapa ${index + 1})'
                                              : 'Services Provision(Case plan ${index + 1} )'
                                          : isOnCasePlanServiceMonitoring
                                              ? currentLanguage == 'lesotho'
                                                  ? 'Phano ea Litsebeletso (moralo oa lintlafatso tsa lelapa ${index + 1}) '
                                                  : 'Services Monitoring (Case plan ${index + 1})'
                                              : 'Case plan ${index + 1}',
                                      style: const TextStyle().copyWith(
                                        color: const Color(0xFF1A3518),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        _getActionButton(
                          icon: 'assets/icons/expand_icon.svg',
                          onTap: () => onViewCasePlan(
                              casePlanByDates[casePlanDate], casePlanDate),
                        ),
                        Visibility(
                          visible: hasEditAccessToCasePlan &&
                              !hasBeneficiaryExitedProgram &&
                              !(isOnCasePlanServiceMonitoring ||
                                  isOnCasePlanServiceProvision),
                          child: _getActionButton(
                            icon: 'assets/icons/edit-icon.svg',
                            onTap: () => onEditCasePlan(
                                casePlanByDates[casePlanDate], casePlanDate),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _getActionButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5.0,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          child: SvgPicture.asset(
            icon,
            height: iconHeight,
            width: iconHeight,
            colorFilter: const ColorFilter.mode(
              Color(0xFF4B9F46),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
