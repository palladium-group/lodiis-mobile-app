import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/current_user.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';
import 'package:provider/provider.dart';

mixin OvcCasePlanServiceProvisionSkipLogic {
  Map hiddenFields = {};
  Map hiddenSections = {};
  Map childMapObject = {};

  Future evaluateSkipLogics(
    BuildContext context,
    List<FormSection> formSections,
    Map dataObject,
  ) async {
    hiddenFields.clear();
    hiddenSections.clear();
    CurrentUser? currentUser = Provider.of<CurrentUserState>(context, listen: false).currentUser;
    String implementingPartner = currentUser!.implementingPartner ?? "";

    List<String> inputFieldIds = FormUtil.getFormFieldIds(formSections);
    for (var key in dataObject.keys) {
      inputFieldIds.add('$key');
    }
    inputFieldIds = inputFieldIds.toSet().toList();

    for (String inputFieldId in inputFieldIds) {
      hiddenFields[inputFieldId] = !['eventDate', 'location'].contains(inputFieldId);
    }

    //TOODO add additional services
    dataObject.forEach((key, value) {
      if (key == 'pbcXNnAuzfh' && value == 'true') {
        hiddenFields['RIpmBgYc0ZN'] = hideServicesByImplementingPartner(
          "RIpmBgYc0ZN",
          implementingPartner,
        );
        var inputValue = '${dataObject['RIpmBgYc0ZN']}';
        if (inputValue == 'true') {
          hiddenFields['uVmlqLmHYpD'] = false;
          hiddenFields['QpE5qR1cQ6T'] = false;
        }
      } else if (key == 'ylSjcj6cv42' && value == 'true') {
        hiddenFields['YFgrURiwirq'] = hideServicesByImplementingPartner(
          "YFgrURiwirq",
          implementingPartner,
        );
        var inputValue = '${dataObject['YFgrURiwirq']}';
        if (inputValue == 'true') {
          hiddenFields['LtiZFxXw0Wc'] = false;
          hiddenFields['i9icxSZ8HCf'] = false;
        }
      } else if (key == 'XoSPWmpWXCy' && value == 'true') {
        hiddenFields['JnqldNamliR'] = hideServicesByImplementingPartner(
          "JnqldNamliR",
          implementingPartner,
        );

        var inputValue = '${dataObject['JnqldNamliR']}';
        if (inputValue == 'true') {
          hiddenFields['KDSYFiIefGN'] = false;
          hiddenFields['CNnzifTDF5a'] = false;
          hiddenFields['sxlVgySosg3'] = false;
        }
      } else if (key == 'AxtahhoHcXV' && value == 'true') {
        hiddenFields['eqhzeRBMftZ'] = hideServicesByImplementingPartner(
          "eqhzeRBMftZ",
          implementingPartner,
        );
        var inputValue = '${dataObject['eqhzeRBMftZ']}';
        if (inputValue == 'true') {
          hiddenFields['F8x8QAoFQBO'] = false;
          hiddenFields['AStxMCkJhi5'] = false;
        }
      } else if (key == 'd2vXxEPeCq7' && value == 'true') {
        hiddenFields['ESIjwQ9S6Ic'] = hideServicesByImplementingPartner(
          "ESIjwQ9S6Ic",
          implementingPartner,
        );
        var inputValue = '${dataObject['ESIjwQ9S6Ic']}';
        if (inputValue == 'true') {
          hiddenFields['EYv3aMwJOUN'] = false;
          hiddenFields['GISFLEttRtU'] = false;
        }
      } else if (key == 'dTFLFtUUeEK' && value == 'true') {
        hiddenFields['r8wPQAog7PJ'] = hideServicesByImplementingPartner(
          "r8wPQAog7PJ",
          implementingPartner,
        );
        var inputValue = '${dataObject['r8wPQAog7PJ']}';
        if (inputValue == 'true') {
          hiddenFields['EgbO5h9cs5D'] = false;
          hiddenFields['itTgPQ0OrMU'] = false;
        }
      } else if (key == 'Hvq9oisH7Gt' && value == 'true') {
        hiddenFields['gV77yUM8NK8'] = hideServicesByImplementingPartner(
          "gV77yUM8NK8",
          implementingPartner,
        );
        var inputValue = '${dataObject['gV77yUM8NK8']}';
        if (inputValue == 'true') {
          hiddenFields['aqJBZDBzh4m'] = false;
          hiddenFields['JFlnkaXlXm5'] = false;
        }
      } else if (key == 'qTf8VSoojJ2' && value == 'true') {
        hiddenFields['qL9c5r7c6kK'] = hideServicesByImplementingPartner(
          "qL9c5r7c6kK",
          implementingPartner,
        );
        var inputValue = '${dataObject['qL9c5r7c6kK']}';
        if (inputValue == 'true') {
          hiddenFields['pUphS6E1Gu5'] = false;
          hiddenFields['SODPuEmHEGV'] = false;
        }
      } else if (key == 'DQxqyncQtwm' && value == 'true') {
        hiddenFields['FRWCmEerPic'] = hideServicesByImplementingPartner(
          "FRWCmEerPic",
          implementingPartner,
        );
        var inputValue = '${dataObject['FRWCmEerPic']}';
        if (inputValue == 'true') {
          hiddenFields['lQYnoeqfKpe'] = false;
          hiddenFields['w4EYZpbtUV8'] = false;
          hiddenFields['cBCJAB8Ogxd'] = false;
        }
      } else if (key == 'e6NV2ZAzFEh' && value == 'true') {
        hiddenFields['xTO562B5g53'] = hideServicesByImplementingPartner(
          "xTO562B5g53",
          implementingPartner,
        );
        var inputValue = '${dataObject['xTO562B5g53']}';
        if (inputValue == 'true') {
          hiddenFields['uOMr56xoKDh'] = false;
          hiddenFields['hMdC0CMKSGn'] = false;
          hiddenFields['SzDHpqzsiLw'] = false;
        }
      } else if (key == 'kvF996ugmMl' && value == 'true') {
        hiddenFields['lpTVK3t1Ahk'] = hideServicesByImplementingPartner(
          "lpTVK3t1Ahk",
          implementingPartner,
        );
        var inputValue = '${dataObject['lpTVK3t1Ahk']}';
        if (inputValue == 'true') {
          hiddenFields['j1yzHzO0w6w'] = false;
          hiddenFields['QnfPxpJvb1D'] = false;
          hiddenFields['KvHf0rBfa1L'] = false;
        }
      } else if (key == 'iiJpQsEE4qx' && value == 'true') {
        hiddenFields['kcoDiGNXWpA'] = hideServicesByImplementingPartner(
          "kcoDiGNXWpA",
          implementingPartner,
        );
        var inputValue = '${dataObject['kcoDiGNXWpA']}';
        if (inputValue == 'true') {
          hiddenFields['qwmtkJDotBk'] = false;
          hiddenFields['giA7cceTW8w'] = false;
        }
      } else if (key == 'ithLHgsAoxs' && value == 'true') {
        hiddenFields['fgDPoYtifQI'] = hideServicesByImplementingPartner(
          "fgDPoYtifQI",
          implementingPartner,
        );
        var inputValue = '${dataObject['fgDPoYtifQI']}';
        if (inputValue == 'true') {
          hiddenFields['lbCCs00yuGQ'] = false;
          hiddenFields['TNmg7uRUWgC'] = false;
        }
      } else if (key == 'JqGGsDlZh8T' && value == 'true') {
        hiddenFields['cbqS6IoSbwI'] = hideServicesByImplementingPartner(
          "cbqS6IoSbwI",
          implementingPartner,
        );
        var inputValue = '${dataObject['cbqS6IoSbwI']}';
        if (inputValue == 'true') {
          hiddenFields['zKkaaSt1c8V'] = false;
          hiddenFields['KpUgwivl5Cr'] = false;
        }
      } else if (key == 'WrjNxZBVHCL' && value == 'true') {
        hiddenFields['lEkrLOFmLrH'] = hideServicesByImplementingPartner(
          "lEkrLOFmLrH",
          implementingPartner,
        );
        var inputValue = '${dataObject['lEkrLOFmLrH']}';
        if (inputValue == 'true') {
          hiddenFields['F8ALMOcc6C1'] = false;
          hiddenFields['p77CBdxxtHI'] = false;
        }
      } else if (key == 'PoxYSqq8Hgz' && value == 'true') {
        hiddenFields['gwwUOs6yt6C'] = hideServicesByImplementingPartner(
          "gwwUOs6yt6C",
          implementingPartner,
        );
        var inputValue = '${dataObject['gwwUOs6yt6C']}';
        if (inputValue == 'true') {
          hiddenFields['w2HlBCfHbZR'] = false;
          hiddenFields['aG42nUguLLW'] = false;
          hiddenFields['n30r7v0ti1s'] = false;
        }
      } else if (key == 'aPmPhwm8Zln' && value == 'true') {
        hiddenFields['rMtSykWZ4HB'] = hideServicesByImplementingPartner(
          "rMtSykWZ4HB",
          implementingPartner,
        );
        var inputValue = '${dataObject['rMtSykWZ4HB']}';
        if (inputValue == 'true') {
          hiddenFields['qwnfgBG2web'] = false;
          hiddenFields['OMhFxj6SYhM'] = false;
          hiddenFields['YPImSLRMLWH'] = false;
        }
      } else if (key == 'Vd8dV7OweWB' && value == 'true') {
        hiddenFields['cuy4Ai7mBbA'] = hideServicesByImplementingPartner(
          "cuy4Ai7mBbA",
          implementingPartner,
        );
        var inputValue = '${dataObject['cuy4Ai7mBbA']}';
        if (inputValue == 'true') {
          hiddenFields['C5bhgqcq6Qn'] = false;
          hiddenFields['h10Iktl4KKR'] = false;
          hiddenFields['sONWFapy6yk'] = false;
        }
      } else if (key == 'Ccp4Odlh3BE' && value == 'true') {
        hiddenFields['ysDSdiL7wNx'] = hideServicesByImplementingPartner(
          "ysDSdiL7wNx",
          implementingPartner,
        );
        var inputValue = '${dataObject['ysDSdiL7wNx']}';
        if (inputValue == 'true') {
          hiddenFields['pBVmFpsSGN7'] = false;
          hiddenFields['XUoqvbk0uVH'] = false;
          hiddenFields['LkQxvdt6YCw'] = false;
        }
      } else if (key == 'AaqeRcyjbyS' && value == 'true') {
        hiddenFields['QDFZ03HbjGj'] = hideServicesByImplementingPartner(
          "QDFZ03HbjGj",
          implementingPartner,
        );
        var inputValue = '${dataObject['QDFZ03HbjGj']}';
        if (inputValue == 'true') {
          hiddenFields['Dw1xLXILErU'] = false;
          hiddenFields['KWk8waoLO7N'] = false;
          hiddenFields['P4PMMDgWCSA'] = false;
        }
      } else if (key == 'yf6KmY3Rm5I' && value == 'true') {
        hiddenFields['UZJ9vqIabAY'] = hideServicesByImplementingPartner(
          "UZJ9vqIabAY",
          implementingPartner,
        );
        var inputValue = '${dataObject['UZJ9vqIabAY']}';
        if (inputValue == 'true') {
          hiddenFields['pGDK3Y7tN2B'] = false;
          hiddenFields['U8h0daQzXXk'] = false;
          hiddenFields['Gs4XVviJB3r'] = false;
        }
      } else if (key == 'WdZ3PnW5yV6' && value == 'true') {
        hiddenFields['gfKsz88uxtg'] = hideServicesByImplementingPartner(
          "gfKsz88uxtg",
          implementingPartner,
        );
        var inputValue = '${dataObject['gfKsz88uxtg']}';
        if (inputValue == 'true') {
          hiddenFields['P06od0qmlSR'] = false;
          hiddenFields['iz4CvIFovsF'] = false;
          hiddenFields['NwtohlveKHW'] = false;
        }
      } else if (key == 'hS7aONLz2cq' && value == 'true') {
        hiddenFields['aGChpBlIzcd'] = hideServicesByImplementingPartner(
          "aGChpBlIzcd",
          implementingPartner,
        );
        var inputValue = '${dataObject['aGChpBlIzcd']}';
        if (inputValue == 'true') {
          hiddenFields['AXLxNo9pz8c'] = false;
          hiddenFields['cb773khL7XB'] = false;
          hiddenFields['RTEBrgDTe02'] = false;
        }
      } else if (key == 'TQSMaZgfZPO' && value == 'true') {
        hiddenFields['EYhFIkTpUS3'] = hideServicesByImplementingPartner(
          "EYhFIkTpUS3",
          implementingPartner,
        );
        var inputValue = '${dataObject['EYhFIkTpUS3']}';
        if (inputValue == 'true') {
          hiddenFields['rM13n9K4vE7'] = false;
          hiddenFields['VlReEXXH1WN'] = false;
          hiddenFields['uVd1sxrd6C7'] = false;
        }
      } else if (key == 'SN2kJN3jAG9' && value == 'true') {
        hiddenFields['IiKUlAeSIE3'] = hideServicesByImplementingPartner(
          "IiKUlAeSIE3",
          implementingPartner,
        );
        var inputValue = '${dataObject['IiKUlAeSIE3']}';
        if (inputValue == 'true') {
          hiddenFields['rUCb6Afcz9U'] = false;
          hiddenFields['sD0zbIksKTY'] = false;
          hiddenFields['p8Ha7w4plCe'] = false;
        }
      } else if (key == 'X47zxNAqMv0' && value == 'true') {
        hiddenFields['hg2bpp1HqwU'] = hideServicesByImplementingPartner(
          "hg2bpp1HqwU",
          implementingPartner,
        );
        var inputValue = '${dataObject['hg2bpp1HqwU']}';
        if (inputValue == 'true') {
          hiddenFields['wB2jXLTYtDb'] = false;
          hiddenFields['Riyr0nniCVo'] = false;
          hiddenFields['cuLeuQsq7ZG'] = false;
        }
      } else if (key == 'cx4xBY4jZXM' && value == 'true') {
        hiddenFields['HzI5X2yHef6'] = hideServicesByImplementingPartner(
          "HzI5X2yHef6",
          implementingPartner,
        );
        var inputValue = '${dataObject['HzI5X2yHef6']}';
        if (inputValue == 'true') {
          hiddenFields['GyG2HcLsVka'] = false;
          hiddenFields['y8ToqnbVz1o'] = false;
          hiddenFields['uU4TvD2O1uL'] = false;
        }
      } else if (key == 'yJQi4cbzeBF' && value == 'true') {
        hiddenFields['BYu8pI5kGXF'] = hideServicesByImplementingPartner(
          "BYu8pI5kGXF",
          implementingPartner,
        );
        var inputValue = '${dataObject['BYu8pI5kGXF']}';
        if (inputValue == 'true') {
          hiddenFields['u8r8p0a3JqU'] = false;
          hiddenFields['W5lbgijaXA6'] = false;
        }
      } else if (key == 'x4yAqv4z2Xv' && value == 'true') {
        hiddenFields['UKczyQWCB0L'] = hideServicesByImplementingPartner(
          "UKczyQWCB0L",
          implementingPartner,
        );
        var inputValue = '${dataObject['UKczyQWCB0L']}';
        if (inputValue == 'true') {
          hiddenFields['jsEr16lnber'] = false;
          hiddenFields['wZLjymsKsuj'] = false;
        }
      } else if (key == 'AM9oJCOHM7f' && value == 'true') {
        hiddenFields['KkqMjxjAR7g'] = hideServicesByImplementingPartner(
          "KkqMjxjAR7g",
          implementingPartner,
        );
        var inputValue = '${dataObject['KkqMjxjAR7g']}';
        if (inputValue == 'true') {
          hiddenFields['gYAZrh9o1DB'] = false;
          hiddenFields['Jxlug5I3kdu'] = false;
        }
      } else if (key == 'hJUuQ648wVF' && value == 'true') {
        hiddenFields['mRoO7kgpgVg'] = hideServicesByImplementingPartner(
          "mRoO7kgpgVg",
          implementingPartner,
        );
        var inputValue = '${dataObject['mRoO7kgpgVg']}';
        if (inputValue == 'true') {
          hiddenFields['CIRXgKGOmSI'] = false;
          hiddenFields['YSsfKXdIRLG'] = false;
          hiddenFields['wfiqfXHUBde'] = false;
        }
      } else if (key == 'BJrrrqQqwQO' && value == 'true') {
        hiddenFields['GNQ3gDA2CTI'] = hideServicesByImplementingPartner(
          "GNQ3gDA2CTI",
          implementingPartner,
        );
        var inputValue = '${dataObject['GNQ3gDA2CTI']}';
        if (inputValue == 'true') {
          hiddenFields['oTSVSO3iHTk'] = false;
          hiddenFields['aDOvfQ1wdIX'] = false;
          hiddenFields['PYMmQdzlPLJ'] = false;
        }
      } else if (key == 'LswSBpMoG5C' && value == 'true') {
        hiddenFields['gSp9bgPW52L'] = hideServicesByImplementingPartner(
          "gSp9bgPW52L",
          implementingPartner,
        );
        var inputValue = '${dataObject['gSp9bgPW52L']}';
        if (inputValue == 'true') {
          hiddenFields['fVpcWBp0Ngp'] = false;
          hiddenFields['pSkl6ibruvU'] = false;
        }
      } else if (key == 'gCKoJgBFdob' && value == 'true') {
        hiddenFields['mY7GqOTKtsQ'] = hideServicesByImplementingPartner(
          "mY7GqOTKtsQ",
          implementingPartner,
        );
        var inputValue = '${dataObject['mY7GqOTKtsQ']}';
        if (inputValue == 'true') {
          hiddenFields['h6obb1v1stw'] = false;
          hiddenFields['kBivIQr6mrW'] = false;
        }
      } else if (key == 'JSQ3xP1NhuN' && value == 'true') {
        hiddenFields['zK7kMYpgPQn'] = hideServicesByImplementingPartner(
          "zK7kMYpgPQn",
          implementingPartner,
        );
        var inputValue = '${dataObject['zK7kMYpgPQn']}';
        if (inputValue == 'true') {
          hiddenFields['GtejBpkVvtD'] = false;
          hiddenFields['g2X9vUL2d9m'] = false;
          hiddenFields['F6z3SQxLskG'] = false;
        }
      } else if (key == 'AwWKp6KmqgY' && value == 'true') {
        hiddenFields['tnspdPfpuXm'] = hideServicesByImplementingPartner(
          "tnspdPfpuXm",
          implementingPartner,
        );
        var inputValue = '${dataObject['tnspdPfpuXm']}';
        if (inputValue == 'true') {
          hiddenFields['V1HnY5m2Pmv'] = false;
          hiddenFields['eXh6Gag1uwp'] = false;
          hiddenFields['YRUnLuPerwn'] = false;
        }
      } else if (key == 'EaJTFrklMo5' && value == 'true') {
        hiddenFields['QnFYeBNZlbf'] = hideServicesByImplementingPartner(
          "QnFYeBNZlbf",
          implementingPartner,
        );
        var inputValue = '${dataObject['QnFYeBNZlbf']}';
        if (inputValue == 'true') {
          hiddenFields['EnrZPBFxZuX'] = false;
          hiddenFields['vXuVPQLxw1d'] = false;
          hiddenFields['xdI5atw8DC4'] = false;
        }
      } else if (key == 'HsxFZOuV4oZ' && value == 'true') {
        hiddenFields['KvLYMr8F4vg'] = hideServicesByImplementingPartner(
          "KvLYMr8F4vg",
          implementingPartner,
        );
        var inputValue = '${dataObject['KvLYMr8F4vg']}';
        if (inputValue == 'true') {
          hiddenFields['hnMy2l2pB3z'] = false;
          hiddenFields['TN5r1EFmHWz'] = false;
        }
      } else if (key == 'yPP7lkomNfK' && value == 'true') {
        hiddenFields['AnnOS2m6LZK'] = hideServicesByImplementingPartner(
          "AnnOS2m6LZK",
          implementingPartner,
        );
        var inputValue = '${dataObject['AnnOS2m6LZK']}';
        if (inputValue == 'true') {
          hiddenFields['UHWzhDsQdoB'] = false;
          hiddenFields['xECpX8Vt1rT'] = false;
          hiddenFields['WA8MAXBxaD1'] = false;
        }
      } else if (key == 'uQiyym8SEvd' && value == 'true') {
        hiddenFields['RNKOtUtLT4c'] = hideServicesByImplementingPartner(
          "RNKOtUtLT4c",
          implementingPartner,
        );
        var inputValue = '${dataObject['RNKOtUtLT4c']}';
        if (inputValue == 'true') {
          hiddenFields['sa79KxTFGFA'] = false;
          hiddenFields['EB3JPVqMdb4'] = false;
          hiddenFields['FAqGmEGN1sa'] = false;
        }
      } else if (key == 'WiPTQhWLVU1' && value == 'true') {
        hiddenFields['GImA3HB9YK5'] = hideServicesByImplementingPartner(
          "GImA3HB9YK5",
          implementingPartner,
        );
        var inputValue = '${dataObject['GImA3HB9YK5']}';
        if (inputValue == 'true') {
          hiddenFields['fFuabYbLUjz'] = false;
          hiddenFields['IFggJCXLYPD'] = false;
          hiddenFields['QBNhlIan0LR'] = false;
        }
      } else if (key == 'neF08iYV9Os' && value == 'true') {
        hiddenFields['Fj2RbXsb8Yj'] = hideServicesByImplementingPartner(
          "Fj2RbXsb8Yj",
          implementingPartner,
        );
        var inputValue = '${dataObject['Fj2RbXsb8Yj']}';
        if (inputValue == 'true') {
          hiddenFields['f90c5olxs5Z'] = false;
          hiddenFields['EPwDypaz61A'] = false;
          hiddenFields['xbMtMJ9Uo5j'] = false;
        }
      } else if (key == 'GO3Ojp1UEX7' && value == 'true') {
        hiddenFields['vj0R7ySdigX'] = hideServicesByImplementingPartner(
          "vj0R7ySdigX",
          implementingPartner,
        );
        var inputValue = '${dataObject['vj0R7ySdigX']}';
        if (inputValue == 'true') {
          hiddenFields['yW0TrzEslYO'] = false;
          hiddenFields['tmi1jtKYZs0'] = false;
          hiddenFields['HtBtsU71Can'] = false;
        }
      } else if (key == 'exHDkX1gPiC' && value == 'true') {
        hiddenFields['JlRnllAlSk0'] = hideServicesByImplementingPartner(
          "JlRnllAlSk0",
          implementingPartner,
        );
        var inputValue = '${dataObject['JlRnllAlSk0']}';
        if (inputValue == 'true') {
          hiddenFields['VlOw6vrLsp5'] = false;
          hiddenFields['ONC3bpjq525'] = false;
          hiddenFields['RcKIwnxrhqw'] = false;
        }
      } else if (key == 'Cb8qzfdrg7d' && value == 'true') {
        hiddenFields['LcIB5EL3IjT'] = hideServicesByImplementingPartner(
          "LcIB5EL3IjT",
          implementingPartner,
        );
        var inputValue = '${dataObject['LcIB5EL3IjT']}';
        if (inputValue == 'true') {
          hiddenFields['zYrrrFd48S5'] = false;
          hiddenFields['WVsVwfErZ7V'] = false;
          hiddenFields['g0WhpZC7Rhe'] = false;
        }
      } else if (key == 'qraZh4n14S4' && value == 'true') {
        hiddenFields['fvgPnlOD7e9'] = hideServicesByImplementingPartner(
          "fvgPnlOD7e9",
          implementingPartner,
        );
        var inputValue = '${dataObject['fvgPnlOD7e9']}';
        if (inputValue == 'true') {
          hiddenFields['JFetYCY5tza'] = false;
          hiddenFields['yuwtSD8EyoY'] = false;
        }
      } else if (key == 'TdReJf2LTXA' && value == 'true') {
        hiddenFields['MeMaUvt3O8j'] = hideServicesByImplementingPartner(
          "MeMaUvt3O8j",
          implementingPartner,
        );
        var inputValue = '${dataObject['MeMaUvt3O8j']}';
        if (inputValue == 'true') {
          hiddenFields['KZIjTeMl7sj'] = false;
          hiddenFields['KppYygPZ8BL'] = false;
        }
      } else if (key == 'q2N7p3UbvSF' && value == 'true') {
        hiddenFields['WQlWXUmYjI2'] = hideServicesByImplementingPartner(
          "WQlWXUmYjI2",
          implementingPartner,
        );
        var inputValue = '${dataObject['WQlWXUmYjI2']}';
        if (inputValue == 'true') {
          hiddenFields['gAMv1jxS0rh'] = false;
          hiddenFields['CxREUNzKxHB'] = false;
        }
      } else if (key == 'NcMANzhhphO' && value == 'true') {
        hiddenFields['Zc0M1jsbfyA'] = hideServicesByImplementingPartner(
          "Zc0M1jsbfyA",
          implementingPartner,
        );
        var inputValue = '${dataObject['Zc0M1jsbfyA']}';
        if (inputValue == 'true') {
          hiddenFields['mLjRp8wJ8aW'] = false;
          hiddenFields['QCbFgssCzeF'] = false;
        }
      } else if (key == 'ksc7ov3MihX' && value == 'true') {
        hiddenFields['TSx4O9Tf5v2'] = hideServicesByImplementingPartner(
          "TSx4O9Tf5v2",
          implementingPartner,
        );
        var inputValue = '${dataObject['TSx4O9Tf5v2']}';
        if (inputValue == 'true') {
          hiddenFields['x5VlMVD2a4E'] = false;
          hiddenFields['rJaHpLnWvfg'] = false;
          hiddenFields['mPMxntJR5Qy'] = false;
        }
      }
    });

    for (String sectionId in hiddenSections.keys) {
      List<FormSection> allFormSections = FormUtil.getFlattenFormSections(formSections);
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
