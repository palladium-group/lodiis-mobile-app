import 'package:flutter/material.dart';

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
  final dynamic mgysdCase;
  final String? householdTei;
  final String? householdName;
  final String? clientName;

  @override
  State<MgysdCarePlanPage> createState() => _MgysdCarePlanPageState();
}

class _MgysdCarePlanPageState extends State<MgysdCarePlanPage> {
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;

  // Local status to keep UI in sync after saves
  String? _localStatus;

  // Client goals
  final TextEditingController _clientShort = TextEditingController();
  final TextEditingController _clientMedium = TextEditingController();
  final TextEditingController _clientLong = TextEditingController();

  // Parent/Guardian goals
  final TextEditingController _parentShort = TextEditingController();
  final TextEditingController _parentMedium = TextEditingController();
  final TextEditingController _parentLong = TextEditingController();

  // Social worker goals
  final TextEditingController _workerShort = TextEditingController();
  final TextEditingController _workerMedium = TextEditingController();
  final TextEditingController _workerLong = TextEditingController();

  @override
  void initState() {
    super.initState();
    _localStatus = widget.mgysdCase?.status?.toString();
  }

  @override
  void dispose() {
    _clientShort.dispose();
    _clientMedium.dispose();
    _clientLong.dispose();
    _parentShort.dispose();
    _parentMedium.dispose();
    _parentLong.dispose();
    _workerShort.dispose();
    _workerMedium.dispose();
    _workerLong.dispose();
    super.dispose();
  }

  Widget _sectionHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  /// Rounded, filled style goal field (matches Save Draft rectangle look)
  Widget _goalField(String label, TextEditingController controller, {int maxLines = 3}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black45),
              ),
              style: const TextStyle(fontSize: 14),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter $label';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Submit handler used for "Mark Complete" (validates form)
  Future<void> _markComplete() async {
    if (!_formKey.currentState!.validate()) return;
    await _onSubmitWithStatus('complete');
  }

  /// Save draft should allow partial/empty fields; skip validation
  Future<void> _saveDraft() async {
    await _onSubmitWithStatus('draft', validate: false);
  }

  /// Core submit logic. If [validate] is true, form must be valid before saving.
  Future<void> _onSubmitWithStatus(String status, {bool validate = true}) async {
    if (validate && !_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final payload = {
      'caseId': widget.mgysdCase?.id ?? '',
      'householdTei': widget.householdTei,
      'householdName': widget.householdName,
      'clientName': widget.clientName,
      'status': status, // 'draft' or 'complete'
      'clientGoals': {
        'short': _clientShort.text.trim(),
        'medium': _clientMedium.text.trim(),
        'long': _clientLong.text.trim(),
      },
      'parentGoals': {
        'short': _parentShort.text.trim(),
        'medium': _parentMedium.text.trim(),
        'long': _parentLong.text.trim(),
      },
      'workerGoals': {
        'short': _workerShort.text.trim(),
        'medium': _workerMedium.text.trim(),
        'long': _workerLong.text.trim(),
      },
      'updatedAt': DateTime.now().toIso8601String(),
    };

    try {
      // Replace this with your actual save logic (API call or local DB).
      debugPrint('Care plan payload ($status): $payload');

      if (mounted) {
        // Update local status so UI (care plan page) and progress summary stay in sync
        setState(() {
          _localStatus = status;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(status == 'draft' ? 'Draft saved' : 'Care plan marked complete')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'complete':
      case 'completed':
        return Colors.green.shade600;
      case 'in progress':
      case 'in-progress':
        return Colors.orange.shade600;
      case 'not started':
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Normalize and map raw status to a friendly label, prefer local status if set
    final String rawStatus = (_localStatus ?? widget.mgysdCase?.status?.toString() ?? '').trim().toLowerCase();
    String statusText;
    if (rawStatus.isEmpty) {
      statusText = 'Not started';
    } else if (rawStatus.contains('complete') || rawStatus.contains('completed') || rawStatus == 'done') {
      statusText = 'Complete';
    } else if (rawStatus.contains('in progress') || rawStatus.contains('in-progress') || rawStatus == 'active' || rawStatus == 'started') {
      statusText = 'In progress';
    } else if (rawStatus.contains('not started') || rawStatus == 'not_started' || rawStatus == 'pending') {
      statusText = 'Not started';
    } else {
      // Fallback: capitalize first letter of raw status
      statusText = rawStatus.isNotEmpty
          ? '${rawStatus[0].toUpperCase()}${rawStatus.substring(1)}'
          : 'Not started';
    }

    final String? caseId = widget.mgysdCase?.id?.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Plan'),
        backgroundColor: widget.color,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Client + icon + case id + status chip block
                if (widget.clientName != null || caseId != null || statusText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.person, size: 20, color: Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.clientName != null)
                                Text('Client: ${widget.clientName}',
                                    style: Theme.of(context).textTheme.titleMedium),
                              if (caseId != null)
                                Text('Case ID: $caseId', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        // Status chip on the right
                        Chip(
                          label: Text(
                            statusText,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: _statusColor(statusText),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                        ),
                      ],
                    ),
                  ),

                if (widget.householdName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Household: ${widget.householdName}', style: Theme.of(context).textTheme.titleSmall),
                  ),

                // Client's goals section
                _sectionHeading("Client's goals"),
                _goalField('Short term (next 3 months)', _clientShort),
                _goalField('Medium term (next 12 months)', _clientMedium),
                _goalField('Long term (beyond 1 year)', _clientLong, maxLines: 4),

                // Parent/Guardian goals section
                _sectionHeading('Parent/Guardian goals (if appropriate)'),
                _goalField('Short term (next 3 months)', _parentShort),
                _goalField('Medium term (next 12 months)', _parentMedium),
                _goalField('Long term (beyond 1 year)', _parentLong, maxLines: 4),

                // Social worker goals section
                _sectionHeading('Social worker goals'),
                _goalField('Short term (next 3 months)', _workerShort),
                _goalField('Medium term (next 12 months)', _workerMedium),
                _goalField('Long term (beyond 1 year)', _workerLong, maxLines: 4),

                const SizedBox(height: 20),

                // Two action buttons: Save Draft and Mark Complete
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _submitting ? null : _saveDraft,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.purple.shade200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('Save Draft', style: TextStyle(color: Colors.purple.shade700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _markComplete,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: widget.color,
                        ),
                        child: _submitting
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Mark Complete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
