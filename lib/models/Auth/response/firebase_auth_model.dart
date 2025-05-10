import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthResult {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  FirebaseAuthResult({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  factory FirebaseAuthResult.fromUser(User user) {
    return FirebaseAuthResult(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  // Convert to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  // Convert from a map
  static FirebaseAuthResult fromMap(Map<String, dynamic> map) {
    return FirebaseAuthResult(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
    );
  }
}