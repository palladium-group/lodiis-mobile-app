import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/core/components/none_participation_beneficiary_card.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/none_participation_beneficiary.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/pages/ovc_enrollement_none_participation_form.dart';
import 'package:provider/provider.dart';

class OvcNoneParticipationRecords extends StatefulWidget {
  const OvcNoneParticipationRecords({Key? key}) : super(key: key);

  @override
  State<OvcNoneParticipationRecords> createState() =>
      _OvcNoneParticipationRecordsState();
}

class _OvcNoneParticipationRecordsState
    extends State<OvcNoneParticipationRecords> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageTranslationState, child) {
        String? currentLanguage = languageTranslationState.currentLanguage;
        return Consumer<OvcInterventionListState>(
          builder: (context, ovcInterventionListState, child) {
            String header = currentLanguage == 'lesotho'
                ? '${'Eo eseng karolo ea OVC'.toUpperCase()}: ${ovcInterventionListState.numberOfOvcNoneParticipants}'
                : '${'OVC none participants'.toUpperCase()}: ${ovcInterventionListState.numberOfOvcNoneParticipants}';
            return SubModuleHomeContainer(
              header: header,
              bodyContents: _buildBody(currentLanguage),
            );
          },
        );
      },
    );
  }

  void onViewBeneficiary(
    BuildContext context,
    NoneParticipationBeneficiary beneficiary,
  ) {
    FormUtil.updateServiceFormState(context, false, beneficiary.eventData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OvcEnrollmentNoneParticipationForm(),
      ),
    );
  }

  void onEditBeneficiary(
    BuildContext context,
    NoneParticipationBeneficiary beneficiary,
  ) {
    FormUtil.updateServiceFormState(context, true, beneficiary.eventData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OvcEnrollmentNoneParticipationForm(),
      ),
    );
  }

  void refreshBeneficiaryList(
      OvcInterventionListState ovcInterventionListState) {
    ovcInterventionListState.refreshOvcNumber();
  }

  Widget _buildBody(String? currentLanguage) {
    return Consumer<OvcInterventionListState>(
      builder: (context, ovcState, child) => RefreshIndicator(
        onRefresh: () async => refreshBeneficiaryList(ovcState),
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
                    ? 'Ha hona eo seng karalo ea OVC hajoale'
                    : 'There is no OVC none participants at moment',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          pagingController: ovcState.noneParticipationPagingController,
          childBuilder: (context, ovcNoneParticipant, index) =>
              NoneParticipantBeneficiaryCard(
            beneficiary: ovcNoneParticipant,
            canEdit: true,
            onViewBeneficiary: () =>
                onViewBeneficiary(context, ovcNoneParticipant),
            onEditBeneficiary: () =>
                onEditBeneficiary(context, ovcNoneParticipant),
          ),
          emptyListWidget: Container(
            margin: const EdgeInsets.only(
              bottom: 16.0,
              right: 13.0,
              left: 13.0,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    currentLanguage == 'lesotho'
                        ? 'Ha hona eo seng karalo ea OVC hajoale'
                        : 'There is no OVC none participants at moment',
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
