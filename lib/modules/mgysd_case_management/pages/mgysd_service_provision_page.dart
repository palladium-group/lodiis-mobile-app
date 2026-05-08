import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kb_mobile_app/core/offline_db/offline_db_provider.dart';
import 'package:kb_mobile_app/modules/mgysd_case_management/models/mgysd_case.dart';
import 'package:sqflite/sqflite.dart';

class MgysdServiceProvisionPage extends StatefulWidget {
  const MgysdServiceProvisionPage({
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
  State<MgysdServiceProvisionPage> createState() =>
      _MgysdServiceProvisionPageState();
}

class _MgysdServiceProvisionPageState
    extends State<MgysdServiceProvisionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fileNoController = TextEditingController();
  final TextEditingController _namesController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _materialProvidedController =
  TextEditingController();
  final TextEditingController _referralReasonsController =
  TextEditingController();
  final TextEditingController _signatureController = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String _savedStatus = 'NOT_STARTED';

  String? _sex;
  bool _isNewClient = false;
  bool _isReturningClient = false;
  bool _psychosocialSupport = false;
  bool _food = false;
  bool _referClient = false;

  static const List<String> _sexOptions = [
    'Female',
    'Male',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _dateController.text = _today();
    _fileNoController.text = widget.mgysdCase.caseNo;
    _namesController.text =
        (widget.clientName ?? widget.mgysdCase.fullName).trim();
    _loadSavedData();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _fileNoController.dispose();
    _namesController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _materialProvidedController.dispose();
    _referralReasonsController.dispose();
    _signatureController.dispose();
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
    return _formatDate(DateTime.now());
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

  bool _asBool(dynamic raw) {
    if (raw is bool) return raw;
    return raw.toString().toLowerCase() == 'true';
  }

  Map<String, dynamic> _payload() {
    return {
      'date': _dateController.text.trim(),
      'fileNo': _fileNoController.text.trim(),
      'names': _namesController.text.trim(),
      'age': _ageController.text.trim(),
      'sex': _sex,
      'address': _addressController.text.trim(),
      'newClient': _isNewClient,
      'returningClient': _isReturningClient,
      'psychosocialSupport': _psychosocialSupport,
      'food': _food,
      'materialProvided': _materialProvidedController.text.trim(),
      'referralReasons': _referralReasonsController.text.trim(),
      'signatureOfClient': _signatureController.text.trim(),
    };
  }

  Future<void> _loadSavedData() async {
    try {
      final db = await _db();
      final rows = await db.query(
        'mgysd_service_provision',
        where: 'id = ?',
        whereArgs: [widget.mgysdCase.id],
        limit: 1,
      );

      if (rows.isNotEmpty) {
        final row = rows.first;
        final payload = jsonDecode((row['payloadJson'] ?? '{}').toString())
        as Map<String, dynamic>;

        _dateController.text = (payload['date'] ?? _today()).toString();
        _fileNoController.text =
            (payload['fileNo'] ?? widget.mgysdCase.caseNo).toString();
        _namesController.text = (payload['names'] ??
            (widget.clientName ?? widget.mgysdCase.fullName))
            .toString();
        _ageController.text = (payload['age'] ?? '').toString();
        _addressController.text = (payload['address'] ?? '').toString();
        _materialProvidedController.text =
            (payload['materialProvided'] ?? '').toString();
        _referralReasonsController.text =
            (payload['referralReasons'] ?? '').toString();
        _signatureController.text =
            (payload['signatureOfClient'] ?? '').toString();

        _sex = _normalizeDropdownValue(payload['sex'], _sexOptions);
        _isNewClient = _asBool(payload['newClient']);
        _isReturningClient = _asBool(payload['returningClient']);
        _psychosocialSupport = _asBool(payload['psychosocialSupport']);
        _food = _asBool(payload['food']);
        _savedStatus = (row['status'] ?? 'DRAFT').toString();
      }
    } catch (_) {
      // Keep defaults if nothing is saved yet or the table is not ready.
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

    if (_sex == null || _sex!.trim().isEmpty) {
      _showSnack('Please select sex.');
      return;
    }

    if (!_isNewClient && !_isReturningClient) {
      _showSnack('Please select whether this is a new or returning client.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final db = await _db();
      await db.insert(
        'mgysd_service_provision',
        {
          'id': widget.mgysdCase.id,
          'caseId': widget.mgysdCase.id,
          'householdTei': (widget.householdTei ?? '').trim(),
          'serviceDate': _dateController.text.trim(),
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
            ? 'Service provision marked as complete.'
            : 'Service provision saved as draft.',
      );
    } catch (e) {
      _showSnack('Failed to save service provision: $e');
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
              Icons.volunteer_activism_outlined,
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
        TextInputType? keyboardType,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
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

  Widget _checkTile({
    required String title,
    required bool value,
    required void Function(bool?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.10)),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: widget.color,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
        title: const Text('Service Provision'),
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
                    'Adult Services Register - General Services',
                    'Capture the service provision record for this client.',
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    _dateController,
                    'Date',
                    readOnly: true,
                    onTap: () => _pickDate(_dateController),
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Date is required'
                        : null,
                  ),
                  _textField(
                    _fileNoController,
                    'File No.',
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'File No. is required'
                        : null,
                  ),
                  _textField(
                    _namesController,
                    'Names',
                    validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Names are required'
                        : null,
                  ),
                  _textField(
                    _ageController,
                    'Age',
                    keyboardType: TextInputType.number,
                  ),
                  _dropdownField(
                    label: 'Sex',
                    value: _sex,
                    items: _sexOptions,
                    onChanged: (value) {
                      setState(() {
                        _sex = value;
                      });
                    },
                  ),
                  _textField(
                    _addressController,
                    'Address',
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Client type and services provided',
                    'Tick the applicable service register columns.',
                  ),
                  const SizedBox(height: 12),
                  _checkTile(
                    title: 'New client',
                    value: _isNewClient,
                    onChanged: (value) {
                      setState(() {
                        _isNewClient = value ?? false;
                        if (_isNewClient) _isReturningClient = false;
                      });
                    },
                  ),
                  _checkTile(
                    title: 'Returning client',
                    value: _isReturningClient,
                    onChanged: (value) {
                      setState(() {
                        _isReturningClient = value ?? false;
                        if (_isReturningClient) _isNewClient = false;
                      });
                    },
                  ),
                  _checkTile(
                    title: 'Psycho-social support',
                    value: _psychosocialSupport,
                    onChanged: (value) {
                      setState(() {
                        _psychosocialSupport = value ?? false;
                      });
                    },
                  ),
                  _checkTile(
                    title: 'Food',
                    value: _food,
                    onChanged: (value) {
                      setState(() {
                        _food = value ?? false;
                      });
                    },
                  ),
                  _textField(
                    _materialProvidedController,
                    'Material provided (write item given)',
                    maxLines: 3,
                  ),

                  _checkTile(
                    title: 'Refer client?',
                    value: _referClient,
                    onChanged: (value) {
                      setState(() {
                        _referClient = value ?? false;
                        if (!_referClient) {
                          _referralReasonsController.clear();
                        }
                      });
                    },
                  ),

                  if (_referClient)
                    _textField(
                      _referralReasonsController,
                      'Referral Reasons (write)',
                      maxLines: 3,
                      validator: (value) =>
                      _referClient &&
                          (value == null || value.trim().isEmpty)
                          ? 'Referral reasons are required'
                          : null,
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
// TODO Implement this library.