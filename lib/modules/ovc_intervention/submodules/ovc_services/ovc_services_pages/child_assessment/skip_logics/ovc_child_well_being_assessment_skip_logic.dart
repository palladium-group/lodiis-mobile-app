import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/enrollment_service_form_state/service_form_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:provider/provider.dart';

class OvcChildWellBeingAssessmentSkipLogic {
  static Map hiddenFields = {};
  static Map hiddenSections = {};

  static Future evaluateSkipLogics(BuildContext context,
      List<FormSection> formSections, Map dataObject, String? hivStatus) async {
    hiddenFields.clear();
    hiddenSections.clear();

    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }
    inputFieldIds = inputFieldIds.toSet().toList();
    void hideForChild() {
      //Domain Schooled
      hiddenFields['Wstcittf'] = true;
      hiddenFields['NAqMo0LwqZR'] = true;
      hiddenFields['HdtChyf'] = true;
      hiddenFields['wOlSzC2ovZN'] = true;
      hiddenFields['DaVKi2U248S'] = true;
      hiddenFields['emR9ocfi1Vm'] = true;
      hiddenFields['xYdWjIv5eup'] = true;
      hiddenFields['M3AaNTqC9d6'] = true;
      hiddenFields['mozNkqqfYRp'] = true;
      hiddenFields['YKuTfp8LIRr'] = true;
      hiddenFields['Dtcmmttdfar'] = true;
      hiddenFields['Ey6WeeJVCI7'] = true;
      hiddenFields['vmvnozO37i7'] = true;
      hiddenFields['xbAukRUBixJ'] = true;
      hiddenFields['SGCjKsX1Mzl'] = true;
      hiddenFields['YKuTfp8LIRr_checkboxes'] = true;
      hiddenFields['Ey6WeeJVCI7'] = true;

      //Domain Stable
      hiddenFields['aaERjQ9jSZn'] = true;
      hiddenFields['dTiDozleQuO'] = true;
      hiddenFields['dTiDozleQuO_checkbox'] = true;
      //Domain Health
      hiddenFields['H84JX4fQWsK'] = true;
      hiddenFields['Vc7Q23oTNhu'] = true;
      hiddenFields['lxF2SNfIGa0'] = true;
      hiddenFields['lz56QGytZkD'] = true;
      hiddenFields['TQGFUJ7MTPu'] = true;
      hiddenFields['ToOqcUP9338'] = true;
      hiddenFields['qI9a8II1g54'] = true;
      hiddenFields['puLHlflNeg6'] = true;
      hiddenFields['ef1ixon3YBh'] = true;
      hiddenFields['eSJhbqT1NQb'] = true;
      hiddenFields['sHUjPZTqpy2'] = true;
      hiddenFields['VFLlpMdPCTX'] = true;
      hiddenFields['VFLlpMdPCTX_checkboxes'] = true;
      hiddenFields['iZGQ4iWkWNu'] = true;
      hiddenFields['f2GIuwu1LGh'] = true;
      hiddenFields['DrPdwo3pKfN'] = true;
      hiddenFields['EYb2XmgHt58'] = true;
      hiddenFields['kcG670LJt3J'] = true;
      hiddenFields['gAzb8e8cLga'] = true;
      hiddenFields['oJVaLuSykXO'] = true;
      hiddenFields['RAlqa0C6PN7'] = true;

      //Domain Safe
      hiddenFields['jxOMACHmXXO'] = true;
      hiddenFields['p82MlDNDGxs'] = true;
      hiddenFields['zjjAVMVuvxe'] = true;
      hiddenFields['LjhWZuKCIJu'] = true;
      hiddenFields['kslj60leTJf'] = true;
      hiddenFields['fe0pgVexVbx'] = true;
      hiddenFields['HqNP6ovZw3p'] = true;
      hiddenFields['iUO02DiUftg'] = true;
      hiddenFields['RykOGTu3wcd'] = true;
      hiddenFields['iQcx8GPINN0'] = true;
      hiddenFields['XG1a90T7iBF'] = true;
      hiddenFields['hidZMdXFxvR'] = true;
      hiddenFields['D1ebTZQurSL'] = true;
      hiddenFields['M0lo7wANrwN'] = true;
      hiddenFields['wP7nZkrJIlp'] = true;
    }

// hideMalnutrition
    void hideMalnutritionQuestions() {
      hiddenFields['OBugEkynJG0'] = true;
      hiddenFields['OBugEkynJG0_checkbox'] = true;
      hiddenFields['xQjn7WKtJvm'] = true;
      hiddenFields['dTiDozleQuO'] = true;
      hiddenFields['dTiDozleQuO_checkbox'] = true;
    }

