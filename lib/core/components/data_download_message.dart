import 'dart:async';
import 'package:kb_mobile_app/modules/synchronization/constants/synchronization_actions_constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:kb_mobile_app/app_state/referral_notification_state/referral_notification_state.dart';
import 'package:kb_mobile_app/app_state/synchronization_state/synchronization_state.dart';
import 'package:kb_mobile_app/core/services/referral_notification_service.dart';
import 'package:kb_mobile_app/modules/synchronization/synchronization.dart';

class DataDownloadMessage extends StatefulWidget {
  const DataDownloadMessage({Key? key}) : super(key: key);

  @override
  State<DataDownloadMessage> createState() => _DataDownloadMessageState();
}

class _DataDownloadMessageState extends State<DataDownloadMessage> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        checkForAvailableBeneficiaryDataFromServer();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onOpenSyncModule(BuildContext context, bool isCheckingForAvailableData) {
    if (!isCheckingForAvailableData) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Synchronization(
            synchronizationAction: SynchronizationActionsConstants.download,
          ),
        ),
      );
    }
  }

  void checkForAvailableBeneficiaryDataFromServer() async {
    Timer(const Duration(milliseconds: 100), () async {
      bool connected =
          Provider.of<DeviceConnectivityState>(context, listen: false)
              .connectivityStatus!;
      if (connected) {
        await ReferralNotificationService().syncReferralNotifications(
          shouldRefreshBeneficairyList: true,
          context: context,
        );
        if (mounted) {
          BuildContext ctx = context;
          await Provider.of<ReferralNotificationState>(ctx, listen: false)
              .reloadReferralNotifications();
          Provider.of<SynchronizationState>(ctx, listen: false)
              .checkingForAvailableBeneficiaryData(context,);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SynchronizationState>(
      builder: (context, synchronizationState, child) {
        return Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child:
                synchronizationState.statusMessageForAvailableDataFromServer !=
                        ''
                    ? GestureDetector(
                        onTap: () => onOpenSyncModule(
                            context,
                            synchronizationState
                                .isCheckingForAvailableDataFromServer),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              synchronizationState
                                  .statusMessageForAvailableDataFromServer,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Visibility(
                              visible: !synchronizationState
                                  .isCheckingForAvailableDataFromServer,
                              child: Container(
                                margin: const EdgeInsets.only(left: 5.0),
                                child: const Icon(
                                  Icons.download_sharp,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : const Text(''));
      },
    );
  }
}
