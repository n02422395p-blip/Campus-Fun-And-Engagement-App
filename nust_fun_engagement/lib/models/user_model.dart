class User {
  final int id;
  final String name;
  final String email;
  final String studentId;
  final String department;
  final String avatar;
  final String bio;
  final String joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.department,
    required this.avatar,
    required this.bio,
    required this.joinDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      studentId: json['studentId'],
      department: json['department'],
      avatar: json['avatar'],
      bio: json['bio'],
      joinDate: json['joinDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'studentId': studentId,
      'department': department,
      'avatar': avatar,
      'bio': bio,
      'joinDate': joinDate,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? studentId,
    String? department,
    String? avatar,
    String? bio,
    String? joinDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      studentId: studentId ?? this.studentId,
      department: department ?? this.department,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}
