import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/di/injection.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<NewsBloc>()..add(LoadNewsEvent()),
      child: const NewsView(),
    );
  }
}

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark 
          ? const Color(0xFF0A0F1D) 
          : Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: theme.colorScheme.surface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EnvConfig.appName, //[cite: 1]
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            Text(
              'Portal Berita Pintar • [${EnvConfig.environment}]', //[cite: 1]
              style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_off_rounded, color: Colors.amber),
            tooltip: 'Mode Offline',
            onPressed: () => context.push('/offline'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // Perbaikan padding right
            child: IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              tooltip: 'Profil Developer',
              onPressed: () => context.push('/profile'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          // 1. STATUS LOADING
          if (state is NewsLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 3),
                  SizedBox(height: 16),
                  Text('Menyelaraskan Berita Terkini...', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }

          // 2. STATUS ERROR / INTERNET MATI[cite: 1, 2]
          if (state is NewsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 72, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    const Text(
                      'Koneksi Internet Terputus',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gagal mengambil data dari API terpusat. Tenang, Anda dapat membaca berita terakhir di mode offline.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/offline'),
                      icon: const Icon(Icons.storage_rounded),
                      label: const Text('Buka Berita Offline (Isar Cache)'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. STATUS BERHASIL MEMUAT DATA (Success State)[cite: 1, 2]
          if (state is NewsSuccess) {
            final articles = state.articles;

            if (articles.isEmpty) {
              return const Center(
                child: Text('Tidak ada berita hari ini.'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(LoadNewsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];

                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.08)), // Perbaikan withValues
                    ),
                    margin: const EdgeInsets.only(bottom: 16), // Perbaikan padding bottom
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.push('/detail', extra: {
                        'title': article.title,
                        'content': article.content,
                        'imageUrl': article.urlToImage,
                      }),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article.urlToImage.isNotEmpty)
                            Image.network(
                              article.urlToImage,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 180,
                                color: Colors.grey.shade200,
                                child: const Center(child: Icon(Icons.broken_image_rounded, size: 48, color: Colors.grey)),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary.withValues(alpha: 0.1), // Perbaikan withValues
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'TERKINI',
                                        style: TextStyle(
                                          fontSize: 10, 
                                          fontWeight: FontWeight.bold, 
                                          color: theme.colorScheme.primary
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Sorted Z-A (NPM 9)', 
                                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  article.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold, 
                                    height: 1.3,
                                    letterSpacing: -0.2
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  article.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13, 
                                    color: theme.brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    height: 1.4
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}