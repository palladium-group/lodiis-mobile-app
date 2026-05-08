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
    this.onStatusChanged,
  }) : super(key: key);

  final Color color;
  final MgysdCase mgysdCase;
  final String? householdTei;
  final String? householdName;
  final String? clientName;

  /// Optional callback invoked after a successful save with the new status.
  final void Function(String status)? onStatusChanged;

  @override
  State<MgysdReferralPage> createState() => _MgysdReferralPageState();
}

class _MgysdReferralPageState extends State<MgysdReferralPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Core fields
  final TextEditingController _referralDateController = TextEditingController();
  final TextEditingController _referredByController = TextEditingController();
  final TextEditingController _organizationNameController = TextEditingController();

  // Contact person table fields (Name, Title, Contact details)
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonTitleController = TextEditingController();
  final TextEditingController _contactPersonContactController = TextEditingController();

  // Additional notes and "Other (specify)"
  final TextEditingController _additionalNotesController = TextEditingController();
  final TextEditingController _otherSpecifyController = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String _savedStatus = 'NOT_STARTED';

  // Checkbox selections
  Map<String, bool> _socialProtection = {
    'Transportation Assistance': false,
    'Food Assistance': false,
    'Social Grant (PA/Bursary/CGP/OAP/DG)': false,
    'Community-based care': false,
  };

  // Health support includes nutritional, disability and primary care items
  Map<String, bool> _healthSupport = {
    'HIV-related care and support': false,
    'Reproductive/sexual health services': false,
    'Nutritional support': false,
    'Disability support (medical assessment/physiotherapy)': false,
    'Support related to primary care': false,
  };

  Map<String, bool> _mentalHealthSupport = {
    'Psychiatric services': false,
    'Substance abuse services': false,
    'Psychosocial support / counselling': false,
    'Support group': false,
  };

  Map<String, bool> _educationSupport = {
    'Bursary or other financial/material support': false,
    'Vocational training': false,
    'Early Childhood Development': false,
    'Support to return to school / homework support': false,
  };

  Map<String, bool> _communityDevelopment = {
    'Skills Development': false,
    'Income Generating Activity': false,
    'Job placement': false,
    'Start-up kit / capital': false,
  };

  Map<String, bool> _otherServices = {
    'Legal advice': false,
    'Birth registration / civil registration support': false,
    'Other (specify)': false,
  };

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
    _contactPersonNameController.dispose();
    _contactPersonTitleController.dispose();
    _contactPersonContactController.dispose();
    _additionalNotesController.dispose();
    _otherSpecifyController.dispose();
    super.dispose();
  }

  Future<Database> _db() async {
    final dbClient = await OfflineDbProvider().db;
    if (dbClient == null) throw Exception('Offline DB not initialized');
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        controller.text = _formatDate(picked);
      });
    }
  }

  Map<String, dynamic> _payload() {
    return {
      'referralDate': _referralDateController.text.trim(),
      'referredBy': _referredByController.text.trim(),
      'organizationName': _organizationNameController.text.trim(),
      'contactPerson': {
        'name': _contactPersonNameController.text.trim(),
        'title': _contactPersonTitleController.text.trim(),
        'contactDetails': _contactPersonContactController.text.trim(),
      },
      'socialProtection': _socialProtection,
      'healthSupport': _healthSupport,
      'mentalHealthSupport': _mentalHealthSupport,
      'educationSupport': _educationSupport,
      'communityDevelopment': _communityDevelopment,
      'otherServices': _otherServices,
      'otherSpecify': _otherSpecifyController.text.trim(),
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
        final payloadJson = (row['payloadJson'] ?? '{}').toString();
        final Map<String, dynamic> payload = jsonDecode(payloadJson) as Map<String, dynamic>;

        _referralDateController.text = (payload['referralDate'] ?? _today()).toString();
        _referredByController.text = (payload['referredBy'] ?? '').toString();
        _organizationNameController.text = (payload['organizationName'] ?? '').toString();

        final contact = payload['contactPerson'];
        if (contact is Map) {
          _contactPersonNameController.text = (contact['name'] ?? '').toString();
          _contactPersonTitleController.text = (contact['title'] ?? '').toString();
          _contactPersonContactController.text = (contact['contactDetails'] ?? '').toString();
        }

        _additionalNotesController.text = (payload['additionalNotes'] ?? '').toString();
        _otherSpecifyController.text = (payload['otherSpecify'] ?? '').toString();

        _setMapFromPayload(_socialProtection, payload['socialProtection']);
        _setMapFromPayload(_healthSupport, payload['healthSupport']);
        _setMapFromPayload(_mentalHealthSupport, payload['mentalHealthSupport']);
        _setMapFromPayload(_educationSupport, payload['educationSupport']);
        _setMapFromPayload(_communityDevelopment, payload['communityDevelopment']);
        _setMapFromPayload(_otherServices, payload['otherServices']);

        _savedStatus = (row['status'] ?? 'NOT_STARTED').toString().toUpperCase();
      }
    } catch (e) {
      // ignore load errors
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _setMapFromPayload(Map<String, bool> target, dynamic source) {
    if (source is Map) {
      for (final key in target.keys.toList()) {
        final val = source[key];
        target[key] = (val == true || val == 'true' || val == 1);
      }
    }
  }

  Future<void> _save(String status) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    // Normalize status to expected values used by case detail
    final normalized = _normalizeStatus(status);

    try {
      final db = await _db();
      await db.insert(
        'mgysd_referral',
        {
          'id': widget.mgysdCase.id,
          'caseId': widget.mgysdCase.id,
          'householdTei': (widget.householdTei ?? '').trim(),
          'referralDate': _referralDateController.text.trim(),
          'status': normalized,
          'payloadJson': jsonEncode(_payload()),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (!mounted) return;
      setState(() {
        _savedStatus = normalized;
      });

      // Notify parent if callback provided
      if (widget.onStatusChanged != null) {
        try {
          widget.onStatusChanged!(normalized);
        } catch (_) {
          // swallow callback errors to avoid breaking save flow
        }
      }

      _showSnack(
        normalized == 'COMPLETED' ? 'Referral marked as complete.' : 'Referral saved as in progress.',
      );
    } catch (e) {
      _showSnack('Failed to save referral: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _normalizeStatus(String raw) {
    final s = raw.trim().toUpperCase();
    if (s == 'COMPLETED' || s == 'COMPLETE' || s == 'DONE') return 'COMPLETED';
    if (s == 'IN_PROGRESS' || s == 'IN PROGRESS' || s == 'DRAFT' || s == 'ACTIVE' || s == 'STARTED') return 'IN_PROGRESS';
    return 'NOT_STARTED';
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _statusChip() {
    final String label;
    final Color color;

    switch (_savedStatus) {
      case 'COMPLETED':
        label = 'Completed';
        color = Colors.green;
        break;
      case 'IN_PROGRESS':
        label = 'In progress';
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
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
    );
  }

  Widget _surface({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.06)),
      ),
      child: child,
    );
  }

  Widget _checkboxGroup(String title, Map<String, bool> options) {
    return _surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 8),
          ...options.keys.map((key) {
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(key),
              value: options[key],
              onChanged: (val) {
                setState(() => options[key] = val ?? false);
              },
            );
          }).toList(),
        ],
      ),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: const Color(0xFFF9FBFD),
        ),
      ),
    );
  }

  Widget _contactPersonTable() {
    return _surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Person making referral', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 8),
          _textField(_contactPersonNameController, 'Name', validator: (v) => null),
          _textField(_contactPersonTitleController, 'Title', validator: (v) => null),
          _textField(_contactPersonContactController, 'Contact details', validator: (v) => null),
        ],
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
            _surface(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: widget.color.withOpacity(0.12),
                    child: Icon(Icons.handshake_outlined, color: widget.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(clientName.isEmpty ? widget.mgysdCase.caseNo : clientName,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text('Case No: ${widget.mgysdCase.caseNo}',
                            style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
                        if (householdName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text('Household: $householdName', style: const TextStyle(color: Colors.blueGrey)),
                        ],
                      ],
                    ),
                  ),
                  _statusChip(),
                ],
              ),
            ),

            // Referral context surface
            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Referral context', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  _textField(
                    _referralDateController,
                    'Date of referral',
                    readOnly: true,
                    onTap: () => _pickDate(_referralDateController),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Referral date is required' : null,
                  ),
                  _textField(
                    _referredByController,
                    'Name of referring organisation / Referred by',
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Referred by is required' : null,
                  ),
                ],
              ),
            ),

            // Person making referral table (Name, Title, Contact details)
            _contactPersonTable(),

            // "This client has been referred to:" section
            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('This client has been referred to:', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  _textField(_organizationNameController, 'Organization name (Specify)', validator: (v) => null),
                ],
              ),
            ),

            // Intro message before needs
            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Now the following needs have been identified and discussed with client:',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            // Service categories
            _checkboxGroup('Social protection support', _socialProtection),
            _checkboxGroup('Health support', _healthSupport),
            _checkboxGroup('Mental health support', _mentalHealthSupport),
            _checkboxGroup('Education support', _educationSupport),
            _checkboxGroup('Community development', _communityDevelopment),

            // Other services group with conditional "specify" textbox
            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Other services', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  const SizedBox(height: 8),
                  ..._otherServices.keys.map((key) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(key),
                      value: _otherServices[key],
                      onChanged: (val) {
                        setState(() {
                          _otherServices[key] = val ?? false;
                          if (key == 'Other (specify)' && !(val ?? false)) {
                            _otherSpecifyController.text = '';
                          }
                        });
                      },
                    );
                  }).toList(),
                  if (_otherServices['Other (specify)'] == true) ...[
                    const SizedBox(height: 8),
                    _textField(_otherSpecifyController, 'Specify other service', maxLines: 2),
                  ],
                ],
              ),
            ),

            // Additional notes
            _surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Other / Additional', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  _textField(_additionalNotesController, 'Additional notes', maxLines: 3),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => _save('IN_PROGRESS'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: widget.color),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
