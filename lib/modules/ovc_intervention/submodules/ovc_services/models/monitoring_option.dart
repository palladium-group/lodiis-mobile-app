import 'package:flutter/material.dart';

class MonitoringOption {
  final String id;
  final String title;
  final String? subtitle;
  final String? routeName; // optional: if you navigate by routes
  final IconData icon;
  final Map<String, dynamic>? extra; // carry anything else (program/stage/etc.)

  const MonitoringOption({
    required this.id,
    required this.title,
    this.subtitle,
    this.routeName,
    this.icon = Icons.description_outlined,
    this.extra,
  });
}
