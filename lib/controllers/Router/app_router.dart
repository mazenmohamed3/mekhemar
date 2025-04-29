import 'package:go_router/go_router.dart';
import 'package:mekhemar/controllers/Router/app_controllers.dart';

import '../../views/Pages/Splash Screen/screens/splash_screen.dart';
import '../../views/Pages/onboarding/screens/onboarding_screen.dart';
import '../../views/Pages/Forget Password/screens/forgot_password_screen.dart';
import '../../views/screens/home_screen.dart';
import '../../views/Pages/Login/screens/login_screen.dart';
import '../../views/Pages/Sign Up/screens/signup_screen.dart';

import 'app_page.dart';

class AppRouter {
  static final GoRouter routerConfig = GoRouter(
    initialLocation: AppPage.splash,
    routes: [
      GoRoute(
        path: AppPage.splash,
        builder:
            (context, state) =>
                SplashScreen(splashController: AppControllers.splashController),
      ),
      GoRoute(
        path: AppPage.onboarding,
        builder: (context, state) => OnboardingScreen(onboardingController: AppControllers.onboardingController),
      ),
      GoRoute(
        path: AppPage.login,
        builder:
            (context, state) =>
                LoginScreen(loginController: AppControllers.loginController),
      ),
      GoRoute(
        path: AppPage.home,
        builder:
            (context, state) => HomeScreen(
              homeController: AppControllers.homeController,
              authController: AppControllers.authDatasource,
            ),
      ),
      GoRoute(
        path: AppPage.forgotPassword,
        builder:
            (context, state) => ForgetPasswordScreen(
              forgetPasswordController: AppControllers.forgetPasswordController,
            ),
      ),
      GoRoute(
        path: AppPage.signup,
        builder:
            (context, state) =>
                SignupScreen(signupController: AppControllers.signupController),
      ),
    ],
  );
}
