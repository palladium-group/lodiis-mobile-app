import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/app_state/current_user_state/current_user_state.dart';
import 'package:lncmis_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:lncmis_mobile_app/app_state/mgysd_case_management_list_state/mgysd_case_management_list_state.dart';
import 'package:lncmis_mobile_app/core/components/access_to_data_entry/access_to_data_entry_warning.dart';
import 'package:lncmis_mobile_app/core/components/circular_process_loader.dart';
import 'package:lncmis_mobile_app/core/constants/custom_color.dart';
import 'package:lncmis_mobile_app/core/services/reserved_attribute_value_service.dart';
import 'package:lncmis_mobile_app/core/services/user_service.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:lncmis_mobile_app/models/intervention_card.dart';
import 'package:lncmis_mobile_app/modules/mgysd_case_management/mgysd_case_management.dart';
import 'package:provider/provider.dart';

class InterventionSelection extends StatefulWidget {
  const InterventionSelection({Key? key}) : super(key: key);

  @override
  State<InterventionSelection> createState() => _InterventionSelectionState();
}

class _InterventionSelectionState extends State<InterventionSelection> {
  final InterventionCard mgysd = InterventionCard.getInterventions().first;
  Color? primaryColor = CustomColor.defaultPrimaryColor;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), updateDataStateLoadingStatus);
  }

  Future<void> updateDataStateLoadingStatus() async {
    try {
      await UserService().setCurrentUserMetadataSyncStatus('false');
      await ReservedAttributeValueService().generateReservedAttributeValues();
      await Provider.of<MgysdCaseManagementListState>(context, listen: false)
          .refreshMgysdCasesNumber();
      Provider.of<CurrentUserState>(context, listen: false).setCurrentUserLocation();
    } catch (_) {}
  }

  void _openMgysd() {
    AppUtil.setStatusBarColor(mgysd.primaryColor);
    Provider.of<InterventionCardState>(context, listen: false)
        .setCurrentInterventionProgramId('mgysd');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MgysdCaseManagement()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CurrentUserState>(
          builder: (context, currentUserState, child) {
            if (!currentUserState.canCurrentUserDoDataEntry) {
              return Container(
                color: primaryColor,
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
                child: const AccessToDataEntryWarning(),
              );
            }
            return Consumer<MgysdCaseManagementListState>(
              builder: (context, state, child) {
                if (state.isLoading) return const CircularProcessLoader();
                return Container(
                  decoration: BoxDecoration(color: mgysd.primaryColor),
                  child: Center(
                    child: GestureDetector(
                      onTap: _openMgysd,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.82,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 34,
                              backgroundColor: mgysd.primaryColor?.withOpacity(0.12),
                              child: Icon(Icons.family_restroom, color: mgysd.primaryColor, size: 36),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              mgysd.name ?? 'LCMIS Case Management',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: mgysd.primaryColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${state.numberOfMgysdCases} case${state.numberOfMgysdCases == 1 ? '' : 's'} available',
                              style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mgysd.primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: _openMgysd,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Open LCMIS'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
