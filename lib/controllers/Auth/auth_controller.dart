import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Secure Storage Helper/secure_storage_helper.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserCredential? userMessage;

  Future<UserCredential> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: identifier,
        password: password,
      );
      userMessage = userCredential;

      // if (rememberMe) {
      //   await SecureStorageHelper.saveLoginInfo(identifier, password);
      // } else {
      //   await SecureStorageHelper.clearLoginInfo();
      // }

      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Future<Map<String, String?>> loadSavedLogin() async {
  //   return await SecureStorageHelper.loadLoginInfo();
  // }
  //
  // Future<void> clearSavedLogin() async {
  //   await SecureStorageHelper.clearLoginInfo();
  // }

  Future<UserCredential> signUp({
    required String identifier,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: identifier,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Reload user to get the latest profile info
      await userCredential.user?.reload();

      // Fetch the updated user
      final updatedUser = _auth.currentUser;

      // Update userMessage using the original userCredential,
      // but now the user object inside it will reflect the updated user
      userMessage = userCredential;

      print("User's name is now: ${updatedUser?.displayName}");
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in aborted');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      userMessage = userCredential;

      print('Google sign-in successful: $userCredential');
      notifyListeners();
      return userCredential;
    } catch (e) {
      print('Google sign-in error: $e');
      throw Exception('Google sign-in failed');
    }
  }

  void logout(context) {
    _auth.signOut();
    _googleSignIn.signOut();
    userMessage = null;
    Navigator.pushReplacementNamed(context, '/login');
    notifyListeners();
  }
}
