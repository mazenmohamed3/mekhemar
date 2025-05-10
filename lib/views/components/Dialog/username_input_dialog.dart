import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../Text/custom_text.dart';
import '../Text/custom_text_form_field.dart';
import '../button/custom_button.dart';

class UsernameInputDialog extends StatefulWidget {
  const UsernameInputDialog({super.key});

  @override
  State<UsernameInputDialog> createState() => _UsernameInputDialogState();
}

class _UsernameInputDialogState extends State<UsernameInputDialog> {
  final TextEditingController controller = TextEditingController();
  final FocusNode node = FocusNode();
  final FocusNode buttonNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    buttonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CustomText(
        text: 'enterUsername',
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person,
            size: 50.0.dg,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: 'enterNewUsername',
            textAlign: TextAlign.center,
            fontSize: 14.sp,
          ),
          SizedBox(height: 16.h),
          CustomTextFormField(
            label: 'usernameLabel',
            controller: controller,
            focus: node,
            onTapOutside: () => node.unfocus(),
            onFieldSubmitted: (_) {
              buttonNode
                ..canRequestFocus = true
                ..requestFocus();
            },
            keyboardType: TextInputType.text,
            hintText: "usernameHint",
            prefixIcon: const Icon(Icons.person),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'usernameEmpty';
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
                text: 'usernameDialogCancel',
                onPressed: () => context.pop(null),
                color: Theme.of(context).colorScheme.errorContainer,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: CustomButton(
                focusNode: buttonNode,
                text: 'usernameDialogSave',
                onPressed: () => context.pop(controller.text.trim()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}