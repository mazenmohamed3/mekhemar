import 'package:local_auth/local_auth.dart';

class BiometricController {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Check if biometrics are available
  Future<bool> canCheckBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }

  // Authenticate with biometrics
  Future<bool> authenticate() async {
    try {
      // Check if biometrics are available
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: AuthenticationOptions(
          biometricOnly: false,
        ),
      );
      return authenticated;
    } catch (e) {
      return false;
    }
  }
}