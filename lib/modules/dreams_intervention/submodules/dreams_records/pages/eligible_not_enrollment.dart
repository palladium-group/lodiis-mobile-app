import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/none_participation_beneficiary_card.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/none_participation_beneficiary.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/pages/agyw_dreams_elligible_not_enrollment.dart';
import 'package:provider/provider.dart';

class DreamsEligibleNotEnrollment extends StatefulWidget {
  const DreamsEligibleNotEnrollment({Key? key}) : super(key: key);

  @override
  State<DreamsEligibleNotEnrollment> createState() =>
      _DreamsEnrollmentNotEligibleState();
}

class _DreamsEnrollmentNotEligibleState
    extends State<DreamsEligibleNotEnrollment> {
  void updateFormState(
    BuildContext context,
    bool isEditableMode,
    Events? eventData,
  ) {
    Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
    Provider.of<EnrollmentFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    if (eventData != null) {
      Provider.of<EnrollmentFormState>(context, listen: false)
          .setFormFieldState('eventDate', eventData.eventDate);
      Provider.of<EnrollmentFormState>(context, listen: false)
          .setFormFieldState('eventId', eventData.event);
      for (Map dataValue in eventData.dataValues) {
        if (dataValue['value'] != '') {
          Provider.of<EnrollmentFormState>(context, listen: false)
              .setFormFieldState(dataValue['dataElement'], dataValue['value']);
        }
      }
    }
  }

  void onEditBeneficiary(
    BuildContext context,
    NoneParticipationBeneficiary beneficiary,
  ) {
    updateFormState(context, true, beneficiary.eventData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywEligibleNotEnrollmentForm(),
      ),
    );
  }

  void onViewBeneficiary(
    BuildContext context,
    NoneParticipationBeneficiary beneficiary,
  ) {
    updateFormState(context, false, beneficiary.eventData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywEligibleNotEnrollmentForm(),
      ),
    );
  }

  void refreshBeneficiaryList(
      DreamsInterventionListState dreamInterventionListState) {
    dreamInterventionListState.refreshBeneficiariesNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String? currentLanguage = languageTranslationState.currentLanguage;
        return Consumer<DreamsInterventionListState>(
          builder: (context, ovcInterventionListState, child) {
            String header = currentLanguage == 'lesotho'
                ? '${'Bana ba AGYW/DREAMS ba nang le monyetla empa basa ngolisoa'.toUpperCase()}: ${ovcInterventionListState.numberOfEnrolledNotEligibleParticipant}'
                : '${'AGYW/DREAMS Eligible but not Enrolled '.toUpperCase()}: ${ovcInterventionListState.numberOfEnrolledNotEligibleParticipant}';
            return SubModuleHomeContainer(
              header: header,
              bodyContents: _buildBody(currentLanguage),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(String? currentLanguage) {
    return Consumer<DreamsInterventionListState>(
      builder: (context, dreamInterventionListState, child) => RefreshIndicator(
        onRefresh: () async {
          refreshBeneficiaryList(dreamInterventionListState);
        },
        child: CustomPaginatedListView(
          errorWidget: Container(
            margin: const EdgeInsets.only(
              bottom: 16.0,
              right: 13.0,
              left: 13.0,
            ),
            child: Center(
              child: Text(
                currentLanguage == 'lesotho'
                    ? 'Ha hona bana ba AGYW/DREAMS ba nang le monyetla empa basa ngolisoa hajoale'
                    : 'There is no AGYW/DREAMS Eligible but not Enroll participants at moment',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          pagingController: dreamInterventionListState
              .enrolledNotEligibleParticipantPagingController,
          childBuilder:
              (context, dreamsEnrolledNotEligibleParticipant, index) =>
                  NoneParticipantBeneficiaryCard(
            beneficiary: dreamsEnrolledNotEligibleParticipant,
            canEdit: true,
            onViewBeneficiary: () => onViewBeneficiary(
                context, dreamsEnrolledNotEligibleParticipant),
            onEditBeneficiary: () => onEditBeneficiary(
                context, dreamsEnrolledNotEligibleParticipant),
          ),
          emptyListWidget: Center(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 16.0,
                right: 13.0,
                left: 13.0,
              ),
              child: Column(
                children: [
                  Text(
                    currentLanguage == 'lesotho'
                        ? 'Ha hona bana ba AGYW/DREAMS ba nang le monyetla empa basa ngolisoa hajoale'
                        : 'There is no AGYW/DREAMS Eligible but not Enroll participants at moment',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
