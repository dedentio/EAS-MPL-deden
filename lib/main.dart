import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
// ⚠️ SILAKAN SESUAIKAN IMPORT ROUTER DI BAWAH INI DENGAN PATH DI PROYEKMU
// Jika nama filenya beda, sesuaikan (misal: 'core/navigation/router.dart')
import 'core/routing/app_router.dart'; 
import 'features/news/presentation/bloc/news_bloc.dart';
import 'features/news/presentation/bloc/news_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Membuka koneksi basis data lokal Isar dan mendaftarkan kelas dependensi GetIt
  await setupLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca identitas nama aplikasi dinamis dari terminal '--dart-define'
    const appTitle = String.fromEnvironment('APP_NAME', defaultValue: 'DigiNews');

    return MultiBlocProvider(
      providers: [
        // Menyuntikkan instansiasi NewsBloc global dengan event pembuka LoadNewsEvent
        BlocProvider<NewsBloc>(
          create: (context) => locator<NewsBloc>()..add(LoadNewsEvent()), 
        ),
      ],
      // Menggunakan MaterialApp.router agar context.push() di news_page.dart baris 147 bisa berjalan
      child: MaterialApp.router(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        
        // INTEGRASI TEMA MULTI-FLAVOR DINAMIS
        theme: AppTheme.themeData,
        
        // ⚠️ PANGGIL VARIABEL ROUTER KAMU DI SINI
        // Jika di file app_router.dart nama variabelnya adalah 'router', gunakan AppRouter.router
        // Jika nama variabelnya global (misal: final router = GoRouter(...)), langsung panggil: router
        routerConfig: AppRouter.router, 
      ),
    );
  }
}