import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String? _localStatus;

  bool _carePlanCompletedForParent = false;

  final ScrollController _scrollController = ScrollController();

  final FocusNode _clientShortFocus = FocusNode();
  final FocusNode _clientMediumFocus = FocusNode();
  final FocusNode _clientLongFocus = FocusNode();
  final FocusNode _parentShortFocus = FocusNode();
  final FocusNode _parentMediumFocus = FocusNode();
  final FocusNode _parentLongFocus = FocusNode();
  final FocusNode _workerShortFocus = FocusNode();
  final FocusNode _workerMediumFocus = FocusNode();
  final FocusNode _workerLongFocus = FocusNode();

  final FocusNode _supportPlanSummaryFocus = FocusNode();
  final FocusNode _planPersonNameFocus = FocusNode();
  final FocusNode _planPersonRoleFocus = FocusNode();
  final FocusNode _planPersonSignatureFocus = FocusNode();
  final FocusNode _planPersonDateFocus = FocusNode();
  final FocusNode _disagreeFullNamesFocus = FocusNode();
  final FocusNode _disagreeSignatureFocus = FocusNode();
  final FocusNode _disagreeDateFocus = FocusNode();
  final FocusNode _disagreeReasonsFocus = FocusNode();

  final Map<String, GlobalKey> _fieldKeys = {
    'clientShort': GlobalKey(),
    'clientMedium': GlobalKey(),
    'clientLong': GlobalKey(),
    'parentShort': GlobalKey(),
    'parentMedium': GlobalKey(),
    'parentLong': GlobalKey(),
    'workerShort': GlobalKey(),
    'workerMedium': GlobalKey(),
    'workerLong': GlobalKey(),
    'supportPlanSummary': GlobalKey(),
    'planPersonName': GlobalKey(),
    'planPersonRole': GlobalKey(),
    'planPersonSignature': GlobalKey(),
    'planPersonDate': GlobalKey(),
    'disagreeFullNames': GlobalKey(),
    'disagreeSignature': GlobalKey(),
    'disagreeDate': GlobalKey(),
    'disagreeReasons': GlobalKey(),
  };

  final TextEditingController _clientShort = TextEditingController();
  final TextEditingController _clientMedium = TextEditingController();
  final TextEditingController _clientLong = TextEditingController();

  final TextEditingController _parentShort = TextEditingController();
  final TextEditingController _parentMedium = TextEditingController();
  final TextEditingController _parentLong = TextEditingController();

  final TextEditingController _workerShort = TextEditingController();
  final TextEditingController _workerMedium = TextEditingController();
  final TextEditingController _workerLong = TextEditingController();

  final TextEditingController _supportPlanSummary = TextEditingController();

  final TextEditingController _planPersonName = TextEditingController();
  final TextEditingController _planPersonRole = TextEditingController();
  final TextEditingController _planPersonSignature = TextEditingController();
  final TextEditingController _planPersonDate = TextEditingController();

  final TextEditingController _disagreeFullNames = TextEditingController();
  final TextEditingController _disagreeSignature = TextEditingController();
  final TextEditingController _disagreeDate = TextEditingController();
  final TextEditingController _disagreeReasons = TextEditingController();

  @override
  void initState() {
    super.initState();

    _localStatus = null;

    _syncStatusFromCase();
    _loadDraftIfAny();
  }

  @override
  void didUpdateWidget(covariant MgysdCarePlanPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mgysdCase != oldWidget.mgysdCase) {
      _syncStatusFromCase();
      _loadDraftIfAny();
    }
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

    _supportPlanSummary.dispose();

    _planPersonName.dispose();
    _planPersonRole.dispose();
    _planPersonSignature.dispose();
    _planPersonDate.dispose();

    _disagreeFullNames.dispose();
    _disagreeSignature.dispose();
    _disagreeDate.dispose();
    _disagreeReasons.dispose();

    _clientShortFocus.dispose();
    _clientMediumFocus.dispose();
    _clientLongFocus.dispose();
    _parentShortFocus.dispose();
    _parentMediumFocus.dispose();
    _parentLongFocus.dispose();
    _workerShortFocus.dispose();
    _workerMediumFocus.dispose();
    _workerLongFocus.dispose();

    _supportPlanSummaryFocus.dispose();

    _planPersonNameFocus.dispose();
    _planPersonRoleFocus.dispose();
    _planPersonSignatureFocus.dispose();
    _planPersonDateFocus.dispose();

    _disagreeFullNamesFocus.dispose();
    _disagreeSignatureFocus.dispose();
    _disagreeDateFocus.dispose();
    _disagreeReasonsFocus.dispose();

    _scrollController.dispose();
    super.dispose();
  }

  String? _caseId() {
    final caseObj = widget.mgysdCase;
    if (caseObj == null) return null;

    try {
      if (caseObj is Map) {
        final value = caseObj['id'] ?? caseObj['caseId'] ?? caseObj['case_id'];
        return value?.toString();
      }

      try {
        return caseObj.id?.toString();
      } catch (_) {}

      try {
        return caseObj.caseId?.toString();
      } catch (_) {}

      try {
        return caseObj.case_id?.toString();
      } catch (_) {}
    } catch (_) {}

    return null;
  }

  Map<String, dynamic> _carePlanCompletedResult() {
    return {
      'caseId': _caseId(),
      'step': 'care_plan',
      'status': 'completed',
      'carePlanStatus': 'completed',
      'care_plan_status': 'completed',
      'carePlan': 'completed',
      'care_plan': 'completed',
    };
  }

  String _normalizeLocalStatus(String? status) {
    final raw = (status ?? '').trim().toLowerCase();

    if (raw.isEmpty) {
      return 'Not started';
    }

    if (raw.contains('complete') || raw == 'done') {
      return 'Completed';
    }

    if (raw == 'draft' ||
        raw == 'in_progress' ||
        raw.contains('in progress') ||
        raw.contains('in-progress') ||
        raw == 'active' ||
        raw == 'started') {
      return 'In progress';
    }

    if (raw.contains('not started') || raw == 'not_started' || raw == 'pending') {
      return 'Not started';
    }

    return '${raw[0].toUpperCase()}${raw.substring(1)}';
  }

  void _syncStatusFromCase() {
    final caseObj = widget.mgysdCase;
    if (caseObj == null) return;

    String? derived;

    try {
      dynamic carePlanCandidate;

      if (caseObj is Map) {
        carePlanCandidate = caseObj['carePlanStatus'] ??
            caseObj['care_plan_status'] ??
            caseObj['careplanStatus'] ??
            caseObj['carePlan'] ??
            caseObj['care_plan'];
      } else {
        try {
          carePlanCandidate = caseObj.carePlanStatus;
        } catch (_) {}

        if (carePlanCandidate == null) {
          try {
            carePlanCandidate = caseObj.care_plan_status;
          } catch (_) {}
        }

        if (carePlanCandidate == null) {
          try {
            carePlanCandidate = caseObj.careplanStatus;
          } catch (_) {}
        }

        if (carePlanCandidate == null) {
          try {
            carePlanCandidate = caseObj.carePlan;
          } catch (_) {}
        }

        if (carePlanCandidate == null) {
          try {
            carePlanCandidate = caseObj.care_plan;
          } catch (_) {}
        }
      }

      if (carePlanCandidate != null) {
        derived = carePlanCandidate.toString();
      }

      if (derived == null) {
        dynamic rawStatusCandidate;

        if (caseObj is Map) {
          rawStatusCandidate = caseObj['status'] ?? caseObj['caseStatus'];
        } else {
          try {
            rawStatusCandidate = caseObj.status;
          } catch (_) {}

          if (rawStatusCandidate == null) {
            try {
              rawStatusCandidate = caseObj.caseStatus;
            } catch (_) {}
          }
        }

        if (rawStatusCandidate != null) {
          derived = rawStatusCandidate.toString();
        }
      }
    } catch (_) {}

    if (derived != null) {
      final mapped = _normalizeLocalStatus(derived);

      if ((_localStatus ?? '').toLowerCase() != mapped.toLowerCase()) {
        if (mounted) {
          setState(() {
            _localStatus = mapped;
          });
        } else {
          _localStatus = mapped;
        }
      }
    }
  }

  Future<void> _loadDraftIfAny() async {
    final caseId = _caseId();
    if (caseId == null || caseId.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final draftKey = 'careplan_draft_$caseId';
    final lastFieldKey = 'careplan_lastfield_$caseId';
    final savedKey = 'careplan_saved_$caseId';

    final draftJson = prefs.getString(draftKey);
    final savedJson = prefs.getString(savedKey);
    final lastField = prefs.getString(lastFieldKey);

    final directStatus = prefs.getString('careplan_status_$caseId') ??
        prefs.getString('care_plan_status_$caseId');

    final directCompleted = prefs.getBool('careplan_completed_$caseId') ??
        prefs.getBool('care_plan_completed_$caseId') ??
        false;

    final progressJson = prefs.getString('case_progress_$caseId');

    final sourceJson = draftJson ?? savedJson;

    String? statusFromStorage;

    if (draftJson != null && draftJson.trim().isNotEmpty) {
      statusFromStorage = 'In progress';
    } else if (directStatus != null && directStatus.trim().isNotEmpty) {
      statusFromStorage = _normalizeLocalStatus(directStatus);
    } else if (directCompleted) {
      statusFromStorage = 'Completed';
    }

    if (progressJson != null && progressJson.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(progressJson);
        if (decoded is Map) {
          final progressStatus = (decoded['carePlanStatus'] ??
              decoded['care_plan_status'] ??
              decoded['carePlan'] ??
              decoded['care_plan'])
              ?.toString();

          if (progressStatus != null && progressStatus.trim().isNotEmpty) {
            final normalized = _normalizeLocalStatus(progressStatus);
            if (draftJson != null && draftJson.trim().isNotEmpty) {
              statusFromStorage = 'In progress';
            } else if (normalized == 'Completed') {
              statusFromStorage = 'Completed';
            } else if (normalized == 'In progress') {
              statusFromStorage = 'In progress';
            }
          }
        }
      } catch (_) {}
    }

    if (sourceJson != null) {
      try {
        final Map<String, dynamic> data =
        jsonDecode(sourceJson) as Map<String, dynamic>;

        _clientShort.text = (data['clientGoals']?['short'] ?? '').toString();
        _clientMedium.text = (data['clientGoals']?['medium'] ?? '').toString();
        _clientLong.text = (data['clientGoals']?['long'] ?? '').toString();

        _parentShort.text = (data['parentGoals']?['short'] ?? '').toString();
        _parentMedium.text = (data['parentGoals']?['medium'] ?? '').toString();
        _parentLong.text = (data['parentGoals']?['long'] ?? '').toString();

        _workerShort.text = (data['workerGoals']?['short'] ?? '').toString();
        _workerMedium.text = (data['workerGoals']?['medium'] ?? '').toString();
        _workerLong.text = (data['workerGoals']?['long'] ?? '').toString();

        _supportPlanSummary.text =
            (data['agreedPlanAction']?['summary'] ?? '').toString();

        _planPersonName.text =
            (data['personsInvolved']?['name'] ?? '').toString();
        _planPersonRole.text =
            (data['personsInvolved']?['role'] ?? '').toString();
        _planPersonSignature.text =
            (data['personsInvolved']?['signature'] ?? '').toString();
        _planPersonDate.text =
            (data['personsInvolved']?['date'] ?? '').toString();

        _disagreeFullNames.text =
            (data['disagreement']?['fullNames'] ?? '').toString();
        _disagreeSignature.text =
            (data['disagreement']?['signature'] ?? '').toString();
        _disagreeDate.text =
            (data['disagreement']?['date'] ?? '').toString();
        _disagreeReasons.text =
            (data['disagreement']?['reasons'] ?? '').toString();

        if (draftJson != null && draftJson.trim().isNotEmpty) {
          statusFromStorage = 'In progress';
        } else if (savedJson != null) {
          statusFromStorage = 'Completed';
        } else if (data['status'] != null && statusFromStorage == null) {
          statusFromStorage = _normalizeLocalStatus(data['status'].toString());
        }

        final fieldToFocus = lastField ?? (draftJson != null ? lastField : null);
        if (fieldToFocus != null && _fieldKeys.containsKey(fieldToFocus)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final key = _fieldKeys[fieldToFocus];
            if (key != null && key.currentContext != null) {
              Scrollable.ensureVisible(
                key.currentContext!,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: 0.1,
              );
            }
            _focusFieldByName(fieldToFocus);
          });
        }
      } catch (_) {}
    }

    if (statusFromStorage != null) {
      if (!mounted) {
        _localStatus = statusFromStorage;
      } else {
        setState(() {
          _localStatus = statusFromStorage;
        });
      }
    }
  }

  Future<void> _persistDraft(String lastEditedField) async {
    final caseId = _caseId();
    if (caseId == null || caseId.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final draftKey = 'careplan_draft_$caseId';
    final lastFieldKey = 'careplan_lastfield_$caseId';

    final draft = {
      'caseId': caseId,
      'status': 'in_progress',
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
      'agreedPlanAction': {
        'summary': _supportPlanSummary.text.trim(),
      },
      'personsInvolved': {
        'name': _planPersonName.text.trim(),
        'role': _planPersonRole.text.trim(),
        'signature': _planPersonSignature.text.trim(),
        'date': _planPersonDate.text.trim(),
      },
      'disagreement': {
        'fullNames': _disagreeFullNames.text.trim(),
        'signature': _disagreeSignature.text.trim(),
        'date': _disagreeDate.text.trim(),
        'reasons': _disagreeReasons.text.trim(),
      },
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await prefs.setString(draftKey, jsonEncode(draft));
    await prefs.setString(lastFieldKey, lastEditedField);

    await prefs.setString('careplan_status_$caseId', 'in_progress');
    await prefs.setString('care_plan_status_$caseId', 'in_progress');
    await prefs.setBool('careplan_completed_$caseId', false);
    await prefs.setBool('care_plan_completed_$caseId', false);

    final progressKey = 'case_progress_$caseId';
    final existingProgressJson = prefs.getString(progressKey);

    Map<String, dynamic> progress = {};

    if (existingProgressJson != null && existingProgressJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(existingProgressJson);
        if (decoded is Map<String, dynamic>) {
          progress = decoded;
        }
      } catch (_) {
        progress = {};
      }
    }

    progress['carePlan'] = 'in_progress';
    progress['care_plan'] = 'in_progress';
    progress['carePlanStatus'] = 'in_progress';
    progress['care_plan_status'] = 'in_progress';

    await prefs.setString(progressKey, jsonEncode(progress));
  }

  Future<void> _persistSavedComplete(Map<String, dynamic> payload) async {
    final caseId = _caseId();
    if (caseId == null || caseId.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final savedKey = 'careplan_saved_$caseId';
    await prefs.setString(savedKey, jsonEncode(payload));
  }

  Future<void> _persistCarePlanProgressComplete(String caseId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('careplan_status_$caseId', 'completed');
    await prefs.setString('care_plan_status_$caseId', 'completed');
    await prefs.setBool('careplan_completed_$caseId', true);
    await prefs.setBool('care_plan_completed_$caseId', true);

    final progressKey = 'case_progress_$caseId';
    final existingProgressJson = prefs.getString(progressKey);

    Map<String, dynamic> progress = {};

    if (existingProgressJson != null && existingProgressJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(existingProgressJson);
        if (decoded is Map<String, dynamic>) {
          progress = decoded;
        }
      } catch (_) {
        progress = {};
      }
    }

    progress['carePlan'] = 'completed';
    progress['care_plan'] = 'completed';
    progress['carePlanStatus'] = 'completed';
    progress['care_plan_status'] = 'completed';

    await prefs.setString(progressKey, jsonEncode(progress));
  }

  void _applyCarePlanCompleteToIncomingCase() {
    final caseObj = widget.mgysdCase;
    if (caseObj == null) return;

    try {
      if (caseObj is Map) {
        caseObj['carePlan'] = 'completed';
        caseObj['care_plan'] = 'completed';
        caseObj['carePlanStatus'] = 'completed';
        caseObj['care_plan_status'] = 'completed';
      } else {
        try {
          caseObj.carePlan = 'completed';
        } catch (_) {}

        try {
          caseObj.care_plan = 'completed';
        } catch (_) {}

        try {
          caseObj.carePlanStatus = 'completed';
        } catch (_) {}

        try {
          caseObj.care_plan_status = 'completed';
        } catch (_) {}
      }
    } catch (_) {}
  }

  void _focusFieldByName(String name) {
    switch (name) {
      case 'clientShort':
        FocusScope.of(context).requestFocus(_clientShortFocus);
        break;
      case 'clientMedium':
        FocusScope.of(context).requestFocus(_clientMediumFocus);
        break;
      case 'clientLong':
        FocusScope.of(context).requestFocus(_clientLongFocus);
        break;
      case 'parentShort':
        FocusScope.of(context).requestFocus(_parentShortFocus);
        break;
      case 'parentMedium':
        FocusScope.of(context).requestFocus(_parentMediumFocus);
        break;
      case 'parentLong':
        FocusScope.of(context).requestFocus(_parentLongFocus);
        break;
      case 'workerShort':
        FocusScope.of(context).requestFocus(_workerShortFocus);
        break;
      case 'workerMedium':
        FocusScope.of(context).requestFocus(_workerMediumFocus);
        break;
      case 'workerLong':
        FocusScope.of(context).requestFocus(_workerLongFocus);
        break;
      case 'supportPlanSummary':
        FocusScope.of(context).requestFocus(_supportPlanSummaryFocus);
        break;
      case 'planPersonName':
        FocusScope.of(context).requestFocus(_planPersonNameFocus);
        break;
      case 'planPersonRole':
        FocusScope.of(context).requestFocus(_planPersonRoleFocus);
        break;
      case 'planPersonSignature':
        FocusScope.of(context).requestFocus(_planPersonSignatureFocus);
        break;
      case 'planPersonDate':
        FocusScope.of(context).requestFocus(_planPersonDateFocus);
        break;
      case 'disagreeFullNames':
        FocusScope.of(context).requestFocus(_disagreeFullNamesFocus);
        break;
      case 'disagreeSignature':
        FocusScope.of(context).requestFocus(_disagreeSignatureFocus);
        break;
      case 'disagreeDate':
        FocusScope.of(context).requestFocus(_disagreeDateFocus);
        break;
      case 'disagreeReasons':
        FocusScope.of(context).requestFocus(_disagreeReasonsFocus);
        break;
      default:
        break;
    }
  }

  Widget _sectionHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _goalField(
      String label,
      TextEditingController controller, {
        int maxLines = 3,
        required String fieldName,
        required FocusNode focusNode,
        bool requiredField = true,
      }) {
    return Padding(
      key: _fieldKeys[fieldName],
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
              focusNode: focusNode,
              controller: controller,
              maxLines: maxLines,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black45),
              ),
              style: const TextStyle(fontSize: 14),
              validator: (v) {
                if (requiredField && (v == null || v.trim().isEmpty)) {
                  return 'Please enter $label';
                }
                return null;
              },
              onChanged: (_) {
                _persistDraft(fieldName);
              },
              onEditingComplete: () {
                _persistDraft(fieldName);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markComplete() async {
    if (!_formKey.currentState!.validate()) return;
    await _onSubmitWithStatus('complete');
  }

  Future<void> _saveDraft() async {
    final lastField = _currentFocusedFieldName();
    await _persistDraft(lastField ?? 'clientShort');
    await _onSubmitWithStatus('draft', validate: false);
  }

  String? _currentFocusedFieldName() {
    if (_clientShortFocus.hasFocus) return 'clientShort';
    if (_clientMediumFocus.hasFocus) return 'clientMedium';
    if (_clientLongFocus.hasFocus) return 'clientLong';
    if (_parentShortFocus.hasFocus) return 'parentShort';
    if (_parentMediumFocus.hasFocus) return 'parentMedium';
    if (_parentLongFocus.hasFocus) return 'parentLong';
    if (_workerShortFocus.hasFocus) return 'workerShort';
    if (_workerMediumFocus.hasFocus) return 'workerMedium';
    if (_workerLongFocus.hasFocus) return 'workerLong';

    if (_supportPlanSummaryFocus.hasFocus) return 'supportPlanSummary';

    if (_planPersonNameFocus.hasFocus) return 'planPersonName';
    if (_planPersonRoleFocus.hasFocus) return 'planPersonRole';
    if (_planPersonSignatureFocus.hasFocus) return 'planPersonSignature';
    if (_planPersonDateFocus.hasFocus) return 'planPersonDate';

    if (_disagreeFullNamesFocus.hasFocus) return 'disagreeFullNames';
    if (_disagreeSignatureFocus.hasFocus) return 'disagreeSignature';
    if (_disagreeDateFocus.hasFocus) return 'disagreeDate';
    if (_disagreeReasonsFocus.hasFocus) return 'disagreeReasons';

    return null;
  }

  Future<void> _onSubmitWithStatus(String status, {bool validate = true}) async {
    if (validate && !_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);

    setState(() => _submitting = true);

    final payload = {
      'caseId': _caseId() ?? '',
      'householdTei': widget.householdTei,
      'householdName': widget.householdName,
      'clientName': widget.clientName,
      'status': status == 'draft' ? 'in_progress' : status,
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
      'agreedPlanAction': {
        'summary': _supportPlanSummary.text.trim(),
      },
      'personsInvolved': {
        'name': _planPersonName.text.trim(),
        'role': _planPersonRole.text.trim(),
        'signature': _planPersonSignature.text.trim(),
        'date': _planPersonDate.text.trim(),
      },
      'disagreement': {
        'fullNames': _disagreeFullNames.text.trim(),
        'signature': _disagreeSignature.text.trim(),
        'date': _disagreeDate.text.trim(),
        'reasons': _disagreeReasons.text.trim(),
      },
      'updatedAt': DateTime.now().toIso8601String(),
    };

    try {
      debugPrint('Care plan payload ($status): $payload');

      if (status == 'draft') {
        final lastField = _currentFocusedFieldName() ?? 'clientShort';
        await _persistDraft(lastField);
        _carePlanCompletedForParent = false;
      } else {
        final caseId = _caseId();
        if (caseId != null && caseId.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();

          await _persistSavedComplete(payload);
          await _persistCarePlanProgressComplete(caseId);
          _applyCarePlanCompleteToIncomingCase();

          _carePlanCompletedForParent = true;

          await prefs.remove('careplan_draft_$caseId');
          await prefs.remove('careplan_lastfield_$caseId');
        }
      }

      if (!mounted) return;

      setState(() {
        _localStatus =
        status == 'complete' ? 'Completed' : _normalizeLocalStatus(status);
      });

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            status == 'draft' ? 'Draft saved' : 'Care plan marked complete',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (!mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'complete':
      case 'completed':
        return Colors.green.shade600;
      case 'draft':
      case 'in progress':
      case 'in-progress':
        return Colors.orange.shade600;
      case 'not started':
      default:
        return Colors.grey.shade600;
    }
  }

  void _popWithCarePlanResult() {
    final result = _carePlanCompletedResult();

    setState(() {
      _carePlanCompletedForParent = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pop(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String statusText = _normalizeLocalStatus(_localStatus);
    final String? caseId = _caseId();

    return PopScope<Object?>(
      canPop: !_carePlanCompletedForParent,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;

        if (_carePlanCompletedForParent) {
          _popWithCarePlanResult();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Care Plan'),
          backgroundColor: widget.color,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                                  Text(
                                    'Client: ${widget.clientName}',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                if (caseId != null)
                                  Text(
                                    'Case ID: $caseId',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
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
                      child: Text(
                        'Household: ${widget.householdName}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),

                  _sectionHeading("Client's goals"),
                  _goalField(
                    'Short term (next 3 months)',
                    _clientShort,
                    fieldName: 'clientShort',
                    focusNode: _clientShortFocus,
                  ),
                  _goalField(
                    'Medium term (next 12 months)',
                    _clientMedium,
                    fieldName: 'clientMedium',
                    focusNode: _clientMediumFocus,
                  ),
                  _goalField(
                    'Long term (beyond 1 year)',
                    _clientLong,
                    fieldName: 'clientLong',
                    focusNode: _clientLongFocus,
                    maxLines: 4,
                  ),

                  _sectionHeading('Parent/Guardian goals (if appropriate)'),
                  _goalField(
                    'Short term (next 3 months)',
                    _parentShort,
                    fieldName: 'parentShort',
                    focusNode: _parentShortFocus,
                  ),
                  _goalField(
                    'Medium term (next 12 months)',
                    _parentMedium,
                    fieldName: 'parentMedium',
                    focusNode: _parentMediumFocus,
                  ),
                  _goalField(
                    'Long term (beyond 1 year)',
                    _parentLong,
                    fieldName: 'parentLong',
                    focusNode: _parentLongFocus,
                    maxLines: 4,
                  ),

                  _sectionHeading('Social worker goals'),
                  _goalField(
                    'Short term (next 3 months)',
                    _workerShort,
                    fieldName: 'workerShort',
                    focusNode: _workerShortFocus,
                  ),
                  _goalField(
                    'Medium term (next 12 months)',
                    _workerMedium,
                    fieldName: 'workerMedium',
                    focusNode: _workerMediumFocus,
                  ),
                  _goalField(
                    'Long term (beyond 1 year)',
                    _workerLong,
                    fieldName: 'workerLong',
                    focusNode: _workerLongFocus,
                    maxLines: 4,
                  ),

                  _sectionHeading('Agreed plan of action (support plan - summary)'),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Give deliverables and milestone outcomes and results for interval review '
                          '(road Map for plan of action) to avoid late reporting of inability to reach goals.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                  _goalField(
                    'Support plan summary',
                    _supportPlanSummary,
                    fieldName: 'supportPlanSummary',
                    focusNode: _supportPlanSummaryFocus,
                    maxLines: 4,
                  ),

                  _sectionHeading('Persons involved in making the plan'),
                  _goalField(
                    'Name',
                    _planPersonName,
                    fieldName: 'planPersonName',
                    focusNode: _planPersonNameFocus,
                    maxLines: 1,
                  ),
                  _goalField(
                    'Role',
                    _planPersonRole,
                    fieldName: 'planPersonRole',
                    focusNode: _planPersonRoleFocus,
                    maxLines: 1,
                  ),
                  _goalField(
                    'Signature',
                    _planPersonSignature,
                    fieldName: 'planPersonSignature',
                    focusNode: _planPersonSignatureFocus,
                    maxLines: 1,
                  ),
                  _goalField(
                    'Date',
                    _planPersonDate,
                    fieldName: 'planPersonDate',
                    focusNode: _planPersonDateFocus,
                    maxLines: 1,
                  ),

                  _sectionHeading('Details of anyone who disagrees with the plan and why'),
                  _goalField(
                    'Full names',
                    _disagreeFullNames,
                    fieldName: 'disagreeFullNames',
                    focusNode: _disagreeFullNamesFocus,
                    maxLines: 1,
                    requiredField: false,
                  ),
                  _goalField(
                    'Signature',
                    _disagreeSignature,
                    fieldName: 'disagreeSignature',
                    focusNode: _disagreeSignatureFocus,
                    maxLines: 1,
                    requiredField: false,
                  ),
                  _goalField(
                    'Date',
                    _disagreeDate,
                    fieldName: 'disagreeDate',
                    focusNode: _disagreeDateFocus,
                    maxLines: 1,
                    requiredField: false,
                  ),
                  _goalField(
                    'Reasons',
                    _disagreeReasons,
                    fieldName: 'disagreeReasons',
                    focusNode: _disagreeReasonsFocus,
                    maxLines: 4,
                    requiredField: false,
                  ),

                  const SizedBox(height: 20),

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
                          child: Text(
                            'Save Draft',
                            style: TextStyle(color: Colors.purple.shade700),
                          ),
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
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
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
      ),
    );
  }
}