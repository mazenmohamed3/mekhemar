import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../Router/app_page.dart';
import '../../../repo/local/secure_storage_helper.dart';
import '../../Auth/sources/auth_datasource.dart';

class SplashController {
  const SplashController(AuthDatasource authController) : _authController = authController;

  final AuthDatasource _authController;

  Future<void> _attemptAutoLogin({required BuildContext context}) async {
    final savedData = await _authController.loadSavedLogin();
    final email = savedData['email'];
    final password = savedData['password'];
    final isGoogleSignIn = savedData['isGoogleSignIn'];

    if (email != null && isGoogleSignIn != null) {
      try {
        if (isGoogleSignIn == "true") {
          if(!context.mounted) return;
          await _authController.signInWithGoogle(context: context, showDialogPrompt: false);
          if (!context.mounted) return;
          context.go(AppPage.home);
        } else if (password != null) {
          await _authController.emailAndPasswordLogin(
            email: email,
            password: password,
            rememberMe: true,
          );
          if (!context.mounted) return;
          context.go(AppPage.home);
        }
      } catch (e) {
        print('Auto-Login failed: $e');
      }
    } else {
      if (!context.mounted) return;
      context.go(AppPage.login);
    }
  }

  Future<void> checkFirstTime({required BuildContext context}) async {
    await Future.delayed(Duration(seconds: 5));

    String? isFirstTime = await SecureStorageHelper.readValueFromKey(key: 'isFirstTime');

    if (isFirstTime == null) {
      // First time ever opening the app
      await SecureStorageHelper.writeValueToKey(key: 'isFirstTime', value: 'false');

      if (!context.mounted) return;

      context.go(AppPage.onboarding);
    } else {
      if (!context.mounted) return;

      _attemptAutoLogin(context: context);
    }
  }
}