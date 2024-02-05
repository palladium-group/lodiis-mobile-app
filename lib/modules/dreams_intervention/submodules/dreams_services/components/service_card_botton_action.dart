import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:provider/provider.dart';

class ServiceCardButtonAction extends StatelessWidget {
  const ServiceCardButtonAction({
    Key? key,
    this.agywBeneficiary,
    this.onOpenPrepLongForm,
    this.onOpenPrepShortForm,
    this.onOpenHTSShortForm,
    this.onOpenCondomForm,
    this.onOpenContraceptivesForm,
    this.onOpenMSGHIVForm,
    this.onOpenANCForm,
    this.onOpenArtRefillForm,
    this.onOpenPEPForm,
    this.onOpenPostGBVForm,
    this.onOpenServiceForm,
    this.onOpenPostGBVLegalForm,
    this.onOpenParentingForm,
    this.onOpenHIVPreventionEducationForm,
    this.onOpenViolencePreventionEducationForm,
  }) : super(key: key);

  final AgywDream? agywBeneficiary;
  final VoidCallback? onOpenPrepLongForm;
  final VoidCallback? onOpenPrepShortForm;
  final VoidCallback? onOpenHTSShortForm;
  final VoidCallback? onOpenMSGHIVForm;
  final VoidCallback? onOpenCondomForm;
  final VoidCallback? onOpenContraceptivesForm;
  final VoidCallback? onOpenPostGBVForm;
  final VoidCallback? onOpenPEPForm;
  final VoidCallback? onOpenANCForm;
  final VoidCallback? onOpenArtRefillForm;
  final VoidCallback? onOpenServiceForm;
  final VoidCallback? onOpenPostGBVLegalForm;
  final VoidCallback? onOpenParentingForm;
  final VoidCallback? onOpenHIVPreventionEducationForm;
  final VoidCallback? onOpenViolencePreventionEducationForm;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) =>
          Consumer<CurrentUserState>(
        builder: (context, currentUserState, child) {
          return Column(
            children: [
              const LineSeparator(
                color: Color(0xFFE9F4FA),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
                child: SizedBox(
                  height: 50.0,
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Visibility(
                          visible: currentUserState.canManageHtsShortForm,
                          child: InkWell(
                            onTap: onOpenHTSShortForm,
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
                                    'HTS',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (currentUserState.canManagePrepLongForm ||
                                  currentUserState.canManagePrepShortForm) &&
                              int.parse(agywBeneficiary!.age ?? '0') >= 15,
                          child: InkWell(
                            onTap: currentUserState.canManagePrepShortForm
                                ? onOpenPrepShortForm
                                : onOpenPrepLongForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'PrEP',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState.canManageMSGHIV,
                          child: InkWell(
                            onTap: onOpenMSGHIVForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    languageTranslationState.currentLanguage ==
                                            'lesotho'
                                        ? 'Hlahlobo ea hoba tlokotsing ea HIV'
                                        : 'HIV Risk Assessment',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState.canManageCondom,
                          child: InkWell(
                            onTap: onOpenCondomForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    languageTranslationState.currentLanguage ==
                                            'lesotho'
                                        ? 'Thuto/Phano ka Likhohlopo'
                                        : 'Condom Education/Provision',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState.canManageContraceptives,
                          child: InkWell(
                            onTap: onOpenContraceptivesForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    languageTranslationState.currentLanguage ==
                                            'lesotho'
                                        ? 'Foromo ea Thero ea Lelapa/SRH'
                                        : 'Family planning/SRH',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState.canManageArtRefill,
                          child: InkWell(
                            onTap: onOpenArtRefillForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'ART RE-FILL',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState.canManageAnc,
                          child: InkWell(
                            onTap: onOpenANCForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'ANC',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState.canManagePOSTGBV,
                          child: InkWell(
                            onTap: onOpenPostGBVForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'POST GBV',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState.canManagePEP,
                          child: InkWell(
                            onTap: onOpenPEPForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'PEP',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState.canManageServiceForm,
                          child: InkWell(
                            onTap: onOpenServiceForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    languageTranslationState.currentLanguage ==
                                            'lesotho'
                                        ? 'FOROMO EA TŠEBELETSO'
                                        : 'SERVICE FORM',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState.canManagePOSTGBVLegal,
                          child: InkWell(
                            onTap: onOpenPostGBVLegalForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'POST GBV (Legal)',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState.canManageManageParenting,
                          child: InkWell(
                            onTap: onOpenParentingForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'PARENTING',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState
                                  .canManageHIVPreventionEducation &&
                              (int.parse(agywBeneficiary!.age ?? '0') >= 10 &&
                                  int.parse(agywBeneficiary!.age ?? '0') <= 24),
                          child: InkWell(
                            onTap: onOpenHIVPreventionEducationForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    languageTranslationState.currentLanguage ==
                                            'lesotho'
                                        ? 'Thuto ea Thibelo ea HIV'
                                        : "HIV Prevention Education",
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentUserState
                                  .canManageViolencePreventionEducation &&
                              (int.parse(agywBeneficiary!.age ?? '0') >= 10 &&
                                  int.parse(agywBeneficiary!.age ?? '0') <= 24),
                          child: InkWell(
                            onTap: onOpenViolencePreventionEducationForm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1,
                                    color: Color(0xFF8EBAD3),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    languageTranslationState.currentLanguage ==
                                            'lesotho'
                                        ? 'Thuto ea Thibelo ea tlhekefetso'
                                        : 'Violence Prevention Education',
                                    style: const TextStyle().copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFF1F8ECE),
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
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
