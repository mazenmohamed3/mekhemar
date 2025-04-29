import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../views/components/Dialog/reset_password_success_dialog.dart';
import '../../../../Router/app_page.dart';
import '../../sources/auth_datasource.dart';

class ForgetPasswordController {
  ForgetPasswordController(this.authDataSource);

  final AuthDatasource authDataSource;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Declare the formKey here for the current form.
  final FocusNode emailFocus = FocusNode();
  final TextEditingController emailController = TextEditingController();

  // Email validator
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

  // Password reset method
  Future<void> resetPassword({required BuildContext context}) async {
    if (formKey.currentState!.validate()) {
      try {
        await authDataSource.resetPassword(email: emailController.text).then((value) async {
          if (!context.mounted) return;

          // Show the success dialog
          await showDialog<void>(
            context: context,
            barrierDismissible: false, // User must press a button to dismiss
            builder: (BuildContext context) {
              return const ResetPasswordSuccessDialog(); // Use the imported dialog
            },
          );

          if (!context.mounted) return;
          dispose();
          context.go(AppPage.login);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void dispose() {
    emailController.text = '';
  }

}