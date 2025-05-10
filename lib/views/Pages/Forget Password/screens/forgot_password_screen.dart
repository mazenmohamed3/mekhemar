import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/Pages/Auth/Forget Password/controllers/forget_password_controller.dart';
import '../../../components/Text/custom_text.dart';
import '../../../components/Text/custom_text_form_field.dart';
import '../../../components/button/custom_button.dart';
import '../../../components/other/logo_widget.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({
    super.key,
    required this.forgetPasswordController,
  });

  final ForgetPasswordController forgetPasswordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: CustomText(
          text: 'forgotPasswordAppbarTitle',
          fontSize: 20.sp,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          onPressed: () {
            forgetPasswordController.dispose();
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 48.h),
                        LogoWidget(width: 200.w, height: 200.h),
                        SizedBox(height: 24.h),
                        CustomText(
                          text: 'forgotPasswordText',
                          textAlign: TextAlign.center,
                          fontSize: 24.sp,
                        ),
                        SizedBox(height: 24.h),
                        Form(
                          key: forgetPasswordController.formKey,
                          child: CustomTextFormField(
                            focus: forgetPasswordController.emailFocus,
                            controller:
                                forgetPasswordController.emailController,
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted:
                                forgetPasswordController.onFieldSubmitted,
                            onTapOutside: forgetPasswordController.onTapOutside,
                            onChanged: forgetPasswordController.onChanged,
                            label: "forgetPasswordLabel",
                            hintText: "forgetPasswordHint",
                            validator:
                                (value) => forgetPasswordController
                                    .emailValidator(value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0.h),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    forgetPasswordController.setButtonState = setState;
                    return CustomButton(
                      text: 'forgetPasswordButtonLabel',
                      onPressed:
                          () async => await forgetPasswordController
                              .resetPassword(context: context),
                      noAction: forgetPasswordController.noAction,
                      isLoading: forgetPasswordController.isLoading,
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
