import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/models/mgysd_case.dart';
import 'package:sqflite/sqflite.dart';

class MgysdInitialRiskAssessmentPage extends StatefulWidget {
  const MgysdInitialRiskAssessmentPage({
    Key? key,
    required this.color,
    required this.mgysdCase,
    this.householdTei,
    this.householdName,
    this.clientName,
  }) : super(key: key);

  final Color color;
  final MgysdCase mgysdCase;
  final String? householdTei;
  final String? householdName;
  final String? clientName;

  @override
  State<MgysdInitialRiskAssessmentPage> createState() =>
      _MgysdInitialRiskAssessmentPageState();
}

class _MgysdInitialRiskAssessmentPageState
    extends State<MgysdInitialRiskAssessmentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _assessmentDateController =
  TextEditingController();
  final TextEditingController _socialWorkerController =
  TextEditingController();
  final TextEditingController _riskReasonController = TextEditingController();
  final TextEditingController _immediateReferralsController =
  TextEditingController();
  final TextEditingController _additionalNotesController =
  TextEditingController();

  final TextEditingController _familyBackgroundNotesController =
  TextEditingController();
  final TextEditingController _caregiverWellbeingNotesController =
  TextEditingController();
  final TextEditingController _extendedFamilyNotesController =
  TextEditingController();
  final TextEditingController _clientRelationshipsNotesController =
  TextEditingController();
  final TextEditingController _livingCircumstancesNotesController =
  TextEditingController();
  final TextEditingController _housingNotesController = TextEditingController();
  final TextEditingController _physicalHealthNotesController =
  TextEditingController();
  final TextEditingController _nutritionNotesController =
  TextEditingController();
  final TextEditingController _emotionalHealthNotesController =
  TextEditingController();
  final TextEditingController _personalHealthNotesController =
  TextEditingController();
  final TextEditingController _supervisionNotesController =
  TextEditingController();
  final TextEditingController _educationNotesController =
  TextEditingController();



  bool _loading = true;
  bool _saving = false;
  String _savedStatus = 'NOT_STARTED';

  String? _reportSource;
  bool? _hasActionTaken;
  String? _noActionReason;
  String _riskLevel = '';

  final List<String> _emergencyActionsTaken = [];
  final List<String> _servicesAccessed = [];
  final List<String> _nextSteps = [];

  String? _familyBackground;
  String? _caregiverWellbeing;
  String? _extendedFamilyRelationships;
  String? _clientRelationships;
  String? _livingCircumstances;
  String? _housing;
  String? _physicalHealth;
  String? _nutrition;
  String? _emotionalHealth;
  String? _supervision;
  String? _education;

  static const List<String> _reportSourceOptions = [
    'Community member',
    'Teacher',
    'Police',
    'Health facility',
    'Social worker',
    'Family member',
    'Self-report',
    'NGO / Partner',
    'Other',
  ];

  static const List<String> _noActionReasonOptions = [
    'Not required',
    'Refused',
    'Pending assessment',
    'Other',
  ];

  static const List<String> _emergencyActionOptions = [
    'Referral to police / CGPU',
    'Emergency medical services',
    'Place of safety arranged',
    'Removed from home',
    'Counselling / psychosocial first response',
    'Supervisor informed',
    'No immediate action',
  ];

  static const List<String> _servicesAccessedOptions = [
    'Health services',
    'Police services',
    'Psychosocial support',
    'Shelter / place of safety',
    'Transport assistance',
    'Food assistance',
    'Legal support',
  ];

  static const List<String> _nextStepOptions = [
    'Monitor through local contacts',
    'Refer to community services',
    'Further investigation required',
    'Urgent protection action required',
    'Open social investigation',
    'Develop care plan',
  ];

  static const List<String> _familyBackgroundOptions = [
    'Stable',
    'Recent changes',
    'Ongoing challenges',
    'Unpredictable or violent context',
  ];

  static const List<String> _caregiverWellbeingOptions = [
    'In good health/stable',
    'Concerns but receiving support',
    'Fragile/inconsistent',
    'Significant issues',
  ];

  static const List<String> _relationshipOptions = [
    'Stable/Good',
    'Inconsistent',
    'Non-existent/Poor',
  ];

  static const List<String> _livingCircumstancesOptions = [
    'Stable/Good',
    'Safe/Okay',
    'Inconsistent',
    'Unstable/Unsafe',
  ];

  static const List<String> _housingOptions = [
    'Stable/Good',
    'Safe/Sufficient',
    'Inconsistent',
    'Not habitable',
  ];

  static const List<String> _physicalHealthOptions = [
    'In good health/stable',
    'Health/Wellbeing concerns but receiving support',
    'Fragile/inconsistent',
    'Significant issues',
  ];

  static const List<String> _nutritionOptions = [
    'Stable/Good',
    'Inconsistent',
    'Poor',
  ];

  static const List<String> _emotionalHealthOptions = [
    'In good health/stable',
    'Mental or wellbeing concerns but receiving support',
    'Fragile/inconsistent',
    'Significant issues/poor',
  ];

  static const List<String> _supervisionOptions = [
    'Well supervised/supported',
    'Basic support but often left alone',
    'Significant issues/unsafe supervision',
  ];

  static const List<String> _educationOptions = [
    'Stable/Good',
    'Reasonable but inconsistent',
    'Ongoing concerns',
    'Significant issues/dropout',
  ];

  @override
  void initState() {
    super.initState();
    _assessmentDateController.text = _today();
    _loadSavedData();
  }

  @override
  void dispose() {
    _assessmentDateController.dispose();
    _socialWorkerController.dispose();
    _riskReasonController.dispose();
    _immediateReferralsController.dispose();
    _additionalNotesController.dispose();

    _familyBackgroundNotesController.dispose();
    _caregiverWellbeingNotesController.dispose();
    _extendedFamilyNotesController.dispose();
    _clientRelationshipsNotesController.dispose();
    _livingCircumstancesNotesController.dispose();
    _housingNotesController.dispose();
    _physicalHealthNotesController.dispose();
    _nutritionNotesController.dispose();
    _emotionalHealthNotesController.dispose();
    _personalHealthNotesController.dispose();
    _supervisionNotesController.dispose();
    _educationNotesController.dispose();

    super.dispose();
  }

  Future<Database> _db() async {
    final dbClient = await OfflineDbProvider().db;
    if (dbClient == null) {
      throw Exception('Offline DB not initialized');
    }
    return dbClient;
  }

  String _today() {
    final now = DateTime.now();
    return _formatDate(now);
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final initial = DateTime.tryParse(controller.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = _formatDate(picked);
      });
    }
  }

  String? _normalizeDropdownValue(dynamic raw, List<String> options) {
    if (raw == null) return null;
    final value = raw.toString().trim();
    if (value.isEmpty) return null;
    if (!options.contains(value)) return null;
    return value;
  }

  List<String> _normalizeMultiSelectValues(
      dynamic raw,
      List<String> options,
      ) {
    if (raw is! List) return [];
    return raw
        .map((e) => e.toString().trim())
        .where((value) => value.isNotEmpty && options.contains(value))
        .toSet()
        .toList();
  }

  Map<String, dynamic> _payload() {
    return {
      'assessmentDate': _assessmentDateController.text.trim(),
      'socialWorker': _socialWorkerController.text.trim(),
      'reportSource': _reportSource,
      'hasActionTaken': _hasActionTaken,
      'noActionReason': _noActionReason,
      'emergencyActionsTaken': _emergencyActionsTaken,
      'servicesAccessed': _servicesAccessed,
      'familyBackground': _familyBackground,
      'familyBackgroundNotes': _familyBackgroundNotesController.text.trim(),
      'caregiverWellbeing': _caregiverWellbeing,
      'caregiverWellbeingNotes': _caregiverWellbeingNotesController.text.trim(),
      'extendedFamilyRelationships': _extendedFamilyRelationships,
      'extendedFamilyNotes': _extendedFamilyNotesController.text.trim(),
      'clientRelationships': _clientRelationships,
      'clientRelationshipsNotes': _clientRelationshipsNotesController.text.trim(),
      'livingCircumstances': _livingCircumstances,
      'livingCircumstancesNotes': _livingCircumstancesNotesController.text.trim(),
      'housing': _housing,
      'housingNotes': _housingNotesController.text.trim(),
      'physicalHealth': _physicalHealth,
      'physicalHealthNotes': _physicalHealthNotesController.text.trim(),
      'nutrition': _nutrition,
      'nutritionNotes': _nutritionNotesController.text.trim(),
      'emotionalHealth': _emotionalHealth,
      'emotionalHealthNotes': _emotionalHealthNotesController.text.trim(),
      'supervision': _supervision,
      'supervisionNotes': _supervisionNotesController.text.trim(),
      'education': _education,
      'educationNotes': _educationNotesController.text.trim(),
      'riskLevel': _riskLevel,
      'riskReason': _riskReasonController.text.trim(),
      'immediateReferrals': _immediateReferralsController.text.trim(),
      'nextSteps': _nextSteps,
      'additionalNotes': _additionalNotesController.text.trim(),
    };
  }

  Future<void> _loadSavedData() async {
    try {
      final db = await _db();
      final rows = await db.query(
        'mgysd_initial_risk_assessment',
        where: 'id = ?',
        whereArgs: [widget.mgysdCase.id],
        limit: 1,
      );

      if (rows.isNotEmpty) {
        final row = rows.first;
        final payload = jsonDecode((row['payloadJson'] ?? '{}').toString())
        as Map<String, dynamic>;

        _assessmentDateController.text =
            (payload['assessmentDate'] ?? _today()).toString();
        _socialWorkerController.text =
            (payload['socialWorker'] ?? '').toString();

        _reportSource =
            _normalizeDropdownValue(payload['reportSource'], _reportSourceOptions);

        _hasActionTaken = payload['hasActionTaken'] is bool
            ? payload['hasActionTaken'] as bool
            : (payload['hasActionTaken']?.toString() == 'true');

        _noActionReason = _normalizeDropdownValue(
          payload['noActionReason'],
          _noActionReasonOptions,
        );

        _emergencyActionsTaken
          ..clear()
          ..addAll(
            _normalizeMultiSelectValues(
              payload['emergencyActionsTaken'],
              _emergencyActionOptions,
            ),
          );

        _servicesAccessed
          ..clear()
          ..addAll(
            _normalizeMultiSelectValues(
              payload['servicesAccessed'],
              _servicesAccessedOptions,
            ),
          );

        _familyBackground = _normalizeDropdownValue(
          payload['familyBackground'],
          _familyBackgroundOptions,
        );
        _familyBackgroundNotesController.text =
            (payload['familyBackgroundNotes'] ?? '').toString();

        _caregiverWellbeing = _normalizeDropdownValue(
          payload['caregiverWellbeing'],
          _caregiverWellbeingOptions,
        );
        _caregiverWellbeingNotesController.text =
            (payload['caregiverWellbeingNotes'] ?? '').toString();

        _extendedFamilyRelationships = _normalizeDropdownValue(
          payload['extendedFamilyRelationships'],
          _relationshipOptions,
        );
        _extendedFamilyNotesController.text =
            (payload['extendedFamilyNotes'] ?? '').toString();

        _clientRelationships = _normalizeDropdownValue(
          payload['clientRelationships'],
          _relationshipOptions,
        );
        _clientRelationshipsNotesController.text =
            (payload['clientRelationshipsNotes'] ?? '').toString();

        _livingCircumstances = _normalizeDropdownValue(
          payload['livingCircumstances'],
          _livingCircumstancesOptions,
        );
        _livingCircumstancesNotesController.text =
            (payload['livingCircumstancesNotes'] ?? '').toString();

        _housing = _normalizeDropdownValue(payload['housing'], _housingOptions);
        _housingNotesController.text =
            (payload['housingNotes'] ?? '').toString();

        _physicalHealth = _normalizeDropdownValue(
          payload['physicalHealth'],
          _physicalHealthOptions,
        );
        _physicalHealthNotesController.text =
            (payload['physicalHealthNotes'] ?? '').toString();

        _nutrition = _normalizeDropdownValue(
          payload['nutrition'],
          _nutritionOptions,
        );
        _nutritionNotesController.text =
            (payload['nutritionNotes'] ?? '').toString();

        _emotionalHealth = _normalizeDropdownValue(
          payload['emotionalHealth'],
          _emotionalHealthOptions,
        );
        _emotionalHealthNotesController.text =
            (payload['emotionalHealthNotes'] ?? '').toString();

        _supervision = _normalizeDropdownValue(
          payload['supervision'],
          _supervisionOptions,
        );
        _supervisionNotesController.text =
            (payload['supervisionNotes'] ?? '').toString();

        _education = _normalizeDropdownValue(
          payload['education'],
          _educationOptions,
        );
        _educationNotesController.text =
            (payload['educationNotes'] ?? '').toString();

        _riskLevel = (payload['riskLevel'] ?? '').toString().trim();
        _riskReasonController.text = (payload['riskReason'] ?? '').toString();
        _immediateReferralsController.text =
            (payload['immediateReferrals'] ?? '').toString();

        _nextSteps
          ..clear()
          ..addAll(
            _normalizeMultiSelectValues(
              payload['nextSteps'],
              _nextStepOptions,
            ),
          );

        _additionalNotesController.text =
            (payload['additionalNotes'] ?? '').toString();

        _savedStatus = (row['status'] ?? 'DRAFT').toString();
      }
    } catch (_) {
      // ignore and start blank
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _save(String status) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_riskLevel.trim().isEmpty) {
      _showSnack('Please select the level of risk.');
      return;
    }

    if (_hasActionTaken == null) {
      _showSnack('Please indicate whether any emergency action was taken.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final db = await _db();
      await db.insert(
        'mgysd_initial_risk_assessment',
        {
          'id': widget.mgysdCase.id,
          'caseId': widget.mgysdCase.id,
          'householdTei': (widget.householdTei ?? '').trim(),
          'assessmentDate': _assessmentDateController.text.trim(),
          'riskLevel': _riskLevel,
          'status': status,
          'payloadJson': jsonEncode(_payload()),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (!mounted) return;
      setState(() {
        _savedStatus = status;
      });

      _showSnack(
        status == 'COMPLETED'
            ? 'Initial Risk Assessment marked as complete.'
            : 'Initial Risk Assessment saved as draft.',
      );
    } catch (e) {
      _showSnack('Failed to save form: $e');
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _statusChip() {
    final String label;
    final Color color;
    switch (_savedStatus) {
      case 'COMPLETED':
        label = 'Completed';
        color = Colors.green;
        break;
      case 'DRAFT':
        label = 'Draft';
        color = Colors.orange;
        break;
      default:
        label = 'Not started';
        color = Colors.blueGrey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _surface({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }

  Widget _textField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
        String? Function(String?)? validator,
        bool readOnly = false,
        VoidCallback? onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: const Color(0xFFF9FBFD),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    final safeValue = (value != null && items.contains(value)) ? value : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: safeValue,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: const Color(0xFFF9FBFD),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          ),
        )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _rapidRiskItem({
    required String title,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
    required TextEditingController notesController,
    bool requiredField = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            requiredField ? '$title *' : title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _dropdownField(
            label: 'Initial rapid strengths and risks assessed',
            value: value,
            items: options,
            onChanged: onChanged,
            validator: requiredField
                ? (selected) => selected == null || selected.trim().isEmpty
                ? 'Please select an option'
                : null
                : null,
          ),
          _textField(
            notesController,
            'Notes / supporting evidence',
            maxLines: 3,
          ),
        ],
      ),
    );
  }



  Widget _binaryChoice({
    required String label,
    required bool? value,
    required void Function(bool?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                dense: true,
                title: const Text('Yes'),
                value: true,
                groupValue: value,
                activeColor: widget.color,
                onChanged: onChanged,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                dense: true,
                title: const Text('No'),
                value: false,
                groupValue: value,
                activeColor: widget.color,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _multiSelectSection({
    required String title,
    required List<String> options,
    required List<String> selectedValues,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...options.map(
                (option) => CheckboxListTile(
              value: selectedValues.contains(option),
              contentPadding: EdgeInsets.zero,
              activeColor: widget.color,
              title: Text(option),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    if (!selectedValues.contains(option)) {
                      selectedValues.add(option);
                    }
                  } else {
                    selectedValues.remove(option);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _riskChoice(String value, String label) {
    final selected = _riskLevel == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: widget.color.withOpacity(0.18),
      labelStyle: TextStyle(
        color: selected ? widget.color : Colors.black87,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      onSelected: (_) {
        setState(() {
          _riskLevel = value;
        });
      },
    );
  }

  Widget _riskLevelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Decision on level of risk',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _riskChoice('LOW', 'No / Low Risk'),
            _riskChoice('MEDIUM', 'Medium Risk'),
            _riskChoice('HIGH', 'High Risk'),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientName = (widget.clientName ?? widget.mgysdCase.fullName).trim();
    final householdName = (widget.householdName ?? '').trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: widget.color,
        title: const Text('Initial Risk Assessment'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _surface(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientName.isEmpty
                              ? widget.mgysdCase.caseNo
                              : clientName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Case No: ${widget.mgysdCase.caseNo}',
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (householdName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Household: $householdName',
                            style: const TextStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _statusChip(),
                ],
              ),
            ),

            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Part 4: Initial rapid risk assessment',
                    'Where emergency action is urgently required to safeguard a child/person with disability and elderly person/client life or safety, this information can be identified after taking action. It is important to note as much information as possible to inform the risk assessment and decision.',
                  ),
                ],
              ),
            ),

            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildSectionTitle(
                  //   'Part 4: Initial rapid risk assessment',
                  //   'Where emergency action is urgently required to safeguard a child / person with disability / elderly person / client life or safety, this information can be identified after taking action. It is important to note as much information as possible to inform the risk assessment and decision. See guidance notes for detail on these questions.',
                  // ),
                  const SizedBox(height: 14),
                  const Text(
                    'Family profile and impact on client',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _rapidRiskItem(
                    title: 'Family background and composition',
                    value: _familyBackground,
                    options: _familyBackgroundOptions,
                    onChanged: (value) {
                      setState(() {
                        _familyBackground = value;
                      });
                    },
                    notesController: _familyBackgroundNotesController,
                  ),
                  _rapidRiskItem(
                    title:
                    'Parent/caregiver/guardian/ personal assistant health & wellbeing',
                    value: _caregiverWellbeing,
                    options: _caregiverWellbeingOptions,
                    onChanged: (value) {
                      setState(() {
                        _caregiverWellbeing = value;
                      });
                    },
                    notesController: _caregiverWellbeingNotesController,
                  ),
                  _rapidRiskItem(
                    title: 'Extended family relationships',
                    value: _extendedFamilyRelationships,
                    options: _relationshipOptions,
                    onChanged: (value) {
                      setState(() {
                        _extendedFamilyRelationships = value;
                      });
                    },
                    notesController: _extendedFamilyNotesController,
                  ),
                  _rapidRiskItem(
                    title:
                    'Client relationships with household members',
                    value: _clientRelationships,
                    options: _relationshipOptions,
                    onChanged: (value) {
                      setState(() {
                        _clientRelationships = value;
                      });
                    },
                    notesController: _clientRelationshipsNotesController,
                  ),
                  _rapidRiskItem(
                    title: 'Present living circumstances',
                    value: _livingCircumstances,
                    options: _livingCircumstancesOptions,
                    onChanged: (value) {
                      setState(() {
                        _livingCircumstances = value;
                      });
                    },
                    notesController: _livingCircumstancesNotesController,
                  ),

                  const Text(
                    'Physical Environment',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),


                  _rapidRiskItem(
                    title: 'Housing (type, size, ownership, water & sanitation and physical accessibility)',
                    value: _housing,
                    options: _housingOptions,
                    onChanged: (value) {
                      setState(() {
                        _housing = value;
                      });
                    },
                    notesController: _housingNotesController,
                  ),

                  const Text(
                    "Client's physical and social circumstances",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _rapidRiskItem(
                    title:
                    "Client's Physical health",
                    value: _physicalHealth,
                    options: _physicalHealthOptions,
                    onChanged: (value) {
                      setState(() {
                        _physicalHealth = value;
                      });
                    },
                    notesController: _physicalHealthNotesController,
                  ),

                  _rapidRiskItem(
                    title: "Client's nutritional state",
                    value: _nutrition,
                    options: _nutritionOptions,
                    onChanged: (value) {
                      setState(() {
                        _nutrition = value;
                      });
                    },
                    notesController: _nutritionNotesController,
                  ),
                  _rapidRiskItem(
                    title: "Client's emotional health",
                    value: _emotionalHealth,
                    options: _emotionalHealthOptions,
                    onChanged: (value) {
                      setState(() {
                        _emotionalHealth = value;
                      });
                    },
                    notesController: _emotionalHealthNotesController,
                  ),

                  _rapidRiskItem(
                    title: 'Supervision and support',
                    value: _supervision,
                    options: _supervisionOptions,
                    onChanged: (value) {
                      setState(() {
                        _supervision = value;
                      });
                    },
                    notesController: _supervisionNotesController,
                  ),

                  _rapidRiskItem(
                    title:
                    'Education (abilities / problems, achievement)',
                    value: _education,
                    options: _educationOptions,
                    onChanged: (value) {
                      setState(() {
                        _education = value;
                      });
                    },
                    notesController: _educationNotesController,
                  ),


                ],
              ),
            ),

            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Part 5: Risk decision and next steps',
                    'Classify the level of risk and record why.',
                  ),
                  const SizedBox(height: 12),
                  _riskLevelField(),
                  const SizedBox(height: 12),
                  _textField(
                    _riskReasonController,
                    'Reason for selected risk level',
                    maxLines: 4,
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Please explain the selected risk level'
                        : null,
                  ),
                  _textField(
                    _immediateReferralsController,
                    'Immediate referrals made',
                    maxLines: 3,
                  ),
                  // _multiSelectSection(
                  //   title: 'Immediate next steps',
                  //   options: _nextStepOptions,
                  //   selectedValues: _nextSteps,
                  // ),
                  _textField(
                    _additionalNotesController,
                    'Additional notes',
                    maxLines: 4,
                  ),
                ],
              ),
            ),

            // _surface(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       _buildSectionTitle(
            //         'Decision on level of risk and next steps',
            //         'Identify the level of risk based on the information collected and record the reason for the decision.',
            //       ),
            //       const SizedBox(height: 12),
            //       _riskLevelField(),
            //       const SizedBox(height: 10),
            //       const Text(
            //         'No/low risk: Monitor the situation through local contact and refer where necessary.\n'
            //             'Medium/high risk: Further investigation required. Client is in a safe space while further investigation is done.\n'
            //             'High risk: Further intervention and support required while client is in a safe space.',
            //         style: TextStyle(
            //           color: Colors.blueGrey,
            //           fontSize: 12.5,
            //           height: 1.35,
            //         ),
            //       ),
            //       const SizedBox(height: 12),
            //       _textField(
            //         _riskReasonController,
            //         'Briefly explain your observations and reason for selecting option',
            //         maxLines: 4,
            //         validator: (value) =>
            //         (value == null || value.trim().isEmpty)
            //             ? 'Please explain the selected risk level'
            //             : null,
            //       ),
            //       _textField(
            //         _immediateReferralsController,
            //         'Note any referrals made / further action required using the referral form',
            //         maxLines: 3,
            //       ),
            //       _textField(
            //         _additionalNotesController,
            //         'Additional notes',
            //         maxLines: 3,
            //       ),
            //     ],
            //   ),
            // ),


            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => _save('DRAFT'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: widget.color),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save Draft'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saving ? null : () => _save('COMPLETED'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_saving ? 'Saving...' : 'Mark Complete'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
