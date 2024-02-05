import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';

class DataDownloadConflictPageHeader extends StatelessWidget {
  const DataDownloadConflictPageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: const Column(
          children: [
            LineSeparator(
              color: Colors.grey,
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Label"),
                Text("Offline Value"),
                Text("Online Value"),
                Text("Action")
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            LineSeparator(
              color: Colors.grey,
              height: 1,
            )
          ],
        ));
  }
}
