
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/models/mgysd_case.dart';
import 'package:sqflite/sqflite.dart';

class MgysdSocialInvestigationPage extends StatefulWidget {
  const MgysdSocialInvestigationPage({
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
  State<MgysdSocialInvestigationPage> createState() =>
      _MgysdSocialInvestigationPageState();
}

class _MgysdSocialInvestigationPageState
    extends State<MgysdSocialInvestigationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _investigationDateController =
  TextEditingController();
  final TextEditingController _socialWorkerController =
  TextEditingController();
  final TextEditingController _supervisorController = TextEditingController();
  final TextEditingController _caseDetailsController = TextEditingController();
  final TextEditingController _strengthsController = TextEditingController();
  final TextEditingController _challengesController = TextEditingController();
  final TextEditingController _findingsController = TextEditingController();
  final TextEditingController _recommendationsController =
  TextEditingController();
  final TextEditingController _additionalNotesController =
  TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String _savedStatus = 'NOT_STARTED';

  String? _concernType;
  String? _incidentType;
  String? _clientHealth;
  String? _clientEducation;
  String? _clientEmotionalHealth;
  String? _identityAndSelfEsteem;
  String? _familyBackground;
  String? _caregiverWellbeing;
  String? _extendedFamilySupport;
  String? _clientFamilyRelationships;
  String? _housingCondition;
  String? _communitySafety;
  String? _socialInclusion;
  String? _childVoiceSafety;
  String? _overallRisk;
  String? _investigationOutcome;

  static const List<String> _concernTypeOptions = [
    'Abuse / Violence',
    'Neglect / Care and protection',
    'Health concern',
    'Education concern',
    'Behavioural concern',
    'Psychosocial distress',
    'Disability / Special needs',
    'Household vulnerability',
    'Other',
  ];

  static const List<String> _incidentTypeOptions = [
    'Specific incident',
    'Long-term / ongoing concern',
  ];

  static const List<String> _healthOptions = [
    'Good / Stable',
    'Concerns but receiving support',
    'Fragile / Inconsistent',
    'Significant issues',
  ];

  static const List<String> _educationOptions = [
    'Stable / Good',
    'Reasonable but inconsistent',
    'Ongoing concerns',
    'Significant issues / dropout',
  ];

  static const List<String> _emotionalOptions = [
    'Stable',
    'Mild distress',
    'Moderate distress',
    'Severe distress',
  ];

  static const List<String> _identityOptions = [
    'Positive and confident',
    'Some self-esteem concerns',
    'Low confidence / limited aspirations',
    'Serious identity / self-worth concerns',
  ];

  static const List<String> _familyBackgroundOptions = [
    'Stable',
    'Recent changes',
    'Ongoing challenges',
    'Unpredictable or violent context',
  ];

  static const List<String> _caregiverWellbeingOptions = [
    'In good health / stable',
    'Concerns but receiving support',
    'Fragile / inconsistent',
    'Significant issues',
  ];

  static const List<String> _relationshipOptions = [
    'Stable / Good',
    'Inconsistent',
    'Non-existent / Poor',
  ];

  static const List<String> _housingOptions = [
    'Safe and stable',
    'Adequate',
    'Unsafe',
    'Homeless / unstable',
  ];

  static const List<String> _communitySafetyOptions = [
    'Safe',
    'Moderate risk',
    'High risk',
  ];

  static const List<String> _socialInclusionOptions = [
    'Active and socially engaged',
    'Some involvement',
    'Isolated / poor connections',
  ];

  static const List<String> _childVoiceSafetyOptions = [
    'Feels safe',
    'Feels sometimes unsafe',
    'Feels unsafe',
    'Unable to assess',
  ];

  static const List<String> _overallRiskOptions = [
    'Low',
    'Medium',
    'High',
  ];

  static const List<String> _investigationOutcomeOptions = [
    'Care plan required',
    'Referral required',
    'Monitoring required',
    'Urgent intervention required',
    'No further action required',
  ];

  @override
  void initState() {
    super.initState();
    _investigationDateController.text = _today();
    _loadSavedData();
  }

  @override
  void dispose() {
    _investigationDateController.dispose();
    _socialWorkerController.dispose();
    _supervisorController.dispose();
    _caseDetailsController.dispose();
    _strengthsController.dispose();
    _challengesController.dispose();
    _findingsController.dispose();
    _recommendationsController.dispose();
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
      'investigationDate': _investigationDateController.text.trim(),
      'socialWorker': _socialWorkerController.text.trim(),
      'supervisor': _supervisorController.text.trim(),
      'concernType': _concernType,
      'incidentType': _incidentType,
      'caseDetails': _caseDetailsController.text.trim(),
      'clientHealth': _clientHealth,
      'clientEducation': _clientEducation,
      'clientEmotionalHealth': _clientEmotionalHealth,
      'identityAndSelfEsteem': _identityAndSelfEsteem,
      'familyBackground': _familyBackground,
      'caregiverWellbeing': _caregiverWellbeing,
      'extendedFamilySupport': _extendedFamilySupport,
      'clientFamilyRelationships': _clientFamilyRelationships,
      'housingCondition': _housingCondition,
      'communitySafety': _communitySafety,
      'socialInclusion': _socialInclusion,
      'childVoiceSafety': _childVoiceSafety,
      'overallRisk': _overallRisk,
      'investigationOutcome': _investigationOutcome,
      'strengths': _strengthsController.text.trim(),
      'challenges': _challengesController.text.trim(),
      'findings': _findingsController.text.trim(),
      'recommendations': _recommendationsController.text.trim(),
      'additionalNotes': _additionalNotesController.text.trim(),
    };
  }

