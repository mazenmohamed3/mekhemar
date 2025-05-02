import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mekhemar/views/components/Snack%20Bar/failed_snackbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../models/user_model.dart';
import '../../../../views/components/Dialog/stay_signed_in_dialog.dart';
import '../../../Router/app_page.dart';
import '../services/auth_service.dart';

class AuthDatasource {
  AuthDatasource(AuthService loginService) : _loginService = loginService;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _loginService;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static UserCredential? userMessage;

  Future<FirebaseAuthResult> emailAndPasswordLogin({
    required String email,
    required String password,
    required bool rememberMe,
    required BuildContext context,
  }) async {
    try {
      // Sign in using email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save the UserCredential to the class variable
      userMessage = userCredential; // <-- Add this line

      final user = FirebaseAuthResult.fromUser(userCredential.user!);

      // Save user credentials if rememberMe is true
      if (rememberMe) {
        await _loginService.saveLogin(
          email: user.email,
          password: password,
          username: user.displayName ?? '',
          isGoogleSignIn: false,
        );
      } else {
        await _loginService.clearSavedLogin();
      }

      // Return custom FirebaseAuthResult model
      return user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showFailedSnackBar(
          context,
          title: _loginService.handleFirebaseAuthException(e),
        );
      }
      rethrow;
    }
  }

  Future<FirebaseAuthResult> signUp({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      userMessage = userCredential; // <-- Add this line

      bool rememberMe = false;

      if (context.mounted) {
        final bool? choice = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const StaySignedInDialog(),
        );

        rememberMe = choice ?? false;
      }
      final user = FirebaseAuthResult.fromUser(userCredential.user!);

      if (rememberMe) {
        await _loginService.saveLogin(
          email: user.email,
          password: password,
          username: name,
          isGoogleSignIn: false,
        );
      } else {
        await _loginService.clearSavedLogin();
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showFailedSnackBar(
          context,
          title: _loginService.handleFirebaseAuthException(e),
        );
      }
      rethrow;
    }
  }

  Future<FirebaseAuthResult?> signInWithGoogle({
    required BuildContext context,
    bool showDialogPrompt = true,
  }) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw 'googleSignInAborted';

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
      final user = FirebaseAuthResult.fromUser(userCredential.user!);

      // Save login credentials if rememberMe is true
      if (rememberMe) {
        await _loginService.saveLogin(
          email: user.email,
          password: '',
          username: user.displayName ?? '',
          isGoogleSignIn: true,
        );
      } else if (showDialogPrompt) {
        await _loginService.clearSavedLogin();
      }

      // Returning a custom result model (FirebaseAuthResult)
      return user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showFailedSnackBar(
          context,
          title: _loginService.handleFirebaseAuthException(e),
        );
      }
      rethrow;
    } catch (e) {
      if (context.mounted) {
        showFailedSnackBar(context, title: e.toString());
      }
      rethrow;
    }
  }

  Future<FirebaseAuthResult?> signInWithApple({
    required BuildContext context,
  }) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      userMessage = userCredential;

      bool rememberMe = false;

      if (context.mounted) {
        final bool? choice = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const StaySignedInDialog(),
        );

        rememberMe = choice ?? false;
      }

      final user = FirebaseAuthResult.fromUser(userCredential.user!);

      // Save login credentials if rememberMe is true
      if (rememberMe) {
        await _loginService.saveLogin(
          email: user.email,
          password: '',
          username: user.displayName ?? '',
          isGoogleSignIn: false,
        );
      } else {
        await _loginService.clearSavedLogin();
      }

      // Returning custom FirebaseAuthResult model
      return user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showFailedSnackBar(
          context,
          title: _loginService.handleFirebaseAuthException(e),
        );
      }
      rethrow;
    } catch (e) {
      if (context.mounted) {
        showFailedSnackBar(context, title: e.toString());
      }
      rethrow;
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _loginService.handleFirebaseAuthException(e);
    }
  }

  Future<Map<String, String?>> loadSavedLogin() async {
    return await _loginService.loadSavedLogin();
  }

  void logout(BuildContext context) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    userMessage = null;
    await _loginService.clearSavedLogin();
    if (!context.mounted) return;
    context.go(AppPage.login);
  }
}