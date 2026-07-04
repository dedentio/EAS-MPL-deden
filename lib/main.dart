import 'package:flutter/material.dart';
import 'core/config/env_config.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DigiNewsApp());
}

class DigiNewsApp extends StatelessWidget {
  const DigiNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: !EnvConfig.isProduction, // Sembunyikan banner di PROD
      title: EnvConfig.appName,
      theme: AppTheme.themeData,
      routerConfig: AppRouter.router,
    );
  }
}