  Future<void> _loadSavedData() async {
    try {
      final db = await _db();
      final rows = await db.query(
        'mgysd_social_investigation',
        where: 'id = ?',
        whereArgs: [widget.mgysdCase.id],
        limit: 1,
      );

      if (rows.isNotEmpty) {
        final row = rows.first;
        final payload = jsonDecode((row['payloadJson'] ?? '{}').toString())
        as Map<String, dynamic>;

        _investigationDateController.text =
            (payload['investigationDate'] ?? _today()).toString();
        _socialWorkerController.text =
            (payload['socialWorker'] ?? '').toString();
        _supervisorController.text = (payload['supervisor'] ?? '').toString();
        _caseDetailsController.text = (payload['caseDetails'] ?? '').toString();
        _strengthsController.text = (payload['strengths'] ?? '').toString();
        _challengesController.text = (payload['challenges'] ?? '').toString();
        _findingsController.text = (payload['findings'] ?? '').toString();
        _recommendationsController.text =
            (payload['recommendations'] ?? '').toString();
        _additionalNotesController.text =
            (payload['additionalNotes'] ?? '').toString();

        _concernType = _normalizeDropdownValue(
          payload['concernType'],
          _concernTypeOptions,
        );
        _incidentType = _normalizeDropdownValue(
          payload['incidentType'],
          _incidentTypeOptions,
        );
        _clientHealth = _normalizeDropdownValue(
          payload['clientHealth'],
          _healthOptions,
        );
        _clientEducation = _normalizeDropdownValue(
          payload['clientEducation'],
          _educationOptions,
        );
        _clientEmotionalHealth = _normalizeDropdownValue(
          payload['clientEmotionalHealth'],
          _emotionalOptions,
        );
        _identityAndSelfEsteem = _normalizeDropdownValue(
          payload['identityAndSelfEsteem'],
          _identityOptions,
        );
        _familyBackground = _normalizeDropdownValue(
          payload['familyBackground'],
          _familyBackgroundOptions,
        );
        _caregiverWellbeing = _normalizeDropdownValue(
          payload['caregiverWellbeing'],
          _caregiverWellbeingOptions,
        );
        _extendedFamilySupport = _normalizeDropdownValue(
          payload['extendedFamilySupport'],
          _relationshipOptions,
        );
        _clientFamilyRelationships = _normalizeDropdownValue(
          payload['clientFamilyRelationships'],
          _relationshipOptions,
        );
        _housingCondition = _normalizeDropdownValue(
          payload['housingCondition'],
          _housingOptions,
        );
        _communitySafety = _normalizeDropdownValue(
          payload['communitySafety'],
          _communitySafetyOptions,
        );
        _socialInclusion = _normalizeDropdownValue(
          payload['socialInclusion'],
          _socialInclusionOptions,
        );
        _childVoiceSafety = _normalizeDropdownValue(
          payload['childVoiceSafety'],
          _childVoiceSafetyOptions,
        );
        _overallRisk = _normalizeDropdownValue(
          payload['overallRisk'],
          _overallRiskOptions,
        );
        _investigationOutcome = _normalizeDropdownValue(
          payload['investigationOutcome'],
          _investigationOutcomeOptions,
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

    if (_overallRisk == null || _overallRisk!.trim().isEmpty) {
      _showSnack('Please select the overall risk level.');
      return;
    }

    if (_investigationOutcome == null || _investigationOutcome!.trim().isEmpty) {
      _showSnack('Please select the investigation outcome.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final db = await _db();
      await db.insert(
        'mgysd_social_investigation',
        {
          'id': widget.mgysdCase.id,
          'caseId': widget.mgysdCase.id,
          'householdTei': (widget.householdTei ?? '').trim(),
          'investigationDate': _investigationDateController.text.trim(),
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
            ? 'Social Investigation marked as complete.'
            : 'Social Investigation saved as draft.',
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
              Icons.fact_check_outlined,
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
        title: const Text('Social Investigation'),
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
                    'Investigation context',
                    'Capture when the investigation was conducted and by whom.',
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    _investigationDateController,
                    'Investigation date',
                    readOnly: true,
                    onTap: () =>
                        _pickDate(_investigationDateController),
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Investigation date is required'
                        : null,
                  ),
                  _textField(
                    _socialWorkerController,
                    'Social worker',
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Social worker is required'
                        : null,
                  ),
                  _textField(
                    _supervisorController,
                    'Supervisor',
                  ),
                  _dropdownField(
                    label: 'Type of concern',
                    value: _concernType,
                    items: _concernTypeOptions,
                    onChanged: (value) {
                      setState(() {
                        _concernType = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Concern pattern',
                    value: _incidentType,
                    items: _incidentTypeOptions,
                    onChanged: (value) {
                      setState(() {
                        _incidentType = value;
                      });
                    },
                  ),
                  _textField(
                    _caseDetailsController,
                    'Case details / incident summary',
                    maxLines: 4,
                  ),
                ],
              ),
            ),

            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Client profile',
                    'Use structured ratings for the main client wellbeing areas.',
                  ),
                  const SizedBox(height: 12),
                  _dropdownField(
                    label: 'Client health',
                    value: _clientHealth,
                    items: _healthOptions,
                    onChanged: (value) {
                      setState(() {
                        _clientHealth = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Education',
                    value: _clientEducation,
                    items: _educationOptions,
                    onChanged: (value) {
                      setState(() {
                        _clientEducation = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Emotional health',
                    value: _clientEmotionalHealth,
                    items: _emotionalOptions,
                    onChanged: (value) {
                      setState(() {
                        _clientEmotionalHealth = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Identity / self-esteem',
                    value: _identityAndSelfEsteem,
                    items: _identityOptions,
                    onChanged: (value) {
                      setState(() {
                        _identityAndSelfEsteem = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Child / client voice on safety',
                    value: _childVoiceSafety,
                    items: _childVoiceSafetyOptions,
                    onChanged: (value) {
                      setState(() {
                        _childVoiceSafety = value;
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
                    'Family and environment',
                    'Capture household and community conditions using structured categories.',
                  ),
                  const SizedBox(height: 12),
                  _dropdownField(
                    label: 'Family background',
                    value: _familyBackground,
                    items: _familyBackgroundOptions,
                    onChanged: (value) {
                      setState(() {
                        _familyBackground = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Caregiver wellbeing',
                    value: _caregiverWellbeing,
                    items: _caregiverWellbeingOptions,
                    onChanged: (value) {
                      setState(() {
                        _caregiverWellbeing = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Extended family support',
                    value: _extendedFamilySupport,
                    items: _relationshipOptions,
                    onChanged: (value) {
                      setState(() {
                        _extendedFamilySupport = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Client-family relationships',
                    value: _clientFamilyRelationships,
                    items: _relationshipOptions,
                    onChanged: (value) {
                      setState(() {
                        _clientFamilyRelationships = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Housing condition',
                    value: _housingCondition,
                    items: _housingOptions,
                    onChanged: (value) {
                      setState(() {
                        _housingCondition = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Community safety',
                    value: _communitySafety,
                    items: _communitySafetyOptions,
                    onChanged: (value) {
                      setState(() {
                        _communitySafety = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Social inclusion',
                    value: _socialInclusion,
                    items: _socialInclusionOptions,
                    onChanged: (value) {
                      setState(() {
                        _socialInclusion = value;
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
                    'Assessment summary',
                    'Keep narrative only for professional judgement and key actions.',
                  ),
                  const SizedBox(height: 12),
                  _dropdownField(
                    label: 'Overall risk',
                    value: _overallRisk,
                    items: _overallRiskOptions,
                    onChanged: (value) {
                      setState(() {
                        _overallRisk = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Investigation outcome',
                    value: _investigationOutcome,
                    items: _investigationOutcomeOptions,
                    onChanged: (value) {
                      setState(() {
                        _investigationOutcome = value;
                      });
                    },
                  ),
                  _textField(
                    _strengthsController,
                    'Strengths / protective factors',
                    maxLines: 4,
                  ),
                  _textField(
                    _challengesController,
                    'Challenges / risks identified',
                    maxLines: 4,
                  ),
                  _textField(
                    _findingsController,
                    'Investigation findings',
                    maxLines: 5,
                  ),
                  _textField(
                    _recommendationsController,
                    'Recommendations',
                    maxLines: 4,
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
                    onPressed:
                    _saving ? null : () => _save('COMPLETED'),
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
