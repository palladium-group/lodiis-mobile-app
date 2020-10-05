import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/models/agyw_dream.dart';
import 'package:kb_mobile_app/models/tracked_entity_instance.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/components/dream_beneficiary_card_header.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/dreams_enrollment/dream_enrollment_page_view_form.dart';
import 'package:kb_mobile_app/modules/dreams_intervention/submodules/non_agyw/non_agyw_enrollment_page_view_form.dart';
import 'package:provider/provider.dart';

class DreamsBeneficiaryCard extends StatelessWidget {
  const DreamsBeneficiaryCard({
    Key key,
    @required this.canEdit,
    @required this.canView,
    @required this.canExpand,
    @required this.isExpanded,
    @required this.beneficiaryName,
    @required this.cardBody,
    @required this.cardBottonActions,
    @required this.cardBottonContent,
    @required this.agywDream,
    @required this.isAgywEnrollment,
    this.onCardToogle,
  }) : super(key: key);

  final Widget cardBody;
  final Widget cardBottonActions;
  final Widget cardBottonContent;
  final bool canEdit;
  final bool canView;
  final bool canExpand;
  final bool isExpanded;
  final String beneficiaryName;
  final AgywDream agywDream;
  final bool isAgywEnrollment;

  final VoidCallback onCardToogle;

  final String svgIcon = 'assets/icons/dreams-header-icon.svg';

  void onEdit() {}
  void updateEnrollmentFormStateData(BuildContext context, bool edit) {
    TrackeEntityInstance teiData = agywDream.trackeEntityInstanceData;
    Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
    Provider.of<EnrollmentFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: edit);
    for (Map attributeObj in teiData.attributes) {
      if (attributeObj['value'] != '' && '${attributeObj['value']}' != 'null') {
        Provider.of<EnrollmentFormState>(context, listen: false)
            .setFormFieldState(
                attributeObj['attribute'], attributeObj['value']);
      }
    }
  }

  void onView(BuildContext context) {
    updateEnrollmentFormStateData(context, false);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => isAgywEnrollment
              ? DreamAgywEnrollmentViewForm()
              : DreamNonAgywEnrollmentViewForm(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0, right: 13.0, left: 13.0),
      child: MaterialCard(
        body: Container(
          child: Column(
            children: [
              DreamBeneficiaryCardHeader(
                svgIcon: svgIcon,
                beneficiaryName: beneficiaryName,
                canEdit: canEdit,
                canExpand: canExpand,
                canView: canView,
                isExpanded: isExpanded,
                onToggleCard: onCardToogle,
                onEdit: onEdit,
                onView: () => onView(context),
              ),
              cardBody,
              cardBottonActions,
              Visibility(
                  visible: isExpanded,
                  child: Row(
                    children: [cardBottonContent],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
