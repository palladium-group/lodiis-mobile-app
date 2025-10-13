
import 'package:flutter/widgets.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../../../app_state/enrollment_service_form_state/service_form_state.dart';

class OvcServiceMonitoringSkipLogicChild9Plus {
  Map hiddenFields = {};
  Map hiddenSections = {};
  static Map hiddenInputFieldOptions = {};
  final Map _childMapObject = {};

  /// Keep this exact signature — it matches how your container invokes it.
  Future<void> evaluateSkipLogics(
      BuildContext context,
      List<FormSection> formSections, Map dataObject, String? hivStatus, bool? isTested, bool? artStatus      ) async {
    hiddenFields.clear();
    hiddenSections.clear();
    hiddenInputFieldOptions.clear();

    // Initial hidden sections (same defaults you were using)
    hiddenSections['domainschooltsasekolo'] = true;
    hiddenSections['roleimpact'] = true;
    hiddenSections['domainstable'] = true;
    hiddenSections['domainsafe'] = true;

    // Build input list
    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }
    inputFieldIds = inputFieldIds.toSet().toList();

    int _safeParseAge(dynamic v) {
      final s = (v ?? '').toString();
      final m = RegExp(r'\d+').firstMatch(s);
      if (m == null) return -1;
      return int.tryParse(m.group(0)!) ?? -1;
    }

    final int age =
    _safeParseAge(dataObject['age']);

    // ---------- helpers ----------
    void hideChildDisclosure() {
      hiddenFields['hgQXrOd7iuH'] = true;
      hiddenFields['Qisosyae92z'] = true;
      hiddenFields['EYb2XmgHt58'] = true;
      hiddenFields['kcG670LJt3J'] = true;
      hiddenFields['cEPYE0hDKtH'] = true;
    }

    void hideAdolDisclosure() {
      hiddenFields['KFCBwn7ypws'] = true;
      hiddenFields['wi6Iq4yVdXV'] = true;
      hiddenFields['ToWhhydys'] = true;
      hiddenFields['BYZu8p33lzP'] = true;
    }

    void hideHivQuestions() {
      hiddenFields['Icgkv0xkUow'] = true;
      hiddenFields['ubin7MjQ5OI'] = true;
      hiddenFields['ToWhhydys'] = true;
      hiddenFields['YTa10rE1vtd'] = true;
      hiddenFields['aRNGDZcwWmS'] = true;
      hiddenFields['tYN12Es3707'] = true;
      hiddenFields['o1GBFscjs4y'] = true;
      hiddenFields['wi6Iq4yVdXV'] = true;
      hiddenFields['KFCBwn7ypws'] = true;
      hiddenFields['BYZu8p33lzP'] = true;
    }

