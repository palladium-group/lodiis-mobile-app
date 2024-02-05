import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ogac_intervention_list_state/ogac_intervention_list_state.dart';
import 'package:kb_mobile_app/core/components/paginated_list_view.dart';
import 'package:kb_mobile_app/core/components/sub_module_home_container.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/utils/app_resume_routes/app_resume_route.dart';
import 'package:kb_mobile_app/models/form_auto_save.dart';
import 'package:kb_mobile_app/models/ogac_beneficiary.dart';
import 'package:kb_mobile_app/modules/ogac_intervention/components/ogac_beneficiary_card.dart';
import 'package:kb_mobile_app/modules/ogac_intervention/constants/ogac_routes_constant.dart';
import 'package:kb_mobile_app/modules/ogac_intervention/pages/ogac_enrollment_form.dart';
import 'package:provider/provider.dart';

class OgacInterventionHome extends StatelessWidget {
  const OgacInterventionHome({
    Key? key,
  }) : super(key: key);

  final String title = 'OGAC List';
  final String translatedTitle = 'Lethathamo la OGAC';
  void onUpdateFormState(
    BuildContext context,
    OgacBeneficiary ogacBeneficiary,
    bool isEditableMode,
  ) {
    Provider.of<EnrollmentFormState>(context, listen: false).resetFormState();
    Provider.of<EnrollmentFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    Provider.of<EnrollmentFormState>(context, listen: false).setFormFieldState(
        'location',
        isEditableMode ? ogacBeneficiary.orgUnit : ogacBeneficiary.location);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('trackedEntityInstance', ogacBeneficiary.id);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('orgUnit', ogacBeneficiary.orgUnit);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('enrollment', ogacBeneficiary.enrollment);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('enrollmentDate', ogacBeneficiary.createdDate);
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setFormFieldState('incidentDate', ogacBeneficiary.createdDate);
    if (ogacBeneficiary.trackedEntityInstanceData != null) {
      for (Map attributeObj
          in ogacBeneficiary.trackedEntityInstanceData!.attributes) {
        Provider.of<EnrollmentFormState>(context, listen: false)
            .setFormFieldState(
                attributeObj['attribute'], attributeObj['value']);
      }
    }
    if (ogacBeneficiary.eventData != null) {
      Provider.of<EnrollmentFormState>(context, listen: false)
          .setFormFieldState('eventDate', ogacBeneficiary.eventData!.eventDate);
      Provider.of<EnrollmentFormState>(context, listen: false)
          .setFormFieldState('eventId', ogacBeneficiary.eventData!.event);
      for (Map dataValue in ogacBeneficiary.eventData!.dataValues) {
        Provider.of<EnrollmentFormState>(context, listen: false)
            .setFormFieldState(dataValue['dataElement'], dataValue['value']);
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const OgacEnrollmentForm();
        },
      ),
    );
  }

  void onViewBeneficiary(
    BuildContext context,
    OgacBeneficiary ogacBeneficiary,
  ) {
    onUpdateFormState(context, ogacBeneficiary, false);
  }

  void onEditBeneficiary(
    BuildContext context,
    OgacBeneficiary ogacBeneficiary,
  ) async {
    String beneficiaryId = ogacBeneficiary.id ?? "";
    String formAutoSaveId = "${OgacRoutesConstant.pageModule}_$beneficiaryId";
    FormAutoSave formAutoSave =
        await FormAutoSaveOfflineService().getSavedFormAutoData(formAutoSaveId);
    bool shouldResumeWithUnSavedChanges = await AppResumeRoute()
        .shouldResumeWithUnSavedChanges(context, formAutoSave,
            beneficiaryName: ogacBeneficiary.toString());
    if (shouldResumeWithUnSavedChanges) {
      AppResumeRoute().redirectToPages(context, formAutoSave);
    } else {
      onUpdateFormState(context, ogacBeneficiary, true);
    }
  }

  void onAddOgacBeneficiary(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId = "${OgacRoutesConstant.pageModule}_$beneficiaryId";
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
            return const OgacEnrollmentForm();
          },
        ),
      );
    }
  }

  void refreshBeneficiaryList(
      OgacInterventionListState ogacInterventionListState) {
    ogacInterventionListState.refreshOgacNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageTranslationState>(
      builder: (context, languageState, child) =>
          Consumer<OgacInterventionListState>(
        builder: (context, dreamInterventionListState, child) {
          return SubModuleHomeContainer(
            header: languageState.currentLanguage == 'lesotho'
                ? '$translatedTitle : ${dreamInterventionListState.numberOfOgac} Ba unang melemo ka hare ho morero'
                : '$title : ${dreamInterventionListState.numberOfOgac} beneficiaries',
            bodyContents: _buildBody(),
            showFilter: true,
          );
        },
      ),
    );
  }

  Consumer<OgacInterventionListState> _buildBody() {
    return Consumer<OgacInterventionListState>(
      builder: (context, ogacInterventionListState, child) {
        return Consumer<LanguageTranslationState>(
          builder: (context, languageState, child) => RefreshIndicator(
            onRefresh: () async =>
                refreshBeneficiaryList(ogacInterventionListState),
            child: CustomPaginatedListView(
              childBuilder: (context, ogacBeneficiary, child) =>
                  OgacBeneficiaryCard(
                ogacBeneficiary: ogacBeneficiary,
                onEditBeneficiary: () =>
                    onEditBeneficiary(context, ogacBeneficiary),
                onViewBeneficiary: () =>
                    onViewBeneficiary(context, ogacBeneficiary),
              ),
              pagingController: ogacInterventionListState.pagingController,
              emptyListWidget: Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Text(
                        languageState.currentLanguage == 'lesotho'
                            ? 'Ha hona ba ngolisitsoeng tlasa OGAC hajoale'
                            : 'There is no OGAC beneficiaries enrolled at the moment',
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/add-beneficiary.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.blueGrey,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () => onAddOgacBeneficiary(context),
                    )
                  ],
                ),
              ),
              errorWidget: Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: const Text(
                        'There is no OGAC beneficiaries enrolled at the moment',
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/add-beneficiary.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.blueGrey,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () => onAddOgacBeneficiary(context),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
