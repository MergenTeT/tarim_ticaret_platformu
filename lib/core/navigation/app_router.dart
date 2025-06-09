import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proje_app/features/auth/view/login_view.dart';
import 'package:proje_app/features/auth/view/register_view.dart';
import 'package:proje_app/features/auth/view/role_selection_view.dart';
import 'package:proje_app/features/market/view/market_view.dart';
import 'package:proje_app/features/messages/view/messages_view.dart';
import 'package:proje_app/features/profile/view/profile_view.dart';
import 'package:proje_app/features/listings/view/listings_view.dart';
import 'package:proje_app/features/splash/view/splash_view.dart';

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
        path: '/listings',
        builder: (context, state) => const ListingsView(),
      ),
      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessagesView(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileView(),
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