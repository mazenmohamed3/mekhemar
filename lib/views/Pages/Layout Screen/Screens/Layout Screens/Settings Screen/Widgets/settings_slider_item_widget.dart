import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../components/Text/custom_text.dart';

class SettingsSliderItem extends StatelessWidget {
  final String iconAsset;
  final String label;
  final double value;
  final double min;
  final double max;
  final Function(double)? onchanged;
  final Function(double)? onChangeEnd;

  const SettingsSliderItem({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onchanged,
    this.onChangeEnd,
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
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onchanged,
              onChangeEnd: onChangeEnd,
            ),
          ),
        ],
      ),
    );
  }
}