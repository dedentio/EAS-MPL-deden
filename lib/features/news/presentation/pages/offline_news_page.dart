import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/models/article.dart';

class OfflineNewsPage extends StatefulWidget {
  const OfflineNewsPage({super.key});

  @override
  State<OfflineNewsPage> createState() => _OfflineNewsPageState();
}

class _OfflineNewsPageState extends State<OfflineNewsPage> {
  late final NewsRepositoryImpl _newsRepository;
  List<Article> _offlineArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Mengambil instance repository dari GetIt locator
    _newsRepository = locator<NewsRepositoryImpl>();
    _loadOfflineData();
  }

  Future<void> _loadOfflineData() async {
    try {
      final localData = await _newsRepository.fetchOfflineNews();
      setState(() {
        _offlineArticles = localData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark 
          ? const Color(0xFF0A0F1D) 
          : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Berita Offline (Cache)'),
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _offlineArticles.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off_rounded, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum Ada Cache Berita',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Aplikasi belum sempat menyimpan data dari internet. Silakan hubungkan internet terlebih dahulu pada halaman utama.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _offlineArticles.length,
                  itemBuilder: (context, index) {
                    final article = _offlineArticles[index];

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.08)),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: article.urlToImage.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  article.urlToImage,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.broken_image, color: Colors.grey),
                                  ),
                                ),
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.storage, color: Colors.amber),
                              ),
                        title: Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            article.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        onTap: () => context.push('/detail', extra: {
                          'title': article.title,
                          'content': article.content,
                          'imageUrl': article.urlToImage,
                        }),
                      ),
                    );
                  },
                ),
    );
  }
}