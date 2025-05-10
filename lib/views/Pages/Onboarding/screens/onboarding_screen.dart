import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/Pages/Onboarding/controllers/onboarding_controller.dart';
import '../../../components/Text/custom_text.dart';
import '../../../components/button/custom_button.dart';
import '../../../components/other/logo_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onboardingController});

  final OnboardingController onboardingController;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    widget.onboardingController.setShowButtonsState = setState;
    widget.onboardingController.init();
    super.initState();
  }

  @override
  void dispose() {
    widget.onboardingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Responsive logo size
            LogoWidget(width: 200.w, height: 200.h),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              // responsive padding
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatefulBuilder(
                      builder: (context, textState) {
                        widget.onboardingController.setTextState = textState;
                        return CustomText(
                          text: widget.onboardingController.displayedText,
                          // Flashing cursor at the end
                          textAlign: TextAlign.center,
                          fontSize: 24.sp, // responsive font size
                          fontWeight: FontWeight.bold,
                        );
                      },
                    ),
                    // Use StatefulBuilder to rebuild only the cursor part
                    StatefulBuilder(
                      builder: (context, cursorState) {
                        widget.onboardingController.setCursorState =
                            cursorState;
                        return CustomText(
                          text: "cursor",
                          textAlign: TextAlign.center,
                          color:
                              widget.onboardingController.showCursor
                                  ? null
                                  : Colors.transparent,
                          fontSize: 24.sp,
                          // responsive font size
                          fontWeight: FontWeight.bold,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 3),
            widget.onboardingController.showButtons
                ? Padding(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    bottom: 40.h,
                    right: 16.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Ensure the button scales with screen size
                      Expanded(
                        child: SizedBox(
                          height: 55.h,
                          child: CustomButton(
                            text: "englishButtonLabel",
                            onPressed:
                                () => widget.onboardingController
                                    .onEnglishPressed(context),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w), // responsive width between buttons
                      Expanded(
                        child: SizedBox(
                          height: 55.h,
                          child: CustomButton(
                            text: "arabicButtonLabel",
                            onPressed:
                                () => widget.onboardingController
                                    .onArabicPressed(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : SizedBox(height: 95.h),
          ],
        ),
      ),
    );
  }
}
