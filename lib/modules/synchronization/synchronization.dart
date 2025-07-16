import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/app_state/synchronization_state/synchronization_state.dart';
import 'package:kb_mobile_app/core/components/circular_process_loader.dart';
import 'package:kb_mobile_app/core/components/sub_page_app_bar.dart';
import 'package:kb_mobile_app/core/components/sup_page_body.dart';
import 'package:kb_mobile_app/models/intervention_card.dart';
import 'package:kb_mobile_app/modules/synchronization/components/offline_data_summary.dart';
import 'package:kb_mobile_app/modules/synchronization/components/synchronization_progress.dart';
import 'package:kb_mobile_app/modules/synchronization/conflict_on_download_page.dart';
import 'package:kb_mobile_app/modules/synchronization/constants/synchronization_actions_constants.dart';
import 'package:provider/provider.dart';

class Synchronization extends StatefulWidget {
  const Synchronization({Key? key, this.synchronizationAction})
      : super(key: key);
  final String? synchronizationAction;
  @override
  State<Synchronization> createState() => _SynchronizationState();
}

class _SynchronizationState extends State<Synchronization> {
  final String label = 'Data Synchronization';
  String selectedSyncAction = SynchronizationActionsConstants.upload;

  void onViewConflicts(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const ConflictOnDownloadPage();
      },
    ));
  }

  void initializeSynchronization(BuildContext context) async {
    await Provider.of<SynchronizationState>(context, listen: false)
        .startSyncActivity(
            syncAction: SynchronizationActionsConstants.upload);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        String currentSyncAction =
            Provider.of<SynchronizationState>(context, listen: false)
                .currentSyncAction;
        selectedSyncAction = currentSyncAction != ''
            ? currentSyncAction
            : widget.synchronizationAction ?? '';
        Provider.of<SynchronizationState>(context, listen: false)
            .startCheckingStatusOfUnsyncedData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Consumer<InterventionCardState>(
          builder: (context, interventionCardState, child) {
            InterventionCard activeInterventionProgram =
                interventionCardState.currentInterventionProgram;
            return SubPageAppBar(
              label: label,
              activeInterventionProgram: activeInterventionProgram,
              disableSelectionOfActiveIntervention: false,
            );
          },
        ),
      ),
      body: SubPageBody(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 13.0),
          child: Consumer<SynchronizationState>(
            builder: (context, synchronizationState, child) {
              bool isDataDownloadingActive =
                  synchronizationState.isDataDownloadingActive;
              bool isDataUploadingActive =
                  synchronizationState.isDataUploadingActive;
              bool hasUnsyncedData = synchronizationState.hasUnsyncedData;
              bool isUnsyncedCheckingActive =
                  synchronizationState.isUnsyncedCheckingActive;
              int beneficiaryCount = synchronizationState.beneficiaryCount;
              int beneficiaryServiceCount =
                  synchronizationState.beneficiaryServiceCount;
              double profileSyncProgress =
                  synchronizationState.profileSyncProgress;
              double eventsSyncProgress =
                  synchronizationState.eventsSyncProgress;
              double overallSyncProgress =
                  synchronizationState.overallSyncProgress;
              double overallDownloadProgress =
                  synchronizationState.overallDownloadProgress;
              double overallUploadProgress =
                  synchronizationState.overallUploadProgress;
              double notificationSyncProgress =
                  synchronizationState.notificationProgress;
              bool isSyncActive =
                  (isDataDownloadingActive || isDataUploadingActive);
              return isUnsyncedCheckingActive
                  ? const CircularProcessLoader(
                      color: Colors.blueGrey,
                    )
                  : Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          child: OfflineDataSummary(
                              beneficiaryCount: beneficiaryCount,
                              syncAction: selectedSyncAction,
                              isSyncActive: isSyncActive,
                              onInitializeSyncAction: (String? syncAction) =>
                                  initializeSynchronization(context),
                              beneficiaryServiceCount: beneficiaryServiceCount),
                        ),
                        Visibility(
                          visible:
                              isDataDownloadingActive || isDataUploadingActive,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            child: SynchronizationProgress(
                              syncAction: selectedSyncAction,
                              notificationSyncProgress:
                                  notificationSyncProgress,
                              hasUnsyncedData: hasUnsyncedData,
                              eventsSyncProgress: eventsSyncProgress,
                              profileSyncProgress: profileSyncProgress,
                              overallSyncProgress: overallSyncProgress,
                              overallDownloadProgress: overallDownloadProgress,
                              overallUploadProgress: overallUploadProgress,
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
