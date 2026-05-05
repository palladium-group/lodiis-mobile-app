
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/models/mgysd_case.dart';
import 'package:sqflite/sqflite.dart';

class MgysdReferralPage extends StatefulWidget {
  const MgysdReferralPage({
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
  State<MgysdReferralPage> createState() => _MgysdReferralPageState();
}

class _MgysdReferralPageState extends State<MgysdReferralPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _referralDateController = TextEditingController();
  final TextEditingController _referredByController = TextEditingController();
  final TextEditingController _organizationNameController =
  TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _reasonForReferralController =
  TextEditingController();
  final TextEditingController _serviceDetailsController =
  TextEditingController();
  final TextEditingController _appointmentDateController =
  TextEditingController();
  final TextEditingController _feedbackDateController = TextEditingController();
  final TextEditingController _outcomeNotesController = TextEditingController();
  final TextEditingController _barriersController = TextEditingController();
  final TextEditingController _additionalNotesController =
  TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String _savedStatus = 'NOT_STARTED';

  String? _referralCategory;
  String? _serviceUrgency;
  String? _serviceProviderType;
  String? _referralMethod;
  String? _referralStatus;
  String? _feedbackStatus;
  String? _caseDecisionAfterReferral;

  static const List<String> _referralCategoryOptions = [
    'Protection services',
    'Psychosocial support',
    'Health services',
    'Education support',
    'Nutrition support',
    'Shelter support',
    'Economic support',
    'Legal support',
    'Disability support',
    'Parenting support',
    'Other',
  ];

  static const List<String> _serviceUrgencyOptions = [
    'Routine',
    'Priority',
    'Urgent',
  ];

  static const List<String> _serviceProviderTypeOptions = [
    'Government department',
    'Health facility',
    'School',
    'Police / Justice',
    'NGO / Partner',
    'Community structure',
    'Faith-based organization',
    'Private provider',
    'Other',
  ];

  static const List<String> _referralMethodOptions = [
    'Written referral',
    'Phone call',
    'Escorted referral',
    'Verbal instruction',
    'Electronic referral',
  ];

  static const List<String> _referralStatusOptions = [
    'Prepared',
    'Sent',
    'Received by provider',
    'Completed',
    'Not completed',
  ];

  static const List<String> _feedbackStatusOptions = [
    'Awaiting feedback',
    'Feedback received',
    'Client did not attend',
    'Service unavailable',
    'Follow-up needed',
  ];

  static const List<String> _caseDecisionAfterReferralOptions = [
    'Continue case management',
    'Continue monitoring',
    'Additional referral needed',
    'Escalate case',
    'Ready for closure',
  ];

  @override
  void initState() {
    super.initState();
    _referralDateController.text = _today();
    _loadSavedData();
  }

  @override
  void dispose() {
    _referralDateController.dispose();
    _referredByController.dispose();
    _organizationNameController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _reasonForReferralController.dispose();
    _serviceDetailsController.dispose();
    _appointmentDateController.dispose();
    _feedbackDateController.dispose();
    _outcomeNotesController.dispose();
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
      'referralDate': _referralDateController.text.trim(),
      'referredBy': _referredByController.text.trim(),
      'referralCategory': _referralCategory,
      'serviceUrgency': _serviceUrgency,
      'serviceProviderType': _serviceProviderType,
      'organizationName': _organizationNameController.text.trim(),
      'contactPerson': _contactPersonController.text.trim(),
      'contactPhone': _contactPhoneController.text.trim(),
      'reasonForReferral': _reasonForReferralController.text.trim(),
      'serviceDetails': _serviceDetailsController.text.trim(),
      'referralMethod': _referralMethod,
      'appointmentDate': _appointmentDateController.text.trim(),
      'referralStatus': _referralStatus,
      'feedbackStatus': _feedbackStatus,
      'feedbackDate': _feedbackDateController.text.trim(),
      'outcomeNotes': _outcomeNotesController.text.trim(),
      'barriers': _barriersController.text.trim(),
      'caseDecisionAfterReferral': _caseDecisionAfterReferral,
      'additionalNotes': _additionalNotesController.text.trim(),
    };
  }

