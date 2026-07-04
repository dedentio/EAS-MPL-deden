import 'package:flutter/material.dart';
import '../config/env_config.dart';

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      // Jika PROD wajib Biru Gelap (Navy), jika DEV menggunakan Teal
      colorSchemeSeed: EnvConfig.isProduction ? const Color(0xFF001A3A) : Colors.teal,
      brightness: EnvConfig.isProduction ? Brightness.dark : Brightness.light,
    );
  }
}