class Member {
  final String id;
  final String name;
  final String email;


  Member({
    required this.id,
    required this.name,
    required this.email,

  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

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
}

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
}