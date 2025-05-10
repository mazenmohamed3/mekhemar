import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../components/Text/custom_text.dart';

class SettingsSwitchItem extends StatelessWidget {
  final String iconAsset;
  final String label;
  final bool value;
  final Function(bool)? onChanged;

  const SettingsSwitchItem({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
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
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}