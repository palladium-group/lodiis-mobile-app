import 'package:flutter/material.dart';

class OvcRecordsPage extends StatefulWidget {
  const OvcRecordsPage({
    Key? key,
    required this.tabsController,
    this.tabsVieItems = const [],
  }) : super(key: key);

  final List<Widget> tabsVieItems;
  final TabController tabsController;

  @override
  State<OvcRecordsPage> createState() => _OvcRecordsPageState();
}

class _OvcRecordsPageState extends State<OvcRecordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: widget.tabsController,
        children: widget.tabsVieItems.map((Widget tab) => tab).toList(),
      ),
    );
  }
}
