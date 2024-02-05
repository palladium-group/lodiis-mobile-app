import 'package:flutter/material.dart';
import 'package:kb_mobile_app/modules/education_intervention/components/education_beneficiary_button.dart';

class EducationBeneficiaryBottonAction extends StatelessWidget {
  const EducationBeneficiaryBottonAction({
    Key? key,
    required this.isLbseLearningOutcomeVisible,
    required this.isBursarySchoolVisible,
    required this.isBursaryClubVisible,
    required this.isBursaryClubReferralVisible,
    this.onOpenLbseLearningOutcome,
    this.onOpenBursarySchool,
    this.onOpenBursaryClub,
    this.onOpenBursaryClubReferral,
  }) : super(key: key);

  final double height = 50.0;

  final bool isLbseLearningOutcomeVisible;
  final bool isBursarySchoolVisible;
  final bool isBursaryClubVisible;
  final bool isBursaryClubReferralVisible;

  final VoidCallback? onOpenLbseLearningOutcome;
  final VoidCallback? onOpenBursarySchool;
  final VoidCallback? onOpenBursaryClub;
  final VoidCallback? onOpenBursaryClubReferral;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      ),
      child: Container(
        height: height,
        color: const Color(0xFF009688).withOpacity(0.08),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              EducationBeneficiaryButton(
                label: 'LEARNING OUTCOME',
                translatedLabel: 'SEPHETHO SA BOITHUTO',
                isVisible: isLbseLearningOutcomeVisible,
                hasSplitBorder: false,
                onTap: onOpenLbseLearningOutcome,
              ),
              EducationBeneficiaryButton(
                label: 'SCHOOL',
                translatedLabel: 'SEKOLO',
                isVisible: isBursarySchoolVisible,
                hasSplitBorder: isBursaryClubVisible,
                onTap: onOpenBursarySchool,
              ),
              EducationBeneficiaryButton(
                label: 'CLUB',
                translatedLabel: "SEHLOTS'OANA",
                isVisible: isBursaryClubVisible,
                hasSplitBorder: isBursaryClubReferralVisible,
                onTap: onOpenBursaryClub,
              ),
              EducationBeneficiaryButton(
                label: 'CLUB RERERRAL',
                isVisible: isBursaryClubReferralVisible,
                hasSplitBorder: false,
                onTap: onOpenBursaryClubReferral,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
