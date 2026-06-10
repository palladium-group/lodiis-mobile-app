import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lncmis_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:lncmis_mobile_app/app_state/synchronization_state/synchronization_state.dart';
import 'package:lncmis_mobile_app/core/components/line_separator.dart';
import 'package:lncmis_mobile_app/core/components/material_card.dart';
import 'package:lncmis_mobile_app/modules/synchronization/constants/synchronization_actions_constants.dart';
import 'package:provider/provider.dart';

class SynchronizationProgress extends StatefulWidget {
  const SynchronizationProgress(
      {Key? key,
      this.syncAction,
      this.hasUnsyncedData,
      this.overallSyncProgress,
      this.eventsSyncProgress,
      this.profileSyncProgress,
      this.overallUploadProgress,
      this.overallDownloadProgress,
      this.notificationSyncProgress})
      : super(key: key);

  final String? syncAction;
  final bool? hasUnsyncedData;
  final double? eventsSyncProgress;
  final double? profileSyncProgress;
  final double? overallUploadProgress;
  final double? overallDownloadProgress;
  final double? overallSyncProgress;
  final double? notificationSyncProgress;

  @override
  State<SynchronizationProgress> createState() =>
      _SynchronizationProgressState();
}

class _SynchronizationProgressState extends State<SynchronizationProgress> {
  Future<void> stopSynchronization(BuildContext context) async {
    Provider.of<SynchronizationState>(context, listen: false)
        .stopSyncActivity();
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Synchronization Progress';
    return MaterialCard(
        body: Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              // ),
              child: Row(children: [
                Expanded(
                  flex: 9,
                  child: Center(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: const TextStyle().copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => stopSynchronization(context),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            height: 22,
                            width: 22,
                            child: SvgPicture.asset(
                              'assets/icons/close_icon.svg',
                            ),
                          ),
                        )
                      ],
                    ))
              ])),
          LineSeparator(color: Colors.blueGrey.withOpacity(0.2)),
          Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: Text(
                'Starting ${widget.syncAction == SynchronizationActionsConstants.download ? "Download" : widget.syncAction == SynchronizationActionsConstants.upload ? "Upload" : "Synchronization"}. Please wait, this might take a while.',
                textAlign: TextAlign.center,
                style: const TextStyle().copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                )),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                const Text('Overall Progress'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color?>(
                          Provider.of<InterventionCardState>(context,
                                  listen: false)
                              .currentInterventionProgram
                              .primaryColor),
                      minHeight: 10.0,
                      value: widget.overallSyncProgress ?? 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.syncAction ==
                SynchronizationActionsConstants.downloadAndUpload,
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  const Text('Data upload'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color?>(
                            Provider.of<InterventionCardState>(context,
                                    listen: false)
                                .currentInterventionProgram
                                .primaryColor),
                        minHeight: 10.0,
                        value: widget.overallUploadProgress ?? 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.syncAction !=
                SynchronizationActionsConstants.downloadAndUpload,
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  const Text('Profile Data'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color?>(
                            Provider.of<InterventionCardState>(context,
                                    listen: false)
                                .currentInterventionProgram
                                .primaryColor),
                        minHeight: 10.0,
                        value: widget.profileSyncProgress ?? 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.syncAction !=
                SynchronizationActionsConstants.downloadAndUpload,
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  const Text('Service Data'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color?>(
                            Provider.of<InterventionCardState>(context,
                                    listen: false)
                                .currentInterventionProgram
                                .primaryColor),
                        minHeight: 10.0,
                        value: widget.eventsSyncProgress ?? 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                const Text('Notifications'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color?>(
                          Provider.of<InterventionCardState>(context,
                                  listen: false)
                              .currentInterventionProgram
                              .primaryColor),
                      minHeight: 10.0,
                      value: widget.notificationSyncProgress ?? 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
