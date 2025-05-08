import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Text/custom_text.dart';
import '../button/custom_button.dart';

class StaySignedInDialog extends StatelessWidget {
  const StaySignedInDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const CustomText(text: 'staySignedInDialogTitle'),
      content: const CustomText(text: 'staySignedInDialogSubtitle'),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                  color: Theme.of(context).colorScheme.errorContainer,
                  onPressed: () {
                  context.pop(false); // No
                },
                text: 'staySignedInNoButtonLabel',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomButton(
                onPressed: () {
                  context.pop(true); // Yes
                },
                text: 'staySignedInYesButtonLabel',
              ),
            ),
          ],
        ),
      ],
    );
  }
}