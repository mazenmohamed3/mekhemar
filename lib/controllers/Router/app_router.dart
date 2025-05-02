import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mekhemar/controllers/Router/app_controllers.dart';
import '../../views/Pages/Layout Screen/Screens/Layout Screens/Home Screen/Screens/home_screen.dart';
import '../../views/Pages/Layout Screen/Screens/Layout Screens/Profile Screen/Screens/profile_screen.dart';
import '../../views/Pages/Layout Screen/Screens/Layout Screens/Settings Screen/Screens/settings_screen.dart';
import '../../views/Pages/Layout Screen/Screens/layout_screen.dart';
import '../../views/Pages/Splash Screen/screens/splash_screen.dart';
import '../../views/Pages/onboarding/screens/onboarding_screen.dart';
import '../../views/Pages/Forget Password/screens/forgot_password_screen.dart';
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
        builder:
            (context, state) => OnboardingScreen(
              onboardingController: AppControllers.onboardingController,
            ),
      ),
      GoRoute(
        path: AppPage.login,
        builder:
            (context, state) =>
                LoginScreen(loginController: AppControllers.loginController),
      ),
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          // Directly passing navigationShell to LayoutScreen without requiring explicit argument.
          return LayoutScreen(
            layoutController: AppControllers.layoutController,
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppPage.profile,
                builder:
                    (BuildContext context, GoRouterState state) =>
                        ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppPage.home,
                builder:
                    (BuildContext context, GoRouterState state) => HomeScreen(homeController: AppControllers.homeController),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppPage.settings,
                builder:
                    (BuildContext context, GoRouterState state) =>
                        SettingsScreen(),
              ),
            ],
          ),
        ],
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
