import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/register_view.dart';
import '../../features/auth/view/role_selection_view.dart';
import '../../features/market/view/market_view.dart';
import '../../features/messages/view/messages_view.dart';
import '../../features/listings/view/add_listing_view.dart';
import '../../features/stock_market/view/stock_market_view.dart';
import '../../features/settings/view/settings_view.dart';
import '../../features/splash/view/splash_view.dart';

final class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionView(),
      ),
      GoRoute(
        path: '/market',
        builder: (context, state) => const MarketView(),
      ),
      GoRoute(
        path: '/add-listing',
        builder: (context, state) => const AddListingView(),
      ),
      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessagesView(),
      ),
      GoRoute(
        path: '/stock-market',
        builder: (context, state) => const StockMarketView(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsView(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Sayfa bulunamadı: ${state.uri}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    ),
  );
} 