    void hideForCaregiver() {
      hiddenFields['lt88RMPaBPg'] = true;
      hiddenFields['TWvKsmKyCSc'] = true;
      hiddenFields['cv8RKCPOOAo'] = true;
      hiddenFields['BvEsLzWsL3Z'] = true;
      hiddenFields['KlbW2l1L1NC'] = true;
      hiddenFields['tnaSD0CNrHH'] = true;
      hiddenFields['ot2CtK0hAHo'] = true;
      hiddenFields['VMP6xJWkWHK'] = true;
      hiddenFields['mtZfZIAkVjt'] = true;
      //Domain Stable
      hiddenFields['MEmFZrOhvb3'] = true;
      //Domain Health
      hiddenFields['AcAWUuDae0A'] = true;
      hiddenFields['ETI9FukQuNo'] = true;
      hiddenFields['YZ9ORZBKzHk'] = true;
      hiddenFields['RC28ZyOhzUQ'] = true;
      hiddenFields['RC28ZyOhzUQ_checkbox'] = true;
      hiddenFields['YQVQRnN30O6'] = true;
      hiddenFields['uMwExnG6Flk'] = true;
      hiddenFields['wO2o2ZqG65D'] = true;
      hiddenFields['J4ozQS4koE8'] = true;
      hiddenFields['o2XWRHW5zwb'] = true;
      hiddenFields['c5TMWtM4VVJ'] = true;
      hiddenFields['bgJkdPrTnbg'] = true;
      hiddenFields['Z51O61hlZMR'] = true;
      hiddenFields['kqQ3MMTTO2t'] = true;
      hiddenFields['pU5ywj3cjSA'] = true;
      hiddenFields['HXk5d3kxy37'] = true;
      hiddenFields['ndK4JCMORL0'] = true;
      hiddenFields['wv3YAGLZlev'] = true;
      hiddenFields['Tr5lrn4ctTN'] = true;
      hiddenFields['YTa10rE1vtd'] = true;
      hiddenFields['wi6Iq4yVdXV'] = true;
      hiddenFields['gPSf6k0BcWE'] = true;
      //Domain Safe
      hiddenFields['gdooctJzx2o'] = true;
      hiddenFields['t1VRnFuBb7I'] = true;
      hiddenFields['t1VRnFuBb7I_checkbox'] = true;
      hiddenFields['nLoEbs7cRIu'] = true;
      hiddenFields['LU0OIdYmV7K'] = true;
      hiddenFields['ahAIJZ9IkCV'] = true;
      hiddenFields['MxioydJaOgX'] = true;
      hiddenFields['ebeAKSCVsYo'] = true;
      hiddenFields['XXHMvERCGLn'] = true;
      hiddenFields['MlcK6DAGoCx'] = true;
      hiddenFields['W91GgtMqWnl'] = true;
      hiddenFields['sM8amXv7Nck'] = true;
    }

    int age = int.parse(dataObject['age']);
    if (age >= 14) {
      hideForChild();
    } else {
      hideForCaregiver();
    }
    if (age > 5) {
      hideMalnutritionQuestions();
      hiddenFields['r0vhM9GCkxp'] = true;
    } else if (age < 2) {
      hiddenSections['domainschooltsasekolo'] = true;
    }

