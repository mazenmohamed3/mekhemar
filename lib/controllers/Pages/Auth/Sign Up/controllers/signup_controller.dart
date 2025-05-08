import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mekhemar/controllers/Router/app_page.dart';

import '../../../../../models/Auth/input/user_model.dart';
import '../../services/auth_service.dart';
import '../../sources/auth_datasource.dart';

class SignupController {
  SignupController(AuthDatasource authDataSource, AuthService authService)
    : _authDataSource = authDataSource,
      _authService = authService;

  final AuthDatasource _authDataSource;
  final AuthService _authService;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final TextEditingController usernameController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode confirmPasswordFocus = FocusNode();
  final FocusNode signupButtonFocus = FocusNode();
  late void Function(void Function()) setButtonState;
  bool noAction = true;
  bool isLoading = false;

  void toggleNoAction({bool? value}) {
    if (value == null) {
      noAction = true;
    } else {
      setButtonState(() {
        noAction = value;
      });
    }
  }

  void toggleIsLoading({bool? value}) {
    if (value == null) {
      isLoading = false;
    } else if (value) {
      isLoading = value;
      toggleNoAction(value: value);
    } else {
      isLoading = value;
      toggleNoAction(value: value);
    }
  }

  void onChanged(String value) {
    // Validate each field
    final isEmailValid = emailValidator(emailController.text) == null;
    final isUsernameValid = usernameValidator(usernameController.text) == null;
    final isPasswordValid = passwordValidator(passwordController.text) == null;
    final isConfirmPasswordValid =
        confirmPasswordValidator(confirmPasswordController.text) == null;

    // Check if all fields are valid and the button is not loading
    if (isEmailValid &&
        isUsernameValid &&
        isPasswordValid &&
        isConfirmPasswordValid &&
        !isLoading) {
      setButtonState(() {
        noAction = false; // Enable the signup button
      });
    } else {
      setButtonState(() {
        noAction = true; // Disable the signup button
      });
    }
  }

  void onFieldSubmitted(String value) {
    final isUsernameValid = usernameValidator(usernameController.text) == null;
    final isEmailValid = emailValidator(emailController.text) == null;
    final isPasswordValid = passwordValidator(passwordController.text) == null;
    final isConfirmPasswordValid =
        confirmPasswordValidator(confirmPasswordController.text) == null;

    bool allValid =
        isUsernameValid &&
        isEmailValid &&
        isPasswordValid &&
        isConfirmPasswordValid;

    if (usernameFocus.hasFocus && !allValid) {
      usernameFocus.unfocus();

      Future.microtask(() {
        if (!isUsernameValid) {
          usernameFocus.requestFocus();
          toggleNoAction(value: true);
        } else if (!isEmailValid) {
          emailFocus.requestFocus();
        } else if (!isPasswordValid) {
          passwordFocus.requestFocus();
        } else if (!isConfirmPasswordValid) {
          confirmPasswordFocus.requestFocus();
        }
      });
    } else if (emailFocus.hasFocus && !allValid) {
      emailFocus.unfocus();

      Future.microtask(() {
        if (!isEmailValid) {
          emailFocus.requestFocus();
          toggleNoAction(value: true);
        } else if (!isUsernameValid) {
          usernameFocus.requestFocus();
          toggleNoAction(value: true);
        } else if (!isPasswordValid) {
          passwordFocus.requestFocus();
        } else if (!isConfirmPasswordValid) {
          confirmPasswordFocus.requestFocus();
        }
      });
    } else if (passwordFocus.hasFocus && !allValid) {
      passwordFocus.unfocus();

      Future.microtask(() {
        if (!isPasswordValid) {
          passwordFocus.requestFocus();
          toggleNoAction(value: true);
        } else if (!isUsernameValid) {
          usernameFocus.requestFocus();
          toggleNoAction(value: true);
        } else if (!isEmailValid) {
          emailFocus.requestFocus();
          toggleNoAction(value: true);
        } else if (!isConfirmPasswordValid) {
          confirmPasswordFocus.requestFocus();
        }
      });
    } else if (confirmPasswordFocus.hasFocus && !allValid) {
      confirmPasswordFocus.unfocus();

      Future.microtask(() {
        if (!isConfirmPasswordValid && isPasswordValid) {
          confirmPasswordFocus.requestFocus();
          toggleNoAction(value: true);
        } else if (!isUsernameValid) {
          usernameFocus.requestFocus();
          toggleNoAction(value: true);
        } else if (!isEmailValid) {
          emailFocus.requestFocus();
          toggleNoAction(value: true);
        } else if (!isPasswordValid) {
          passwordFocus.requestFocus();
          toggleNoAction(value: true);
        }
      });
    } else {
      toggleNoAction(value: false);
      signupButtonFocus
        ..canRequestFocus = true
        ..requestFocus();
    }
  }

  void onTapOutside() {
    if (usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (formKey.currentState!.validate()) {
        toggleNoAction(value: false);
      }
    } else {
      toggleNoAction(value: true);
    }
  }

  String? emailValidator(String? value) => _authService.validateEmail(value);

  String? usernameValidator(String? value) =>
      _authService.validateUsername(value);

  String? passwordValidator(String? value) =>
      _authService.validatePassword(value);

  String? confirmPasswordValidator(String? value) =>
      _authService.validateConfirmPassword(value, passwordController.text);

  Future<void> signUp(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        toggleIsLoading(value: true);

        final userModel = UserModel(
          email: emailController.text,
          username: usernameController.text,
          password: passwordController.text,
        );

        await _authDataSource.signUp(userModel: userModel, context: context);

        if (!context.mounted) return;
        dispose();
        context.go(AppPage.home);
      } finally {
        toggleIsLoading(value: false);
      }
    }
  }

  void dispose() {
    toggleNoAction();
    toggleIsLoading();
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
