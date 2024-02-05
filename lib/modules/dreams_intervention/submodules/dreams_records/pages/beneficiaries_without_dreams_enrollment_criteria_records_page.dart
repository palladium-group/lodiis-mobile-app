import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/dreams_intervention_list_state/dreams_intervention_list_state.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/none_participation_beneficiary_card.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/models/events.dart';
import 'package:kb_mobile_app/models/none_participation_beneficiary.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/pages/agyw_dreams_without_enrollment_criteria_form.dart';
import 'package:provider/provider.dart';

class BeneficiariesWithoutDreamsEnrollmentCriteriaRecordsPage
    extends StatefulWidget {
  const BeneficiariesWithoutDreamsEnrollmentCriteriaRecordsPage({Key? key})
      : super(key: key);

  @override
  State<BeneficiariesWithoutDreamsEnrollmentCriteriaRecordsPage>
      createState() =>
          _BeneficiariesWithoutDreamsEnrollmentCriteriaRecordsPageState();
}

class _BeneficiariesWithoutDreamsEnrollmentCriteriaRecordsPageState
    extends State<BeneficiariesWithoutDreamsEnrollmentCriteriaRecordsPage> {
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

  void onViewBeneficiary(
      BuildContext context, NoneParticipationBeneficiary beneficiary) {
    updateFormState(context, false, beneficiary.eventData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsWithoutEnrollmentCriteriaForm(),
      ),
    );
  }

  void onEditBeneficiary(
      BuildContext context, NoneParticipationBeneficiary beneficiary) {
    updateFormState(context, true, beneficiary.eventData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgywDreamsWithoutEnrollmentCriteriaForm(),
      ),
    );
  }

  void refreshBeneficiaryList(
      DreamsInterventionListState dreamsInterventionListState) {
    dreamsInterventionListState.refreshBeneficiariesNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String? currentLanguage = languageTranslationState.currentLanguage;
        return Consumer<DreamsInterventionListState>(
          builder: (context, dreamsInterventionListState, child) {
            String header = currentLanguage == 'lesotho'
                ? '${'Bana ba senang mekhoa ea ho ngolisa'.toUpperCase()}: ${dreamsInterventionListState.numberOfBeneficiariesWithoutAgywDreamsCriteria}'
                : '${'Beneficiaries without Enrollment criteria'.toUpperCase()}: ${dreamsInterventionListState.numberOfBeneficiariesWithoutAgywDreamsCriteria}';
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
      builder: (context, dreamsInterventionListState, child) =>
          RefreshIndicator(
        onRefresh: () async {
          refreshBeneficiaryList(dreamsInterventionListState);
        },
        child: CustomPaginatedListView(
          errorWidget: Container(
            margin: const EdgeInsets.only(
              bottom: 16.0,
              right: 13.0,
              left: 13.0,
            ),
            child: Text(
              currentLanguage == 'lesotho'
                  ? 'Ha hona bana ba senang mekhoa ea ho ngolisa hajoale'
                  : 'There is no beneficiaries without AGYW/DREAMS enrollment criteria at moment',
              textAlign: TextAlign.center,
            ),
          ),
          pagingController: dreamsInterventionListState
              .beneficiariesWithoutAgywDreamsCriteriaPagingController,
          childBuilder: (context, dreamsNoneParticipant, index) =>
              NoneParticipantBeneficiaryCard(
            beneficiary: dreamsNoneParticipant,
            canEdit: true,
            onViewBeneficiary: () =>
                onViewBeneficiary(context, dreamsNoneParticipant),
            onEditBeneficiary: () =>
                onEditBeneficiary(context, dreamsNoneParticipant),
          ),
          emptyListWidget: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 16.0,
                    right: 13.0,
                    left: 13.0,
                  ),
                  child: Text(
                    currentLanguage == 'lesotho'
                        ? 'Ha hona bana ba senang mekhoa ea ho ngolisa hajoale'
                        : 'There is no beneficiaries without AGYW/DREAMS enrollment criteria at moment',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
