import 'package:flutter/material.dart';

class InterventionPopActionMenu {
  String? id;
  String? name;
  String? translatedName;
  Color? color;
  FontWeight fontWeight;

  InterventionPopActionMenu({
    this.id,
    this.name,
    this.translatedName,
    this.color = const Color(0xFF1A3518),
    this.fontWeight = FontWeight.normal,
  });

  static List<InterventionPopActionMenu>
      getDefaultInterventionPopActionMenus() {
    return [
      InterventionPopActionMenu(
        id: 'logout',
        name: 'Logout',
        translatedName: 'Tsoa'
      ),
      InterventionPopActionMenu(
        id: 'about',
        name: 'About App',
        translatedName: 'Mabapi le App'
      ),
      InterventionPopActionMenu(
        id: 'sync',
        name: 'Sync',
        translatedName: 'Sync'
      ),
      InterventionPopActionMenu(
        id: 'language_setting',
        name: 'Language Settings',
        translatedName: 'Khetha Puo',
      ),
      InterventionPopActionMenu(
        id: 'application_logs',
        name: 'Application Logs',
        translatedName: "Litaba tse bonts'ang liketsahalo tsohle ka hara LODIIS"
      ),
    ];
  }

  @override
  String toString() {
    return '$name - $id';
  }
}
