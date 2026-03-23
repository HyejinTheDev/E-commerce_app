import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Feature imports - will be added as features are built
// import '../../features/auth/presentation/pages/login_page.dart';
// import '../../features/customer/home/presentation/pages/home_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth
      GoRoute(path: '/login', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/register', builder: (context, state) => const Placeholder()),

      // Customer
      GoRoute(path: '/home', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/products', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/product/:id', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/cart', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/orders', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/order/:id', builder: (context, state) => const Placeholder()),

      // Seller
      GoRoute(path: '/seller/dashboard', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/seller/products', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/seller/orders', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/seller/shop', builder: (context, state) => const Placeholder()),

      // Delivery
      GoRoute(path: '/delivery/shipments', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/delivery/history', builder: (context, state) => const Placeholder()),

      // Admin
      GoRoute(path: '/admin/dashboard', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/admin/users', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/admin/shops', builder: (context, state) => const Placeholder()),
      GoRoute(path: '/admin/categories', builder: (context, state) => const Placeholder()),
    ],
  );
}
