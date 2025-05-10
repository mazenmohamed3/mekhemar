import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../Text/custom_text.dart';
import '../Text/custom_text_form_field.dart';
import '../button/custom_button.dart';

class PhoneNumberInputDialog extends StatefulWidget {
  const PhoneNumberInputDialog({super.key});

  @override
  State<PhoneNumberInputDialog> createState() => _PhoneNumberInputDialogState();
}

class _PhoneNumberInputDialogState extends State<PhoneNumberInputDialog> {
  final TextEditingController controller = TextEditingController();
  final FocusNode node = FocusNode();
  final FocusNode buttonNode = FocusNode();

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
        text: 'enterPhoneNumber',
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.phone_android_rounded,
            size: 50.0.dg,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: 'verificationMessage',
            textAlign: TextAlign.center,
            fontSize: 14.sp,
          ),
          SizedBox(height: 16.h),
          CustomTextFormField(
            label: 'phoneNumber',
            controller: controller,
            focus: node,
            onTapOutside: () => node.unfocus(),
            onFieldSubmitted: (_) {
              buttonNode
                ..canRequestFocus = true
                ..requestFocus();
            },
            keyboardType: TextInputType.phone,
            hintText: "+201234567890",
            prefixIcon: const Icon(Icons.phone),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'phoneNumberEmpty'.tr();
              }

              final regex = RegExp(r'^\+?\d+$');
              if (!regex.hasMatch(value)) {
                return 'invalidPhoneNumber'.tr();
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
                text: 'cancel',
                onPressed: () => context.pop(null),
                color: Theme.of(context).colorScheme.errorContainer,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: CustomButton(
                focusNode: buttonNode,
                text: 'sendCode',
                onPressed: () => context.pop(controller.text.trim()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}