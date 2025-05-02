import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthResult {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? providerId;
  final bool isEmailVerified;
  final String? phoneNumber;

  FirebaseAuthResult({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.providerId,
    this.isEmailVerified = false,
    this.phoneNumber,
  });

  factory FirebaseAuthResult.fromUser(User user) {
    return FirebaseAuthResult(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      providerId: user.providerData.isNotEmpty ? user.providerData[0].providerId : null,
      isEmailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
    );
  }
}