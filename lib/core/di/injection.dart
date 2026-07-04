import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';

final locator = GetIt.instance;[cite: 2]

void setupLocator() {[cite: 2]
  // 1. Registrasi Client Dio untuk Networking
  locator.registerLazySingleton<Dio>(() {[cite: 2]
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));[cite: 2]
    // Menambahkan Interceptor standar sesuai modul praktikum
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));[cite: 2]
    return dio;
  });

  // 2. Registrasi News Repository
  locator.registerLazySingleton<NewsRepositoryImpl>(
    () => NewsRepositoryImpl(locator<Dio>()),
  );
}