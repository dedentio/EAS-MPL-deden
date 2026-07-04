import 'package:dio/dio.dart';

class NewsApiService {
  final Dio _dio;

  NewsApiService(this._dio);

  /// Mengambil data mentah dari endpoint NewsAPI
  Future<Response> getEverythingNews() async {
    return await _dio.get(
      'everything?q=indonesia&sortBy=publishedAt&apiKey=e8c8118de54f49979c0fa9babe4edb7a',
    );
  }
}