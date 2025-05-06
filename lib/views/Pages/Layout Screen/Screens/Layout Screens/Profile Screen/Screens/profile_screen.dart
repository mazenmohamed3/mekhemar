import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekhemar/views/components/Text/custom_text.dart';

import '../../../../../../../controllers/Generated/Assets/assets.dart';
import '../../../../../../../controllers/Pages/Layout/Controllers/Layout Pages Controllers/Profile/Controllers/profile_controller.dart';
import '../widgets/profile_tile_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.profileController});

  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              text: "Hesham Abaza",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              fontSize: 32.sp,
            ),
            SizedBox(height: 64.h,),
            ProfileTileWidget(
              asset: Assets.mail,
              iconHeight: 42.h,
              iconWidth: 42.w,
              title: "Email",
              subtitle: "heshamabaza1@gmail.com",
              subtitleDecoration: TextDecoration.underline,
            ),
            SizedBox(height: 32.h,),
            ProfileTileWidget(
              asset: Assets.phone,
              iconHeight: 42.h,
              iconWidth: 42.w,
              title: "Phone",
              subtitle: "010123456789",
            ),
            SizedBox(height: 32.h,),
            ProfileTileWidget(
              asset: Assets.logout,
              iconColor: Theme.of(context).colorScheme.error,
              iconHeight: 42.h,
              iconWidth: 42.w,
              title: "Sign out",
              onPressed: () => profileController.logout(context),
              titleColor: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}