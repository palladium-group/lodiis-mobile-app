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


  Widget getCardBeneficiaryLabelAndCount({
    required String label,
    required String count,
  }) {
    if (label.trim().isEmpty && count.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return RichText(
      text: TextSpan(
        text: '$label ',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: interventionProgram?.countLabelColor,
        ),
        children: [
          TextSpan(
            text: count,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: interventionProgram?.countColor,
            ),
          ),
        ],
      ),
    );
  }

  String getBeneficiaryCardCount({
    required String interventionId,
    required bool isSubtitle,
  }) {
    String beneficiaryCardCount = '';

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
      beneficiaryCardCount = isSubtitle ? '' : numberOfOgac.toString();
    } else if (interventionId == 'pp_prev') {
      beneficiaryCardCount = isSubtitle ? '' : numberPpPrev.toString();
    }

    return beneficiaryCardCount;
  }

  String getBeneficiaryCardLabel({
    required String interventionId,
    required bool isSubtitle,
    required BuildContext context,
  }) {
    final String currentLanguage =
        Provider.of<LanguageTranslationState>(context, listen: false)
            .currentLanguage;

    String beneficiaryCardLabel = isSubtitle
        ? ''
        : (currentLanguage == 'lesotho'
        ? 'Palo ea bajalefa:'
        : '# of Beneficiaries:');

    if (interventionId == 'ovc') {
      beneficiaryCardLabel = isSubtitle
          ? (currentLanguage == 'lesotho' ? 'Palo ea OVCs:' : '# of OVCs:')
          : (currentLanguage == 'lesotho'
          ? 'Palo ea malapa:'
          : '# of Households:');
    } else if (interventionId == 'dreams') {
      beneficiaryCardLabel = isSubtitle
          ? (currentLanguage == 'lesotho'
          ? 'Palo ea none AGYWs:'
          : '# of none-AGYWs:')
          : (currentLanguage == 'lesotho'
          ? 'Palo ea AGYWs:'
          : '# of AGYWs:');
    } else if (interventionId == 'education') {
      beneficiaryCardLabel = isSubtitle
          ? (currentLanguage == 'lesotho'
          ? 'Palo ea Bursary:'
          : '# of BURSARY:')
          : (currentLanguage == 'lesotho' ? 'Palo ea LBSE:' : '# of LBSE:');
    }

    return beneficiaryCardLabel;
  }

  @override
  Widget build(BuildContext context) {
    final current = interventionProgram;
    if (current == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 22.0),
                  decoration: BoxDecoration(
                    color: current.svgBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  width: 65.0,
                  height: 65.0,
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      current.svgIcon ?? '',
                      colorFilter: ColorFilter.mode(
                        current.primaryColor ?? Colors.blueGrey,
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
                      current.name ?? '',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: current.nameColor,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getCardBeneficiaryLabelAndCount(
                          label: getBeneficiaryCardLabel(
                            interventionId: current.id ?? '',
                            isSubtitle: false,
                            context: context,
                          ),
                          count: getBeneficiaryCardCount(
                            interventionId: current.id ?? '',
                            isSubtitle: false,
                          ),
                        ),
                        getCardBeneficiaryLabelAndCount(
                          label: getBeneficiaryCardLabel(
                            interventionId: current.id ?? '',
                            isSubtitle: true,
                            context: context,
                          ),
                          count: getBeneficiaryCardCount(
                            interventionId: current.id ?? '',
                            isSubtitle: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 35.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: interventionProgramId == current.id
                  ? current.secondaryColor
                  : const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32.0),
                bottomRight: Radius.circular(32.0),
              ),
            ),
            child: Visibility(
              visible: interventionProgramId == current.id,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SvgPicture.asset(
                  'assets/icons/tick-icon.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

