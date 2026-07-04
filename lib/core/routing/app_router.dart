import 'package:go_router/go_router.dart';
import '../../features/news/presentation/pages/news_page.dart';
import '../../features/news/presentation/pages/news_detail_page.dart';
import '../../features/news/presentation/pages/offline_news_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const NewsPage(),
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          // Mengambil parameter yang dikirim via go_router extra object
          final extra = state.extra as Map<String, String>? ?? {};
          return NewsDetailPage(
            title: extra['title'] ?? 'No Title',
            content: extra['content'] ?? 'No Content',
            imageUrl: extra['imageUrl'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/offline',
        builder: (context, state) => const OfflineNewsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}