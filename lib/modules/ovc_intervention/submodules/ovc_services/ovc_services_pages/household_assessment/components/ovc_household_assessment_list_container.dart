import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_event_data_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/core/utils/tracked_entity_instance_util.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:provider/provider.dart';

class OvcHouseholdAssessmentListContainer extends StatelessWidget {
  const OvcHouseholdAssessmentListContainer({
    Key? key,
    required this.programStageIds,
    this.onViewHouseholdAssessment,
    this.onEditHouseholdAssessment,
  }) : super(key: key);

  final List<String> programStageIds;
  final Function? onViewHouseholdAssessment;
  final Function? onEditHouseholdAssessment;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String currentLanguage = languageTranslationState.currentLanguage;
        double iconHeight = 20;
        return Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5.0,
          ),
          child: Consumer<ServiceEventDataState>(
            builder: (context, serviceEventDataState, child) {
              Map<String?, List<Events>> eventListByProgramStage =
                  serviceEventDataState.eventListByProgramStage;
              List<Events> eventList = TrackedEntityInstanceUtil
                  .getAllEventListFromServiceDataStateByProgramStages(
                      eventListByProgramStage, programStageIds);
              int assessmentIndex = eventList.length;
              return assessmentIndex == 0
                  ? Center(
                      child: Text(currentLanguage == 'lesotho'
                          ? 'Ha hona hlahlobo hajoale'
                          : 'There is no Assessment at moment'),
                    )
                  : Column(
                      children: eventList.map((Events assessment) {
                        assessmentIndex--;
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 7.0,
                          ),
                          child: MaterialCard(
                            body: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                bottomLeft: Radius.circular(12.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 20.0,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              text:
                                                  '${assessment.eventDate}   ',
                                              style: const TextStyle().copyWith(
                                                color: const Color(0xFF92A791),
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: currentLanguage ==
                                                          'lesotho'
                                                      ? 'Hlahlobo ${assessmentIndex + 1}'
                                                      : 'Assessment ${assessmentIndex + 1}',
                                                  style: const TextStyle()
                                                      .copyWith(
                                                    color:
                                                        const Color(0xFF1A3518),
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
                                            onTap: () =>
                                                onViewHouseholdAssessment!(
                                                    assessment),
                                            child: Container(
                                              height: iconHeight,
                                              width: iconHeight,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 5.0,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/icons/expand_icon.svg',
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Color(0xFF4B9F46),
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Consumer<CurrentUserState>(
                                          builder: (context, currentUserState,
                                              child) {
                                            bool isKbFacilitySocialWorker =
                                                currentUserState
                                                    .isKbFacilitySocialWorker;
                                            return Visibility(
                                              visible: !isKbFacilitySocialWorker &&
                                                  assessment
                                                      .enrollmentOuAccessible!,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 5.0,
                                                ),
                                                child: InkWell(
                                                  onTap: () =>
                                                      onEditHouseholdAssessment!(
                                                          assessment),
                                                  child: Container(
                                                    height: iconHeight,
                                                    width: iconHeight,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 5.0,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'assets/icons/edit-icon.svg',
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        Color(0xFF4B9F46),
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
            },
          ),
        );
      },
    );
  }
}
