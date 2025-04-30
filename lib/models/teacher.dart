import 'package:flutter_attendance/models/member.dart';

class Teacher {
  final String id;
  final String memberId;
  final String bio;
  final Member member;

  Teacher({
    required this.id,
    required this.memberId,
    required this.bio,
    required this.member,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      memberId: json['member_id'],
      bio: json['bio'],
      member: Member.fromJson(json['member']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'bio': bio,
      'member': member.toJson(),
    };
  }
}