import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../models/Auth/input/user_model.dart';
import '../../../../Router/app_page.dart';
import '../../services/auth_service.dart';
import '../../sources/auth_datasource.dart';

class LoginController {
  LoginController(this.authDataSource, this.loginService);

  final AuthDatasource authDataSource;
  final AuthService loginService;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode loginButtonFocus = FocusNode();

  late void Function(void Function()) setEmailButtonState;
  late void Function(void Function()) setGoogleButtonState;
  late void Function(void Function()) setRememberMeState;

  bool rememberMe = false;
  bool isEmailNoAction = true;
  bool isGoogleNoAction = false;
  bool isAppleNoAction = false;
  bool isEmailLoading = false;
  bool isGoogleLoading = false;

  void toggleRememberMe({bool? value}) {
    if (value == null) {
      rememberMe = false;
    } else {
      setRememberMeState(() {
        rememberMe = value;
      });
    }
  }

  void toggleNoAction({bool? value, bool? isGoogle, bool? isApple}) {
    if (value == null) {
      isGoogleNoAction = false;
      isEmailNoAction = true;
      isAppleNoAction = true; // Default no action for Apple
    } else if (isGoogle == true) {
      setGoogleButtonState(() {
        isGoogleNoAction = value;
      });
    } else {
      setEmailButtonState(() {
        isEmailNoAction = value;
      });
    }
  }

  void onChanged(String value) {
    final isEmailValid =
        loginService.validateEmail(emailController.text) == null;
    final isPasswordValid =
        loginService.validatePassword(passwordController.text) == null;

    // Check if both email and password are valid and the button is not loading
    if (isEmailValid &&
        isPasswordValid &&
        !isEmailLoading &&
        !isGoogleLoading) {
      setEmailButtonState(() {
        isEmailNoAction = false; // Enable the email button
      });
    } else {
      setEmailButtonState(() {
        isEmailNoAction = true; // Disable the email button
      });
    }
  }

  void onFieldSubmitted(String value) {
    final isEmailValid =
        loginService.validateEmail(emailController.text) == null;
    final isPasswordValid =
        loginService.validatePassword(passwordController.text) == null;

    if (emailFocus.hasFocus && (!isEmailValid || !isPasswordValid)) {
      emailFocus.unfocus();
      Future.microtask(() {
        if (!isEmailValid) {
          emailFocus.requestFocus();
        } else {
          passwordFocus.requestFocus();
        }
        toggleNoAction(value: true);
      });
    } else if (passwordFocus.hasFocus && (!isEmailValid || !isPasswordValid)) {
      passwordFocus.unfocus();
      Future.microtask(() {
        if (!isPasswordValid) {
          passwordFocus.requestFocus();
        } else {
          emailFocus.requestFocus();
        }
        toggleNoAction(value: true);
      });
    } else {
      toggleNoAction(value: false);
      loginButtonFocus
        ..canRequestFocus = true
        ..requestFocus();
    }
  }

  void onTapOutside() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (formKey.currentState!.validate()) {
        toggleNoAction(value: false);
      }
    } else {
      toggleNoAction(value: true);
    }
  }

  void toggleIsLoading({bool? value, bool? isGoogle, bool? isApple}) {
    if (value == null) {
      isGoogleLoading = false;
      isEmailLoading = false;
    } else if (isGoogle == true) {
      setGoogleButtonState(() {
        isGoogleLoading = value;
      });
      toggleNoAction(
        value: value,
        isGoogle: isGoogle,
        isApple: isApple,
      ); // Pass Apple state as well
    } else {
      setEmailButtonState(() {
        isEmailLoading = value;
      });
      toggleNoAction(
        value: value,
        isGoogle: isGoogle,
        isApple: isApple,
      ); // Pass Google and Apple states
    }
  }

  String? emailValidator(String? value) => loginService.validateEmail(value);

  String? passwordValidator(String? value) =>
      loginService.validatePassword(value);

  Future<void> loginWithEmailAndPassword({
    required BuildContext context,
  }) async {
    if (isGoogleLoading) return;
    if (formKey.currentState!.validate()) {
      try {
        toggleIsLoading(value: true, isGoogle: false);

        // Create a UserModel from the input values
        UserModel userModel = UserModel(
          email: emailController.text,
          password: passwordController.text,
        );

        await authDataSource.emailAndPasswordLogin(
          rememberMe: rememberMe,
          userModel: userModel, // Pass the UserModel
          context: context,
        );

        if (!context.mounted) return;

        dispose();
        context.go(
          AppPage.home,
        ); // Navigate to the home page after successful login
      } finally {
        toggleIsLoading(value: false, isGoogle: false);
      }
    } else {
      toggleNoAction(value: true, isGoogle: false);
    }
  }

  Future<void> loginWithGoogle({required BuildContext context}) async {
    try {
      if (isEmailLoading) return;
      toggleIsLoading(value: true, isGoogle: true);

      await authDataSource.signInWithGoogle(context: context);

      if (!context.mounted) return;

      dispose();
      context.go(AppPage.home);
    } finally {
      toggleIsLoading(value: false, isGoogle: true);
    }
  }

  void dispose() {
    toggleRememberMe();
    toggleNoAction();
    toggleIsLoading();
    emailController.clear();
    passwordController.clear();
  }
}
