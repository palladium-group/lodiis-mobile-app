import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/referrals_old/referral_outcome_view.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/referral_outcome_event.dart';
import 'package:kb_mobile_app/models/referral_outcome_follow_up_event.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:provider/provider.dart';

class ReferralOutComeViewContainer extends StatefulWidget {
  const ReferralOutComeViewContainer({
    Key? key,
    required this.themeColor,
    required this.eventData,
    required this.beneficiary,
    required this.referralFollowUpStage,
    required this.referralToFollowUpLinkage,
    required this.referralProgram,
    required this.isEditableMode,
    required this.enrollmentOuAccessible,
    required this.referralOutcomeFollowUpFormSections,
    required this.onEditReferralOutCome,
  }) : super(key: key);

  final Color? themeColor;
  final Events eventData;
  final TrackedEntityInstance? beneficiary;
  final String referralFollowUpStage;
  final String referralToFollowUpLinkage;
  final String referralProgram;
  final bool isEditableMode;
  final bool enrollmentOuAccessible;
  final List<FormSection>? referralOutcomeFollowUpFormSections;
  final Function onEditReferralOutCome;

  @override
  State<ReferralOutComeViewContainer> createState() =>
      _ReferralOutComeViewContainerState();
}

class _ReferralOutComeViewContainerState
    extends State<ReferralOutComeViewContainer> {
  ReferralOutcomeEvent? referralOutComeEvent;
  bool isViewReady = false;
  double editIconHeight = 20;

  @override
  void initState() {
    super.initState();
    setReferralOutComeView();
  }

  void setReferralOutComeView() {
    Timer(
      const Duration(
        milliseconds: 400,
      ),
      () {
        setState(
          () {
            isViewReady = true;
            referralOutComeEvent = ReferralOutcomeEvent().fromTeiModel(
              eventData: widget.eventData,
              referralToComeReference: "",
              referralToFollowUpLinkage: widget.referralToFollowUpLinkage,
            );
          },
        );
      },
    );
  }

  List<ReferralOutcomeFollowUpEvent> getReferralOutComeFollowUps(
    Map<String?, List<Events>> eventListByProgramStage,
  ) {
    TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(
      eventListByProgramStage,
      [widget.referralFollowUpStage],
    );
    List<Events> events = TrackedEntityInstanceUtil
        .getAllEventListFromServiceDataStateByProgramStages(
      eventListByProgramStage,
      [widget.referralFollowUpStage],
    );
    List<ReferralOutcomeFollowUpEvent> referralOutComeFollowUps = events
        .map((Events event) => ReferralOutcomeFollowUpEvent().fromTeiModel(
            eventData: event,
            referralToFollowUpLinkage: widget.referralToFollowUpLinkage))
        .toList();
    return referralOutComeFollowUps
        .where((referralOutComeFollowUp) =>
            referralOutComeFollowUp.referralReference ==
            referralOutComeEvent!.referralReference)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;

        return !isViewReady
            ? const CircularProcessLoader(
                color: Colors.blueGrey,
              )
            : Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFB2B7B9),
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0,
                            ),
                            child: Text(
                              currentLanguage == 'lesotho'
                                  ? 'SEPHETHO'
                                  : 'OUTCOME',
                              style: const TextStyle().copyWith(
                                color: const Color(0xFF1A3518),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Consumer<ServiceEventDataState>(
                            builder: (context, serviceEventDataState, child) {
                          Map<String?, List<Events>> eventListByProgramStage =
                              serviceEventDataState.eventListByProgramStage;
                          List<ReferralOutcomeFollowUpEvent>
                              referralOutComeFollowUpEvents =
                              getReferralOutComeFollowUps(
                                  eventListByProgramStage);
                          return Visibility(
                            visible: widget.isEditableMode &&
                                referralOutComeEvent != null &&
                                referralOutComeFollowUpEvents.isEmpty &&
                                widget.eventData.enrollmentOuAccessible!,
                            child: InkWell(
                              onTap: widget.onEditReferralOutCome as void
                                  Function()?,
                              child: Container(
                                height: editIconHeight,
                                width: editIconHeight,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 20.0,
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/edit-icon.svg',
                                  colorFilter: ColorFilter.mode(
                                    widget.themeColor!,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                    const LineSeparator(
                      color: Color(0xFFB2B7B9),
                      height: 1.0,
                    ),
                    ReferralOutComeView(
                      enrollmentOuAccessible: widget.enrollmentOuAccessible,
                      isEditableMode: widget.isEditableMode,
                      referralOutComeEvent: referralOutComeEvent,
                      beneficiary: widget.beneficiary,
                      referralOutcomeFollowUpFormSections:
                          widget.referralOutcomeFollowUpFormSections,
                      themeColor: widget.themeColor,
                      referralFollowUpStage: widget.referralFollowUpStage,
                      referralProgram: widget.referralProgram,
                      referralToFollowUpLinkage:
                          widget.referralToFollowUpLinkage,
                    ),
                  ],
                ),
              );
      },
    );
  }
}
