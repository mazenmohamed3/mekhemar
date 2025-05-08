import 'dart:async';
import 'package:flutter/material.dart';
import '../../Pages/Layout/Controllers/Layout Pages Controllers/Settings/Services/settings_update_service.dart';
import '../../Repos/local/secure_storage_helper.dart';
import '../Service/theme_update_service.dart';

class ThemeController {
  ThemeMode _themeMode = ThemeMode.system;
  final StreamController<ThemeMode> _themeModeControllerStream =
      StreamController<ThemeMode>.broadcast();
  final ThemeUpdateService _themeUpdateService = ThemeUpdateService();
  late final StreamSubscription<SettingsUpdateEvent> _settingsSubscription;

  ThemeMode get themeMode => _themeMode;

  Stream<ThemeMode> get themeModeStream => _themeModeControllerStream.stream;

  ThemeController() {
    _settingsSubscription = SettingsUpdateService().settingsUpdates.listen(
      _handleSettingsUpdate,
    );
  }

  // Initialize the theme from secure storage, defaulting to light mode if not found
  Future<void> loadThemeFromStorage() async {
    try {
      final isFirstTime = await SecureStorageHelper.readValueFromKey(
        key: 'isFirstTime',
      );
      final storedTheme = await SecureStorageHelper.readValueFromKey(
        key: 'themeMode',
      );

      if (isFirstTime == null && storedTheme == null) {
        // If theme was found in secure storage, set it accordingly
        _themeMode = ThemeMode.system;
      } else if (storedTheme != null) {
        _themeMode = storedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
      }

      _themeModeControllerStream.add(_themeMode);
    } catch (e) {
      debugPrint('Error loading theme from storage: $e');
      // Default to light mode if there was an issue reading from storage
      _themeMode = ThemeMode.light;
      await _saveThemeToStorage('light');
      _themeModeControllerStream.add(_themeMode);
    }
  }

  // Save the theme mode to secure storage
  Future<void> _saveThemeToStorage(String theme) async {
    try {
      await SecureStorageHelper.writeValueToKey(key: 'themeMode', value: theme);
    } catch (e) {
      debugPrint('Error saving theme to storage: $e');
    }
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      _themeModeControllerStream.add(_themeMode);
      _themeUpdateService.notifyThemeUpdate(_themeMode); // broadcast theme
      _saveThemeToStorage(
        mode == ThemeMode.light ? 'light' : 'dark',
      ); // Save new theme to secure storage
    }
  }

  void saveFirstTime(BuildContext context) async {
    String? firstTime = await SecureStorageHelper.readValueFromKey(key: 'isFirstTime',);
    if(firstTime != null) return;
    if(!context.mounted) return;
    final brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.light) {
      await _saveThemeToStorage('light');
      setThemeMode(ThemeMode.light);
    } else {
      await _saveThemeToStorage('dark');
      setThemeMode(ThemeMode.dark);
    }
  }

  void toggleThemeMode(bool isDarkMode) {
    final newMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(newMode);
  }

  void _handleSettingsUpdate(SettingsUpdateEvent event) {
    if (event.updateType == SettingsUpdateType.themeMode ||
        event.updateType == SettingsUpdateType.all) {
      toggleThemeMode(event.settings.isDarkMode);
    }
  }

  void dispose() {
    _themeModeControllerStream.close();
    _settingsSubscription.cancel();
  }
}
