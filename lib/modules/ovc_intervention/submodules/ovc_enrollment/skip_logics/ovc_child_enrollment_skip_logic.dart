import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/enrollment_form_state.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_enrollment/constants/ovc_enrollment_child_form_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/constants/ovc_intervention_constant.dart';
import 'package:provider/provider.dart';

class OvcChildEnrollmentSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};
  static Map hiddenInputFieldOptions = {};
  static Map assignedFields = {};

  static T? _firstNonNull<T>(dynamic a, dynamic b) =>
      (a is T) ? a : (b is T ? b : null);

  static void _guardParentArtVisibilityTyped({
    required Map dataObject,
    required Map assignedFields,
    required Map hiddenFields,
    required String aliveField,
    required String hivField,
    required String onArtField,
    required String artFacilityField,
  }) {
    final String alive = _firstNonNull<String>(dataObject[aliveField], assignedFields[aliveField]) ?? '';
    final String hiv   = _firstNonNull<String>(dataObject[hivField], assignedFields[hivField]) ?? '';
    final bool? onArt  = _firstNonNull<bool>(dataObject[onArtField], assignedFields[onArtField]);

    if (alive != 'Yes') {
      hiddenFields[onArtField] = true;
      hiddenFields[artFacilityField] = true;
      return;
    }
    if (hiv != 'Positive') {
      hiddenFields[onArtField] = true;
      hiddenFields[artFacilityField] = true;
      return;
    }
    hiddenFields.remove(onArtField);
    if (onArt == true) {
      hiddenFields.remove(artFacilityField);
    } else {
      hiddenFields[artFacilityField] = true;
    }
  }


  static Map evaluateSkipLogics(
    BuildContext context,
    List<FormSection> formSections,
    Map dataObject, {
    bool shouldSetEnrollmentState = true,
    Map caregiverDataObject = const {},
  }) {

    hiddenSections.clear();
    hiddenFields.clear();
    hiddenFields['RB8Wx75hGa4'] = true;
    hiddenInputFieldOptions.clear();
    assignedFields.clear();


    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }
    inputFieldIds = inputFieldIds.toSet().toList();

    var caregiverFirstName =
        caregiverDataObject[OvcInterventionConstant.firstName] ?? '';
    var caregiverMiddleName =
        caregiverDataObject[OvcInterventionConstant.middleName] ?? '';
    var caregiverDateOfBirth =
        caregiverDataObject[OvcInterventionConstant.dateOfBirth] ?? '';
    var caregiverSurname =
        caregiverDataObject[OvcInterventionConstant.surname] ?? '';
    var caregiverPhoneNumber =
        caregiverDataObject[OvcInterventionConstant.phoneNumber] ?? '';
    var caregiverVillage =
        caregiverDataObject[OvcInterventionConstant.village] ?? '';
    var caregiverSubVillage =
        caregiverDataObject[OvcInterventionConstant.phoneNumber] ?? '';
    var caregiverHivStatus =
        caregiverDataObject[OvcInterventionConstant.hivStatus] ?? '';
    var caregiverArtStatus =
        caregiverDataObject[OvcInterventionConstant.artStatus] ?? '';
    var caregiverArtFacility =
        caregiverDataObject[OvcInterventionConstant.artFacility] ?? '';

    assignedFields[OvcEnrollmentChildConstant.village] = caregiverVillage;
    assignedFields[OvcEnrollmentChildConstant.subVillage] = caregiverSubVillage;

    final String? caregiverSex =
    (caregiverDataObject['vIX4GTSCX4P'] ?? dataObject['vIX4GTSCX4P'])
        ?.toString();

    final String relationshipToCaregiver =
    (dataObject['iS9mAp3jDaU'] ?? '').toString();
    final bool motherIsCaregiver = relationshipToCaregiver == 'Biological mother';
    final bool fatherIsCaregiver = relationshipToCaregiver == 'Biological father';


    for (String inputFieldId in inputFieldIds) {
      int age = AppUtil.getAgeInYear(dataObject['qZP982qpSPS']);
      String value = '${dataObject[inputFieldId]}';


      if (inputFieldId == 'iS9mAp3jDaU') {
        // Build the hide-map fresh each pass so changes to Sex re-render options correctly
        final Map<String, bool> optionHides = {};
        if (caregiverSex == 'Male') {
          // Hide mother when caregiver is male
          optionHides['Biological mother'] =
          true; // option *code* exactly as in form
        } else if (caregiverSex == 'Female') {
          // Hide father when caregiver is female
          optionHides['Biological father'] =
          true; // option *code* exactly as in form
        }

        // Overwrite for this field id (don’t merge, to avoid stale hides)
        hiddenInputFieldOptions[inputFieldId] = optionHides;
      }

      if (dataObject['vIX4GTSCX4P'] == 'Male') {
        hiddenFields['tHbPB5hrbOc'] = true;
        hiddenFields['ZGH70UbL2O1'] = true;
      }

      if (age > 5){
        hiddenFields['FYjxxvyugEt'] = true;
      }

      if (dataObject['XYPRtYgQUF8'] == 'Yes'){
        dataObject['tHbPB5hrbOc'] = true;
      }else{
        hiddenFields['tHbPB5hrbOc'] = true;
      }

      if (dataObject['nO38lKlKHYi'] == 'Positive' ||dataObject['tbpqNLJotOi'] == 'Positive' ){
        dataObject['ZKMhrjWoXnD'] = true;
      }else{
        hiddenFields['ZKMhrjWoXnD'] = true;
      }

      if (inputFieldId == 'iS9mAp3jDaU') {
        if (value == 'Biological mother') {
          assignedFields['R9e8v9r3lMM'] = 'Yes';
          assignedFields['d3HviODv676'] = caregiverFirstName;
          assignedFields['Zv8FOfjPZzm'] = caregiverMiddleName;
          assignedFields['FBdCMyESsdg'] = caregiverSurname;
          assignedFields['or2YNqJqVqZ'] = caregiverDateOfBirth;
          assignedFields['rP7oCRukLkq'] = caregiverPhoneNumber;
          assignedFields['nO38lKlKHYi'] = caregiverHivStatus;
          assignedFields['PAv1sKQn2hO'] = caregiverArtStatus;
          assignedFields['fa0BSFwqQGQ'] = caregiverArtFacility;
          final motherHiv = (caregiverHivStatus ?? '').toString().trim();
          if (motherHiv.isEmpty || motherHiv == 'Unknown') {
            hiddenFields['nO38lKlKHYi'] = true; // HIV status
            hiddenFields['PAv1sKQn2hO'] = true; // On ART
            hiddenFields['fa0BSFwqQGQ'] = true; // ART facility
          } else if (motherHiv == 'Negative') {
            hiddenFields['PAv1sKQn2hO'] = true;
            hiddenFields['fa0BSFwqQGQ'] = true;
          }
        }

        if (value == 'Biological father') {
          assignedFields['cJl00w5DjIL'] = 'Yes';
          assignedFields['ZPf4iCd2aw3'] = caregiverFirstName;
          assignedFields['zKKeQ5pTCAd'] = caregiverMiddleName;
          assignedFields['JMwIgMSUnlu'] = caregiverSurname;
          assignedFields['PvLva3TSY9N'] = caregiverDateOfBirth;
          assignedFields['NzeeDnWJsNU'] = caregiverPhoneNumber;
          assignedFields['tbpqNLJotOi'] = caregiverHivStatus;
          assignedFields['xJfScNlfNS2'] = caregiverArtStatus;
          assignedFields['IWFLOoEtisa'] = caregiverArtFacility;
          final fatherHiv = (caregiverHivStatus ?? '').toString().trim();
          if (fatherHiv.isEmpty || fatherHiv == 'Unknown') {
            hiddenFields['tbpqNLJotOi'] = true; // HIV status
            hiddenFields['xJfScNlfNS2'] = true; // On ART
            hiddenFields['IWFLOoEtisa'] = true; // ART facility
          } else if (fatherHiv == 'Negative') {
            hiddenFields['xJfScNlfNS2'] = true;
            hiddenFields['IWFLOoEtisa'] = true;
          }

        }
      }

      if (inputFieldId == 'psMvy1sqWwf' && value != 'true') {
        hiddenFields['mrODVshHUli'] = true;
      }
      if (inputFieldId == 'XYPRtYgQUF8' && value != 'Yes'){
        hiddenFields['xSd3LPUf8Tf'] = true;
      }

      if (inputFieldId == 'oSKX8fFQdWc' && value == 'Positive') {
        hiddenFields['NqhUKijE4hB'] = true;
        hiddenFields['GMcljM7jbNG'] = true;
      }
      if (inputFieldId == 'nO38lKlKHYi' && value != 'Positive') {
        hiddenFields['GMcljM7jbNG'] = true;
      }
      else if (inputFieldId == 'tNdoR0jYr7R') {
        if (caregiverPhoneNumber != 'N/A') {
          if (shouldSetEnrollmentState) {
            assignInputFieldValue(context, 'tNdoR0jYr7R', caregiverPhoneNumber);
          } else {
            assignedFields['tNdoR0jYr7R'] = caregiverPhoneNumber;
          }
        } else {
          hiddenFields['tNdoR0jYr7R'] = true;
        }
      } else if (inputFieldId == 'qZP982qpSPS') {
        int age = AppUtil.getAgeInYear(value);
        if (shouldSetEnrollmentState) {
          assignInputFieldValue(context, 'ls9hlz2tyol', age.toString());
        } else {
          assignedFields['ls9hlz2tyol'] = age.toString();
        }
        if (age > 18 || age < 10) {
          hiddenFields['ZGH70UbL2O1'] = true;
          hiddenFields['tHbPB5hrbOc'] = true;
        }
        if (age < 10) {
          hiddenFields['psMvy1sqWwf'] = true;
          hiddenFields['mrODVshHUli'] = true;
          hiddenFields['XYPRtYgQUF8'] = true;
          hiddenFields['xSd3LPUf8Tf'] = true;
          hiddenFields['wGFmu7DhNGV'] = true;
          hiddenFields['d9E1aPQ4MKa'] = true;
          hiddenFields['OcY02VcD7fm'] = true;
        }
      } else if (inputFieldId == 'vIX4GTSCX4P' && value == 'Male') {
        hiddenFields['psMvy1sqWwf'] = true;
        hiddenFields['mrODVshHUli'] = true;
        hiddenFields['XYPRtYgQUF8'] = true;
        hiddenFields['xSd3LPUf8Tf'] = true;
        hiddenFields['wGFmu7DhNGV'] = true;
        hiddenFields['d9E1aPQ4MKa'] = true;
        hiddenFields['OcY02VcD7fm'] = true;
        hiddenFields['ZGH70UbL2O1'] = true;
      }
      else if (inputFieldId == 'wGFmu7DhNGV' && value != 'true') {
        hiddenFields['ZGH70UbL2O1'] = true;
        hiddenFields['d9E1aPQ4MKa'] = true;
        hiddenFields['OcY02VcD7fm'] = true;
      }


      else if (inputFieldId == 'nOgf8LKXS4k') {
        Map hiddenOptions = {};
        String relationShipToCaregiver = '${dataObject['iS9mAp3jDaU']}';
        if (relationShipToCaregiver == 'Biological mother') {
          hiddenOptions['Single Orphan(Mother)'] = true;
          hiddenOptions['Double Orphan'] = true;
        } else if (relationShipToCaregiver == 'Biological father') {
          hiddenOptions['Single Orphan(Father)'] = true;
          hiddenOptions['Double Orphan'] = true;
        }
        hiddenInputFieldOptions[inputFieldId] = hiddenOptions;
        if (dataObject['vIX4GTSCX4P'] != 'Female') {
          hiddenFields['ZGH70UbL2O1'] = true;
          hiddenFields['tHbPB5hrbOc'] = true;
        }
        if (dataObject['cJl00w5DjIL'] == 'Yes' &&
            dataObject['R9e8v9r3lMM'] == 'Yes') {
          hiddenOptions['Single Orphan(Father)'] = true;
          hiddenOptions['Single Orphan(Mother)'] = true;
          hiddenOptions['Double Orphan'] = true;
        }
        if (dataObject['cJl00w5DjIL'] == 'Yes') {
          hiddenOptions['Single Orphan(Father)'] = true;
          hiddenOptions['Double Orphan'] = true;
        }
        if (dataObject['R9e8v9r3lMM'] == 'Yes') {
          hiddenOptions['Single Orphan(Mother)'] = true;
          hiddenOptions['Double Orphan'] = true;
        }

      } else if (inputFieldId == 'UeF4OvjIIEK') {
        if (value.isEmpty || value.trim() != 'true') {
          hiddenFields['nOgf8LKXS4k'] = true;
        }
        if (dataObject['cJl00w5DjIL'] == 'No' ||
            dataObject['R9e8v9r3lMM'] == 'No') {
          dataObject[inputFieldId] = 'true';
          hiddenFields['nOgf8LKXS4k'] = false;
        } else if (dataObject['cJl00w5DjIL'] == 'Yes' &&
            dataObject['R9e8v9r3lMM'] == 'Yes') {
          dataObject[inputFieldId] = 'false';
          hiddenFields['nOgf8LKXS4k'] = true;
        }
      } else if (inputFieldId == 'wmKqYZML8GA' &&
          (value.isEmpty || value.trim() == 'true')) {
        hiddenFields['NqhUKijE4hB'] = true;
        hiddenFields['GMcljM7jbNG'] = true;
      } else if (inputFieldId == 'GMcljM7jbNG') {
        int age =
        AppUtil.getAgeInYear('${dataObject["qZP982qpSPS"]}', ceil: true);
        if (age <= 3) {
          hiddenFields['WAlaenCYazT'] = true;
        }


        if (age > 3) {
          hiddenFields[inputFieldId] = true;
          hiddenFields['IQX90Pjcrdh'] = true;
        } else {
          var isOvcHIVExposedInfant = (age >= 0 && age <= 3) &&
              '${dataObject["nO38lKlKHYi"]}' == 'Positive';
          assignedFields[inputFieldId] = '$isOvcHIVExposedInfant';
          if (isOvcHIVExposedInfant == true) {
            hiddenFields['WAlaenCYazT'] = true;
          }
        }
        if (age <= 3) {
          if (inputFieldId == 'IQX90Pjcrdh' && value != 'true') {
            hiddenFields['oSKX8fFQdWc'] = true;
          }
        }
        if (age > 3 && (inputFieldId == 'WAlaenCYazT' && value != 'true')) {
          hiddenFields['oSKX8fFQdWc'] = true;
        }
      } else if (inputFieldId == 'Mc3k3bSwXNe' &&
          (value.isEmpty || value.trim() != 'true')) {
        hiddenFields['CePNVGSnj00'] = true;
        hiddenFields['GM2mJDlGZin'] = true;
      } else if (inputFieldId == 'CePNVGSnj00' &&
          (value.isEmpty || value.trim() != 'Other')) {
        hiddenFields['GM2mJDlGZin'] = true;
      } else if (inputFieldId == 'YR7Xxk14qoP' && value != 'true') {
        hiddenFields['YR7Xxk14qoP_checkbox'] = true;
        List<String> checkBoxFieldIds = [
          'dufGxx0KVg0',
          'nfp9NHLf25K',
          'tbLVGG4zDrJ',
          'ULr0tYkjTTB',
          'BfbiOanp9Pi',
          'X3MQhmVA1Jt',
          'TPRVr4ua9f9'
        ];
        for (String id in checkBoxFieldIds) {
          hiddenFields[id] = true;
        }
      } else if (inputFieldId == 'omUPOnb4JVp' && value != 'true') {
        hiddenFields['WsmWkkFBiT6'] = true;
      } else if (inputFieldId == 'JTNxMQPT134' && value != 'true') {
        hiddenFields['iQdwzVfZdml'] = true;
        hiddenFields['EwZil0AnlYo'] = true;
        hiddenFields['f7WkgoF9uib'] = true;
        hiddenFields['h1HeZ2eEkGn'] = true;
        hiddenFields['NGVFqUVSHiU'] = true;
        hiddenFields['oioDyk1WK1j'] = true;
        hiddenFields['cFDqjIXQucQ'] = true;
        hiddenFields['i6Y27IFBR9b'] = true;
      }

      else if (inputFieldId == 'IQX90Pjcrdh') {
        int age =
        AppUtil.getAgeInYear('${dataObject["qZP982qpSPS"]}', ceil: true);
        if (age <= 3 && (inputFieldId == 'IQX90Pjcrdh' && value != 'true')) {
          hiddenFields['oSKX8fFQdWc'] = true;
        }
      }

      else if (inputFieldId == 'WAlaenCYazT') {
        int age =
        AppUtil.getAgeInYear('${dataObject["qZP982qpSPS"]}', ceil: true);
        if (age > 3 && (inputFieldId == 'WAlaenCYazT' && value != 'true')) {
          hiddenFields['oSKX8fFQdWc'] = true;
        }
      }


      else if (inputFieldId == 'f7WkgoF9uib' && value == 'Preschool' ||
          value == 'TertiaryLevel' || value == 'VocationalLevel') {
        hiddenFields['cFDqjIXQucQ'] = true;
        hiddenFields['i6Y27IFBR9b'] = true;
      }
      else if (inputFieldId == 'iQdwzVfZdml' && value != 'Formal') {
        hiddenFields['f7WkgoF9uib'] = true;
        hiddenFields['cFDqjIXQucQ'] = true;
        hiddenFields['i6Y27IFBR9b'] = true;
      } else if (inputFieldId == 'WAlaenCYazT' && value != 'true') {
        hiddenFields['l7op0btSqSc'] = true;
        hiddenFields['iBws3HMjiUT'] = true;
        hiddenFields['aX0niP9AH6t'] = true;
        hiddenFields['EIMgHQW61kx'] = true;
      }

      else if (inputFieldId == 'f7WkgoF9uib' && value == 'SecondaryLevel') {
        hiddenFields['cFDqjIXQucQ'] = true;
      }
      else if (inputFieldId == 'f7WkgoF9uib' && value == 'PrimaryLevel') {
        hiddenFields['i6Y27IFBR9b'] = true;
      }
      else if (inputFieldId == 'oSKX8fFQdWc') {
        assignedFields['wmKqYZML8GA'] = '${value == 'Positive'}';
        if (value != 'Positive') {
          hiddenFields['l7op0btSqSc'] = true;
        }
      } else if (inputFieldId == 'l7op0btSqSc' && value != 'true') {
        hiddenFields['iBws3HMjiUT'] = true;
        hiddenFields['aX0niP9AH6t'] = true;
        hiddenFields['EIMgHQW61kx'] = true;
      }

      // else if (inputFieldId == 'tbpqNLJotOi' &&
      //     value != 'Positive' &&
      //     value != 'null') {
      //   hiddenFields['PAv1sKQn2hO'] = true;
      //   hiddenFields['fa0BSFwqQGQ'] = true;
      else if (inputFieldId == 'tbpqNLJotOi' && value != 'Positive') {
        hiddenFields['xJfScNlfNS2'] = true;   // Is father on ART?
        hiddenFields['IWFLOoEtisa'] = true;   // Father's ART facility

      } else if (inputFieldId == 'PAv1sKQn2hO' &&
          value != 'true' &&
          value != 'null') {
        hiddenFields['fa0BSFwqQGQ'] = true;
      }

      else if (inputFieldId == 'cJl00w5DjIL') {
        const fatherCauseOfDeath = 'wKEQZfKU2jX';

        // Only identity/contacts — NO HIV/ART fields here
        const fatherAliveBasics = <String>[
          'ZPf4iCd2aw3', // Father's name
          'zKKeQ5pTCAd', // Middle name
          'JMwIgMSUnlu', // Surname
          'PvLva3TSY9N', // DOB
          'NzeeDnWJsNU', // Phone
        ];

        // Default: hide both groups
        hiddenFields[fatherCauseOfDeath] = true;
        for (final id in fatherAliveBasics) {
          hiddenFields[id] = true;
        }
        // Also default-hide HIV/ART; they will be decided below
        hiddenFields['tbpqNLJotOi'] = true; // HIV status
        hiddenFields['xJfScNlfNS2'] = true; // On ART
        hiddenFields['IWFLOoEtisa'] = true; // ART facility

        if (value == 'Yes') {
          // Show basics
          for (final id in fatherAliveBasics) {
            hiddenFields.remove(id);
          }

          // Determine HIV/ART visibility once, here
          final fatherHiv = (
              assignedFields['tbpqNLJotOi'] ??
                  dataObject['tbpqNLJotOi'] ??
                  ''
          ).toString().trim();

          if (fatherIsCaregiver) {
            if (fatherHiv.isEmpty || fatherHiv == 'Unknown') {
              // keep HIV + ART hidden
            } else if (fatherHiv == 'Negative') {
              // show HIV only; keep ART hidden
              hiddenFields.remove('tbpqNLJotOi');
            } else {
              // Positive -> show HIV and ART
              hiddenFields.remove('tbpqNLJotOi');
              hiddenFields.remove('xJfScNlfNS2');
              hiddenFields.remove('IWFLOoEtisa');
            }
          } else {
            // Father is NOT the registered caregiver → keep capture fields visible
            hiddenFields.remove('tbpqNLJotOi');
            if (fatherHiv == 'Positive') {
              hiddenFields.remove('xJfScNlfNS2');
              hiddenFields.remove('IWFLOoEtisa');
            }
          }
        } else if (value == 'No') {
          // Show cause of death only
          hiddenFields.remove(fatherCauseOfDeath);
        }
      }

      // else if (inputFieldId == 'cJl00w5DjIL') {
      //   if (value != 'No') {
      //     hiddenFields['wKEQZfKU2jX'] = true;
      //   }else if (value =='No'){
      //    // hiddenFields['wKEQZfKU2jX'] = false;
      //     hiddenFields['ZPf4iCd2aw3'] = true;
      //     hiddenFields['zKKeQ5pTCAd'] = true;
      //     hiddenFields['JMwIgMSUnlu'] = true;
      //     hiddenFields['PvLva3TSY9N'] = true;
      //     hiddenFields['NzeeDnWJsNU'] = true;
      //     hiddenFields['tbpqNLJotOi'] = true;
      //     hiddenFields['xJfScNlfNS2'] = true;
      //     hiddenFields['IWFLOoEtisa'] = true;
      //
      //   }
      //   else if (value != "Yes") {
      //     hiddenFields['ZPf4iCd2aw3'] = true;
      //     hiddenFields['zKKeQ5pTCAd'] = true;
      //     hiddenFields['JMwIgMSUnlu'] = true;
      //     hiddenFields['PvLva3TSY9N'] = true;
      //     hiddenFields['NzeeDnWJsNU'] = true;
      //     hiddenFields['wKEQZfKU2jX'] = true;
      //     hiddenFields['tbpqNLJotOi'] = true;
      //     hiddenFields['xJfScNlfNS2'] = true;
      //     hiddenFields['IWFLOoEtisa'] = true;
      //
      //
      //   }

      else if (inputFieldId == 'nO38lKlKHYi' && value != 'Positive') {
        hiddenFields['PAv1sKQn2hO'] = true;   // Is mother on ART?
        hiddenFields['fa0BSFwqQGQ'] = true;   // Mother's ART facility

      } else if (inputFieldId == 'PAv1sKQn2hO' &&
          value != 'true' &&
          value != 'null') {
        hiddenFields['fa0BSFwqQGQ'] = true;
      }

      else if (inputFieldId == 'R9e8v9r3lMM') {
        const motherCauseOfDeath = 'voFec8nlKRX';

        // Only the identity/contacts — do NOT include HIV/ART fields here
        const motherAliveBasics = <String>[
          'd3HviODv676', // Mother's name
          'Zv8FOfjPZzm', // Middle name
          'FBdCMyESsdg', // Surname
          'or2YNqJqVqZ', // DOB
          'rP7oCRukLkq', // Phone
        ];

        // Default: hide both groups
        hiddenFields[motherCauseOfDeath] = true;
        for (final id in motherAliveBasics) {
          hiddenFields[id] = true;
        }
        // Also default-hide HIV/ART; they will be re-opened by the rule below
        hiddenFields['nO38lKlKHYi'] = true; // HIV status
        hiddenFields['PAv1sKQn2hO'] = true; // On ART
        hiddenFields['fa0BSFwqQGQ'] = true; // ART facility

        if (value == 'Yes') {
          // Show basics
          for (final id in motherAliveBasics) {
            hiddenFields.remove(id);
          }

          // Now decide HIV/ART visibility deterministically
          final motherHiv = (
              assignedFields['nO38lKlKHYi'] ?? dataObject['nO38lKlKHYi'] ?? ''
          ).toString().trim();

          if (motherIsCaregiver) {
            if (motherHiv.isEmpty || motherHiv == 'Unknown') {
              // keep HIV + ART hidden
            } else if (motherHiv == 'Negative') {
              // show HIV only; keep ART hidden
              hiddenFields.remove('nO38lKlKHYi');
            } else {
              // Positive -> show HIV and ART
              hiddenFields.remove('nO38lKlKHYi');
              hiddenFields.remove('PAv1sKQn2hO');
              hiddenFields.remove('fa0BSFwqQGQ');
            }
          } else {
            // Mother is NOT the registered caregiver → we must capture these
            hiddenFields.remove('nO38lKlKHYi');
            // Show ART only if HIV is Positive; otherwise keep hidden
            if (motherHiv == 'Positive') {
              hiddenFields.remove('PAv1sKQn2hO');
              hiddenFields.remove('fa0BSFwqQGQ');
            }
          }
        } else if (value == 'No') {
          // Show cause of death only
          hiddenFields.remove(motherCauseOfDeath);
        }
      }

      // else if (inputFieldId == 'R9e8v9r3lMM') {
      //   if (value != 'No') {
      //     hiddenFields['voFec8nlKRX'] = true;
      //   }else if(value == 'No'){
      //     //hiddenFields['voFec8nlKRX'] = false;
      //     hiddenFields['d3HviODv676'] = true;
      //     hiddenFields['Zv8FOfjPZzm'] = true;
      //     hiddenFields['FBdCMyESsdg'] = true;
      //     hiddenFields['or2YNqJqVqZ'] = true;
      //     hiddenFields['rP7oCRukLkq'] = true;
      //     hiddenFields['nO38lKlKHYi'] = true;
      //     hiddenFields['wKEQZfKU2jX'] = true;
      //     hiddenFields['PAv1sKQn2hO'] = true;
      //     hiddenFields['fa0BSFwqQGQ'] = true;
      //
      //
      //   }
      //   else if (value != 'Yes') {
      //     hiddenFields['d3HviODv676'] = true;
      //     hiddenFields['Zv8FOfjPZzm'] = true;
      //     hiddenFields['FBdCMyESsdg'] = true;
      //     hiddenFields['or2YNqJqVqZ'] = true;
      //     hiddenFields['rP7oCRukLkq'] = true;
      //     hiddenFields['voFec8nlKRX'] = true;
      //     hiddenFields['nO38lKlKHYi'] = true;
      //     hiddenFields['wKEQZfKU2jX'] = true;
      //     hiddenFields['PAv1sKQn2hO'] = true;
      //     hiddenFields['fa0BSFwqQGQ'] = true;
      //
      //
      //   }
      // }


    }
    for (String sectionId in hiddenSections.keys) {
      List<FormSection> allFormSections =
          FormUtil.getFlattenFormSections(formSections);
      List<String> hiddenSectionInputFieldIds = FormUtil.getFormFieldIds(
          allFormSections
              .where((formSection) => formSection.id == sectionId)
              .toList());
      for (String inputFieldId in hiddenSectionInputFieldIds) {
        hiddenFields[inputFieldId] = true;
      }
    }

    _guardParentArtVisibilityTyped(
      dataObject: dataObject,
      assignedFields: assignedFields,
      hiddenFields: hiddenFields,
      aliveField: 'R9e8v9r3lMM',   // mother alive
      hivField: 'nO38lKlKHYi',
      onArtField: 'PAv1sKQn2hO',
      artFacilityField: 'fa0BSFwqQGQ',
    );
    _guardParentArtVisibilityTyped(
      dataObject: dataObject,
      assignedFields: assignedFields,
      hiddenFields: hiddenFields,
      aliveField: 'cJl00w5DjIL',   // father alive
      hivField: 'tbpqNLJotOi',
      onArtField: 'xJfScNlfNS2',
      artFacilityField: 'IWFLOoEtisa',
    );


    assignPrimaryVulnerability(context, dataObject, shouldSetEnrollmentState);
    if (shouldSetEnrollmentState) {
      setAssignedValues(context, assignedFields);
      resetValuesForHiddenFields(context, hiddenFields.keys);
      resetValuesForHiddenSections(context, formSections);
      resetValuesForHiddenInputFieldOptions(context, formSections);
    }
    return shouldSetEnrollmentState
        ? {}
        : {
            "assignedFields": assignedFields,
            "hiddenFields": hiddenFields,
            "hiddenInputFieldOptions": hiddenInputFieldOptions,
            "hiddenSections": hiddenSections,
          };
  }

  static assignPrimaryVulnerability(
    BuildContext context,
    Map dataObject,
    bool shouldSetEnrollmentState,
  ) {
    const String defaultVulnerability = 'Sibling ';
    List<String> vulnerabilities = [
      'wmKqYZML8GA',
      'GMcljM7jbNG',
      'ZKMhrjWoXnD',
      'tHbPB5hrbOc',
      'ZGH70UbL2O1',
      'FYjxxvyugEt',
      'NqhUKijE4hB',

    ];
    List<String> primaryVulnerabilitiesOptions = [
      'Child living with HIV',
      'HIV exposed infants',
      'Child of PLHIV',
      'Adolescent Girl who is Pregnant',
      'Adolescent Girl who is a young mother',
      'Child of Adolescent Girl who is Breastfeeding',
      'Sibling for CALHIV',



    ];
    for (var vulnerabilityKey in vulnerabilities) {
      if ('${dataObject[vulnerabilityKey]}' == 'true') {
        var vulnerabilityIndex = vulnerabilities.indexOf(vulnerabilityKey);
        String value = vulnerabilityIndex >= 0
            ? primaryVulnerabilitiesOptions[
                vulnerabilities.indexOf(vulnerabilityKey)]
            : defaultVulnerability;
        if (shouldSetEnrollmentState) {
          assignInputFieldValue(context,
              OvcEnrollmentChildConstant.primaryVulnerabilityKey, value);
        } else {
          assignedFields[OvcEnrollmentChildConstant.primaryVulnerabilityKey] =
              value;
        }
        break;
      } else {
        continue;
      }
    }
    if (vulnerabilities.every((element) =>
        (dataObject[element] == false || dataObject[element] == null))) {
      if (shouldSetEnrollmentState) {
        assignInputFieldValue(
            context,
            OvcEnrollmentChildConstant.primaryVulnerabilityKey,
            defaultVulnerability);
      } else {
        assignedFields[OvcEnrollmentChildConstant.primaryVulnerabilityKey] =
            defaultVulnerability;
      }
    }
  }

  static void setAssignedValues(BuildContext context, Map assignedValues) {
    assignedFields.forEach((key, value) {
      assignInputFieldValue(context, key, value);
    });
  }

  static resetValuesForHiddenFields(BuildContext context, inputFieldIds) {
    for (String inputFieldId in inputFieldIds) {
      if (hiddenFields[inputFieldId]) {
        assignInputFieldValue(context, inputFieldId, null);
      }
    }
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setHiddenFields(hiddenFields);
  }

  static resetValuesForHiddenSections(
    BuildContext context,
    List<FormSection> formSections,
  ) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setHiddenSections(hiddenSections);
  }

  static resetValuesForHiddenInputFieldOptions(
    BuildContext context,
    List<FormSection> formSections,
  ) {
    Provider.of<EnrollmentFormState>(context, listen: false)
        .setHiddenInputFieldOptions(hiddenInputFieldOptions);
  }

  static assignInputFieldValue(
    BuildContext context,
    String inputFieldId,
    String? value,
  ) {
    Provider.of<EnrollmentFormState>(context, listen: false).setFormFieldState(
      inputFieldId,
      value,
      isChangesBasedOnSkipLogic: true,
    );
  }

}
