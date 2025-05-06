import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/Pages/Auth/Sign Up/controllers/signup_controller.dart';
import '../../../components/Text/custom_text.dart';
import '../../../components/Text/custom_text_form_field.dart';
import '../../../components/button/custom_button.dart';
import '../../../components/other/logo_widget.dart';

class SignupScreen extends StatelessWidget {
  final SignupController signupController;

  const SignupScreen({super.key, required this.signupController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: CustomText(
          text: 'signupAppbarTitle',
          fontSize: 20.sp,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          onPressed: () {
            signupController.dispose();
            context.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                // <-- this makes form area scrollable independently
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 48.h),
                      LogoWidget(width: 200.w, height: 200.h),
                      SizedBox(height: 24.h),
                      CustomText(
                        text: 'signupText',
                        textAlign: TextAlign.center,
                        fontSize: 24.sp,
                      ),
                      SizedBox(height: 24.h),
                      Form(
                        key: signupController.formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              focus: signupController.usernameFocus,
                              controller: signupController.usernameController,
                              keyboardType: TextInputType.name,
                              onFieldSubmitted:
                                  signupController.onFieldSubmitted,
                              onTapOutside: signupController.onTapOutside,
                              onChanged: signupController.onChanged,
                              label: "signUpUsernameLabel",
                              hintText: "signUpUsernameHint",
                              validator:
                                  (value) =>
                                      signupController.usernameValidator(value),
                            ),
                            SizedBox(height: 16.h),
                            CustomTextFormField(
                              focus: signupController.emailFocus,
                              controller: signupController.emailController,
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted:
                                  signupController.onFieldSubmitted,
                              onTapOutside: signupController.onTapOutside,
                              onChanged: signupController.onChanged,
                              label: "signUpEmailLabel",
                              hintText: "signUpEmailHint",
                              validator:
                                  (value) =>
                                      signupController.emailValidator(value),
                            ),
                            SizedBox(height: 16.h),
                            CustomTextFormField(
                              focus: signupController.passwordFocus,
                              controller: signupController.passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              onFieldSubmitted:
                                  signupController.onFieldSubmitted,
                              onTapOutside: signupController.onTapOutside,
                              onChanged: signupController.onChanged,
                              label: "signUpPasswordLabel",
                              hintText: "signUpPasswordHint",
                              obscureText: true,
                              validator:
                                  (value) =>
                                      signupController.passwordValidator(value),
                            ),
                            SizedBox(height: 16.h),
                            CustomTextFormField(
                              focus: signupController.confirmPasswordFocus,
                              controller:
                                  signupController.confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              onFieldSubmitted:
                                  signupController.onFieldSubmitted,
                              onTapOutside: signupController.onTapOutside,
                              onChanged: signupController.onChanged,
                              label: "signUpConfirmPasswordLabel",
                              hintText: "signUpConfirmPasswordHint",
                              obscureText: true,
                              validator:
                                  (value) => signupController
                                      .confirmPasswordValidator(value),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0.h),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    signupController.setButtonState = setState;
                    return CustomButton(
                      focusNode: signupController.signupButtonFocus,
                      text: 'signUpButtonLabel',
                      onPressed: () async {
                        await signupController.signUp(context);
                      },
                      noAction: signupController.noAction,
                      isLoading: signupController.isLoading,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
