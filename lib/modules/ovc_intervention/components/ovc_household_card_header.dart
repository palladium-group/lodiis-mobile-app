import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kb_mobile_app/app_state/synchronization_state/synchronization_status_state.dart';
import 'package:kb_mobile_app/core/components/beneficiary_sync_status_indicator.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/models/ovc_household.dart';
import 'package:kb_mobile_app/models/ovc_household_child.dart';
import 'package:kb_mobile_app/modules/ovc_intervention/components/ovc_household_primary_child_warning.dart';
import 'package:provider/provider.dart';

class OvcHouseholdCardHeader extends StatelessWidget {
  const OvcHouseholdCardHeader({
    Key? key,
    required this.ovcHousehold,
    required this.svgIcon,
    required this.canEdit,
    required this.canView,
    required this.canExpand,
    required this.isExpanded,
    this.onEdit,
    this.onView,
    this.onToggleCard,
  }) : super(key: key);

  final OvcHousehold? ovcHousehold;

  final String svgIcon;
  final bool canEdit;
  final bool canView;
  final bool canExpand;
  final bool isExpanded;

  final VoidCallback? onEdit;
  final VoidCallback? onView;
  final VoidCallback? onToggleCard;

  Visibility _getOvcHouseHoldCardHeaderIcon({
    required double iconHeight,
    required bool isVisible,
    required String svgIcon,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Visibility(
      visible: isVisible,
      child: Expanded(
        flex: 1,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: iconHeight * 0.8,
            width: iconHeight,
            margin: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 5.0,
            ),
            child: SvgPicture.asset(
              svgIcon,
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _getSyncStatusOfHousehold(
    OvcHousehold ovcHousehold,
    List<String> unsyncedTeiReferences,
  ) {
    int teiIndex = unsyncedTeiReferences.indexOf(ovcHousehold.id!);
    List<OvcHouseholdChild> unsyncedChildren =
        ovcHousehold.children!.where((OvcHouseholdChild ovcHouseholdChild) {
      int childIndex = unsyncedTeiReferences.indexOf(ovcHouseholdChild.id!);
      return childIndex > -1;
    }).toList();
    return unsyncedChildren.isEmpty && teiIndex == -1;
  }

  @override
  Widget build(BuildContext context) {
    double iconHeight = 20.0;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getOvcHouseHoldCardHeaderIcon(
                iconHeight: iconHeight,
                isVisible: true,
                svgIcon: svgIcon,
                iconColor: const Color(0xFF4B9F46),
              ),
              Visibility(
                visible: true,
                child: Expanded(
                  flex: canEdit && canView ? 9 : 10,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Text(
                      ovcHousehold!.primaryUIC!,
                      style: const TextStyle().copyWith(
                        color: const Color(0xFF1A3518),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: ovcHousehold?.primaryChildExist != true ||
                      ovcHousehold?.primaryChildHasExited == true,
                  child: OvcHouseholdPrimaryChildWarning(
                    primaryChildExited: (ovcHousehold?.primaryChildHasExited)!,
                  )),
              Consumer<SynchronizationStatusState>(
                  builder: (context, synchronizationStatusState, child) {
                List<String> unsyncedTeiReferences =
                    synchronizationStatusState.unsyncedTeiReferences;
                return BeneficiarySyncStatusIndicator(
                  isSynced: _getSyncStatusOfHousehold(
                      ovcHousehold!, unsyncedTeiReferences),
                );
              }),
              _getOvcHouseHoldCardHeaderIcon(
                iconHeight: iconHeight,
                isVisible: canView,
                onTap: onView,
                svgIcon: 'assets/icons/expand_icon.svg',
                iconColor: const Color(0xFF4B9F46),
              ),
              _getOvcHouseHoldCardHeaderIcon(
                iconHeight: iconHeight,
                isVisible: canEdit &&
                    ovcHousehold!.enrollmentOuAccessible! &&
                    ovcHousehold!.hasExitedProgram != true,
                onTap: onEdit,
                svgIcon: 'assets/icons/edit-icon.svg',
                iconColor: const Color(0xFF4B9F46),
              ),
              _getOvcHouseHoldCardHeaderIcon(
                iconHeight: iconHeight,
                isVisible: canExpand,
                onTap: onToggleCard,
                svgIcon: isExpanded
                    ? 'assets/icons/chevron_up.svg'
                    : 'assets/icons/chevron_down.svg',
                iconColor: const Color(0xFF05131B),
              ),
            ],
          ),
        ),
        const LineSeparator(
          color: Color(0xFFECF5EC),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}
