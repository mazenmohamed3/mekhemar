import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mekhemar/views/components/button/custom_button.dart';

class ResetPasswordSuccessDialog extends StatelessWidget {
  const ResetPasswordSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('resetPasswordSuccessDialogTitle'),
      content: const Text('resetPasswordSuccessDialogSubtitle'),
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
