import 'package:go_router/go_router.dart';
import '../../features/news/presentation/pages/news_page.dart';
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
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}