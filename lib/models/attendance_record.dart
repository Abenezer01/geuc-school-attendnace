class AttendanceRecord {
  final int? id;
  final String userType; // e.g. 'teacher' or 'student'
  final String userId;
  final int? sessionclassId;
  final String status; // 'present', 'absent', 'late', 'excused'
  final String? remarks;
  final DateTime attendanceDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AttendanceRecord({
    this.id,
    required this.userType,
    required this.userId,
    this.sessionclassId,
    required this.status,
    this.remarks,
    required this.attendanceDate,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      userType: json['user_type'],
      userId: json['user_id'],
      sessionclassId: json['session_class_id'],
      status: json['status'],
      remarks: json['remarks'],
      attendanceDate: DateTime.parse(json['attendance_date']),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_type': userType,
      'user_id': userId,
      'session_class_id': sessionclassId,
      'status': status,
      'remarks': remarks,
      'attendance_date': attendanceDate.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}