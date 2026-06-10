import 'package:flutter/material.dart';
import 'package:lncmis_mobile_app/core/utils/app_util.dart';
import 'package:lncmis_mobile_app/models/input_field.dart';

class FormSection {
  String? id;
  String name;
  String? translatedName;
  Color color;
  Color? backgroundColor;
  Color? borderColor;
  String? description;
  String? translatedDescription;
  List<FormSection>? subSections;
  List<InputField>? inputFields;

  FormSection({
    this.id,
    required this.name,
    required this.color,
    this.backgroundColor,
    this.borderColor,
    this.subSections,
    this.description,
    this.translatedDescription,
    this.translatedName,
    this.inputFields,
  }) {
    id = id ?? AppUtil.getUid();
    backgroundColor = backgroundColor ?? Colors.transparent;
    borderColor = borderColor ?? Colors.transparent;
    subSections = subSections ?? [];
    inputFields = inputFields ?? [];
    description = description ?? "";
  }

  @override
  String toString() {
    return name;
  }
}
