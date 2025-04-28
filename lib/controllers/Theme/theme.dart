import 'package:flutter/material.dart';

final ThemeData purpleTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F3F8),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.purple,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 4,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.purple,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.purple),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      elevation: WidgetStateProperty.all(4),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.purple,
      side: const BorderSide(color: Colors.purple),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.purple,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.purple, width: 2.5),
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.purpleAccent, width: 2.5),
      borderRadius: BorderRadius.circular(12),
    ),
    labelStyle: const TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.bold, // <-- Label Text (Floating)
      fontSize: 16,
    ),
    hintStyle: const TextStyle(
      color: Colors.purpleAccent,
      fontWeight: FontWeight.bold, // <-- Hint Text
      fontSize: 16,
    ),
    floatingLabelStyle: const TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.bold, // <-- Floating Label when focused
      fontSize: 16,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontWeight: FontWeight.bold, // <-- Main input text inside TextFormField
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  ),
);