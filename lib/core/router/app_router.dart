import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_exposicao/core/models/theme_config.dart';
import 'package:site_exposicao/core/providers/config_provider.dart';
import '../providers/auth_provider.dart';
import '../../features/public/screens/public_site_screen.dart';
import '../../features/admin/screens/admin_login_screen.dart';
import '../../features/admin/screens/admin_panel_screen.dart';
import '../../features/error/screens/not_found_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final appConfig = ref.watch(appConfigProvider);
  final companyName = appConfig.general.companyName;
  final appTheme = ThemeConfig.getPreset(appConfig.theme);

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
        builder: (context, state) => Title(
          title: companyName,
          color: appTheme.primaryColor,
          child: const PublicSiteScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => Title(
          title: 'Admin Login',
          color: appTheme.primaryColor,
          child: const AdminLoginScreen(),
        ),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => Title(
          title: 'Admin Panel',
          color: appTheme.primaryColor,
          child: const AdminPanelScreen(),
        ),
        routes: [
          GoRoute(
            path: 'general',
            name: 'admin-general',
            builder: (context, state) => Title(
              title: 'Admin Panel - General',
              color: appTheme.primaryColor,
              child: const AdminPanelScreen(initialTab: 0),
            ),
          ),
        ],
      ),
    ],
  );
});
