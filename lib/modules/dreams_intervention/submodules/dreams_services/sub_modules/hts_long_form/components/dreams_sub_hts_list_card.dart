import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/hts_tb_home_page.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/index/hts_index_home_page.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/models/dreams_hts_event.dart';
import 'package:provider/provider.dart';

class DreamsSubHTSListCard extends StatefulWidget {
  const DreamsSubHTSListCard(
      {Key? key,
      required this.eventData,
      this.canAccessIndexContact,
      this.hivResultStatus,
      this.onViewConsent,
      this.onViewIntake,
      this.onViewStatus,
      this.onEditConsent,
      this.onEditIntake,
      this.onEditStatus,
      this.onViewRegister,
      this.onEditRegister})
      : super(key: key);

  final bool? canAccessIndexContact;
  final String? hivResultStatus;
  final Function? onViewConsent;
  final Function? onEditConsent;
  final Function? onViewIntake;
  final Function? onEditIntake;
  final Function? onViewStatus;
  final Function? onEditStatus;
  final Function? onViewRegister;
  final Function? onEditRegister;
  final DreamsHTSEvent eventData;

  @override
  State<DreamsSubHTSListCard> createState() => _DreamsSubHTSListCardState();
}

class _DreamsSubHTSListCardState extends State<DreamsSubHTSListCard> {
  DreamsHTSEvent? dreamsHTSEventCard;

  @override
  Widget build(BuildContext context) {
    double iconHeight = 20;
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 17.0,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15.0),
              child: MaterialCard(
                body: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '${widget.eventData.date}   ',
                            style: const TextStyle().copyWith(
                              color: const Color(0xFF82898D),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                text: languageState.currentLanguage == 'lesotho'
                                    ? 'Tumellano'
                                    : 'Consent',
                                style: const TextStyle().copyWith(
                                  color: const Color(0xFF05131B),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: InkWell(
                            onTap: widget.onViewConsent as void Function()?,
                            child: Container(
                              height: iconHeight,
                              width: iconHeight,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: SvgPicture.asset(
                                'assets/icons/expand_icon.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1F8ECE),
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: InkWell(
                            onTap: widget.onEditConsent as void Function()?,
                            child: Container(
                              height: iconHeight,
                              width: iconHeight,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: SvgPicture.asset(
                                'assets/icons/edit-icon.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1F8ECE),
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15.0),
              child: MaterialCard(
                body: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '${widget.eventData.date}   ',
                            style: const TextStyle().copyWith(
                              color: const Color(0xFF82898D),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                text: "Client Intake",
                                style: const TextStyle().copyWith(
                                  color: const Color(0xFF05131B),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: InkWell(
                            onTap: widget.onViewIntake as void Function()?,
                            child: Container(
                              height: iconHeight,
                              width: iconHeight,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: SvgPicture.asset(
                                'assets/icons/expand_icon.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1F8ECE),
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: InkWell(
                            onTap: widget.onEditIntake as void Function()?,
                            child: Container(
                              height: iconHeight,
                              width: iconHeight,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: SvgPicture.asset(
                                'assets/icons/edit-icon.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1F8ECE),
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15.0),
              child: MaterialCard(
                body: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '${widget.eventData.date}   ',
                            style: const TextStyle().copyWith(
                              color: const Color(0xFF82898D),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                text: "HTS Register",
                                style: const TextStyle().copyWith(
                                  color: const Color(0xFF05131B),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: InkWell(
                            onTap: widget.onViewRegister as void Function()?,
                            child: Container(
                              height: iconHeight,
                              width: iconHeight,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: SvgPicture.asset(
                                'assets/icons/expand_icon.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1F8ECE),
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: InkWell(
                            onTap: widget.onEditRegister as void Function()?,
                            child: Container(
                              height: iconHeight,
                              width: iconHeight,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: SvgPicture.asset(
                                'assets/icons/edit-icon.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1F8ECE),
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15.0),
              child: MaterialCard(
                body: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '${widget.eventData.date}   ',
                            style: const TextStyle().copyWith(
                              color: const Color(0xFF82898D),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                text: "Status Consent",
                                style: const TextStyle().copyWith(
                                  color: const Color(0xFF05131B),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: InkWell(
                            onTap: widget.onViewStatus as void Function()?,
                            child: Container(
                              height: iconHeight,
                              width: iconHeight,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: SvgPicture.asset(
                                'assets/icons/expand_icon.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1F8ECE),
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: InkWell(
                            onTap: widget.onEditStatus as void Function()?,
                            child: Container(
                              height: iconHeight,
                              width: iconHeight,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: SvgPicture.asset(
                                'assets/icons/edit-icon.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1F8ECE),
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
                visible: widget.canAccessIndexContact!,
                child: HTSTBHomePage(
                    htsToTBLinkageValue: widget.eventData.htsTBLinkage,
                    hivResultStatus: widget.hivResultStatus)),
            Visibility(
                visible: widget.canAccessIndexContact!,
                child: HTSIndexHomePage(
                    htsIndexLinkage: widget.eventData.htsIndexLinkage))
          ],
        ),
      ),
    );
  }
}
