import 'dart:async';
import 'package:flutter/material.dart';

/// A broadcast system to share theme mode updates across the app.
class ThemeUpdateService {
  // Singleton pattern
  static final ThemeUpdateService _instance = ThemeUpdateService._internal();
  factory ThemeUpdateService() => _instance;
  ThemeUpdateService._internal();

  final _themeUpdateController = StreamController<ThemeMode>.broadcast();

  Stream<ThemeMode> get themeUpdates => _themeUpdateController.stream;

  void notifyThemeUpdate(ThemeMode themeMode) {
    _themeUpdateController.add(themeMode);
  }

  void dispose() {
    _themeUpdateController.close();
  }
}