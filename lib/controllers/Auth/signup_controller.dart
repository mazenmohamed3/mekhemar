import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'auth_controller.dart';

class SignupController extends ChangeNotifier {
  final AuthController authController;
  bool _isLoading = false;

  SignupController(this.authController);

  bool get isLoading => _isLoading;

  Future<void> signUp(User newUser) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    authController.signUp(identifier: newUser.email, password: newUser.password, name: newUser.username);
    _isLoading = false;
    notifyListeners();
  }
}
