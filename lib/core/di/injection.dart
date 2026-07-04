import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../config/env_config.dart';
import '../../features/news/data/datasources/news_api_service.dart'; // Import service baru
import '../../features/news/data/models/news_cache.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/presentation/bloc/news_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // 1. Inisialisasi Isar
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([NewsCacheSchema], directory: dir.path);
  locator.registerSingleton<Isar>(isar);

  // 2. Registrasi Dio Client
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  // 3. Registrasi News API Service (Baru)
  locator.registerLazySingleton<NewsApiService>(() => NewsApiService(locator<Dio>()));

  // 4. Registrasi News Repository (Menerima ApiService & Isar)
  locator.registerLazySingleton<NewsRepositoryImpl>(
    () => NewsRepositoryImpl(locator<NewsApiService>(), locator<Isar>()),
  );

  // 5. Registrasi News BLOC
  locator.registerFactory<NewsBloc>(() => NewsBloc(locator<NewsRepositoryImpl>()));
}