
import 'dart:convert';

class MgysdReportedCase {
  final String id; // local id
  final String program;
  final String programStage;
  final String orgUnit;
  final String eventDate; // yyyy-mm-dd
  final String status; // PENDING / SYNCED / FAILED
  final String payloadJson; // JSON string
  final String createdAt; // ISO string
  final String? lastError;

  const MgysdReportedCase({
    required this.id,
    required this.program,
    required this.programStage,
    required this.orgUnit,
    required this.eventDate,
    required this.status,
    required this.payloadJson,
    required this.createdAt,
    this.lastError,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'program': program,
      'programStage': programStage,
      'orgUnit': orgUnit,
      'eventDate': eventDate,
      'status': status,
      'payloadJson': payloadJson,
      'createdAt': createdAt,
      'lastError': lastError ?? '',
    };
  }

  static MgysdReportedCase fromMap(Map<String, dynamic> map) {
    return MgysdReportedCase(
      id: (map['id'] ?? '').toString(),
      program: (map['program'] ?? '').toString(),
      programStage: (map['programStage'] ?? '').toString(),
      orgUnit: (map['orgUnit'] ?? '').toString(),
      eventDate: (map['eventDate'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      payloadJson: (map['payloadJson'] ?? '').toString(),
      createdAt: (map['createdAt'] ?? '').toString(),
      lastError: ((map['lastError'] ?? '').toString().trim().isEmpty)
          ? null
          : (map['lastError'] ?? '').toString(),
    );
  }

  /// This returns the DHIS2-like event payload you will POST later
  /// (you can enrich it during sync with real orgUnit, etc.)
  Map<String, dynamic> toDhis2EventPayload() {
    final decoded = jsonDecode(payloadJson);
    return decoded is Map<String, dynamic> ? decoded : {};
  }
}
