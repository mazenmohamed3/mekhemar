import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../components/Text/custom_text.dart';

class SettingsItem extends StatelessWidget {
  final String iconAsset;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.iconAsset,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      highlightColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  iconAsset,
                  width: 36.w,
                  height: 36.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 16.w),
                CustomText(
                  text: label,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            trailing ?? Icon(Icons.arrow_forward_ios, size: 24.sp),
          ],
        ),
      ),
    );
  }
}