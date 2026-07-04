import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/presentation/bloc/news_bloc.dart'; // Import BLOC

final locator = GetIt.instance;

void setupLocator() {
  // 1. Registrasi Client Dio
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  // 2. Registrasi News Repository
  locator.registerLazySingleton<NewsRepositoryImpl>(
    () => NewsRepositoryImpl(locator<Dio>()),
  );

  // 3. Registrasi News BLOC (Gunakan factory agar BLOC ter-reset setiap halaman dibuka ulang)
  locator.registerFactory<NewsBloc>(
    () => NewsBloc(locator<NewsRepositoryImpl>()),
  );
}