import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = const Color(0xFF4F659C);
  static Color secondaryColor = const Color(0xFFFFBC37);
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    hintColor: primaryColor,
    secondaryHeaderColor: secondaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black54),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 18),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.black),
      hintStyle: const TextStyle(color: Colors.black38),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      prefixIconColor: primaryColor,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor, // Global cursor color
    ),
  );
}
