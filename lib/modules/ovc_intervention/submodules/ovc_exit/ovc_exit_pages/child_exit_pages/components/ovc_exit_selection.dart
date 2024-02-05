import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/ovc_intervention_list_state/ovc_household_current_selection_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/child_exit_pages/constants/ovc_exit_case_plan_graduation_readiness_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/child_exit_pages/constants/ovc_exit_case_transfer_constant.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_exit/ovc_exit_pages/child_exit_pages/constants/ovc_exit_constant.dart';
import 'package:provider/provider.dart';

class OvcChildExitSelection extends StatefulWidget {
  final List<String?> programStageIdsWithData;

  const OvcChildExitSelection({
    Key? key,
    required this.programStageIdsWithData,
  }) : super(key: key);

  @override
  State<OvcChildExitSelection> createState() => _OvcChildExitSelectionState();
}

class _OvcChildExitSelectionState extends State<OvcChildExitSelection> {
  late List<String?> exitTitles;

  @override
  void initState() {
    super.initState();
    setExitTitles();
  }

  void setExitTitles() {
    exitTitles = [];
    var currentHouseHold =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHousehold;
    var currentOvc =
        Provider.of<OvcHouseholdCurrentSelectionState>(context, listen: false)
            .currentOvcHouseholdChild;
    Map programStageMap = OvcExitConstant.getOvcExitProgramStageMap();

    setState(() {
      for (String id in programStageMap.keys.toList()) {
        if (!widget.programStageIdsWithData.contains(id)) {
          exitTitles.add(programStageMap[id]);
        }
      }
      if (widget.programStageIdsWithData.isEmpty ||
          widget.programStageIdsWithData
              .contains(OvcExitConstant.caseClosureKey)) {
        exitTitles.remove(programStageMap[OvcExitConstant.caseClosureKey]);
      }
      if (currentOvc?.hasExitedProgram == true ||
          currentHouseHold?.hasExitedProgram == true) {
        exitTitles.removeWhere((title) => [
              programStageMap[OvcExitCaseTransferConstant.programStage],
              programStageMap[
                  HouseholdGraduationReadinessFormConstant.programStage]
            ].contains(title));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: const Text(
              'SELECT EXIT TYPE',
              style: TextStyle(
                  color: Color(0xFF4B9F46),
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
          ),
          Column(
            children: exitTitles.map((exitTitle) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const LineSeparator(
                    color: Color(0xFFE0E6E0),
                    height: 1.0,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.pop(context, exitTitle),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Text(
                                exitTitle!,
                                style: const TextStyle(
                                  color: Color(0xFF1A3518),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
