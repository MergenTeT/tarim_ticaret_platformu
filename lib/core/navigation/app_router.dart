import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/register_view.dart';
import '../../features/splash/view/splash_view.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // Splash ve Auth rotaları
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterView(),
      ),
      
      // Ana uygulama rotaları
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: NavigationBar(
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.list_alt),
                  label: 'İlanlar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_box),
                  label: 'İlan Ekle',
                ),
                NavigationDestination(
                  icon: Icon(Icons.message),
                  label: 'Mesajlar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.trending_up),
                  label: 'Borsa',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Ayarlar',
                ),
              ],
              selectedIndex: _calculateSelectedIndex(state.fullPath ?? '/listings'),
              onDestinationSelected: (index) => _onNavigationItemSelected(index, context),
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/listings',
            builder: (context, state) => const Placeholder(), // ListingsView eklenecek
          ),
          GoRoute(
            path: '/add-listing',
            builder: (context, state) => const Placeholder(), // AddListingView eklenecek
          ),
          GoRoute(
            path: '/messages',
            builder: (context, state) => const Placeholder(), // MessagesView eklenecek
          ),
          GoRoute(
            path: '/market',
            builder: (context, state) => const Placeholder(), // AgriculturalMarketView eklenecek
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const Placeholder(), // SettingsView eklenecek
          ),
        ],
      ),
    ],
  );

  static int _calculateSelectedIndex(String location) {
    if (location.startsWith('/listings')) return 0;
    if (location.startsWith('/add-listing')) return 1;
    if (location.startsWith('/messages')) return 2;
    if (location.startsWith('/market')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  static void _onNavigationItemSelected(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/listings');
        break;
      case 1:
        context.go('/add-listing');
        break;
      case 2:
        context.go('/messages');
        break;
      case 3:
        context.go('/market');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }
} 