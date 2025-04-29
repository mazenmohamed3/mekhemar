import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/Generated/Assets/assets.dart';
import '../../../../controllers/Pages/Auth/Login/controllers/login_controller.dart';
import '../../../../controllers/Router/app_page.dart';
import '../../../../controllers/Theme/theme.dart';
import '../../../components/Text/custom_text.dart';
import '../../../components/Text/custom_text_form_field.dart';
import '../../../components/button/custom_button.dart';
import '../../../components/other/logo_widget.dart';

class LoginScreen extends StatefulWidget {
  final LoginController loginController;

  const LoginScreen({super.key, required this.loginController});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: widget.loginController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                LogoWidget(width: 200.w, height: 200.h),
                CustomText(
                  text: 'appName',
                  fontSize: 42,
                  textAlign: TextAlign.center,
                ),
                CustomTextFormField(
                  focus: widget.loginController.emailFocus,
                  controller: widget.loginController.emailController,
                  keyboardType: TextInputType.emailAddress,

                  label: "emailLabel",
                  hintText: "emailHint",
                  validator:
                      (value) => widget.loginController.emailValidator(value),
                ),
                CustomTextFormField(
                  focus: widget.loginController.passwordFocus,
                  controller: widget.loginController.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  label: "passwordLabel",
                  hintText: "passwordHint",
                  obscureText: true,
                  validator:
                      (value) =>
                          widget.loginController.passwordValidator(value),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: widget.loginController.rememberMe,
                      onChanged:
                          (value) => setState(
                            () => widget.loginController.toggleRememberMe(
                              value!,
                            ),
                          ),
                    ),
                    CustomText(text: 'rememberMeLabel'),
                    const Spacer(),
                    TextButton(
                      onPressed:
                          () => context.push(AppPage.forgotPassword,),
                      child: Text('forgotPasswordButtonLabel'.tr()),
                    ),
                  ],
                ),
                CustomButton(
                  text: 'loginButtonLabel',
                  onPressed:
                      () async => await widget.loginController
                          .loginWithEmailAndPassword(context: context),
                ),
                CustomButton(
                  icon: Image.asset(Assets.googleIcon, height: 24),
                  showIcon: true,
                  text: "googleButtonLabel",
                  onPressed:
                      () async => await widget.loginController
                          .loginWithGoogle(context: context),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "dontHaveAccountLabel".tr(), // Regular text
                        style: AppTheme.textTheme.bodyLarge!.copyWith(
                          color: AppTheme.defaultTextColor(context),
                        ), // Default color (you can adjust if needed)
                      ),
                      TextSpan(
                        text: "createAccountButtonLabel".tr(), // Highlighted text
                        style: AppTheme.textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () => context.push(
                                    AppPage.signup,
                                  ), // Navigate to signup page on tap
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
