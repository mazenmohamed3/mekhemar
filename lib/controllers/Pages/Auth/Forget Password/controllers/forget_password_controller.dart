import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../models/Auth/input/user_model.dart';
import '../../../../../views/components/Dialog/reset_password_success_dialog.dart';
import '../../../../Router/app_page.dart';
import '../../services/auth_service.dart';
import '../../sources/auth_datasource.dart';

class ForgetPasswordController {
  ForgetPasswordController(this.authDataSource, this.loginService);

  final AuthDatasource authDataSource;
  final AuthService loginService;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();
  final FocusNode resetButtonFocus = FocusNode();
  final TextEditingController emailController = TextEditingController();

  late void Function(void Function()) setButtonState;
  bool noAction = true;
  bool isLoading = false;

  String? emailValidator(String? value) => loginService.validateEmail(value);

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
    // Validate email
    final isEmailValid = emailValidator(emailController.text) == null;

    // Check if email is valid and the button is not loading
    if (isEmailValid && !isLoading) {
      setButtonState(() {
        noAction = false; // Enable the reset password button
      });
    } else {
      setButtonState(() {
        noAction = true; // Disable the reset password button
      });
    }
  }

  void onTapOutside() {
    if (emailController.text.isNotEmpty && formKey.currentState!.validate()) {
      toggleNoAction(value: false);
    } else {
      toggleNoAction(value: true);
    }
  }

  void onFieldSubmitted(String value) {
    final isEmailValid = emailValidator(value) == null;

    if (emailFocus.hasFocus && !isEmailValid) {
      emailFocus.unfocus();
      Future.microtask(() {
        emailFocus.requestFocus();
        toggleNoAction(value: true);
      });
    } else {
      toggleNoAction(value: false);
      resetButtonFocus
        ..canRequestFocus = true
        ..requestFocus();
    }
  }

  Future<void> resetPassword({required BuildContext context}) async {
    if (formKey.currentState!.validate()) {
      try {
        toggleIsLoading(value: true);
        await authDataSource.resetPassword(
          user: UserModel(email: emailController.text),
        );

        if (!context.mounted) return;

        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const ResetPasswordSuccessDialog(),
        );

        if (!context.mounted) return;
        dispose();
        context.go(AppPage.login);
      } finally {
        toggleIsLoading(value: false);
      }
    }
  }

  void dispose() {
    toggleNoAction();
    toggleIsLoading();
    emailController.clear();
  }
}
