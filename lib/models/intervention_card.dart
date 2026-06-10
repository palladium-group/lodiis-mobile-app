
import 'package:flutter/material.dart';

class InterventionCard {
  String? id;
  String? name;
  String? translatedName;
  String? shortName;
  String? translatedShortName;
  String? svgIcon;
  String? enrollmentIcon;
  Color? primaryColor;
  Color? secondaryColor;
  Color? svgIconColor;
  Color? svgIconBorderColor;
  Color? svgBackgroundColor;
  Color? background;
  Color? nameColor;
  Color? countLabelColor;
  Color? countColor;
  List<String>? supportedTabs;

  InterventionCard({
    this.id,
    this.name,
    this.translatedName,
    this.translatedShortName,
    this.shortName,
    this.svgIcon,
    this.enrollmentIcon,
    this.primaryColor,
    this.secondaryColor,
    this.svgIconColor,
    this.svgIconBorderColor,
    this.svgBackgroundColor,
    this.background,
    this.nameColor,
    this.countColor,
    this.countLabelColor,
    this.supportedTabs,
  });

  static List<String> getInterventionIds() {
    return getInterventions()
        .map((InterventionCard interventionCard) => interventionCard.id!)
        .toList()
        .toSet()
        .toList();
  }

  static List<InterventionCard> getInterventions() {
    return [
      InterventionCard(
        id: 'mgysd',
        name: 'Lesotho Case Management Information System',
        shortName: 'LCMIS',
        svgIcon: 'assets/icons/add-beneficiary.svg',
        enrollmentIcon: 'assets/icons/add-beneficiary.svg',
        primaryColor: const Color(0xFF0D47A1),
        secondaryColor: const Color(0xFF0D47A1).withOpacity(0.8),
        svgIconColor: Colors.white,
        svgIconBorderColor: Colors.white,
        svgBackgroundColor: const Color(0xFF0D47A1).withOpacity(0.1),
        background: const Color(0xFF0D47A1).withOpacity(0.09),
        nameColor: const Color(0xFF0D47A1),
        countColor: const Color(0xFF0D47A1).withOpacity(0.8),
        countLabelColor: const Color(0xFF0D47A1).withOpacity(0.3),
        supportedTabs: ['cases', 'records'],
      ),
    ];
  }

  @override
  String toString() {
    return '$name - $id';
  }
}