    for (String inputFieldId in inputFieldIds) {
      String value = '${dataObject[inputFieldId]}';
      bool isFieldHidden = hiddenFields[inputFieldId] ?? false;

      if (inputFieldId == 'puLHlflNeg6') {
        if (hivStatus != null) {
          dataObject[inputFieldId] = 'true';
          hiddenFields['ef1ixon3YBh'] = true;
        } else if (hivStatus == null) {
          dataObject[inputFieldId] = 'false';
        }
      }

      if (inputFieldId == 'sHUjPZTqpy2' && value != 'Yes') {
        hiddenFields['VFLlpMdPCTX'] = true;
        hiddenFields['VFLlpMdPCTX_checkboxes'] = true;
        hiddenFields['FeL9c9Grwlx'] = true;
        hiddenFields['rh90PSJE7fD'] = true;
        hiddenFields['CkbKlcJCkLE'] = true;
        hiddenFields['zcKvVCd6d0c'] = true;
        hiddenFields['sdQt641yVBS'] = true;
        hiddenFields['sbgsFW299ND'] = true;
        hiddenFields['PErwPNVDZl1'] = true;
        hiddenFields['aRrET00WEbz'] = true;
      }

      if (inputFieldId == '' && value != '') {}

      if (!isFieldHidden) {
        if (inputFieldId == 'vCSvOI0d9M4' && value != 'true') {
          hiddenFields['NAqMo0LwqZR'] = true;
        }

        if (inputFieldId == 'TH3xvl6NZhi' && value != 'true') {
          hiddenFields['wOlSzC2ovZN'] = true;
        }
        if (inputFieldId == 'DaVKi2U248S' && value != 'false') {
          hiddenFields['DaVKi2U248S_checkbox'] = true;
          hiddenFields['fcWZ0cctQlO'] = true;
          hiddenFields['nbLQCi1YrvU'] = true;
          hiddenFields['JMGxn39tjoh'] = true;
          hiddenFields['qPt9jvB5ACh'] = true;
          hiddenFields['giEyqjovyAp'] = true;
          hiddenFields['Q5MH7cmdlhT'] = true;
          hiddenFields['WIrF2dIAkqD'] = true;
          hiddenFields['kamr81y5WJs'] = true;
          hiddenFields['wZ6HnbTdfDg'] = true;
          hiddenFields['emR9ocfi1Vm'] = true;
        }
        if (inputFieldId == 'DaVKi2U248S' && value != 'true') {
          hiddenFields['xYdWjIv5eup'] = true;
          hiddenFields['IUdOAhmhqj1'] = true;
          hiddenFields['pczeYqyA3Bj'] = true;
          hiddenFields['TRuxsvRahqm'] = true;
        }
        if (inputFieldId == 'kamr81y5WJs' && value != 'true') {
          hiddenFields['wZ6HnbTdfDg'] = true;
        }
        if (inputFieldId == 'emR9ocfi1Vm' && value != 'true') {
          hiddenFields['cv8RKCPOOAo'] = true;
        }
        if (inputFieldId == 'OyloI2gUb2p' && value != 'true') {
          hiddenFields['Ey6WeeJVCI7'] = true;
        }

        //Logic change
        if (inputFieldId == 'mtZfZIAkVjt' &&
            (value == 'true' || value == 'null')) {
          hiddenFields['mtZfZIAkVjt_checkbox'] = true;
          hiddenFields['qK6pCo37tWW'] = true;
          hiddenFields['Tbga457Gs8B'] = true;
          hiddenFields['AYqiBBgPBsR'] = true;
          hiddenFields['I42XGV43sC7'] = true;
          hiddenFields['F8cC7TI5t9b'] = true;
          hiddenFields['MNYYB8orI36'] = true;
        }
        if (inputFieldId == 'F8cC7TI5t9b' && value != 'true') {
          hiddenFields['MNYYB8orI36'] = true;
        }
        if (inputFieldId == 'OBugEkynJG0' && value != 'true') {
          hiddenFields['OBugEkynJG0_checkbox'] = true;
          hiddenFields['UHMtTnEP9Yh'] = true;
          hiddenFields['JuHzVswoDKw'] = true;
          hiddenFields['G5EFtvf5qcF'] = true;
          hiddenFields['g8j8aNxz7lh'] = true;
          hiddenFields['W9bFXNhcWHN'] = true;
          hiddenFields['B7i1JLk1GIk'] = true;
          hiddenFields['SSUQsWk0JiA'] = true;
          hiddenFields['FmJ0mLOhMSd'] = true;
          hiddenFields['xQjn7WKtJvm'] = true;
        }
        if (inputFieldId == 'FmJ0mLOhMSd' && value != 'true') {
          hiddenFields['xQjn7WKtJvm'] = true;
        }
        if (inputFieldId == 'Vc7Q23oTNhu' && value != 'true') {
          hiddenFields['qI9a8II1g54'] = true;
          hiddenFields['ToOqcUP9338'] = true;
          hiddenFields['TQGFUJ7MTPu'] = true;
          hiddenFields['lxF2SNfIGa0'] = true;
          hiddenFields['lz56QGytZkD'] = true;
        }
        if (inputFieldId == 'TQGFUJ7MTPu' && value != 'true') {
          hiddenFields['lz56QGytZkD'] = true;
          hiddenFields['lxF2SNfIGa0'] = true;
          hiddenFields['YZ9ORZBKzHk'] = true;
        }
        if (inputFieldId == 'RC28ZyOhzUQ' && value != 'true') {
          hiddenFields['RC28ZyOhzUQ_checkbox'] = true;
          hiddenFields['rVAImAgvrYe'] = true;
          hiddenFields['br8TVOKf1ZI'] = true;
          hiddenFields['DExMWJ61fKp'] = true;
          hiddenFields['LJO2Ar9YytV'] = true;
          hiddenFields['e1KcALoo1ZJ'] = true;
          hiddenFields['YRWFyAhfhRP'] = true;
          hiddenFields['YQVQRnN30O6'] = true;
        }
        if (inputFieldId == 'YRWFyAhfhRP' && value != 'true') {
          hiddenFields['YQVQRnN30O6'] = true;
        }
        if (inputFieldId == 'uMwExnG6Flk' && value != 'true') {
          hiddenFields['wO2o2ZqG65D'] = true;
        }
        if (inputFieldId == 'ef1ixon3YBh' && value != 'true') {
          hiddenFields['J4ozQS4koE8'] = true;
        }
        if (inputFieldId == 'bgJkdPrTnbg' && value != 'Other') {
          hiddenFields['Z51O61hlZMR'] = true;
        }
        if (inputFieldId == 'Tr5lrn4ctTN' && value != 'Other') {
          hiddenFields['YTa10rE1vtd'] = true;
        }
        if (inputFieldId == 'f2GIuwu1LGh' && value != 'Other') {
          hiddenFields['DrPdwo3pKfN'] = true;
        }
        if (inputFieldId == 'PErwPNVDZl1' && value != 'Other') {
          hiddenFields['aRrET00WEbz'] = true;
        }
        if (inputFieldId == 'gAzb8e8cLga' && value != 'Other, specify') {
          hiddenFields['oJVaLuSykXO'] = true;
        }
        if (inputFieldId == 'zjjAVMVuvxe' && value != 'true') {
          hiddenFields['wP7nZkrJIlp'] = true;
          hiddenFields['M0lo7wANrwN'] = true;
          hiddenFields['jxOMACHmXXO'] = true;
        }
        if (inputFieldId == 'wP7nZkrJIlp' && value != 'Yes') {
          hiddenFields['jxOMACHmXXO'] = true;
        }
        if (inputFieldId == 'hidZMdXFxvR' && value != 'Other') {
          hiddenFields['p82MlDNDGxs'] = true;
        }
        if (inputFieldId == 'RykOGTu3wcd') {
          if (value != 'Yes') {
            hiddenFields['iUO02DiUftg'] = true;
          }
          if (value == 'No') {
            hiddenFields['HqNP6ovZw3p'] = true;
          }
        }
        if (inputFieldId == 'kslj60leTJf' && value != 'true') {
          hiddenFields['LjhWZuKCIJu'] = true;
        }
        if (inputFieldId == 't1VRnFuBb7I' && value != 'true') {
          hiddenFields['t1VRnFuBb7I_checkbox'] = true;
          hiddenFields['seiWBkesnnc'] = true;
          hiddenFields['pQ4cUirRxqK'] = true;
          hiddenFields['GI0cqcBMSUV'] = true;
          hiddenFields['MMOeHPgpVj5'] = true;
          hiddenFields['CmJLjd2HxD7'] = true;
          hiddenFields['nLoEbs7cRIu'] = true;
          hiddenFields['LU0OIdYmV7K'] = true;
        }
        if (inputFieldId == 'CmJLjd2HxD7' && value != 'true') {
          hiddenFields['nLoEbs7cRIu'] = true;
          hiddenFields['LU0OIdYmV7K'] = true;
        }
        if (inputFieldId == 'ebeAKSCVsYo' && value != 'false') {
          hiddenFields['XXHMvERCGLn'] = true;
        }

        //This section needs to be worked on when skip logic level 2 is in place
        if (inputFieldId == 'xYdWjIv5eup' && value != 'Primary') {
          hiddenFields['TRuxsvRahqm'] = true;
        }
        if (inputFieldId == 'xYdWjIv5eup' && value != 'Secondary') {
          hiddenFields['pczeYqyA3Bj'] = true;
        }
        if (inputFieldId == 'xYdWjIv5eup' && value != 'College') {
          hiddenFields['IUdOAhmhqj1'] = true;
        }

        if (inputFieldId == 'M3AaNTqC9d6' && value != 'Primary') {
          hiddenFields['xbAukRUBixJ'] = true;
        }
        if (inputFieldId == 'M3AaNTqC9d6' && value != 'Secondary/High level') {
          hiddenFields['SGCjKsX1Mzl'] = true;
        }
        if (inputFieldId == 'M3AaNTqC9d6' && value != 'College') {
          hiddenFields['dwJns2uXUcG'] = true;
        }

        if (inputFieldId == 'YKuTfp8LIRr' && value != 'true') {
          hiddenFields['YKuTfp8LIRr_checkboxes'] = true;
        }
        if (inputFieldId == 'vmvnozO37i7' && value != 'false') {
          hiddenFields['mtZfZIAkVjt_checkbox'] = true;
        }

        //================================================================

        //Domain Stable
        if (inputFieldId == 'aaERjQ9jSZn' && value != 'true') {
          hiddenFields['cGJa4gfVPQ7'] = true;
        }
        if (inputFieldId == 'MEmFZrOhvb3' && value != 'true') {
          hiddenFields['cGJa4gfVPQ7'] = true;
        }

        if (inputFieldId == 'dTiDozleQuO' && value != 'Yes') {
          hiddenFields['dTiDozleQuO_checkbox'] = true;
        }

        //Domain Health

        if (inputFieldId == 'puLHlflNeg6' &&
            dataObject[inputFieldId] == 'false') {
          hiddenFields['eSJhbqT1NQb'] = true;
        }

        if (inputFieldId == 'eSJhbqT1NQb' && hivStatus != null) {
          dataObject[inputFieldId] = hivStatus;
          hiddenFields['sHUjPZTqpy2'] = true;
        }

        if (inputFieldId == 'iZGQ4iWkWNu' && value != 'false') {
          hiddenFields['EYb2XmgHt58'] = true;
          hiddenFields['RAlqa0C6PN7'] = true;
        }
        if (inputFieldId == 'EYb2XmgHt58' && value != 'Other') {
          hiddenFields['RAlqa0C6PN7'] = true;
        }
        if (inputFieldId == 'iZGQ4iWkWNu' && value != 'true') {
          hiddenFields['DrPdwo3pKfN'] = true;
          hiddenFields['f2GIuwu1LGh'] = true;
        }
        if (inputFieldId == 'f2GIuwu1LGh' && value != 'Other') {
          hiddenFields['DrPdwo3pKfN'] = true;
        }
        if (inputFieldId == 'kcG670LJt3J' && value != 'true') {
          hiddenFields['gAzb8e8cLga'] = true;
        }

        //Domain Safe
        if (inputFieldId == 'HqNP6ovZw3p' && value != 'Yes') {
          hiddenFields['fe0pgVexVbx'] = true;
        }
        if (inputFieldId == 'kslj60leTJf' && value != 'true') {
          hiddenFields['LjhWZuKCIJu'] = true;
        }

        //Over 14
        if (inputFieldId == 'TWvKsmKyCSc' && value != 'false') {
          hiddenFields['DaVKi2U248S_checkbox'] = true;
          hiddenFields['fcWZ0cctQlO'] = true;
          hiddenFields['nbLQCi1YrvU'] = true;
          hiddenFields['JMGxn39tjoh'] = true;
          hiddenFields['qPt9jvB5ACh'] = true;
          hiddenFields['giEyqjovyAp'] = true;
          hiddenFields['Q5MH7cmdlhT'] = true;
          hiddenFields['WIrF2dIAkqD'] = true;
          hiddenFields['kamr81y5WJs'] = true;
          hiddenFields['wZ6HnbTdfDg'] = true;
          hiddenFields['emR9ocfi1Vm'] = true;
        }
        if (inputFieldId == 'TWvKsmKyCSc' && value != 'true') {
          hiddenFields['BvEsLzWsL3Z'] = true;
          hiddenFields['cv8RKCPOOAo'] = true;
          hiddenFields['IUdOAhmhqj1'] = true;
          hiddenFields['pczeYqyA3Bj'] = true;
          hiddenFields['TRuxsvRahqm'] = true;
          hiddenFields['KlbW2l1L1NC'] = true;
          hiddenFields['ot2CtK0hAHo'] = true;
          hiddenFields['dwJns2uXUcG'] = true;
          hiddenFields['tnaSD0CNrHH'] = true;
        }
        if (inputFieldId == 'BvEsLzWsL3Z' && value != 'Primary') {
          hiddenFields['TRuxsvRahqm'] = true;
        }
        if (inputFieldId == 'BvEsLzWsL3Z' && value != 'Secondary/High level') {
          hiddenFields['pczeYqyA3Bj'] = true;
        }
        if (inputFieldId == 'BvEsLzWsL3Z' && value != 'College') {
          hiddenFields['IUdOAhmhqj1'] = true;
          hiddenFields['dwJns2uXUcG'] = true;
        }
        if (inputFieldId == 'KlbW2l1L1NC' && value != 'Primary') {
          hiddenFields['TRuxsvRahqm'] = true;
        }
        if (inputFieldId == 'KlbW2l1L1NC' && value != 'Secondary/High level') {
          hiddenFields['pczeYqyA3Bj'] = true;
        }
        if (inputFieldId == 'KlbW2l1L1NC' && value != 'College') {
          hiddenFields['IUdOAhmhqj1'] = true;
        }
        if (inputFieldId == 'ot2CtK0hAHo' && value != 'true') {
          hiddenFields['VMP6xJWkWHK'] = true;
        }
        if (inputFieldId == 'o2XWRHW5zwb' && value != 'true') {
          hiddenFields['c5TMWtM4VVJ'] = true;
          hiddenFields['bgJkdPrTnbg'] = true;
          hiddenFields['Z51O61hlZMR'] = true;
          hiddenFields['kqQ3MMTTO2t'] = true;
        }
        if (inputFieldId == 'HXk5d3kxy37' && value != 'true') {
          hiddenFields['ndK4JCMORL0'] = true;
        }
        if (inputFieldId == 'pU5ywj3cjSA' && value != 'true') {
          hiddenFields['HXk5d3kxy37'] = true;
          hiddenFields['ndK4JCMORL0'] = true;
        }
        if (inputFieldId == 'c5TMWtM4VVJ' && value != 'Positive') {
          hiddenFields['pU5ywj3cjSA'] = true;
          hiddenFields['HXk5d3kxy37'] = true;
          hiddenFields['ndK4JCMORL0'] = true;
          hiddenFields['iZGQ4iWkWNu'] = true;
          hiddenFields['kcG670LJt3J'] = true;
        }
        if (inputFieldId == 'MlcK6DAGoCx' && value != 'true') {
          hiddenFields['W91GgtMqWnl'] = true;
        }
      }
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
    resetValuesForHiddenFields(context, hiddenFields.keys);
    resetValuesForHiddenSections(context, formSections);
  }

  static resetValuesForHiddenFields(BuildContext context, inputFieldIds) {
    for (String inputFieldId in inputFieldIds) {
      if (hiddenFields[inputFieldId]) {
        assignInputFieldValue(context, inputFieldId, null);
      }
    }
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenFields(hiddenFields);
  }

  static resetValuesForHiddenSections(
    BuildContext context,
    List<FormSection> formSections,
  ) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenSections(hiddenSections);
  }

  static assignInputFieldValue(
    BuildContext context,
    String inputFieldId,
    String? value,
  ) {
    Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
      inputFieldId,
      value,
      isChangesBasedOnSkipLogic: true,
    );
  }
}
