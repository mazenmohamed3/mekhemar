import 'package:mekhemar/controllers/Pages/Onboarding/controllers/onboarding_controller.dart';
import 'package:mekhemar/controllers/Pages/Splash/controllers/splash_controller.dart';
import 'package:mekhemar/controllers/Pages/Home/home_controller.dart';

import '../Pages/Auth/Forget Password/controllers/forget_password_controller.dart';
import '../Pages/Auth/Login/controllers/login_controller.dart';
import '../Pages/Auth/Sign Up/controllers/signup_controller.dart';
import '../Pages/Auth/sources/auth_datasource.dart';

class AppControllers {
  //Datasources
  static AuthDatasource authDatasource = AuthDatasource();
  //Controllers
  static SplashController splashController = SplashController(authDatasource);
  static OnboardingController onboardingController = OnboardingController();
  static LoginController loginController = LoginController(authDatasource);
  static ForgetPasswordController forgetPasswordController = ForgetPasswordController(authDatasource);
  static SignupController signupController = SignupController(authDatasource);
  static HomeController homeController = HomeController();
}