
import 'package:flutter/material.dart';
import 'package:kb_mobile_app/models/form_section.dart';
import 'package:kb_mobile_app/models/input_field.dart';

class OvcViralLoadMonitoringConstant {
  // Use your real program stage for monitoring (same stage you save other monitoring to)
  // For HH:
  static const String hhMonitoringProgramStage = 'v9Vrc5exzam'; // <- replace if different
  // For CHILD:
  static const String childMonitoringProgramStage = 'v9Vrc5exzam'; // <- replace if different

  // Data Elements (replace with your real UIDs)
  static const String deArtStartDate = 'DE_ART_START_DATE';
  static const String deBaselineCd4  = 'DE_BASELINE_CD4';
  static const String deArtNumber    = 'DE_ART_NUMBER';
  static const String deCurrentVl    = 'DE_CURRENT_VL';
  static const String deCurrentVlDate= 'DE_CURRENT_VL_DATE';
  static const String deNextVlDue    = 'DE_NEXT_VL_DUE';
  static const String deAdhIssues    = 'DE_MONITORING_ADHERENCE_ISSUES';
  static const String deOnEac        = 'DE_ON_EAC';
  static const String deEacDates     = 'DE_EAC_DATES';
  static const String deFollowupComm = 'DE_ADHERENCE_ISSUES_COMMUNITY';
  static const String deMmd          = 'DE_MMD';
  static const String deNextAppt     = 'DE_NEXT_APPOINTMENT';
  static const String deComment      = 'DE_GENERAL_COMMENT';

  static List<FormSection> getFormSections({Color? color}) {
    final c = color ?? const Color(0xFF4B9F46);
    return [
      FormSection(
        id: 'vl_monitoring',
        name: 'Viral Load Monitoring',
        color: c,
        inputFields: [
          InputField(
            id: deArtStartDate,
            name: 'Start date of ART',
            valueType: 'DATE',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deBaselineCd4,
            name: 'Baseline CD4 count',
            valueType: 'NUMBER',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deArtNumber,
            name: 'ART Number',
            valueType: 'TEXT',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deCurrentVl,
            name: 'Current VL results',
            valueType: 'TEXT',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deCurrentVlDate,
            name: 'Date of VL results',
            valueType: 'DATE',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deNextVlDue,
            name: 'Due date for next VL',
            valueType: 'DATE',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deAdhIssues,
            name: 'Monitoring adherence issues',
            valueType: 'BOOLEAN',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deOnEac,
            name: 'On EAC?',
            valueType: 'BOOLEAN',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deEacDates,
            name: 'Date of EAC sessions',
            valueType: 'TEXT', // use LONG_TEXT if you want multiple dates / notes
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deFollowupComm,
            name: 'Adherence Issues to be followed up at community',
            valueType: 'LONG_TEXT',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deMmd,
            name: 'MMD',
            valueType: 'TEXT',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deNextAppt,
            name: 'Next appointment date',
            valueType: 'DATE',
            inputColor: c,
            labelColor: c,
          ),
          InputField(
            id: deComment,
            name: 'General comment',
            valueType: 'LONG_TEXT',
            inputColor: c,
            labelColor: c,
          ),
        ],
      ),
    ];
  }
}
