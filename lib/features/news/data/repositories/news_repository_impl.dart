import 'package:dio/dio';
import 'package:isar/isar';
import '../../domain/models/article.dart';
import '../models/news_cache.dart';

class NewsRepositoryImpl {
  final Dio _dio;
  final Isar _isar;

  // Konstruktor sekarang menerima 2 argumen sesuai kebutuhan Injection
  NewsRepositoryImpl(this._dio, this._isar);

  Future<List<Article>> fetchNews() async {
    try {
      // 1. Ambil data dari API News terpusat menggunakan Dio[cite: 1, 2]
      final response = await _dio.get('top-headlines?country=id&apiKey=API_KEY_KAMU');

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'] ?? [];
        
        List<Article> articles = articlesJson
            .map((json) => Article.fromJson(json))
            .toList();

        // TANTANGAN ANTI-AI NIM GANJIL: Urutkan data dari Z ke A (Descending)
        articles.sort((a, b) => b.title.compareTo(a.title));

        // 2. PARADIGMA OFFLINE-FIRST: Hapus cache lama dan simpan data terbaru ke Isar[cite: 1, 2]
        await _isar.writeTxn(() async {
          // Bersihkan cache lama agar tidak menumpuk
          await _isar.newsCaches.clear();

          // Pindahkan data dari list model API ke skema koleksi Isar
          for (var article in articles) {
            final cache = NewsCache()
              ..title = article.title
              ..description = article.description
              ..urlToImage = article.urlToImage
              ..content = article.content;
            
            await _isar.newsCaches.put(cache);
          }
        });

        return articles;
      } else {
        throw Exception('Gagal memuat berita dari API server.');
      }
    } catch (e) {
      // Jika terjadi error (misalnya internet mati/Airplane Mode), lemparkan error agar ditangkap BLOC[cite: 1]
      throw Exception(e.toString());
    }
  }

  // Fungsi tambahan khusus untuk memuat cache data lokal dari Isar saat offline
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