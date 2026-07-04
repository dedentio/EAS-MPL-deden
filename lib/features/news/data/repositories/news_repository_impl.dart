import 'package:isar/isar.dart';
import '../../domain/models/article.dart';
import '../datasources/news_api_service.dart';
import '../models/news_cache.dart';

class NewsRepositoryImpl {
  final NewsApiService _apiService; // Menggunakan service, bukan Dio langsung
  final Isar _isar;

  NewsRepositoryImpl(this._apiService, this._isar);

  Future<List<Article>> fetchNews() async {
    try {
      // 1. Ambil respons dari service eksternal
      final response = await _apiService.getEverythingNews();

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'] ?? [];
        
        List<Article> articles = articlesJson
            .map((json) => Article.fromJson(json))
            .toList();

        // ⚠️ TANTANGAN ANTI-AI NIM GANJIL: Urutkan judul dari Z ke A (Descending)
        articles.sort((a, b) => b.title.compareTo(a.title));

        // 2. PARADIGMA OFFLINE-FIRST: Caching data murni ke Isar lokal
        await _isar.writeTxn(() async {
          await _isar.newsCaches.clear();

          for (var article in articles) {
            final cache = NewsCache()
              ..title = article.title
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
      throw Exception(e.toString());
    }
  }

  // Fungsi memuat cache data lokal dari Isar saat offline
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