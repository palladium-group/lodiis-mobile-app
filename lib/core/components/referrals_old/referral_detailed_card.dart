import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/implementing_partner_referral_service_state/implementing_partner_referral_service_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/referrals_old/referral_card_data.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/referral_event.dart';
import 'package:kb_mobile_app/models/referral_outcome_event.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/constants/dreams_routes_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_referral/pages/dream_agyw_referral_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_child_referral_pages/pages/ovc_child_referral_add_form.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_referral/ovc_referral_pages/ovc_house_referral_pages/pages/ovc_household_add_referral_form.dart';
import 'package:provider/provider.dart';

class ReferralDetailedCard extends StatefulWidget {
  const ReferralDetailedCard({
    Key? key,
    required this.eventData,
    required this.referralIndex,
    required this.borderColor,
    required this.titleColor,
    required this.labelColor,
    required this.valueColor,
    required this.isIncomingReferral,
    this.isOvcIntervention = true,
    this.isHouseholdReferral = false,
    this.isEditable = false,
  }) : super(key: key);

  final Events eventData;
  final int referralIndex;
  final Color borderColor;
  final Color titleColor;
  final Color valueColor;
  final Color labelColor;
  final bool isOvcIntervention;
  final bool isHouseholdReferral;
  final bool isEditable;
  final bool isIncomingReferral;

  @override
  State<ReferralDetailedCard> createState() => _ReferralDetailedCardState();
}

class _ReferralDetailedCardState extends State<ReferralDetailedCard> {
  ReferralEvent? referralDataCard;
  bool isLoading = true;
  double editIconHeight = 20;
  ReferralOutcomeEvent? referralOutComeEvent;
  Color? buttonLabelColor;

  @override
  void initState() {
    super.initState();
    buttonLabelColor = widget.isOvcIntervention
        ? const Color(0xFF4B9F46)
        : const Color(0xFF1F8ECE);
    setState(() {});
  }

  void onUpdateEventData(Events eventData) async {
    if (isLoading) {
      referralDataCard = await ReferralEvent().fromTeiModel(eventData);
      referralOutComeEvent = ReferralOutcomeEvent().fromTeiModel(
        eventData: eventData,
        referralToComeReference: "",
        referralToFollowUpLinkage: "",
      );
      isLoading = false;
      setState(() {});
    }
  }

  onEditReferral(BuildContext context) async {
    CurrentUser? user = await UserService().getCurrentUser();
    await Provider.of<ImplementingPartnerReferralServiceState>(context,
            listen: false)
        .setImplementingPartnerServices();
    FormUtil.updateServiceFormState(context, true, widget.eventData);
    dynamic beneficiary = widget.isOvcIntervention
        ? widget.isHouseholdReferral
            ? Provider.of<OvcHouseholdCurrentSelectionState>(context,
                    listen: false)
                .currentOvcHousehold
            : Provider.of<OvcHouseholdCurrentSelectionState>(context,
                    listen: false)
                .currentOvcHouseholdChild
        : Provider.of<DreamsBeneficiarySelectionState>(context, listen: false)
            .currentAgywDream;

    String beneficiaryId = beneficiary!.id;
    String eventId = widget.eventData.event!;
    String formAutoSaveId =
        "${widget.isOvcIntervention ? widget.isHouseholdReferral ? OvcRoutesConstant.houseHoldReferralFormPage : OvcRoutesConstant.ovcReferralFormPage : DreamsRoutesConstant.agywDreamsReferralPage}_${beneficiaryId}_$eventId";

    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave);

    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget.isOvcIntervention
              ? widget.isHouseholdReferral
                  ? const OvcHouseholdAddReferralForm()
                  : const OvcChildReferralAddForm()
              : DreamsAgywAddReferralForm(
                  currentUser: user,
                ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String? currentLanguage = languageTranslationState.currentLanguage;
        return Consumer<ServiceEventDataState>(
          builder: (context, serviceEventDataState, child) {
            Map<String?, List<Events>> eventListByProgramStage =
                serviceEventDataState.eventListByProgramStage;
            List<Events> eventList =
                TrackedEntityInstanceUtil.getAllEventListFromServiceDataState(
                    eventListByProgramStage);
            if (eventList.isNotEmpty) {
              Events currentReferralEvent = eventList.firstWhere(
                  (Events eventData) =>
                      eventData.event == widget.eventData.event);
              onUpdateEventData(currentReferralEvent);
            }
            return isLoading || referralDataCard == null
                ? const CircularProcessLoader(
                    color: Colors.grey,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 15.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                              languageTranslationState.currentLanguage == 'lesotho'
                                          ?'Phetisetso ${widget.referralIndex.toString()}'
                                          :'Referral ${widget.referralIndex.toString()}',
                                
                                style: const TextStyle().copyWith(
                                  color: widget.titleColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  widget.eventData.enrollmentOuAccessible! &&
                                      widget.isEditable &&
                                      referralOutComeEvent != null &&
                                      referralOutComeEvent!
                                              .dateClientReachStation ==
                                          '',
                              child: InkWell(
                                onTap: () => onEditReferral(context),
                                child: Container(
                                  height: editIconHeight,
                                  width: editIconHeight,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 5.0,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/edit-icon.svg',
                                    colorFilter: ColorFilter.mode(
                                      buttonLabelColor!,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      LineSeparator(
                        color: widget.borderColor,
                        height: 2,
                      ),
                      Visibility(
                        visible: referralDataCard != null,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 13.0,
                            vertical: 10.0,
                          ),
                          child: ReferralCardData(
                            currentLanguage: currentLanguage,
                            labelColor: widget.labelColor,
                            valueColor: widget.valueColor,
                            referralDataCard: referralDataCard!,
                            isIncomingReferral: widget.isIncomingReferral,
                          ),
                        ),
                      )
                    ],
                  );
          },
        );
      },
    );
  }
}
