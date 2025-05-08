import 'dart:async';

import '../../../../../../../models/Settings/settings_model.dart';

/// A notification system for broadcasting settings updates across the app.
///
/// This class follows the Singleton pattern to ensure a single instance is used app-wide.
class SettingsUpdateService {
  // Singleton instance
  static final SettingsUpdateService _instance = SettingsUpdateService._internal();

  // Factory constructor to return the singleton instance
  factory SettingsUpdateService() => _instance;

  // Private constructor for singleton
  SettingsUpdateService._internal();

  // StreamController for settings updates
  final _settingsUpdateController = StreamController<SettingsUpdateEvent>.broadcast();

  // Stream that other widgets/controllers can listen to
  Stream<SettingsUpdateEvent> get settingsUpdates => _settingsUpdateController.stream;

  // Method to notify listeners when settings change
  void notifySettingsUpdate(SettingsUpdateEvent event) {
    _settingsUpdateController.add(event);
  }

  // Clean up resources
  void dispose() {
    _settingsUpdateController.close();
  }
}

/// Event class containing settings update information
class SettingsUpdateEvent {
  final SettingsModel settings;
  final SettingsUpdateType updateType;

  SettingsUpdateEvent({
    required this.settings,
    required this.updateType,
  });
}

/// Enum to specify what type of setting was updated
enum SettingsUpdateType {
  model,
  temperature,
  themeMode,
  language,
  all,
  username,
}