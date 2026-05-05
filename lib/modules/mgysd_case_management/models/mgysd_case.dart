
class MgysdCase {
  final String id;                // enrollment UID
  final String caseNo;            // usually same as enrollment UID
  final String fullName;          // from TEI attributes
  final String district;          // optional (can be empty for now)
  final String status;            // ACTIVE / COMPLETED / etc.
  final String? phone;            // optional
  final String? enrollmentDate;   // yyyy-mm-dd (stored as string offline)

  const MgysdCase({
    required this.id,
    required this.caseNo,
    required this.fullName,
    required this.district,
    required this.status,
    this.phone,
    this.enrollmentDate,
  });

  /// Useful helper getters
  bool get isActive => status.toUpperCase() == 'ACTIVE';

  String get displayStatus {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'Open';
      case 'COMPLETED':
        return 'Closed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  DateTime? get parsedEnrollmentDate {
    if (enrollmentDate == null || enrollmentDate!.isEmpty) return null;
    try {
      return DateTime.parse(enrollmentDate!);
    } catch (_) {
      return null;
    }
  }
}

