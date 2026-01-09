import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../features/public/screens/public_site_screen.dart';
import '../../features/admin/screens/admin_login_screen.dart';
import '../../features/admin/screens/admin_panel_screen.dart';
import '../../features/error/screens/not_found_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    errorBuilder: (context, state) => const NotFoundScreen(),
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final isGoingToAdmin = state.matchedLocation.startsWith('/admin');
      final isGoingToLogin = state.matchedLocation == '/login';

      if (isGoingToAdmin && !isAuthenticated) {
        return '/login';
      }

      if (isGoingToLogin && isAuthenticated) {
        return '/admin';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const PublicSiteScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminPanelScreen(),
        routes: [
          GoRoute(
            path: 'general',
            name: 'admin-general',
            builder: (context, state) => const AdminPanelScreen(initialTab: 0),
          ),
          GoRoute(
            path: 'services',
            name: 'admin-services',
            builder: (context, state) => const AdminPanelScreen(initialTab: 1),
          ),
          GoRoute(
            path: 'contact',
            name: 'admin-contact',
            builder: (context, state) => const AdminPanelScreen(initialTab: 2),
          ),
          GoRoute(
            path: 'chatbot',
            name: 'admin-chatbot',
            builder: (context, state) => const AdminPanelScreen(initialTab: 3),
          ),
        ],
      ),
    ],
  );
});
