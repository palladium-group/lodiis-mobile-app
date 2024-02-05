import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/constants/ovc_case_plan_constant.dart';

class OvcChildCasePlanConstant {
  static const String program = 'em38qztTI8s';
  static const String casePlanProgramStage = 'ZHjrdThi7Bz';
  static const String casePlanGapProgramStage = 'gkNKXUxpyv9';
  static const String casePlanGapServiceProvisionProgramStage = 'CHFwighOquA';
  static const String casePlanGapServiceMonitoringProgramStage = 'v9Vrc5exzam';

  static List<String> getValidIdForAutoPopulatingServiceData({
    required Map domainConfig,
    required int age,
  }) {
    List<String> validIds = [];
    validIds.addAll(domainConfig['generic'] ?? []);
    List ageBased = domainConfig["ageBased"] ?? [];
    if (ageBased.isNotEmpty) {
      for (Map ageBasedConfig in ageBased) {
        int? minAge = ageBasedConfig['minAge'];
        int? maxAge = ageBasedConfig['maxAge'];
        if (minAge != null && maxAge != null && age >= minAge && age < maxAge) {
          List<String> ids = ageBasedConfig["ids"] ?? [];
          validIds.addAll(ids);
        }
      }
    }
    return validIds;
  }

  static const Map<String, Map> domainToAutopopuledCasePlanGaps = {
    "Health": {
      "generic": [
        //Defult for events
        "eventDate",
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
        // FOOD PREV
        "AwWKp6KmqgY", "cXCdR7BvrSM", "u8yn7sY5eOX", "Mu0LxlAOoSp",
        // FOOD PREP
        "JSQ3xP1NhuN", "k6jzyzGOu5Y", "HrCyUkuZath", "MdmCqSwcrlk",
        //FOOD SUPPORT
        "EaJTFrklMo5", "rHgxOKM91wi", "v00dsDvhCRu", "WAq2HJHXZYS",
        //TIPPY TAP
        "DQxqyncQtwm", "P4I6rK6Xqxw", "WFKe1YpH1uK", "YJXb5rSVP0L",
        // WASH MESSAGE
        "Hvq9oisH7Gt", "ue6xLPEURqt", "vIbKIUgzBU4", "tQ3pKyJ0X9d",
        //SOACKAGE PIT
        "qTf8VSoojJ2", "ontonbgTJ8k", "AjYKLfIQPtT", "M2Aqvn027cd",
      ],
      "ageBased": []
    },
    "Safe": {
      "generic": [
        //Defult for events
        "eventDate",
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
        //RTEEN/Parenting
        "WiPTQhWLVU1", "E2CWztOcx2X", "xFXc0oacTEb", "BpLk6ruSL7e"
      ],
      "ageBased": [
        {
          "minAge": 0,
          "maxAge": 5,
          "ids": [
            //P&FC
            "PoxYSqq8Hgz", "O3mOdzWYmg3", "WFscqdyjgUy", "fCDk1LxN484"
          ],
        },
      ]
    },
    "Stable": {
      "generic": [
        //Defult for events
        "eventDate",
        OvcCasePlanConstant.casePlanToGapLinkage,
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
        // SILC
        "e6NV2ZAzFEh", "JtfKB58MvNK", "MMjndp2xsoQ", "Hdf3EtTGfAb",
        // K/TPLOTS
        'WrjNxZBVHCL', "NWBZilCPutW", "boUUP8UeWDL", "d3k97F0fS2y"
      ],
      "ageBased": [
        {
          "minAge": 9,
          "maxAge": 18,
          "ids": [
            // FINANCIAL EDUCATION
            "kvF996ugmMl", "OMtcDA7tcVL", "Mz24UpWclb3", "zVCkEJuy2t8",
          ],
        },
      ]
    },
  };

  static const Map<String, Map> domainToAutopopuledCasePlanServiceProvision = {
    "Health": {
      "generic": [
        //Defult for events
        "eventDate",
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        // FOOD PREV
        "tnspdPfpuXm",
        "V1HnY5m2Pmv",
        "YRUnLuPerwn",
        "eXh6Gag1uwp",
        // FOOD PREP
        "zK7kMYpgPQn", "GtejBpkVvtD", "F6z3SQxLskG", "g2X9vUL2d9m",
        //FOOD SUPPORT
        "QnFYeBNZlbf", "EnrZPBFxZuX", "vXuVPQLxw1d", "xdI5atw8DC4",
        //TIPPY TAP
        "FRWCmEerPic", "lQYnoeqfKpe", "IiIVDSKX8yk",
        // WASH MESSAGE
        "gV77yUM8NK8", "aqJBZDBzh4m", "EtENRPlSnO0", "JFlnkaXlXm5",
        //SOACKAGE PIT
        "qL9c5r7c6kK", "pUphS6E1Gu5", "k5RGRpWRbbs", "SODPuEmHEGV"
      ],
      "ageBased": []
    },
    "Safe": {
      "generic": [
        //Defult for events
        "eventDate",
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        //RTEEN/Parenting
        "GImA3HB9YK5", "fFuabYbLUjz", "QBNhlIan0LR", "IFggJCXLYPD"
      ],
      "ageBased": [
        {
          "minAge": 0,
          "maxAge": 5,
          "ids": [
            //P&FC
            "gwwUOs6yt6C", "w2HlBCfHbZR", "n30r7v0ti1s", "aG42nUguLLW"
          ],
        },
      ]
    },
    "Stable": {
      "generic": [
        //Defult for events
        "eventDate",
        OvcCasePlanConstant.casePlanGapToServiceProvisionLinkage,
        // SILC
        "xTO562B5g53", "uOMr56xoKDh", "hMdC0CMKSGn",
        // K/TPLOTS
        "lEkrLOFmLrH", "F8ALMOcc6C1", "ereN7hP7yuT", "p77CBdxxtHI"
      ],
      "ageBased": [
        {
          "minAge": 9,
          "maxAge": 18,
          "ids": [
            // FINANCIAL EDUCATION
            "lpTVK3t1Ahk", "j1yzHzO0w6w", "KvHf0rBfa1L", "HGpA4kx5jLQ"
          ],
        },
      ]
    },
  };

  static const Map<String, Map> domainToAutopopuledCasePlanServiceMonitoring = {
    "Health": {
      "generic": [
        //Defult for events
        "eventDate",
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
        // FOOD PREV
        "JINWcteYR7D",
        // FOOD PREP
        "BLuel6eSkV3",
        //FOOD SUPPORT
        "gtXZARFG9Pa",
        //TIPPY TAP
        "TaSyHHXKYhF",
        // WASH MESSAGE
        "qezhtOHXgaK",
        //SOACKAGE PIT
        "W4UjM09aOEw",
      ],
      "ageBased": []
    },
    "Safe": {
      "generic": [
        //Defult for events
        "eventDate",
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
        //RTEEN/Parenting
        "UqQEuWwhwBd",
      ],
      "ageBased": [
        {
          "minAge": 0,
          "maxAge": 5,
          "ids": [
            //P&FC
            "JgokYFY6IWK",
          ],
        },
      ]
    },
    "Stable": {
      "generic": [
        //Defult for events
        "eventDate",
        OvcCasePlanConstant.casePlanGapToMonitoringLinkage,
        // SILC
        "wNUBfCAg3Fq",
        // K/TPLOTS
        "legjCg7fomo",
      ],
      "ageBased": [
        {
          "minAge": 9,
          "maxAge": 18,
          "ids": [
            // FINANCIAL EDUCATION,
            "QD77bNjavza",
          ],
        },
      ]
    },
  };
}
