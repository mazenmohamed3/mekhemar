import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../controllers/Pages/Splash/controllers/splash_controller.dart';
import '../../../components/Text/custom_text.dart';
import '../../../components/other/logo_widget.dart';

class SplashScreen extends StatefulWidget {
  final SplashController splashController;

  const SplashScreen({super.key, required this.splashController});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    widget.splashController.checkFirstTime(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 2),
              LogoWidget(width: 200.w, height: 200.h),
              SizedBox(height: 24.h),
              CustomText(
                text: "splashScreenText",
                fontSize: 30,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              SizedBox(height: 52.h),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: CustomText(
                  text: "splashScreenFooter",
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}