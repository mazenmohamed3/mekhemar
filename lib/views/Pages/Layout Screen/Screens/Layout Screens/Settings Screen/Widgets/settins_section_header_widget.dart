import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../components/Text/custom_text.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String iconAsset;
  final String title;

  const SettingsSectionHeader({
    super.key,
    required this.iconAsset,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Image.asset(
              iconAsset,
              width: 48.w,
              height: 48.h,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 16.w),
            CustomText(
              text: title,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        Divider(),
        SizedBox(height: 16.h),
      ],
    );
  }
}