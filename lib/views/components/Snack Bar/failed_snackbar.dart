import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controllers/Generated/Assets/assets.dart';
import '../../../controllers/Theme/Theme Data/theme.dart';
import '../Text/custom_text.dart';

void showFailedSnackBar(
  BuildContext context, {
  required String title,
  List<String>? args,
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder:
        (context) => Positioned(
          top: 100,
          left: 16,
          right: 16,
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Theme.of(context).colorScheme.errorContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  Assets.error,
                  height: 25.h,
                  color: AppTheme.defaultTextColor(context),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomText(
                    text: title,
                    args: args,
                    height: 1.3.h,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
  );
  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3)).then((_) => overlayEntry.remove());
}
