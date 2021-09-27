import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/pp_prev_intervention_state/pp_prev_intervention_state.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/pp_prev_beneficiary.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/components/pp_prev_beneficiary_card.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/constants/pp_prev_routes_constant.dart';
import 'package:kb_mobile_app/modules/pp_prev_intervention/pages/pp_prev_intervention_enrollment_form.dart';
import 'package:provider/provider.dart';

class PpPrevInterventionHome extends StatelessWidget {
  const PpPrevInterventionHome({Key? key}) : super(key: key);

  final String title = 'PP PREV List';

  void onAddPpPrevBeneficiary(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId =
        "${PpPrevRoutesConstant.enrollmentPageModule}_$beneficiaryId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave);
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PpPrevInterventionEnrollmentForm();
          },
        ),
      );
    }
  }

  void onViewBeneficiary(
    BuildContext context,
    PpPrevBeneficiary ppPrevBeneficiary,
  ) {
    print("onViewBeneficiary => ${ppPrevBeneficiary.toString()}");
  }

  void onEditBeneficiary(
    BuildContext context,
    PpPrevBeneficiary ppPrevBeneficiary,
  ) {
    print("onEditBeneficiary => ${ppPrevBeneficiary.toString()}");
  }

  void onOpenBeneficiaryServices(
    BuildContext context,
    PpPrevBeneficiary ppPrevBeneficiary,
  ) {
    print("onOpenBeneficiaryServices => ${ppPrevBeneficiary.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PpPrevInterventionListState>(
      builder: (context, ppPrevInterventionListState, child) {
        return SubModuleHomeContainer(
          header:
              '$title : ${ppPrevInterventionListState.numberOfPpPrev} beneficiaries',
          bodyContents: _buildBody(),
        );
      },
    );
  }

  Container _buildBody() {
    return Container(
      child: Container(
        child: Consumer<PpPrevInterventionListState>(
          builder: (context, ppPrevInterventionListState, child) {
            return CustomPaginatedListView(
              childBuilder: (context, ppPrevBeneficiary, child) => Container(
                child: PpPrevBeneficiaryCard(
                  ppPrevBeneficiary: ppPrevBeneficiary,
                  onEditBeneficiary: () => onEditBeneficiary(
                    context,
                    ppPrevBeneficiary,
                  ),
                  onViewBeneficiary: () => onViewBeneficiary(
                    context,
                    ppPrevBeneficiary,
                  ),
                  onOpenBeneficiaryServices: () => onOpenBeneficiaryServices(
                    context,
                    ppPrevBeneficiary,
                  ),
                ),
              ),
              pagingController: ppPrevInterventionListState.pagingController!,
              emptyListWidget: Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Text(
                        'There is no PP PREV beneficiaries enrolled at moment',
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/add-beneficiary.svg',
                          color: Colors.blueGrey,
                        ),
                        onPressed: () => onAddPpPrevBeneficiary(context),
                      ),
                    )
                  ],
                ),
              ),
              errorWidget: Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Text(
                        'There is no PP PREV beneficiaries enrolled at moment',
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/add-beneficiary.svg',
                          color: Colors.blueGrey,
                        ),
                        onPressed: () => onAddPpPrevBeneficiary(context),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
