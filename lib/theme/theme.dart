import 'package:flutter/material.dart';
import 'colors.dart';

class NiubiTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NiubiColors.bgPage,
      colorScheme: const ColorScheme.dark(
        primary: NiubiColors.primary,
        secondary: NiubiColors.secondary,
        tertiary: NiubiColors.accent,
        surface: NiubiColors.bgCard,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: NiubiColors.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: NiubiColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: NiubiColors.borderColor),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xE60A0A0F),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: NiubiColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: NiubiColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NiubiColors.bgDeepest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NiubiColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NiubiColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NiubiColors.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: NiubiColors.textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: NiubiColors.textSecondary, fontSize: 13),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NiubiColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: NiubiColors.primaryLight,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: NiubiColors.borderLight,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: NiubiColors.textPrimary, fontWeight: FontWeight.w800),
        displayMedium: TextStyle(color: NiubiColors.textPrimary, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: NiubiColors.textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: NiubiColors.textSecondary, fontSize: 14),
        bodySmall: TextStyle(color: NiubiColors.textMuted, fontSize: 12),
        labelLarge: TextStyle(color: NiubiColors.textPrimary, fontWeight: FontWeight.w600),
      ),
    );
  }
}
