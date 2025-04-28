class User {
  final String email;
  final String username;
  final String password;

  const User({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              email == other.email &&
              username == other.username;

  @override
  int get hashCode => email.hashCode ^ username.hashCode;
}