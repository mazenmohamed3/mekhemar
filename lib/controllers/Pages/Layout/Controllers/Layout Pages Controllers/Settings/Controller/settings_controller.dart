import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mekhemar/views/components/Dialog/username_input_dialog.dart';
import 'package:mekhemar/views/components/Snack%20Bar/success_snackbar.dart';
import 'dart:convert';

import '../../../../../../../models/Settings/settings_model.dart';
import '../../../../../../../views/components/Dialog/password_input_dialog.dart';
import '../../../../../../Generated/Assets/assets.dart';
import '../../../../../../Repos/local/secure_storage_helper.dart';
import '../Services/settings_update_service.dart';

typedef SettingsCallback = void Function(SettingsModel settings);

class SettingsController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late void Function(void Function()) setTemperatureState;
  late void Function(void Function())? setLightModeState;
  SettingsModel _settings = SettingsModel();
  String? brightnessIcon = Assets.darkMode;
  String? brightnessLabel = '';

  // Settings notifier
  final SettingsUpdateService _settingsNotifierService =
      SettingsUpdateService();

  SettingsModel get settings => _settings;

  String get selectedModel => settings.selectedModel;

  String get selectedLanguage => settings.selectedLanguage;

  double get temperature => settings.temperature;

  bool get isDarkMode => settings.isDarkMode;

  Future<void> loadSettings() async {
    try {
      final settingsString = await SecureStorageHelper.readValueFromKey(
        key: 'settings',
      );
      final String? storedTheme = await SecureStorageHelper.readValueFromKey(
        key: 'themeMode',
      );

      if (settingsString != null) {
        final settingsMap = json.decode(settingsString) as Map<String, dynamic>;
        _settings = SettingsModel.fromMap(settingsMap);
      }

      if (storedTheme != null) {
        if (storedTheme == 'light') {
          _settings.updateDarkMode(false);
        } else {
          _settings.updateDarkMode(true);
        }
      } else {
        _settings.updateDarkMode(false);
      }
      setLightModeState!(() {

        brightnessIcon = _settings.brightnessIcon;
        brightnessLabel = _settings.brightnessLabel;
      });

      _notifySettingsUpdate(SettingsUpdateType.all);
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> saveSettings() async {
    try {
      final settingsMap = _settings.toMap();
      final settingsString = json.encode(settingsMap);

      await SecureStorageHelper.writeValueToKey(
        key: 'settings',
        value: settingsString,
      );
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  void onUsernameTap(BuildContext context) async {
    String? newUsername = await showDialog<String>(
      context: context,
      builder: (context) => UsernameInputDialog(),
    );
    if (newUsername == null || newUsername.isEmpty) return;
    _settings.updateUsername(newUsername);
    try{
      await _auth.currentUser?.updateDisplayName(newUsername);
    } on FirebaseAuthException catch (e) {
      print('Error updating username: $e');
    }
    await saveSettings();
    if(!context.mounted) return;
    showSuccessSnackBar(context, title: 'usernameUpdatedSuccess');
    _notifySettingsUpdate(SettingsUpdateType.username);
  }

  void onPasswordTap(BuildContext context) async {
    String? newPassword = await showDialog<String>(
      context: context,
      builder: (context) => PasswordInputDialog(),
    );
    if (newPassword == null || newPassword.isEmpty) return;
    _settings.updatePassword(newPassword);
    await _auth.currentUser?.updatePassword(newPassword);
    await saveSettings();
    if(!context.mounted) return;
    showSuccessSnackBar(context, title: 'passwordUpdatedSuccess');
  }

  void onModelSelected(String? newModel) async {
    if (newModel == selectedModel) return;
    if (newModel == null) return;
    _settings.updateSelectedModel(newModel);
    await saveSettings();

    // Notify listeners about model change
    _notifySettingsUpdate(SettingsUpdateType.model);
  }

  void onTemperatureChanged(double newTemperature) async {
    setTemperatureState(() {
      _settings.updateTemperature(newTemperature);
    });
    await saveSettings();

  }

  void onTemperatureChangedEnd(double newTemperature) async {
    setTemperatureState(() {
      _settings.updateTemperature(newTemperature);
    });
    await saveSettings();
    _notifySettingsUpdate(SettingsUpdateType.temperature);
  }

  void onLightModeChanged(bool value) async {
    setLightModeState!(() {
      _settings.updateDarkMode(value);
      brightnessIcon = _settings.brightnessIcon;
      brightnessLabel = _settings.brightnessLabel;
    });
    await saveSettings();

    // Notify listeners about dark mode change
    _notifySettingsUpdate(SettingsUpdateType.themeMode);
  }

  String getLanguageValue(BuildContext context) {
    final locale = context.locale;
    final languageCode = locale.languageCode;
    if (languageCode == 'en') {
      _settings.updateSelectedLanguage('en');
    } else if (languageCode == 'ar') {
      _settings.updateSelectedLanguage('ar');
    }

    return context.locale.languageCode;
  }

  void onLanguageSelected(BuildContext context, String? newLanguage) async {
    if (newLanguage == selectedLanguage) return;
    if (newLanguage == null) return;
    _settings.updateSelectedLanguage(newLanguage);
    await context.setLocale(Locale(newLanguage));
    await saveSettings();
    // Notify listeners about language change
    _notifySettingsUpdate(SettingsUpdateType.language);
  }

  // Helper method to broadcast settings updates
  void _notifySettingsUpdate(SettingsUpdateType updateType) {
    _settingsNotifierService.notifySettingsUpdate(
      SettingsUpdateEvent(settings: _settings, updateType: updateType),
    );
  }
}