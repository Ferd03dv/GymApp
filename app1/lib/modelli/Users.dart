// ignore_for_file: file_names

class Users {
  final String username;
  final String userId;
  final String email;
  final String role;

  Users({
    required this.username,
    required this.userId,
    required this.email,
    required this.role,
  });

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      userId: map['_id'].toString(),
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
