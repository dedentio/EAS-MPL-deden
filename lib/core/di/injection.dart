import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../config/env_config.dart';
import '../../features/news/data/models/news_cache.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/presentation/bloc/news_bloc.dart';

final locator = GetIt.instance;

// Ubah fungsi menjadi Future agar bisa menanti (await) inisialisasi Isar
Future<void> setupLocator() async {
  // 1. Inisialisasi Penyimpanan Isar Database Lokal
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [NewsCacheSchema], // Schema hasil generate build_runner
    directory: dir.path,
  );
  // Registrasi Isar sebagai Singleton
  locator.registerSingleton<Isar>(isar);

  // 2. Registrasi Client Dio
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  // 3. Registrasi News Repository (Kini menerima parameter Isar untuk caching)
  locator.registerLazySingleton<NewsRepositoryImpl>(
    () => NewsRepositoryImpl(locator<Dio>(), locator<Isar>()),
  );

  // 4. Registrasi News BLOC
  locator.registerFactory<NewsBloc>(
    () => NewsBloc(locator<NewsRepositoryImpl>()),
  );
}