  Future<void> _loadSavedData() async {
    try {
      final db = await _db();
      final rows = await db.query(
        'mgysd_referral',
        where: 'id = ?',
        whereArgs: [widget.mgysdCase.id],
        limit: 1,
      );

      if (rows.isNotEmpty) {
        final row = rows.first;
        final payload = jsonDecode((row['payloadJson'] ?? '{}').toString())
        as Map<String, dynamic>;

        _referralDateController.text =
            (payload['referralDate'] ?? _today()).toString();
        _referredByController.text = (payload['referredBy'] ?? '').toString();
        _organizationNameController.text =
            (payload['organizationName'] ?? '').toString();
        _contactPersonController.text =
            (payload['contactPerson'] ?? '').toString();
        _contactPhoneController.text =
            (payload['contactPhone'] ?? '').toString();
        _reasonForReferralController.text =
            (payload['reasonForReferral'] ?? '').toString();
        _serviceDetailsController.text =
            (payload['serviceDetails'] ?? '').toString();
        _appointmentDateController.text =
            (payload['appointmentDate'] ?? '').toString();
        _feedbackDateController.text =
            (payload['feedbackDate'] ?? '').toString();
        _outcomeNotesController.text =
            (payload['outcomeNotes'] ?? '').toString();
        _barriersController.text = (payload['barriers'] ?? '').toString();
        _additionalNotesController.text =
            (payload['additionalNotes'] ?? '').toString();

        _referralCategory = _normalizeDropdownValue(
          payload['referralCategory'],
          _referralCategoryOptions,
        );
        _serviceUrgency = _normalizeDropdownValue(
          payload['serviceUrgency'],
          _serviceUrgencyOptions,
        );
        _serviceProviderType = _normalizeDropdownValue(
          payload['serviceProviderType'],
          _serviceProviderTypeOptions,
        );
        _referralMethod = _normalizeDropdownValue(
          payload['referralMethod'],
          _referralMethodOptions,
        );
        _referralStatus = _normalizeDropdownValue(
          payload['referralStatus'],
          _referralStatusOptions,
        );
        _feedbackStatus = _normalizeDropdownValue(
          payload['feedbackStatus'],
          _feedbackStatusOptions,
        );
        _caseDecisionAfterReferral = _normalizeDropdownValue(
          payload['caseDecisionAfterReferral'],
          _caseDecisionAfterReferralOptions,
        );

        _savedStatus = (row['status'] ?? 'DRAFT').toString();
      }
    } catch (_) {
      //
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

    if (_referralCategory == null || _referralCategory!.trim().isEmpty) {
      _showSnack('Please select the referral category.');
      return;
    }

    if (_serviceProviderType == null ||
        _serviceProviderType!.trim().isEmpty) {
      _showSnack('Please select the service provider type.');
      return;
    }

    if (_referralStatus == null || _referralStatus!.trim().isEmpty) {
      _showSnack('Please select the referral status.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final db = await _db();
      await db.insert(
        'mgysd_referral',
        {
          'id': widget.mgysdCase.id,
          'caseId': widget.mgysdCase.id,
          'householdTei': (widget.householdTei ?? '').trim(),
          'referralDate': _referralDateController.text.trim(),
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
            ? 'Referral marked as complete.'
            : 'Referral saved as draft.',
      );
    } catch (e) {
      _showSnack('Failed to save referral: $e');
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
              Icons.handshake_outlined,
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
                    style: const TextStyle(color: Colors.blueGrey),
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
  }) {
    final safeValue = (value != null && items.contains(value)) ? value : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: safeValue,
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
        title: const Text('Referral'),
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
                    'Referral context',
                    'Capture when the referral was made and who initiated it.',
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    _referralDateController,
                    'Referral date',
                    readOnly: true,
                    onTap: () => _pickDate(_referralDateController),
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Referral date is required'
                        : null,
                  ),
                  _textField(
                    _referredByController,
                    'Referred by',
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Referred by is required'
                        : null,
                  ),
                  _dropdownField(
                    label: 'Referral category',
                    value: _referralCategory,
                    items: _referralCategoryOptions,
                    onChanged: (value) {
                      setState(() {
                        _referralCategory = value;
                      });
                    },
                  ),
                  _dropdownField(
                    label: 'Service urgency',
                    value: _serviceUrgency,
                    items: _serviceUrgencyOptions,
                    onChanged: (value) {
                      setState(() {
                        _serviceUrgency = value;
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
                    'Service provider details',
                    'Document where the case is being referred.',
                  ),
                  const SizedBox(height: 12),
                  _dropdownField(
                    label: 'Service provider type',
                    value: _serviceProviderType,
                    items: _serviceProviderTypeOptions,
                    onChanged: (value) {
                      setState(() {
                        _serviceProviderType = value;
                      });
                    },
                  ),
                  _textField(
                    _organizationNameController,
                    'Organization / facility name',
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Organization / facility name is required'
                        : null,
                  ),
                  _textField(
                    _contactPersonController,
                    'Contact person',
                  ),
                  _textField(
                    _contactPhoneController,
                    'Contact phone',
                  ),
                  _dropdownField(
                    label: 'Referral method',
                    value: _referralMethod,
                    items: _referralMethodOptions,
                    onChanged: (value) {
                      setState(() {
                        _referralMethod = value;
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
                    'Reason and service requested',
                    'Capture why the client is being referred and what support is expected.',
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    _reasonForReferralController,
                    'Reason for referral',
                    maxLines: 3,
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Reason for referral is required'
                        : null,
                  ),
                  _textField(
                    _serviceDetailsController,
                    'Requested service / support details',
                    maxLines: 4,
                  ),
                  _textField(
                    _appointmentDateController,
                    'Appointment / service date',
                    readOnly: true,
                    onTap: () => _pickDate(_appointmentDateController),
                  ),
                  _dropdownField(
                    label: 'Referral status',
                    value: _referralStatus,
                    items: _referralStatusOptions,
                    onChanged: (value) {
                      setState(() {
                        _referralStatus = value;
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
                    'Feedback and outcome',
                    'Capture whether feedback was received and what happened after referral.',
                  ),
                  const SizedBox(height: 12),
                  _dropdownField(
                    label: 'Feedback status',
                    value: _feedbackStatus,
                    items: _feedbackStatusOptions,
                    onChanged: (value) {
                      setState(() {
                        _feedbackStatus = value;
                      });
                    },
                  ),
                  _textField(
                    _feedbackDateController,
                    'Feedback date',
                    readOnly: true,
                    onTap: () => _pickDate(_feedbackDateController),
                  ),
                  _textField(
                    _outcomeNotesController,
                    'Outcome / feedback notes',
                    maxLines: 4,
                  ),
                  _textField(
                    _barriersController,
                    'Barriers / challenges',
                    maxLines: 3,
                  ),
                  _dropdownField(
                    label: 'Case decision after referral',
                    value: _caseDecisionAfterReferral,
                    items: _caseDecisionAfterReferralOptions,
                    onChanged: (value) {
                      setState(() {
                        _caseDecisionAfterReferral = value;
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