    void hideForChild() {
      // Domain Schooled
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
      hiddenFields['GN85Cf2mOmw'] = true;
      hiddenFields['H84JX4fQWsK'] = true;

      // Domain Stable
      hiddenFields['aaERjQ9jSZn'] = true;
      hiddenFields['dTiDozleQuO'] = true;
      hiddenFields['dTiDozleQuO_checkbox'] = true;

      // Domain Health
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
      hiddenSections['tbsection_child'] = true;

      // Domain Safe
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

    void hideMalnutritionQuestions() {
      hiddenFields['r0vhM9GCkxp'] = true;
      hiddenFields['OBugEkynJG0'] = true;
      hiddenFields['JnCFOeouVIy'] = true;
      hiddenFields['lbr7YOB6HJ1'] = true;
      hiddenFields['ATWzSRHBmuF'] = true;
      hiddenFields['uINNVU0OeRP'] = true;
      hiddenFields['bMNyAIWumx1'] = true;
      hiddenFields['OUPk2e9DoMe'] = true;
      hiddenFields['eQM7VOlr5hG'] = true;
      hiddenFields['yVTsRM4eMHA'] = true;
      hiddenSections['childnutrition'] = true;
      hiddenFields['eDuHTPn7rhh'] = true;
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
      hiddenSections['tbsection_adolescent'] = true;

      // Domain Stable
      hiddenFields['MEmFZrOhvb3'] = true;

      // Domain Health
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

      // Domain Safe
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

    // ---------- top-level gates ----------


    if (hivStatus == 'Positive') {
      hiddenFields['Uv26fX0HQvO'] = true;
    }

    if (age > 5) {
      hideMalnutritionQuestions();
    } else if (age >= 0 && age < 2) {
      hiddenSections['domainschooltsasekolo'] = true;
    }

    // ---------- per-field rules (fixed identifiers; unchanged logic) ----------
    for (final inputFieldId in inputFieldIds) {
      final String value = '${dataObject[inputFieldId]}';
      final bool isFieldHidden = hiddenFields[inputFieldId] ?? false;
      if (inputFieldId =='BvNaiaoxc6w' && value != 'true') {
        hideHivQuestions();
        hiddenFields['vNeOE9abQBB'] = true;
        hiddenFields['Uv26fX0HQvO'] = true;
      }
      if(hivStatus == 'Positive'){
        dataObject['BvNaiaoxc6w'] = isTested;
        hiddenFields['EEclxMv9xXk'] = true;
      }
      if (inputFieldId == 'BvNaiaoxc6w' && value !='true') {
        hiddenFields['EEclxMv9xXk'] = true;
      }
      if (inputFieldId == 'vNeOE9abQBB' && hivStatus =='Positive') {

        dataObject[inputFieldId] = hivStatus;
      }
      if (inputFieldId == 'BYZu8p33lzP' && value != 'Yes') {
        hiddenFields['ToWhhydys'] = true;
        hiddenFields['wi6Iq4yVdXV'] = true;
      }

      if (inputFieldId == 'sLyfb45aLkl' && value != '1') {
        hiddenFields['aRNGDZcwWmS'] = true;
        hiddenFields['P52dMXyK4eA'] = true;
      }

      if (inputFieldId == 'tYN12Es3707' && value != 'true') {
        hiddenFields['o1GBFscjs4y'] = true;
      }


if(inputFieldId == 'Icgkv0xkUow' && value != 'true'){
  hiddenFields['ubin7MjQ5OI'] = true;
  hiddenFields['sLyfb45aLkl'] = true;
}

      if (inputFieldId == 'hgQXrOd7iuH' &&
          (value != 'true' || value.toLowerCase() == 'null')) {
        hiddenFields['Qisosyae92z'] = true;
      }
      if ((inputFieldId == 'hgQXrOd7iuH' &&
          (value != 'false' || value.toLowerCase() == 'null')) ||
          age < 6) {
        hiddenFields['EYb2XmgHt58'] = true;
      }

      if (inputFieldId == 'kcG670LJt3J' &&
          (value != 'true' || value.toLowerCase() == 'null')) {
        hiddenFields['cEPYE0hDKtH'] = true;
      }

      if (age <= 12) {
        hideAdolDisclosure();
      } else {
        hideChildDisclosure();
      }

     /* if (hivStatus != null) {
        if (hivStatus != 'Positive' || artStatus != true) {
          hiddenFields['sLyfb45aLkl'] = true;
          hiddenFields['aRNGDZcwWmS'] = true;
          hiddenFields['f2GIuwu1LGh'] = true;
          hiddenFields['EYb2XmgHt58'] = true;
          hiddenFields['gAzb8e8cLga'] = true;
          hiddenFields['tYN12Es3707'] = true;
        }
      }*/

      // HIV screening vs risk assessment sections by age
      if (age >= 12) {
        if (inputFieldId == 'Uv26fX0HQvO' ||
            inputFieldId == 'EEclxMv9xXk' ||
            inputFieldId == 'vNeOE9abQBB') {
          final testedDuration =
          (dataObject['Uv26fX0HQvO'] ?? '').toString().trim();
          final exposure =
          (dataObject['EEclxMv9xXk'] ?? '').toString().trim();
          final hivStatusmonitoring =
          (dataObject['vNeOE9abQBB'] ?? '').toString().trim();
          bool showScreening = false;
          if (hivStatusmonitoring == 'Negative') {
            if (testedDuration != 'Less than 3 months' &&
                testedDuration != '') {
              showScreening = true;
            } else if (testedDuration == 'Less than 3 months' &&
                exposure == 'true') {
              showScreening = true;
            }
          }
          if (!showScreening) {
            hiddenSections['hivscreening'] = true;
          } else {
            hiddenSections.remove('hivscreening');
          }
        }
      } else {
        hiddenSections['hivscreening'] = true;
      }

      if (inputFieldId == 'ImAyVEpwmNS' && value != 'false') {
        hiddenSections['tbsection_adolescent'] = true;
      }

      if (age < 12) {
        if (inputFieldId == 'Uv26fX0HQvO' ||
            inputFieldId == 'EEclxMv9xXk' ||
            inputFieldId == 'vNeOE9abQBB') {
          final testedDuration =
          (dataObject['Uv26fX0HQvO'] ?? '').toString().trim();
          final exposure =
          (dataObject['EEclxMv9xXk'] ?? '').toString().trim();
          final hivStatusmonitoring =
          (dataObject['vNeOE9abQBB'] ?? '').toString().trim();

          bool showScreening = false;
          if (hivStatusmonitoring == 'Negative') {
            if (testedDuration != 'Less than 3 months' &&
                testedDuration != '') {
              showScreening = true;
            } else if (testedDuration == 'Less than 3 months' &&
                exposure == 'true') {
              showScreening = true;
            }
          }

          if (!showScreening) {
            hiddenSections['hivriskassessment'] = true;
          } else {
            hiddenSections.remove('hivriskassessment');
          }
        }
      } else {
        hiddenSections['hivriskassessment'] = true;
      }
bool show = false;
      if (inputFieldId == 'Uv26fX0HQvO') {
        final testedDuration = value.toString().trim();
        if (!(testedDuration == 'Less than 3 months'))
        {
          show = true;

      }

      }
      if(inputFieldId == 'vNeOE9abQBB') {
        if(value != 'null' && value == 'Positive'){
        hiddenFields['EEclxMv9xXk'] = true; }// hide in all other cases
      }
      final vlResult = (dataObject['aRNGDZcwWmS'] ?? '').toString().trim();
      if (vlResult != 'High (above 1,000 copies/ml)') {
        hiddenFields['tYN12Es3707'] = true;
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

      // cascade hide chains
      if (inputFieldId == 'dE3bwyB7guF' && value != '1') {
        hiddenFields['w6xeZ47TwwI'] = true;
      }
      if (inputFieldId == 'NdvnM08tekD' && value != '1') {
        hiddenFields['sVpDAdtsGR6'] = true;
      }
      if (inputFieldId == 'eAVGC2zqUjP' && value != '1') {
        hiddenFields['ir5Pzw7MyIT'] = true;
      }
      if (inputFieldId == 'ehtYoYKxATO' && value != '1') {
        hiddenFields['crEW7U1Tbqg'] = true;
      }
      if (inputFieldId == 'z9StVriYu0Q' && value != '1') {
        hiddenFields['kn1dKAwP5wD'] = true;
      }
      if (inputFieldId == 'HQdMUzgaIXr' && value != '1') {
        hiddenFields['mH9DgJoa0nT'] = true;
      }

      if (inputFieldId == 'Js9auywpL0O' && value != 'true') {
        hiddenFields['SQUodtvxYLs'] = true;
      }
      if (inputFieldId == 'WYUkGeSWaZY' && value != 'true') {
        hiddenFields['dE3bwyB7guF'] = true;
      }
      if (inputFieldId == 'KA3l4V5NDWu' && value != 'true') {
        hiddenFields['NdvnM08tekD'] = true;
      }
      if (inputFieldId == 'NpxDYjUFlKS' && value != 'true') {
        hiddenFields['eAVGC2zqUjP'] = true;
      }
      if (inputFieldId == 'sftyaTdwBKz' && value != 'true') {
        hiddenFields['ehtYoYKxATO'] = true;
      }
      if (inputFieldId == 'bEXtDfYHP4B' && value != 'true') {
        hiddenFields['z9StVriYu0Q'] = true;
      }
      if (inputFieldId == 'gcW6652C8Bt' && value != 'true') {
        hiddenFields['bmJjZctbkhX'] = true;
      }
      if (inputFieldId == 'bmJjZctbkhX' &&
          (value.isEmpty || value.toLowerCase() == 'null')) {
        hiddenFields['HQdMUzgaIXr'] = true;
      }

      // only when not already hidden
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

        if (inputFieldId == 'ubin7MjQ5OI' &&
            (value == 'less than six months' ||
                value.toLowerCase() == 'null')) {
          hiddenFields['sLyfb45aLkl'] = true;
          hiddenFields['aRNGDZcwWmS'] = true;
        }

        // Logic change group
        if (inputFieldId == 'mtZfZIAkVjt' &&
            (value == 'true' || value.toLowerCase() == 'null')) {
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
        if (inputFieldId == 'EDgB0kYWS3v' && value != 'true') {
          hiddenFields['ut8LqpHyZnR_checkbox'] = true;
          hiddenFields['ir5Pzw7MyIT'] = true;
          hiddenFields['YQVQRnN30O6'] = true;
          hiddenFields['wO2o2ZqG65D'] = true;
          hiddenFields['J4ozQS4koE8'] = true;
          hiddenFields['HQdMUzgaIXr'] = true;
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

        // Education breakdowns
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
        if (inputFieldId == 'M3AaNTqC9d6' &&
            value != 'Secondary/High level') {
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

        // Domain Stable mirrors
        if (inputFieldId == 'aaERjQ9jSZn' && value != 'true') {
          hiddenFields['cGJa4gfVPQ7'] = true;
        }
        if (inputFieldId == 'MEmFZrOhvb3' && value != 'true') {
          hiddenFields['cGJa4gfVPQ7'] = true;
        }
        if (inputFieldId == 'dTiDozleQuO' && value != 'Yes') {
          hiddenFields['dTiDozleQuO_checkbox'] = true;
        }

        // Domain Health
        if (inputFieldId == 'puLHlflNeg6' &&
            dataObject[inputFieldId] == 'false') {
          hiddenFields['eSJhbqT1NQb'] = true;
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

        // Domain Safe
        if (inputFieldId == 'HqNP6ovZw3p' && value != 'Yes') {
          hiddenFields['fe0pgVexVbx'] = true;
        }
        if (inputFieldId == 'kslj60leTJf' && value != 'true') {
          hiddenFields['LjhWZuKCIJu'] = true;
        }

        // Over 14 group (kept intact)
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
        if (inputFieldId == 'BvEsLzWsL3Z' &&
            value != 'Secondary/High level') {
          hiddenFields['pczeYqyA3Bj'] = true;
        }
        if (inputFieldId == 'BvEsLzWsL3Z' && value != 'College') {
          hiddenFields['IUdOAhmhqj1'] = true;
          hiddenFields['dwJns2uXUcG'] = true;
        }
        if (inputFieldId == 'KlbW2l1L1NC' && value != 'Primary') {
          hiddenFields['TRuxsvRahqm'] = true;
        }
        if (inputFieldId == 'KlbW2l1L1NC' &&
            value != 'Secondary/High level') {
          hiddenFields['pczeYqyA3Bj'] = true;
        }
        if (inputFieldId == 'KlbW2l1L1NC' && value != 'College') {
          hiddenFields['IUdOAhmhqj1'] = true;
        }
        if (inputFieldId == 'ot2CtK0hAHo' && value != 'true') {
          hiddenFields['VMP6xJWkWHK'] = true;
        }

        if (inputFieldId == 'HXk5d3kxy37' && value != 'true') {
          hiddenFields['ndK4JCMORL0'] = true;
        }
        if (inputFieldId == 'pU5ywj3cjSA' && value != 'true') {
          hiddenFields['HXk5d3kxy37'] = true;
          hiddenFields['ndK4JCMORL0'] = true;
        }

        if (inputFieldId == 'vNeOE9abQBB' && hivStatus != null) {
          if (hivStatus != 'Positive') {
            hiddenFields['Icgkv0xkUow'] = true;
            hiddenFields['wv3YAGLZlev'] = true;
            hiddenFields['YTa10rE1vtd'] = true;
            hiddenFields['wi6Iq4yVdXV'] = true;
            hiddenFields['KFCBwn7ypws'] = true;
          }
        }
        if (artStatus != true) {
          hiddenFields['wv3YAGLZlev'] = true;
        }

        if (inputFieldId == 'MlcK6DAGoCx' && value != 'true') {
          hiddenFields['W91GgtMqWnl'] = true;
        }
      }
    }

    // Hide all inputs within any hidden sections
    for (String sectionId in hiddenSections.keys) {
      final all = FormUtil.getFlattenFormSections(formSections);
      final ids =
      FormUtil.getFormFieldIds(all.where((s) => s.id == sectionId).toList());
      for (final fid in ids) {
        hiddenFields[fid] = true;
      }
    }

    _resetValuesForHiddenFields(context as BuildContext, hiddenFields.keys);
    _resetValuesForHiddenSections(context as BuildContext, formSections);
  }

  void _resetValuesForHiddenFields(BuildContext context, Iterable inputFieldIds) {
    for (String inputFieldId in inputFieldIds) {
      if (hiddenFields[inputFieldId] == true) {
        _assignInputFieldValue(context, inputFieldId, null);
      }
    }
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenFields(hiddenFields);
  }

  void _resetValuesForHiddenSections(
      BuildContext context,
      List<FormSection> formSections,
      ) {
    Provider.of<ServiceFormState>(context, listen: false)
        .setHiddenSections(hiddenSections);
  }

  void _assignInputFieldValue(
      BuildContext context,
      String inputFieldId,
      String? value,
      ) {
    _childMapObject[inputFieldId] = value;
    Provider.of<ServiceFormState>(context, listen: false).setFormFieldState(
      inputFieldId,
      value,
      isChangesBasedOnSkipLogic: true,
    );
  }
}
