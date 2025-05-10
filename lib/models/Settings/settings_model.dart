import 'package:flutter/material.dart';
import 'package:groq_sdk/models/groq_llm_model.dart';
import '../../controllers/Generated/Assets/assets.dart';

class SettingsModel {
  // Account settings
  String username;
  String password;

  // AI settings
  String selectedModel;
  double temperature;

  // Preferences
  bool isDarkMode;
  String selectedLanguage;

  // UI presentation
  String brightnessIcon;
  String brightnessLabel;

  SettingsModel({
    this.username = '',
    this.password = '',
    this.selectedModel = GroqModels.llama3_70b,
    this.temperature = 0.5,
    this.isDarkMode = false,
    this.selectedLanguage = 'en',
    String? brightnessIcon,
    String? brightnessLabel,
  })  : brightnessIcon = brightnessIcon ?? Assets.lightMode,
        brightnessLabel = brightnessLabel ?? "Light Mode" {
    // Adjust icon and label based on isDarkMode
    if (isDarkMode) {
      this.brightnessIcon = Assets.darkMode;
      this.brightnessLabel = "Dark Mode";
    }
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    final bool isDark = map.containsKey('isDarkMode')
        ? map['isDarkMode']
        : !(map['isLightMode'] ?? true); // Invert fallback

    return SettingsModel(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      selectedModel: map['selectedModel'] ?? GroqModels.llama3_70b,
      temperature: (map['temperature'] ?? 0.5).toDouble(),
      isDarkMode: isDark,
      selectedLanguage: map['selectedLanguage'] ?? 'en',
      brightnessIcon: isDark ? Assets.darkMode : Assets.lightMode,
      brightnessLabel: isDark ? "Dark Mode" : "Light Mode",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'selectedModel': selectedModel,
      'temperature': temperature,
      'isDarkMode': isDarkMode,
      'selectedLanguage': selectedLanguage,
      'brightnessIcon': brightnessIcon,
      'brightnessLabel': brightnessLabel,
    };
  }

  void updateUsername(String newUsername) {
    username = newUsername;
  }

  void updatePassword(String newPassword) {
    password = newPassword;
  }

  void updateSelectedModel(String model) {
    selectedModel = model;
  }

  void updateTemperature(double value) {
    temperature = value;
  }

  void updateDarkMode(bool value) {
    isDarkMode = value;
    brightnessIcon = value ? Assets.darkMode : Assets.lightMode;
    brightnessLabel = value ? "Dark Mode" : "Light Mode";
  }

  void updateSelectedLanguage(String language) {
    selectedLanguage = language;
  }

  factory SettingsModel.fromSystemBrightness(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return SettingsModel(
      isDarkMode: isDark,
      brightnessIcon: isDark ? Assets.darkMode : Assets.lightMode,
      brightnessLabel: isDark ? "Dark Mode" : "Light Mode",
    );
  }
}