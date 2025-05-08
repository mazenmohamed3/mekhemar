import 'package:flutter/material.dart';
import '../../../Repos/local/secure_storage_helper.dart';

class InitLocaleController {
  static Future<Locale> initializeAppLocale() async {
    // Check if it's the first time the app is launched
    String? isFirstTime = await SecureStorageHelper.readValueFromKey(
      key: 'isFirstTime',
    );

    Locale initialLocale;
    if (isFirstTime == null) {
      // First time opening the app, get device's locale
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

      // Check if the language code contains 'ar' or 'en' (e.g., 'ar-EG', 'en-US')
      if (deviceLocale.languageCode.contains('ar')) {
        initialLocale = const Locale('ar'); // Set to Arabic
      } else if (deviceLocale.languageCode.contains('en')) {
        initialLocale = const Locale('en'); // Set to English
      } else {
        initialLocale = const Locale(
          'en',
        ); // Default to English if neither 'ar' nor 'en'
      }

      // Save the selected locale as the default for future app launches
      await SecureStorageHelper.writeValueToKey(
        key: 'chosenLocale',
        value: initialLocale.languageCode,
      );

      // Save that the app is no longer "first time"

    } else {
      // Fetch the saved locale
      String? savedLocale = await SecureStorageHelper.readValueFromKey(
        key: 'chosenLocale',
      );

      // If no saved locale, default to English
      if (savedLocale == null || savedLocale.isEmpty) {
        initialLocale = const Locale('en');
      } else {
        initialLocale = Locale(savedLocale); // Use the saved locale
      }
    }

    return initialLocale;
  }
}
