import 'package:flutter/material.dart';
import 'core/config/env_config.dart';
import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // Wajib dipanggil jika menggunakan async sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Menanti inisialisasi Dependency Injection & Isar Database selesai
  await setupLocator();
  
  runApp(const DigiNewsApp());
}

class DigiNewsApp extends StatelessWidget {
  const DigiNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: !EnvConfig.isProduction,
      title: EnvConfig.appName,
      theme: AppTheme.themeData,
      routerConfig: AppRouter.router,
    );
  }
}