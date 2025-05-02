import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.iconColor, this.onPressed,
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
    return Row(
      children: [
        TextButton(
          onPressed: onPressed,
          child: Row(
            spacing: 16.w,
            children: [
              SvgPicture.asset(
                asset,
                width: iconWidth,
                height: iconHeight,
                colorFilter:
                    iconColor != null
                        ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                        : null,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    fontSize: 32.sp,
                  ),
                  if (subtitle != null) ...{
                    CustomText(
                      text: subtitle!,
                      textDecoration: subtitleDecoration ?? TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      fontSize: 24.sp,
                    ),
                  },
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
