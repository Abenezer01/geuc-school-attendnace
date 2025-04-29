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
      userType: json['userType'],
      userId: json['userId'],
      sessionclassId: json['sessionclassId'],
      status: json['status'],
      remarks: json['remarks'],
      attendanceDate: DateTime.parse(json['attendanceDate']),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userType': userType,
      'userId': userId,
      'sessionclassId': sessionclassId,
      'status': status,
      'remarks': remarks,
      'attendanceDate': attendanceDate.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}