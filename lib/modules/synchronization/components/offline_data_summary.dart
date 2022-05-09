import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';

class OfflineDataSummary extends StatelessWidget {
  const OfflineDataSummary(
      {Key? key,
      required this.beneficiaryCount,
      required this.beneficiaryServiceCount})
      : super(key: key);

  final int beneficiaryCount;
  final int beneficiaryServiceCount;
  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text('Offline data summary',
                  style: const TextStyle().copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            LineSeparator(color: Colors.blueGrey.withOpacity(0.2)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Unsynced Beneficiaries',
                      style: const TextStyle().copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$beneficiaryCount',
                      style: const TextStyle().copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 10.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Unsynced Beneficiaries' services",
                      style: const TextStyle().copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$beneficiaryServiceCount',
                      style: const TextStyle().copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
