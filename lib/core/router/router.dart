import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/register_view.dart';
import '../../features/market/view/market_view.dart';
import '../../features/listings/view/product_detail_view.dart';
import '../../features/listings/model/product_model.dart';
import '../../features/chat/view/chat_view.dart';
import '../../features/profile/view/profile_view.dart';

final router = GoRouter(
  initialLocation: '/market',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: '/market',
      builder: (context, state) => const MarketView(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final product = state.extra as ProductModel;
        return ProductDetailView(product: product);
      },
    ),
    GoRoute(
      path: '/chat/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return ChatView(userId: userId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileView(),
    ),
  ],
); 