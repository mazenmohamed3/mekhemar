import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../views/components/Dialog/stay_signed_in_dialog.dart';
import '../../../Router/app_page.dart';
import '../../../repo/local/secure_storage_helper.dart';

class AuthDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserCredential? userMessage;

  Future<UserCredential> emailAndPasswordLogin({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      userMessage = userCredential;

      if (rememberMe) {
        await SecureStorageHelper.writeValueToKey(key: "email", value: email);
        await SecureStorageHelper.writeValueToKey(
          key: "password",
          value: password,
        );
        await SecureStorageHelper.writeValueToKey(
          key: "isGoogleSignIn",
          value: "false",
        );
      } else {
        await clearSavedLogin();
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<Map<String, String?>> loadSavedLogin() async {
    final email = await SecureStorageHelper.readValueFromKey(key: "email");
    final password = await SecureStorageHelper.readValueFromKey(
      key: "password",
    );
    final isGoogleSignIn = await SecureStorageHelper.readValueFromKey(
      key: "isGoogleSignIn",
    );
    return {
      "email": email,
      "password": password,
      "isGoogleSignIn": isGoogleSignIn,
    };
  }

  Future<void> clearSavedLogin() async {
    await SecureStorageHelper.deleteValueFromKey(key: "email");
    await SecureStorageHelper.deleteValueFromKey(key: "password");
    await SecureStorageHelper.deleteValueFromKey(key: "isGoogleSignIn");
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      // Create the user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update the user's display name
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      final updatedUser = _auth.currentUser;
      print("User's name is now: ${updatedUser?.displayName}");

      bool rememberMe = false;

      if (context.mounted) {
        final bool? choice = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const StaySignedInDialog(),
        );

        rememberMe = choice ?? false;
      }

      if (rememberMe) {
        await SecureStorageHelper.writeValueToKey(key: "email", value: email);
        await SecureStorageHelper.writeValueToKey(
          key: "password",
          value: password,
        );
        await SecureStorageHelper.writeValueToKey(
          key: "isGoogleSignIn",
          value: "false",
        );
      } else {
        await clearSavedLogin();
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserCredential?> signInWithGoogle({
    required BuildContext context,
    bool showDialogPrompt = true,
  }) async {
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

      bool rememberMe = false;

      if (showDialogPrompt && context.mounted) {
        final bool? choice = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const StaySignedInDialog(),
        );

        rememberMe = choice ?? false;
      }

      if (rememberMe) {
        await SecureStorageHelper.writeValueToKey(
          key: "email",
          value: googleUser.email,
        );
        await SecureStorageHelper.writeValueToKey(
          key: "isGoogleSignIn",
          value: "true",
        );
      } else if (showDialogPrompt) {
        await clearSavedLogin();
      }

      print('Google sign-in successful: $userCredential');
      return userCredential;
    } catch (e) {
      print('Google sign-in error: $e');
      throw Exception('Google sign-in failed');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  void logout(BuildContext context) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    userMessage = null;
    await clearSavedLogin();
    if (!context.mounted) return;
    //TODO: remove navigation from here
    context.go(AppPage.login);
  }
}
