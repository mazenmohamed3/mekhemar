import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../components/Text/custom_text.dart';

class ProfileTileWidget extends StatelessWidget {
  const ProfileTileWidget({
    super.key,
    required this.asset,
    required this.title,
    required this.iconWidth,
    required this.iconHeight,
    this.subtitle,
    this.subtitleDecoration,
    this.titleColor,
    this.iconColor,
    this.onPressed,
  });

  final String asset;
  final Color? iconColor;
  final double iconWidth;
  final double iconHeight;
  final String title;
  final Color? titleColor;
  final String? subtitle;
  final TextDecoration? subtitleDecoration;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            asset,
            width: iconWidth,
            height: iconHeight,
            color: iconColor ?? Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 16.w), // Adds spacing between icon and text
          Expanded(
            // Ensures text takes remaining space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: title,
                  fontWeight: FontWeight.w700,
                  color: titleColor ?? Theme.of(context).colorScheme.primary,
                  fontSize: 24.sp,
                ),
                if (subtitle != null)
                  CustomText(
                    text: subtitle!,
                    textDecoration: subtitleDecoration ?? TextDecoration.none,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}