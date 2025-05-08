import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mekhemar/views/components/Text/custom_text.dart';
import 'package:mekhemar/views/components/Text/custom_text_form_field.dart';
import 'package:mekhemar/views/components/button/custom_button.dart';

class PhoneNumberInputDialog extends StatelessWidget {
  PhoneNumberInputDialog({super.key});

  final TextEditingController controller = TextEditingController();
  final FocusNode node = FocusNode();

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
            keyboardType: TextInputType.phone,
            hintText: "+201234567890",
            prefixIcon: Icon(Icons.phone),
            validator: (value) {
              // Check if the field is empty
              if (value == null || value.isEmpty) {
                return 'phoneNumberEmpty'.tr();
              }

              // Regular expression to validate phone number format
              final regex = RegExp(r'^\+?\d+$');
              if (!regex.hasMatch(value)) {
                return 'invalidPhoneNumber'.tr();
              }

              return null; // Return null if validation passes
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
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: CustomButton(
                text: 'sendCode',
                onPressed: () =>
                    context.pop(controller.text.trim()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}