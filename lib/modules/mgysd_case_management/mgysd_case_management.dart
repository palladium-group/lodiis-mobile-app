
import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:lncmis_mobile_app/models/intervention_card.dart';
import 'package:lncmis_mobile_app/modules/mgysd_case_management/case_shell/pages/mgysd_case_list_page.dart';
import 'package:lncmis_mobile_app/modules/mgysd_case_management/case_shell/pages/mgysd_case_management_home.dart';
import 'package:lncmis_mobile_app/modules/mgysd_case_management/case_shell/pages/mgysd_records_page.dart';
import 'package:provider/provider.dart';
import 'package:lncmis_mobile_app/core/utils/app_bar_util.dart';

class MgysdCaseManagement extends StatefulWidget {
  const MgysdCaseManagement({Key? key}) : super(key: key);

  @override
  State<MgysdCaseManagement> createState() => _MgysdCaseManagementState();
}

class _MgysdCaseManagementState extends State<MgysdCaseManagement> {
  InterventionCard? interventionCard;

  @override
  void initState() {
    super.initState();
    interventionCard =
        Provider.of<InterventionCardState>(context, listen: false)
            .currentInterventionProgram;
  }

  @override
  Widget build(BuildContext context) {
    final InterventionCard current = interventionCard ??
        InterventionCard(
          id: 'mgysd',
          name: 'MGYSD Case Management',
          primaryColor: const Color(0xFF6A1B9A), // ✅ dark purple default
          secondaryColor: const Color(0xFF6A1B9A),
        );

    final Color themeColor =
        current.primaryColor ?? const Color(0xFF6A1B9A);

    return DefaultTabController(
      length: 3, // Home + Cases + Records
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeColor,
          elevation: 0,
          title: Text(
            current.name ?? 'MGYSD Case Management',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),

          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                AppBarUtil.onOpenMoreMenu(
                  context,
                  current,
                  true,
                );
              },
            ),
          ],

          // ✅ Styled TabBar
          bottom: TabBar(
            labelColor: Colors.white, // selected tab text
            unselectedLabelColor: Colors.white70, // unselected tab text
            indicatorColor: Colors.white, // underline color
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Home'),
              Tab(text: 'Cases'),
              Tab(text: 'Records'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const MgysdCaseManagementHome(),
            MgysdCaseListPage(color: themeColor),
            MgysdRecordsPage(color: themeColor),
          ],
        ),
      ),
    );
  }
}
