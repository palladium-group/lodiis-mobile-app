import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/pp_prev_beneficiary.dart';

class PpPrevBeneficiaryCardActionButtons extends StatelessWidget {
  const PpPrevBeneficiaryCardActionButtons({
    Key? key,
    required this.ppPrevBeneficiary,
    this.onOpenGenderNormsForm,
    this.onOpenReferralForm,
    this.onOpenServiceForm,
  }) : super(key: key);

  final PpPrevBeneficiary ppPrevBeneficiary;
  final VoidCallback? onOpenServiceForm;
  final VoidCallback? onOpenGenderNormsForm;
  final VoidCallback? onOpenReferralForm;

  @override
  Widget build(BuildContext context) {
    var beneficiaryAge = int.parse(ppPrevBeneficiary.age ?? '');
    var beneficiarySex = ppPrevBeneficiary.sex;
    return SizedBox(
      height: 50.0,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            InkWell(
              onTap: () {
                onOpenServiceForm!();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Service',
                      style: const TextStyle().copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF9B2BAE),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                onOpenReferralForm!();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1,
                      color: const Color(0xFF9B2BAE).withOpacity(0.4),
                    ),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Referrals',
                      style: const TextStyle().copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF9B2BAE),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: beneficiarySex == 'Male' &&
                  beneficiaryAge >= 20 &&
                  beneficiaryAge <= 49,
              child: InkWell(
                onTap: () {
                  onOpenGenderNormsForm!();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 1,
                        color: const Color(0xFF9B2BAE).withOpacity(0.4),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Gender Norms',
                        style: const TextStyle().copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF9B2BAE),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
