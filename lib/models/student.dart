import 'package:flutter_attendance/models/member.dart';

class Student {
  final String id;
  final String memberId;
  final Member member;
  final String classId;

  Student({
    required this.id,
    required this.memberId,
    required this.member,
    required this.classId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      memberId: json['member_id'],
      member: Member.fromJson(json['member']),
      classId: json['class_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'member': member.toJson(),
      'class_id': classId,
    };
  }
}
