import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/core/components/line_separator.dart';
import 'package:lncmis_mobile_app/core/components/material_card.dart';
import 'package:lncmis_mobile_app/core/constants/app_logs_constants.dart';
import 'package:lncmis_mobile_app/models/app_logs.dart';

class AppLogsCard extends StatelessWidget {
  const AppLogsCard({
    Key? key,
    required this.appLog,
    required this.currentInterventionColor,
  }) : super(key: key);

  final AppLogs appLog;
  final Color? currentInterventionColor;

  @override
  Widget build(BuildContext context) {
    String logDateString =
        appLog.date != null ? appLog.date!.split(' ')[0] : '';
    String logTimeString =
        appLog.date != null ? appLog.date!.split(' ')[1] : '';
    return MaterialCard(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: appLog.type == AppLogsConstants.errorLogType
                      ? const Icon(
                          Icons.cancel,
                          color: Colors.redAccent,
                        )
                      : appLog.type == AppLogsConstants.infoLogType
                          ? const Icon(
                              Icons.info,
                              color: Colors.blueAccent,
                            )
                          : appLog.type == AppLogsConstants.warningLogType
                              ? const Icon(
                                  Icons.warning,
                                  color: Colors.amberAccent,
                                )
                              : null,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      logDateString,
                      style: const TextStyle().copyWith(
                        color: const Color(0xFF82898D),
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      logTimeString.split('.')[0],
                      style: const TextStyle().copyWith(
                          color: const Color(0xFF82898D), fontSize: 12.0),
                    )
                  ],
                )
              ],
            ),
          ),
          LineSeparator(
            color: currentInterventionColor!.withOpacity(0.3),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    appLog.message!,
                    style: const TextStyle().copyWith(
                      fontSize: 14.0,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
