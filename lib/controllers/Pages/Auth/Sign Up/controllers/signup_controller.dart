import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mekhemar/controllers/Router/app_page.dart';

import '../../../../../models/user_model.dart';
import '../../sources/auth_datasource.dart';

class SignupController {
  SignupController(this.authDataSource);

  final AuthDatasource authDataSource;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final TextEditingController usernameController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FocusNode confirmPasswordFocus = FocusNode();

  Future<void> signUp(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final newUser = User(
        email: emailController.text,
        username: usernameController.text,
        password: passwordController.text,
      );

      await authDataSource.signUp(
        context: context,
        email: newUser.email,
        password: newUser.password,
        name: newUser.username,
      );

      if (!context.mounted) return;
      dispose();
      context.go(AppPage.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User already exists')),
      );
    }
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

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
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

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void dispose() {
    emailController.text = '';
    usernameController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
  }
}