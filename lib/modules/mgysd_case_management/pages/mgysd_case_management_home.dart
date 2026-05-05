
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/app_state/intervention_card_state/intervention_card_state.dart';
import 'package:kb_mobile_app/core/components/line_separator.dart';
import 'package:kb_mobile_app/core/components/material_card.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/pages/mgysd_case_list_page.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/pages/mgysd_new_case_page.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/pages/mgysd_report_case_page.dart';
import 'package:provider/provider.dart';

class MgysdCaseManagementHome extends StatelessWidget {
  const MgysdCaseManagementHome({Key? key}) : super(key: key);

  Color _getPrimaryColor(BuildContext context) {
    return Provider.of<InterventionCardState>(context, listen: false)
        .currentInterventionProgram
        .primaryColor ??
        const Color(0xFF6A1B9A);
  }

  void _openCaseList(BuildContext context, Color primaryColor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MgysdCaseListPage(color: primaryColor),
      ),
    );
  }

  void _openNewCase(BuildContext context, Color primaryColor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MgysdNewCasePage(color: primaryColor),
      ),
    );
  }

  void _openReportCase(BuildContext context, Color primaryColor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MgysdRecordCasePage(color: primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = _getPrimaryColor(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Column(
        children: [
          MaterialCard(
            body: Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MGYSD Case Management',
                    style: const TextStyle().copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  LineSeparator(color: Colors.blueGrey.withOpacity(0.2)),
                  const SizedBox(height: 10.0),
                  Text(
                    'Stage 1: Reporting saves an OFFLINE event (Reported Case).\n'
                        'Stage 2+: Intake/registered cases will be Tracker later.',
                    style: const TextStyle().copyWith(
                      fontSize: 13.0,
                      color: Colors.blueGrey,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          _ActionTile(
            title: 'Report a Case',
            subtitle: 'Stage 1 reporting (offline event)',
            icon: Icons.report_problem_outlined,
            color: primaryColor,
            onTap: () => _openReportCase(context, primaryColor),
          ),
          const SizedBox(height: 10),

          _ActionTile(
            title: 'Open Cases',
            subtitle: 'View and search registered cases',
            icon: Icons.folder_open,
            color: primaryColor,
            onTap: () => _openCaseList(context, primaryColor),
          ),
          const SizedBox(height: 10),

          _ActionTile(
            title: 'Register / Intake Case',
            subtitle: 'Stage 2+ (tracker program later)',
            icon: Icons.person_add_alt_1,
            color: primaryColor,
            onTap: () => _openNewCase(context, primaryColor),
          ),
          const SizedBox(height: 10),

          _ActionTile(
            title: 'Sync',
            subtitle: 'Use the main Synchronization screen to sync MGYSD data',
            icon: Icons.sync,
            color: primaryColor,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Open the main Synchronization screen to sync MGYSD data.'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      body: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle().copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle().copyWith(
                        fontSize: 12.5,
                        color: Colors.blueGrey,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.blueGrey),
            ],
          ),
        ),
      ),
    );
  }
}
