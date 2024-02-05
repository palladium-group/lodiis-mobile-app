import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_intervention_list_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/constants/beneficiary_identification.dart';
import 'package:kb_mobile_app/core/constants/user_account_reference.dart';
import 'package:kb_mobile_app/core/services/form_auto_save_offline_service.dart';
import 'package:kb_mobile_app/core/services/user_service.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_routes_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_enrollment_child_services.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/services/ovc_enrollment_household_service.dart';
import 'package:provider/provider.dart';

class OvcEnrollementFormSavingContaniner extends StatefulWidget {
  const OvcEnrollementFormSavingContaniner({
    Key? key,
  }) : super(key: key);

  @override
  State<OvcEnrollementFormSavingContaniner> createState() =>
      _OvcEnrollementFormSavingContaninerState();
}

class _OvcEnrollementFormSavingContaninerState extends State<OvcEnrollementFormSavingContaniner> {
  final bool shouldEnroll = true;
  final String trackedEntityInstance = AppUtil.getUid();
  @override
  void initState() {
    super.initState();
    _onInitateSaving();
  }

  void _clearFormAutoSaveState(BuildContext context) async {
    String beneficiaryId = "";
    String formAutoSaveId = "${OvcRoutesConstant.ovcConcentFormPage}_$beneficiaryId";
    await FormAutoSaveOfflineService().deleteSavedFormAutoData(formAutoSaveId);
  }

  _onInitateSaving() async {
    int maleCount = 0;
    int femaleCount = 0;
    Map dataObject = Provider.of<EnrollmentFormState>(context, listen: false).formState;
    dataObject['PN92g65TkVI'] = dataObject['PN92g65TkVI'] ?? 'Active';
    List<String> hiddenFields = [
      BeneficiaryIdentification.beneficiaryId,
      BeneficiaryIdentification.beneficiaryIndex,
      'PN92g65TkVI',
      UserAccountReference.implementingPartnerAttribute,
      UserAccountReference.serviceProviderAttribute,
      UserAccountReference.subImplementingPartnerAttribute
    ];
    List<Map> childMapObjects = [];
    for (Map childObj in dataObject["children"]) {
      String sexValue = childObj['vIX4GTSCX4P'] ?? '';
      if (sexValue == 'Male') {
        maleCount++;
      } else if (sexValue == 'Female') {
        femaleCount++;
      }
      childMapObjects.add(childObj);
    }
    dataObject['kQehaqmaygZ'] = maleCount.toString();
    dataObject['BXUNH6LXeGA'] = femaleCount.toString();
    dataObject.remove('children');
    CurrentUser? user = await UserService().getCurrentUser();
    dataObject[UserAccountReference.implementingPartnerAttribute] =
        dataObject[UserAccountReference.implementingPartnerAttribute] ?? user!.implementingPartner;
    dataObject[UserAccountReference.serviceProviderAttribute] =
        dataObject[UserAccountReference.serviceProviderAttribute] ?? user!.username;
    if (user!.subImplementingPartner != '') {
      dataObject[UserAccountReference.subImplementingPartnerAttribute] =
          dataObject[UserAccountReference.subImplementingPartnerAttribute] ??
              user.subImplementingPartner;
    }
    String? orgUnit = dataObject['location'];
    String? enrollment = dataObject['enrollment'];
    String enrollmentDate = dataObject['enrollmentDate'] ?? '';
    String incidentDate = dataObject['incidentDate'] ?? enrollmentDate;
    await OvcEnrollmentHouseholdService().savingHouseholdForm(
      dataObject,
      trackedEntityInstance,
      orgUnit,
      enrollment,
      enrollmentDate,
      incidentDate,
      shouldEnroll,
      hiddenFields,
    );
    await OvcEnrollmentChildService().savingChildrenEnrollmentForms(
      trackedEntityInstance,
      orgUnit,
      childMapObjects,
      enrollmentDate,
      incidentDate,
      shouldEnroll,
      hiddenFields,
    );
    await Provider.of<OvcInterventionListState>(context, listen: false).onHouseholdAdd();
    _clearFormAutoSaveState(context);
    Timer(const Duration(seconds: 1), () {
      if (Navigator.canPop(context)) {
        bool isSesothoLanguage =
            Provider.of<LanguageTranslationState>(context, listen: false).isSesothoLanguage;
        AppUtil.showToastMessage(
          message: isSesothoLanguage ? 'Fomo e bolokeile' : 'Form has been saved successfully',
          position: ToastGravity.TOP,
        );
        setState(() {});
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.shortestSide,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProcessLoader(color: Colors.blueGrey),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 15.0,
            ),
            child: Text(
              "Saving caregiver and OVCs information ...",
              style: const TextStyle().copyWith(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        ],
      ),
    );
  }
}
