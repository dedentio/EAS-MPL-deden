import 'package:dio/dio.dart';
import '../../domain/models/article.dart';

class NewsRepositoryImpl {
  final Dio _dio;

  NewsRepositoryImpl(this._dio);

  Future<List<Article>> fetchNews() async {
    try {
      // Mengambil data berita (Ganti apiKey dengan API key NewsAPI.org milikmu jika sudah ada)
      final response = await _dio.get('top-headlines?country=id&apiKey=API_KEY_KAMU');

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'] ?? [];
        
        List<Article> articles = articlesJson
            .map((json) => Article.fromJson(json))
            .toList();

        // ⚠️ TANTANGAN ANTI-AI NIM GANJIL:
        // Digit terakhir NPM 20123009 adalah 9 (Ganjil).
        // Wajib mengurutkan data dari Z ke A (Descending) di layer Repository!
        articles.sort((a, b) => b.title.compareTo(a.title));[cite: 1]

        return articles;
      } else {
        throw Exception('Gagal memuat berita dari API server.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}