import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Text/custom_text.dart';
import '../button/custom_button.dart';

class ResetPasswordSuccessDialog extends StatelessWidget {
  const ResetPasswordSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const CustomText(text: 'resetPasswordSuccessDialogTitle'),
      content: const CustomText(text: 'resetPasswordSuccessDialogSubtitle'),
      actions: [
        // Using a Row to ensure the button is expanded
        Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () {
                  context.pop();
                },
                text: 'resetPasswordOkayButtonLabel',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
