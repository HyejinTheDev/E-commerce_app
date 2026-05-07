import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../bloc/seller_bloc.dart';
import '../../bloc/seller_event.dart';
import '../../data/datasources/seller_remote_datasource.dart';
import 'seller_dashboard_page.dart';
import 'seller_products_page.dart';
import 'seller_orders_page.dart';

/// Main seller shell: hosts bottom nav + 3 tab pages sharing one SellerBloc
class SellerShellPage extends StatefulWidget {
  const SellerShellPage({super.key});

  @override
  State<SellerShellPage> createState() => _SellerShellPageState();
}

class _SellerShellPageState extends State<SellerShellPage> {
  int _currentIndex = 0;

  final _pages = const [
    SellerDashboardPage(),
    SellerProductsPage(),
    SellerOrdersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => SellerBloc(getIt<SellerRemoteDataSource>())
        ..add(const SellerDashboardLoaded())
        ..add(const SellerProductsLoaded())
        ..add(const SellerOrdersLoaded()),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: AppColors.softWhite,
          indicatorColor: AppColors.pearlMist,
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard_rounded),
              label: l.sellerOverview,
            ),
            NavigationDestination(
              icon: const Icon(Icons.inventory_2_outlined),
              selectedIcon: const Icon(Icons.inventory_2_rounded),
              label: l.sellerProductsNav,
            ),
            NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long_rounded),
              label: l.sellerOrdersNav,
            ),
          ],
        ),
      ),
    );
  }
}
