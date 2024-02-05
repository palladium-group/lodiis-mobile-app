import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/input_field_option.dart';

class InputField {
  String id;
  String name;
  String? translatedName;
  String? description;
  String? translatedDescription;
  String valueType;
  Color? labelColor;
  Color? inputColor;
  Color? background;
  bool? renderAsRadio;
  bool? isReadOnly;
  bool? allowFuturePeriod;
  bool? showCountryLevelTree;
  bool? disablePastPeriod;
  bool? hasError;
  int? minAgeInYear;
  int? maxAgeInYear;
  int? numberOfMonth;
  String? lastDate;
  String? firstDate;
  bool? shouldUserCustomAgeLimit;
  String? suffixLabel;
  String? hint;
  String? translatedHint;
  List<InputFieldOption>? options;
  bool? hasSubInputField;
  bool? hasLabelOnly;
  bool? sortOptions;
  InputField? subInputField;
  List<int>? allowedSelectedLevels;
  Pattern? regExpValidation;
  int? limitingNumericLength;
  List<String>? filteredPrograms;

  InputField({
    required this.id,
    required this.name,
    required this.valueType,
    this.hasSubInputField,
    this.description,
    this.inputColor,
    this.labelColor,
    this.background,
    this.renderAsRadio,
    this.isReadOnly,
    this.options,
    this.subInputField,
    this.allowedSelectedLevels,
    this.allowFuturePeriod,
    this.disablePastPeriod,
    this.translatedName,
    this.translatedDescription,
    this.hint,
    this.translatedHint,
    this.maxAgeInYear,
    this.minAgeInYear,
    this.numberOfMonth,
    this.firstDate,
    this.lastDate,
    this.suffixLabel,
    this.filteredPrograms,
    this.hasError,
    this.shouldUserCustomAgeLimit,
    this.showCountryLevelTree,
    this.hasLabelOnly,
    this.regExpValidation,
    this.limitingNumericLength,
    this.sortOptions = true,
  }) {
    showCountryLevelTree = showCountryLevelTree ?? false;
    hasLabelOnly = hasLabelOnly ?? false;
    allowedSelectedLevels = allowedSelectedLevels ?? [];
    allowFuturePeriod = allowFuturePeriod ?? false;
    disablePastPeriod = disablePastPeriod ?? false;
    isReadOnly = isReadOnly ?? false;
    description = description ?? '';
    firstDate = firstDate ?? '';
    lastDate = lastDate ?? '';
    hasSubInputField = hasSubInputField ?? false;
    renderAsRadio = renderAsRadio ?? false;
    options = options ?? [];
    filteredPrograms = filteredPrograms ?? [];
    inputColor = inputColor ?? Colors.black;
    labelColor = labelColor ?? const Color(0xFF1A3518);
    background = background ?? Colors.transparent;
    suffixLabel = suffixLabel ?? '';
    limitingNumericLength = limitingNumericLength ?? 99;
    regExpValidation = regExpValidation ??
        RegExp(['INTEGER_ZERO_OR_POSITIVE', 'NUMBER'].contains(valueType)
            ? '[0-9]'
            : '.*');
  }

  @override
  String toString() {
    return '$id - $name - $isReadOnly';
  }
}
