import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/agyw_dreams_index_info_event.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/constants/agyw_dreams_hts_index_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/constants/agyw_dreams_index_contact_constant.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/models/index_contact.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/pages/agyw_dreams_hts_index_contact_follow_up_list.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_services/sub_modules/hts_long_form/pages/agyw_dreams_index_contact.dart';
import 'package:provider/provider.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';

class DreamsHTSIndexCardButtonContent extends StatefulWidget {
  const DreamsHTSIndexCardButtonContent({
    Key? key,
    this.event,
  }) : super(key: key);

  final AgywDreamsIndexInfoEvent? event;

  @override
  State<DreamsHTSIndexCardButtonContent> createState() =>
      _DreamsHTSIndexCardButtonContentState();
}

class _DreamsHTSIndexCardButtonContentState
    extends State<DreamsHTSIndexCardButtonContent> {
  @override
  void initState() {
    super.initState();
  }

  void updateFormState(
    BuildContext context,
    bool isEditableMode,
    IndexContact? eventData,
  ) {
    Provider.of<ServiceFormState>(context, listen: false).resetFormState();
    Provider.of<ServiceFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    if (eventData != null) {
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventDate', eventData.date);
      Provider.of<ServiceFormState>(context, listen: false)
          .setFormFieldState('eventId', eventData.id);
      for (Map dataValue in eventData.dataValues) {
        if (dataValue['value'] != '') {
          Provider.of<ServiceFormState>(context, listen: false)
              .setFormFieldState(dataValue['dataElement'], dataValue['value']);
        }
      }
    }
  }

  void onEditIndexContact(BuildContext context, IndexContact eventData) {
    updateFormState(context, true, eventData);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AgywDreamsIndexContact(),
        ));
  }

  void onViewIndexContact(BuildContext context, IndexContact eventData) {
    updateFormState(context, false, eventData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsIndexContact(),
      ),
    );
  }

  void onFollowUpIndexContact(
    BuildContext context,
    IndexContact eventData,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgywDreamsHTSIndexFollowUpList(
          indexContactEvent: eventData,
          indexInfoEvent: widget.event,
        ),
      ),
    );
  }

  void onAddNewIndexContact(BuildContext context, AgywDream? agywDream) {
    updateFormState(context, true, null);
    Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
      AgywDreamsHTSIndexConstant.indexInfoToIndexContactLinkage,
      widget.event!.indexInfoToIndexContactLinkage,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsIndexContact(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AgywDream? agywDream;
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) => Column(
        children: [
          const LineSeparator(
            color: Color(0xFFECF5EC),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 13.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: SvgPicture.asset(
                      'assets/icons/children_ovc_icon.svg',
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF258DCC),
                        BlendMode.srcIn,
                      ),
                    )),
                Expanded(
                  child: Text('Index Contact List',
                      style: const TextStyle().copyWith(
                        fontSize: 14.0,
                        color: const Color(0xFF536852),
                        fontWeight: FontWeight.w700,
                      )),
                )
              ],
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
            child: Consumer<ServiceEventDataState>(
              builder: (context, serviceEventDataState, child) {
                bool isLoading = serviceEventDataState.isLoading;
                Map<String?, List<Events>> eventListByProgramStage =
                    serviceEventDataState.eventListByProgramStage;
                List<Events> events = TrackedEntityInstanceUtil
                    .getAllEventListFromServiceDataStateByProgramStages(
                        eventListByProgramStage,
                        [AgywDreamsIndexConstantConstant.programStage]);
                List<IndexContact> indexContactEvents = events
                    .map((Events eventData) =>
                        IndexContact().fromTeiModel(eventData))
                    .toList()
                    .where((element) =>
                        widget.event != null &&
                        element.indexInfoToIndexContactLinkage ==
                            widget.event!.indexInfoToIndexContactLinkage)
                    .toList();
                return isLoading
                    ? const CircularProcessLoader(color: Colors.blueGrey)
                    : Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 0.0),
                        child: Column(
                            children: indexContactEvents
                                .map((IndexContact eventData) {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  eventData.name.toString(),
                                  style: const TextStyle().copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0xFF536852),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                InkWell(
                                    onTap: () =>
                                        onViewIndexContact(context, eventData),
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        languageState.currentLanguage ==
                                                'lesotho'
                                            ? 'SHEBA'
                                            : 'VIEW',
                                        style: const TextStyle().copyWith(
                                          fontSize: 12.0,
                                          color: const Color(0xFF258DCC),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                                Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: InkWell(
                                        onTap: () => onEditIndexContact(
                                            context, eventData),
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            languageState.currentLanguage ==
                                                    'lesotho'
                                                ? 'FETOLA'
                                                : 'EDIT',
                                            style: const TextStyle().copyWith(
                                              fontSize: 12.0,
                                              color: const Color(0xFF258DCC),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ))),
                                Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: InkWell(
                                        onTap: () => onFollowUpIndexContact(
                                            context, eventData),
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'FOLLOWUP',
                                            style: const TextStyle().copyWith(
                                              fontSize: 12.0,
                                              color: const Color(0xFF258DCC),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )))
                              ])
                            ],
                          );
                        }).toList()));
              },
            ),
          ),
          const LineSeparator(
            color: Color(0xFFECF5EC),
          ),
          Visibility(
              visible: widget.event != null,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: InkWell(
                    onTap: () => onAddNewIndexContact(context, agywDream),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(
                        'ADD NEW INDEX CONTACT',
                        style: const TextStyle().copyWith(
                          fontSize: 12.0,
                          color: const Color(0xFF258DCC),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              )),
        ],
      ),
    );
  }
}
