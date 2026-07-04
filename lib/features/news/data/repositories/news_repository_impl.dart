import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import '../../domain/models/article.dart';
import '../models/news_cache.dart';

class NewsRepositoryImpl {
  final Dio _dio;
  final Isar _isar;

  NewsRepositoryImpl(this._dio, this._isar);

  Future<List<Article>> fetchNews() async {
    try {
      // 1. Ambil data asli dari NewsAPI menggunakan API Key kamu
      final response = await _dio.get('top-headlines?country=id&apiKey=e8c8118de54f49979c0fa9babe4edb7a');

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'] ?? [];
        
        List<Article> articles = articlesJson
            .map((json) => Article.fromJson(json))
            .toList();

        // TANTANGAN ANTI-AI NIM GANJIL: Urutkan data dari Z ke A (Descending)
        articles.sort((a, b) => b.title.compareTo(a.title));

        // 2. PARADIGMA OFFLINE-FIRST: Simpan data ter-update ke Isar lokal
        await _isar.writeTxn(() async {
          // Bersihkan cache lama agar penyimpanan tidak membengkak
          await _isar.newsCaches.clear();

          for (var article in articles) {
            final cache = NewsCache()
              ..title = article.title
              // Memberikan fallback string kosong ('') jika properti dari API bernilai null
              ..description = article.description ?? ''
              ..urlToImage = article.urlToImage ?? ''
              ..content = article.content ?? '';
            
            await _isar.newsCaches.put(cache);
          }
        });

        return articles;
      } else {
        throw Exception('Gagal memuat berita dari API server.');
      }
    } catch (e) {
      // Melempar error agar dibaca oleh Catch Error di layer BLOC saat offline
      throw Exception(e.toString());
    }
  }

  // Fungsi khusus untuk memuat cache data lokal dari Isar saat offline
  Future<List<Article>> fetchOfflineNews() async {
    final cachedData = await _isar.newsCaches.where().findAll();
    
    return cachedData.map((cache) {
      return Article(
        title: cache.title,
        description: cache.description,
        urlToImage: cache.urlToImage,
        content: cache.content,
      );
    }).toList();
  }
}