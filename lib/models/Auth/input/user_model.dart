class UserModel {
  final String email;
  final String? password;
  final String? username;

  UserModel({
    required this.email,
    this.password,
    this.username,
  });

  // You can add methods to serialize/deserialize to/from Firestore or Firebase
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'username': username,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      password: map['password'],
      username: map['username'],
    );
  }
}