import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mekhemar/controllers/Pages/Auth/services/auth_service.dart';
import '../../../../models/Auth/input/user_model.dart';
import '../../../../views/components/Snack Bar/failed_snackbar.dart';
import '../../../Features/Biometric/Controller/biometric_controller.dart';
import '../../../Repos/local/secure_storage_helper.dart';
import '../../../Router/app_page.dart';
import '../../Auth/sources/auth_datasource.dart';

class SplashController {
  const SplashController(
    AuthDatasource authDatasource,
    BiometricController biometricController,
  ) : _authDatasource = authDatasource,
      _biometricController = biometricController;

  final AuthDatasource _authDatasource;
  final BiometricController _biometricController;

  Future<void> _attemptAutoLogin({required BuildContext context}) async {
    final savedData = await _authDatasource.loadSavedLogin();
    final email = savedData['email'];
    final password = savedData['password'];
    final isGoogleSignIn = savedData['isGoogleSignIn'];

    if ((email != null && password != null) || isGoogleSignIn != null) {
      try {
        final canUseBiometrics =
            await _biometricController.canCheckBiometrics();

        if (canUseBiometrics) {
          final isAuthenticated = await _biometricController.authenticate();

          if (!isAuthenticated) {
            if (!context.mounted) return;
            _handleLoginFailure(context, message: 'biometricFailed');
            return;
          }

          if (isGoogleSignIn == "true") {
            if (!context.mounted) return;
            await _authDatasource.signInWithGoogle(
              context: context,
              showDialogPrompt: false,
            );
          } else {
            final userModel = UserModel(email: email!, password: password!);

            if (!context.mounted) return;
            await _authDatasource.emailAndPasswordLogin(
              userModel: userModel,
              rememberMe: true,
              context: context,
            );
          }

          if (context.mounted) context.go(AppPage.home);
        } else {
          if (!context.mounted) return;
          _handleLoginFailure(context, message: 'biometricUnsupported');
        }
      } catch (e) {
        if (!context.mounted) return;
        _handleLoginFailure(
          context,
          message: 'loginFailed',
          args: [e.toString()],
        );
      }
    } else {
      await SecureStorageHelper.deleteValueFromKey(key: 'email');
      await SecureStorageHelper.deleteValueFromKey(key: 'password');
      await SecureStorageHelper.deleteValueFromKey(key: 'isGoogleSignIn');
      if (!context.mounted) return;
      context.go(AppPage.login);
    }
  }

  void _handleLoginFailure(
    BuildContext context, {
    required String message,
    List<String>? args,
  }) async {
    await SecureStorageHelper.clearAllValues();
    await SecureStorageHelper.writeValueToKey(
      key: 'isFirstTime',
      value: 'false',
    );

    await AuthService.setRememberMe(false);

    if (!context.mounted) return;
    showFailedSnackBar(context, title: message, args: args);

    context.go(AppPage.login);
  }

  Future<void> checkFirstTime({required BuildContext context}) async {
    await Future.delayed(Duration(seconds: 5));

    String? isFirstTime = await SecureStorageHelper.readValueFromKey(
      key: 'isFirstTime',
    );

    if (isFirstTime == null) {
      await SecureStorageHelper.writeValueToKey(
        key: 'isFirstTime',
        value: 'false',
      );

      if (!context.mounted) return;
      context.go(AppPage.onboarding);
    } else if (await AuthService.getRememberMe()) {
      if (!context.mounted) return;
      _attemptAutoLogin(context: context);
    } else {
      if (!context.mounted) return;
      context.go(AppPage.login);
    }
  }
}
