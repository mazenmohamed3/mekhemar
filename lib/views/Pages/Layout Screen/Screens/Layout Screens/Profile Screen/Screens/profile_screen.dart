import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../controllers/Generated/Assets/assets.dart';
import '../../../../../../../controllers/Pages/Layout/Controllers/Layout Pages Controllers/Profile/Controllers/profile_controller.dart';
import '../../../../../../components/Text/custom_text.dart';
import '../widgets/profile_image_widget.dart';
import '../widgets/profile_tile_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.profileController});

  final ProfileController profileController;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    widget.profileController.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: StatefulBuilder(
                  builder: (context, setProfileState) {
                    widget.profileController.setProfileState = setProfileState;
                    return ProfileImageWidget(
                      onTap:
                          () => widget.profileController.onProfileTap(context),
                      displayName: widget.profileController.displayName,
                      photoURL: widget.profileController.photoUrl,
                    );
                  },
                ),
              ),
              SizedBox(height: 32.h),
              StatefulBuilder(
                builder: (context, setDisplayNameState) {
                  widget.profileController.setDisplayNameState = setDisplayNameState;
                  return CustomText(
                    text: widget.profileController.displayName!,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w700,
                    fontSize: 32.sp,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
              SizedBox(height: 64.h),
              ProfileTileWidget(
                asset: Assets.mail,
                iconHeight: 42.h,
                iconWidth: 42.w,
                title: "email",
                subtitle: widget.profileController.email!,
                subtitleDecoration: TextDecoration.underline,
              ),
              SizedBox(height: 32.h),
              StatefulBuilder(
                builder: (context, setPhoneState) {
                  widget.profileController.setPhoneState = setPhoneState;
                  return ProfileTileWidget(
                    asset: Assets.phone,
                    iconHeight: 42.h,
                    iconWidth: 42.w,
                    title: "phone",
                    subtitle: widget.profileController.phone,
                    onPressed: widget.profileController.onPhoneTap(context),
                  );
                },
              ),
              SizedBox(height: 32.h),
              StatefulBuilder(
                builder: (context, setLocationState) {
                  widget.profileController.setLocationState = setLocationState;
                  return ProfileTileWidget(
                    asset: Assets.location,
                    iconHeight: 42.h,
                    iconWidth: 42.w,
                    title: "location",
                    subtitle: widget.profileController.location,
                  );
                },
              ),
              SizedBox(height: 32.h),
              ProfileTileWidget(
                asset: Assets.logout,
                iconColor: Theme.of(context).colorScheme.error,
                iconHeight: 42.h,
                iconWidth: 42.w,
                title: "signOut",
                onPressed: () => widget.profileController.logout(context),
                titleColor: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
