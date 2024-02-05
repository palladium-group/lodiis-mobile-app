import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:provider/provider.dart';

class InterventionSelectionCard extends StatelessWidget {
  const InterventionSelectionCard({
    Key? key,
    this.interventionProgram,
    this.interventionProgramId,
    required this.numberOfNoneAgywDreamsBeneficiaries,
    required this.numberOfAgywDreamsBeneficiaries,
    required this.numberOfHouseholds,
    required this.numberOfOvcs,
    required this.numberOfOgac,
    required this.numberPpPrev,
    required this.numberEducationLbse,
    required this.numberEducationBursary,
  }) : super(key: key);

  final InterventionCard? interventionProgram;
  final String? interventionProgramId;
  final int numberOfNoneAgywDreamsBeneficiaries;
  final int numberOfAgywDreamsBeneficiaries;
  final int numberOfHouseholds;
  final int numberOfOvcs;
  final int numberOfOgac;
  final int numberPpPrev;
  final int numberEducationBursary;
  final int numberEducationLbse;

  RichText getCardBeneficiaryLabelAndCount({
    required String label,
    required String count,
  }) {
    return RichText(
      text: TextSpan(
        text: '$label ',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: interventionProgram!.countLabelColor,
        ),
        children: [
          TextSpan(
            text: count,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: interventionProgram!.countColor,
            ),
          )
        ],
      ),
    );
  }

  String getBeneficiaryCardCount({
    required String interventionId,
    required bool isSubtitle,
  }) {
    String beneficiaryCardCount = isSubtitle ? '' : '';
    if (interventionId == 'ovc') {
      beneficiaryCardCount =
          isSubtitle ? numberOfOvcs.toString() : numberOfHouseholds.toString();
    } else if (interventionId == 'dreams') {
      beneficiaryCardCount = isSubtitle
          ? numberOfNoneAgywDreamsBeneficiaries.toString()
          : numberOfAgywDreamsBeneficiaries.toString();
    } else if (interventionId == 'education') {
      beneficiaryCardCount = isSubtitle
          ? numberEducationBursary.toString()
          : numberEducationLbse.toString();
    } else if (interventionId == 'ogac') {
      beneficiaryCardCount =
          isSubtitle ? beneficiaryCardCount : numberOfOgac.toString();
    } else if (interventionId == 'pp_prev') {
      beneficiaryCardCount =
          isSubtitle ? beneficiaryCardCount : numberPpPrev.toString();
    }
    return beneficiaryCardCount;
  }

  String getBeneficiaryCardLabel({
    required String interventionId,
    required bool isSubtitle, required BuildContext context,
  }) {

  String currentLanguage = Provider.of <LanguageTranslationState>(context, listen: false).currentLanguage;  
    String beneficiaryCardLabel = isSubtitle ? '' : currentLanguage=='lesotho'?'Palo ea bajalefa':'# of Beneficiaries:';
    if (interventionId == 'ovc') {
      beneficiaryCardLabel = isSubtitle ? currentLanguage=='lesotho'?'Palo ea OVCs':'# of OVCs:' : currentLanguage=='lesotho'?'Palo ea malapa':'# of Households:';
    } else if (interventionId == 'dreams') {
      beneficiaryCardLabel = isSubtitle ? currentLanguage=='lesotho'?'Palo ea none AGYWS':'# of none-AGWYs:' : currentLanguage=='lesotho'?'Palo ea AGYWS':'# of AGYWS:';
    } else if (interventionId == 'education') {
      beneficiaryCardLabel = isSubtitle ? currentLanguage=='lesotho'?'Palo ea Bursary':'# of BURSARY:' : currentLanguage=='lesotho'?'Palo ea LBSE':'# of LBSE:';
    }
    return beneficiaryCardLabel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 30.0,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 22.0,
                  ),
                  decoration: BoxDecoration(
                    color: interventionProgram!.svgBackgroundColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  width: 65.0,
                  height: 65.0,
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      interventionProgram!.svgIcon!,
                      colorFilter: ColorFilter.mode(
                        interventionProgram!.primaryColor!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interventionProgram!.name!,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: interventionProgram!.nameColor,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getCardBeneficiaryLabelAndCount(
                          label: getBeneficiaryCardLabel(
                            interventionId: interventionProgram!.id!,
                            isSubtitle: false,
                            context: context
                          ),
                          count: getBeneficiaryCardCount(
                            interventionId: interventionProgram!.id!,
                            isSubtitle: false,
                          ),
                        ),
                        getCardBeneficiaryLabelAndCount(
                          label: getBeneficiaryCardLabel(
                            interventionId: interventionProgram!.id!,
                            isSubtitle: true,
                             context: context
                          ),
                          count: getBeneficiaryCardCount(
                            interventionId: interventionProgram!.id!,
                            isSubtitle: true,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 35.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: interventionProgramId == interventionProgram!.id
                  ? interventionProgram!.secondaryColor
                  : const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32.0),
                bottomRight: Radius.circular(32.0),
              ),
            ),
            child: Visibility(
              visible: interventionProgramId == interventionProgram!.id,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: SvgPicture.asset('assets/icons/tick-icon.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
