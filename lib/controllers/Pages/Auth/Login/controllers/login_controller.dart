import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../Router/app_page.dart';
import '../../sources/auth_datasource.dart';

class LoginController {
  LoginController(this.authDataSource);

  final AuthDatasource authDataSource;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Declare the formKey here for the login form.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool rememberMe = false;

  void toggleRememberMe(bool value) {
    rememberMe = value;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> loginWithEmailAndPassword({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      try {
        await authDataSource.emailAndPasswordLogin(
          rememberMe: rememberMe,
          email: emailController.text,
          password: passwordController.text,
        );

        if (!context.mounted) return;
        dispose();
        context.go(AppPage.home);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> loginWithGoogle({required BuildContext context}) async {
    try {
      await authDataSource.signInWithGoogle(context: context);
      if (!context.mounted) return;
      dispose();
      context.go(AppPage.home);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void dispose() {
    rememberMe = false;
    emailController.text = '';
    passwordController.text = '';
  }
}
