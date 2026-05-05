
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/models/mgysd_case.dart';
import 'package:sqflite/sqflite.dart';

class MgysdCarePlanPage extends StatefulWidget {
  const MgysdCarePlanPage({
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
  State<MgysdCarePlanPage> createState() => _MgysdCarePlanPageState();
}

class _MgysdCarePlanPageState extends State<MgysdCarePlanPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _planDateController = TextEditingController();
  final TextEditingController _preparedByController = TextEditingController();
  final TextEditingController _goalSummaryController = TextEditingController();
  final TextEditingController _priorityNeedDetailsController =
  TextEditingController();
  final TextEditingController _plannedInterventionsController =
  TextEditingController();
  final TextEditingController _responsiblePersonController =
  TextEditingController();
  final TextEditingController _targetDateController = TextEditingController();
  final TextEditingController _reviewDateController = TextEditingController();
  final TextEditingController _expectedOutcomeController =
  TextEditingController();
  final TextEditingController _barriersController = TextEditingController();
  final TextEditingController _additionalNotesController =
  TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String _savedStatus = 'NOT_STARTED';

  String? _priorityNeedCategory;
  String? _riskLevelAtPlanning;
  String? _serviceArea;
  String? _interventionType;
  String? _frequency;
  String? _responsiblePartyType;
  String? _followUpMode;
  String? _casePlanOutcome;

  static const List<String> _priorityNeedCategoryOptions = [
    'Protection / Safety',
    'Psychosocial support',
    'Health',
    'Education',
    'Nutrition / Food security',
    'Shelter / Housing',
    'Economic strengthening',
    'Parenting / Caregiver support',
    'Legal / Documentation',
    'Disability support',
    'Other',
  ];

  static const List<String> _riskLevelOptions = [
    'Low',
    'Medium',
    'High',
  ];

  static const List<String> _serviceAreaOptions = [
    'Protection services',
    'Psychosocial services',
    'Health services',
    'Education support',
    'Nutrition support',
    'Shelter support',
    'Economic support',
    'Parenting support',
    'Legal support',
    'Disability support',
    'Multi-sectoral support',
  ];

  static const List<String> _interventionTypeOptions = [
    'Direct case management',
    'Referral',
    'Home visit',
    'Counselling session',
    'Material support',
    'School support',
    'Health linkage',
    'Family mediation',
    'Safety planning',
    'Follow-up visit',
  ];

  static const List<String> _frequencyOptions = [
    'One-time',
    'Weekly',
    'Bi-weekly',
    'Monthly',
    'As needed',
  ];

  static const List<String> _responsiblePartyTypeOptions = [
    'Social worker',
    'Caregiver',
    'Client',
    'Household member',
    'Partner organization',
    'Health facility',
    'School',
    'Police / Justice',
    'Community structure',
    'Other',
  ];

  static const List<String> _followUpModeOptions = [
    'Phone follow-up',
    'Home visit',
    'Office review',
    'Partner feedback',
    'Community follow-up',
  ];

  static const List<String> _casePlanOutcomeOptions = [
    'Draft care plan',
    'Active care plan',
    'Requires supervisor review',
    'Ready for implementation',
  ];

  @override
  void initState() {
    super.initState();
    _planDateController.text = _today();
    _loadSavedData();
  }

  @override
  void dispose() {
    _planDateController.dispose();
    _preparedByController.dispose();
    _goalSummaryController.dispose();
    _priorityNeedDetailsController.dispose();
    _plannedInterventionsController.dispose();
    _responsiblePersonController.dispose();
    _targetDateController.dispose();
    _reviewDateController.dispose();
    _expectedOutcomeController.dispose();
    _barriersController.dispose();
    _additionalNotesController.dispose();
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

  Map<String, dynamic> _payload() {
    return {
      'planDate': _planDateController.text.trim(),
      'preparedBy': _preparedByController.text.trim(),
      'goalSummary': _goalSummaryController.text.trim(),
      'priorityNeedCategory': _priorityNeedCategory,
      'priorityNeedDetails': _priorityNeedDetailsController.text.trim(),
      'riskLevelAtPlanning': _riskLevelAtPlanning,
      'serviceArea': _serviceArea,
      'interventionType': _interventionType,
      'plannedInterventions': _plannedInterventionsController.text.trim(),
      'frequency': _frequency,
      'responsiblePartyType': _responsiblePartyType,
      'responsiblePerson': _responsiblePersonController.text.trim(),
      'targetDate': _targetDateController.text.trim(),
      'reviewDate': _reviewDateController.text.trim(),
      'expectedOutcome': _expectedOutcomeController.text.trim(),
      'followUpMode': _followUpMode,
      'barriers': _barriersController.text.trim(),
      'casePlanOutcome': _casePlanOutcome,
      'additionalNotes': _additionalNotesController.text.trim(),
    };
  }

  Future<void> _loadSavedData() async {
    try {
      final db = await _db();
      final rows = await db.query(
        'mgysd_care_plan',
        where: 'id = ?',
        whereArgs: [widget.mgysdCase.id],
        limit: 1,
      );

      if (rows.isNotEmpty) {
        final row = rows.first;
        final payload = jsonDecode((row['payloadJson'] ?? '{}').toString())
        as Map<String, dynamic>;

        _planDateController.text =
            (payload['planDate'] ?? _today()).toString();
        _preparedByController.text = (payload['preparedBy'] ?? '').toString();
        _goalSummaryController.text =
            (payload['goalSummary'] ?? '').toString();
        _priorityNeedDetailsController.text =
            (payload['priorityNeedDetails'] ?? '').toString();
        _plannedInterventionsController.text =
            (payload['plannedInterventions'] ?? '').toString();
        _responsiblePersonController.text =
            (payload['responsiblePerson'] ?? '').toString();
        _targetDateController.text = (payload['targetDate'] ?? '').toString();
        _reviewDateController.text = (payload['reviewDate'] ?? '').toString();
        _expectedOutcomeController.text =
            (payload['expectedOutcome'] ?? '').toString();
        _barriersController.text = (payload['barriers'] ?? '').toString();
        _additionalNotesController.text =
            (payload['additionalNotes'] ?? '').toString();

        _priorityNeedCategory = _normalizeDropdownValue(
          payload['priorityNeedCategory'],
          _priorityNeedCategoryOptions,
        );
        _riskLevelAtPlanning = _normalizeDropdownValue(
          payload['riskLevelAtPlanning'],
          _riskLevelOptions,
        );
        _serviceArea = _normalizeDropdownValue(
          payload['serviceArea'],
          _serviceAreaOptions,
        );
        _interventionType = _normalizeDropdownValue(
          payload['interventionType'],
          _interventionTypeOptions,
        );
        _frequency = _normalizeDropdownValue(
          payload['frequency'],
          _frequencyOptions,
        );
        _responsiblePartyType = _normalizeDropdownValue(
          payload['responsiblePartyType'],
          _responsiblePartyTypeOptions,
        );
        _followUpMode = _normalizeDropdownValue(
          payload['followUpMode'],
          _followUpModeOptions,
        );
        _casePlanOutcome = _normalizeDropdownValue(
          payload['casePlanOutcome'],
          _casePlanOutcomeOptions,
        );

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

    if (_priorityNeedCategory == null || _priorityNeedCategory!.trim().isEmpty) {
      _showSnack('Please select the priority need category.');
      return;
    }

    if (_serviceArea == null || _serviceArea!.trim().isEmpty) {
      _showSnack('Please select the service area.');
      return;
    }

    if (_interventionType == null || _interventionType!.trim().isEmpty) {
      _showSnack('Please select the intervention type.');
      return;
    }

    if (_casePlanOutcome == null || _casePlanOutcome!.trim().isEmpty) {
      _showSnack('Please select the care plan outcome.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final db = await _db();
      await db.insert(
        'mgysd_care_plan',
        {
          'id': widget.mgysdCase.id,
          'caseId': widget.mgysdCase.id,
          'householdTei': (widget.householdTei ?? '').trim(),
          'planDate': _planDateController.text.trim(),
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
            ? 'Care Plan marked as complete.'
            : 'Care Plan saved as draft.',
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildHeaderCard(String clientName, String householdName) {
    return _surface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: widget.color.withOpacity(0.12),
            child: Icon(
              Icons.assignment_outlined,
              color: widget.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clientName.isEmpty ? widget.mgysdCase.caseNo : clientName,
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
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.5,
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
        bool readOnly = false,
        VoidCallback? onTap,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
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

  @override
  Widget build(BuildContext context) {
    final clientName = (widget.clientName ?? widget.mgysdCase.fullName).trim();
    final householdName = (widget.householdName ?? '').trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: widget.color,
        title: const Text('Care Plan'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeaderCard(clientName, householdName),
            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Care plan context',
                    'Capture when the plan was prepared and who prepared it.',
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    _planDateController,
                    'Plan date',
                    readOnly: true,
                    onTap: () => _pickDate(_planDateController),
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Plan date is required'
                        : null,
                  ),
                  _textField(
                    _preparedByController,
                    'Prepared by',
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Prepared by is required'
                        : null,
                  ),
                  _dropdownField(
                    label: 'Risk level at planning',
                    value: _riskLevelAtPlanning,
                    items: _riskLevelOptions,
                    onChanged: (value) {
                      setState(() {
                        _riskLevelAtPlanning = value;
                      });
                    },
                  ),
                  _textField(
                    _goalSummaryController,
                    'Overall goal summary',
                    maxLines: 3,
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Overall goal summary is required'
                        : null,
                  ),
                ],
              ),
            ),
            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Priority need and intervention planning',
                    'Define the main need and the intervention approach.',
                  ),
                  const SizedBox(height: 12),
                  _dropdownField(
                    label: 'Priority need category',
                    value: _priorityNeedCategory,
                    items: _priorityNeedCategoryOptions,
                    onChanged: (value) {
                      setState(() {
                        _priorityNeedCategory = value;
                      });
                    },
                  ),
                  _textField(
                    _priorityNeedDetailsController,
                    'Priority need details',
                    maxLines: 3,
                  ),
                  _dropdownField(
                    label: 'Service area',
                    value: _serviceArea,
                    items: _serviceAreaOptions,
                    onChanged: (value) {
                      setState(() {
                        _serviceArea = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Intervention type',
                    value: _interventionType,
                    items: _interventionTypeOptions,
                    onChanged: (value) {
                      setState(() {
                        _interventionType = value;
                      });
                    },
                  ),
                  _textField(
                    _plannedInterventionsController,
                    'Planned interventions / actions',
                    maxLines: 4,
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Planned interventions are required'
                        : null,
                  ),
                  _dropdownField(
                    label: 'Frequency',
                    value: _frequency,
                    items: _frequencyOptions,
                    onChanged: (value) {
                      setState(() {
                        _frequency = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Responsibility and follow-up',
                    'Capture who is responsible and when follow-up should happen.',
                  ),
                  const SizedBox(height: 12),
                  _dropdownField(
                    label: 'Responsible party type',
                    value: _responsiblePartyType,
                    items: _responsiblePartyTypeOptions,
                    onChanged: (value) {
                      setState(() {
                        _responsiblePartyType = value;
                      });
                    },
                  ),
                  _textField(
                    _responsiblePersonController,
                    'Responsible person / institution',
                    maxLines: 2,
                  ),
                  _textField(
                    _targetDateController,
                    'Target completion date',
                    readOnly: true,
                    onTap: () => _pickDate(_targetDateController),
                  ),
                  _textField(
                    _reviewDateController,
                    'Review date',
                    readOnly: true,
                    onTap: () => _pickDate(_reviewDateController),
                  ),
                  _dropdownField(
                    label: 'Follow-up mode',
                    value: _followUpMode,
                    items: _followUpModeOptions,
                    onChanged: (value) {
                      setState(() {
                        _followUpMode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Expected results',
                    'Document expected outcomes, barriers, and current care plan status.',
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    _expectedOutcomeController,
                    'Expected outcome',
                    maxLines: 3,
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Expected outcome is required'
                        : null,
                  ),
                  _textField(
                    _barriersController,
                    'Potential barriers / risks',
                    maxLines: 3,
                  ),
                  _dropdownField(
                    label: 'Care plan outcome',
                    value: _casePlanOutcome,
                    items: _casePlanOutcomeOptions,
                    onChanged: (value) {
                      setState(() {
                        _casePlanOutcome = value;
                      });
                    },
                  ),
                  _textField(
                    _additionalNotesController,
                    'Additional notes',
                    maxLines: 4,
                  ),
                ],
              ),
            ),
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

