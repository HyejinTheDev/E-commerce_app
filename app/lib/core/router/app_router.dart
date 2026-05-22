import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../di/injection.dart';
import '../../features/customer/home/presentation/pages/home_page.dart';
import '../../features/customer/home/bloc/home_bloc.dart';
import '../../features/customer/home/bloc/home_event.dart';
import '../../features/customer/product/presentation/pages/product_detail_page.dart';
import '../../features/customer/product/bloc/product_detail_bloc.dart';
import '../../features/customer/product/bloc/product_detail_event.dart';
import '../../features/customer/categories/presentation/pages/categories_page.dart';
import '../../features/customer/categories/bloc/categories_bloc.dart';
import '../../features/customer/categories/bloc/categories_bloc_types.dart';
import '../../features/customer/cart/presentation/pages/cart_page.dart';
import '../../features/customer/checkout/presentation/pages/checkout_page.dart';
import '../../features/customer/checkout/bloc/checkout_bloc.dart';
import '../../features/customer/search/presentation/pages/search_page.dart';
import '../../features/customer/search/bloc/search_bloc.dart';
import '../../features/customer/search/bloc/search_event.dart';
import '../../features/customer/search/domain/repositories/search_history_repository.dart';
import '../../features/customer/profile/presentation/pages/profile_page.dart';
import '../../features/customer/profile/bloc/profile_bloc.dart';
import '../../features/customer/profile/bloc/profile_bloc_types.dart';
import '../../features/customer/orders/presentation/pages/orders_page.dart';
import '../../features/customer/orders/presentation/pages/order_tracking_page.dart';
import '../../features/customer/orders/bloc/orders_bloc.dart';
import '../../features/customer/orders/bloc/orders_event.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/category/domain/repositories/category_repository.dart';
import '../../features/order/domain/repositories/order_repository.dart';
import '../../features/profile/domain/repositories/user_repository.dart';
import '../widgets/lucent_bottom_nav.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/bloc/auth_state.dart';
// Seller
import '../../features/seller/presentation/pages/seller_shell_page.dart';
// Delivery
import '../../features/delivery/presentation/pages/delivery_shell_page.dart';
// Admin
import '../../features/admin/presentation/admin_shell_page.dart';
// Chat
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';
// Notifications
import '../../features/notifications/presentation/pages/notifications_page.dart';
// Onboarding
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';

/// Bridges AuthBloc stream → GoRouter refreshListenable
class AuthNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String? _role;

  AuthStatus get status => _status;
  String? get role => _role;

  void update(AuthState state) {
    final changed = _status != state.status || _role != state.userRole;
    _status = state.status;
    _role = state.userRole;
    if (changed) notifyListeners();
  }
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  static final authNotifier = AuthNotifier();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authStatus = authNotifier.status;
      final location = state.uri.path;
      final isAuthPage = location == '/login' || location == '/register';
      final isSplashOrOnboarding =
          location == '/splash' || location == '/onboarding';

      // Let splash/onboarding through always
      if (isSplashOrOnboarding) return null;

      // Still loading — don't redirect yet
      if (authStatus == AuthStatus.initial ||
          authStatus == AuthStatus.loading) {
        return null;
      }

      // Not logged in → force to login (unless already there)
      if (authStatus == AuthStatus.unauthenticated ||
          authStatus == AuthStatus.error) {
        return isAuthPage ? null : '/login';
      }

      // Logged in — redirect away from auth pages → always /home
      if (authStatus == AuthStatus.authenticated && isAuthPage) {
        return '/home';
      }

      // Redirect root '/' to '/home'
      if (location == '/') return '/home';

      return null; // no redirect
    },
    routes: [
      // ─── Splash Screen ───
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => _SplashWrapper(),
      ),

      // ─── Onboarding ───
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => OnboardingPage(
          onFinished: () {
            final authStatus = authNotifier.status;
            if (authStatus == AuthStatus.authenticated) {
              _rootNavigatorKey.currentContext?.go('/home');
            } else {
              _rootNavigatorKey.currentContext?.go('/login');
            }
          },
        ),
      ),

      // ─── Customer Shell Route (with bottom nav) ───
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _ScaffoldWithNav(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) => HomeBloc(getIt<ProductRepository>())
                  ..add(const HomeLoaded()),
                child: const HomePage(),
              ),
            ),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) => SearchBloc(
                  getIt<ProductRepository>(),
                  getIt<SearchHistoryRepository>(),
                )
                  ..add(const SearchHistoryLoaded())
                  ..add(const SearchQueryChanged('')),
                child: const SearchPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/cart',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CartPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) => ProfileBloc(getIt<UserRepository>())
                  ..add(const ProfileLoaded()),
                child: const ProfilePage(),
              ),
            ),
          ),
        ],
      ),

      // ─── Seller (self-contained shell with bottom nav) ───
      GoRoute(
        path: '/seller',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SellerShellPage(),
      ),

      // ─── Delivery (self-contained shell with bottom nav) ───
      GoRoute(
        path: '/delivery',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DeliveryShellPage(),
      ),

      // ─── Admin Panel ───
      GoRoute(
        path: '/admin',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminShellPage(),
      ),

      // ─── Chat ───
      GoRoute(
        path: '/chat',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChatListPage(),
      ),
      GoRoute(
        path: '/chat/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ChatDetailPage(
          conversationId: state.pathParameters['id'] ?? '',
        ),
      ),

      // ─── Notifications ───
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsPage(),
      ),

      // ─── Full-screen routes (no bottom nav) ───
      GoRoute(
        path: '/product/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => ProductDetailBloc(getIt<ProductRepository>())
            ..add(ProductDetailLoaded(state.pathParameters['id'] ?? '1')),
          child: ProductDetailPage(
            productId: state.pathParameters['id'],
          ),
        ),
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => CheckoutBloc(getIt<OrderRepository>()),
          child: const CheckoutPage(),
        ),
      ),
      GoRoute(
        path: '/orders',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => OrdersBloc(getIt<OrderRepository>())
            ..add(const OrdersLoaded()),
          child: const OrdersPage(),
        ),
      ),
      GoRoute(
        path: '/orders/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => OrderTrackingPage(
          orderId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/categories',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => CategoriesBloc(getIt<CategoryRepository>())
            ..add(const CategoriesLoaded()),
          child: const CategoriesPage(),
        ),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
    ],
  );
}

/// Main scaffold with bottom navigation (Customer)
class _ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNav({required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: LucentBottomNav(
        currentIndex: _currentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/search');
            case 2:
              context.go('/cart');
            case 3:
              context.go('/profile');
          }
        },
      ),
    );
  }
}

/// Wraps SplashPage and decides where to navigate after splash finishes.
/// Checks SharedPreferences to see if onboarding was already completed.
class _SplashWrapper extends StatefulWidget {
  @override
  State<_SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<_SplashWrapper> {
  bool _hasSeenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
      });
    }
  }

  void _onSplashFinished() {
    if (_hasSeenOnboarding) {
      // Returning user → go to auth flow (router redirect handles login/home)
      final authStatus = AppRouter.authNotifier.status;
      if (authStatus == AuthStatus.authenticated) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    } else {
      // First-time user → show onboarding
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashPage(onFinished: _onSplashFinished);
  }
}
