import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../components/Text/custom_text.dart';

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({
    super.key,
    this.photoURL,
    this.displayName,
    required this.onTap,
  });

  final String? photoURL;
  final String? displayName;
  final void Function() onTap;

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 72.r,
          backgroundImage:
              (widget.photoURL != null && widget.photoURL!.isNotEmpty)
                  ? NetworkImage(widget.photoURL!)
                  : null,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child:
              (widget.photoURL == null || widget.photoURL!.isEmpty)
                  ? CustomText(
                    text:
                        widget.displayName?.substring(0, 1).toUpperCase() ??
                        '?',
                    fontSize: 32.sp,
                  )
                  : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Icon(Icons.camera_alt, size: 24.r, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}