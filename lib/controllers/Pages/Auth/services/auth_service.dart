import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Repos/local/secure_storage_helper.dart';
import '../../Layout/Controllers/Layout Pages Controllers/Home/Services/chat_service.dart';

class AuthService {
  static const _rememberMeKey = 'rememberMe';
  Map<String, ChatService> chatHistory = {};

  // FirebaseAuth error mapper
  String handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return "invalidEmailOrPassword";
      case 'user-disabled':
        return "userDisabled";
      case 'too-many-requests':
        return "tooManyRequests";
      case 'network-request-failed':
        return "networkError";
      case 'email-already-in-use':
        return "emailAlreadyInUse";
      case 'weak-password':
        return "weakPassword";
      default:
        return "unknownError";
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'pleaseEnterEmail'.tr();
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'invalidEmail'.tr();
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'pleaseEnterUsername'.tr();
    }
    if (value.length < 3) {
      return 'usernameTooShort'.tr();
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'pleaseEnterPassword'.tr();
    }
    if (value.length < 6) {
      return 'passwordTooShort'.tr();
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'pleaseConfirmPassword'.tr();
    }
    if (value != password) {
      return 'passwordsDoNotMatch'.tr();
    }
    return null;
  }

  static Future<void> setRememberMe(bool value) async {
    await SecureStorageHelper.writeValueToKey(
      key: _rememberMeKey,
      value: value.toString(),
    );
  }

  static Future<bool> getRememberMe() async {
    final value = await SecureStorageHelper.readValueFromKey(
      key: _rememberMeKey,
    );
    return value == 'true';
  }

  static Future<void> clearRememberMe() async {
    await SecureStorageHelper.deleteValueFromKey(key: _rememberMeKey);
  }

  Future<void> saveLogin({
    required String email,
    required String password,
    required String username,
    required bool isGoogleSignIn,
  }) async {
    await SecureStorageHelper.writeValueToKey(key: "email", value: email);
    await SecureStorageHelper.writeValueToKey(key: "username", value: username);
    await SecureStorageHelper.writeValueToKey(
      key: "isGoogleSignIn",
      value: isGoogleSignIn.toString(),
    );
    if (!isGoogleSignIn) {
      await SecureStorageHelper.writeValueToKey(
        key: "password",
        value: password,
      );
    }
  }

  Future<void> clearSavedLogin() async {
    await SecureStorageHelper.deleteValueFromKey(key: "email");
    await SecureStorageHelper.deleteValueFromKey(key: "username");
    await SecureStorageHelper.deleteValueFromKey(key: "password");
    await SecureStorageHelper.deleteValueFromKey(key: "isGoogleSignIn");
  }

  Future<Map<String, String?>> loadSavedLogin() async {
    final email = await SecureStorageHelper.readValueFromKey(key: "email");
    final username = await SecureStorageHelper.readValueFromKey(
      key: "username",
    );
    final password = await SecureStorageHelper.readValueFromKey(
      key: "password",
    );
    final isGoogleSignIn = await SecureStorageHelper.readValueFromKey(
      key: "isGoogleSignIn",
    );

    return {
      "email": email,
      "username": username,
      "password": password,
      "isGoogleSignIn": isGoogleSignIn,
    };
  }
}
