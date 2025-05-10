import '../Features/Biometric/Controller/biometric_controller.dart';
import '../Features/Cloud Image/Controller/cloudinary_controller.dart';
import '../Features/Location/Controller/location_controller.dart';
import '../Pages/Auth/Forget Password/controllers/forget_password_controller.dart';
import '../Pages/Auth/Login/controllers/login_controller.dart';
import '../Pages/Auth/Sign Up/controllers/signup_controller.dart';
import '../Pages/Auth/services/auth_service.dart';
import '../Pages/Auth/sources/auth_datasource.dart';
import '../Pages/Layout/Controllers/Layout Pages Controllers/Home/Controllers/home_controller.dart';
import '../Pages/Layout/Controllers/Layout Pages Controllers/Home/Services/voice_service.dart';
import '../Pages/Layout/Controllers/Layout Pages Controllers/Profile/Controllers/profile_controller.dart';
import '../Pages/Layout/Controllers/Layout Pages Controllers/Settings/Controller/settings_controller.dart';
import '../Pages/Layout/Controllers/layout_controller.dart';
import '../Pages/Onboarding/controllers/onboarding_controller.dart';
import '../Pages/Splash/controllers/splash_controller.dart';

class AppControllers {
  //Services
  static AuthService loginService = AuthService();
  static VoiceService voiceService = VoiceService();
  //Datasources
  static AuthDatasource authDatasource = AuthDatasource(loginService);
  //Controllers
    //Features
  static BiometricController biometricController = BiometricController();
  static LocationController locationController = LocationController();
  static CloudinaryController cloudinaryController = CloudinaryController();
  //Pages
  static SplashController splashController = SplashController(authDatasource, biometricController);
  static OnboardingController onboardingController = OnboardingController();
  static LoginController loginController = LoginController(authDatasource, loginService);
  static ForgetPasswordController forgetPasswordController = ForgetPasswordController(authDatasource, loginService);
  static SignupController signupController = SignupController(authDatasource, loginService);
  static LayoutController layoutController = LayoutController();
  static HomeController homeController = HomeController(voiceService: voiceService);
  static ProfileController profileController = ProfileController(authDatasource: authDatasource, locationController: locationController, cloudinaryController: cloudinaryController);
  static SettingsController settingsController = SettingsController();
}