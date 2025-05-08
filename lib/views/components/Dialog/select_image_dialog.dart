import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../Text/custom_text.dart';
import '../button/custom_button.dart';

class SelectImageDialog extends StatelessWidget {
  const SelectImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CustomText(
        text: 'selectImage',
        fontSize: 22.sp, // Make title font size responsive
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.photo,
            size: 50.0.sp, // Make icon size responsive
          ),
          SizedBox(height: 16.h), // Use ScreenUtil for spacing
          CustomText(
            text: 'choosePhoto',
            textAlign: TextAlign.center,
            fontSize: 16.sp, // Make font size responsive for description
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () => context.pop(true), // true = gallery
                text: 'fromGallery',
              ),
            ),
            SizedBox(width: 8.w), // Make width responsive for spacing between buttons
            Expanded(
              child: CustomButton(
                onPressed: () => context.pop(false), // false = camera
                text: 'fromCamera',
              ),
            ),
          ],
        ),
      ],
    );
  }
}