// ignore_for_file: file_names

class UsersNotConfirmed {
  final String username;
  final String userId;
  final String email;
  final String role;
  //final String createdAt;

  UsersNotConfirmed({
    required this.username,
    required this.userId,
    required this.email,
    required this.role,
    //required this.createdAt
  });

  factory UsersNotConfirmed.fromMap(Map<String, dynamic> map) {
    return UsersNotConfirmed(
      role: map['Ruolo'] ?? '',
      email: map['email'] ?? '',
      userId: map['user-id'] ?? '',
      username: map['username'] ?? '',
      //createdAt: map['createdAt'] as String,
    );
  }
}
