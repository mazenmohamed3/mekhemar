import 'package:flutter/material.dart';
import 'auth_controller.dart';

class LoginController extends ChangeNotifier {
  bool rememberMe = false;
  final AuthController authController;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  LoginController(this.authController);

  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  bool validate() {
    return emailController.text.isNotEmpty &&
        passwordController.text.length >= 6;
  }

  void login() {
    if (validate()) {
      authController.login(
        identifier: emailController.text,
        password: passwordController.text,
        rememberMe: rememberMe,
      );
    }
  }
}
