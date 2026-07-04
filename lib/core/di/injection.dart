import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Registrasi Client Dio untuk Networking
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    // Menambahkan Interceptor standar sesuai modul praktikum
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  // 2. Registrasi News Repository
  locator.registerLazySingleton<NewsRepositoryImpl>(
    () => NewsRepositoryImpl(locator<Dio>()),
  );
}