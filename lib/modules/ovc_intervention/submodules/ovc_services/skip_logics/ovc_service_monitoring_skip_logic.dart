import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:provider/provider.dart';

class OvcServiceMonitoringSkipLogic {
  Map hiddenFields = {};
  Map hiddenSections = {};
  Map childMapObject = {};

  Future evaluateSkipLogics(
    BuildContext context,
    List<FormSection> formSections,
    Map dataObject,
  ) async {
    CurrentUser? currentUser = Provider.of<CurrentUserState>(context, listen: false).currentUser;
    String implementingPartner = currentUser!.implementingPartner ?? "";

    hiddenFields.clear();
    hiddenSections.clear();

    // Gather all progress fields
    List<FormSection> filteredFormSections = formSections
        .where((formSection) => formSection.id != '' && formSection.id != null)
        .toList();
    List<String> inputFieldIds = FormUtil.getFormFieldIds(filteredFormSections);

    // Gather all non-progress fields
    List<FormSection> sectionsToBeSkipped = formSections
        .where((formSection) => formSection.id == '' || formSection.id == null)
        .toList();
    List<String> skippedInputFieldIds = FormUtil.getFormFieldIds(sectionsToBeSkipped);

    for (String inputFieldId in inputFieldIds) {
      hiddenFields[inputFieldId] = !['eventDate', 'location'].contains(inputFieldId);
    }

    // skip logics for non-progress fields
    for (String inputFieldId in skippedInputFieldIds) {
      String value = "${dataObject[inputFieldId]}";
      if (inputFieldId == 'kEa51XegbF1' && value != 'true') {
        hiddenFields['whQroZXYFXl'] = true;
      }
      if (inputFieldId == 'pgjVoHQ4rr7' && value != 'true') {
        hiddenFields['lHfHlWRFF7C'] = true;
      }
      if (inputFieldId == 'gdbL3fKWwXn' && value != 'true') {
        hiddenFields['uRsImCXXDXe'] = true;
        hiddenFields['jiS3es770I1'] = true;
        hiddenFields['ywYdzitJvSi'] = true;
        hiddenFields['KgLtXquRot3'] = true;
      }
      if (inputFieldId == 'uRsImCXXDXe' && value != 'Positive') {
        hiddenFields['jiS3es770I1'] = true;
        hiddenFields['KgLtXquRot3'] = true;
        hiddenFields['ywYdzitJvSi'] = true;
      }
      if (inputFieldId == 'ywYdzitJvSi' && value != 'true') {
        hiddenFields['KgLtXquRot3'] = true;
      }
    }

    // Hidding all progress fields
    for (var key in dataObject.keys) {
      if (!skippedInputFieldIds.contains(key)) {
        inputFieldIds.add('$key');
      }
    }
    inputFieldIds = inputFieldIds.toSet().toList();

    dataObject.forEach((key, value) {
      if (key == 'pbcXNnAuzfh' && value == 'true') {
        hiddenFields['GUwNhNgTfpY'] = hideServicesByImplementingPartner(
          "GUwNhNgTfpY",
          implementingPartner,
        );
      } else if (key == 'ylSjcj6cv42' && value == 'true') {
        hiddenFields['yOoWkd9dHsJ'] = hideServicesByImplementingPartner(
          "yOoWkd9dHsJ",
          implementingPartner,
        );
      } else if (key == 'XoSPWmpWXCy' && value == 'true') {
        hiddenFields['DC4B9EIMZN9'] = hideServicesByImplementingPartner(
          "DC4B9EIMZN9",
          implementingPartner,
        );
      } else if (key == 'AxtahhoHcXV' && value == 'true') {
        hiddenFields['fySDvo8AXNy'] = hideServicesByImplementingPartner(
          "fySDvo8AXNy",
          implementingPartner,
        );
      } else if (key == 'd2vXxEPeCq7' && value == 'true') {
        hiddenFields['kWyCcWCVJjv'] = hideServicesByImplementingPartner(
          "kWyCcWCVJjv",
          implementingPartner,
        );
      } else if (key == 'dTFLFtUUeEK' && value == 'true') {
        hiddenFields['QvFFo0xqZCy'] = hideServicesByImplementingPartner(
          "QvFFo0xqZCy",
          implementingPartner,
        );
      } else if (key == 'Hvq9oisH7Gt' && value == 'true') {
        hiddenFields['qezhtOHXgaK'] = hideServicesByImplementingPartner(
          "qezhtOHXgaK",
          implementingPartner,
        );
      } else if (key == 'qTf8VSoojJ2' && value == 'true') {
        hiddenFields['W4UjM09aOEw'] = hideServicesByImplementingPartner(
          "W4UjM09aOEw",
          implementingPartner,
        );
      } else if (key == 'DQxqyncQtwm' && value == 'true') {
        hiddenFields['TaSyHHXKYhF'] = hideServicesByImplementingPartner(
          "TaSyHHXKYhF",
          implementingPartner,
        );
      } else if (key == 'e6NV2ZAzFEh' && value == 'true') {
        hiddenFields['wNUBfCAg3Fq'] = hideServicesByImplementingPartner(
          "wNUBfCAg3Fq",
          implementingPartner,
        );
      } else if (key == 'kvF996ugmMl' && value == 'true') {
        hiddenFields['QD77bNjavza'] = hideServicesByImplementingPartner(
          "QD77bNjavza",
          implementingPartner,
        );
      } else if (key == 'iiJpQsEE4qx' && value == 'true') {
        hiddenFields['VtX5d8LBcZP'] = hideServicesByImplementingPartner(
          "VtX5d8LBcZP",
          implementingPartner,
        );
      } else if (key == 'ithLHgsAoxs' && value == 'true') {
        hiddenFields['b2f8Bv0MozX'] = hideServicesByImplementingPartner(
          "b2f8Bv0MozX",
          implementingPartner,
        );
      } else if (key == 'JqGGsDlZh8T' && value == 'true') {
        hiddenFields['HwbAyUqRqjT'] = hideServicesByImplementingPartner(
          "HwbAyUqRqjT",
          implementingPartner,
        );
      } else if (key == 'WrjNxZBVHCL' && value == 'true') {
        hiddenFields['legjCg7fomo'] = hideServicesByImplementingPartner(
          "legjCg7fomo",
          implementingPartner,
        );
      } else if (key == 'PoxYSqq8Hgz' && value == 'true') {
        hiddenFields['JgokYFY6IWK'] = hideServicesByImplementingPartner(
          "JgokYFY6IWK",
          implementingPartner,
        );
      } else if (key == 'aPmPhwm8Zln' && value == 'true') {
        hiddenFields['es23GNgSa7N'] = hideServicesByImplementingPartner(
          "es23GNgSa7N",
          implementingPartner,
        );
      } else if (key == 'Vd8dV7OweWB' && value == 'true') {
        hiddenFields['akSICiOvXty'] = hideServicesByImplementingPartner(
          "akSICiOvXty",
          implementingPartner,
        );
      } else if (key == 'Ccp4Odlh3BE' && value == 'true') {
        hiddenFields['J5Tw8gd59Aq'] = hideServicesByImplementingPartner(
          "J5Tw8gd59Aq",
          implementingPartner,
        );
      } else if (key == 'AaqeRcyjbyS' && value == 'true') {
        hiddenFields['x3FxC6Bw139'] = hideServicesByImplementingPartner(
          "x3FxC6Bw139",
          implementingPartner,
        );
      } else if (key == 'yf6KmY3Rm5I' && value == 'true') {
        hiddenFields['ngjLjWJjPmN'] = hideServicesByImplementingPartner(
          "ngjLjWJjPmN",
          implementingPartner,
        );
      } else if (key == 'WdZ3PnW5yV6' && value == 'true') {
        hiddenFields['XPFvUiqedGQ'] = hideServicesByImplementingPartner(
          "XPFvUiqedGQ",
          implementingPartner,
        );
      } else if (key == 'hS7aONLz2cq' && value == 'true') {
        hiddenFields['zYjncKPdz9C'] = hideServicesByImplementingPartner(
          "zYjncKPdz9C",
          implementingPartner,
        );
      } else if (key == 'TQSMaZgfZPO' && value == 'true') {
        hiddenFields['KURLrgcqqZS'] = hideServicesByImplementingPartner(
          "KURLrgcqqZS",
          implementingPartner,
        );
      } else if (key == 'SN2kJN3jAG9' && value == 'true') {
        hiddenFields['MKfKx93j7Mb'] = hideServicesByImplementingPartner(
          "MKfKx93j7Mb",
          implementingPartner,
        );
      } else if (key == 'X47zxNAqMv0' && value == 'true') {
        hiddenFields['I4vmREMJZug'] = hideServicesByImplementingPartner(
          "I4vmREMJZug",
          implementingPartner,
        );
      } else if (key == 'cx4xBY4jZXM' && value == 'true') {
        hiddenFields['PcLhqLEjKGw'] = hideServicesByImplementingPartner(
          "PcLhqLEjKGw",
          implementingPartner,
        );
      } else if (key == 'yJQi4cbzeBF' && value == 'true') {
        hiddenFields['kVvlzs4hSP3'] = hideServicesByImplementingPartner(
          "kVvlzs4hSP3",
          implementingPartner,
        );
      } else if (key == 'x4yAqv4z2Xv' && value == 'true') {
        hiddenFields['Kcy88uJjTQl'] = hideServicesByImplementingPartner(
          "Kcy88uJjTQl",
          implementingPartner,
        );
      } else if (key == 'AM9oJCOHM7f' && value == 'true') {
        hiddenFields['a7yFGFtZ3U9'] = hideServicesByImplementingPartner(
          "a7yFGFtZ3U9",
          implementingPartner,
        );
      } else if (key == 'hJUuQ648wVF' && value == 'true') {
        hiddenFields['A3aXfHkuywQ'] = hideServicesByImplementingPartner(
          "A3aXfHkuywQ",
          implementingPartner,
        );
      } else if (key == 'BJrrrqQqwQO' && value == 'true') {
        hiddenFields['qhTPL1R9OlY'] = hideServicesByImplementingPartner(
          "qhTPL1R9OlY",
          implementingPartner,
        );
      } else if (key == 'LswSBpMoG5C' && value == 'true') {
        hiddenFields['FroSdO9AGHb'] = hideServicesByImplementingPartner(
          "FroSdO9AGHb",
          implementingPartner,
        );
      } else if (key == 'gCKoJgBFdob' && value == 'true') {
        hiddenFields['lviiwATI5uv'] = hideServicesByImplementingPartner(
          "lviiwATI5uv",
          implementingPartner,
        );
      } else if (key == 'JSQ3xP1NhuN' && value == 'true') {
        hiddenFields['BLuel6eSkV3'] = hideServicesByImplementingPartner(
          "BLuel6eSkV3",
          implementingPartner,
        );
      } else if (key == 'AwWKp6KmqgY' && value == 'true') {
        hiddenFields['JINWcteYR7D'] = hideServicesByImplementingPartner(
          "JINWcteYR7D",
          implementingPartner,
        );
      } else if (key == 'EaJTFrklMo5' && value == 'true') {
        hiddenFields['gtXZARFG9Pa'] = hideServicesByImplementingPartner(
          "gtXZARFG9Pa",
          implementingPartner,
        );
      } else if (key == 'HsxFZOuV4oZ' && value == 'true') {
        hiddenFields['EG4MGO83vqG'] = hideServicesByImplementingPartner(
          "EG4MGO83vqG",
          implementingPartner,
        );
      } else if (key == 'yPP7lkomNfK' && value == 'true') {
        hiddenFields['a7GDFMWz1qf'] = hideServicesByImplementingPartner(
          "a7GDFMWz1qf",
          implementingPartner,
        );
      } else if (key == 'uQiyym8SEvd' && value == 'true') {
        hiddenFields['KNRkkNs8IeP'] = hideServicesByImplementingPartner(
          "KNRkkNs8IeP",
          implementingPartner,
        );
      } else if (key == 'WiPTQhWLVU1' && value == 'true') {
        hiddenFields['UqQEuWwhwBd'] = hideServicesByImplementingPartner(
          "UqQEuWwhwBd",
          implementingPartner,
        );
      } else if (key == 'neF08iYV9Os' && value == 'true') {
        hiddenFields['amHHA220xdt'] = hideServicesByImplementingPartner(
          "amHHA220xdt",
          implementingPartner,
        );
      } else if (key == 'GO3Ojp1UEX7' && value == 'true') {
        hiddenFields['HY12JH4WYIl'] = hideServicesByImplementingPartner(
          "HY12JH4WYIl",
          implementingPartner,
        );
      } else if (key == 'exHDkX1gPiC' && value == 'true') {
        hiddenFields['ouQhwyHxW0W'] = hideServicesByImplementingPartner(
          "ouQhwyHxW0W",
          implementingPartner,
        );
      } else if (key == 'Cb8qzfdrg7d' && value == 'true') {
        hiddenFields['AKjlaqY2VFZ'] = hideServicesByImplementingPartner(
          "AKjlaqY2VFZ",
          implementingPartner,
        );
      } else if (key == 'qraZh4n14S4' && value == 'true') {
        hiddenFields['wJergsqzGLz'] = hideServicesByImplementingPartner(
          "wJergsqzGLz",
          implementingPartner,
        );
      } else if (key == 'TdReJf2LTXA' && value == 'true') {
        hiddenFields['V8IMX0zD0Of'] = hideServicesByImplementingPartner(
          "V8IMX0zD0Of",
          implementingPartner,
        );
      } else if (key == 'q2N7p3UbvSF' && value == 'true') {
        hiddenFields['ks2bazFqWHo'] = hideServicesByImplementingPartner(
          "ks2bazFqWHo",
          implementingPartner,
        );
      } else if (key == 'NcMANzhhphO' && value == 'true') {
        hiddenFields['T51fsJaITSM'] = hideServicesByImplementingPartner(
          "T51fsJaITSM",
          implementingPartner,
        );
      } else if (key == 'ksc7ov3MihX' && value == 'true') {
        hiddenFields['C06k1O4qrjw'] = hideServicesByImplementingPartner(
          "C06k1O4qrjw",
          implementingPartner,
        );
      } else if (key == 'EaJTFrklMo5' && value == 'true') {
        hiddenFields['gtXZARFG9Pa'] = hideServicesByImplementingPartner(
          "gtXZARFG9Pa",
          implementingPartner,
        );
      }
    });

    for (String sectionId in hiddenSections.keys) {
      List<FormSection> allFormSections = FormUtil.getFlattenFormSections(filteredFormSections);
      List<String> hiddenSectionInputFieldIds = FormUtil.getFormFieldIds(
          allFormSections.where((formSection) => formSection.id == sectionId).toList());
      for (String inputFieldId in hiddenSectionInputFieldIds) {
        hiddenFields[inputFieldId] = true;
      }
    }
    resetValuesForHiddenFields(context, hiddenFields.keys);
  }

  ///
  /// this function filter the services based on IP
  /// It's implemented based on Paralegal
  ///
  bool hideServicesByImplementingPartner(
    String service,
    String implementingPartner,
  ) {
    if (OvcCasePlanConstant.paralegalServices.contains(service)) {
      var isCurrentUserParalegal = implementingPartner == 'Paralegal';
      return !isCurrentUserParalegal;
    } else if (implementingPartner == 'Paralegal') {
      return true;
    } else {
      return false;
    }
  }

  resetValuesForHiddenFields(BuildContext context, inputFieldIds) {
    for (String inputFieldId in inputFieldIds) {
      if (hiddenFields[inputFieldId]) {
        assignInputFieldValue(context, inputFieldId, null);
      }
    }
  }

  assignInputFieldValue(
    BuildContext context,
    String inputFieldId,
    String? value,
  ) {
    childMapObject[inputFieldId] = value;
  }
}
