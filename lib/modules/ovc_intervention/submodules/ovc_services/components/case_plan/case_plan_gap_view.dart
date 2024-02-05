import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kb_mobile_app/app_state/language_translation_state/language_translation_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/utils/app_util.dart';
import 'package:kb_mobile_app/core/utils/form_util.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_child_case_plan_gap.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/submodules/ovc_services/models/ovc_services_household_case_plan_gaps.dart';
import 'package:provider/provider.dart';

class CasePlanGapView extends StatelessWidget {
  const CasePlanGapView({
    Key? key,
    required this.casePlanGapObjects,
    required this.hasEditAccessToCasePlan,
    required this.isEditableMode,
    required this.isHouseholdCasePlan,
    required this.domainId,
    required this.formSectionColor,
    required this.onEdiCasePlanGap,
    required this.isOnCasePlanServiceProvision,
    required this.isOnCasePlanServiceMonitoring,
  }) : super(key: key);

  final List casePlanGapObjects;
  final bool isHouseholdCasePlan;
  final bool hasEditAccessToCasePlan;
  final bool isEditableMode;
  final bool isOnCasePlanServiceProvision;
  final bool isOnCasePlanServiceMonitoring;
  final String domainId;
  final Color formSectionColor;

  final Function onEdiCasePlanGap;

  final double iconHeight = 15.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 10.0,
      ),
      child: Column(
        children: [
          Visibility(
            visible: casePlanGapObjects.isNotEmpty,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                left: 13.0,
                right: 13.0,
                bottom: 5.0,
              ),
              child: Consumer<LanguageTranslationState>(
                builder: (context, languageTranslationState, child) => Text(
                  languageTranslationState.isSesothoLanguage
                      ? "Likheo"
                      : "Gaps",
                  style: const TextStyle().copyWith(
                    color: formSectionColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: casePlanGapObjects.map((casePlanGapObject) {
              Map casePlanGap = Map<String, dynamic>.from(casePlanGapObject);
              List<FormSection> formSections =
                  _getCasePlanGapFormSection(casePlanGapObject);
              List<InputField> inputFields =
                  FormUtil.getFormInputFields(formSections)
                      .where((InputField inputField) =>
                          casePlanGap.keys.toList().contains((inputField.id)))
                      .toList();
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: formSectionColor.withOpacity(0.2),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      ...[
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                '',
                              ),
                            ),
                            Visibility(
                              visible: hasEditAccessToCasePlan &&
                                  isEditableMode &&
                                  !(isOnCasePlanServiceMonitoring ||
                                      isOnCasePlanServiceProvision),
                              child: InkWell(
                                onTap: () => onEdiCasePlanGap(casePlanGap),
                                child: Container(
                                  height: iconHeight,
                                  width: iconHeight,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 10.0,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/edit-icon.svg',
                                    colorFilter: ColorFilter.mode(
                                      formSectionColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                      ...inputFields
                          .map(
                            (inputField) => Container(
                              margin: const EdgeInsets.symmetric(),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                    ),
                                    child: Text(
                                      inputField.name,
                                      style: const TextStyle().copyWith(
                                        color: formSectionColor,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      _getInputValue(
                                        inputField,
                                        casePlanGap,
                                      ),
                                      style: const TextStyle().copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 5.0,
                                    ),
                                    child: LineSeparator(
                                      color: formSectionColor.withOpacity(0.5),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<FormSection> _getCasePlanGapFormSection(casePlanGapObject) {
    return isHouseholdCasePlan
        ? OvcHouseholdServicesCasePlanGaps.getFormSections(
                firstDate: casePlanGapObject['eventDate'] ??
                    AppUtil.formattedDateTimeIntoString(
                      DateTime.now(),
                    ))
            .where((FormSection form) => form.id == domainId)
            .toList()
        : OvcServicesChildCasePlanGap.getFormSections(
                firstDate: casePlanGapObject['eventDate'] ??
                    AppUtil.formattedDateTimeIntoString(
                      DateTime.now(),
                    ))
            .where((FormSection form) => form.id == domainId)
            .toList();
  }

  String _getInputValue(InputField inputField, Map dataObject) {
    dynamic value = '${dataObject[inputField.id]}' != 'null'
        ? '${dataObject[inputField.id]}'
        : '   ';
    if (inputField.valueType == 'BOOLEAN') {
      value = '$value' == 'true'
          ? 'Yes'
          : value == 'false'
              ? 'No'
              : value;
    } else if (inputField.valueType == 'TRUE_ONLY') {
      value = '$value' == 'true' ? 'Yes' : value;
    }
    return value.toString();
  }
}
