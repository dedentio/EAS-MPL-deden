import 'package:flutter/material.dart';

class AppTheme {
  // Mengambil nama environment dari argument runtime compilation
  static const String currentEnv = String.fromEnvironment('ENV_NAME', defaultValue: 'DEV');

  static ThemeData get themeData {
    // 1. JIKA FLAVOR ADALAH PROD (NIM Ujian) -> TEMA GELAP (DARK MODE) + BIRU GELAP
    if (currentEnv == 'PROD') {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1E3A8A), // Biru Gelap / Navy
          secondary: Color(0xFF3B82F6),
          surface: Color(0xFF0F172A),  // Latar belakang gelap slate
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        // PERBAIKAN: Menggunakan CardThemeData
        cardTheme: const CardThemeData(
          color: Color(0xFF1E293B),
        ),
      );
    }

    // 2. JIKA FLAVOR ADALAH DEV -> TEMA TERANG (LIGHT MODE) + TEAL
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Colors.teal, // Warna Hijau Toska / Teal
        secondary: Colors.tealAccent,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // PERBAIKAN: Menggunakan CardThemeData
      cardTheme: CardThemeData(
        color: Colors.grey.shade50,
      ),
    );
  }
}