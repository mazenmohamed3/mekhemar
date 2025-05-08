import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../Text/custom_text.dart';
import '../Text/custom_text_form_field.dart';
import '../button/custom_button.dart';

class PasswordInputDialog extends StatefulWidget {
  const PasswordInputDialog({super.key});

  @override
  State<PasswordInputDialog> createState() => _PasswordInputDialogState();
}

class _PasswordInputDialogState extends State<PasswordInputDialog> {
  final TextEditingController controller = TextEditingController();
  final FocusNode node = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CustomText(
        text: 'changePassword',
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock,
            size: 50.0.dg,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: 'enterNewPassword',
            textAlign: TextAlign.center,
            fontSize: 14.sp,
          ),
          SizedBox(height: 16.h),
          CustomTextFormField(
            label: 'passwordDialogLabel',
            controller: controller,
            focus: node,
            onTapOutside: () => node.unfocus(),
            obscureText: true,
            hintText: "passwordDialogHint",
            prefixIcon: const Icon(Icons.lock),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'passwordEmpty';
              }
              if (value.length < 6) {
                return 'passwordDialogTooShort';
              }
              return null;
            },
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'passwordDialogCancel',
                onPressed: () => context.pop(null),
                color: Theme.of(context).colorScheme.errorContainer,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: CustomButton(
                text: 'passwordDialogSave',
                onPressed: () => context.pop(controller.text.trim()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}