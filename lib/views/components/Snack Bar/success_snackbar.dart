import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekhemar/controllers/Theme/Theme%20Data/color_extensions.dart';
import '../../../controllers/Generated/Assets/assets.dart';
import '../Text/custom_text.dart';

void showSuccessSnackBar(
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
              color: Theme.of(context).colorScheme.successBackground,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(Assets.success, height: 25.h),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomText(
                    text: title,
                    args: args,
                    color: Theme.of(context).colorScheme.success,
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
