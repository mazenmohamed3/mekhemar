import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static Color defaultTextColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
  }

  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple.shade900,
    primary: Color(0xff4e5cc2),
    brightness: Brightness.light,
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple.shade900,
    primary: Color(0xff4e5cc2),
    brightness: Brightness.dark,
  );

  static final TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
    displayMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
    displaySmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    bodyLarge: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
    bodyMedium: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
    bodySmall: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
    labelLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    labelMedium: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
    labelSmall: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
  );

  static final ThemeData lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    useMaterial3: true,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: lightColorScheme.surface,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
              (states) => lightColorScheme.primary,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
              (states) => lightColorScheme.surface,
        ),
        overlayColor: WidgetStateProperty.resolveWith(
              (states) => lightColorScheme.onSurface.withAlpha(50),
        ),
        elevation: WidgetStateProperty.all(4),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge!.copyWith(color: lightColorScheme.onSurface),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
              (states) => lightColorScheme.surface,
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: lightColorScheme.primary),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge!.copyWith(color: lightColorScheme.onSurface),
        ),
        overlayColor: WidgetStateProperty.resolveWith(
              (states) => lightColorScheme.onSurface.withAlpha(50),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        // In light mode, make the text color black
        foregroundColor: WidgetStateProperty.resolveWith(
              (states) => lightColorScheme.onSurface, // Or Color(0xFF000000) for pure black
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.bodyLarge!.copyWith(color: lightColorScheme.onSurface),
        ),
        overlayColor: WidgetStateProperty.resolveWith(
              (states) => lightColorScheme.onSurface.withAlpha(50),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightColorScheme.primary, width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightColorScheme.primary, width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightColorScheme.primary.withAlpha(128), width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightColorScheme.error, width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightColorScheme.error, width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      labelStyle: textTheme.bodyLarge,
      hintStyle: textTheme.bodyLarge,
      floatingLabelStyle: textTheme.bodyLarge!.copyWith(color: lightColorScheme.primary),
    ),
    textTheme: textTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    useMaterial3: true,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: darkColorScheme.surface,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
              (states) => darkColorScheme.primary,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
              (states) => darkColorScheme.surface,
        ),
        overlayColor: WidgetStateProperty.resolveWith(
              (states) => darkColorScheme.onSurface.withAlpha(50),
        ),
        elevation: WidgetStateProperty.all(4),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge!.copyWith(color: darkColorScheme.onSurface),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
              (states) => darkColorScheme.surface,
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: darkColorScheme.primary),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge!.copyWith(color: darkColorScheme.onSurface),
        ),
        overlayColor: WidgetStateProperty.resolveWith(
              (states) => darkColorScheme.onSurface.withAlpha(50),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        // In dark mode, make the text color white or primary
        foregroundColor: WidgetStateProperty.resolveWith(
              (states) => darkColorScheme.onSurface, // Or darkColorScheme.primary for primary color
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.bodyLarge!.copyWith(color: darkColorScheme.onSurface),
        ),
        overlayColor: WidgetStateProperty.resolveWith(
              (states) => darkColorScheme.onSurface.withAlpha(50),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkColorScheme.primary, width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkColorScheme.primary, width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkColorScheme.primary.withAlpha(128), width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkColorScheme.error, width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkColorScheme.error, width: 2.5),
        borderRadius: BorderRadius.circular(12),
      ),
      labelStyle: textTheme.bodyLarge,
      hintStyle: textTheme.bodyLarge,
      floatingLabelStyle: textTheme.bodyLarge!.copyWith(color: darkColorScheme.primary),
    ),
    textTheme: textTheme,
  );
}