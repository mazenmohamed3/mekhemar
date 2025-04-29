import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/Theme/theme.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight fontWeight;
  final double fontSize;
  final FontStyle? fontStyle;
  final double height;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final dynamic googleFonts;
  final TextOverflow? overflow;
  final List<String>? args;

  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontWeight = FontWeight.w600,
    this.fontSize = 16,
    this.height = 1.2,
    this.textAlign = TextAlign.start,
    this.textDecoration = TextDecoration.none,
    this.googleFonts = GoogleFonts.figtree,
    this.overflow,
    this.args,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final argsToPass = args ?? [];

    final defaultColor = AppTheme.defaultTextColor(context);

    return Text(
      text.tr(args: argsToPass),
      textAlign: textAlign,
      overflow: overflow,
      style: lang == 'en'
          ? googleFonts(
        decoration: textDecoration,
        decorationThickness: 1.8,
        fontSize: fontSize.sp,
        fontStyle: fontStyle,
        color: color ?? defaultColor,
        fontWeight: fontWeight,
        height: height,
      )
          : GoogleFonts.tajawal(
        decoration: textDecoration,
        decorationThickness: 1.8,
        fontSize: fontSize.sp,
        fontStyle: fontStyle,
        color: color ?? defaultColor,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}
